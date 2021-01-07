Include (%occInclude, %msql, %SYS.DBSRV)

/// This class is a direct copy of HSTA.Core.TransientTable, and made available for Health Connect.
/// This class provides a ResultSet-style iterator object that also allows to programmatically set
/// column names, set data into new result rows, and to iterate through the result set. It also
/// provides the ability to hold extremely large result sets due to its use of %SQL.IResultSet,
/// which holds its data in a process-private global.  The following methods are added in this
/// extending of %SQL.IResultSet:<br>
/// %AddColumn(columnName, dataType) - this adds a new column definition. The dataType is in SQL format - VARCHAR(200) for example;<br>
/// %Set() - set a column by column name<br>
/// %SetData() - set a column by column number<br>
/// %NewRow() - advance the iterator to beyond the last row, initialize the %Data array<br>
/// %SaveRow() - save the current row, replacing the existing row, if any, entirely.<br>
Class HS.Util.TransientTable Extends %SQL.IResultSet
{

Property %storageOffset As %Integer [ Private ];

Property %currentRow As %Integer [ Private ];

/// %Data is a multidimensional property of column values for the current row. It is subscripted by column
/// number.
Property %Data As %String(MAXLEN = "") [ MultiDimensional, Private ];

Property %hasStreams As %Integer [ InitialExpression = 0, Private ];

Property %streams As %String [ Internal, MultiDimensional ];

Property %streamColumns As %String(MAXLEN = "") [ Internal ];

Property %lastRow As %Integer [ Private ];

Property %ToStringMethods [ MultiDimensional, Private ];

/// %RowCount for a static result set is always the number of rows in the static set.
Method %ROWCOUNTGet() As %Integer [ CodeMode = expression ]
{
..%lastRow
}

Method %Save() As %Status
{
	kill $$$tFile(..%storageOffset,0)
	merge $$$tFile(..%storageOffset,0,"m") = ..%Metadata
	set $$$tFile(..%storageOffset,0,"p") = ..%Parameters
	set $$$tFile(..%storageOffset,0,"o") = ..%Objects
	set $$$tFile(..%storageOffset,0,"x") = ..%ExtendedMetadata
	quit $$$OK
}

Method %SaveTo(gbl As %String, offset As %String = "") As %String
{
	d ..%Save()
	
	if (offset = "") {
		set offset = $i(@gbl)
	}
	k @gbl@(offset)
	m @gbl@(offset) = $$$tFile(..%storageOffset)
	
	Quit offset
}

ClassMethod %RestoreFrom(gbl As %String, offset As %String) As TransientTable
{
	set storageOffset = $Increment($$$tFileRoot)
	k $$$tFile(storageOffset)
	
	m $$$tFile(storageOffset) = @gbl@(offset)
	
	set rs = ..%New(,,storageOffset)
	
	d rs.%SetIterator(0)
	
	Quit rs
}

Method %OnNew(initvalue As %Library.RawString = "", pRuntimeMode As %Integer = {$zu(115,5)}, storageOffset As %Integer = 0) As %Status [ Private, ProcedureBlock = 1, PublicList = SQLCODE, ServerOnly = 1 ]
{
	set ..%SelectMode = pRuntimeMode
	if (storageOffset) && ($Data($$$tFile(storageOffset))) {
		set ..%storageOffset = storageOffset
		merge ..%Metadata = $$$tFile(storageOffset,0,"m")
		/*
		merge ..%Objects = $$$tFile(storageOffset,0,"o")
		merge ..%Parameters = $$$tFile(storageOffset,0,"p")
		merge ..%ExtendedMetadata = $$$tFile(storageOffset,0,"x")
		*/
		// MAB: merge |-> set becuase of Object Dispatch error
		set ..%Objects = $g($$$tFile(storageOffset,0,"o"))
		set ..%Parameters = $g($$$tFile(storageOffset,0,"p"))
		set ..%ExtendedMetadata = $g($$$tFile(storageOffset,0,"x"))
		set ..%lastRow = $o($$$tFile(storageOffset,""),-1)
		do ..refreshMetadata()
		
		set ..%ResultColumnCount = ..%GetMetadata().columnCount
	} else {
			#; allocate storage
		new SQLCODE
		set ..%storageOffset = $Increment($$$tFileRoot)
		kill $$$tFile(..%storageOffset)
		set $$$tFile(..%storageOffset) = 0
			#; Take the snapshot
		if $isobject(initvalue) {
				#; Grab the result set data and metadata from the donor result set
				Try {
					set lastRow = 0, status = initvalue.%CreateSnapshot(..%storageOffset,.lastRow,.tRuntimeMode,$this), ..%lastRow = lastRow, ..%SelectMode = tRuntimeMode,..%Objects = initvalue.%Objects
				} Catch ex {
					d ex.StackAsArray(.stack)
					// m ^dbg1($i(^dbg1)) = stack
				}
				#; This class only recognizes a single node of metadata
			merge tMetadata = initvalue.%Metadata
			if ($d(tMetadata) = 0) {
				Try {
					set tMetadata = initvalue.%Metadata
				} Catch ex {
				}
			}
			//m ^dbg1=tMetadata
			// s ^dbg1(1) = initvalue
			if $Get(tMetadata) = "" { set tMetadata = tMetadata($Order(tMetadata(""))) }
			set ..%Metadata = tMetadata
				#; The result set will only return an error status if something went wrong. Otherwise we can assume that all rows are in the snapshot
			if $$$ISOK(status) { set ..%ResultColumnCount = $List(..%Metadata,1) } else { set ..%SQLCODE = initvalue.%SQLCODE, ..%Message = "error encountered while taking result set snapshot" }
			if (initvalue.%IsA(..%ClassName(1))) {
				m ..%ToStringMethods = initvalue.%ToStringMethods
			}
		}
		elseif initvalue {
				#; must be a straight xDBC statement - probably SELECT or a query procedure
			new %qacn
			set %qacn = initvalue
			if $G($$$SPName) '= "" {
					#; query stored procedure
				kill %qHandle Merge %qHandle=$$$SPHandle Set %sqlcontext=$$$SPContext If '$isobject(%sqlcontext) { set ..%SQLCODE = -430, ..%Message = "Context object invalid" Goto Error }
				set ..%ResultColumnCount = $Get(%qsc(initvalue,13))
					#; We'll take runtime mode from the parameter list
				set ..%SelectMode = pRuntimeMode
				set sc=$classmethod($$$SPClassName,$$$SPName_"Fetch",.%qHandle,.row)
				while ($$$ISOK(sc))&&(row'="") {
					set rowPtr = $increment($$$tFile(..%storageOffset)) 
					for column=1:1:..%ResultColumnCount Set:$listdata(row,column) $$$tFile(..%storageOffset,rowPtr,column) = $list(row,column)
					set sc=$classmethod($$$SPClassName,$$$SPName_"Fetch",.%qHandle,.row)
				}
				if $$$ISERR(sc) {  set ..%SQLCODE = -400, ..%Message = "error encountered while taking result set snapshot" }
				set ..%lastRow = $$$tFile(..%storageOffset)
				set qrc = $classmethod($$$SPClassName,$$$SPName_"Close",.%qHandle)
				kill $$$LastPce, $$$FetchStatus,%sqlcontext,$$$SPHandle
			}
			else {
					#; %SelectMode should really be the SELECTMODE of the donor select statement but I don't know how to get it.
					#; Let's assume it is ODBC
				set ..%SelectMode = 1
					#; probably a select statement
					#; cq oref should have been defined in Prepare^%SYS.SQLSRV earlier
				if $G($$$FetchStatus) {
					do %qsc(%qacn,1).%OnClose() set qrc=SQLCODE  // %OnClose implicitly sets SQLCODE
					if qrc set ..%SQLCODE = -qrc, ..%Message = "error closing cursor from previous fetch in while taking result set snapshot"
					kill $$$FetchStatus
				}
				set qrc=%qsc(%qacn,31).%Open()	// This Opens the SQL Query
				if qrc set ..%SQLCODE = -qrc, ..%Message = "error opening cached query object to take result set snapshot"
				set qrc = %qsc(%qacn,31).FetchRows(..%storageOffset)
					#; A normal return is qrc = 100 - all other values, including 0, indicate that something is wrong. Of course, 0 should never be returned since we are asking for all rows
				if qrc = 100 { set ..%ResultColumnCount = $Get(%qsc(initvalue,13)), ..%lastRow = $$$tFile(..%storageOffset) } else { set ..%SQLCODE = -qrc, ..%Message = "error encountered while taking result set snapshot" }
				do %qsc(%qacn,31).%OnClose() set qrc=SQLCODE
				kill $$$FetchStatus
			}
		}
		set ..%hasStreams = $Find(..%streamColumns,$Char(1))
	}
		#; always return ok - we want the object. The object state will reflect any status information that the caller may need
	quit $$$OK
Error	set $ZTRAP= ""
	quit $$$OK
}

Method %OnClose() As %Status [ Private ]
{
	if ..%storageOffset { kill $$$tFile(..%storageOffset) }
	quit $$$OK
}

Method %SendRows() As %Integer
{
	set qrc = 0, from = $$$ReadNext, nrows = $$$ReadNext, to = from + nrows - 1
		#; get last row request
	if from = 0 { set from = ..%lastRow, to = from set:'to qrc = 100 }
	elseif ..%lastRow < to { set to = ..%lastRow, qrc = 100 }
	set a = to - from + 1 set:a<0 a = 0
	set b = from set:qrc=100 b = ..%lastRow
	set b = $Select(from'>..%lastRow:from,1:..%lastRow)
	$$$WriteData(b)
	if to > 0 {
		#; number of rows processed
		$$$WriteData(a)
		for row = from:1:to {
			set tRow = $Get($$$tFile(..%storageOffset,row)), tPtr = 0
			for tColumn=1:1 { quit:'$Listnext(tRow,tPtr,tValue)  $$$WriteData(tValue) }
			if tColumn '> ..%ResultColumnCount {
				for tColumnOv = tColumn:1:..%ResultColumnCount {
					$$$WriteData($Get($$$tFile(..%storageOffset,row,tColumnOv)))
				}
			}
		}
	}
	else { $$$WriteData(0) }
	quit qrc
}

/// Fetch and send a series of rows for the ODBC/JDBC server. For internal use only.
Method %SendODBC() As %Library.Integer
{
	new %row
		#; process any orphans
	if ..%NextColumn {	// Should only be TRUE if %protocol<51 or there are stream columns
		for ptr=..%NextColumn:1:..%ResultColumnCount {
			if '($Ascii(..%streamColumns,ptr)) { set tVal = i%%Data(ptr) } 
			else { set tVal = $Get(..%streams(..%currentRow,ptr)) if $Isobject(tVal) { set:$Get(%qacn) %qobjhandle(%qacn,tVal) = tVal set tVal = tVal _ "" } }
			goto:$zobjexport(tVal,7) Done
		}
	}
	set ..%NextColumn = 0
Fetch2
	if ..%Next(.sc) {
		if %protocol>50,'..%hasStreams {
				// Can't send $name(i%%Data) to $zobjexport, so move it into a public array() and then send the row
			merge %row=i%%Data
			quit:$zobjexport($name(%row),56) 0	// Buffer full, SQLCODE=0
			goto Fetch2	// Get another row to put in this buffer
		}
		for ptr=1:1:..%ResultColumnCount {
			set tVal = i%%Data(ptr)
			if ($Ascii(..%streamColumns,ptr)) && ($Isobject(tVal)) { set:$Get(%qacn) %qobjhandle(%qacn,tVal) = tVal set tVal = tVal _ "" }
			if $zobjexport(tVal,7) Goto Done
		}
		Goto Fetch2
	}
	else {	// ..%Next returned FALSE
		set SQLCODE=100
		if $d(sc)#2,('sc) { 
			if SQLCODE=0||(SQLCODE=100) { set SQLCODE=-400,%msg=$$GetErrorText^%apiOBJ(sc) }
		}
		QUIT SQLCODE
	}
Done set ..%NextColumn=ptr Quit 0
}

/// Advance the result set cursor to the next row. Returns 0 if the cursor is at the end of the 
/// result set.
/// The global structure consists of a base $list with individual nodes for columns. The base $list() can contain zero or more column
/// values. Additional column values are stored in the global subscripted by column number and equal to the column value.
Method %Next(ByRef sc As %Library.Status = {$$$OK}) As %Library.Integer
{
	set ..%currentRow = ..%currentRow + 1
	if ..%currentRow > ..%lastRow Quit 0
	set tRowPtr = ..%currentRow
	set tRow = $Get($$$tFile(..%storageOffset,tRowPtr)), tPtr = 0
	for tColumn=1:1 { quit:'$Listnext(tRow,tPtr,tValue)  set i%%Data(tColumn) = tValue }
	if tColumn '> ..%ResultColumnCount {
		for tColumnOv = tColumn:1:..%ResultColumnCount {
			set i%%Data(tColumnOv) = $Get($$$tFile(..%storageOffset,tRowPtr,tColumnOv))
		}
	}
	if ..%hasStreams {
		set tPtr = ..%hasStreams
		do {
			set tColumn = tPtr - 1
			if $Data(..%streams(tRowPtr,tColumn)) { set ..%Data(tColumn) = ..%streams(tRowPtr,tColumn) }
			set tPtr = $Find(..%streamColumns,$Char(1),tPtr)
		} while tPtr
	}
	quit 1
}

/// Returns the value of the column with the name <var>name</var> in the current row of the result set.
/// <p>If <var>name</var> is not a valid column name, this method returns an empty string.
Method %Get(colname As %String = "") As %Library.String
{
	set tRSMD = ..%GetMetaData()
	set tCOLUMNNAME = $$$ucase(colname)
	if $Data(tRSMD.columnIndex(tCOLUMNNAME)) { set rReturnValue = $Get(..%Data($List(tRSMD.columnIndex(tCOLUMNNAME),1))) }
	else { $$$ThrowPropertyDoesNotExistError(colname) }
	quit rReturnValue
}

/// Returns the value of column <var>colnbr</var> in the current row of the result set.
Method %GetData(colnbr As %Integer = 0) As %Library.String
{
	if colnbr '> ..%ResultColumnCount { set rReturnValue = $Get(..%Data(colnbr)) }
	else { $$$ThrowPropertyDoesNotExistError("Column #: "_colnbr) }
	quit rReturnValue
}

/// Set the column whose name is <var>colname</var> to <var>value</var>. 
Method %Set(colname As %String = "", value As %Library.RawString = "") As %Integer
{
	set tRSMD = ..%GetMetaData()
	set tCOLUMNNAME = $$$ucase(colname)
	if $Data(tRSMD.columnIndex(tCOLUMNNAME)) {
		set colnbr = $List(tRSMD.columnIndex(tCOLUMNNAME),1)
		set ..%Data(colnbr) = value
	}
	else { $$$ThrowPropertyDoesNotExistError(colname) }
	quit colnbr
}

Method %SetData(colnbr As %Integer = 0, value As %Library.RawString = "") As %Integer
{
	if colnbr '> ..%ResultColumnCount { set ..%Data(colnbr) = value }
	else { $$$ThrowPropertyDoesNotExistError("Column #: "_colnbr) }
	quit colnbr
}

Method %AddResultSet(rs As %IResultSet) As %Status
{
	#dim sc As %Status = $$$OK
	#dim i, n As %Integer
	set n = ..%ResultColumnCount
	While (rs.%Next()) {
		d ..%NewRow()
		for i = 1:1:n {
			d ..%SetData(i, rs.%GetData(i))
		}
		set sc = ..%SaveRow()
		Quit:$$$ISERR(sc)
	}
	
	Quit sc
}

///  Dispatch <property>Get calls when the <property> does not exist
///  in the class descriptor. This implementation normalizes case and
///  attempts to dispatch to the correct property, effectively making properties
///  corresponding to column values case insensitive. Also, SQLCODE, ROWID and ROWCOUNT
///  are case-normalized and dispatched to the correct property.
Method %DispatchGetProperty(propertyName As %String(MAXLEN=255)) [ Internal ]
{
	set tRSMD = ..%GetMetadata(), tPROPERTY = $$$ucase(propertyName)
	if $Data(tRSMD.columnIndex(tPROPERTY),cdef) { quit ..%GetData($List(cdef,1)) }
	elseif (tPROPERTY = "SQLCODE") || (tPROPERTY = "%SQLCODE") { quit ..%SQLCODE }
	elseif (tPROPERTY = "%ROWID") { quit ..%ROWID }
	elseif (tPROPERTY = "%ROWCOUNT") { quit ..%ROWCOUNT }
	else { $$$ThrowPropertyDoesNotExistError(propertyName) }
	quit ""
}

///  Property dispatch method to catch references to 
///  virtual properties.<br>
///  This should not be called directly.<br>
Method %DispatchSetProperty(propertyName As %String, value As %String) [ Final, Internal ]
{
	set tRSMD = ..%GetMetadata(), tPROPERTY = $$$ucase(propertyName)
	if $Data(tRSMD.columnIndex(tPROPERTY),cdef) { quit ..%SetData($List(cdef,1),value) }
	else { $$$ThrowPropertyDoesNotExistError(propertyName) }
}

Method %AddColumn(colname As %String = "", dataType As %String = "", nullable As %Integer = 1, position As %Integer = "") As %Integer
{
	#dim rsmd As %ResultSet.MetaData
	#dim c, i As %Integer
	#dim title As %String
	try {
		set rsmd = ..%GetMetadata()
		set column = ##class(%SQL.StatementColumn).%New()
		do parseFormal^%occName("","","x:"_dataType,.formalArgs)
		merge colParms = formalArgs(1,2)
		set cacheType = $$NormalizeClassname^%occName(colParms)
		do GetODBCColInfo^%ourODBC(cacheType,.colParms,.colODBCTypeName,.colODBCType,.maxLen,.precision,.scale)
		set column.colName = colname
		set column.isNullable = nullable
		set column.ODBCType = colODBCType
		set column.precision = precision
		set column.scale = scale
		do column.typeClassSetObjectId(cacheType)
		set column.clientType = $$$comClassKeyGet(cacheType,$$$cCLASSclientdatatypeenum)
		if (position = "") {
			do rsmd.columns.Insert(column)
			set position = rsmd.columns.Count()
			set ..%ResultColumnCount = rsmd.columns.Count()
		} else {
			do rsmd.columns.InsertAt(column,position)
			set ..%ResultColumnCount = rsmd.columns.Count()
			set c = ..%currentRow
			d ..%SetIterator()
			set title = $o(rsmd.columnIndex(""))
			While (title '= "") {
				set i = $lg(rsmd.columnIndex(title))
				if (i >= position) {
					set rsmd.columnIndex($$$ucase(title)) = $lb(i+1,title)
				}
				set title = $o(rsmd.columnIndex(title))
			}
			While (..%Next()) {
				set i = $o(..%Data(""),-1)
				While ((i >= position) && (i '= "")) {
					m ..%Data(i+1) = ..%Data(i)
					set i = $o(..%Data(i),-1)
				}
				set ..%Data(position) = ""
				d ..%SaveRow()
			}
			d ..%SetIterator(c)
		}
		set rsmd.columnIndex($$$ucase(colname)) = $ListBuild(position,colname)
		do ..refreshMetadata()
	} catch exception {
		break
	}
	return ..%ResultColumnCount
}

Method %AddColumnByMD(column As %SQL.StatementColumn = "") As %Integer
{
	try {
		
		set rsmd = ..%GetMetadata()
		
		set colname = column.colName
		do rsmd.columns.Insert(column)
		set ..%ResultColumnCount = rsmd.columns.Count()
		set rsmd.columnIndex($$$ucase(colname)) = $ListBuild(..%ResultColumnCount,colname)
		do ..refreshMetadata()

	} catch exception {
		break
	}
	return ..%ResultColumnCount
}

Method %AddColumnByOid(oid As %List) As %Integer
{
	set ret=""
	try {
		
		set column = ##class(%SQL.StatementColumn).%Open(oid)
		set ret=..%AddColumnByMD(column)
	} catch exception {
		break
	}
	return ret
}

/// After adding a new column, it will be necessary to rebuild the xDBC metadata properties - only %Metadata is affected and then only the columns section and perhaps the 
/// extended metadata for objects. We don't support adding new parameters. 
Method refreshMetadata()
{
	set metadataPtr = 0, metadata(0) = "", pObjects = ""
	set rsmd = ..%GetMetadata()
	s ..%rsmd = ""
		#; Column count is first
	set columnCount = rsmd.columns.Count()
	set streams = ""
	set metadata(metadataPtr) = $listbuild(columnCount)
	for ptr = 1:1:columnCount {
		set column = rsmd.columns.GetAt(ptr)
		if (column.ODBCType = $$$ODBCTYPElongvarchar) || (column.ODBCType = $$$ODBCTYPElongvarbinary) {
			set streams = streams _ $Char(1)
		} else {
			set streams = streams _ $Char(0)
		}
		set metadata(metadataPtr) = metadata(metadataPtr)_column.getColInfo()
	}
	set ..%streamColumns = streams
	if $Length(streams,$Char(1)) {
		set ..%hasStreams = 1
	}
	kill:metadata(metadataPtr)="" metadata(metadataPtr)
	kill ..%Metadata
	merge ..%Metadata = metadata
}

Method %SetIterator(pRowNumber As %Library.Integer = 0) As %Library.Integer
{
	if pRowNumber '> ..%lastRow { set ..%currentRow = pRowNumber } else { set ..%currentRow = ..%lastRow }
	quit ..%currentRow
}

Method %NewRow() As %Library.Integer
{
	set ..%lastRow = ..%lastRow + 1
	set ..%currentRow = ..%lastRow
	kill ..%Data
	set ..%NextColumn = ""
	return ..%lastRow
}

Method %SaveRow() As %Status
{
	kill $$$tFile(..%storageOffset,..%currentRow)
	set serialRow = ""
	for ptr = 1:1:..%ResultColumnCount {
		set serialRow = serialRow _ $lb($Get(..%Data(ptr)))
	}
	set $$$tFile(..%storageOffset,..%currentRow) = serialRow
	return $$$OK
}

///  %Print()
///  <p>Write the current row to the current device. An optional column delimiter can be
///  specified. No formatting is applied other than writing <var>pDelimiter</var> between
///  column values. This can be useful for exporting result set data to tab delimited files.</p>
///  <p>For example:</p><p></p>
///  <example>
///  set sql = "select name,home_street,home_city,home_state,home_zip from sample.person"
///  set rset = ##class(%ResultSet.SQL).%Prepare(.sql,.err,"")
///  if '$Isobject(err) {
///  	set file="c:\temp\names.asv"
///  	open file:"WNS"
///  	use file while rset.%Next() { do rset.%Print($char(9)) } 
///  	close file
///  }
///  </example>
///  <p><p>
///  Example data:
///  <table>
///  <tr><td>Cornell,Ezra M.</td><td>340 Franklin Court</td><td>Sarasota</td><td>NY</td><td>12866</td></tr>
///  <tr><td>Huff,Stephen A.</td><td>548 Washington Blvd</td><td>Brownfield Center</td><td>MD</td><td>53436</td></tr>
///  <tr><td>Sands,Jeep Q.</td><td>7298 Washington Drive</td><td>Xavier</td><td>WY</td><td>23685</td></tr>
///  </table>
Method %Print(pDelimiter As %String = " ") As %Status
{
	set tRSMD = ..%GetMetadata()
	set tColumns = tRSMD.columns.Count()
	if tColumns {
		set tValue = ..%GetData(1)
		set tVlaue = ..%ColumnValueToString(tValue, 1)
		if (tValue [ pDelimiter) || (tValue [ $Char(10)) { set tValue = $zu(144,1,tValue) }
		write tValue
		for tPtr = 2:1:tColumns {
			set tValue = ..%GetData(tPtr)
			set tValue = ..%ColumnValueToString(tValue, tPtr)
			if (tValue [ pDelimiter) || (tValue [ $Char(10)) { set tValue = $zu(144,1,tValue) }
			write pDelimiter,tValue
		}
		write !
	}
	quit $$$OK
}

Method %ColumnValueToString(pValue As %String, pColumn As %Integer) As %String
{
	set call = $g(..%ToStringMethods(pColumn))
	if (call '= "") {
		set class = $p(call, ":", 1)
		set method = $p(call, ":", 2)
		set pValue = $classmethod(class,method,pValue)
	}
	
	Quit pValue
}

/// Registers a custom method to convert internal value to string for contents of the given column 
/// <p> The call argument should be in the format: "class:method"
Method %RegsiterToStringMethod(pColumn As %Integer, call As %String)
{
	set ..%ToStringMethods(pColumn) = call
}

Method %Sort(by...) As TransientTable
{
	#dim i, n, row, NR, d As %Integer
	#dim c, v As %String
	#dim columns
	#dim ridx, rdata, dir
	#dim sc As %Status = $$$OK

	k ^||ISC.HSTA.TTable
	set n = $g(by,0)
	if (n = 0) {
		Throw ##class(%Exception.General).%New("InvalidArg",5001,,"Sort column(s) are required fro %Sort")
	}
	
	d ..%SetIterator()
	
	k columns
	if ((n = 1) && ($lv($g(by(1)))) && ($g(by(1)) '= "")) {
		set n = $ll(by(1))
		for i = 1:1:n {
			set c = $li(by(1))
			set c = ..%ColumnIndex(c, .d)
			set columns(i) = c
			set dir(i) = d
		}
	} else {
		set n = by
		for i = 1:1:n {
			set c = by(i)
			set c = ..%ColumnIndex(c, .d)
			set columns(i) = c
			set dir(i) = d
		}
	}
	set columns = n
	set dir = n
	
	set row = 0
	do ..%SetIterator(0)

	While(..%Next()) {
		set row = $i(row)

		k ridx
		m ridx(row) = ..%Data
		for i = n:-1:1 {
			set v = ..%GetData(columns(i))
			if (v = "") {
				set v = " "
			}
			k rdata
			m rdata(v) = ridx
			k ridx
			m ridx = rdata
		}
		
		m ^||ISC.HSTA.TTable = ridx
	}
	set NR = row

	set table = ..%New($this)
	if (NR < 1) {
		Quit table
	}
	
	for i = 1:1:(n+1) {
		set ridx(i) = ""
	}
	set ridx = n + 1
	set dir(n + 1) = 1
	k rdata
	
	While(..%nextNode("^||ISC.HSTA.TTable",.ridx,.dir,.rdata)) {
		set row = table.%NewRow()
		// w row, !
		// zw rdata
		m table.%Data = rdata
		set sc = table.%SaveRow()
		Throw:$$$ISERR(sc) ##class(%Exception.StatusException).CreateFromStatus(sc)
	}
	
	d table.%SetIterator()
	Quit table
}

Method %ColumnIndex(columnName As %String, Output dir As %Integer) As %Integer
{
	#dim c As %Integer
	#dim tRSMD As %SQL.StatementMetadata
	
	set tRSMD = ..%GetMetaData()

	set dir = 1
	if ('$isvalidnum(columnName)) {
		set c = $$$ucase(columnName)
		if ($e(c) = "-") {
			set c = $e(c,2,*)
			set dir = -1
		}
		if ($Data(tRSMD.columnIndex(c))) { 
			set c = $List(tRSMD.columnIndex(c),1) 
		} else { 
			$$$ThrowPropertyDoesNotExistError(columnName) 
		}
	} else {
		set c = columnName
		if (c < 0) {
			set c = -c
			set dir = -1
		}
	}
	
	Quit c
}

ClassMethod %nextNode(a As %String, ByRef idx, ByRef dir, Output row) As %Boolean
{
	#dim var, k, index As %String
	#dim i, n As %Integer
	#dim hasNext As %Boolean
	
	k row
	set hasNext = 1
	set n = idx
	set index = ""
	for i = 1:1:(n-1) {
		if (idx(i) = "") {
			if (i = 1) {
				set var = a
			} else {
				set var = a_"("_index_")"
			}
			
			set idx(i) = $o(@var@(idx(i)),dir(i))
			if (idx(i) = "") {
				set hasNext = 0
				Quit
			}
		}
		if (i > 1) {
			set index = index_","
		}
		if ($isvalidnum(idx(i))) {
			set index = index_idx(i)
		} else {
			set index = index_""""_idx(i)_""""
		}
	}
	if ('hasNext) {
		Quit hasNext
	}
	if (n = 1) {
		set var = a
	} else {
		set var = a_"("_index_")"
	}
	set k = $o(@var@(idx(n)),dir(n))
	set idx(n) = k
	if (k '= "") {
		m row = @var@(k)
		Quit 1
	}
	if (n = 1) {
		Quit 0
	}
	
	set idx = n - 1
	set hasNext = ..%nextNode(a,.idx,.dir)
	set idx = n
	if (hasNext) {
		set hasNext = ..%nextNode(a,.idx,.dir,.row)
	} 
	
	Quit hasNext
}

}

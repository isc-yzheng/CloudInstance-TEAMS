Include HSMOD.CSVTable

/// <p>Utilities for CSV tables. </p>
/// <p><strong>
/// This class is for internal InterSystems use only. This class is subject to change in future versions of HealthShare.
/// </strong></p>
Class HSMOD.CSVTable.Utils [ Abstract, Final ]
{

/// <p>Internal helper method for other classmethods in this class. Returns file column information as an array. 
/// </p><p>
/// For simple cases, the array will have one node for each property, with sub-nodes for name, type, description, and property parameters. 
/// In the case of a property that is actually a reference to another class, the array will have nodes for the unique identifiers in the 
/// target class, with the names set up as the current property concatenated with the target properties, with a period between. So, for 
/// example, if the current class has a field called OtherRefObject of type "foo.bar.RandomCode", which has a primary key 
/// consisting of the properties "CodeSystem" and "Code", then the array for the current class will include a node for "OtherRefObject.CodeSystem"
/// and another for "OtherRefObject.Code", and that's how we expect the import/export columns to look, as ordered by an incrementing subscript. 
/// </p>
ClassMethod LookUpColumnInformation(pTargetClass As %String, ByRef pPropertyInfo, pIncludeComputedFields As %Boolean = 0, pIncludeNonComputedFields As %Boolean = 1) As %Status [ Internal ]
{
	set tCursorIsOpen = 0
	
	try 
	{
		kill pPropertyInfo
		
		&sql(declare PropertyInfo cursor for 
			select Name, Description, RuntimeType, SequenceNumber, Parameters, Required, SqlColumnNumber
			into :tName, :tDesc, :tType, :tSeqNum, :tParams, :tRequired, :tColNumber
			from %Dictionary.CompiledProperty 
			where parent = :pTargetClass
			and Internal = 0
			and ((SqlComputed = 0 and :pIncludeNonComputedFields = 1)
				or (SqlComputed = 1 and :pIncludeComputedFields = 1))
			order by SqlColumnNumber)
			
		&sql(open PropertyInfo)
	
		if SQLCODE
		{
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error"))
		}
		
		set tCursorIsOpen = 1
		
		&sql(fetch PropertyInfo)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while SQLCODE = 0
		{
			if tColNumber = "" $$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error: table does not specify column numbers"))
			
			kill tNewItem
			set tNewItem("Name") = tName
			set tNewItem("Description") = $zstrip($case(tDesc,"":"(no description)",:tDesc),"<>W") 
			set tNewItem("Type") = tType
			set tNewItem("Required") = tRequired
			
			set tParamCount = $listlength(tParams)
			for tParamLoop = 1:1:tParamCount
			{
				set tParamPair = $listget(tParams,tParamLoop)
				set tNewItem("Parameters",$listget(tParamPair,1)) = $listget(tParamPair,2)
			}
							
			//merge tWorkingInfo($i(tWorkingInfo)) = tNewItem
			if ($data(pPropertyInfo(tColNumber)) '= 0) $$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error: conflicting column numbers"))
			
			if ($classmethod(tType, "%Extends", "%Library.DataType") = 0)
			{
				// it's not a literal. is it a data type? that's the only other case we support
				
				set tTestClassObj = ##class(%Dictionary.CompiledClass).%OpenId(tType)
				if '$isobject(tTestClassObj) $$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error; property type " _ tType _ " not recognized"))
				
				if tTestClassObj.ClassType = "datatype"
				{	
					// is there a value list? 
					set tTestValListObj = ##class(%Dictionary.CompiledParameter).IDKEYOpen(tType, "VALUELIST")
					if $ISOBJECT(tTestValListObj)
					{
						set tTestValList = tTestValListObj.Default
						// assume it uses "," as the delimiter; we can be more flexible here if needed
						if $extract(tTestValList,1,1) '= "," $$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error; expected value list for " _ tType _ " to be comma-delimited"))
						
						set tNewItem("Values") = $extract(tTestValList,2,*)
					}					
				}
				else
				{
					// unexpected case
					$$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error; data type " _ tType _ " is neither a datatype nor a literal"))
				}				
			} // else it's a literal and OK
			
			merge pPropertyInfo(tColNumber) = tNewItem	
				
			&sql(fetch PropertyInfo)
			$$$ThrowErrorForSqlCode(SQLCODE)
		}
		
		&sql(close PropertyInfo)
		$$$ThrowErrorForSqlCode(SQLCODE)	
		
		set tCursorIsOpen = 0
		
		// go back and look at nontrivial types. We do this outside the cursor in order to recurse without causing "cursor is already open" errors. 
		set tItemIndex = ""
		while 1
		{
			set tItemIndex = $o(tWorkingInfo(tItemIndex))
			if tItemIndex = "" quit
			
			set tType = tWorkingInfo(tItemIndex, "Type")
			
			if $extract(tType, 1,1) '= "%"
			{
				set tTestClassObj = ##class(%Dictionary.CompiledClass).%OpenId(tType)
				if '$isobject(tTestClassObj) $$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error; property type " _ tType _ " not recognized"))
				if tTestClassObj.ClassType = "datatype"
				{
					//merge pPropertyInfo($i(pPropertyInfo)) = tWorkingInfo(tItemIndex)
					kill tReferenceItem 
					set tReferenceItem("Type") = tType
					set tReferenceItem("Name") = tWorkingInfo(tItemIndex,"Name")
					set tReferenceItem("Description") = tWorkingInfo(tItemIndex,"Description")
					set tReferenceItem("Required") = tWorkingInfo(tItemIndex,"Required")
					
					// is there a value list? 
					set tTestValListObj = ##class(%Dictionary.CompiledParameter).IDKEYOpen(tType, "VALUELIST")
					if $ISOBJECT(tTestValListObj)
					{
						set tTestValList = tTestValListObj.Default
						// assume it uses "," as the delimiter; we can be more flexible here if needed
						if $extract(tTestValList,1,1) '= "," $$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error; expected value list for " _ tType _ " to be comma-delimited"))
						
						set tReferenceItem("Values") = $extract(tTestValList,2,*)
					}
					
					merge pPropertyInfo($i(pPropertyInfo)) = tReferenceItem	
				}
				else
				{
					// unexpected case
					$$$ThrowStatus($$$ERROR($$$GeneralError,"Internal error; data type " _ tType _ " is neither a datatype nor a literal"))
				}			
			}
			else
			{
				merge pPropertyInfo($i(pPropertyInfo)) = tWorkingInfo(tItemIndex)
			}
		}
		
		set tRetVal = $$$OK
	}
	catch tAnyException
	{
		if tCursorIsOpen &sql(close PropertyInfo)
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// determine whether a given class extends HSMOD.CSVTable.AbstractTable
ClassMethod IsClassACsvTable(pClassName) As %Boolean [ Internal ]
{
	if '##class(%Dictionary.CompiledClass).%ExistsId(pClassName) quit 0
	
	quit $classmethod(pClassName, "%IsA", "HSMOD.CSVTable.AbstractTable")
}

/// look up the SQL table name for a persistent class
ClassMethod GetSqlTableName(pClassName As %String) As %String [ Internal ]
{
	
	&sql(select SqlQualifiedNameQ 
		into :tThisTable 
		from %Dictionary.CompiledClass 
		where ID = :pClassName)	
		
	quit $select(SQLCODE=0:tThisTable,1:"")
}

/// evaluate whether the table design follows some rules we want them to. API (run from Terminal)
ClassMethod VerifySchema(pPackagePrefix As %String) [ Internal ]
{
	// does every column have an explicit SqlColumnNumber? 
	&sql(select top 1 cp.ID1
		into :badcol
		from %Dictionary.CompiledClass cc
						join %Dictionary.CompiledProperty cp on cc.ID = cp.Parent
						where cc.name like :pPackagePrefix || '%'
						and cc.PrimarySuper like '%~HSMOD.CSVTable.AbstractTable~%'
						and cc.classtype = 'persistent'
						and cp.internal = 0
						and cp.Name <> 'UniqueIdentifier'
						and nvl(cp.SqlColumnNumber,'') = ''  )
	if SQLCODE = 0
	{
		write !, "column missing a column number: " _ badcol
		quit
	}
	elseif SQLCODE < 0
	{
		write !, "ERROR"
	}	
	
	write !, "looks OK"
}

/// generator for simple documentation content
ClassMethod DocumentationStarter(pPackagePrefix As %String, pIncludeAbstractTables As %Boolean = 0) [ Internal ]
{
	try 
	{
		set tCursorOpen = ""
		
		&sql(declare DocTableList cursor for 
			select Name, SqlQualifiedNameQ, Abstract
			into :tClassName, :tTableName, :tTableIsAbstract
			from %Dictionary.CompiledClass
			where name like :pPackagePrefix || '%'
			and PrimarySuper like '%~HSMOD.CSVTable.AbstractTable~%'
			and classtype = 'persistent'
			) 
		
		&sql(open DocTableList)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = "DocTableList"
		
		&sql(fetch DocTableList)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while 'SQLCODE
		{
			set tTables(tClassName) = tTableName
			set tTables(tClassName, "abstract") = tTableIsAbstract
			
			&sql(fetch DocTableList)
			$$$ThrowErrorForSqlCode(SQLCODE)
		}
		
		&sql(close DocTableList)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = ""
		
		&sql(declare PropertyCursor cursor for 		
			select cc.Name, cp.Name, cp.SqlColumnNumber, 
				case cp.RunTimeType when '%Library.String' then 'String' else cp.RunTimeType end, 
				cp.Storable, cp.SqlComputed, cp.ID1
			into :tClassName, :propertyName, :colNum, 
				:datatype, 
				:storable, :sqlcomputed, :propertyId
						from %Dictionary.CompiledClass cc
						join %Dictionary.CompiledProperty cp on cc.ID = cp.Parent
						where cc.name like :pPackagePrefix || '%'
						and cc.PrimarySuper like '%~HSMOD.CSVTable.AbstractTable~%'
						and cc.classtype = 'persistent'
						and cp.internal = 0
						and cp.Name <> 'UniqueIdentifier'
				order by cc.name, cp.SqlColumnNumber)
		
		
		&sql(open PropertyCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = "PropertyCursor"
		
		&sql(fetch PropertyCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while 'SQLCODE
		{			
			set tProperties(tClassName, colNum, "name") = propertyName
			set tProperties(tClassName, colNum, "type") = datatype
			
			set tPropertiesByName(tClassName,propertyName) = colNum
			
			set tNote = ""
			if sqlcomputed = 1 set tNote = tNote _ "Computed"
			
			if datatype = "String"
			{
				set tPropObj = ##class(%Dictionary.CompiledProperty).%OpenId(propertyId)
				set tMaxLen = tPropObj.Parameters.GetAt("MAXLEN")
				if tMaxLen '= 50
				{
					set tNote = tNote _ $case(tNote,"":"",:", ") _ "Max length: " _ tMaxLen
				}
			}
			
			set tProperties(tClassName, colNum, "note") = tNote
			
			&sql(fetch PropertyCursor)
			$$$ThrowErrorForSqlCode(SQLCODE)
		}
		
		&sql(close PropertyCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = ""
		
		&sql(declare indexCursor cursor for 		
			select ci.parent, ci.Name, ci.primarykey, ci.properties
			into :tClassName, :tIndexName, :tPK, :tIndexProperties
			from %Dictionary.CompiledClass cc
			join %Dictionary.CompiledIndex ci on cc.ID = ci.Parent
			where cc.name like :pPackagePrefix || '%'
			and cc.PrimarySuper like '%~HSMOD.CSVTable.AbstractTable~%'
			and cc.classtype = 'persistent'
			and ci.type = 'index'
			and ci.name <> 'UNIQUEIDIX'
			and ci._unique = 1)
			
			
		&sql(open indexCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = "indexCursor"
		
		&sql(fetch indexCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while 'SQLCODE
		{
			set tIndexes(tClassName, tIndexName, "properties") = tIndexProperties
			set tIndexes(tClassName, tIndexName, "ispk") = tPK
			
			
			&sql(fetch indexCursor)
			$$$ThrowErrorForSqlCode(SQLCODE)
		}
		
		&sql(close indexCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = ""
		
		
		&sql(declare fkCursor cursor for		
			select ck.parent, ck.properties, ck.referencedclass, ck.referencedkey, ck.name
			into :tClassName, :tPropertiesVal, :tRefClass, :tRefKey, :tFKName
			from %Dictionary.CompiledClass cc
			join %Dictionary.CompiledForeignKey ck on cc.ID = ck.Parent
			where cc.name like :pPackagePrefix || '%'
			and cc.PrimarySuper like '%~HSMOD.CSVTable.AbstractTable~%'
			and cc.classtype = 'persistent') 
	
		
		&sql(open fkCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = "fkCursor"
		
		&sql(fetch fkCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while 'SQLCODE
		{ 
			set tFK(tClassName,tFKName,"properties") = tPropertiesVal
			set tFK(tClassName,tFKName,"targetclass") = tRefClass
			set tFK(tClassName,tFKName,"targetkey") = tRefKey
			
			&sql(fetch fkCursor)
			$$$ThrowErrorForSqlCode(SQLCODE)
		}
		
		&sql(close fkCursor)
		$$$ThrowErrorForSqlCode(SQLCODE)
		set tCursorOpen = ""
	 
		
		set tTableLoop = ""
		while 1
		{
			if $data(tTables) = 0 quit
			set tTableLoop = $o(tTables(tTableLoop))
			if tTableLoop = "" {
				quit
			}
			
			if tTables(tTableLoop, "abstract") = 1 {
				w !, "skipping abstract table " _ tTableLoop
				continue
			}
			
			// stage some index info in the properties
			set tNonPKIxCount = 0
			set tIndexLoop = ""
			while 1
			{				
				set tIndexLoop = $o(tIndexes(tTableLoop,tIndexLoop))
				if tIndexLoop = "" {
					quit
				}
				
				if tIndexes(tTableLoop,tIndexLoop,"ispk") = 1
				{
					set tIndexAlias = "PK"
				}
				else
				{
					set tNonPKIxCount = tNonPKIxCount + 1
					set tIndexAlias = "IX" _ tNonPKIxCount
				}
				
				set tPropList = tIndexes(tTableLoop,tIndexLoop,"properties")
				for i=1:1:$length(tPropList,",")
				{
					set tPropName = $piece(tPropList,",",i)
					set tColNum = tPropertiesByName(tTableLoop,tPropName)
					set tProperties(tTableLoop,tColNum,"indexes") = $get(tProperties(tTableLoop,tColNum,"indexes")) _ "," _ tIndexAlias
				}
			}
			
			write !, !, "================================="
			write !,!, tTables(tTableLoop)
			write !, !, "Properties/Fields:" 
			
			set tPropertyLoop = ""
			while 1
			{
				set tPropertyLoop = $o(tProperties(tTableLoop,tPropertyLoop))
				if tPropertyLoop = "" {
					quit
				}
					
				kill tItem
				merge tItem = tProperties(tTableLoop,tPropertyLoop)
				
				write !, tItem("name") _ ": " _ tItem("type") _ " " _ tItem("note")
				if $get(tItem("indexes")) '= ""
				{
					write " (" _ $extract(tItem("indexes"),2,*) _ ")"					
				}				
			}
			
			if $d(tIndexes(tTableLoop))
			{
				write !, !, "Unique Indexes: " 
				
				set tIndexLoop = ""
				while 1
				{
					set tIndexLoop = $o(tIndexes(tTableLoop,tIndexLoop))
					if tIndexLoop = "" {
						quit
					}
					
					write !, tIndexLoop _ ": (" _ tIndexes(tTableLoop,tIndexLoop,"properties") _ ")"
					
					if tIndexes(tTableLoop,tIndexLoop,"ispk") = 1 write " - PK "
				}
				
			}
			
			if $d(tFK(tTableLoop))
			{
				write !, !, "Foreign Keys: "
				set tFKLoop = ""
				while 1
				{
					set tFKLoop = $o(tFK(tTableLoop,tFKLoop))
					if tFKLoop = "" {
						quit
					}
					
					write !, "(" _ tFK(tTableLoop,tFKLoop,"properties") _ ") --> " _ 
						tTables(tFK(tTableLoop,tFKLoop,"targetclass")) _ ":" _ tFK(tTableLoop,tFKLoop,"targetkey")
				}
			}
		}
		
	}
	catch anyEx
	{
		if $get(tCursorOpen) = "DocTableList" {
			&sql(close DocTableList)
		} elseif $get(tCursorOpen) = "PropertyCursor" {
			&sql(close PropertyCursor) 
		} elseif $get(tCursorOpen) = "indexCursor" {
			&sql(close indexCursor)
		} elseif $get(tCursorOpen) = "fkCursor" {
			&sql(close fkCursor)
		}
		
		write !, anyEx.DisplayString()
	}
}

/// CSV import method for a set of tables, using a set of CSV files in a common folder. Arguments: 
/// <ul><li><var>pTargetFolder</var> is the target folder where the files should be found. Each file should 
/// have a name of the form "<var>tablename</var>.csv" where "tablename" is the full SQL table name of the class, e.g. 
/// "web_HS_Clinigraphic_CodeCategorization.Categorization.csv". </li>
/// <li><var>pClassNames</var> is a list of class names (not table names); the corresponding files are expected to have names consisting
/// of the table (SQL) name, normalized, followed by the ".csv" suffix.</li>
/// <li><var>pRemoveExistingValues</var> indicates whether the existing table data should be deleted prior to import; default is 1 (yes). </li>
/// <li><var>pRelyOnHeaderRow</var> indicates whether the import code should look at the first file row as a "header" row with column names and 
/// use those column names as a guide (instead of expecting data to be in predicted column sequence). Default is 0 (no). </li>
/// <li><var>pVerbose</var> controls text output (for use in Terminal). Default is 1 (verbose).</li>
/// </ul>
/// @API.Method
ClassMethod ImportTablesFromCSV(pTargetFolder As %String, pClassNames As %List, pRemoveExistingValues As %Boolean = 1, pRelyOnHeaderRow As %Boolean = 0, pVerbose As %Boolean = 1) As %Status
{
	set tRetVal = $$$OK
	try 
	{ 
		set tInitTLevel = $TLevel
		TSTART 
		
		set pTargetFolder = ##class(%Library.File).NormalizeDirectory(pTargetFolder) 
		// ensures we have a final slash/backslash as appropriate
		
		if '##class(%Library.File).DirectoryExists(pTargetFolder) {
			set tProblem = "Folder not found: " _ pTargetFolder
			if pVerbose {
				write !, tProblem
			}
			$$$ThrowStatus($$$ERROR($$$GeneralError, tProblem))
		}
		
		// we'll loop twice, to verify the existence of the files before we start loading. This is in order to save time 
		// and avoid a large rollback. 
								    
		for tClassLoop = 1:1:$listlength(pClassNames) {
			set tClassName = $listget(pClassNames, tClassLoop)
			set tTableName = ..GetSqlTableName(tClassName)
			set tFileName = ##class(%Library.File).NormalizeFilename(tTableName _ ".csv", pTargetFolder)
			
			if ##class(%Library.File).Exists(tFileName) {
				set tClassesAndFiles($increment(tClassesAndFiles)) = $listbuild(tFileName, tClassName)
			}
			else {
				set tProblem = "File not found: " _ tFileName
				if pVerbose {					
					write !, tProblem
				}
				$$$ThrowStatus($$$ERROR($$$GeneralError, tProblem))
			}
		}
		
		set tFileLoop = ""
		while 1
		{
			set tFileLoop = $order(tClassesAndFiles(tFileLoop))
			if tFileLoop = "" {
				quit
			}
			
			set tFileName = $listget(tClassesAndFiles(tFileLoop), 1)
			set tClassName = $listget(tClassesAndFiles(tFileLoop), 2)
			 
			set tSC = $CLASSMETHOD(tClassName, "ImportFile", tFileName, pRemoveExistingValues, pRelyOnHeaderRow, .tResultInfo)
			if $$$ISERR(tSC)
			{
				if pVerbose {
					write !, "problem importing " _ tFileName _ ": " _ $get(tResultInfo)
				}
				$$$ThrowStatus(tSC)
			}
			elseif pVerbose
			{
				// output for successful progress (not a problem)
				set tShortFileName = $extract(tFileName, $length(pTargetFolder) + 1,*)
				write !, tShortFileName _ ": " _ $get(tResultInfo)
			}
		}
		
		TCOMMIT
	}
	catch anyEx
	{		
		while ($TLevel > tInitTLevel) {
			TROLLBACK 1
		}
		
		if pVerbose {
			write !, anyEx.DisplayString()
		}
		set tRetVal = anyEx.AsStatus()
		
	}
	
	quit tRetVal
}

/// CSV export method for a set of tables in a list. Each file will have a name of the 
/// form "<var>tablename</var>.csv" where "tablename" is the full SQL table 
/// name of the class, e.g. "web_HS_Clinigraphic_CodeCategorization.Categorization.csv". Arguments: 
/// <ul>
/// <li><var>pTargetFolder</var> is the destination folder for export. </li>
/// <li><var>pClassNames</var> is a list of class names (not table names) to export.</li>
/// <li><var>pOverwriteExisting</var> indicates whether to overwrite existing files. Default is 0 (no). </li>
/// <li><var>pAddHeaderRow</var> indicates whether to include a header row (with column names) in the output file. Default is 0 (no). </li>
/// <li><var>pVerbose</var> controls text output (for use in Terminal). Default is 1 (verbose).</li>
/// </ul>
/// @API.Method
ClassMethod ExportTablesToCSV(pTargetFolder As %String, pClassNames As %List, pOverwriteExisting = 0, pAddHeaderRow As %Boolean = 0, pVerbose As %Boolean = 1)
{
	set tCursorOpen = 0
	set tFilesWritten = 0
		
	try 
	{
		set pTargetFolder = ##class(%Library.File).NormalizeDirectory(pTargetFolder) 
		// ensures we have a final slash/backslash as appropriate
		
		if '##class(%Library.File).DirectoryExists(pTargetFolder) {
			set tProblem = "Folder not found: " _ pTargetFolder
			if pVerbose {
				write !, tProblem
			}
			$$$ThrowStatus($$$ERROR($$$GeneralError, tProblem))
		}
		
		&sql(declare TableList cursor for 
			select Name, SqlQualifiedNameQ
			into :tClassName, :tTableName
			from %Dictionary.CompiledClass
			where name %INLIST :pClassNames
			and PrimarySuper like '%~HSMOD.CSVTable.AbstractTable~%'
			and classtype = 'persistent'
			and abstract = 0)
		
		&sql(open TableList)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		set tCursorOpen = 1
		
		&sql(fetch TableList)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while SQLCODE = 0
		{
			set tTargetFile = ##class(%Library.File).NormalizeFilename(tTableName _ ".csv", pTargetFolder)
			if pOverwriteExisting = 0 {
				if ##class(%Library.File).Exists(tTargetFile) {
					set tProblem = "File already exists: " _ tTargetFile
					if pVerbose {
						write !, tProblem
					}
					$$$ThrowStatus($$$ERROR($$$GeneralError, tProblem))
				}
			}
			
			// store in an array and then loop through it separately. This allows us to avoid exporting a partial 
			// set if there's an avoidable problem like a file already existing when we're not supposed to overwrite. 
			set tClassesAndFiles($increment(tClassesAndFiles)) = $listbuild(tTargetFile, tClassName)
			
			&sql(fetch TableList)
			$$$ThrowErrorForSqlCode(SQLCODE)
		}
		
		&sql(close TableList)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		set tCursorOpen = 0
		
		// now loop through the files ... 
		set tFileLoop = ""
		while 1
		{
			set tFileLoop = $order(tClassesAndFiles(tFileLoop))
			if tFileLoop = "" {
				quit
			}
			
			set tTargetFile = $listget(tClassesAndFiles(tFileLoop), 1)
			set tExportClassName = $listget(tClassesAndFiles(tFileLoop), 2)
			
			set tSC = $CLASSMETHOD(tExportClassName, "ExportToFile", tTargetFile, pOverwriteExisting, pAddHeaderRow, .tResultInfo)
			if $$$ISERR(tSC)
			{
				if pVerbose {
					write !, "result info for error situation: " _ $get(tResultInfo)
				}
				$$$ThrowStatus(tSC)
			}
			else
			{
				// success output
				set tFilesWritten = tFilesWritten + 1
				if pVerbose {
					write !, tTargetFile _ ": " _ $get(tResultInfo)
				}
			}
		}
	}
	catch anyEx
	{
		if tCursorOpen
		{
			&sql(close TableList)
		}
		
		if pVerbose {
			write !, anyEx.DisplayString()
			if tFilesWritten > 0 
			{
				write !, tFilesWritten _ " files were written; these may need to be cleaned up"
			}
		}
	}
}

}

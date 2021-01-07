Include (HSMOD.CSVTable, %occErrors)

/// <p>
/// Base class for tables with CSV import/export functionality.
/// </p><p>
/// This would be particularly useful for any set of (persistent) data that drives behavior but has very low churn or 
/// turnover, including tables whose contents might be managed by customers or implementers, possibly using external 
/// code dictionary/mapping software. 
/// </p><p>
/// In order for the import/export code to work, we handle object references by replacing the object 
/// property with simple values from the target class's primary key. We do this for any property whose 
/// type does not begin with a % symbol; if this is too broad we can restrict it to other subclasses of this class.
/// </p>
/// <p>The import/export features rely on explicit SqlColumnNumber values for every (persistent) property in the 
/// class. Column number 1 is internal, and column numbers 2 and 3 are used by this base class. Thus, a table 
/// class extending this class would begin with column 4 for its properties. 
/// </p>
/// <p><strong>
/// This class is subject to change in future versions of HealthShare.
/// </strong></p>
/// @API.Extensible
Class HSMOD.CSVTable.AbstractTable Extends %Persistent [ Abstract, NoExtent ]
{

/// optional unique identifer; each table has a unique index on this property. It is not used 
/// by the functional code, and is purely an aid to data management
Property UniqueIdentifier As %String(MAXLEN = 200) [ SqlColumnNumber = 2 ];

/// computed field (automatically populated), containing the most recent modification date/time. 
Property LastModified As %TimeStamp [ SqlColumnNumber = 3, SqlComputeCode = { set {LastModified} = $zdatetime($ztimestamp,3,1)}, SqlComputed, SqlComputeOnChange = %%UPDATE ];

Index UNIQUEIDIX On UniqueIdentifier [ Unique ];

/// helper method for class info
ClassMethod GetReferencedTables(Output pRefTables) As %Status [ Internal ]
{
	set tRetVal = $$$OK
	kill pRefTables
	
	try 
	{
		set tCursorIsOpen = 0
		set tThisClass = $classname()
		
		// EXAMINE OUTGOING FK's
		&sql(declare outgoingFKs cursor for 			
			select cfk.ReferencedClass 
			into :tRefTable
			from %Dictionary.CompiledForeignKey cfk
			where cfk.parent = :tThisClass)
			
		&sql(open outgoingFKs)
		$$$ThrowErrorForSqlCode(SQLCODE)
	
		set tCursorIsOpen = 1
		
		&sql(fetch outgoingFKs)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while SQLCODE = 0
		{
			set pRefTables(tRefTable) = 1
			
			&sql(fetch outgoingFKs)
			$$$ThrowErrorForSqlCode(SQLCODE)			
		}
		
		&sql(close outgoingFKs)
		$$$ThrowErrorForSqlCode(SQLCODE)	
		
		set tCursorIsOpen = 0	 
	}
	catch tAnyException
	{
		if tCursorIsOpen &sql(close outgoingFKs)
		kill pRefTables
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// helper method for class info
ClassMethod GetDependentTables(Output pDependentTables) As %Status [ Internal ]
{
	set tRetVal = $$$OK
	kill pDependentTables
	
	try 
	{
		set tCursorIsOpen = 0
		set tThisClass = $classname()
		
		// get full ancestry; we care about incoming FK's on parent classes. This only looks at the 
		// primary ancestry path, not multiple inheritance situations. 
		set tClassObject = ##class(%Dictionary.CompiledClass).%OpenId(tThisClass,, .tSC)
		$$$ThrowOnError(tSC)
		if ($data(tClassObject) = 0) || ('$isobject(tClassObject)) {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "could not open class meta-data for " _ tThisClass))
		}
		
		set tAncestryList = $listfromstring(tClassObject.PrimarySuper,"~")
		
		// EXAMINE INCOMING FK's
		
		// TODO: we might want a better way to do this because the FK table isn't indexed on this 
		// property and we would therefore be doing a full table scan. It's probably not a big deal in practice, 
		// because we won't be doing lots of these at once. In particular, INFORMATION.SCHEMA.REFERENTIALCONSTRAINTS may be 
		// useful here. 
		
		&sql(declare incomingFKs cursor for 			
			select cfk.parent 
			into :tDependentTable
			from %Dictionary.CompiledForeignKey cfk
			where cfk.ReferencedClass %INLIST :tAncestryList)
			
		&sql(open incomingFKs)
		$$$ThrowErrorForSqlCode(SQLCODE)
	
		set tCursorIsOpen = 1
		
		&sql(fetch incomingFKs)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while SQLCODE = 0
		{
			set pDependentTables(tDependentTable) = 1
			
			&sql(fetch incomingFKs)
			$$$ThrowErrorForSqlCode(SQLCODE)	
		}
		
		&sql(close incomingFKs)
		$$$ThrowErrorForSqlCode(SQLCODE)	
		
		set tCursorIsOpen = 0	 
	}
	catch tAnyException
	{
		if tCursorIsOpen &sql(close incomingFKs)
		kill pDependentTables
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// helper method for class info
ClassMethod GetUniqueIndexInfo(Output pIndexArray) As %Status [ Internal ]
{
	set tRetVal = $$$OK
	kill pIndexArray
	
	try 
	{
		set tCursorIsOpen = 0
		set tThisClass = $classname()
		
		&sql(declare indexInfo cursor for 
			select ci.Name, cip.Property
			into :tIndexName, :tPropertyName
			from %Dictionary.CompiledIndex ci
			join %Dictionary.CompiledIndexProperty cip on ci.id1 = cip.parent
			where ci.parent = :tThisClass
			and ci._unique = 1
			order by ci.Name)
			
		
		&sql(open indexInfo)
		$$$ThrowErrorForSqlCode(SQLCODE)
	
		set tCursorIsOpen = 1
		
		&sql(fetch indexInfo)
		$$$ThrowErrorForSqlCode(SQLCODE)
		
		while SQLCODE = 0
		{
			set pIndexArray(tIndexName, $i(pIndexArray(tIndexName))) = tPropertyName
			
			&sql(fetch indexInfo)
			$$$ThrowErrorForSqlCode(SQLCODE)	
		}
		
		&sql(close indexInfo)
		$$$ThrowErrorForSqlCode(SQLCODE)	
		
		set tCursorIsOpen = 0	 
	}
	catch tAnyException
	{
		if tCursorIsOpen &sql(close indexInfo)
		kill pIndexArray
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// <p>Recursive method for wiping out contents of CSV-enabled tables, recursing upstream along the foreign keys. 
/// The argument <parameter>pClassTrail</parameter> is a %List of the classes we've recursed through to 
/// get here, which is used to avoid cycles. If we encounter a cycle, we stop. </p>
/// @API.Method 
ClassMethod DeleteRecursively(pClassTrail As %List = "") As %Status [ Internal ]
{
	set tRetVal = $$$OK
	try 
	{
		set tStatus = ..GetDependentTables(.tDependentTables)
		$$$ThrowOnError(tStatus)
		
		set tNewTrail = pClassTrail _ $listbuild($classname())
		
		set tDependentTable = ""
		while 1
		{
			set tDependentTable = $o(tDependentTables(tDependentTable))
			if tDependentTable = "" quit
			
			if ((##class(HSMOD.CSVTable.Utils).IsClassACsvTable(tDependentTable)) && ($listfind(pClassTrail, tDependentTable) = 0))
			{
				set tStatus = $CLASSMETHOD(tDependentTable, "DeleteRecursively", tNewTrail)
				$$$ThrowOnError(tStatus)
			}
		}
		
		// We use %DeleteExtent() instead of %KillExtent() here in order to enforce constraints
		set tStatus = ..%DeleteExtent()
		$$$ThrowOnError(tStatus)
	}
	catch tAnyException
	{
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// <p>Callback method for subclasses to do special data cleanup/validation/etc. during data import</p>
/// @API.Overrideable
ClassMethod PreProcessNewDataRow(ByRef pNewLine) As %Status [ Internal ]
{
	// do nothing (default)
	quit $$$OK
}

/// <p>Callback method for validation, cleanup, etc. when importing new objects</p>
/// @API.Overrideable
Method PostProcessNewDataObject() As %Status [ Internal ]
{
	// do nothing (default)
	quit $$$OK
}

/// helper method for <method>ImportFile</import>; stream implementation allows us to separate the logic from 
/// actual files (so, for example, we can test with other streams)
ClassMethod ImportFromStream(pStream As %Stream.Object, pRemoveExistingValues As %Boolean = 1, pRelyOnHeaderRow As %Boolean = 0, pLineLength As %Integer = {$$$MaxLocalLength}, Output pRowsImported As %Integer) As %Status [ Internal ]
{
	set tRetVal = $$$OK
	set tTransactionLevel = $tlevel
	try {
		TSTART
		
		if pRemoveExistingValues {			
			set tStatus = ..DeleteRecursively()
			$$$ThrowOnError(tStatus)
		}
		
		if pRelyOnHeaderRow
		{	
			// look up which columns are computed, so we can skip them in the import if they appear in the file
			set tStatus = ##class(HSMOD.CSVTable.Utils).LookUpColumnInformation($classname(), .tComputedProperties,1,0)
			$$$ThrowOnError(tStatus)
			
			set tPropertyLoop = ""
			while 1
			{
				set tPropertyLoop = $o(tComputedProperties(tPropertyLoop))
				if tPropertyLoop = "" quit
				
				set tComputedColNames(tComputedProperties(tPropertyLoop,"Name")) = 1
			}
		}
		
		do pStream.Rewind()
		
		if pStream.AtEnd 
		{
			TCOMMIT
			quit
		}
		
		// check line endings in file, update the terminator on the stream if we ignored a trailing CR in the data
		set tFirstLine = pStream.ReadLine(pLineLength)
		if $extract(tFirstLine,*) = $char(13) {
			// we found a trailing CR on the first line, so update the line terminators to CRLF
			set pStream.LineTerminator = $char(13,10)
		}
		do pStream.Rewind()
		
		set tFirstLine = 1
		set pRowsImported = 0
		while 'pStream.AtEnd {
			set tNewLine = pStream.ReadLine(pLineLength)
						
			if tFirstLine = 1 {
				set tFirstLine = 0
				
				if pRelyOnHeaderRow = 1
				{
					// get the column names from the current file line
					do ##class(%DeepSee.TermList).%ParseCSVRecord(tNewLine, .tFileColumnNames)					
					
					// now that we've build the array, we're done with this row
					continue
				}
				else 
				{
					// here we assume that the file uses columns that match what we would normally export
					
					kill tExpectedProperties
					set tStatus = ##class(HSMOD.CSVTable.Utils).LookUpColumnInformation($classname(), .tExpectedProperties)
					$$$ThrowOnError(tStatus)
		
					set tPropertyLoop = ""
					set tCounter = 0
					while 1 {
						set tPropertyLoop = $o(tExpectedProperties(tPropertyLoop))
						if tPropertyLoop = "" quit
						
						set tCounter = tCounter + 1
						set tFileColumnNames(tCounter) = tExpectedProperties(tPropertyLoop, "Name")	
					}
					
					// check whether the first row is a header row; if so, skip it
					set tHeaderString = ..HeaderRowString(.tExpectedProperties)
					if tHeaderString = tNewLine {
						continue // skip header rows
					}
				}
			}
			
			set tStatus = ..PreProcessNewDataRow(.tNewLine)
			$$$ThrowOnError(tStatus)
			
			do ##class(%DeepSee.TermList).%ParseCSVRecord(tNewLine, .tNewValues) // is there a better place to get this than a %DeepSee class? 
			
			set tNewInstance = ..%New()
			
			set tPropertyLoop = ""
			while 1 {
				set tPropertyLoop = $o(tFileColumnNames(tPropertyLoop))
				if tPropertyLoop = "" quit
				
				set tColumnName = tFileColumnNames(tPropertyLoop)
				if ((pRelyOnHeaderRow = 1) && ($g(tComputedColNames(tColumnName)) = 1)) {
					// skip computed columns
					continue
				}
				
				set $property(tNewInstance, tColumnName) = $g(tNewValues(tPropertyLoop))
				// to do: any special date formatting, etc.? 				
			}
			
			set tStatus = tNewInstance.PostProcessNewDataObject()
			$$$ThrowOnError(tStatus)
			
			set tStatus = tNewInstance.%Save()
			$$$ThrowOnError(tStatus)
			
			set pRowsImported = pRowsImported + 1
		}
		
		TCOMMIT
	} catch tException {	
		// roll back enough levels to get back to status quo
		while (tTransactionLevel < $tlevel) {
  			TROLLBACK 1
		}
		set pRowsImported = 0

		set pResultInfo = "Error: " _ tException.DisplayString()
		set tRetVal = tException.AsStatus()
	}
	
	quit tRetVal
}

/// <p>Utility method for importing table contents from CSV. Run <method>DescribeFileFormat</method> for a summary of the file format. </p>
/// <p>Arguments: <ol>
/// 	<li><strong>pFileName</strong>: full file path and file name for file to import</li>
/// 	<li><strong>pRemoveExistingValues</strong>: whether to wipe out the current contents of the file before importing. If true, 
/// 		then dependent data in downstream tables will be cleared as well.</li>
/// 	<li><strong>pRelyOnHeaderRow</strong>: whether to expect a header row with column names in the file.</li>
/// 	<li><strong>pLineLength</strong>: the maximum length to read per line. If omitted, we use the string length limit for the current server.</li>
/// 	<li><strong>pResultInfo</strong>: verbal confirmation of success or failure, with error contents or line count.</li>
/// 	</ol></p>
/// @API.Method
ClassMethod ImportFile(pFilename As %String, pRemoveExistingValues As %Boolean = 1, pRelyOnHeaderRow As %Boolean = 0, pLineLength As %Integer = {$$$MaxLocalLength}, Output pResultInfo As %String) As %Status
{
	set tRetVal = $$$OK
	
	try {
		// validate file name
		if '##class(%Library.File).Exists(pFilename) $$$ThrowStatus($$$ERROR($$$FileDoesNotExist, "File not found: " _ pFilename))
		
		set tFileStream = ##class(%Stream.FileCharacter).%New()
		set tStatus = tFileStream.LinkToFile(pFilename)
		$$$ThrowOnError(tStatus)
		
  		set tStatus = ..ImportFromStream(tFileStream,pRemoveExistingValues,pRelyOnHeaderRow, pLineLength, .tRowsFound)
		$$$ThrowOnError(tStatus)
		
		set pResultInfo = "Success! " _ $get(tRowsFound,0) _ " rows imported"
	} catch tAnyException {
		set pResultInfo = "Error: " _ tAnyException.DisplayString()
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

ClassMethod EscapeStringForCSV(pStartVal As %String) As %String [ Internal ]
{
	// escaping logic cribbed from ##class(%DeepSee.TermList).%WriteCSVRecord(): 
	// if the string contains a comma or a double-quote character, wrap it using $$$quote 
				
	quit $select(((pStartVal)["""")||((pStartVal)[","):$$$quote(pStartVal),1:(pStartVal))
}

ClassMethod HeaderRowString(ByRef pPropertyArray) As %String [ Internal, Private ]
{
	set tWorkingList = ""
	set tPropertyLoop = "" 
	while 1			
	{
		set tPropertyLoop = $o(pPropertyArray(tPropertyLoop))
		if tPropertyLoop = "" quit
		
		set tPropName = pPropertyArray(tPropertyLoop, "Name")
		set tWorkingList = tWorkingList _ $listbuild(..EscapeStringForCSV(tPropName))
	}
	
	quit $listtostring(tWorkingList)
}

/// helper/implementation method for export
ClassMethod ExportToStream(pStream As %Stream.Object, pAddHeaderRow As %Boolean = 0, Output pRowsFound As %Integer) As %Status [ Internal ]
{
	set tRetVal = $$$OK
	try {	
		kill tProperties
		set tStatus = ##class(HSMOD.CSVTable.Utils).LookUpColumnInformation($classname(), .tProperties)
		$$$ThrowOnError(tStatus)
		
		do pStream.Rewind()
		
		if pAddHeaderRow
		{
			set tWorkingString = ..HeaderRowString(.tProperties)
			
			set tStatus = pStream.WriteLine(tWorkingString)
			$$$ThrowOnError(tStatus)
		}
		
		
		// loop through instances
		// We "order by ID" specifically in order to ensure row order. This can matter in 
		// some cases (e.g. when the class has a self-referencing foreign key), and omitting 
		// the "order by" can produce alternate orderings if the class has a primary key 
		// on some non-ID property that would influence storage order. Outputting the rows 
		// in ID order means that the file will then be suitable for import. 
		set tInstanceQuery = ##class(%SQL.Statement).%New()
		set tInstanceSQL = "Select %ID from " _ ##class(HSMOD.CSVTable.Utils).GetSqlTableName($classname()) _ 
			" order by %ID"
		
		set tStatus = tInstanceQuery.%Prepare(tInstanceSQL)
		$$$ThrowOnError(tStatus)
		set tResults = tInstanceQuery.%Execute()
		set pRowsFound = 0
		
		while tResults.%Next() {
			set tCurrentObject = ..%OpenId(tResults.%Get("ID"),,.tStatus)
			$$$ThrowOnError(tStatus)
			
			set tWorkingList = ""
			set tPropertyLoop = ""
			
			while 1
			{
				set tPropertyLoop = $o(tProperties(tPropertyLoop))
				if tPropertyLoop = "" quit
				
				// get the property value. For simple cases we could use $PROPERTY, but some of our property 
				// name expressions are compound strings separated by periods, for object references. So 
				// we use a recursive helper method to traverse the object references. 
				set tValue = $PROPERTY(tCurrentObject, tProperties(tPropertyLoop, "Name"))
				set tValue = $g(tValue,"")
				
				// TO DO: special handling for dates/times, etc.? 
				set tWorkingList = tWorkingList _ $listbuild(..EscapeStringForCSV(tValue))
			}
			
			set tStatus = pStream.WriteLine($listtostring(tWorkingList))
			set pRowsFound = pRowsFound + 1
			$$$ThrowOnError(tStatus)
		}
	} catch tAnyException {
		set pResultInfo = "Error: " _ tAnyException.DisplayString()
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// <p>Utility method for exporting table contents to CSV. Run <method>FileFormat</method> for a summary of the file format.</p>
/// <p>Arguments: <ol>
/// 	<li><strong>pFileName</strong>: full file path and file name for file to export</li>
/// 	<li><strong>pOverwriteExisting</strong>: whether to overwrite any existing file by that name</li>
/// 	<li><strong>pAddHeaderRow</strong>: whether to include a header row containing column names</li>
/// 	<li><strong>pResultInfo</strong>: verbal confirmation of success or failure, with error contents or line count.</li>
/// </ol></p>
/// @API.Method 
ClassMethod ExportToFile(pFilename As %String, pOverwriteExisting = 0, pAddHeaderRow As %Boolean = 0, Output pResultInfo As %String) As %Status
{
	set tRetVal = $$$OK
	try {
		if ##class(%Library.File).Exists(pFilename)	{
			if pOverwriteExisting {
				if '##class(%Library.File).Delete(pFilename) {
					$$$ThrowStatus($$$ERROR($$$GeneralError, "Error deleting existing file: " _ pFilename))
				}
			}
			else {
				$$$ThrowStatus($$$ERROR($$$GeneralError, "File already exists: " _ pFilename))
			}
		}
		
		set tFileStream = ##class(%Stream.FileCharacter).%New()
		set tStatus = tFileStream.LinkToFile(pFilename)
		$$$ThrowOnError(tStatus)
		
		/// write to stream
		set tStatus = ..ExportToStream(tFileStream, pAddHeaderRow, .tRowCount)
		$$$ThrowOnError(tStatus)
		
		set tStatus = tFileStream.%Save()
		$$$ThrowOnError(tStatus)
		
		set pResultInfo = "Success! Rows found: " _ tRowCount
		
	} catch tAnyException {
		set pResultInfo = "Error: " _ tAnyException.DisplayString()
		set tRetVal = tAnyException.AsStatus()
	}
	
	quit tRetVal
}

/// <p>Class summary information generator; intended to be run from Terminal. Writes output directly to the current device.</p>
/// @API.Method 
ClassMethod LayOutPropertyInfo(ByRef pPropertyInfo) [ Private ]
{
	set tIndent = "    "
	set tPropertyIndex = ""
	while 1	{
		set tPropertyIndex = $o(pPropertyInfo(tPropertyIndex))
		if tPropertyIndex = "" quit
		
		kill tProp			
		merge tProp = pPropertyInfo(tPropertyIndex)
		
		set tOutput = tPropertyIndex _ ": " _tProp("Name")	
		
		if tProp("Type") = "%Library.String" {
			set tOutput = tOutput _ ": string (maxlen: " _ $g(tProp("Parameters","MAXLEN"),"?") _ ")"
		} else {
			set tOutput = tOutput _ ": " _ tProp("Type")
		}
		
		if tProp("Required") set tOutput = tOutput _ " (REQUIRED)"
		
		write !, tOutput	
		
		if $g(tProp("Description")) '= "" {
			write !, tIndent _ tProp("Description") 
		}
		
		if $g(tProp("Values")) '= "" {
			write !, tIndent _ "Allowed values: " _ tProp("Values")
		}
	}
}

/// <p>Outputs a description of the file format for the table, to aid users in import/export file prep. 
/// Intended to be run from Terminal. Writes output directly to the current device.</p>
/// @API.Method 
ClassMethod DescribeFileFormat()
{
	kill tPropertyInfo
	set tIndent = "    "
	try {
		set tThisClass = ##class(%Dictionary.CompiledClass).%OpenId($classname())
		// if this object is undefined then we'll throw an exception here
		if tThisClass.Abstract = 1
		{
			w !, "This class is abstract and cannot use file import/export features."
			quit
		}
		
		
		w !, "SQL table name: " _ ##class(HSMOD.CSVTable.Utils).GetSqlTableName($classname())
		w !
		
		
		set tStatus = ##class(HSMOD.CSVTable.Utils).LookUpColumnInformation($classname(), .tPropertyInfo)
		$$$ThrowOnError(tStatus)
		
		w !, "File columns:" 
		do ..LayOutPropertyInfo(.tPropertyInfo)
		
		
		set tStatus = ##class(HSMOD.CSVTable.Utils).LookUpColumnInformation($classname(), .tPropertyInfo,1,0)
		$$$ThrowOnError(tStatus)
		
		if $data(tPropertyInfo)
		{
			w !
			w !, "COMPUTED table columns (omitted from file import/export):" 
			do ..LayOutPropertyInfo(.tPropertyInfo)
		}
		
		set tStatus = ..GetUniqueIndexInfo(.tIndexArray)
		if $d(tIndexArray)
		{
			w !
			w !, "The following combinations must be unique: " 
			
			set tIndexLoop = ""
			while 1
			{
				set tIndexLoop = $o(tIndexArray(tIndexLoop))
				if tIndexLoop = "" quit
				
				set tIndexProperties= ""
				set tIndexPropertyLoop = ""
				while 1
				{
					set tIndexPropertyLoop = $o(tIndexArray(tIndexLoop, tIndexPropertyLoop))
					if tIndexPropertyLoop = "" quit
					
					if tIndexProperties '= "" set tIndexProperties = tIndexProperties _ ","
					set tIndexProperties = tIndexProperties _ tIndexArray(tIndexLoop, tIndexPropertyLoop)
				}
				w !, tIndent _ "(" _ tIndexProperties _ ")"
			}

		}
	
		w !
		w !, "Dependent tables (tables that rely upon this table): " 
		
		set tStatus = ..GetDependentTables(.tTableList)
		$$$ThrowOnError(tStatus)
		
		if $data(tTableList) {
			set tTableName = ""
			while 1 {
				set tTableName = $o(tTableList(tTableName))
				if tTableName = "" quit
				
				w !, tTableName
			}
		} else {
			w !, "-none-"
		}
		
		
		w !
		w !, "Referenced tables (tables that this table relies upon): " 
		
		set tStatus = ..GetReferencedTables(.tTableList)
		$$$ThrowOnError(tStatus)
		
		if $data(tTableList) {
			set tTableName = ""
			while 1	{
				set tTableName = $o(tTableList(tTableName))
				if tTableName = "" quit
				
				w !, tTableName
			}
		} else {
			w !, "-none-"
		}
		
		w !
		
		// TO DO: 
		// foreign keys, treading carefully around the object properties. We already describe the "referenced" tables but 
		// we don't specify which columns are involved in these FK's 
		
		// other helpful info? 
		
		
	}
	catch tException
	{
		w !, "Error: " _ tException.DisplayString()
	}
}

}

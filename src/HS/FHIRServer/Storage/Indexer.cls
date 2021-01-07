Include (HS.HC, HS.FHIRServer)

Class HS.FHIRServer.Storage.Indexer Extends (%RegisteredObject, HS.FHIRServer.Util.FHIRQueryUtils)
{

/// The max length value that can be indexed for search. The indices for values
/// longer than this will be truncated. The actual resource data will not be
/// affected though.
Parameter MAXSEARCHINDEXLEN = 220;

Property strategy As HS.FHIRServer.Storage.Json.InteractionsStrategy;

Property interactions As HS.FHIRServer.Storage.Json.Interactions;

Property mdAPI As HS.FHIRMeta.API;

Property json As %DynamicObject;

Property SearchTableEntry As %Persistent;

Property CommonSearchTableEntry As %Persistent;

Property IsBaseResourceProperty As %Boolean;

Property QuantityObjectsToSave As %ListOfObjects;

Property keyBeingIndexed As %String [ Transient ];

Property paramBeingIndexed As %String [ Transient ];

Method %OnNew(json As %DynamicObject, interactions As HS.FHIRServer.Storage.Json.Interactions) As %Status
{
	Set ..interactions = interactions
	Set ..mdAPI = interactions.strategy.schema
	// NOTE: ResourceObject is ALWAYS JSON		
	Set ..json = json
	// Prepare for any Quantity properties to be indexed
	Set ..QuantityObjectsToSave = ##class(%ListOfObjects).%New()

	Quit $$$OK
}

Method IndexValues()
{
	
	Set resourceType = ..json.resourceType
	#dim fpAPI as HS.FHIRPath.API = ..mdAPI.FHIRPathAPI

	Set ..keyBeingIndexed = resourceType _ "/" _ ..json.id
	Set resourceVersion = ..json.meta.versionId

	set tSearchClassname = ..interactions.strategy.GetSearchClass(resourceType)
	// Assert that the search table exists
	if ('$$$defClassDefined(tSearchClassname)) { quit }
	
	do $CLASSMETHOD(tSearchClassname, "KeyIdxDelete", ..keyBeingIndexed)
	set ..SearchTableEntry = $CLASSMETHOD(tSearchClassname, "%New")

	set tCommonSearchClassname = ..interactions.strategy.GetSearchClass("")
	do $CLASSMETHOD(tCommonSearchClassname, "KeyIdxDelete", ..keyBeingIndexed)
	set ..CommonSearchTableEntry = $CLASSMETHOD(tCommonSearchClassname, "%New")

	// Then actually create the search indices.
	for tClassName = "Resource", resourceType {
		
		if tClassName = resourceType {
			set ..IsBaseResourceProperty = 0
			set searchColumns = ..interactions.getSearchColumnsForType(resourceType)
		} else {
			set ..IsBaseResourceProperty = 1
			set searchColumns = ..interactions.getSearchColumnsForType("Resource")
		}
		//w !, "Process properties for ",tClassName,!
		// Flag whether this is a shared property so that AddToSearchTableEntry can know
		// whether to populate one or two objects

		#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn
		set tableName = ""
		Set columnCount = searchColumns.Count()
		for columnIx=1:1:columnCount {
			set searchColumn = searchColumns.GetAt(columnIx)
			if columnIx = 1 {
				set tableName = searchColumn.TableName
			}
			set ..paramBeingIndexed = searchColumn.ParamName
			set columnPropertyName = searchColumn.ColumnName
			Set tParamType = searchColumn.Type
			Set tParamDataType = searchColumn.DataType
			if tParamType = "composite" {
				//w "Skip composite ",..paramBeingIndexed,!
				Continue
			}

			// DIAGNOSTIC
			//w "Eval: ",searchParam.fhirPath,!

			// Extract the values (and their types)			
			Set tree = fpAPI.parse(searchColumn.FHIRPath)
			try {
				do fpAPI.evaluate(..json, tree, .VALUES)
				if VALUES = 0 {
					Continue
				}
			} catch ex {
				Set errorMsg = "FHIRPath evaluation failed on: " _ searchColumn.FHIRPath _ " for " _ ..keyBeingIndexed _ " ? " _ ..paramBeingIndexed
				$$$FSLog(errorMsg)
				$$$LOGWARNING(errorMsg)
				Continue
			}
			
			// DIAGNOSTIC
			//zw VALUES

			

			// Eventually we will clean up the loop in each populator method
			for ord=1:1:VALUES {
				Set value = VALUES(ord)
				Continue:value=""
				
				Set valueType = VALUES(ord,"t")
				Set methodName = ..NormalizeParamName("Index-" _ valueType)
				try {
					//w !,"About to index ", ..paramBeingIndexed,"|",ord," with method: ",methodName, " for ",value,!
					Do $METHOD(,methodName, searchColumn, columnPropertyName, tParamDataType, value)
				} catch ex {
					$$$FHIRLOGERROR("Error creating search indices for "_resourceType_"?"_..paramBeingIndexed_": "_$system.Status.GetOneErrorText(ex.AsStatus()))
					//w !,ex.AsStatus(),!
				}
			}
		}
	}
	try {
		TSTART
		set ..SearchTableEntry.MDVersion = ##class(HS.FHIRServer.Storage.Json.SearchTableVersion).getCurrentVer(..interactions.strategy.RepoInstance.parentRepo.%Id(), tableName)
		Set ..SearchTableEntry.Key = ..keyBeingIndexed
		Set ..SearchTableEntry.VersionId = resourceVersion
		$$$ThrowOnError( ..SearchTableEntry.%Save() )
		if '$classmethod($classname(..CommonSearchTableEntry), "KeyIdxExists", ..keyBeingIndexed) {
			Set ..CommonSearchTableEntry.Key = ..keyBeingIndexed
			Set ..CommonSearchTableEntry.VersionId = resourceVersion
			$$$ThrowOnError( ..CommonSearchTableEntry.%Save() )
		}
		// Set reference field and save any Quantity Objects
		// ..QuantityObjectsToSave
		for ord=1:1:..QuantityObjectsToSave.Count() {
			set tQuantityObj = ..QuantityObjectsToSave.GetAt(ord)
			set tQuantityObj.Key = ..keyBeingIndexed
			$$$ThrowOnError( tQuantityObj.%Save() )
		}
		
		TCOMMIT
	} catch ex {

		TROLLBACK 1

		throw ex
	}
}

Method AddToSearchTableEntry(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pValue As %String, pSuffix As %String = "")
{
	set isColl = searchColumn.isMultiValue
	set ColumnPropName = searchColumn.ColumnName _ pSuffix
	
	// Insert as list or scalar depending on whether it is MultiValue
	if isColl {
		set tColumnProp = $PROPERTY(..SearchTableEntry, ColumnPropName)
		Do tColumnProp.Insert(pValue)
	}
	else {
		set $PROPERTY(..SearchTableEntry, ColumnPropName)=pValue
	}
	
	// Rinse and repeat if the property is also shared across all resources
	if ..IsBaseResourceProperty {
		if isColl {
			set tColumnProp = $PROPERTY(..CommonSearchTableEntry, ColumnPropName)
			if (tColumnProp="") {
				$$$ThrowFHIR($$$GeneralError, "Column not found in common search table: "_..json.resourceType,".",ColumnPropName)
			}
			Do tColumnProp.Insert(pValue)
		} else {
			set $PROPERTY(..CommonSearchTableEntry, ColumnPropName)=pValue
		}
	}
}

/* 
This is a list of supported value types.  There is an index handler for each type
 * Address, Age, Attachment, * CodeableConcept, * Coding, * ContactPoint, Duration, 
 * HumanName, * Identifier, Location.Position, Money, * Period, * Quantity, Range, 
 * Reference, ResourceContainer, Timing, base64Binary, boolean, * code, * date, dateTime, 
 * decimal, id, instant, * integer, markdown, oid, * positiveInt, string, uri
*/
Method IndexAddress(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set spacer = ""
	Set tAddress = value
	if (tAddress.text'="") { 
		set tValue = tAddress.text
	} else {
		set tValue = ""
		if $IsObject(tAddress.line) {
			set tIterator = tAddress.line.%GetIterator()
			while tIterator.%GetNext(.tPropName, .tData) {
				If tData="" Continue
				Set tValue = tValue_spacer_tData
				Set spacer = " "
			}
		}
		for tAddressPart=tAddress.city,tAddress.state,tAddress.postalCode,tAddress.country {
			if (tAddressPart'="") { set tValue = tValue_spacer_tAddressPart }
			Set spacer = " "
		}
	}
	if tValue '= "" {
		Do ..AddToSearchTableEntry(searchColumn, tValue)
	}
}

Method IndexCoding(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set tCoding = value
	If tCoding.code="" Quit
	Do ..AddToSearchTableEntry(searchColumn, tCoding.code)
	Do ..AddToSearchTableEntry(searchColumn, tCoding.system_"|"_tCoding.code)
}

Method IndexCodeableConcept(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set tCodeableConcept = value
	If tCodeableConcept.coding="" Quit
	// coding is a collection, and for each one, create two indices, one for "code", and and for "system|code"
	Set tIterator = tCodeableConcept.coding.%GetIterator()
	while tIterator.%GetNext(.tPropName, .tCoding) {
		If tCoding="" Continue
		If tCoding.code="" Continue
		Do ..AddToSearchTableEntry(searchColumn, tCoding.code)
		Do ..AddToSearchTableEntry(searchColumn, tCoding.system_"|"_tCoding.code)
	}
}

Method IndexContactPoint(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set tContactPoint = value
	set tValue = tContactPoint.value
	Quit:tValue=""
	// According to the spec (http://www.hl7.org/fhir/DSTU2/search.html#token),
	// and According to the spec (http://www.hl7.org/fhir/STU3/search.html#token),
	// "The use is prepended by http://hl7.org/fhir/contact-point-system/"
	if (tContactPoint.system'="") { 
		set tSystem = tContactPoint.system_"-"_tContactPoint.use 
	} else { 
		set tSystem = tContactPoint.use 
	}
	do ..AddToSearchTableEntry(searchColumn, tValue)
	do ..AddToSearchTableEntry(searchColumn, tSystem_"|"_tValue)

	// The spec doesn't say to do this, but as a matter of practicality, if the value
	// is a phone number, we will also index (and therefore allow to be searched on)
	// a normalized version (whitespace and punctuation stripped) of the value.
	if (",phone,fax,pager,sms," [ (","_tContactPoint.system_",")) {
		set tValueNormalized = ..NormalizePhone(tValue)
		if (tValueNormalized '= tValue) {
			for tTableValue = tValueNormalized, tSystem_"|"_tValueNormalized {
				do ..AddToSearchTableEntry(searchColumn, tTableValue)
			}
		}
	}
}

Method IndexDate(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	if pColumnDataType = "Period" {
		do ..IndexDateAsPeriod(searchColumn, pColumnPropName, pColumnDataType, value)
		return	
	}
	Set tValue = value
	
	if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) { 
		set tValue = ##class(HS.FHIRServer.Utils).ConvertToUTC(tValue)
	}
	Do ..AddToSearchTableEntry(searchColumn, tValue)
}

Method IndexDateAsPeriod(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set tValue = value

	// If the value has a time then convert to UTC.
	if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
		set tValue = ##class(HS.FHIRServer.Utils).ConvertToUTC(tValue)
	}
	do ..AddToSearchTableEntry(searchColumn, ..FirstInstant(tValue), ..#PERIODSTARTSUFFIX)
	do ..AddToSearchTableEntry(searchColumn, ..LastInstant(tValue), ..#PERIODENDSUFFIX)
	
	// Presently we can only index on a single period per search param,
	//  even for those that include collections in their xpath values.
	// TO DO: fix this. Will probably require a fundamental change to
	// how periods are indexed and searched on.
}

Method IndexHumanName(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value) As %Status
{
	#dim tHumanName as %DynamicObject = value
	Set tValue = ""
	if (tHumanName.text'="") { 
		set tValue = tHumanName.text
		Do ..AddToSearchTableEntry(searchColumn, tHumanName.text)
	} else {
		set tValue = ..JSONArrayToList(tHumanName.given)
		// In Pre-STU3 FHIR, 'family' was an array property, it switched to a scalar.
		// Handle either here
		if tHumanName.family '= "" {
			set familyType = tHumanName.%GetTypeOf("family")
			if familyType = "array" {
				set tValue = tValue _ ..JSONArrayToList(tHumanName.family)
			} else {
				set $LIST(tValue, *+1) = tHumanName.family
			}
		}
		if (tValue '= "") {
			Do ..AddToSearchTableEntry(searchColumn, $ListToString(tValue, " "))
		}
	}
}

/// Converts an JSON array of scalar values to a $LIST
ClassMethod JSONArrayToList(jsonArray As %DynamicArray)
{
	Set list = ""
	if jsonArray '= "" {
		set count = jsonArray.%Size() - 1
		for ord=0:1:count {
			Set $List(list,*+1) = jsonArray.%Get(ord)
		}
	}
	return list
}

/// This method differs from DSTU2 to STU3, it must be overridden in the subclass
Method IndexIdentifier(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set tIdentifier = value
	Do ..AddToSearchTableEntry(searchColumn, tIdentifier.value) 
	Do ..AddToSearchTableEntry(searchColumn, tIdentifier.system_"|"_tIdentifier.value)
}

Method IndexNumber(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..AddToSearchTableEntry(searchColumn, value)
}

Method IndexPeriod(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
		Set tPeriod = value
		if (tPeriod.start="")&&(tPeriod.end="") { Quit }
		
		set tValue = tPeriod.start
		// If the value has a time then convert to UTC.
		if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
			set tValue = ##class(HS.FHIRServer.Utils).ConvertToUTC(tValue)
		}
		//Assume beginning of day if no time provided for start
		elseif (tValue ? 4N1"-"2N1"-"2N) {
			set tValue = tValue _ "T00:00:00Z"
		}
		//Assume beginning of month if no day provided for start
		elseif (tValue ? 4N1"-"2N) {
			set tValue = tValue _ "-01T00:00:00Z"
		}
		//Assume beginning of year if no month provided for start
		elseif (tValue ? 4N) {
			set tValue = tValue _ "-01-01T00:00:00Z"
		}
		// No start value -> Use year 0 as start value
		if (tValue="") { set tValue = 0 }
		Do ..AddToSearchTableEntry(searchColumn, tValue, ..#PERIODSTARTSUFFIX) 
		
		set tValue = tPeriod.end
		// If the value has a time then convert to UTC.
		if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
			set tValue = ##class(HS.FHIRServer.Utils).ConvertToUTC(tValue)
		}
		//Assume end of day if no time provided for end
		elseif (tValue ? 4N1"-"2N1"-"2N) {
			set tValue = tValue _ "T23:59:59Z"
		}
		//Assume end of month if no day provided for end
		elseif (tValue ? 4N1"-"2N) {
			set lastOfMonth = $zd($system.SQL.LASTDAY(tValue _ "-01"), 3)
			set tValue = lastOfMonth _ "T23:59:59Z"
		}
		//Assume end of year if no month provided for end
		elseif (tValue ? 4N) {
			set tValue = tValue _ "-12-31T23:59:59Z"
		}
		// No end value -> Use year 9999 as end value
		if (tValue="") { set tValue = 9999 }
		Do ..AddToSearchTableEntry(searchColumn, tValue, ..#PERIODENDSUFFIX) 
		
		// Presently we can only index on a single period per search param,
		//  even for those that include collections in their xpath values.
		// TO DO: fix this. Will probably require a fundamental change to
		// how periods are indexed and searched on.
}

Parameter MaxNumber As %Number = "1.79E308";

Parameter MinNumber As %Number = "-1.79E308";

Method IndexQuantity(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	set isColl = searchColumn.isMultiValue
	set ColumnPropName = searchColumn.ColumnName

	if searchColumn.DataType = "Range" {
		Set valueLow = value.low.value
		Set valueHigh = value.high.value
		if (valueLow="") && (valueHigh = "") {
			Quit
		}
		if valueLow '= "" {
			Set code = value.low.code
			Set unit = value.low.unit
			Set system = value.low.system
			if valueHigh '= "" {
				// We have both values
				if (code '= value.high.code) || (unit '= value.high.unit) || (system '= value.high.system) {
					Set errorMsg = "Range value not indexed because code, unit, and system did not match for the low and high Quantity values for " _ ..keyBeingIndexed _ " ? " _ ..paramBeingIndexed
					$$$FSLog(errorMsg)
					$$$LOGWARNING(errorMsg)
					Quit
				}
			} else {
				Set valueHigh = ..#MaxNumber
			}
		} else {
			// Only the high value
			Set code = value.high.code
			Set unit = value.high.unit
			Set system = value.high.system
			Set valueHigh = ..#MinNumber
		}		
	} else {
		Set valueLow = value.value
		Quit:valueLow=""

		Set valueHigh = value.value
		Set code = value.code
		Set unit = value.unit
		Set system = value.system
	}
	
	if isColl {
		// Indexed values are:
		//   value=value, unit=system|code (system may be null)
		//   value=value, unit=|code
		//   value=value, unit=|unit (if different from code)
		// Where system, code, and unit are properties of the unit of measure
		
		// Quantities are stored in a separate table the references the main search table via a foreign key.
		set tQuantityClassName = ..interactions.strategy.GetSearchClassesPackage()_"."_..json.resourceType_"."_pColumnPropName

		set tQuantityObj = $CLASSMETHOD(tQuantityClassName,"%New")
		set tQuantityObj.value = valueLow
		set tQuantityObj.valueHigh = valueHigh

		if (code '= "") {
			do tQuantityObj.unit.Insert("|" _ code)
		}
		if (unit '= "") && (unit '= code) {
			do tQuantityObj.unit.Insert("|" _ unit)
		}
		// We only need to add another unit if the system is not null, otherwise it
		// would be the same as the "|code" unit created above.
		if (system'="") {
			do tQuantityObj.unit.Insert(system _ "|" _ code)
		}
		// Save this to save later
		Do ..QuantityObjectsToSave.Insert(tQuantityObj)
	}
	else {
		set tQuantityObj = ##class(HS.FHIRServer.Storage.QuantitySerial).%New()
		set tQuantityObj.value = valueLow
		set tQuantityObj.valueHigh = valueHigh
		
		// Prefer the unit field to the code field ???
		set unit = $Select(unit="":code, 1:unit)
		set tQuantityObj.unit = system_"|"_unit
		set $PROPERTY(..SearchTableEntry, ColumnPropName) = tQuantityObj
		
	}
}

Method IndexRange(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	do ..IndexQuantity(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexReference(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set tRefVal = value
	If tRefVal = "" Quit
	Set tRefVal = tRefVal.reference
	If $Extract(tRefVal)="#" Quit
	// Check whether the reference value is of the right type to be indexed
	// and searched by this param.
	set pieceCount = $Length(tRefVal, "/")
	Set targetId = $Piece(tRefVal, "/", *)
	Set targetURL = ""
	// To Do ... handle ID-only reference values like we used to
	if pieceCount = 1 {
		// This is an ID only.  It is valid for reference parameters that target ONLY as single
		// resource type.
		if $ListLength(searchColumn.Target)	> 1 {
			// There is no Resource type making the reference ambiguous
			$$$ThrowFHIR($$$HSFHIRErrMissingReferencedType, $Lts(searchColumn.FHIRPath), ..json.resourceType)
		}
		Set targetType = $ListGet(searchColumn.Target,1)
	} else {
		Set targetType = $P(tRefVal, "/", *-1)
		if '$ListFind(searchColumn.Target, targetType) {
			// Not one of the target types for this field. This can happen if multiple search parameters look at
			// a list of references selecting a single type (e.g. Appointment?(practitioner, location, patient)
			Quit
		}
		if pieceCount>2 {
			Set targetURL = tRefVal
		}
	}
	Set targetTypeAndId = targetType _ "/" _ targetId
	
	// For references, index two or three values:
	// -Just the ID (should be the last piece, "/"-delimited)
	// -The entire URL, as it is given (can be relative or absolute)
	// -Just the type and ID (as "[type]/[id]"), but only if different from the URL
	for tValue = targetTypeAndId, targetURL {
		if tValue '= "" {
			do ..AddToSearchTableEntry(searchColumn, tValue)
		}
	}
}

Method IndexString(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Set tValue = value
	If tValue = "" Quit

	If ($Length(tValue) > ..#MAXSEARCHINDEXLEN) {
		$$$FHIRLOGERROR("Value is too long for search index, will be truncated: "_tValue)
		set tValue = $E(tValue,1,..#MAXSEARCHINDEXLEN)
	}
	Do ..AddToSearchTableEntry(searchColumn, tValue)
}

Method IndexAge(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	// Per: http://www.hl7.org/fhir/search.html#token
	// Age is not used in search.  Do nothing
}

Method IndexAttachment(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	// Per: http://www.hl7.org/fhir/search.html#token
	// Attachment is not used in search.  Do nothing
}

Method IndexDuration(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexQuantity(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexLocationPosition(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	// Requires special processing ....
	// No indexing for now
}

Method IndexMoney(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexQuantity(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexTiming(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	// TBD: Should generate a Period style indexing
}

Method IndexBase64Binary(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	// Per: http://www.hl7.org/fhir/search.html#token
	// Base64Binary is not used in search.
}

Method IndexBoolean(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	if value = 1 {
		Do ..AddToSearchTableEntry(searchColumn, value)
		return
	}
}

Method IndexCanonical(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexCode(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexDateTime(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexDate(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexId(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexInstant(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexMarkdown(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexOid(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexUri(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

Method IndexUrl(searchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pColumnPropName As %String, pColumnDataType As %String, value)
{
	Do ..IndexString(searchColumn, pColumnPropName, pColumnDataType, value)
}

}

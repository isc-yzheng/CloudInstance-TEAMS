Include HS.HC

Class HS.FHIR.vCommon.ResourceBase [ Abstract, DependsOn = HS.FHIR.vCommon.StorageUtils ]
{

/// A key useable for disambiguating version-specific cached data
Parameter VERSIONKEY [ Abstract ];

/// The name of the Global used by the subclass (
Parameter INDEXGLOBAL [ Abstract ];

Parameter DATAGLOBAL [ Abstract ];

Parameter STREAMGLOBAL [ Abstract ];

Parameter COUNTERGLOBAL [ Abstract ];

Parameter STORAGEPKG [ Abstract ];

Parameter MODELPACKAGE [ Abstract ];

Parameter HSDEPLOY = 1;

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Comma-delimited list of search params that are defined in the FHIR
/// standard, but that are not currently supported by HealthShare. Each
/// subclass will define its list.
/// The parameter value should start and end with commas. Note that all composite
/// type params are currently not supported and do not need to be included here.
Parameter EXCLUDEPARAMS;

Parameter DEFAULTCHARSACCENTED = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüýÿ";

Parameter DEFAULTCHARSUNACCENTED = "AAAAAACEEEEIIIINOOOOOOUUUUYaaaaaaceeeeiiiinoooooouuuuyy";

Method GetFHIRClass()
{
	if (..ResourceSchema'="")&&(..ResourceType'="") { quit ..ResourceSchema_"."_..ResourceType }
	quit ""
}

Property Session As %String(COLLATION = "EXACT", MAXLEN = 256);

Property ResourceType As %String;

Property ResourceSchema As %String;

Property ResourceString As %String(MAXLEN = "");

Property ResourceStream As %Stream.GlobalCharacter;

Property Resource As %RegisteredObject [ Transient ];

Property ResourceObject As %RegisteredObject [ Transient ];

Property XPathDoc As %XML.XPATH.Document [ Transient ];

Property ResourceId As %String(MAXLEN = 64);

Property VersionId As %Integer;

Property Deleted As %Boolean [ InitialExpression = 0 ];

/// The time that this version of the resource was saved, in UTC.
/// ie, YYYY-MM-DDThh:mm:ssZ. This gets set in <method>SaveStreamlet</method>.
/// No other code should set it.
Property LastModified As %String;

Property Format As %String(VALUELIST = ",XML,JSON");

/// The HTTP verb used in the interaction that created this version of this resource.
/// Needed because the history interaction requires this to be known, and because the
/// first version of a resource can be created with either a POST/create or PUT/update,
/// with no other indication which verb was used.
Property Verb As %String(VALUELIST = ",POST,PUT,DELETE");

Index VersionIdx On (Session, ResourceType, ResourceId, VersionId) [ Data = Deleted, Unique ];

Property Compartments As list Of %String;

Index CompartmentsIdx On Compartments(ELEMENTS);

Property SearchTableEntry As %Persistent [ Transient ];

Property CommonSearchTableEntry As %Persistent [ Transient ];

Parameter SEARCHTABLEPACKAGE [ Abstract ];

/// The name of the table in the search package that will store the searchable
/// values common to all resource types, which will be searched in a
/// "search-all" interaction. Also, the name of the class in the storage
/// package (HS.FHIR.vDSTU2.Repository.Resource) that contains the definitions of the
/// search parameters common to all types in its SearchParams XData block.
Parameter BASERESOURCE = "Resource";

Parameter PERIODSTARTSUFFIX = "Start";

Parameter PERIODENDSUFFIX = "End";

/// Collation type to use<br>
/// Corresponds to arguments to $system.Util.Collation()<br>
/// 7 is SQLUPPER
Parameter COLLATION = 7;

/// The max length value that can be indexed for search. The indices for values
/// longer than this will be truncated. The actual resource data will not be
/// affected though.
Parameter MAXSEARCHINDEXLEN = 220;

/// Streamlet class can implement this callback to perform any logic needed to tweak properties,
/// do defaulting, etc., before we attempt to match to a stored streamlet
Method OnBeforeMatch() As %Status
{
	Quit $$$OK
}

/// Streamlet class can implement this callback to perform validation<br>
/// This is invoked by the SaveStreamlet method before the streamlet is physically saved.
Method OnValidate() As %Status
{
	Quit $$$OK
}

/// Streamlet class can implement this callback to perform some action after the streamlet has
/// been saved. Note that this can't change the streamlet at all as it's already been saved.
Method OnAfterSave() As %Status
{
	Quit $$$OK
}

/// GetStorageClass returns the name of the individual resource type storage class that
/// holds the resource type-specific search parameter definitions and resource type-specific
/// indexing logic. The default package of storage classes that ship with the product is
/// specified by STORAGEPKG. A custom storage package to be used instead of STORAGEPKG may
/// be specified by passing in a value for the pCustomStoragePkg input parameter.
ClassMethod GetStorageClass(pType As %String, ByRef pSC As %Status, pCustomStoragePkg As %String) As %String
{
	try {
		set pSC = $$$OK
		set tStorageClass = ""
		if (pType [ ".") { set pSC = $$$ERROR($$$GeneralError, "Invalid resource type (contains "".""): "_pType) quit }
		
		if $Get(pCustomStoragePkg)'="" {
			if $Extract(pCustomStoragePkg,*)'="." set pCustomStoragePkg = pCustomStoragePkg_"."
			if $$$defClassDefined(pCustomStoragePkg_pType) set tStorageClass = pCustomStoragePkg_pType
		}
		if tStorageClass="" {
			if ($$$defClassDefined(..#STORAGEPKG_pType)) {
				set tStorageClass = ..#STORAGEPKG_pType
			} else {
				set pSC = $$$ERROR($$$GeneralError, "Storage class not found for resource type "_pType)
			}
		}
	}
	catch (ex) { set pSC = ex.AsStatus() }
	quit tStorageClass
}

ClassMethod GetStorageClassFromLogicalId(pLogicalId) As %String
{
	if ($D(@..#DATAGLOBAL@(pLogicalId))) {
		set tClass = $LG(@..#DATAGLOBAL@(pLogicalId), 1)
		// The stored value has "~" added to the beginning and end
		set tClass = $E(tClass,2,*-1)
	}
	else { set tClass = "" }
	quit tClass
}

/// GenerateResourceId returns a resource id to use for
/// the specified resource type.
ClassMethod GenerateResourceId(pResourceType As %String, pSession As %String = "") As %String
{
	#; Reference an index to get the next available integer
	#; value for the specified FHIR resource type.
	Set tId = ""
	Lock +@..#COUNTERGLOBAL@(0,pResourceType)
	Do {
		Set tId = $i(@..#COUNTERGLOBAL@(0,pResourceType))
	}
	While (..ResourceExists(pSession, pResourceType, tId))
	Lock -@..#COUNTERGLOBAL@(0,pResourceType)
	
	Quit tId
}

Method SetResourceId() As %Status
{
	try {
		set tSC = $$$OK
		set tId = ..GenerateResourceId(..ResourceType,..Session)
		set tSC = ##class(HS.FHIR.Utils).UpdateResourceId(..ResourceObject, tId) quit:$$$ISERR(tSC)
		set ..ResourceId = tId
	}
	catch (ex) { set tSC = ex.AsStatus() }	
	Quit tSC
}

/// Given a session, resource type, resource ID, and optionally a version ID, this method will return
/// the logical (object) ID of that version of the resource in the given session.<br>
/// pType must be a valid resource type. This method will not validate it.<br>
/// pResourceId must not be null.<br>
/// If pVersionId is null, the Logical ID of the current version will be returned.<br>
/// If there is no resource in the repository with the given type and resource ID in (and<br>
/// version ID, if given) in the given session, this method will return "" (null).
ClassMethod ResourceToLogicalId(pSession As %String, pType As %String, pResourceId As %String, pVersionId = "") As %String
{
	// If pVersionId is null, use the version ID of the current version
	if (pVersionId="") { set pVersionId = ..CurrentVersion(pSession, pType, pResourceId) }
	if (pVersionId="") { quit "" }
	// Logical ID is the next subscript in VersionIdx
	quit $O(@..#INDEXGLOBAL@("VersionIdx",..CollateSession(pSession),..Collate(pType),..Collate(pResourceId),pVersionId,""))
}

/// Given a session, resource type, resource ID, and optionally a version ID, this method will return
/// true if that version of the resource is "deleted", and false otherwise. (Not physically deleted,
/// but rather marked deleted with the "delete" interaction.)<br>
/// pType must be a valid resource type. This method will not validate it.<br>
/// pResourceId must not be null.<br>
/// If pVersionId is null, the deleted status of the current version will be returned.
ClassMethod ResourceIsDeleted(pSession As %String, pType As %String, pResourceId As %String, pVersionId = "") As %Boolean
{
	// If pVersionId is null, use the version ID of the current version
	if (pVersionId="") { set pVersionId = ..CurrentVersion(pSession, pType, pResourceId) }
	// Logical ID is the next subscript in VersionIdx
	set tLogicalId = $O(@..#INDEXGLOBAL@("VersionIdx",..CollateSession(pSession),..Collate(pType),..Collate(pResourceId),pVersionId,""))
	// The value of a node in VersionIdx is Deleted
	quit $LG(@..#INDEXGLOBAL@("VersionIdx",..CollateSession(pSession),..Collate(pType),..Collate(pResourceId),pVersionId,tLogicalId), 2)
}

/// Returns true if a resource of the given type with the given resource ID
/// (not logical ID) exists in the given session, even if it is currently marked as deleted, and false otherwise.
ClassMethod ResourceExists(pSession As %String, pType As %String, pResourceId As %String) As %Boolean
{
	quit $D(@..#INDEXGLOBAL@("VersionIdx", ..CollateSession(pSession), ..Collate(pType), ..Collate(pResourceId)))
}

/// Returns true if the resource with the given type and resource ID has a version with
/// version ID matching pVersion, and false otherwise.<br>
/// Also, if there is no resource of the given type and resource ID, false will be returned.
ClassMethod VersionExists(pSession As %String, pType As %String, pResourceId As %String, pVersion As %Integer) As %Boolean
{
	quit $D(@..#INDEXGLOBAL@("VersionIdx", ..CollateSession(pSession), ..Collate(pType), ..Collate(pResourceId),pVersion))
}

/// Returns the current (most recent) version ID of the resource with the given
/// type and ID in the given session, or "" if there is no such resource.
ClassMethod CurrentVersion(pSession As %String, pType As %String, pResourceId As %String) As %String
{
	if (pType="")||(pResourceId="") { quit "" }
	quit $O(@..#INDEXGLOBAL@("VersionIdx", ..CollateSession(pSession), ..Collate(pType), ..Collate(pResourceId), ""),-1)
}

Method IndexValues() As %Status
{
	try {
		set tSC = $$$OK
		
		set tOriginalFormat = ..Format
		set tOriginalResourceObject = ..ResourceObject
		
		#dim ExtensionClass As %String = "Extension"
		#dim HumanNameClass As %String = "HumanName"
		#dim AddressClass As %String = "Address"
		#dim CodeableConceptClass As %String = "CodeableConcept"
		#dim CodingClass As %String = "Coding"
		#dim CodeClass As %String = "Code"
		#dim ContactPointClass As %String = "ContactPoint"
		#dim IdentifierClass As %String = "Identifier"
		#dim PeriodClass As %String = "Period"
		
		// %DynamicObject for JSON performs better than the XML-based tools, at least
		// in this context. Use it for the basis of indexing when possible. If
		// complex predicates are used by this resource type, use XML so that
		// %XML.XPATH.Document can properly evaluate the XPaths.
		set tComplexPredicate = $Get(%HSFHIRSearchParams(..#VERSIONKEY, ..%ClassName(), 0))
		if 'tComplexPredicate {
			if ..Format="XML" {
				set tSC = ##class(HS.FHIR.Utils).XMLDocumentToDynamicObject(..ResourceObject, ..ResourceSchema, .tJSONObject)
				if $$$ISERR(tSC) quit
				set ..ResourceObject = tJSONObject
				set ..Format = "JSON"
			}
		} else {
			set tXMLStream = ##class(%Stream.TmpCharacter).%New()
			if ..Format="JSON" {
				set tSC = ##class(HS.FHIR.Utils).JSONDynamicObjectToXML(..ResourceObject, .tXMLStream, ..ResourceSchema)
				if $$$ISERR(tSC) quit
				set ..Format = "XML"
			} else {
				do ..GetResourceAsStream(.tXMLStream)
			}
			set tSC = ##class(HS.FHIR.Utils).GetFHIRXPathDocFromXMLStream(tXMLStream, .tXPathDocument)
			if $$$ISERR(tSC) quit
			set ..XPathDoc = tXPathDocument
		}
		
		// In case this is a "re-index", clear Compartments.
		do ..Compartments.Clear()

		set tSearchTableName = ..#SEARCHTABLEPACKAGE_"."_..ResourceType
		// Assert that the search table exists
		if ('$$$defClassDefined(tSearchTableName)) { quit }
		// The search table entry has to be %Saved before we start to populate it, since we could
		// create entries in other tables with foreign keys that reference the search table.
		// And before we can %Save the search table entry, we have to delete the existing entry
		// for this resource, if there is one.
		if $CLASSMETHOD(tSearchTableName, "%ExistsId", ..%Id()) {
			set tSC = $CLASSMETHOD(tSearchTableName, "%DeleteId", ..%Id()) quit:$$$ISERR(tSC)
		}
		set ..SearchTableEntry = $CLASSMETHOD(tSearchTableName, "%New")
		do ..SearchTableEntry.ResourceLogicalIdSetObjectId(..%Id())
		set tSC = ..SearchTableEntry.%Save() quit:$$$ISERR(tSC)
		
		set tCommonSearchTableName = ..#SEARCHTABLEPACKAGE_"."_..#BASERESOURCE
		if $CLASSMETHOD(tCommonSearchTableName, "%ExistsId", ..%Id()) {
			set tSC = $CLASSMETHOD(tCommonSearchTableName, "%DeleteId", ..%Id()) quit:$$$ISERR(tSC)
		}
		set ..CommonSearchTableEntry = $CLASSMETHOD(tCommonSearchTableName, "%New")
		do ..CommonSearchTableEntry.ResourceLogicalIdSetObjectId(..%Id())
			
		// Make sure search param info is cached in %HSFHIRSearchParams if not already.
		set tSC = ..CacheSearchParams(..ResourceType) quit:$$$ISERR(tSC)
		// Then actually create the search indices.
		for tClassName=..#BASERESOURCE,..%ClassName() {
			set tParamName = 0
			for {
				// See CacheSearchParams(). The format of %HSFHIRSearchParams is:
				// %HSFHIRSearchParams(..#VERSIONKEY, resourceType,0) = resource type includes an XPath with complex predicate (0 or 1) (0 or 1)
				// An XPath is considered to have a "complex predicate" if either the predicate is not in the last piece of
				// the XPath, or there are multiple predicates.<br/>
				// %HSFHIRSearchParams(..#VERSIONKEY, resourceType,searchParam) = paramType^xpath^refType1~refType2~...~^custom
				set tParamName = $O(%HSFHIRSearchParams(..#VERSIONKEY, tClassName,tParamName),1,d) quit:tParamName=""
				set tParamType = $P(d, "^", 1)
				set tXPath = $P(d, "^", 2)
				set tRefTypes = $P(d, "^", 3)
				set tCustom = $P(d, "^", 4)
				set tResultType = $P(d, "^", 5)
				
				// If %HSFHIRSearchParams indicates that there is a special method to create the indices for
				// this search param, invoke it instead of the usual processing.
				if (tCustom) {
					set tSC = $METHOD(,..NormalizeParamName(.tParamName))
					if ($$$ISERR(tSC)) { $$$LOGERROR("Error creating search indices (manual) for param """_tParamName_""": "_$system.Status.GetOneErrorText(tSC)) }
					continue
				}
				// Otherwise process the search param normally.
				for tI=1:1:$L(tXPath,"|") {
					set tOneXPath = $ZSTRIP($P(tXPath, "|", tI), "<>W")
					if ($P(tOneXPath,"/")="f:Resource") { set $P(tOneXPath,"/") = "f:"_..ResourceType }
					set tOneResultType = $ZSTRIP($P(tResultType, "|", tI), "<>W")
					if (tOneResultType="") { $$$LOGERROR("Error getting type for XPath """_tOneXPath_""": "_$system.Status.GetOneErrorText(tSC)) continue }
					// We only care about the last piece of the result type
					set tOneResultTypeShort = $P(tOneResultType, ".", *)
					
					set tIndexValues = ""
					if (tParamType="token") {
						set tMethod = $CASE(tOneResultTypeShort,
										CodeableConceptClass:"IndexCodeableConcept",
										CodingClass:"IndexCoding",
										//CodeClass:"IndexCode",
										IdentifierClass:"IndexIdentifier",
										ContactPointClass:"IndexContactPoint",
										:"IndexScalar")
					}
					elseif (tParamType="string") {
						set tMethod = $CASE(tOneResultTypeShort,
										HumanNameClass:"IndexHumanName",
										AddressClass:"IndexAddress",
										:"IndexScalar")
					}
					elseif (tParamType="date") {
						set tMethod = $SELECT(tOneResultTypeShort=PeriodClass:"IndexPeriod",
											..ParamSearchesPeriod(..ResourceType,tParamName):"IndexDateAsPeriod",
											1:"IndexDate")
					}
					elseif (tParamType="reference") {
						set tMethod = "IndexReference"
					}
					elseif (tParamType="number") {
						set tMethod = "IndexNumber"
					}
					elseif (tParamType="quantity") {
						set tMethod = "IndexQuantity"
					}
					elseif (tParamType="uri") {
						set tMethod = "IndexScalar"
					}
					
					set tSC = $METHOD(,tMethod, .tParamName, .tOneXPath)
					if ($$$ISERR(tSC))&& (tParamName '= "_lastUpdated") { 
						$$$LOGERROR("Error creating search indices for param """_tParamName_""": "_$system.Status.GetOneErrorText(tSC))
						continue
					}
				}
			}
		}
		
		set tSC = ..SearchTableEntry.%Save() quit:$$$ISERR(tSC)
		set tSC = ..CommonSearchTableEntry.%Save() quit:$$$ISERR(tSC)
	}
	catch (ex) { set tSC = ex.AsStatus() }
	if ..Format'=tOriginalFormat {
		set ..Format = tOriginalFormat
		set ..ResourceObject = tOriginalResourceObject
		kill tJSONObject
		kill tJSONStream
	}
	if $get(tComplexPredicate) kill tXMLStream
	Quit tSC
}

Method IndexAddress(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				If tResults(tI)="" Continue
				Set tAddress = tResults(tI)
				if (tAddress.text'="") { set tValue = tAddress.text }
				else {
					set tValue = ""
					if $IsObject(tAddress.line) {
						set tIterator = tAddress.line.%GetIterator()
						for {
							If 'tIterator.%GetNext(.tPropName, .tData) Quit
							If tData="" Continue
							Set tValue = tValue_$S(tValue="":"", 1:" ")_tData
						}
					}
					for tAddressPart=tAddress.city,tAddress.state,tAddress.postalCode,tAddress.country {
						if (tAddressPart'="") { set tValue = tValue_$S(tValue="":"", 1:" ")_tAddressPart }
					}
				}
				Continue:tValue=""
				set tSC = ..AddToSearchTableEntry(.pParamName, .tValue)
				quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		quit:$$$ISERR(tSC)
		// For each Address, create an index from either the "text" property if
		// not null, or a concatenation of the other properties if it is.
		for tI=1:1:tResults.Count() {
			set tAddress = tResults.GetAt(tI)
			if (tAddress.text.value'="") { set tValue = tAddress.text.value }
			else {
				set tValue = ""
				for tJ=1:1:tAddress.line.Count() {
					set tAddressPart = tAddress.line.GetAt(tJ).value
					continue:tAddressPart=""
					set tValue = tValue_$S(tValue="":"", 1:" ")_tAddressPart
				}
				for tAddressPart=tAddress.city.value,tAddress.state.value,tAddress.postalCode.value,tAddress.country.value {
					if (tAddressPart'="") { set tValue = tValue_$S(tValue="":"", 1:" ")_tAddressPart }
				}
			}
			continue:tValue=""
			set tSC = ..AddToSearchTableEntry(.pParamName, .tValue) quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexCoding(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				If tResults(tI)="" Continue
				Set tCoding = tResults(tI)
				If tCoding.code="" Continue
				set tSC = ..AddToSearchTableEntry(.pParamName, tCoding.code) quit:$$$ISERR(tSC)
				set tSC = ..AddToSearchTableEntry(.pParamName, tCoding.system_"|"_tCoding.code) quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		if $$$ISERR(tSC) quit
		// For each Coding, create two indices, one for "code", and and for "system|code"
		for tI=1:1:tResults.Count() {
			set tCoding = tResults.GetAt(tI)
			continue:tCoding.code.value=""
			set tSC = ..AddToSearchTableEntry(pParamName, tCoding.code.value) quit:$$$ISERR(tSC)
			set tSC = ..AddToSearchTableEntry(pParamName, tCoding.system.value_"|"_tCoding.code.value) quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexCodeableConcept(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				If tResults(tI)="" Continue
				Set tCodeableConcept = tResults(tI)
				If tCodeableConcept.coding="" Continue
				// coding is a collection, and for each one, create two indices, one for "code", and and for "system|code"
				Set tIterator = tCodeableConcept.coding.%GetIterator()
				For {
					If 'tIterator.%GetNext(.tPropName, .tData) Quit
					If tData="" Continue
					If tData.code="" Continue
					set tSC = ..AddToSearchTableEntry(.pParamName, tData.code) quit:$$$ISERR(tSC)
					set tSC = ..AddToSearchTableEntry(.pParamName, tData.system_"|"_tData.code) quit:$$$ISERR(tSC)				
				}
			}
			quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		if $$$ISERR(tSC) quit
		for tI=1:1:tResults.Count() {
			set tCodeableConcept = tResults.GetAt(tI)
			// coding is a collection, and for each one, create two indices, one for "code", and and for "system|code"
			for tJ=1:1:tCodeableConcept.coding.Count() {
				set tCoding = tCodeableConcept.coding.GetAt(tJ)
				continue:tCoding.code.value=""
				set tSC = ..AddToSearchTableEntry(pParamName, tCoding.code.value) quit:$$$ISERR(tSC)
				set tSC = ..AddToSearchTableEntry(pParamName, tCoding.system.value_"|"_tCoding.code.value) quit:$$$ISERR(tSC)				
			}
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexContactPoint(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Kill tResults
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				set tContactPoint = tResults(tI)
				continue:tContactPoint=""
				set tValue = tContactPoint.value
				continue:tValue=""
				// According to the spec (http://www.hl7.org/fhir/DSTU2/search.html#token),
				// and According to the spec (http://www.hl7.org/fhir/STU3/search.html#token),
				// "The use is prepended by http://hl7.org/fhir/contact-point-system/"
				if (tContactPoint.system'="") { set tSystem = tContactPoint.system_"-"_tContactPoint.use }
				else { set tSystem = tContactPoint.use }
				for tTableValue = tValue, tSystem_"|"_tValue {
					do ..AddToSearchTableEntry(.pParamName, .tTableValue)
				}
				// The spec doesn't say to do this, but as a matter of practicality, if the value
				// is a phone number, we will also index (and therefore allow to be searched on)
				// a normalized version (whitespace and punctuation stripped) of the value.
				if (",phone,fax,pager,sms," [ (","_tContactPoint.system_",")) {
					set tValueNormalized = ..NormalizePhone(tValue)
					if (tValueNormalized '= tValue) {
						for tTableValue = tValueNormalized, tSystem_"|"_tValueNormalized {
							do ..AddToSearchTableEntry(.pParamName, .tTableValue)
						}
					}
				}
			}
			quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		if $$$ISERR(tSC) quit
		// For each ContactPoint, create two indices, one for "value", and and for "system-use|value"
		for tI=1:1:tResults.Count() {
			set tContactPoint = tResults.GetAt(tI)
			set tValue = tContactPoint.value.value
			continue:tValue=""
			// According to the spec (http://www.hl7.org/fhir/DSTU2/search.html#token),
			// and According to the spec (http://www.hl7.org/fhir/STU3/search.html#token),
			// "The use is prepended by http://hl7.org/fhir/contact-point-system/"
			if (tContactPoint.system.value'="") { set tSystem = tContactPoint.system.value_"-"_tContactPoint.use.value }
			else { set tSystem = tContactPoint.use.value }
			for tTableValue = tValue, tSystem_"|"_tValue {
				do ..AddToSearchTableEntry(pParamName, tTableValue)
			}
			// The spec doesn't say to do this, but as a matter of practicality, if the value
			// is a phone number, we will also index (and therefore allow to be searched on)
			// a normalized version (whitespace and punctuation stripped) of the value.
			if (",phone,fax,pager,sms," [ (","_tContactPoint.system.value_",")) {
				set tValueNormalized = ..NormalizePhone(tValue)
				if (tValueNormalized '= tValue) {
					for tTableValue = tValueNormalized, tSystem_"|"_tValueNormalized {
						do ..AddToSearchTableEntry(pParamName, tTableValue)
					}
				}
			}			
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexDate(pParamName As %String, pXPath As %String) As %Status
{
	try {
		set tSC = $$$OK
		
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				set tValue = tResults(tI)
				continue:tValue=""
				if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) { 
					s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
				}
				set tSC = ..AddToSearchTableEntry(.pParamName, .tValue)
				quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tXPathSuffix = "/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath_tXPathSuffix, ..ResourceSchema, .tResultType, .tResults)
		if $$$ISERR(tSC) quit
		for tI=1:1:tResults.Count() {
			set tValue = tResults.GetAt(tI)
			continue:tValue=""
			if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) { 
				s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
			}
			set tSC = ..AddToSearchTableEntry(pParamName, tValue)
			quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexDateAsPeriod(pParamName As %String, pXPath As %String) As %Status
{
	try {
		set tSC = $$$OK
		
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				set tValue = tResults(tI)
				continue:tValue=""
				// If the value has a time then convert to UTC.
				if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
					s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
				}
				do ..AddToSearchTableEntry(pParamName_..#PERIODSTARTSUFFIX, ..FirstInstant(tValue))
				do ..AddToSearchTableEntry(pParamName_..#PERIODENDSUFFIX, ..LastInstant(tValue))
				
				// Presently we can only index on a single period per search param,
				//  even for those that include collections in their xpath values.
				// TO DO: fix this. Will probably require a fundamental change to
				// how periods are indexed and searched on.
				quit
			}
			quit
		}
		
		// The value being indexed is not a period, but this search parameter does search periods,
		// so in the search table this value will be formatted as a period, ie, implicit start and
		// end will be mapped to explicit start and end.
		set tXPathSuffix = "/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath_tXPathSuffix, ..ResourceSchema, .tResultType, .tResults)
		quit:$$$ISERR(tSC)
		for tI=1:1:tResults.Count() {
			set tValue = tResults.GetAt(tI)
			continue:tValue=""
			// If the value has a time then convert to UTC.
			if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
				s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
			}
			do ..AddToSearchTableEntry(pParamName_..#PERIODSTARTSUFFIX, ..FirstInstant(tValue))
			do ..AddToSearchTableEntry(pParamName_..#PERIODENDSUFFIX, ..LastInstant(tValue))
			
			// Presently we can only index on a single period per search param,
			//  even for those that include collections in their xpath values.
			// TO DO: fix this. Will probably require a fundamental change to
			// how periods are indexed and searched on.
			quit
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexHumanName(pParamName As %String, pXPath As %String) As %Status [ Abstract ]
{
	// Code varies by FHIR version, must be overridden by a subclass
}

/// This method differs from DSTU2 to STU3, it must be overridden in the subclass
Method IndexIdentifier(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				set tIdentifier = tResults(tI)
				continue:tIdentifier=""
				set tSC = ..AddToSearchTableEntry(.pParamName, tIdentifier.value) quit:$$$ISERR(tSC)
				set tSC = ..AddToSearchTableEntry(.pParamName, tIdentifier.system_"|"_tIdentifier.value) quit:$$$ISERR(tSC)			
			}
			quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		quit:$$$ISERR(tSC)
		// For each Identifier, create two indices, one for "value", and and for "system|value"
		for tI=1:1:tResults.Count() {
			set tIdentifier = tResults.GetAt(tI)
			set tSC = ..AddToSearchTableEntry(pParamName, tIdentifier.value.value) quit:$$$ISERR(tSC)
			set tSC = ..AddToSearchTableEntry(pParamName, tIdentifier.system.value_"|"_tIdentifier.value.value) quit:$$$ISERR(tSC)			
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexNumber(pParamName As %String, pXPath As %String) As %Status
{
	try {
		set tSC = $$$OK
		
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				set tValue = tResults(tI)
				continue:tValue=""
				set tSC = ..AddToSearchTableEntry(.pParamName, .tValue)
				quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tXPathSuffix = "/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath_tXPathSuffix, ..ResourceSchema, .tResultType, .tResults)
		if $$$ISERR(tSC) quit
		for tI=1:1:tResults.Count() {
			set tValue = tResults.GetAt(tI)
			continue:tValue=""
			set tSC = ..AddToSearchTableEntry(pParamName, tValue)
			quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexPeriod(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				Set tPeriod = tResults(tI)
				If tPeriod="" Continue
				if (tPeriod.start="")&&(tPeriod.end="") { continue }
				
				set tValue = tPeriod.start
				// If the value has a time then convert to UTC.
				if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
					s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
				}
				// No start value -> Use year 0 as start value
				if (tValue="") { set tValue = 0 }
				set tSC = ..AddToSearchTableEntry(pParamName_..#PERIODSTARTSUFFIX, .tValue)
				quit:$$$ISERR(tSC)
				
				set tValue = tPeriod.end
				// If the value has a time then convert to UTC.
				if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
					s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
				}
				// No end value -> Use year 9999 as end value
				if (tValue="") { set tValue = 9999 }
				set tSC = ..AddToSearchTableEntry(pParamName_..#PERIODENDSUFFIX, .tValue)
				quit:$$$ISERR(tSC)
				
				// Presently we can only index on a single period per search param,
				//  even for those that include collections in their xpath values.
				// TO DO: fix this. Will probably require a fundamental change to
				// how periods are indexed and searched on.
				quit
			}
			quit
		}
		
		// The XPath points to the period property. We want the start and end values
		//  of the period so they can be indexed separately.
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		quit:$$$ISERR(tSC)
		for tI=1:1:tResults.Count() {
			set tPeriod = tResults.GetAt(tI)
			// The period must have a start or an end to be indexed.
			if (tPeriod.start.value="")&&(tPeriod.end.value="") { continue }
			
			set tValue = tPeriod.start.value
			// If the value has a time then convert to UTC.
			if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
				s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
			}
			// No start value -> Use year 0 as start value
			if (tValue="") { set tValue = 0 }
			set tSC = ..AddToSearchTableEntry(pParamName_..#PERIODSTARTSUFFIX, tValue)
			quit:$$$ISERR(tSC)
			
			set tValue = tPeriod.end.value
			// If the value has a time then convert to UTC.
			if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N.E) {
				s tValue = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
			}
			// No end value -> Use year 9999 as end value
			if (tValue="") { set tValue = 9999 }
			set tSC = ..AddToSearchTableEntry(pParamName_..#PERIODENDSUFFIX, tValue)
			quit:$$$ISERR(tSC)
			
			// Presently we can only index on a single period per search param,
			//  even for those that include collections in their xpath values.
			// TO DO: fix this. Will probably require a fundamental change to
			// how periods are indexed and searched on.
			quit
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexQuantity(pParamName As %String, pXPath As %String) As %Status
{
	try {
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				If tResults(tI)="" Continue
				set tQuantity = tResults(tI)
				quit:tQuantity.value=""
				// Indexed values are:
				//   value=value, unit=system|code (system may be null)
				//   value=value, unit=|code
				//   value=value, unit=|unit (if different from code)
				// Where system, code, and unit are properties of the unit of measure
				
				// Quantities are stored in a separate table the references the main search table via a foreign key.
				set tQuantityClassName = ..#SEARCHTABLEPACKAGE_"."_..ResourceType_"."_..NormalizeParamName(.pParamName)
				set tQuantityObj = $CLASSMETHOD(tQuantityClassName,"%New")
				set tQuantityObj.ResourceLogicalId = ..%Id()
				set tQuantityObj.value = tQuantity.value

				if (tQuantity.code '= "") {
					do tQuantityObj.unit.Insert("|"_tQuantity.code)
				}
				if (tQuantity.unit '= "")&&(tQuantity.unit '= tQuantity.code) {
					do tQuantityObj.unit.Insert("|"_tQuantity.unit)
				}
				// We only need to add another unit if the system is not null, otherwise it
				// would be the same as the "|code" unit created above.
				if (tQuantity.system'="") {
					do tQuantityObj.unit.Insert(tQuantity.system_"|"_tQuantity.code)
				}
				set tSC = tQuantityObj.%Save()
				quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath, ..ResourceSchema, .tResultType, .tResults)
		quit:$$$ISERR(tSC)
		for tI=1:1:tResults.Count() {
			set tQuantity = tResults.GetAt(tI)
			quit:tQuantity.value.value=""
			// Indexed values are:
			//   value=value, unit=system|code (system may be null)
			//   value=value, unit=|code
			//   value=value, unit=|unit (if different from code)
			// Where system, code, and unit are properties of the unit of measure
			
			// Quantities are stored in a separate table the references the main search table via a foreign key.
			set tQuantityClassName = ..#SEARCHTABLEPACKAGE_"."_..ResourceType_"."_..NormalizeParamName(.pParamName)
			set tQuantityObj = $CLASSMETHOD(tQuantityClassName,"%New")
			set tQuantityObj.ResourceLogicalId = ..%Id()
			set tQuantityObj.value = tQuantity.value.value

			if (tQuantity.code.value '= "") {
				do tQuantityObj.unit.Insert("|"_tQuantity.code.value)
			}
			if (tQuantity.unit.value '= "")&&(tQuantity.unit.value '= tQuantity.code.value) {
				do tQuantityObj.unit.Insert("|"_tQuantity.unit.value)
			}
			// We only need to add another unit if the system is not null, otherwise it
			// would be the same as the "|code" unit created above.
			if (tQuantity.system.value'="") {
				do tQuantityObj.unit.Insert(tQuantity.system.value_"|"_tQuantity.code.value)
			}
			set tSC = tQuantityObj.%Save()
			quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexReference(pParamName As %String, pXPath As %String) As %Status
{
	try {
		set tSC = $$$OK
		
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				If tResults(tI)="" Continue
				Set tRefVal = tResults(tI).reference
				If $Extract(tRefVal)="#" Continue
				// Check whether the reference value is of the right type to be indexed
				// and searched by this param.
				set tRefType = $P(tRefVal, "/", *-1)
				if (tRefType'="") {
					if ('..RefMatchesSearchParam(..ResourceType, .pParamName, .tRefType)) { continue }
				}
				// For references, index two or three values:
				// -Just the ID (should be the last piece, "/"-delimited)
				// -The entire URL, as it is given (can be relative or absolute)
				// -Just the type and ID (as "[type]/[id]"), but only if different from the URL
				for tValue = $P(tRefVal,"/",*), tRefVal {
					do ..AddToSearchTableEntry(.pParamName, .tValue)
				}
				if ($L(tRefVal,"/") > 2) {
					set tValue = $P(tRefVal,"/",*-1,*)
					do ..AddToSearchTableEntry(.pParamName, .tValue)
				}
				// In addition to indexing this value for search, also determine if this value places
				// the current resource in a compartment, and if so, put a reference to that compartment
				// in "Compartments".
				// Only do this if the reference value includes the type of the referenced resource.
				if ($L(tRefVal,"/") > 1) {
					set tVal = $P(tRefVal,"/",*-1,*)
					if (..IsCompartment(tRefType, ..ResourceType, pParamName)) {
						// The resource has already been %Saved. To prevent having to do this again,
						// manipulate the storage and index globals directly.
						set tValCollated = $system.Util.Collation(tVal,7)
						set tLogicalId = ..%Id()
						// Check whether Compartments already contains this value by checking the index.
						if ('$D(@..#INDEXGLOBAL@("CompartmentsIdx",tValCollated,tLogicalId))) {
							// The Compartments property is a $LIST
							set tCompartments = $LG(@..#DATAGLOBAL@(tLogicalId),10)
							// If Compartments is empty, it will be indexed as " ". Kill this.
							if ($LL(tCompartments)=0) {	kill @..#INDEXGLOBAL@("CompartmentsIdx"," ",tLogicalId) }
							set tCompartments = tCompartments_$LB(tVal)
							set $LIST(@..#DATAGLOBAL@(tLogicalId),10) = tCompartments
							set @..#INDEXGLOBAL@("CompartmentsIdx",tValCollated,tLogicalId) = "~"_..%ClassName(1)_"~"
						}
					}
				}
				quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tXPathSuffix = "/f:reference/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath_tXPathSuffix, ..ResourceSchema, .tResultType, .tResults)
		if $$$ISERR(tSC) quit
		set pValues = ""
		for tI=1:1:tResults.Count() {
			set tRefVal = tResults.GetAt(tI)
			quit:tRefVal=""
			// By default, contained reference values are not searchable:
			//     http://www.hl7.org/fhir/DSTU2/search.html#contained
			//     http://www.hl7.org/fhir/STU3/search.html#contained
			quit:$E(tRefVal)="#"
			// Check whether the reference value is of the right type to be indexed
			// and searched by this param.
			set tRefType = $P(tRefVal, "/", *-1)
			if (tRefType'="") {
				if ('..RefMatchesSearchParam(..ResourceType, pParamName, tRefType)) { continue }
			}
			// For references, index two or three values:
			// -Just the ID (should be the last piece, "/"-delimited)
			// -The entire URL, as it is given (can be relative or absolute)
			// -Just the type and ID (as "[type]/[id]"), but only if different from the URL
			for tValue = $P(tRefVal,"/",*), tRefVal {
				do ..AddToSearchTableEntry(pParamName, tValue)
			}
			if ($L(tRefVal,"/") > 2) {
				set tValue = $P(tRefVal,"/",*-1,*)
				do ..AddToSearchTableEntry(pParamName, tValue)
			}
			// In addition to indexing this value for search, also determine if this value places
			// the current resource in a compartment, and if so, put a reference to that compartment
			// in "Compartments".
			// Only do this if the reference value includes the type of the referenced resource.
			if ($L(tRefVal,"/") > 1) {
				set tVal = $P(tRefVal,"/",*-1,*)
				if (..IsCompartment(tRefType, ..ResourceType, pParamName)) {
					// The resource has already been %Saved. To prevent having to do this again,
					// manipulate the storage and index globals directly.
					set tValCollated = $system.Util.Collation(tVal,7)
					set tLogicalId = ..%Id()
					// Check whether Compartments already contains this value by checking the index.
					if ('$D(@..#INDEXGLOBAL@("CompartmentsIdx",tValCollated,tLogicalId))) {
						// The Compartments property is a $LIST
						set tCompartments = $LG(@..#DATAGLOBAL@(tLogicalId),10)
						// If Compartments is empty, it will be indexed as " ". Kill this.
						if ($LL(tCompartments)=0) {	kill @..#INDEXGLOBAL@("CompartmentsIdx"," ",tLogicalId) }
						set tCompartments = tCompartments_$LB(tVal)
						set $LIST(@..#DATAGLOBAL@(tLogicalId),10) = tCompartments
						set @..#INDEXGLOBAL@("CompartmentsIdx",tValCollated,tLogicalId) = "~"_..%ClassName(1)_"~"
					}
				}
			}
			quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method IndexScalar(pParamName As %String, pXPath As %String) As %Status
{
	try {
		set tSC = $$$OK
		
		if (..Format="JSON") {
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .pXPath, .tResults)
			For tI = 1:1:tResults {
				set tValue = tResults(tI)
				continue:tValue=""
				If ($Length(tValue) > ..#MAXSEARCHINDEXLEN) {
					$$$LOGWARNING("Value is too long for search index, will be truncated: "_tValue)
					set tValue = $E(tValue,1,..#MAXSEARCHINDEXLEN)
				}
				set tSC = ..AddToSearchTableEntry(.pParamName, .tValue)
				quit:$$$ISERR(tSC)
			}
			quit
		}
		
		set tXPathSuffix = "/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, pXPath_tXPathSuffix, ..ResourceSchema, .tResultType, .tResults)
		if $$$ISERR(tSC) quit
		for tI=1:1:tResults.Count() {
			set tValue = tResults.GetAt(tI)
			continue:tValue=""
			if ($L(tValue) > ..#MAXSEARCHINDEXLEN) {
				$$$LOGWARNING("Value is too long for search index, will be truncated: "_tValue)
				set tValue = $E(tValue,1,..#MAXSEARCHINDEXLEN)
			}
			set tSC = ..AddToSearchTableEntry(pParamName, tValue)
			quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod EvaluateXPathDynamicObj(pData As %Library.DynamicObject, pXPath As %String, ByRef pResults As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// Remove the previous property level.
		Set tRightBracketCount = 0
		Set tLeftBracketCount = 0
		For tPos = 1:1:$Length(pXPath) {
			Set tChar = $Extract(pXPath,tPos)
			If (tChar="/")&&(tRightBracketCount=tLeftBracketCount) Quit
			If tChar="[" {
				If $i(tLeftBracketCount)
			} ElseIf tChar="]" {
				If $i(tRightBracketCount)
			}
		}
		Set pXPath = $Extract(pXPath, tPos+1, *)
		If pXPath="" Quit
		
		// Now get to the end of the current property and possible predicate.
		Set tRightBracketCount = 0
		Set tLeftBracketCount = 0
		For tPos = 1:1:$Length(pXPath) {
			Set tChar = $Extract(pXPath,tPos)
			If (tChar="/")&&(tRightBracketCount=tLeftBracketCount) Quit
			If tChar="[" {
				If $i(tLeftBracketCount)
			} ElseIf tChar="]" {
				If $i(tRightBracketCount)
			}
		}
		
		// Make a note of whether there is another level to the XPATH expression,
		// and if the next level of the expression specifies FHIR extension.
		Set tExtensionIsNext = 0
		Set tTheRest = $Extract(pXPath, tPos+1, *)
		If $Piece(tTheRest,"[",1)="f:extension" Set tExtensionIsNext = 1
		
		If $Extract(pXPath, tPos)="/" Set tPos = tPos-1
		Set tPropName = $Extract(pXPath, 1, tPos)
		
		If tPropName[":" Set tPropName = $Piece(tPropName, ":", 2, 99)
		
		Set tPredicate = ""
		
		//Check for a predicate on this level of the XPATH expression.
		If tPropName["[" {
			Set tPredicate = $Piece(tPropName, "[", 2, 99)
			Set tPredicate = $Extract(tPredicate, 1, *-1)
			Set tPredicate = $ZConvert(tPredicate, "I", "XML")
			Set tPropName = $Piece(tPropName, "[", 1)
		}
		
		// Save the original object because we may have to back up to it when
		// dealing with a predicate using extension on primitive data type.
		Set tData = pData
		
		// If there is another level to the XPATH expression, and if the next
		// level of the expression specifies FHIR extension, check to see if
		// it is an extension on a complex data type or resource, or if it is
		// an extension on a primitive data type. If on a primitive data type
		// then change the property name to "_"_propertyname.
		If tExtensionIsNext {
			If (tData.extension="")&&(tData.%Get("_"_tPropName)'="") {
				Set tPropName = "_"_tPropName
			}
		}
		
		Set tPropVal = tData.%Get(tPropName)
		
		Set tTypeOf = tData.%GetTypeOf(tPropName)
		
		If '$IsObject(tPropVal) {
			If (tPropVal'="")&&((tPredicate="")||(..EvaluateXPathDynObjPredicate(pData, tData, tPropName, tPredicate))) {
				If tTypeOf'="boolean" {
					Set pResults($i(pResults)) = tPropVal
				} Else {
					Set pResults($i(pResults)) = $Case(tPropVal, 1:"true", 0:"false", "true":"true", "false":"false", :"false")
				}
			}
		} ElseIf tPropVal.%IsA("%Library.DynamicObject") {
			If ((tPredicate="")||(..EvaluateXPathDynObjPredicate(pData, tData, tPropName, tPredicate))) {
				// The check on only the first piece by left square bracket indicates
				// the limited support for predicates at this time. It assumes that
				// any predicate if present will be a simple one, at the end of the
				// xpath expression, and not embedded at a level before the end.
				If $Piece(pXPath,"[",1)'["/" {
					Set pResults($i(pResults)) = tPropVal
				} Else {
					Set tSC = ..EvaluateXPathDynamicObj(tPropVal, pXPath, .pResults)
					If $$$ISERR(tSC) Quit
				}
			}
		} Else {
			// It's a DynamicArray.
			Set tIterator = tPropVal.%GetIterator()
			Set tPropName2 = ""
			For {
				If 'tIterator.%GetNext(.tPropName2, .tData2) Quit
				If tPropName2="" Quit
				If '$IsObject(tData2) {
					If (tData2'="")&&((tPredicate="")||(..EvaluateXPathDynObjPredicate(pData, tData2, tPropName, tPredicate))) {
						If tTypeOf'="boolean" {
							Set pResults($i(pResults)) = tData2
						} Else {
							Set pResults($i(pResults)) = $Case(tData2, 1:"true", 0:"false", "true":"true", "false":"false", :"false")
						}
					}
				} ElseIf tData2.%IsA("%Library.DynamicObject") {
					If ((tPredicate="")||(..EvaluateXPathDynObjPredicate(pData, tData2, tPropName, tPredicate))) {
						// The check on only the first piece by left square bracket indicates
						// the limited support for predicates at this time. It assumes that
						// any predicate if present will be a simple one, at the end of the
						// xpath expression, and not embedded at a level before the end.
						If $Piece(pXPath,"[",1)'["/" {
							Set pResults($i(pResults))=tData2
						} Else {
							Set tSC = ..EvaluateXPathDynamicObj(tData2, pXPath, .pResults)
							If $$$ISERR(tSC) Quit
						}
					}
				} Else {
					// is an array
				}
				If $$$ISERR(tSC) Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod EvaluateXPathDynObjPredicate(pOrigData As %Library.DynamicObject, pData As %Library.DynamicObject, pCurrentProp As %String, pPredicate As %String) As %Boolean
{
	Set tPass = 0
	
	// For DSTU2 and STU3, this methods assumes that the predicate is just one
	// property and one attribute value check, or just one attribute check:
	// someproperty/@value='somevalue'
	// someproperty/@url='somevalue'
	// someproperty/@id='somevalue'
	// @value='somevalue'
	// @url='somevalue'
	// @id='somevalue'
	
	Set tP1 = $Piece(pPredicate,"/",1)
	
	// If single quote before slash then assume that the slash is within
	// an attribute compare value. In that case then the entire thing is
	// just the attribute compare value.
	If tP1["'" Set tP1 = pPredicate
	
	If $Extract(tP1)="@" {
		// Attribute value compare only.
		Set tPredAtt = $Piece(tP1,"=",1)
		Set tPredVal = $Piece(tP1,"=",2)
		If ($Extract(tPredVal)="'")&&($Extract(tPredVal,*)="'") {
			Set tPredVal = $Extract(tPredVal,2,*-1)
		}
		
		/*
		Write !,"pData="_pData
		Write !,"pCurrentProp="_pCurrentProp
		Write !,"pPredicate="_pPredicate
		Write !,"tP1="_tP1
		Write !,"tPredAtt="_tPredAtt
		Write !,"tPredVal="_tPredVal
		Write !,"pData.url="_pData.url
		*/
		
		If tPredAtt="@url" {
			If $IsObject(pData) Set tPass = (tPredVal=pData.url)
		} ElseIf tPredAtt="@id" {
			If $IsObject(pData) Set tPass = (tPredVal=pData.id)
		} Else {
			Set tPass = (tPredVal=pData)
		}
	} Else {
		// Property plus attribute value compare.
		Set tPredProp = tP1
		If tPredProp[":" Set tPredProp = $Piece(tPredProp,":",2)
		Set tPredAtt = $Piece($Piece(pPredicate,"/",2),"=",1)
		Set tPredVal = $Piece($Piece(pPredicate,"/",2,99),"=",2,99)
		If ($Extract(tPredVal)="'")&&($Extract(tPredVal,*)="'") {
			Set tPredVal = $Extract(tPredVal,2,*-1)
		}
		
		/*
		Write !,"pData="_pData
		Write !,"pCurrentProp="_pCurrentProp
		Write !,"pPredicate="_pPredicate
		Write !,"tP1="_tP1
		Write !,"tPredProp="_tPredProp
		Write !,"tPredAtt="_tPredAtt
		Write !,"tPredVal="_tPredVal
		Write !,"pData.%Get(tPredProp)="_pData.%Get(tPredProp)
		*/
		
		If tPredProp'="extension" {
			If tPredAtt'="@id" {
				Set tPass = (tPredVal=pData.%Get(tPredProp))
			} Else {
				Set tPass = (tPredVal=pData.%Get(tPredProp).id)
			}
		} Else {
			If pData.extension'="" {
				If tPredAtt="@url" {
					Set tPass = (tPredVal=pData.%Get(tPredProp).url)
				} ElseIf tPredAtt="@id" {
					Set tPass = (tPredVal=pData.%Get(tPredProp).id)
				} Else {
					Set tPass = (tPredVal=pData.%Get(tPredProp))
				}
			} Else {
				Set tPredProp = "_"_pCurrentProp
				Set pData = pOrigData.%Get(tPredProp).extension
				If tPredAtt="@url" {
					Set tPass = (tPredVal=pData.%Get(tPredProp).url)
				} ElseIf tPredAtt="@id" {
					Set tPass = (tPredVal=pData.%Get(tPredProp).id)
				} Else {
					Set tPass = (tPredVal=pData.%Get(tPredProp))
				}
			}
		}
	}
	
	Quit tPass
}

ClassMethod CacheSearchParams(pType As %String, pCustomStoragePkg As %String) As %Status [ Abstract ]
{
	// Code varies by FHIR version, must be overridden by a subclass
}

/// Given a resource type and the name of a search parameter, return the type
/// of that parameter (token, string, reference, date, uri, quantity, number, etc.).
/// This will return null if pResourceType is valid but pParamName is not recognized.
ClassMethod GetSearchParamType(pResourceType As %String, pParamName As %String, ByRef pPropType As %String) As %String
{
	set tParamType = ""
	set pPropType = ""
	if (pParamName="") { throw ##class(%Exception.General).%New("General Exception","999",,"Param name is null") }
	if (pParamName="0") quit tParamType
	if (pResourceType="") { set pResourceType = ..#BASERESOURCE }
	// Make sure search param info is cached in %HSFHIRSearchParams.
	// This is effectively a no-op if this type is already cached.
	set tSC = ..CacheSearchParams(pResourceType)
	if ($$$ISERR(tSC)) { throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
	// First check whether this is one of the params common to all types.
	if ($D(%HSFHIRSearchParams(..#VERSIONKEY, ..#BASERESOURCE, pParamName))) {
		set tParamType = $P($G(%HSFHIRSearchParams(..#VERSIONKEY, ..#BASERESOURCE, pParamName)), "^")
		set pPropType = $P($G(%HSFHIRSearchParams(..#VERSIONKEY, ..#BASERESOURCE, pParamName)), "^", 5)
	} else {
		set tParamType = $P($G(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType, pParamName)), "^")
		set pPropType = $P($G(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType, pParamName)), "^", 5)
	}
	quit tParamType
}

/// Given a resource type and a search parameter on that resource of type
/// "reference", this method will return "true" if that search parameter
/// references of type pRefType, and false otherwise. For example, the
/// "practitioner" search param on Appointment searches the participant.actor
/// property, which can be a reference to a Patient, Practitioner,
/// RelatedPerson, Device, HealthcareService, or Location. However, the
/// "practitioner" param only searches for values of this property that are of
/// type Practitioner. So calling the method with pResourceType="Appointment",
/// pParamName="practitioner", and pRefType="Practitioner" returns true.
/// However calling it with pResourceType and pParamName and pRefType="Patient"
/// returns false.
ClassMethod RefMatchesSearchParam(pResourceType As %String, pParamName As %String, pRefType As %String) As %Boolean
{
	// Make sure search param info is cached in %HSFHIRSearchParams.
	// This is effectively a no-op if this type is already cached.
	set tSC = ..CacheSearchParams(pResourceType)
	if ($$$ISERR(tSC)) { throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
	set tValidRefTypes = $P($G(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType,pParamName)),"^", 3)
	if (tValidRefTypes = "*") { quit 1 }
	elseif (tValidRefTypes [ ("~"_pRefType_"~")) { quit 1 }
	quit 0
}

Method AddToSearchTableEntry(pKey As %String, pValue As %String) As %Status
{
	try {
		set tPropName = ..NormalizeParamName(.pKey)
		set tProp = $PROPERTY(..SearchTableEntry, tPropName)
		if (tProp="") { set tSC = $$$ERROR($$$GeneralError, "Column not found in search table: "_tPropName) quit }
		set tSC = $METHOD(tProp, "Insert", pValue)
		quit:$$$ISERR(tSC)
		if ($D(%HSFHIRSearchParams(..#VERSIONKEY, ..#BASERESOURCE,pKey))) {
			set tProp = $PROPERTY(..CommonSearchTableEntry, tPropName)
			if (tProp="") { set tSC = $$$ERROR($$$GeneralError, "Column not found in common search table: "_tPropName) quit }
			set tSC = $METHOD(tProp, "Insert", pValue)
			quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// Normalize a phone number for indexing and search by stripping out punctuation and whitespace
ClassMethod NormalizePhone(pVal As %String) As %String
{
	quit $ZSTRIP(pVal, "*PW")
}

/// Typically we index the "value" property of a searchable property, however extensions
/// must be handled differently because they have no "value" property, but rather
/// "valueBoolean", "valueInteger", etc. We can look at the URL of the extension to know
/// which to use.
ClassMethod GetExtensionIndexProp(pURL As %String) As %String
{
	try {
		set tPropName = $CASE(pURL,
					"http://hl7.org/fhir/StructureDefinition/us-core-race"				:"valueCodeableConcept",
					"http://hl7.org/fhir/StructureDefinition/us-core-ethnicity"			:"valueCodeableConcept",
					"http://hl7.org/fhir/StructureDefinition/11179-objectClass"			:"valueCoding",
					"http://hl7.org/fhir/StructureDefinition/11179-objectClassProperty"	:"valueCoding",
																						:"")
	}
	catch (ex) {
		$$$LOGERROR($system.Status.GetOneErrorText(ex.AsStatus()))
		set tPropName = ""
	}
	quit tPropName
}

/// A resource gets deprecated when a newer version is received to replace it.
/// To deprecate an exising streamlet remove the entries in the search
/// tables corresponding to this resource. There will be two, one in the table
/// corresponding to the type of the resource, and one in the "common" table.
/// Also clear the Compartments property linking the resource to one or more
/// compartments and remove any indices on it.
ClassMethod DeprecateResource(pSession As %String, pType As %String, pResourceId As %String) As %Status
{
	#dim tStreamlet As HS.FHIR.vCommon.ResourceBase
	try{
		set tSC = $$$OK
		set tVersionId = ..CurrentVersion(pSession, pType, pResourceId)
		// The error messages are slightly different to distinguish between these cases.
		if (tVersionId = "") { set tSC = $$$ERROR($$$GeneralError, "No resource of type "_pType_" with ID="_pResourceId_" found. (No versionId)") quit }
		set tLogicalId = ..ResourceToLogicalId(pSession, pType, pResourceId, tVersionId)
		if (tLogicalId = "") { set tSC = $$$ERROR($$$GeneralError, "No resource of type "_pType_" with ID="_pResourceId_" found. (No logicalId)") quit }
		set tStorageClass = ..GetStorageClassFromLogicalId(tLogicalId) quit:$$$ISERR(tSC)
		
		// Manually clear Compartments and CompartmentsIdx
		set tData = @..#DATAGLOBAL@(tLogicalId)
		set tCompartments = $LG(tData,10)
		for tI=1:1:$LL(tCompartments) {
			set tOneCompartment = $LG(tCompartments,tI)
			kill @..#INDEXGLOBAL@("CompartmentsIdx",$system.Util.Collation(tOneCompartment,7),tLogicalId)
		}
		if ($LL(tCompartments)=0) { kill @..#INDEXGLOBAL@("CompartmentsIdx"," ",tLogicalId) }
		set $LIST(tData,10) = ""
		set @..#DATAGLOBAL@(tLogicalId) = tData
		
		// Remove entries from search tables.
		// First check for the existence of the search table, then a row corresponding to this resource in that table
		set tSearchTableName = ..#SEARCHTABLEPACKAGE_"."_pType
		set tCommonSearchTableName = ..#SEARCHTABLEPACKAGE_"."_..#BASERESOURCE
		for tTableName = tSearchTableName,tCommonSearchTableName {
			if ($$$comClassDefined(tTableName)) && ($CLASSMETHOD(tTableName, "%ExistsId", tLogicalId)) {
				set tSC = $CLASSMETHOD(tTableName, "%DeleteId", tLogicalId) quit:$$$ISERR(tSC)
			}
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// Call this to save the resource
Method SaveResource() As %Status
{
	set tSC = $$$OK
	try {
		set tSC= ..OnValidate() quit:$$$ISERR(tSC)
		// LastModified and VersionId have to be set before the resource is exported to a stream so that
		// the corresponsing meta object properties can be set and saved.
		
		// $ZDT(,3,7) converts a timestamp from $H format (assuming the local time zone)
		//  to UTC time and format: YYYY-MM-DDThh:mm:ssZ
		
		Set ..LastModified = $ZDT($H,3,7)
		Set tLastVersion = ..CurrentVersion(..Session, ..ResourceType, ..ResourceId)
		Set ..VersionId = $I(tLastVersion)
		// Do not set resource string if streamlet is deleted
		if ('..Deleted) {
			do ..UpdateMeta(..ResourceObject, ..VersionId, ..LastModified)
			
			set tTempStream = ##class(%Stream.TmpCharacter).%New()
			// Omit indent and line feed chars (the blank parameters).
			set tSC = ##class(HS.FHIR.Utils).SerializeResourceObject(..ResourceObject, , , , , .tTempStream) quit:$$$ISERR(tSC)
			set %maxlocallength = $Get(%maxlocallength,$$$MaxLocalLength)
			set ..ResourceString = ""
			do ..ResourceStream.Clear()
			if tTempStream.Size'>%maxlocallength {
				while 'tTempStream.AtEnd {
					// Reading the stream in 32767 chunks (which is the default) is faster
					// than reading it all at once, when dealing with very long streams.
					Set ..ResourceString = ..ResourceString_tTempStream.Read()
				}
			} else {
				set tSC = ..ResourceStream.CopyFrom(tTempStream)
				if $$$ISERR(tSC) quit
			}
			
		}
		set tSC = ..%Save() quit:$$$ISERR(tSC)
		set tSC = ..OnAfterSave() quit:$$$ISERR(tSC)
		// IndexValues() has to be called after %Save() because the search table entry requires
		//  the ID of this resource.
		if ('..Deleted) { set tSC = ..IndexValues() quit:$$$ISERR(tSC) }
	}
	Catch (ex) { set tSC = ex.AsStatus() }
	Quit tSC
}

ClassMethod UpdateMeta(pResourceObject, pVersionId As %String, pLastUpdated As %String)
{
	If pResourceObject.%IsA("%Library.DynamicObject") {
		If '$IsObject(pResourceObject.meta) {
			Set pResourceObject.meta = ##class(%Library.DynamicObject).%New()
		}
		Set pResourceObject.meta.lastUpdated = pLastUpdated
		Set pResourceObject.meta.versionId = pVersionId
		
	} Else { // Assume it is %XML.Document
		
		#dim tNode As %XML.Node
		
		Set tNode = pResourceObject.GetDocumentElement()
		Set tNodeId("topNode") = tNode.NodeId
		
		// This block assumes that there is already at least one child element in the resource.
		Set tNodeId("extension") = ""
		Set tNodeId("id") = ""
		Set tNodeId("meta") = ""
		Set tNodeId("versionId") = ""
		Set tNodeId("lastUpdated") = ""
		Set tNodeId("source") = ""
		Set tNodeId("profile") = ""
		Set tNodeId("security") = ""
		Set tNodeId("tag") = ""
		
		// This will be the NodeId of the first first-level property other than id and meta.
		Set tNodeId("firstFirstLevelProp") = ""
		
		If tNode.MoveToFirstChild(1) {
			For {
				Set tPropName = tNode.LocalName
				If tPropName="id" {
					Set tNodeId("id") = tNode.NodeId
				} ElseIf tPropName="meta" {
					Set tNodeId("meta") = tNode.NodeId
				} Else {
					Set tNodeId("firstFirstLevelProp") = tNode.NodeId
					Quit
				}
				If 'tNode.MoveToNextSibling(1) Quit
			}
		}
		
		// If no meta object found, then build a new meta tree, then insert
		// it before the first first-level resource property other than id.
		If tNodeId("meta")="" {
			Set tNode.NodeId = tNodeId("topNode")
			If tNodeId("firstFirstLevelProp")'="" {
				Set tTempNodeId = tNodeId("firstFirstLevelProp")
				Set tNodeId("meta") = tNode.InsertElement("meta", , .tTempNodeId)
				Set tNodeId("firstFirstLevelProp") = tTempNodeId
			} Else {
				Do tNode.AppendElement("meta")
				If tNode.MoveToFirstChild(1) {
					For {
						If tNode.LocalName="meta" {
							Set tNodeId("meta") = tNode.NodeId
							Quit
						}
						If 'tNode.MoveToNextSibling(1) Quit
					}
				}
			}
			Set tNode.NodeId = tNodeId("meta")
			Do tNode.AppendElement("versionId")
			Do tNode.AppendElement("lastUpdated")
			Do tNode.MoveToFirstChild(1)
			Do tNode.SetAttribute("value", , pVersionId)
			Do tNode.MoveToNextSibling(1)
			Do tNode.SetAttribute("value", , pLastUpdated)
			
			Set tNode.NodeId = tNodeId("topNode")
			
		} Else { // meta was found, update it.
		
			Set tNode.NodeId = tNodeId("meta")
			
			If tNode.MoveToFirstChild(1) {
				// Look for the properties we want to update. If found,
				// update their value attribute, and note their NodeId.
				For {
					Set tPropName = tNode.LocalName
					Set tNodeId(tPropName) = tNode.NodeId
					If tPropName="versionId" {
						Do tNode.SetAttribute("value", , pVersionId)
					} ElseIf tPropName="lastUpdated" {
						Do tNode.SetAttribute("value", , pLastUpdated)
					}
					If 'tNode.MoveToNextSibling(1) Quit
				}
				// Verify that all desired properties were found. If not,
				// then insert or append them in the correct XML sequence
				// position within meta.
				If (tNodeId("versionId")="")||(tNodeId("lastUpdated")="") {
					Set tNode.NodeId = tNodeId("meta")
					If tNodeId("lastUpdated")="" {
						// If lastUpdated needs to be added, it must come before
						// these properties. Insert it before the first found of
						// any of the properties in the tFindProp loop. If none
						// found, then append it to the end of the existing meta
						// object.
						For tFindProp = "source", "profile", "security", "tag" {
							If tNodeId(tFindProp)'="" Quit
						}
						If tNodeId(tFindProp)="" {
							// AppendElement does not return the NodeId of what
							// we just appended, so we have to go looking for it.
							Do tNode.AppendElement("lastUpdated")
							If tNode.MoveToFirstChild(1) {
								For {
									If tNode.LocalName="lastUpdated" {
										Set tNodeId("lastUpdated") = tNode.NodeId
										Do tNode.SetAttribute("value", , pLastUpdated)
										Quit
									}
									If 'tNode.MoveToNextSibling(1) Quit
								}
							}
						} Else {
							// One of the properties in the tFindProp loop was
							// found. Insert lastUpdated before it.
							Set tChildNodeId = tNodeId(tFindProp)
							Set tNodeId("lastUpdated") = tNode.InsertElement("lastUpdated", , .tChildNodeId)
							Set tNode.NodeId = tNodeId("lastUpdated")
							Do tNode.SetAttribute("value", , pLastUpdated)
						}
					}
					If tNodeId("versionId")="" {
						// At this point we know we at least have lastUpdated populated.
						// Insert versionId right before it.
						Set tNode.NodeId = tNodeId("meta")
						Set tChildNodeId = tNodeId("lastUpdated")
						Set tNodeId("versionId") = tNode.InsertElement("versionId", , .tChildNodeId)
						Set tNode.NodeId = tNodeId("versionId")
						Do tNode.SetAttribute("value", , pVersionId)
					}
				}
			}
		}
	}
	
	Quit
}

/// Validate a date param<br>
/// Param can be in the format:<br>
/// YYYY<br>
/// YYYY-MM<br>
/// YYYY-MM-DD<br>
/// YYYY-MM-DDThh:mm<br>
/// YYYY-MM-DDThh:mm:ss<br>
/// This method will also assert that month, date, hour, minute and second values are valid<br>
/// pDate will be modified and returned if the precision on it warranted converting to UTC
ClassMethod ValidateDate(ByRef pDate As %String) As %Boolean
{
	// YYYY
	if ($L(pDate)=4) {
		if (pDate '? 4N) { quit 0 }
		set tFilledInDate = pDate_"-01-01T00:00:00"
	}
	// YYYY-MM
	elseif ($L(pDate)=7) {
		if (pDate '? 4N1"-"2N) { quit 0 }
		set tFilledInDate = pDate_"-01T00:00:00"
	}
	// YYYY-MM-DD
	elseif ($L(pDate)=10) {
		if (pDate '? 4N1"-"2N1"-"2N) { quit 0 }
		set tFilledInDate = pDate_"T00:00:00"
	}
	// YYYY-MM-DDThh:mm (no time zone)
	elseif ($L(pDate)=16) {
		if (pDate '? 4N1"-"2N1"-"2N1"T"2N1":"2N) { quit 0 }
		set tFilledInDate = pDate_":00"
		set pDate = ##class(HS.FHIR.Utils).ConvertToUTC(tFilledInDate)
	}
	// YYYY-MM-DDThh:mm:ss (no time zone)
	elseif ($L(pDate)=19) {
		if (pDate '? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N) { quit 0 }
		set tFilledInDate = pDate
		set pDate = ##class(HS.FHIR.Utils).ConvertToUTC(pDate)
	}
	elseif ($L(pDate)>19) {
		// YYYY-MM-DDThh:mm:ss.nnn (no time zone)
		if (pDate ? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N.1".".1N.E)&&(pDate '? .E1"+"2N1":"2N)&&(pDate '? .E1"-"2N1":"2N)&&($E(pDate,*)'="Z") {
			set tFilledInDate = pDate
			set pDate = ##class(HS.FHIR.Utils).ConvertToUTC(pDate)
		}
		elseif '((pDate ? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N.E)&&((pDate ? .E1"+"2N1":"2N)||(pDate ? .E1"-"2N1":"2N)||($E(pDate,*)="Z"))) {
			// Does not evaluate to a date and time with time zone.
			quit 0
		}
		else {
			// YYYY-MM-DDThh:mm:ss[.nnn] (with time zone)
			if $extract(pDate,"*")="Z" {
				set tFilledInDate = $E(pDate, 1, *-1)
			} else {
				set tFilledInDate = $E(pDate, 1, *-6)
				set pDate = ##class(HS.FHIR.Utils).ConvertToUTC(pDate)
			}
		}
	}
	// unrecognized length
	else { quit 0 }

	quit ($ZDTH(tFilledInDate,3,,,,,,,,"error")'="error")
}

/// Given a date and optionally time in one of the formats:<br>
/// YYYY<br>
/// YYYY-MM<br>
/// YYYY-MM-DD<br>
/// YYYY-MM-DDThh:mmZ<br>
/// YYYY-MM-DDThh:mm:ssZ<br>
/// This method will return the first instant (second) that falls within that date/time.<br>
/// For example, an input value of "1974" would return "1974-01-01T00:00:00Z". A date/time<br>
/// that already has second precision will be returned unchanged.<br>
/// The argument must be in one of the above formats. This method will not validate it.
ClassMethod FirstInstant(pVal As %String) As %String
{
	set tYear   = $P(pVal,"-")
	set tMonth  = $P(pVal,"-",2)
	set tDate   = $P($P(pVal,"-",3),"T")
	set tHour   = $P($P(pVal,"T",2),":")
	set tMinute = $P(pVal,":",2)
	set tSecond = $E($P(pVal,":",3),1,2)
	
	set:tSecond="" tSecond="00"
	set:tMinute="" tMinute="00"
	set:tHour="" tHour="00"
	set:tMonth="" tMonth="01"
	set:tDate="" tDate="01"
	
	// hopefully there's a year!
	
	quit tYear_"-"_tMonth_"-"_tDate_"T"_tHour_":"_tMinute_":"_tSecond_"Z"
}

/// Given a date and optionally time in one of the formats:<br>
/// YYYY<br>
/// YYYY-MM<br>
/// YYYY-MM-DD<br>
/// YYYY-MM-DDThh:mmZ<br>
/// YYYY-MM-DDThh:mm:ssZ<br>
/// This method will return the last instant (second) that falls within that date/time.<br>
/// For example, an input value of "1974" would return "1974-12-31T23:59:59Z". A date/time<br>
/// that already has second precision will be returned unchanged.<br>
/// The argument must be in one of the above formats. This method will not validate it.
ClassMethod LastInstant(pVal As %String) As %String
{
	set tYear   = $P(pVal,"-")
	set tMonth  = $P(pVal,"-",2)
	set tDate   = $P($P(pVal,"-",3),"T")
	set tHour   = $P($P(pVal,"T",2),":")
	set tMinute = $P(pVal,":",2)
	set tSecond = $E($P(pVal,":",3),1,2)
	
	set:tSecond="" tSecond=59
	set:tMinute="" tMinute=59
	set:tHour="" tHour=23
	set:tMonth="" tMonth=12
	set:tDate="" tDate=$CASE(tMonth, "01":31, "02":$$FebruaryLength(tYear), "03":31, "04":30, "05":31, "06":30, "07":31, "08":31, "09":30, "10":31, "11":30, "12":31)
	
	// hopefully there's a year!
	
	quit tYear_"-"_tMonth_"-"_tDate_"T"_tHour_":"_tMinute_":"_tSecond_"Z"
	
FebruaryLength(pYear)
	if (pYear#4=0)&&((pYear#100'=0)||(pYear#400=0)) quit 29
	quit 28
}

/// Given a timestamp in YYYY-MM-DDThh:mm:ss format, return the value
/// of the timestamp that is one second prior
ClassMethod PreviousInstant(pVal As %String) As %String
{
	set tDateTimeH = $ZDTH(pVal, 3)
	set tDateH = $P(tDateTimeH, ",")
	set tTimeH = $P(tDateTimeH, ",", 2)
	if (tTimeH = 0) {
		set tTimeH = 86399
		set tDateH = tDateH-1
	}
	else { set tTimeH = tTimeH-1 }
	quit $REPLACE($ZDT(tDateH_","_tTimeH, 3), " ", "T")
}

ClassMethod Collate(pVal As %String) As %String
{
	quit $system.Util.Collation(pVal, ..#COLLATION)
}

ClassMethod CollateSession(pSession As %String = "") As %String
{
	quit $SELECT(pSession="":-100000000000000, 1:pSession)
}

ClassMethod NormalizeAccents(pVal As %String) As %String
{
	#; For now, the functionality to get the "from" and "to" strings from the
	#; config registry is being disabled while we decide how we want to enable
	#; the user to customize these values. The DEFAULTCHARSACCENTED and
	#; DEFAULTCHARSUNACCENTED parameters of this class will be used for the time being.
	#; The original annotation:
/// This method will $TRANSLATE accented chars to unaccented, since string search
/// is supposed to be accent-insensitive. The "from" string comes from the
/// Configuration Registry entry with the key:<br>
///   /FHIR/Search/CharsAccented<br>
/// The "to" string comes from the entry:<br>
///   /FHIR/Search/CharsUnaccented<br>
/// If either of these values is null or not defined, then the default values from
/// the parameters <parameter>DEFAULTCHARSACCENTED</parameter> and <parameter>DEFAULTCHARSUNACCENTED</parameter>
/// will be used.
	/*
	#dim RegistryKeyCharsAccented = "/FHIR/Search/CharsAccented"
	#dim RegistryKeyCharsUnaccented = "/FHIR/Search/CharsUnaccented"
	
	if ($G(%FHIR("CharsAccented"))="")||($G(%FHIR("CharsUnaccented"))) {
		set tCharsAccented = ##class(HS.Registry.Config).GetKeyValue(RegistryKeyCharsAccented)
		set tCharsUnaccented = ##class(HS.Registry.Config).GetKeyValue(RegistryKeyCharsUnaccented)
		// Both keys must have a value, or neither will be used
		// (To prevent something like a user mistyping one of the keys, so one string from the Registry
		//  being used with one of the default strings - a disaster)
		if (tCharsAccented'="")&&(tCharsUnaccented'="") {
			set %FHIR("CharsAccented") = tCharsAccented
			set %FHIR("CharsUnaccented") = tCharsUnaccented
		}
		else {
			set %FHIR("CharsAccented") = ..#DEFAULTCHARSACCENTED
			set %FHIR("CharsUnaccented") = ..#DEFAULTCHARSUNACCENTED
		}
	}
	
	quit $TRANSLATE(pVal, %FHIR("CharsAccented"), %FHIR("CharsUnaccented"))
	*/
	quit $TRANSLATE(pVal, ..#DEFAULTCHARSACCENTED, ..#DEFAULTCHARSUNACCENTED)
}

/// For every instance of "-" in the given string, convert the following character
/// to uppercase, then strip out the "-". Ex: "address-city" becomes "addressCity".
ClassMethod NormalizeParamName(pParamName As %String) As %String
{
	if (pParamName = "") { $$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentMethod_" method blank input specified")) }
	
	set tIdx = $FIND(pParamName, "-", 0)
	if tIdx=0 quit pParamName
	
	set tOuputParamName = pParamName
	for {
		set $E(tOuputParamName, tIdx) = $ZCVT($E(tOuputParamName, tIdx), "U")
		set $E(tOuputParamName, tIdx-1) = ""
		set tIdx = $FIND(tOuputParamName, "-", tIdx-1)
		if tIdx=0 quit
	}
	quit tOuputParamName
}

ClassMethod SearchToken(pParam As %String, pVals, ByRef pQuery As %String, ByRef pSQLParams, pPropType As %String) As %Status
{
	#; http://www.hl7.org/fhir/DSTU2/search.html#token
	#; http://www.hl7.org/fhir/STU3/search.html#token
	
	try {
		set tSC = $$$OK
		// pVals is a $LIST of values. Each value is one search condition and they are all AND-ed together.
		//  This is valid because some properties are lists so can have more than one value.
		//  Ex: find a care provider who speaks English *and* Spanish.
		
		//Modifiers are not supported yet
		set tMod = $P(pParam, ":", 2)
		set pParam = $P(pParam, ":")
		// The repository operation will check for the text "Unsupported modifier on param" in the error so it can return a
		// 400 (Bad Request) rather than a 500 (Internal Server Error).
		if (tMod'="") { set tSC = $$$ERROR($$$GeneralError, "Unsupported modifier on param "_pParam_": '"_tMod_"'") quit }
		set tParamNormalized = ..NormalizeParamName(pParam)
		for tI=1:1:$LL(pVals) {
			if (tI'=1) { set pQuery = pQuery_" AND " }
			set tSearchVal = $LG(pVals, tI)
			// The search value may be comma-delimited list, which indicates OR-ed together conditions
			set tNumSearchVals = $L(tSearchVal,",")
			if (tNumSearchVals=1) {
				set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE=?) "
			}
			else {
				set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE IN (?"
				for tJ=2:1:tNumSearchVals { set pQuery = pQuery_",?" }
				set pQuery = pQuery_"))"
			}
			
			for tJ=1:1:tNumSearchVals { 
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				// For each search value, if we can determine it is a phone number, normalize it
				// for search. The search val is a phone number if it is formatted as:
				//      [system]-[use]|[value]
				// And "[system]" is "phone", "fax", or "beeper"
				if ($L(tOneSearchVal,"|")=2) {
					set tSystem = $P(tOneSearchVal,"|",1)
					if (tSystem'="")&&(..IsStringOrCode(pPropType)) {
						// The precedent has been set in this method to return an error status
						// for the business operation to catch, so we will do the same here.
						set tSC = $$$ERROR($$$GeneralError, "Specifying system value on token-type search parameter for FHIR code-type field is not supported")
						quit
					}
					if ($L(tSystem,"-")=2) && (",phone,fax,beeper," [ (","_$P(tSystem,"-")_",")) {
						set $P(tOneSearchVal,"|",2) = ..NormalizePhone($P(tOneSearchVal,"|",2))
					}
				}
				set pSQLParams($I(pSQLParams)) = tOneSearchVal
			}
			quit:$$$ISERR(tSC)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod IsStringOrCode(pHSFHIRClass As %String) As %Boolean
{
	Set tStringOrCode = 0
	
	Set tPropName = "@"
	Set tPropCount = 0
	Set tLastProp = ""
	For {
		Set tPropName = $$$defMemberNext(pHSFHIRClass, $$$cCLASSproperty, tPropName)
		If tPropName="" Quit
		If $i(tPropCount)>1 Quit
		Set tLastProp = tPropName
		Set tPropOrigin = $$$comMemberKeyGet(pHSFHIRClass, $$$cCLASSproperty, tPropName, $$$cPROPorigin)
		Set tPropType = $$$defMemberKeyGet(tPropOrigin, $$$cCLASSproperty, tPropName, $$$cPROPtype)
	}
	
	Set tStringOrCode = ((tPropCount=1)&&(tLastProp="value")&&((tPropType="%String")||(tPropType="%Library.String")||(tPropType[".CodePrimitive")||(tPropType[".StringPrimitive")))
	
	Quit tStringOrCode
}

ClassMethod SearchDate(pType As %String, pParam As %String, pVals, ByRef pQuery As %String, ByRef pSQLParams, pPropType As %String) As %Status
{
	#; http://www.hl7.org/fhir/DSTU2/search.html#date
	#; http://www.hl7.org/fhir/STU3/search.html#date
	
	try {
		set tSC = $$$OK
		// A search value is supposed to select a target value if the implied ranges intersect at
		//  at all. For example, a search value "gt2012-06-15" should select a stored value of "2012"
		//  because the range of the search value (everything after 2012-06-15) intersects the implied
		//  range of the target value (2012-01-01T00:00:00 to 2012-12-31T23:59:59). This is handled
		//  automatically for upper bounds (lt,le) because a less precise value sorts before a 
		//  more precise value. For lower bounds (gt,ge), however, we must explicitly include a condition
		//  to select less precise values, ie, for "gt2012-06-15", we must include a condition like:
		//  "%VALUE IN ('2012-06','2012')"
		
		// Some values are indexed as periods. Periods have explicit start and end times, and both the
		//  start time and the end time are stored and indexed in the search table. All searchable periods
		//  in the data model are indexed as periods. Additionally some values that are not periods
		//  are indexed as periods, because the searchable property is an "[x]" property and one of
		//  the types that it may be is a period and at least one is not. Ex: The "onset" parameter
		//  of Condition searches both onsetPeriod and onsetDateTime. In this case, non-period values
		//  are indexed as periods by using implicit start and end times. The way searching on periods
		//  works is, if the seach contains a lower bound (gt, ge), then we query on the "End" value.
		//  If it contains an upper bound (lt, le), then we query on the "Start" value. "Equals" as
		//  it pertains to periods means (per the spec) "the range of the search value fully contains
		//  the range of the target value", which in this case means that the first instant of the
		//  search value comes before the stored "Start" value, and the last instant of the search
		//  value comes after the "End" value.
		set tParamSearchesPeriod = ..ParamSearchesPeriod(pType, pParam)
		
		
		// Optimize for a special case: The parameter being searched does not search a period,
		//  there are exactly 2 items in pVals, neither is an "OR" condition, one is a  "greater
		//  than (or equal to)" condition, and the other is a "less than (or  equal to)" condition.
		//  In this case, use SQL "BETWEEN" operator.
		// The range condition is inclusive of both the first and second parameters. However,
		//  because a less precise value will always sort before a more precise value, a 
		//  condition like "%VALUE BETWEEN '2012-01' AND '2012-06'" will not select a value of
		//  2012-06-15, for example. For this reason, if the upper bound parameter has less than
		//  second-level precision, it will be filled in to the last second of the implied range.
		//  For example, a given parameter of "2012-06" will become "2012-06-30T23:59:59Z" in the
		//  actual query.
		if ('tParamSearchesPeriod) && ($LL(pVals)=2) && ($LG(pVals)'[",") && ($LG(pVals,2)'[",") {
			for tI=1:1:2 {
				set tVal = $LG(pVals,tI)
				if (",lt,le," [ (","_$E(tVal,1,2)_",")) { set tHiPrefix=$E(tVal,1,2), tHiVal=$E(tVal,3,*) }
				if (",gt,ge," [ (","_$E(tVal,1,2)_",")) { set tLoPrefix=$E(tVal,1,2), tLoVal=$E(tVal,3,*) }
			}
			if (tHiVal'="")&&(tLoVal'="") {
				set tOrigHiVal=tHiVal, tOrigLoVal=tLoVal
				if ('..ValidateDate(.tHiVal)) { set tSC = $$$ERROR($$$GeneralError, "Invalid search value for "_pParam_": "_tOrigHiVal) quit }
				if ('..ValidateDate(.tLoVal)) { set tSC = $$$ERROR($$$GeneralError, "Invalid search value for "_pParam_": "_tOrigLoVal) quit }
				set tParamNormalized = ..NormalizeParamName(pParam)
				set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE BETWEEN ? AND ? "
				// Depending on the lower bound, we may need an additional "IN" or "=" condition. See note above.
				// YYYY-MM-DDThh:mm:ssZ
				if ($L(tLoVal)=20) { set pQuery = pQuery_"OR %VALUE IN (?,?,?)) " }
				// YYYY-MM-DD
				elseif ($L(tLoVal)=10) { set pQuery = pQuery_"OR %VALUE IN (?,?)) " }
				// YYYY-MM
				elseif ($L(tLoVal)=7)  { set pQuery = pQuery_"OR %VALUE=?) " }
				else { set pQuery = pQuery_") " }
				// Because "BETWEEN" is inclusive but "greater than" and "less than" are not, then if those
				// are the prefixes, increment or decrement the values accordingly.
				if (tLoPrefix="gt") { set tLoVal = ..IncrementDateTime(tLoVal) }
				if (tHiPrefix="lt") { set tHiVal = ..DecrementDateTime(tHiVal) }
				set pSQLParams($I(pSQLParams)) = tLoVal
				// Fill in the upper range if necessary.
				set pSQLParams($I(pSQLParams)) = ..LastInstant(tHiVal)
				// Depending on the lower bound, we may need an additional condition, with
				// a variable number of values. See note above.
				// YYYY-MM-DDThh:mm:ssZ
				if ($L(tLoVal)=20) { set pSQLParams($I(pSQLParams)) = $E(tLoVal,1,10) }
				// YYYY-MM-DD
				if ($L(tLoVal)>=10) { set pSQLParams($I(pSQLParams)) = $E(tLoVal,1,7) }
				// YYYY-MM
				if ($L(tLoVal)>=7)  { set pSQLParams($I(pSQLParams)) = $E(tLoVal,1,4) }

				quit
			}
		}
		
		
		// If the special case above does not apply, then process each condition individually.
		// pVals is a $LIST of values. Each value is one search condition and they are all AND-ed together.
		for tI=1:1:$LL(pVals) {
			set tSearchVal = $LG(pVals,tI)
			if (tI'=1) { set pQuery = pQuery_" AND " }
			set pQuery = pQuery_" ("
			for tJ=1:1:$L(tSearchVal,",") {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tJ'=1) { set pQuery = pQuery_" OR " }
				// The value should have a prefix, however if it does not, treat that as "equal"
				if ($E(tOneSearchVal,1,2) ? 2A) {
					set tPrefix = $ZCVT($E(tOneSearchVal,1,2),"L")
					if (",eq,ne,gt,lt,ge,le,sa,eb,ap," '[ (","_tPrefix_",")) { set tSC = $$$ERROR($$$GeneralError, "Invalid prefix value for "_pParam_": "_tPrefix) quit }
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}
				else { set tPrefix = "eq" }
				set tOrigSearchVal = tOneSearchVal
				if ('..ValidateDate(.tOneSearchVal)) { set tSC = $$$ERROR($$$GeneralError, "Invalid search value for "_pParam_": "_tOrigSearchVal) quit }
				
				set tParamNormalized = ..NormalizeParamName(pParam)
				
				if (tPrefix = "eq") {
					if (tParamSearchesPeriod) {
						set pQuery = pQuery_" (FOR SOME %ELEMENT("_tParamNormalized_..#PERIODSTARTSUFFIX_") (%VALUE >= ?) AND FOR SOME %ELEMENT("_tParamNormalized_..#PERIODENDSUFFIX_") (%VALUE <= ?))"
						set pSQLParams($I(pSQLParams)) = ..FirstInstant(tOneSearchVal)
						set pSQLParams($I(pSQLParams)) = ..LastInstant(tOneSearchVal)
					}
					elseif ($Length(tOneSearchVal)=10)&&(($Piece(pPropType,".",*)="DateTime")||($Piece(pPropType,".",*)="Instant")) {
						// If length is 10 then assume YYYY-MM-DD. This is a date-only value being
						// applied against a dateTime or instant-typed property. Because dateTime
						// and instant are indexed in UTC time, the time window for the date-only
						// search value must be adjusted for UTC.
						Set tDH = $ZDateTimeH(tOneSearchVal,3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tFirstVal = ##class(HS.FHIR.Utils).ConvertToUTC(tLocal)
						Set tDH = $ZDateTimeH(tOneSearchVal_"T23:59:59",3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tSecondVal = ##class(HS.FHIR.Utils).ConvertToUTC(tLocal)
						set pQuery = pQuery_" (FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE >= ?) AND FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE <= ?))"
						set pSQLParams($I(pSQLParams)) = tFirstVal
						set pSQLParams($I(pSQLParams)) = tSecondVal
					}
					else {
						set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE %STARTSWITH ?) "
						set pSQLParams($I(pSQLParams)) = tOneSearchVal
					}
				}
				elseif (tPrefix = "ne") {
					if (tParamSearchesPeriod) {
						// Per the standard, "not equal" as it applies to periods means: "the range of the search
						// value does not fully contain the range of the target value". So return results where the
						// period start is less than the first instant of the search value, or the period end is
						// greater than the last instant of the search value.
						set pQuery = pQuery_" (FOR SOME %ELEMENT("_tParamNormalized_..#PERIODSTARTSUFFIX_") (%VALUE < ?) OR FOR SOME %ELEMENT("_tParamNormalized_..#PERIODENDSUFFIX_") (%VALUE > ?))"
						set pSQLParams($I(pSQLParams)) = ..FirstInstant(tOneSearchVal)
						set pSQLParams($I(pSQLParams)) = ..LastInstant(tOneSearchVal)
					}
					elseif ($Length(tOneSearchVal)=10)&&(($Piece(pPropType,".",*)="DateTime")||($Piece(pPropType,".",*)="Instant")) {
						// If length is 10 then assume YYYY-MM-DD. This is a date-only value being
						// applied against a dateTime or instant-typed property. Because dateTime
						// and instant are indexed in UTC time, the time window for the date-only
						// search value must be adjusted for UTC.
						Set tDH = $ZDateTimeH(tOneSearchVal,3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tFirstVal = ##class(HS.FHIR.Utils).ConvertToUTC(tLocal)
						Set tDH = $ZDateTimeH(tOneSearchVal_"T23:59:59",3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tSecondVal = ##class(HS.FHIR.Utils).ConvertToUTC(tLocal)
						set pQuery = pQuery_" (FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE < ?) OR FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE > ?))"
						set pSQLParams($I(pSQLParams)) = tFirstVal
						set pSQLParams($I(pSQLParams)) = tSecondVal
					}
					else {
						set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (NOT %VALUE %STARTSWITH ?) "
						set pSQLParams($I(pSQLParams)) = tOneSearchVal
					}
				}
				elseif (tPrefix = "gt")||(tPrefix = "ge") {
					// For "gt" ("greater than"):
					// -If search val is "2012", we want everything from 2013 on.
					// -If search val is "2012-06", we want everything from 2012-07 on, including "2012".
					// -If search val is "2012-06-15", we want everything from 2012-06-16 on, including "2012-06" and "2012"
					// -We cannot simply do "%VALUE > ?" with the parameter being the original search value because then
					//  "gt2012" will select "2012-06", which is wrong. So we increment the search value and do "%VALUE >= ?".
					// -Then, Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
					//
					// For "ge" ("greather than or equal to"):
					// -If search val is "2012", we want everything from 2012 on.
					// -If search val is "2012-06", we want everything from 2012-06 on, including "2012".
					// -If search val is "2012-06-15" we want everything from 2012-06-15 on, include "2012-06" and "2012".
					// -So most of what we want is encompassed by "%VALUE >= ?" on the original search value.
					// -Then, Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
					//
					// Therefore, the only different between "ge" and "gt" is that "gt" must have the original search value
					//  incremented before being used in the query.
					//
					// The only thing that changes for periods is that we want to search the "End" column for the period.
					
					if (tParamSearchesPeriod) { set tParamNormalized = tParamNormalized_..#PERIODENDSUFFIX }
					set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE >= ?"
					// Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
					// YYYY-MM-DDThh:mm:ssZ
					if ($L(tOneSearchVal)=20) { set pQuery = pQuery_" OR %VALUE IN (?,?,?)) " }
					// YYYY-MM-DD
					elseif ($L(tOneSearchVal)=10) { set pQuery = pQuery_" OR %VALUE IN (?,?)) " }
					// YYYY-MM
					elseif ($L(tOneSearchVal)=7)  { set pQuery = pQuery_" OR %VALUE=?) " }
					else { set pQuery = pQuery_") " }
					set:tPrefix="gt" tOneSearchVal = ..IncrementDateTime(tOneSearchVal)
					set pSQLParams($I(pSQLParams)) = tOneSearchVal
					// YYYY-MM-DDThh:mm:ssZ
					if ($L(tOneSearchVal)=20) { set pSQLParams($I(pSQLParams)) = $E(tOneSearchVal,1,10) }
					// YYYY-MM-DD
					if ($L(tOneSearchVal)>=10) { set pSQLParams($I(pSQLParams)) = $E(tOneSearchVal,1,7) }
					// YYYY-MM
					if ($L(tOneSearchVal)>=7)  { set pSQLParams($I(pSQLParams)) = $E(tOneSearchVal,1,4) }
				}
				elseif (tPrefix = "lt")||(tPrefix = "le") {
					// For "lt" ("less than"):
					// -If search val is "2012", we want everything prior to 2012.
					// -If search val is "2012-06", we want everything prior to 2012-06, including "2012".
					// -If search val is "2012-06-15, we want everything prior to 2012-06-15, including "2012-06" and "2012".
					// -All of this is encompassed by "%VALUE < ?". For example, if the search is "lt2012-06", a value of "2012" will
					//  be selected because "2012" sorts before "2012-06".
					//
					// For "le" ("less than or equal to"):
					// -If search val is "2012", we want everything prior to 2013, including "2012-06" and "2012-06-15".
					// -If search val is "2012-06", we want everything prior to 2012-07, including "2012" and "2012-06-15".
					// -If search val is "2012-06-15", we want everything prior to 2012-06-16, including "2012" and "2012-06".
					// -If we increment the search value, then all of this is encompassed by "%VALUE < ?".
					//
					// Therefore, the only difference between "lt" and "le" is that "le" must have the original search value
					//  incremented before being used in the query.
					//
					// The only thing that changes for periods is that we want to search the "Start" column for the period.
					
					// If the param name is a SQL reserved word, it needs to be quoted in the "IS NOT NULL" part.
					if (tParamSearchesPeriod) { set tParamNormalized = tParamNormalized_..#PERIODSTARTSUFFIX }
					if ($SYSTEM.SQL.IsReservedWord(tParamNormalized)) { set tQParam = $C(34)_tParamNormalized_$C(34) }
					else { set tQParam = tParamNormalized }
					set pQuery = pQuery_" (FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE < ?) AND "_tQParam_" IS NOT NULL) "
					set:tPrefix="le" tOneSearchVal = ..IncrementDateTime(tOneSearchVal)
					set pSQLParams($I(pSQLParams)) = tOneSearchVal
				}
				else { set tSC = $$$ERROR($$$GeneralError, "Prefix not supported yet: "_tPrefix) quit }
				
			}	// loop over OR-ed together conditions
			set pQuery = pQuery_") "
		}	// loop over AND-ed together conditions
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod ParamSearchesPeriod(pResourceType As %String, pParamName As %String) As %Boolean [ Abstract ]
{
	// Code varies by FHIR version, must be overridden by a subclass
}

/// Must be overridden by the subclass
/// Returns true if the given search parameter on the given resource type
/// searches of property of type Period, and false otherwise. pParamName must
/// be the name of the search parameter as it appears in the parameter
/// definition, *not* the param name normalized via <method>NormalizeParamName</method>.
/// ie, "date-recorded", not "dateRecorded". If a search parameter searches
/// more than one property, this will return true if any of them is a Period.
/// For example, the "date" parameter on Procedure searches two properties,
/// performedDateTime and performedPeriod.  performedPeriod is a Period, so
/// this method returns true for that parameter.
/// Given a date or date-time, decrement it by one of whatever the precision is.
/// For example, "1932" returns "1931". "1985-01" returns "1984-12".
/// "2000-05-25T15:45Z" returns "2000-05-25T15:44Z". Valid input formats are:<br/>
/// YYYY <br/>
/// YYYY-MM <br/>
/// YYYY-MM-DD <br/>
/// YYYY-MM-DDThh:mmZ <br/>
/// YYYY-MM-DDThh:mm:ssZ <br/>
/// pDateTime is assumed to be valid and in UTC when applicable. ie, should
/// have already had <method>ValidateDate</method> called on it.
ClassMethod DecrementDateTime(pDateTime As %String) As %String
{
	// YYYY
	if (pDateTime ? 4N) {
		quit (pDateTime - 1)
	}
	// YYYY-MM
	elseif (pDateTime ? 4N1"-"2N) {
		set tYear = $P(pDateTime,"-",1)
		set tMonth = $P(pDateTime,"-",2)
		if (tMonth = "01") { set tMonth = "12", tYear = tYear-1 }
		else {
			set tMonth = tMonth-1
			if ($L(tMonth)=1) { set tMonth = "0"_tMonth }
		}
		quit (tYear_"-"_tMonth)
	}
	// YYYY-MM-DD
	elseif (pDateTime ? 4N1"-"2N1"-"2N) {
		// Convert to $H format, decrement, convert back
		set tDateH = $ZDH(pDateTime,3)
		quit $ZD(tDateH-1,3)
	}
	// YYYY-MM-DDThh:mm[:ss]Z
	elseif (pDateTime ? 4N1"-"2N1"-"2N1"T"2N1":"2N0.1(1":"2N)1"Z") {
		// In the absence of seconds, $ZDTH assumes them to be "00".
		set tDateTimeH = $ZDTH(pDateTime,3,7)
		set tDateH=$P(tDateTimeH,","), tTimeH=$P(tDateTimeH,",",2)
		// If the time is midnight (00:00:00), decrement the date and set the time to 23:59:59.
		if (tTimeH=0) { set tDateH=tDateH-1, tTimeH=86399 }
		else { set tTimeH = tTimeH-1 }
		quit $ZDT(tDateH_","_tTimeH,3,7)
	}
	else { throw ##class(%Exception.General).%New("General Exception","999",,"Invalid date-time: "_pDateTime) }
}

/// Given a date or date-time, increment it by one of whatever the precision is.
/// For example, "1932" returns "1933". "1985-12" returns "1986-01".
/// "2000-05-25T15:45Z" returns "2000-05-25T15:46Z". Valid input formats are:<br/>
/// YYYY <br/>
/// YYYY-MM <br/>
/// YYYY-MM-DD <br/>
/// YYYY-MM-DDThh:mmZ <br/>
/// YYYY-MM-DDThh:mm:ssZ <br/>
/// pDateTime is assumed to be valid and in UTC when applicable. ie, should
/// have already had <method>ValidateDate</method> called on it.
ClassMethod IncrementDateTime(pDateTime As %String) As %String
{
	// YYYY
	if (pDateTime ? 4N) {
		quit (pDateTime + 1)
	}
	// YYYY-MM
	elseif (pDateTime ? 4N1"-"2N) {
		set tYear = $P(pDateTime,"-",1)
		set tMonth = $P(pDateTime,"-",2)
		if (tMonth = 12) { set tMonth = "01", tYear = tYear+1 }
		else {
			set tMonth = tMonth+1
			if ($L(tMonth)=1) { set tMonth = "0"_tMonth }
		}
		quit (tYear_"-"_tMonth)
	}
	// YYYY-MM-DD
	elseif (pDateTime ? 4N1"-"2N1"-"2N) {
		// Convert to $H format, increment, convert back
		set tDateH = $ZDH(pDateTime,3)
		quit $ZD(tDateH+1,3)
	}
	// YYYY-MM-DDThh:mm[:ss]Z
	elseif (pDateTime ? 4N1"-"2N1"-"2N1"T"2N1":"2N0.1(1":"2N)1"Z") {
		// In the absence of seconds, $ZDTH assumes them to be "00".
		set tDateTimeH = $ZDTH(pDateTime,3,7)
		// Increment the time.
		set tDateH=$P(tDateTimeH,","), tTimeH=$P(tDateTimeH,",",2)+1
		// If this makes the time 24 hours since midnight, increment the date and set the time to 0.
		// 24*60*60=86400
		if (tTimeH=86400) { set tTimeH=0, tDateH=tDateH+1 }
		quit $ZDT(tDateH_","_tTimeH,3,7)
	}
	else { throw ##class(%Exception.General).%New("General Exception","999",,"Invalid date-time: "_pDateTime) }
}

ClassMethod SearchString(pParam As %String, pVals, ByRef pQuery As %String, ByRef pSQLParams) As %Status
{
	#; http://www.hl7.org/fhir/DSTU2/search.html#string
	#; http://www.hl7.org/fhir/STU3/search.html#string
	
	// TO DO: Accent-sensitivity of "exact" searches
	//  Right now if the client does an exact search for "Marche" and the original value is "Marché", the
	//  resource will be returned (even though it shouldn't be) because both "Marche" and "Marché" exist in
	//  the search table and there is no distinction as to which is the original value.
	try {
		set tSC = $$$OK
		
		set tMod = $P(pParam, ":", 2)
		// An unrecognized modifier returns an error. This gets returned to the client.
		if (",exact,contains,," '[ (","_tMod_",")) { set tSC = $$$ERROR($$$GeneralError, "Unsupported modifier on param "_pParam_": "_tMod) quit }
		// Per the FHIR spec, string search is case-insensitive unless the "exact" modifier is used.
		// However the "[" operator uses exact collation. See:
		//   http://<host>:<port>/csp/docbook/DocBook.UI.Page.cls?KEY=GSQL_langelements#GSQL_langelements_ops_relational
		// For this reason, we must do that collation within the query. So %VALUE is UPPER collated here,
		//  and the the search value is UPPER collated below.
		if (tMod="contains") { set tCondition = " (%UPPER(%VALUE) [ ?) " }
		elseif (tMod="exact") { set tCondition = " (%EXACT(%VALUE)= ?) " }
		else { set tCondition = " (%VALUE %STARTSWITH ?) " }
		set pParam = $P(pParam, ":")
		set tParamNormalized = ..NormalizeParamName(pParam)
		
		// pVals is a $List of AND-ed together conditions,
		//  and each item in the $List is a comma-delimited list of OR-ed together conditions.
		for tI=1:1:$LL(pVals) {
			if (tI'=1) { set pQuery = pQuery_" AND " }
			set tValue = $LG(pVals,tI)
			set tNumSearchVals = $L(tValue,",")
			for tJ=1:1:tNumSearchVals {
				set tOneVal = $P(tValue, ",", tJ)
				if (tJ'=1) { set pQuery = pQuery_" OR " }
				set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") "_tCondition
				// Collation 5 = UPPER (converts letters to uppercase)
				if (tMod="contains") { set tOneVal = $system.Util.Collation(tOneVal,5) }
				// Normalize for accents if the modifier is not "exact".
				if (tMod'="exact") { set pSQLParams($I(pSQLParams)) = ..NormalizeAccents(tOneVal) }
				else { set pSQLParams($I(pSQLParams)) = tOneVal }
			}
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod SearchReference(pParam As %String, pVals, ByRef pQuery As %String, ByRef pSQLParams) As %Status
{
	#; http://www.hl7.org/fhir/DSTU2/search.html#reference
	#; http://www.hl7.org/fhir/STU3/search.html#reference
	try {
		set tSC = $$$OK
		
		// The modifier, if present, is the type of the referenced resource
		set tMod = $P(pParam, ":", 2)
		set pParam = $P(pParam, ":")
		set tParamNormalized = ..NormalizeParamName(pParam)
		// pVals is a $LIST of values. Each value is one search condition and they are all AND-ed together.
		//  This is valid because some properties are lists so can have more than one value.
		//  Ex: Find patients linked to careProvider A (Organization) and careProvider B (Practitioner)
		for tI=1:1:$LL(pVals) {
			if (tI'=1) { set pQuery = pQuery_" AND " }
			set tSearchVal = $LG(pVals, tI)
			// The search value may be comma-delimited list, which indicates OR-ed together conditions
			set tNumSearchVals = $L(tSearchVal,",")
			if (tNumSearchVals=1) {
				set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE=?) "
			}
			else {
				set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE IN (?"
				for tJ=2:1:tNumSearchVals { set pQuery = pQuery_",?" }
				set pQuery = pQuery_"))"
			}
			for tJ=1:1:tNumSearchVals { 
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				// If the param modifier specifies the type but the search value does not,
				// incorporate it into the search value.
				if (tMod'="")&&($L(tOneSearchVal,"/")=1) { set tOneSearchVal = tMod_"/"_tOneSearchVal }
				set pSQLParams($I(pSQLParams)) = tOneSearchVal
			}
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod SearchQuantity(pType As %String, pParam As %String, pVals, ByRef pQuery As %String, ByRef pSQLParams) As %Status
{
	
	#; http://www.hl7.org/fhir/DSTU2/search.html#quantity
	#; http://www.hl7.org/fhir/STU3/search.html#quantity
	
	#dim tPrefixes As %String = ",eq,ne,gt,lt,ge,le,sa,eb,ap,"
	
	try {
		set tSC = $$$OK
		
		//Modifiers are not supported yet
		set tMod = $P(pParam, ":", 2)
		set pParam = $P(pParam, ":")
		if (tMod'="") { $$$LOGWARNING("Unrecognized modifier on param "_pParam_", ignoring: "_tMod) }
		set tChildTableName = ..NormalizeParamName(pParam)
		
	/*
	Optimize for a special case: all of the various AND-ed and OR-ed conditions have the exact
	 same units. In that case, rather than including a "unit" condition with each "value" condition,
	 combine all the "value" conditions and then "AND" on a single "unit" condition to those. For
	 example, given a search:
	    [base]/fhir/Observation?value-quantity=gt3.1||mmol/L&value-quantity=lt6.2||mmol/L
	Rather than generating:
	    SELECT ResourceLogicalId As ID FROM HS_Local_FHIR_Repository_Search.Observation 
	  	WHERE ResourceLogicalId IN (SELECT ResourceLogicalId FROM HS_Local_FHIR_Repository_Search_Observation.valueQuantity WHERE
	 	((value > 3.1 AND FOR SOME %ELEMENT(unit) (%VALUE='http://unitsofmeasure.org|mmol/L')) 
	 	 AND 
	  	(value < 6.2 AND FOR SOME %ELEMENT(unit) (%VALUE='http://unitsofmeasure.org|mmol/L'))))
	Instead generate:
	  	SELECT ResourceLogicalId As ID FROM HS_Local_FHIR_Repository_Search.Observation 
		WHERE ResourceLogicalId IN (SELECT ResourceLogicalId FROM HS_Local_FHIR_Repository_Search_Observation.valueQuantity WHERE
	  	FOR SOME %ELEMENT(unit) (%VALUE='http://unitsofmeasure.org|mmol/L')) AND
	  	value>3.1 AND value<6.2)
	  	
	Originally I had the idea to optimize this even further by replacing two AND-ed inequalities with
	a "BETWEEN" condition, however my testing shows no performance improvement when I do this. The SQL
	engine must be doing the same thing in either case.
	*/
		set tUnits="", tUnitsMatch=1
		for tI=1:1:$LL(pVals) {
			set tSearchVal = $LG(pVals, tI)
			for tJ=1:1:$L(tSearchVal,",") {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tUnits="") { set tUnits = $P(tOneSearchVal, "|", 2, 3) }
				elseif (tUnits'=$P(tOneSearchVal, "|", 2, 3)) { set tUnitsMatch=0 quit }
			}
			quit:tUnitsMatch=0
		}
		
		if (tUnitsMatch) {
			set pQuery = pQuery_" ResourceLogicalId IN (SELECT ResourceLogicalId FROM "_$TR(..#SEARCHTABLEPACKAGE,".","_")_"_"_pType_"."_tChildTableName_" WHERE FOR SOME %ELEMENT(unit) (%VALUE=?) AND "
			set pSQLParams($I(pSQLParams)) = tUnits
			for tI=1:1:$LL(pVals) {
				set tSearchVal = $LG(pVals, tI)
				if (tI'=1) { set pQuery = pQuery_" AND " }
				for tJ=1:1:$L(tSearchVal,",") {
					if (tJ=1) { set pQuery = pQuery_" (" }
					else { set pQuery = pQuery_ " OR " }
					set tOneSearchVal = $P(tSearchVal,",",tJ)
					if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
						set tPrefix = $E(tOneSearchVal,1,2)
						set tOneSearchVal = $E(tOneSearchVal,3,*)
					}
					else { set tPrefix = "eq" }
					set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
					if (tOp="err") { set tSC = $$$ERROR($$$GeneralError, "Prefix on quantity parameter not supported: "_tPrefix) quit }
					set pQuery=pQuery_" value"_tOp_"? "
					set pSQLParams($I(pSQLParams)) = $P(tOneSearchVal,"|")
				}
				set pQuery=pQuery_")"
				quit:$$$ISERR(tSC)
			}
			set pQuery = pQuery_")"
			quit
		}
		

		// The vals in the $LIST are all AND-ed together conditions
		//  ex: /fhir/Observation?value-quantity=le6||kpa&value-quantity=ge4.8||kpa
		//  "search for all observations with value between 4.8 and 6 kPa"
		//  (except that this example would actually be handled above)
		for tI=1:1:$LL(pVals) {
			set tSearchVal = $LG(pVals, tI)
			// Each val in the $LIST is a comma-delimited list of OR-ed together conditions
			//  ex: /fhir/Observation?value-quantity=ge4.8||kpa,ge36||mm[Hg]
			//  "search for all observations with value >=4.8 kPa or 36 mm[Hg]" (ie, same value in different units)
			if (tI'=1) { set pQuery = pQuery_" AND " }
			set pQuery = pQuery_" ResourceLogicalId IN (SELECT ResourceLogicalId FROM "_$TR(..#SEARCHTABLEPACKAGE,".","_")_"_"_pType_"."_tChildTableName_" WHERE ("
			for tJ=1:1:$L(tSearchVal,",") {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
					set tPrefix = $E(tOneSearchVal,1,2)
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}
				// Missing prefix is the same as "eq"
				else { set tPrefix = "eq" }
				set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
				if (tOp="err") { set tSC = $$$ERROR($$$GeneralError, "Prefix on quantity parameter not supported: "_tPrefix) quit }
				set tValue = $P(tOneSearchVal, "|")
				set tUnits = $P(tOneSearchVal, "|", 2, 3)
			    if (tJ'=1) { set pQuery = pQuery_" OR " }
			    set pQuery = pQuery_"(Value "_tOp_" ? AND FOR SOME %ELEMENT(unit) (%VALUE=?))"
				set pSQLParams($I(pSQLParams)) = tValue
				set pSQLParams($I(pSQLParams)) = tUnits
			}
			quit:$$$ISERR(tSC)
			set pQuery = pQuery_"))"
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod SearchNumber(pParam As %String, pVals, ByRef pQuery As %String, ByRef pSQLParams) As %Status
{
	#; http://www.hl7.org/fhir/DSTU2/search.html#number
	#; http://www.hl7.org/fhir/STU3/search.html#number
	
	#dim tPrefixes As %String = ",eq,ne,gt,lt,ge,le,sa,eb,ap,"
	
	try {
		set tSC = $$$OK
		//Modifiers are not supported yet
		set tMod = $P(pParam, ":", 2)
		if (tMod'="") { $$$LOGWARNING("Unrecognized modifier on param "_pParam_", ignoring: "_tMod) }
		set pParam = $P(pParam, ":")
		set tParamNormalized = ..NormalizeParamName(pParam)
		set pQuery = pQuery_"FOR SOME %ELEMENT("_tParamNormalized_") ("
		
		// The vals in the $LIST are all AND-ed together conditions
		//  ex: /fhir/Encounter?length=gt5&length=lt20
		//  "search for encounters with length >5 AND length <20"
		// Note: attempting to combine two AND-ed inequalities with a "BETWEEN" condition
		//  does not appear to yield any performance improvement.
		set tInequalityExists=0
		for tI=1:1:$LL(pVals) {
			set:tI'=1 pQuery = pQuery_" AND "
			set tSearchVal = $LG(pVals, tI)
			// Each val in the $LIST is a comma-delimited list of OR-ed together conditions
			//  ex: /fhir/Encounter?length=lt5,gt20
			//  "search for encounter with length <5 OR length >20"
			set:tSearchVal["," pQuery=pQuery_ "("
			for tJ=1:1:$L(tSearchVal,",") {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
					set tPrefix = $E(tOneSearchVal,1,2)
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}
				// No prefix is the same as "eq"
				else { set tPrefix = "eq" }
				if ('$IsValidNum(tOneSearchVal)) { set tSC = $$$ERROR($$$GeneralError, "Invalid parameter value for "_pParam_", must be a valid number: "_tOneSearchVal) quit }
				set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
				if (tOp="err") { set tSC = $$$ERROR($$$GeneralError, "Prefix on number parameter not supported: "_tPrefix) quit }
				if (tOp["<")||(tOp[">") { set tInequalityExists = 1 }
				if (tJ'=1) { set pQuery = pQuery_" OR " }
				set pQuery = pQuery_"%VALUE"_tOp_"?"
				// Cast the search value to a number. Right now it is a string.
				set pSQLParams($I(pSQLParams)) = +tOneSearchVal
			}
			quit:$$$ISERR(tSC)
			set:tSearchVal["," pQuery=pQuery_ ")"
		}
		quit:$$$ISERR(tSC)
		// The "IS NOT NULL" is only stricly necessary if there is an upper bound (le,lt) with no lower bound (gt,ge),
		//  as null values are "less than" any non-null value. However, what I have observed in testing is that when
		//  there is a lower bound, the "IS NOT NULL" makes the query perform slightly better, whether there is an
		//  upper bound or not.
		if (tInequalityExists) { set pQuery = pQuery_") AND "_tParamNormalized_" IS NOT NULL" }
		else { set pQuery = pQuery_")" }
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod SearchURI(pParam As %String, pVals, ByRef pQuery As %String, ByRef pSQLParams) As %Status
{
	#; http://www.hl7.org/fhir/DSTU2/search.html#uri
	#; http://www.hl7.org/fhir/STU3/search.html#uri
	
	try {
		set tSC = $$$OK
		
		set tMod = $P(pParam, ":", 2)
		set pParam = $P(pParam, ":")
		if (tMod'="")&&(tMod'="above")&&(tMod'="below") { 
			$$$LOGWARNING("Unrecognized modifier on param "_pParam_", ignoring: "_tMod)
			set tMod=""
		}
		set tParamNormalized = ..NormalizeParamName(pParam)
		
		// The vals in the $LIST are all AND-ed together conditions
		for tI=1:1:$LL(pVals) {
			if (tI'=1) { set pQuery = pQuery_" AND " }
			set tSearchVal = $LG(pVals, tI)
			// Each val in the $LIST is a comma-delimited list of OR-ed together conditions
			set:tSearchVal["," pQuery = pQuery_" ("
			for tJ=1:1:$L(tSearchVal,",") {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tJ'=1) { set pQuery = pQuery_" OR " }
				if (..#VERSIONKEY'="DSTU2")&&($e(tOneSearchVal,1,4)="urn:")&&((tMod="above")||(tMod="below")) { set tSC = $$$ERROR($$$GeneralError, "Use of 'above' or 'below' modifier with urn search value is invalid") quit }
				if (tMod="below") { set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE %STARTSWITH ?) " }
				elseif (tMod="above") { set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (? %STARTSWITH %VALUE AND %VALUE IS NOT NULL) " }
				else { set pQuery = pQuery_" FOR SOME %ELEMENT("_tParamNormalized_") (%VALUE=?) " }
				set pSQLParams($I(pSQLParams)) = tOneSearchVal
			}
			quit:$$$ISERR(tSC)
			set:tSearchVal["," pQuery = pQuery_" )"
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod SearchCompartment(pType As %String, pCompartment As %String, pCompartmentId As %String, ByRef pQuery As %String, ByRef pSQLParams) As %Status
{
	#; http://www.hl7.org/fhir/DSTU2/compartments.html
	#; http://www.hl7.org/fhir/STU3/compartments.html
	
	try {
		set tSC = $$$OK
		// Given the resource type and the compartment, get the param names to search on
		set tSC = ..GetCompartmentSearchParam(pCompartment, pType, .tCols) quit:$$$ISERR(tSC)
		set tSearchVal = pCompartment_"/"_pCompartmentId
		set pQuery = pQuery_" ("
		for tI=1:1:$L(tCols,",") {
			set tOneCol = $P(tCols, ",", tI)
			if (tI'=1) { set pQuery = pQuery_" OR " }
			set pQuery = pQuery_"FOR SOME %ELEMENT("_tOneCol_") (%VALUE=?)"
			set pSQLParams($I(pSQLParams)) = tSearchVal
		}
		set pQuery = pQuery_")"
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// pCompartment must be either Patient, Encounter, RelatedPerson, Practitioner, or Device.
/// If pCompartment is not one of these values, an error will be returned.
/// pResourceType must be the name of a resource in the given compartment. If the
/// named resource is not in the given compartment, an error will be returned.
/// pSearchParam could either be a single value or a comma-delimited list of values.
ClassMethod GetCompartmentSearchParam(pCompartment As %String, pResourceType As %String, ByRef pSearchParam As %String, pForceRebuild As %Boolean = 0) As %Status
{
	set tSC = $$$OK

	try {
		set pSearchParam=""

		if ('$Data(%CompartmentDef(..#VERSIONKEY)))||(pForceRebuild) {
			kill %CompartmentDef(..#VERSIONKEY)
			// Format is:
			// %CompartmentDef(fhirVersion, compartment, resourceType, searchParam) = ""
			Do ..BuildCompartmentDef(..#VERSIONKEY)
		}

		if $Data(%CompartmentDef(..#VERSIONKEY, pCompartment, pResourceType)) {
			set tSearchParam = ""
			for {
				set tSearchParam = $Order(%CompartmentDef(..#VERSIONKEY, pCompartment, pResourceType, tSearchParam))
				if tSearchParam="" quit
				if pSearchParam'="" set pSearchParam = pSearchParam_","
				set pSearchParam = pSearchParam_tSearchParam
			}
		} elseif ($Data(%CompartmentDef(..#VERSIONKEY, pCompartment)))&&('$Data(%CompartmentDef(..#VERSIONKEY, pCompartment, pResourceType))) {
			set tSC = $$$ERROR($$$GeneralError, "Resource type not in "_pCompartment_" compartment: "_pResourceType)
		} else {
			set tSC = $$$ERROR($$$GeneralError, "Compartment not supported: "_pCompartment)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod IsCompartment(pRefType As %String, pResourceType As %String, pSearchParam As %String, pForceRebuild As %Boolean = 0) As %Boolean
{
	if ('$D(%CompartmentDef(..#VERSIONKEY)))||(pForceRebuild) {
		kill %CompartmentDef(..#VERSIONKEY)
		// Format is:
		// %CompartmentDef(fhirVersion, compartment, resourceType, searchParam) = ""
		Do ..BuildCompartmentDef(..#VERSIONKEY)
	}
	if (pRefType="")||(pResourceType="")||(pSearchParam="") { quit 0 }
	quit $D(%CompartmentDef(..#VERSIONKEY,pRefType,pResourceType,pSearchParam))
}

ClassMethod BuildCompartmentDef(pFHIRVersion As %String) [ Abstract ]
{
	// Code varies by FHIR version, must be overridden by a subclass
}

/// API
/// Rebuild the CompartmentsIdx and VersionIdx indices for each resource type.
ClassMethod RebuildClassIndices() As %Status
{
	/*
	 For subtle reasons relating to how the Abstract class is defined, calling
	 %BuildIndices() on each subclass will not work. Opening each resource via
	 %OpenId() and then doing a %Save() will not actually do anything unless we
	 make a change to the resource. So regenerate the indices manually.
	*/
	
	try {
		set tSC = $$$OK
		
		#dim CompartmentsIdxName = "CompartmentsIdx"
		#dim VersionIdxName = "VersionIdx"

		TSTART
		kill @..#INDEXGLOBAL
		set tLogicalId = ""
		for {
			set tLogicalId = $O(@..#DATAGLOBAL@(tLogicalId),1,tResourceStored) quit:tLogicalId=""
			// The class name is stored as "~class~" - this is what we want.
			set tClassName = $LG(tResourceStored,1)
			set tCompartmentsList = $LG(tResourceStored,10)
			set tSession = $LG(tResourceStored,9)
			set tResourceType = $LG(tResourceStored,2)
			set tResourceId = $LG(tResourceStored,3)
			set tVersionId = $LG(tResourceStored,4)
			set tDeleted = $LG(tResourceStored,5)
			
			// CompartmentsIdx
			if ($LL(tCompartmentsList)=0) { set @..#INDEXGLOBAL@(CompartmentsIdxName, ..Collate(""), tLogicalId) = tClassName }
			else {
				for tI=1:1:$LL(tCompartmentsList) { 
					set tOneCompartment = $LG(tCompartmentsList,tI)
					set @..#INDEXGLOBAL@(CompartmentsIdxName, ..Collate(tOneCompartment), tLogicalId) = tClassName
				}
			}
			
			// VersionIdx
			set @..#INDEXGLOBAL@(VersionIdxName, ..CollateSession(tSession), ..Collate(tResourceType), ..Collate(tResourceId), tVersionId, tLogicalId) = $LB(tClassName, tDeleted)
		}
		TCOMMIT
	}
	catch (ex) {
		TROLLBACK
		set tSC = ex.AsStatus()
		write !, $system.Status.GetOneErrorText(tSC)
		write !, "All changes to FHIR resource indices have been rolled back."
	}
	quit tSC
}

/// API
/// For every resource stored in the repository, rebuild its search indices.<br>
/// If pBreakOnError is true, the user will be prompted if:<br>
/// -the production is running<br>
/// -there is an error instantiating a resource<br>
/// -there is an error rebuilding the search indices for a resource<br>
/// Specify pType if you want to rebuild indices for only a single resource type.<br>
/// Specify pStorageClass if you want to use a Repository Storage class other than the default for this FHIR version.
ClassMethod RebuildSearchIndices(pBreakOnError As %Boolean = 0, pType As %String = "", pStorageClass As %String = "") As %Status
{
	#define Err(%msg) write !!, %msg if ('pBreakOnError) { write !, "Continuing...", !! continue } else { write !, "Continue? (y/n) " read tResp if ($ZCVT($E(tResp,1),"U") '= "Y") { set tSC=sc write !, "Quitting...",! quit } else { continue } }
	#dim tStreamlet As HS.FHIR.vCommon.ResourceBase
	#dim tResourceSchemaRoot = ..#MODELPACKAGE_".Resource"
	try {
		set tSC = $$$OK
		
		set tHadFHIRSearchParams = $Data(%HSFHIRSearchParams)
		set tHadPropsByName = $Data(%propsByName)
		set tHadCompartmentDef = $Data(%CompartmentDef)
		set tHadFHIRPeriodParams = $Data(%HSFHIRPeriodParams)
		
		set tBaseClassName = "HS.FHIR.vCommon.ResourceBase"
		
		if (..%ClassName(1)=tBaseClassName)||('..%Extends(tBaseClassName)) {
			set tSC = $$$ERROR($$$GeneralError, "This method must be run from a class that extends "_tBaseClassName)
			quit
		}
		
		// We need a Repository.Storage class specified or derived, in order to pick up the
		// correct %HSFHIRSearchParams data to drive indexing.
		if ..#VERSIONKEY="DSTU2" {
			set tBaseStorageClass = "HS.FHIR.vDSTU2.Repository.Storage"
		} else {
			set tBaseStorageClass = "HS.FHIR.vSTU3.Repository.Storage"
		}
		
		if pStorageClass="" set pStorageClass = tBaseStorageClass
		
		set tStorageClassObj = ##class(%Dictionary.CompiledClass).%OpenId(pStorageClass)
		if '$IsObject(tStorageClassObj) {
			set tSC = $$$ERROR($$$GeneralError, "Invalid storage class specified")
			quit
		}
		for i = 1:1:$Length(tStorageClassObj.Super,",") {
			set tX = $Piece(tStorageClassObj.Super,",",i)
			If tX'="" Set tSupers(tX) = ""
		}
		if '((pStorageClass=tBaseStorageClass)||($Data(tSupers(tBaseStorageClass)))) {
			set tSC = $$$ERROR($$$GeneralError, "Specified storage class must be or extend "_tBaseStorageClass)
			quit
		}
		// If the specified Repository.Storage class appears to be the product default class for this
		// FHIR version, check to see if there are any sub-classes created, possibly for the purpose
		// of using a custom storage package. If so, prompt the user to confirm to use the base class
		// instead of the one with the custom storage package definition.
		If $parameter(pStorageClass, "CUSTOMSTORAGEPKG")="" {
			set tRS = ##class(%ResultSet).%New("%Library.ClassDefinition:SubclassOf")     
			set tSC = tRS.Execute(tBaseStorageClass)
			quit:$$$ISERR(tSC)
			set tOtherClasses = 0
			while tRS.%Next() {
				if tRS.Get("Name")'=tBaseStorageClass set tOtherClasses($i(tOtherClasses)) = tRS.Get("Name")
			}
			if tOtherClasses {
				if tOtherClasses=1 {
					set tPrompt = "Class '"_tOtherClasses(1)_"' extends "_pStorageClass_"."
				} else {
					set tPrompt = ""
					for i = 1:1:tOtherClasses {
						if i=tOtherClasses {
							set tPrompt = tPrompt_" and "
						} elseif i>1 {
							set tPrompt = tPrompt_", "
						}
						set tPrompt = tPrompt_"'"_tOtherClasses(i)_"'"
					}
					set tPrompt = "Classes "_tPrompt_" extend "_pStorageClass_"."
				}
				write !,tPrompt
				write !
				write !,"Use specified storage class "_pStorageClass_" anyway? (y/n) "
				read tResp
				set tResp = $ZConvert(tResp,"U")
				if '((tResp="Y")||(tResp="YES")) {
					set tSC = $$$ERROR($$$GeneralError, "Aborted")
					quit
				}
				write !
			}
		}
		
		set tSC = ##class(Ens.Director).GetProductionStatus(.tProdName, .tState) quit:$$$ISERR(tSC)
		if (tState = $$$eProductionStateRunning) {
			// If breaking on error, prompt the user, otherwise do not proceed
			if (pBreakOnError) {
				write !, "Production '"_tProdName_"' is currently running. It is strongly recommended that the production be stopped before continuing. Continue anyway? (y/n) "
				read tResp
				if ($ZCVT($E(tResp,1),"U") '= "Y") { write !, "Quitting..." quit }
			}
			else { set tSC = $$$ERROR($$$GeneralError, "Cannot rebuild search indices while production is running: "_tProdName_". Quitting.") quit }
		}
		
		$$$LOGINFO("Starting "_..%ClassName(1)_" RebuildSearchIndices() for "_$select(pType="":"all resource types",1:"resource type '"_pType_"'")_" using storage class "_pStorageClass)
		
		// Get a count of the number of resources for which indices have to be rebuilt so progress can be reported.
		// We cannot simply count resources because the Abstract table will include old versions and deleted resources.
		if pType="" {
			set tResult = ##class(%SQL.Statement).%ExecDirect(,"SELECT COUNT(%ID) FROM "_$TR(..#SEARCHTABLEPACKAGE,".","_")_"."_..#BASERESOURCE)
		} else {
			set tResult = ##class(%SQL.Statement).%ExecDirect(,"SELECT COUNT(%ID) FROM "_$TR(..#SEARCHTABLEPACKAGE,".","_")_"."_$S($system.SQL.IsReservedWord(pType):$C(34)_pType_$C(34), 1:pType))
		}
		do tResult.%Next()
		set tTotal = tResult.%GetData(1)
		
		write !!, "Rebuilding search indices for "_tTotal_" resources...",!

		write !,"Gathering indexing definitions...",!
		
		set tSC = $classmethod(pStorageClass, "LoadAllSearchParams")
		if $$$ISERR(tSC) quit
		
		set (tTimeTotal, tImportTotal, tIndexTotal) = 0
		set tTotalStart = $ZHOROLOG
		set tSession = ""
		for {
			set tSession = $O(@..#INDEXGLOBAL@("VersionIdx",tSession)) quit:tSession=""
			// Use VersionIdx to get the ID of the current version of every resource
			set tTypeCollated = ""
			set tCount=0
			for {
				set tTypeCollated = $O(@..#INDEXGLOBAL@("VersionIdx",tSession,tTypeCollated)) quit:tTypeCollated=""
				if (pType'="")&&(tTypeCollated '= $system.Util.Collation(pType,7)) { continue }
				set tResourseIdCollated = ""
				for {
					set tResourseIdCollated = $O(@..#INDEXGLOBAL@("VersionIdx",tSession,tTypeCollated,tResourseIdCollated)) quit:tResourseIdCollated=""
					set tCurrVer = $O(@..#INDEXGLOBAL@("VersionIdx",tSession,tTypeCollated,tResourseIdCollated,""),-1)
					set tId = $O(@..#INDEXGLOBAL@("VersionIdx",tSession,tTypeCollated,tResourseIdCollated,tCurrVer,""),1,d)
					// Check whether the resource is deleted
					continue:$LG(d,2)=1
					// Remember tTypeCollated is collated so we can't use that for the class name, so get it from the index node data
					// The value will begin and end with an extra "~"
					set tClass = $E($LG(d,1),2,*-1)
					continue:tClass="HS.FHIR.Repository.Resource.Generic"
					set tStreamlet = $CLASSMETHOD(tClass,"%OpenId",tId)
#;					set tStream = ##class(%Stream.TmpCharacter).%New()
#;					do tStream.Write(tStreamlet.ResourceString)
					if tStreamlet.ResourceObject="" {
						Set tResourceObject = ""
						set tTargetStream = ##class(%Stream.TmpCharacter).%New()
						do tStreamlet.GetResourceAsStream(.tTargetStream)

						Set sc = ##class(HS.FHIR.Utils).CreateResourceObject(tStreamlet.Format, tTargetStream, .tResourceObject)
						if $$$ISERR(sc) {
							// TODO: Do we want to log an error here???
							continue
						}
						Set tStreamlet.ResourceObject = tResourceObject
					}
#;					set tImportStart = $ZHOROLOG
#;					set sc = ##class(HS.FHIR.Utils).FHIRToHSFHIR(tStreamlet.Format, tStream, .tResource, tResourceSchemaRoot)
#;					set tImportEnd = $ZHOROLOG
#;					set tImportTotal = tImportTotal + (tImportEnd-tImportStart)
#;					if ($$$ISERR(sc)) { 
#;						set tMsg = "Error loading resource, Class="_tClass_", ID="_tId_", """_$system.Status.GetOneErrorText(sc)_""""
#;						$$$Err(tMsg)
#;					}
#;					set tStreamlet.Resource = tResource
					set tIndexStart = $ZHOROLOG
					set sc = tStreamlet.IndexValues()
					set tIndexEnd = $ZHOROLOG
					set tIndexTotal = tIndexTotal + (tIndexEnd-tIndexStart)
					if ($$$ISERR(sc)) {
						set tMsg = "Error building search indices, Class="_tClass_", ID="_tId_", """_$system.Status.GetOneErrorText(sc)_""""
						$$$Err(tMsg)
					}
					if ($I(tCount)#1000 = 0) { write !!, tCount_" streamlets re-indexed."}
				}
				quit:$$$ISERR(tSC)
			}
			quit:$$$ISERR(tSC)
		}
		quit:$$$ISERR(tSC)
		set tTotalEnd = $ZHOROLOG
		set tTimeTotal = (tTotalEnd-tTotalStart)
		set tImportPercent = $FNUMBER(tImportTotal/tTimeTotal*100,"",0)
		set tIndexPercent = $FNUMBER(tIndexTotal/tTimeTotal*100,"",0)
		set tTimeTotal = $FNUMBER(tTimeTotal,",",2)
		set tImportTotal = $FNUMBER(tImportTotal,",",2)
		set tIndexTotal = $FNUMBER(tIndexTotal,",",2)
		write !!, tCount_" resources re-indexed."
		write !, "Total Time: "_tTimeTotal_"s   Import Time: "_tImportTotal_"s ("_tImportPercent_"%)   Indexing Time: "_tIndexTotal_"s ("_tIndexPercent_"%)"
	}
	catch (ex) { set tSC = ex.AsStatus() }
	
	write ! $$$LOGINFO("Finished "_..%ClassName(1)_" RebuildSearchIndices() for "_$select($get(pType)="":"all resource types",1:"resource type '"_pType_"'")_" using storage class "_$get(pStorageClass)_", status = "_$Select($$$ISERR(tSC):$system.Status.GetErrorText(tSC),1:1))
	
	if ($$$ISERR(tSC)) { write !!, $system.Status.GetOneErrorText(tSC) }
	
	if '$get(tHadFHIRSearchParams) kill %HSFHIRSearchParams
	if '$get(tHadPropsByName) kill %propsByName
	if '$get(tHadCompartmentDef) kill %CompartmentDef
	if '$get(tHadFHIRPeriodParams) kill %HSFHIRPeriodParams
	
	quit tSC
}

ClassMethod DeleteOrphanedResources() As %Status [ Abstract ]
{
	// Code varies by FHIR version, must be overridden by a subclass
}

/// API
/// In this context, "orphaned" means the resource references a non-existent
/// session.<br>
/// There *should* never be orphaned resources. The deletion of the referenced
/// session should trigger the delete of the resource. Still, this utility
/// is provided in case something goes wrong and orphaned resources are left
/// in the repository.
ClassMethod EvaluateXPath(pObj As %RegisteredObject, pXPath As %String, ByRef pVal As %RegisteredObject = "") As %Status
{
	try {
		set tSC = $$$OK
		if (pXPath="") {
			set pVal = pObj
			quit
		}
		// If there is a open square bracket before a slash, then the current property
		// has a predicate
		set tIdxSlash = $FIND(pXPath, "/")
		set tIdxOpenSquareBracket = $FIND(pXPath, "[")
		// Case 1: There is no predicate, or there is one but not on the current (first) property
		if (tIdxOpenSquareBracket = 0) ||
		   ((tIdxOpenSquareBracket'=0) && (tIdxSlash'=0) && (tIdxOpenSquareBracket > tIdxSlash))
		{
			set tPredicate = ""
			set tFirstProp = $P(pXPath, "/")
			set tOtherProps = $P(pXPath, "/", 2, *)

		}
		// Case 2: There is a predicate on this property. There may or may not be other properties.
		elseif (tIdxOpenSquareBracket'=0) {
			set tPredicate = $P($P(pXPath, "]", 1), "[", 2)
			set tFirstProp = $P(pXPath, "[", 1)
			set tOtherProps = $P(pXPath, "]/", 2, *)
		}
		set tProp = $PROPERTY(pObj, tFirstProp)
		if (tProp.%IsA("%Collection.AbstractList")) {
			// If there is a predicate and it is a number, treat it as an index
			if $ISVALIDNUM(tPredicate) {
				set tProp = tProp.GetAt(tPredicate)
				set tSC = ..EvaluateXPath(tProp, tOtherProps, .pVal) quit:$$$ISERR(tSC)
			}
			// Otherwise we must evaluate every element in the list, or at least those selected by
			// the predicate (which could be >1). Return the value of the first one to return a value.
			else {
				for tI=1:1:tProp.Count() {
					set tOneProp = tProp.GetAt(tI)
					if (tPredicate="")||(..EvalXPathPredicate(tOneProp,tPredicate)) {
						set tSC = ..EvaluateXPath(tProp.GetAt(tI), tOtherProps, .pVal) quit:$$$ISERR(tSC)
						if (pVal'="") { quit }
					}
				}
			}
		}
		else { 
			set tSC = ..EvaluateXPath(tProp, tOtherProps, .pVal)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod EvalXPathPredicate(pObj, pPredicate As %String) As %Boolean
{
	try {
		set tVal = 0
		if (pObj="") { quit }
		if (pPredicate="") { set tVal=1 quit }
		// Remove enclosing square brackets, if present
		if ($E(pPredicate)="[") && ($E(pPredicate,*)="]") { set pPredicate = $E(pPredicate,2,*-1) }
		set tPredicateProps = $P(pPredicate, "=", 1)
		set tPredicateConst = $P(pPredicate, "=", 2)
		// Strip off leading and trailing single quotes
		set tPredicateConst = $E(tPredicateConst,2,*-1)
		
		for tI=1:1:$L(tPredicateProps,"/") {
			set tProp = $P(tPredicateProps, "/", tI)
			// Attributes are projected as regular properties in the object model, so ignore "@" symbols
			if ($E(tProp)="@") { set tProp = $E(tProp,2,*) }
			set pObj = $PROPERTY(pObj, tProp)
			// An uninstantiated serial object property will return null, so quit to avoid invalid oref error
			if (pObj="") { quit }
			// For a list we have to call this method recursively
			if ($IsObject(pObj))&&(pObj.%IsA("%Collection.AbstractList")) {
				set tRemainingPred = $P(tPredicateProps, "/", tI+1, *)_"='"_tPredicateConst_"'"
				for tJ=1:1:pObj.Count() {
					set tOneProp = pObj.GetAt(tJ)
					set tVal = ..EvalXPathPredicate(tOneProp, tRemainingPred)
					// a single "true" element makes the whole predicate "true"
					if (tVal=1) { quit }
				}
				quit
			}
		}
		if (tVal=1) { quit }
		// At this point pObj *should* be a primitive
		set tVal = (pObj=tPredicateConst)
	}
	catch (ex) {
		$$$LOGERROR($system.Status.GetOneErrorText(ex.AsStatus()))
		set tVal = 0
	}
	quit tVal
}

ClassMethod EvaluatePointer(pObj As %RegisteredObject, pPointer As %String = "", ByRef pVal As %RegisteredObject = "") As %Status
{
	try {
		set tSC = $$$OK
		if (pPointer="") { set pVal = pObj quit }
		set tVal = pObj
		// Every piece of the pointer is either a property name or an index
		for tI=1:1:$L(pPointer, "/") {
			set tCurrentPiece = $P(pPointer, "/", tI)
			if (tCurrentPiece ? 1.N) {
				// Piece is a number representing an index in a list, so make sure the current
				//  node is a list
				if (('$IsObject(tVal)) || ('tVal.%IsA("%Collection.AbstractList"))) {
					set tSC = $$$ERROR($$$GeneralError, "Invalid JSON pointer, contains an index for a non-list property: "_pPointer)
					quit
				}
				// Add 1 because JSON pointers are 0-indexed while collections are 1-indexed
				set tVal = tVal.GetAt(tCurrentPiece + 1)
				continue
			}
			else {
				// Ignore a leading underscore per http://www.hl7.org/fhir/DSTU2/json.html#primitive
				// Ignore a leading underscore per http://www.hl7.org/fhir/STU3/json.html#primitive
				if ($E(tCurrentPiece) = "_") { set tCurrentPiece = $E(tCurrentPiece, 2, *) }
				set tNewVal = $PROPERTY(tVal, tCurrentPiece)
				// A null value could either mean an invalid pointer, or that an object property that has not been instantiated yet.
				if (tNewVal="") { 
					set tPropOrigin = $$$comMemberKeyGet(tVal.%ClassName(1), $$$cCLASSproperty, tCurrentPiece, $$$cPROPorigin)
					set tPropType = $$$defMemberKeyGet(tPropOrigin, $$$cCLASSproperty, tCurrentPiece, $$$cPROPtype)
					set tPropColl = $$$defMemberKeyGet(tPropOrigin, $$$cCLASSproperty, tCurrentPiece, $$$cPROPcollection)
					if (tPropColl="list") {
						set tNewVal = ##class(%Collection.ListOfObj).%New()
						// An uninstantiated list *should* be the last piece of the pointer
					}
					else {
						set tNewVal = $CLASSMETHOD(tPropType,"%New")
					}
					set $PROPERTY(tVal, tCurrentPiece) = tNewVal
				}
				set tVal = tNewVal
			}
		}
		quit:$$$ISERR(tSC)
		set pVal = tVal
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// LoadResource takes the ResourceString or ResourceStream property - whichever holds the
/// serialized resource - from this FHIR resource repository object instance, de-serializes
/// it into an HS FHIR data model object, and places it into the Resource property.
Method LoadResource() As %Status
{
	try { 
		set tSC = $$$OK
		if ('$isobject(..ResourceStream))||(..ResourceStream.Size=0) {
			set tStreamOrString = ..ResourceString
		} else {
			set tStreamOrString = ..ResourceStream
		}
		set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(..Format,tStreamOrString,.tResource,..ResourceSchema) quit:$$$ISERR(tSC)
		set ..Resource = tResource
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// GetResourceAsStream gets the current serialized resource content for the current
/// resource repository object and returns it in a stream object. The resource content
/// may be currently held in either the ResourceString or ResourceStream property.
Method GetResourceAsStream(ByRef pResourceStream As %Stream.Object)
{
	If '$IsObject($Get(pResourceStream)) Set pResourceStream = ##class(%Stream.TmpCharacter).%New()
	
	If ('$IsObject(..ResourceStream))||(..ResourceStream.Size=0) {
		Do pResourceStream.Write(..ResourceString)
		Do pResourceStream.Rewind()
	} Else {
		Do pResourceStream.CopyFrom(..ResourceStream)
	}
	
	Quit
}

/// API
/// If the resource repository was populated with data on a pre-15.03 version
/// and upgraded to version 15.03 or later, this method must be called manually
/// to fix the format of the LastModified value on resources. While the value
/// of LastModified has always been UTC time, it was not always formatted as
/// such ("YYYY-MM-DD hh:mm:ss" versus "YYYY-MM-DDThh:mm:ssZ"). This method
/// will iterate over every resource in the repository and update and
/// LastModified values stored in the old format.
ClassMethod FixLastModified() As %Status
{
	try {
		set tSC = $$$OK
		set tId = ""
		for {
			set tId = $O(@..#DATAGLOBAL@(tId),1,tResource) quit:tId=""
			set tLastModified = $LG(tResource,6)
			if ($E(tLastModified,*)'="Z") {
				set tLastModified = $TR(tLastModified, " ", "T")_"Z"
				set $LIST(tResource,6) = tLastModified
				set @..#DATAGLOBAL@(tId) = tResource
			}
			// IDs are assigned sequentially. If we find one that is one the right format,
			// all the subsequent ones should be correct as well.
			else { quit }
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// KillAllData finds all FHIR repository data that is used by the current sub-class
/// of this class and kills it.
ClassMethod KillAllData(pVerbose As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tKilled = 0
		For tGlobal = ..#DATAGLOBAL, ..#INDEXGLOBAL, ..#STREAMGLOBAL, ..#COUNTERGLOBAL {
			If (tGlobal'="")&&($Data(@tGlobal)) {
				If pVerbose Write !,"Killing global "_tGlobal
				Kill @tGlobal
				Set tKilled = 1
			}
		}
		If ('tKilled)&&(pVerbose) Write !,"No resource repository storage data to clean up"
		
		If ..#SEARCHTABLEPACKAGE'="" {
			Set tQuery = "SELECT ID FROM %Dictionary.CompiledClass where ID %StartsWith ?"
			Set tStatement = ##class(%SQL.Statement).%New()
			Set tSC = tStatement.%Prepare(tQuery)
			If $$$ISERR(tSC) {
				Set tText = "%Prepare failed for SQL query for search table reset: "_$System.Status.GetErrorText(tSC)
				If pVerbose Write !,tText
				Set tSC = $$$ERROR($$$GeneralError, tText)
				Quit
			}
			Set tResultSet = tStatement.%Execute(..#SEARCHTABLEPACKAGE)
			
			Set tKilled = 0
			While tResultSet.%Next() {
				Set tClassName = tResultSet.ID
				
				Set tDataGlobal = ##class(HS.FHIR.vCommon.StorageUtils).GetDataGlobal(tClassName)
				Set tIndexGlobal = ##class(HS.FHIR.vCommon.StorageUtils).GetIndexGlobal(tClassName)
				Set tCounterGlobal = ##class(HS.FHIR.vCommon.StorageUtils).GetCounterGlobal(tClassName)
				Set tStreamGlobal = ##class(HS.FHIR.vCommon.StorageUtils).GetStreamGlobal(tClassName)
				
				If ($Data(@tDataGlobal))||($Data(@tIndexGlobal))||($Data(@tCounterGlobal))||($Data(@tStreamGlobal)) {
					If pVerbose Write !,"Running "_tClassName_".%DeleteExtent()"
					Set tSC = $ClassMethod(tClassName, "%DeleteExtent")
					If $$$ISERR(tSC) {
						Set tText = "Error in "_tClassName_".%DeleteExtent(): "_$System.Status.GetErrorText(tSC)
						If pVerbose Write !,tText
						Set tSC = $$$ERROR($$$GeneralError, tText)
						Quit
					}
					Set tKilled = 1
				}
			}
			If ('tKilled)&&(pVerbose) Write !,"No search table data to clean up"
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

/// For the specified search parameter name and value(s), if the search parameter is
/// a reference type parameter, gather search parameter id values that unambiguously
/// apply to the specified reference resource type. Return an error if the search
/// parameter is invalid. Return an error if the search parameter value specifies a
/// reference resource type that does not apply to the search parameter.
ClassMethod GetRefTypeIdsFromSearchParam(pParamName As %String, pParamVals, pSearchResourceType As %String, pReferenceResourceType As %String, ByRef pReturnVals As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pReturnVals = ""
	
	Try {
		// If this parameter is not a search criteria then return success and no id values.
		Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
		If tNotSearchKeys[(","_pParamName_",") Quit
		
		Set tSearchParamDef = $Get(%HSFHIRSearchParams(..#VERSIONKEY, pSearchResourceType, pParamName))
		
		If tSearchParamDef="" {
			Set tSearchParamDef = $Get(%HSFHIRSearchParams(..#VERSIONKEY, "Resource", pParamName))
			If tSearchParamDef="" {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid search parameter '"_pParamName_"' specified")
				Quit
			}
		}
		
		If $Piece(tSearchParamDef,"^",1)'="reference" Quit
		
		Set tReferenceTypes = $Piece(tSearchParamDef,"^",3)
		
		// pParamVals is expected to be a $List.
		For i = 1:1:$ListLength(pParamVals) {
			Set tOneVal = $ListGet(pParamVals, i)
			Set tOneValP1 = $Piece(tOneVal, "/", 1)
			Set tOneValP2 = $Piece(tOneVal, "/", 2)
			
			If (tOneValP1'="")&&(tOneValP2'="") {
				If tReferenceTypes'[("~"_tOneValP1_"~") {
					// If the search param value specifies a reference resource type
					// that does not apply to this search param, return an error.
					Set tSC = $$$ERROR($$$GeneralError, "Invalid search parameter value '"_tOneVal_"' specified for search parameter '"_pParamName_"'")
					Quit
				} ElseIf tOneValP1=pReferenceResourceType {
					// If the search param value specifies a reference resource type
					// that matches the specified reference resource type, then add
					// piece 2 of the search param value to the returned values.
					If pReturnVals'="" Set pReturnVals = pReturnVals_","
					Set pReturnVals = pReturnVals_tOneValP2
				}
				
			} ElseIf tOneValP1'="" {
				If (tReferenceTypes=("~"_pReferenceResourceType_"~"))||((pParamName="patient")&&(pReferenceResourceType="Patient")) {
					// If there is only one piece to this reference type search param
					// value, and the only reference resource type on this search
					// param is the specified reference resource type, then add that
					// value to the returned values.
					If pReturnVals'="" Set pReturnVals = pReturnVals_","
					Set pReturnVals = pReturnVals_tOneValP1
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}

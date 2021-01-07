Include (HS.HC, HS.HC.Invoke)

/// Map OID to facility / endpoint
Class HS.Data.OIDMap Extends (%Persistent, %XML.Adaptor, HS.Sync.BaseClass) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 70;

Property OID As %String(MAXLEN = "");

/// code for entry within the identity type
Property IdentityCode As %String(MAXLEN = 512) [ Required ];

Property IdentityCodeAliases As list Of %String(MAXLEN = 512, STORAGEDEFAULT = "array");

Property IdentityType As HS.Data.OIDType;

Property IdentityTypes As list Of HS.Data.OIDType(STORAGEDEFAULT = "array");

/// used as the AssigningAuthority Name
Property Description As %String(MAXLEN = 512);

Property URL As %String(MAXLEN = "");

Index OIDIndex On OID;

Index URLIndex On URL;

Index IdentityTypeIndex On IdentityType;

Index IdentityTypesIndex On IdentityTypes(ELEMENTS);

Index IdentityCodeAliasesIndex On IdentityCodeAliases(ELEMENTS);

Index CodeTypeIndex On (IdentityCode, IdentityType) [ Unique ];

/// Find an IdentityCode for an OID.  When not found the OID will be returned in the IdentityCode but an error will be returned in the Status
ClassMethod OIDRow(pOID As %String = "", ByRef pID As %Integer, ByRef pIdentityCode As %String = "") As %Status
{
	Set pID="",SQLCODE=100
	If pOID]""  {
		&sql(select ID,IdentityCode into :tID,:tIdentityCode from HS_Data.OIDMap where OID=:pOID)
	}
	If SQLCODE && (pIdentityCode]"") {
		&sql(select ID,IdentityCode,OID into :tID,:tIdentityCode,:pOID from HS_Data.OIDMap where IdentityCode=:pIdentityCode)
	}
	#; either no row for that type most likely there is just 1 generic row 
	If 'SQLCODE {
		Set pID=tID,pIdentityCode=$piece(tIdentityCode,"~~~")
	} Else {
		Set pIdentityCode=pOID
	}
	Quit $S(SQLCODE:$$$ERROR($$$GeneralError,"OID Not found"),1:$$$OK)
}

/// Find an IdentityCode for a URL.  When not found the URL will be returned in the IdentityCode but an error will be returned in the Status
ClassMethod URLRow(pURL As %String = "", ByRef pID As %Integer, ByRef pIdentityCode As %String = "") As %Status
{
	Set pID="",SQLCODE=100
	If pURL]""  {
		&sql(select ID,IdentityCode into :tID,:tIdentityCode from HS_Data.OIDMap where URL=:pURL)
	}
	If SQLCODE && (pIdentityCode]"") {
		&sql(select ID,IdentityCode,URL into :tID,:tIdentityCode,:pURL from HS_Data.OIDMap where IdentityCode=:pIdentityCode)
	}
	#; either no row for that type most likely there is just 1 generic row 
	If 'SQLCODE {
		Set pID=tID,pIdentityCode=$piece(tIdentityCode,"~~~")
	} Else {
		Set pIdentityCode=pURL
	}
	Quit $S(SQLCODE:$$$ERROR($$$GeneralError,"URL Not found"),1:$$$OK)
}

/// Given an OID (and optionally the type) return the description.  If not found, the OID will be returned.
ClassMethod OIDDescription(pOID As %String = "", pIdentityType As %String = "") As %String
{
	Set tDescription="",SQLCODE=100
	If pIdentityType ] "" {
		&sql(select OIDMap->Description into :tDescription from OIDMap_IdentityTypes where OIDMap->OID=:pOID AND IdentityTypes=:pIdentityType)
	} Else {
		&sql(select Description into :tDescription from OIDMap where OID=:pOID)
	}
	Quit $S(SQLCODE:pOID,1:tDescription)
}

/// Given a URL (and optionally the type) return the description.  If not found, the URL will be returned.
ClassMethod URLDescription(pURL As %String = "", pIdentityType As %String = "") As %String
{
	Set tDescription="",SQLCODE=100
	If pIdentityType ] "" {
		&sql(select OIDMap->Description into :tDescription from OIDMap_IdentityTypes where OIDMap->URL=:pURL AND IdentityTypes=:pIdentityType)
	} Else {
		&sql(select Description into :tDescription from OIDMap where URL=:pURL)
	}
	Quit $S(SQLCODE:pURL,1:tDescription)
}

/// HSIE-3613 Changes in behavior to HS.Data.OIDMAP class methods:
/// 1. A facility may have one active OID and any number of historical OIDs. Historical OIDs will have '~~~' contained within the IdentityCode, and possibly within the URL.
/// 2. This method has been updated to strip away everything after and including '~~~' for both IdentityCode and URL properties.
/// Since this method may return an altered object (e.g. a historical OID row with '~~~' characters in IdentityCode and possible URL), attempting to save an altered object
/// will throw an exception as DuplicateCheck enforces validation: IdentityCode must be unique, and URL must be unique 
ClassMethod ObjectForOID(pOID As %String = "") As HS.Data.OIDMap
{
	Set tSC=..OIDRow(pOID,.pID)
	Set tOID=..%OpenId(pID)
	If '$IsObject(tOID) {
		Quit ""
	}
	Set tOID.IdentityCode=$piece(tOID.IdentityCode,"~~~")
	Set tOID.URL=$piece(tOID.URL,"~~~")
	quit tOID
}

/// HSIE-3613 Changes in behavior to HS.Data.OIDMAP class methods:
/// 1. A facility may have one active OID and any number of historical OIDs. Historical OIDs will have '~~~' contained within the IdentityCode, and possibly within the URL.
/// 2. This method has been updated to strip away everything after and including '~~~' for both IdentityCode and URL properties.
/// Since this method may return an altered object (e.g. a historical OID row with '~~~' characters in IdentityCode and possible URL), attempting to save an altered object
/// will throw an exception as DuplicateCheck enforces validation: IdentityCode must be unique, and URL must be unique 
ClassMethod ObjectForURL(pURL As %String = "") As HS.Data.OIDMap
{
	Set tSC=..URLRow(pURL,.pID)
	Set tOID=..%OpenId(pID)
	If '$IsObject(tOID) {
		Quit ""
	}
	Set tOID.IdentityCode=$piece(tOID.IdentityCode,"~~~")
	Set tOID.URL=$piece(tOID.URL,"~~~")
	quit tOID
}

/// *** Deprecated by GetOIDForCode() - For clarity this method has been deprecated by GetOIDForCode() ***
/// either returns the entry for the IdentityCode or returns pDefault which is pIdentityCode if a pDefault is not defined,<br>
/// pIdentityType is ignored.
ClassMethod OIDForType(pIdentityCode As %String, pIdentityType As %String = "", pDefault As %String) As %String [ CodeMode = expression ]
{
..GetOIDForCode($g(pIdentityCode),$g(pDefault))
}

/// either returns the entry for the IdentityCode or returns pDefault which is blank if a pDefault is not defined.<br>
/// Use this method instead of OIDForType()
ClassMethod GetOIDForCode(pIdentityCode As %String = "", pDefault As %String) As %String
{
	Set tDefault=$G(pDefault)
	&sql(select OID into :tOID from HS_Data.OIDMap where IdentityCode=:pIdentityCode)
	If 'SQLCODE {
		Quit tOID
	}
	Else { // Search again using Aliases
		&SQL(select OIDMap->OID into tOID from OIDMap_IdentityCodeAliases where IdentityCodeAliases = :pIdentityCode)
	}
	If 'SQLCODE {
		Quit tOID
	}
	Quit tDefault
}

/// either returns the entry for the IdentityCode or returns pDefault which is blank if a pDefault is not defined.<br>
ClassMethod GetURLForCode(pIdentityCode As %String = "", pDefault As %String) As %String
{
	Set tDefault=$G(pDefault)
	&sql(select URL into :tURL from HS_Data.OIDMap where IdentityCode=:pIdentityCode)
	If 'SQLCODE {
		Quit tURL
	}
	Else { // Search again using Aliases
		&SQL(select OIDMap->URL into tURL from OIDMap_IdentityCodeAliases where IdentityCodeAliases = :pIdentityCode)
	}
	If 'SQLCODE {
		Quit tURL
	}
	Quit tDefault
}

/// returns the first found of URL, OID or the default. Default is blank if not defined.<br>
ClassMethod GetURIForCode(pIdentityCode As %String = "", pDefault As %String) As %String
{
	Set tDefault=$G(pDefault)
	Set tURI = ..GetURLForCode(pIdentityCode, "")
	If tURI'="" Quit tURI
	Set tURI = ..GetOIDForCode(pIdentityCode, "")
	If tURI'="" Set:$Extract($ZConvert(tURI,"L"),1,8)'="urn:oid:" tURI = "urn:oid:"_tURI Quit tURI
	Quit tDefault
}

/// Given an oid, return the Code if there is one row matching the oid
ClassMethod GetCodeForOID(pOID As %String = "", pDefault As %String) As %String
{
	Set pDefault=$g(pDefault,pOID)
	&sql(select IdentityCode into :tCode from HS_Data.OIDMap where OID=:pOID )
	If 'SQLCODE  {
		Quit $piece(tCode,"~~~")
	}
	Quit pDefault
}

/// Given a URL, return the Code if there is one row matching the URL
ClassMethod GetCodeForURL(pURL As %String = "", pDefault As %String) As %String
{
	Set pDefault=$g(pDefault,pURL)
	&sql(select IdentityCode into :tCode from HS_Data.OIDMap where URL=:pURL )
	If 'SQLCODE  {
		Quit $piece(tCode,"~~~")
	}
	Quit pDefault
}

/// Given a URI, figure out whether it is a OID, URL, or UUID, and then lookup the Code, if applicable.
ClassMethod GetCodeForURI(pURI As %String = "", pDefault As %String) As %String
{
	Set pDefault=$g(pDefault,pURI)
	
	Set tReturn = ""
	
	If $ZConvert($Extract(pURI,1,8),"L")="urn:oid:" {
		Set pURI = $Extract(pURI,9,*)
		Set tReturn = ..GetCodeForOID(pURI, pDefault)
	} ElseIf (($Extract(pURI)="1")||($Extract(pURI)="2"))&&($Length(pURI,".")>3)&&($Translate(pURI,".0123456789")="") {
		Set tReturn = ..GetCodeForOID(pURI, pDefault)
	} ElseIf ($ZConvert($Extract(pURI,1,7),"L")="http://")||($ZConvert($Extract(pURI,1,8),"L")="https://") {
		Set tReturn = ..GetCodeForURL(pURI, pDefault)
	} Else {
		#; Other URI types such as UUID are not handled by OID Registry.
		Set tReturn = pDefault
	}
	Quit tReturn
}

/// Given a URL, return the OID if there is one row matching the URL.  Returns the URL if no OID is found.
ClassMethod GetOIDForURL(pURL As %String = "") As %String
{
	Set tDefault=pURL
	&sql(select OID into :tOID from HS_Data.OIDMap where URL=:pURL )
	If 'SQLCODE  {
		Quit tOID
	}
	Quit tDefault
}

/// Given an OID, return the URL if there is one row matching the OID.  Returns the OID if no URL is found.
ClassMethod GetURLForOID(pOID As %String = "") As %String
{
	Set tDefault=pOID
	&sql(select URL into :tURL from HS_Data.OIDMap where OID=:pOID )
	If 'SQLCODE  {
		Quit $piece(tURL,"~~~")
	}
	Quit tDefault
}

/// *** Deprecated by GetCodeForOID() ***
/// Given an oid, return the Code if there is one row matching the oid (pType is ignored)
ClassMethod CodeForOID(pOID As %String = "", pType As %String = "", pDefault As %String) As %String [ CodeMode = expression ]
{
..GetCodeForOID($g(pOID),$g(pDefault))
}

/// pAdditionalTypeList is an optional comma separated string.  If passed in, the OID and/or URL will also be used for those types
ClassMethod FileOID(pCode As %String, pType As %String = "", pOID As %String = "", pDescription As %String = "", pAdditionalTypeList As %String = "", pURL As %String = "", pIdentityCodeAliases As %String = "") As %Status
{
	// Call CreateOrUpdateOID with all arguments defined (defaulting to empty)
	Quit ..CreateOrUpdateOID(pCode, pType, pOID, pDescription, pAdditionalTypeList, pURL, pIdentityCodeAliases)
}

/// Similar to FileOID, but will only make changes if the argument is defined.
/// Omit a parameter to leave it unchanged; only <var>pCode</var> is required.
ClassMethod CreateOrUpdateOID(pCode As %String, pType As %String, pOID As %String, pDescription As %String, pAdditionalTypeList As %String, pURL As %String, pIdentityCodeAliases As %String) As %Status
{
	#define IsDefined(%var) ($Data(%var)#2)
	Set SQLCODE="",tID=""
	If ($Get(pType) ] "") {
		&sql(select OIDMap into :tID from HS_Data.OIDMap_identitytypes where OIDMap->IdentityCode=:pCode)
	} Else {
		&sql(select ID into :tID from HS_Data.OIDMap where IdentityCode=:pCode)
	}
	If 'SQLCODE,tID]"" {
		Set tOBJ = ..%OpenId(tID,,.tSC)
		If $$$ISERR(tSC) {
			Quit tSC
		}
		If ($Get(pOID,tOBJ.OID) = "") && ($Get(pURL,tOBJ.URL) = "") {
			Kill tOBJ
			/// pOID and pURL now null, delete the original record
			Set tSC=..%DeleteId(tID)
			Quit tSC
		}
	} Else {
		/// no need to save anything if pOID and pURL are both ""
		If ($Get(pOID)="") && ($Get(pURL)="") {
			Quit $$$OK
		}
		Set tOBJ=..%New()
	}
	Set tOBJ.IdentityCode=pCode
	
	If $$$IsDefined(pType) && $$$IsDefined(pAdditionalTypeList) {
		// Initialize IdentityTypes to reload.  This allows updates via API to remove prior entries.
		Do tOBJ.IdentityTypes.Clear()
	}
	If $$$IsDefined(pType) && 'tOBJ.IdentityTypes.FindObjectId(pType) {
		Do tOBJ.IdentityTypes.InsertObjectId(pType)
	}
	If $$$IsDefined(pAdditionalTypeList) {
		// Parse AdditionalTypeList and add new items.  This code prevents duplication.
		For tI=1:1:$L(pAdditionalTypeList,",") {
			Set tType=$P(pAdditionalTypeList,",",tI)
			Continue:tType=""
			Continue:tOBJ.IdentityTypes.FindObjectId(tType)
			Do tOBJ.IdentityTypes.InsertObjectId(tType)
		}
	}
	If $$$IsDefined(pDescription) {
		Set tOBJ.Description=pDescription
	}
	If $$$IsDefined(pOID) {
		Set tOBJ.OID=pOID
	}
	If $$$IsDefined(pURL) {
		Set tOBJ.URL=pURL
	}
	
	If $$$IsDefined(pIdentityCodeAliases) {
		// Initialize Aliases to reload.  This allows updates via API to remove prior entries.
		Do tOBJ.IdentityCodeAliases.Clear()
		// Parse alias list, skipping empty/duplicate entries
		For tI=1:1:$L(pIdentityCodeAliases,",") {
			Set tAlias=$P(pIdentityCodeAliases,",",tI)
			Continue:tAlias=""
			Continue:tOBJ.IdentityCodeAliases.Find(tAlias)
			Do tOBJ.IdentityCodeAliases.Insert(tAlias)
		}
	}
	Quit tOBJ.%Save()
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	try {
		Set tSC=$$$OK
		Set tCode = ..IdentityCode
		Set tOID = ..OID
		Set tURL = ..URL
		If ((tOID="") && (tURL="")) Set tSC=$$$ERROR($$$GeneralError,"At least one of OID or URL are Required!")
		If $$$ISOK(tSC)
		{
			Set tSC = $$$OK
			Set tID = ..%Id()
			#; new record
			Set tSC = ..DuplicateCheck(tID,tCode,tOID,tURL,insert)
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod DuplicateCheck(pID, pCode, pOID, pURL, pInsert) As %Status
{
	try {
		Set tSC = $$$OK
		If pID ="" {
			&sql(Select Count(ID) into :tCount from OIDMap where OID=:pOID and IdentityCode <> :pCode)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 Code is permitted for each OID.  OID: "_pOID_" and Code: "_pCode)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where URL=:pURL and IdentityCode <> :pCode)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 Code is permitted for each URL.  URL: "_pURL_" and Code: "_pCode)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where IdentityCode=:pCode and OID <> :pOID)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 OID is permitted for each Code.  Code: "_pCode_" and OID: "_pOID)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where IdentityCode=:pCode and URL <> :pURL)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 URL is permitted for each Code.  Code: "_pCode_" and URL: "_pURL)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where IdentityCode=:pCode and OID=:pOID)
			If (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"OID: "_pOID_" already exists with Code: "_pCode)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where IdentityCode=:pCode and URL=:pURL)
			If (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"URL: "_pURL_" already exists with Code: "_pCode)
				Quit
			}
		} Else {
			&sql(Select Count(ID) into :tCount from OIDMap where OID=:pOID and IdentityCode <> :pCode and ID<>:pID)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 Code is permitted for each OID.  OID: "_pOID_" and Code: "_pCode)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where URL=:pURL and IdentityCode <> :pCode and ID<>:pID)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 Code is permitted for each URL.  URL: "_pURL_" and Code: "_pCode)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where IdentityCode=:pCode and OID <> :pOID and ID<>:pID)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 OID is permitted for each Code.  Code: "_pCode_" and OID: "_pOID)
				Quit
			}
			&sql(Select Count(ID) into :tCount from OIDMap where IdentityCode=:pCode and URL <> :pURL and ID<>:pID)
			IF (tCount) {
				Set tSC = $$$ERROR($$$GeneralError,"Only 1 URL is permitted for each Code.  Code: "_pCode_" and URL: "_pURL)
				Quit
			}
		}
	} catch ex {
		Set tSC =ex.AsStatus()
	}
	Quit tSC
}

Trigger OnInsertUpdate [ Event = INSERT/UPDATE ]
{
	Set tSC = ..DuplicateCheck({ID},{IdentityCode},{OID},{URL})
	IF $$$ISERR(tSC) Set %ok=0,%msg=$system.Status.GetErrorText(tSC)
	Quit tSC
}

Method %OnAfterSave(pInsert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	
	/// Create a new code system when an OID is entered for it
	/// (Only done on the Hub to prevent attempting to create code systems again when syncing)
	If ..IdentityTypes.FindObjectId("CodeSystem"),$$$IsHub {
		$$$HCInvoke(tSC,$$$OK,"AddCodeSystem",..IdentityCode,..Description)
		/*
		If ##class(%Dictionary.ClassDefinition).%ExistsId("HS.Registry.CodeSystem") {
			Set tSC = $classMethod("HS.Registry.CodeSystem","AddCodeSystem",..IdentityCode,..Description)
		}
		*/
	}
	
	// Flush the OIDs cache that is used by CDA transforms.
	If $$$ISOK(tSC) {
		Set tSC = ..flushOIDCache()
	}

	Quit tSC
}

Query OrganizationItems() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,IdentityCode FROM OIDMap
 Group BY IdentityCode
}

Property Types As %String [ Calculated, SqlComputeCode = {Set {*}=##Class(HS.Data.OIDMap).CMTypesGet({ID})}, SqlComputed ];

ClassMethod CMTypesGet(pID) As %String
{
	Set obj=..%OpenId(pID,0)
	Quit $S($isObject(obj):obj.Types,1:"")
}

Method TypesGet() As %String [ ServerOnly = 1 ]
{
	Set str=""
	For tIdx=1:1:..IdentityTypes.Count() {
		Set tType=..IdentityTypes.GetAt(tIdx) continue:'$isObject(tType)
		Set str=str_","_..IdentityTypes.GetAt(tIdx).Description
	}
	quit $E(str,2,*)
}

Property Aliases As %String(MAXLEN = 512) [ Calculated, SqlComputeCode = {Set {*}=##Class(HS.Data.OIDMap).CMAliasesGet({ID})}, SqlComputed ];

ClassMethod CMAliasesGet(pID) As %String
{
	Set obj=..%OpenId(pID,0)
	Quit $S($isObject(obj):obj.Aliases,1:"")
}

Method AliasesGet() As %String [ ServerOnly = 1 ]
{
	Set str=""
	For tIdx=1:1:..IdentityCodeAliases.Count() {
		Set tAlias=..IdentityCodeAliases.GetAt(tIdx) continue:tAlias=""
		Set str=str_","_..IdentityCodeAliases.GetAt(tIdx)
	}
	quit $E(str,2,*)
}

Query OIDItems(pType As %String, pSearch As %String = "") As %Query(ROWSPEC = "ID:%Integer,IdentityCode:%String,Types:%String,OID:%String,Description:%String,URL:%String,Aliases:%String")
{
}

ClassMethod OIDItemsExecute(ByRef qHandle As %Binary, pType As %String, pSearch As %String = "") As %Status
{
	Set qHandle=##class(%ResultSet).%New()
	If $g(pType)="" {
		Set tArgs=0,tWhere=""
		If pSearch'="" {
			Set tArgs=6 For tI=1:1:6 Set tArgs(tI)=$ZCVT(pSearch,"U")
			Set tWhere=" Where Upper(IdentityCode)[? OR Upper(Types)[? OR Upper(OID)[? Or Upper(Description)[? Or Upper(URL)[? Or Upper(Aliases)[?"
		}
		Set tSQL="SELECT %ID,IdentityCode,Types as IdentityType,OID, Description, URL,Aliases FROM HS_Data.OIDMap"_tWhere_" ORDER BY IdentityCode"
		
		Do qHandle.Prepare(tSQL)
		Do qHandle.Execute(tArgs...)
	} Else {
		Set tArgs=1,tArgs(1)=pType, tAnd=""
		If pSearch'="" {
			Set tArgs=6 For tI=2:1:6 Set tArgs(tI)=$ZCVT(pSearch,"U")
			Set tAnd=" And (Upper(OIDMap->IdentityCode)[? OR Upper(OIDMap->OID)[? Or Upper(OIDMap->Description)[? Or Upper(OIDMap->URL)[? Or Upper(OIDMap->Aliases)[?)"
		}
		Set tSQL="SELECT OIDMap,OIDMap->IdentityCode,IdentityTypes as IdentityType,OIDMap->OID, OIDMap->Description, OIDMap->URL, OIDMap->Aliases FROM HS_Data.OIDMap_IdentityTypes Where IdentityTypes=?"_tAnd_" ORDER BY OIDMap->IdentityCode"
		Do qHandle.Prepare(tSQL)
		Do qHandle.Execute(tArgs...)
	}	
	Quit $$$OK
}

ClassMethod OIDItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OIDItemsExecute ]
{
	Set qHandle=""
	Quit $$$OK
}

ClassMethod OIDItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OIDItemsExecute ]
{
	Set AtEnd='qHandle.%Next()
	Set Row=$S(AtEnd:"",1:$lb(qHandle.GetData(1),qHandle.GetData(2),qHandle.GetData(3),qHandle.GetData(4),qHandle.GetData(5),qHandle.GetData(6),qHandle.GetData(7)))
	Quit $$$OK
}

/// flushOIDCache flushes out an OID cache that is built and
/// used by HS.Util.XSLTHelper getOIDForCode and getCodeForOID,
/// and getURLForCode and getCodeForURL.
/// The use of background job, Locks, and Hangs here is to
/// avoid excessive killing of the cache upon sudden numerous
/// updates to HS_Data.OIDMap.
ClassMethod flushOIDCache(job As %Boolean = 0) As %Status
{
	Set tNamespace=$$$OIDMapCacheNS
	
	If $Data(^CacheTemp.OIDMap(tNamespace))=0 Quit $$$OK
	
	Set tSC = $$$OK
	
	If 'job {
		Set ^HS.Data.OIDMap.flushOIDCache(tNamespace)=1
		#; another process is taking care of this if we can't get the lock
	 	Lock +^HS.Data.OIDMap.flushOIDCache(tNamespace):0 Quit:'$T $$$OK
	 	Job ##class(HS.Data.OIDMap).flushOIDCache(1)
	 	Lock -^HS.Data.OIDMap.flushOIDCache(tNamespace)
		Quit $$$OK
	}
	#; quit if another job happened to get the lock
	Lock +^HS.Data.OIDMap.flushOIDCache(tNamespace):10 Quit:'$T $$$OK
	For {
		#; each process coming in will set this value to 1 so proceed if we've waited 15 seconds and no one has changed it
		Quit:'^HS.Data.OIDMap.flushOIDCache(tNamespace)
		Set ^HS.Data.OIDMap.flushOIDCache(tNamespace)=0
		Hang 15
	}
	Lock -^HS.Data.OIDMap.flushOIDCache(tNamespace)
	
	Kill ^CacheTemp.OIDMap(tNamespace)
		
	Quit tSC
}

/// Input: 
/// pPath: Full path/filename for output files
/// pOIDList: OIDs to export, if empty, export all.
ClassMethod ExportToFile(pPath, pOIDList As %String = "") As %Status
{
	Set tSC=$$$OK
	Try {
		
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1
		Set tWriter.IndentChars = $char(9)	// 9 is Tab
		
		Set tSC = tWriter.OutputToFile(pPath)
		If $$$ISERR(tSC) Quit
		Set tOIDString=""
		Set txParam=0
		If ($E(pOIDList,1)="("){	//pOIDList looks like either "('1','2','3')" or ""; get rid of the parentheses
			Set tOIDList=$E(pOIDList,2,*-1)
			For tIdx = 1:1:$length(tOIDList,",") {
				Set tOID = $tr($piece(tOIDList,",",tIdx),"'","")
				Set txParam($i(txParam))=tOID
				Set:tOIDString]"" tOIDString=tOIDString_","
				Set tOIDString=tOIDString_"?"
			}
		}
		
		Set tSQL = "SELECT ID FROM HS_Data.OIDMap"
		Set:tOIDString'="" tSQL=tSQL_" WHERE ID in ("_tOIDString_")"
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tSC=tStatement.%Prepare(.tSQL) Quit:$$$ISERR(tSC)
		If (txParam>0){
			Set tRS=tStatement.%Execute(txParam...)
		}
		Else{
			Set tRS=tStatement.%Execute()
		}
		
		Set tXMLOut = ##class(%ListOfObjects).%New()

		While tRS.%Next() {
			Set tOIDMap=##class(HS.Data.OIDMap).%OpenId(tRS.ID)
			Set tSC = tXMLOut.Insert(tOIDMap)
		}
		
		Set tSC = tWriter.RootElement("root")
		If $$$ISERR(tSC) Quit
		
		For i=1:1:tXMLOut.Size {
			Set tSC = tWriter.Object(tXMLOut.GetAt(i))
			If $$$ISERR(tSC) Quit
		}
	
		Set tSC = tWriter.EndRootElement()
		If $$$ISERR(tSC) Quit
		
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// Input: pPath - fully pathed file name
ClassMethod ImportFromFile(pPath) As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		If pPath="" Set tSC = $$$ERROR($$$GeneralError,"Input file not specified") Quit
		
		If '##class(%File).Exists(pPath) Set tSC = $$$ERROR($$$FileDoesNotExist,pPath) Quit
		
		Set reader = ##class(%XML.Reader).%New()
		Set tSC = reader.OpenFile(pPath)
		If $$$ISERR(tSC) Quit
		
		KILL ^ISC.HS.OIDRegistry($Username)
		Set ^ISC.HS.OIDRegistry($Username,"File")=pPath
		
		Do reader.Correlate("OIDMap","HS.Data.OIDMap")
		
		// Initialize counter for total # processed
		Set tCounter=0
		
		While reader.Next(.tObject,.tSC) {
			If '$IsObject($G(tObject)) Continue
			
			// Keep track of total number of objects processed
			Set tCounter=$i(tCounter)
			
			// Initialize tSC for this object
			Set tSC=$$$OK
			
			// Parse first IdentityType, then any others as AdditionalTypes as this is passed as a separate parameter
			Set tAdditionalTypes=""
			For i=1:1:tObject.IdentityTypes.Count() {
				If i=1 {
					Set tFirstIdentityType=tObject.IdentityTypes.GetAt(1).Description
					Continue
				}
				Set tAdditionalTypes=$S(tAdditionalTypes'="":tAdditionalTypes_",",1:"")_tObject.IdentityTypes.GetAt(i).Description
				
			}
			
			// Call FileOID to build the record and save it
			Set tSC=##class(HS.Data.OIDMap).FileOID(tObject.IdentityCode,tFirstIdentityType,tObject.OID,tObject.Description,tAdditionalTypes,tObject.URL,tObject.Aliases)
			
			// Handle any errors reported by FileOID
			If $$$ISERR(tSC) {
				// log errors and keep processing
				Set tErrorText=$System.Status.GetErrorText(tSC)
				Set discard=$I(^ISC.HS.OIDRegistry($Username,"Errors")) // # of occurrences of errors
				Set ^ISC.HS.OIDRegistry($Username,"Errors",tObject.IdentityCode)=tErrorText // Full text for this error
			}
		}
		// Store total number of objects processed.
		Set ^ISC.HS.OIDRegistry($Username,"Total")=tCounter
		Quit
	}
	Catch ex
	{
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) Write !,$System.Status.GetErrorText(tSC),!!
	
	Quit tSC
}

Storage Default
{
<Data name="IdentityCodeAliases">
<Attribute>IdentityCodeAliases</Attribute>
<Structure>subnode</Structure>
<Subscript>"IdentityCodeAliases"</Subscript>
</Data>
<Data name="IdentityTypes">
<Attribute>IdentityTypes</Attribute>
<Structure>subnode</Structure>
<Subscript>"IdentityTypes"</Subscript>
</Data>
<Data name="OIDMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OID</Value>
</Value>
<Value name="3">
<Value>IdentityCode</Value>
</Value>
<Value name="4">
<Value>IdentityType</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>URL</Value>
</Value>
</Data>
<DataLocation>^HS.Data.OIDMapD</DataLocation>
<DefaultData>OIDMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Data.OIDMapD</IdLocation>
<IndexLocation>^HS.Data.OIDMapI</IndexLocation>
<StreamLocation>^HS.Data.OIDMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

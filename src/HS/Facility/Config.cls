Include HS.HC

/// Include (Ensemble, HS.Common, %occErrors)
Class HS.Facility.Config Extends (%Persistent, HS.Types.FacilityInfo, %XML.Adaptor, HS.Sync.BaseClass) [ ClassType = persistent, Inheritance = right ]
{

Parameter RESOURCE As STRING = {$$$HSHubManagement};

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 40;

Property LastUpdate As %TimeStamp(ZENREADONLY = 1) [ SqlComputeCode = {set {*}=$ZDT($H,3)}, SqlComputed, SqlComputeOnChange = (%%INSERT, %%UPDATE) ];

Index UpdateIndex On LastUpdate;

Relationship Gateway As HS.Gateway.Config(ZENSIZE = 60, ZENSQL = "SELECT ID, Name FROM HS_Gateway.Config", ZENSQLLOOKUP = "SELECT Name FROM HS_Gateway.Config WHERE ID=?") [ Cardinality = one, Inverse = Facilities ];

Index GatewaysIndex On Gateway;

Index FacilityIdIndex On FacilityId [ Unique ];

Index ExternalHIEIndex On ExternalHIE;

Index IDKEY On FacilityCode [ IdKey, Unique ];

/// API Method: Load facility info into an object
/// Returns 1 if OK, 0 if facility not found
ClassMethod LoadFacility(pFacilityCode As %String, Output pFacilityInfo As HS.Types.FacilityInfo) As %Boolean
{
	Set tFacilityInfo=..%OpenId(pFacilityCode) Quit:'$IsObject(tFacilityInfo) 0
	Do ##class(HS.Types.FacilityInfo).CopyFrom(tFacilityInfo,.pFacilityInfo)
	Set pFacilityInfo.Contact=tFacilityInfo.Contact
	Quit 1
}

/// API Method: Do add/update save of facility info
ClassMethod SaveFacility(pFacilityInfo As HS.Types.FacilityInfo) As %Status
{
	#dim tSC as %Status = $$$OK
	Try {
		Set tFacility=..%OpenId(pFacilityInfo.FacilityCode)
		Set:'$IsObject(tFacility) tFacility=..%New()
		Do tFacility.CopyFrom(pFacilityInfo,tFacility)
		Set tFacility.Contact=pFacilityInfo.Contact
		Set tSC=tFacility.%Save()
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Delete a facility
/// Simple wrapper around %DeleteId
ClassMethod DeleteFacility(pFacilityCode As %String) As %Status [ Internal ]
{
	Quit ..%DeleteId(pFacilityCode)
}

/// Locate the gateway endpoint string using tha facility 'code'
ClassMethod FindGatewayEndpointByCode(FacilityCode As %String, ByRef Endpoint As %String) As %Status [ Internal ]
{
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		Set Endpoint = ""
		
		Set tSC = ..FindByFacilityCode(FacilityCode, .Id, .GatewayId, .FacilityId)
		If $$$ISERR(tSC) {
			If +$P($system.Status.GetErrorCodes(tSC),",") = $$$KeyNotFound {
				// Embed the error and return facility not found ...
				Set tSC = $$$EMBEDSC($$$HSError($$$HSErrFacilityNotFound,FacilityCode),tSC)
			}
			Quit
		}
		
		#dim tGW As HS.Gateway.Config
		Set tGW = ##class(HS.Gateway.Config).%OpenId(GatewayId,,.tSC)
		Quit:$$$ISERR(tSC)
		
		Set Endpoint = tGW.EndPoint
		
	} While (0)
Exit

	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

ClassMethod FindByFacilityCode(Code As %String, ByRef Id As %Integer, ByRef GatewayId As %Integer, ByRef FacilityId As %String = "") As %Status [ Internal ]
{
	Set tSC = $$$OK
	&SQL(SELECT Id,Gateway,FacilityId INTO :Id,:GatewayId,:FacilityId FROM HS_Facility.Config WHERE FacilityCode=:Code)
	If SQLCODE {
		Set (Id,GatewayId,FacilityId)=""
		Set tSC = $S(SQLCODE=100:$$$HSError($$$HSErrFacilityNotFound,Code),1:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)))
	}
	Quit tSC
}

ClassMethod FindByFacilityId(FacilityId As %String = "", ByRef Name As %String, ByRef Id As %Integer, ByRef GatewayId As %Integer, ByRef Code As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	&SQL(SELECT Name,Id,Gateway,FacilityCode INTO :Name,:Id,:GatewayId,:Code FROM HS_Facility.Config WHERE FacilityId=:FacilityId)
	If SQLCODE {
		Set (Name,Id,GatewayId)=""
		Set tSC = $S(SQLCODE=100:$$$HSError($$$HSErrFacilityNotFound,FacilityId),1:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)))
	}
	Quit tSC
}

// Note - FacilityCode is the same as %ID

Query ListFacilities(pName As %String = "") As %SQLQuery [ Internal ]
{
SELECT %ID,FacilityId,Name,GatewayName,Gateway->Endpoint,Gateway->Status FROM Config
 WHERE (FacilityCode %STARTSWITH :pName)
 ORDER BY FacilityCode
}

/// Used to replicate part of this table to the gateways
Query GetUpdatedFacilities(pSince As %TimeStamp = "") As %SQLQuery [ Internal ]
{
	SELECT FacilityId,Name,FacilityCode,Description,ConsentGroup
	FROM Config WHERE (LastUpdate > :pSince) OR (:pSince IS NULL)
}

/// Facility list used for Consent setup, as this list is filtered by $$$HSAdminConsentManagement and $$$HSAdminFacilityConsentManagement
Query ListAllFacilities(pIncludeMPI As %Boolean = 0) As %Query(ROWSPEC = "ID:%String,Name:%String,MPISetting:%String,MPISettingString:%String,EffectiveDate:%Date,ExpirationDate:%Date") [ Internal ]
{
}

ClassMethod ListAllFacilitiesExecute(ByRef qHandle As %Binary, pIncludeMPI As %Boolean = 0) As %Status [ Internal, ServerOnly = 1 ]
{
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Consent.WebServices","HS.Consent.WebServicesClient","ListFacilities",.tObj,pIncludeMPI,$Roles)
	If '$$$ISOK(tSC) Quit tSC
	If '$$$ISOK(tObj.Status) Quit tObj.Status
	Set qHandle=tObj
	Set qHandle("POS")=0
	Quit $$$OK
}

ClassMethod ListAllFacilitiesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListAllFacilitiesExecute, ServerOnly = 1 ]
{
	Kill qHandle
	Quit $$$OK
}

ClassMethod ListAllFacilitiesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListAllFacilitiesExecute, ServerOnly = 1 ]
{
	Set Row=""
	Set pos=qHandle("POS")+1
	If pos>qHandle.Items.Count() {Set AtEnd=1}
	Else {
		Set tItem=qHandle.Items.GetAt(pos)
		Set Row=$Lb(tItem.ID,tItem.Name,tItem.Decision,tItem.DecisionString,tItem.EffectiveDate,tItem.ExpirationDate)
	}
	Set qHandle("POS")=pos	
	Quit $$$OK
}

ClassMethod GetHomeFacility(Output pName As %String = "") As %String [ Internal ]
{
	&sql(SELECT ID,Name INTO :tId,:pName FROM HS_Facility.Config WHERE HomeFacility = 1)
	Quit $S(SQLCODE:"",1:tId)
}

Method %OnAfterSave(pInsert As %Boolean) As %Status [ Internal, Private, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	If ##class(HS.Sync.Utils).IsSyncSlave() Quit tSC
	
	/// Only one Home facility
	If ..HomeFacility { 
		Set tId=..%Id()
		&SQL(Update HS_Facility.Config Set HomeFacility=0 WHERE ID <> :tId and HomeFacility <> 0) 
		Set:SQLCODE<0 tSC=$$$ERROR($$$GeneralError,"Unable to update Home Facility")
	}
	
	/// Create doctor and MRN assigning authorities for new facility
	/// Or update the OtherID for an existing facility
	/// (Only done on the Hub to prevent attempting to create assigning authorities again when syncing)
	If ..AssigningAuthority {
		Set tSC = ##class(HS.AssignAuth.Config).AddAssigningAuthority(..FacilityCode,..Name,..FacilityId)
	}

	Quit tSC
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Gateway</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>MPIFacilityID</Value>
</Value>
<Value name="5">
<Value>GatewayName</Value>
</Value>
<Value name="6">
<Value>FacilityID</Value>
</Value>
<Value name="7">
<Value>FacilityId</Value>
</Value>
<Value name="8">
<Value>FacilityCode</Value>
</Value>
<Value name="9">
<Value>Description</Value>
</Value>
<Value name="10">
<Value>Contact</Value>
</Value>
<Value name="11">
<Value>LastUpdate</Value>
</Value>
<Value name="12">
<Value>ConsentGroup</Value>
</Value>
<Value name="13">
<Value>ExternalHIE</Value>
</Value>
<Value name="14">
<Value>OID</Value>
</Value>
<Value name="15">
<Value>Roles</Value>
</Value>
<Value name="16">
<Value>Tier</Value>
</Value>
<Value name="17">
<Value>HomeFacility</Value>
</Value>
<Value name="18">
<Value>AssigningAuthority</Value>
</Value>
<Value name="19">
<Value>IgnoreProviderUpdates</Value>
</Value>
</Data>
<Data name="IPAddresses">
<Attribute>IPAddresses</Attribute>
<Structure>subnode</Structure>
<Subscript>"IPAddresses"</Subscript>
</Data>
<DataLocation>^HS.Facility.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Facility.ConfigD</IdLocation>
<IndexLocation>^HS.Facility.ConfigI</IndexLocation>
<StreamLocation>^HS.Facility.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

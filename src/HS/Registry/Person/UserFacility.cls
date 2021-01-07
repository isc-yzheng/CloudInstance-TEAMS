Include HS.HC

Class HS.Registry.Person.UserFacility Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter DSTIME = "AUTO";

Parameter DSINTERVAL = 5;

Relationship UserClinician As HS.Registry.Person.User [ Cardinality = parent, Inverse = Facilities ];

/// Facility Code, IDKEY to Facility Table.
/// MAXLEN taken from <class>HS.Facility.Config</class>.
Property FacilityCode As %String(MAXLEN = 256);

/// One facilioty for the user is designated as primary
Property PrimaryFlag As %Boolean;

/// Aditional Roles assigned to the user by that facility
Property Roles As list Of %String(MAXLEN = 64);

/// Returns the primary facility for a user
ClassMethod PrimaryFacility(pUserId As %String) As %String
{
	Set tId=""
	&sql(SELECT ID INTO :tId FROM HS_Registry_Person.UserFacility WHERE UserClinician=:pUserId AND PrimaryFlag=1)
	Quit tId
}

/// List login IDs via web service call
Query ListUserFacilities(pRegistryId As %String) As %Query(ROWSPEC = "ID:%String,Facility:%String,PrimaryFlag:%Boolean")
{
}

ClassMethod ListUserFacilitiesExecute(ByRef qHandle As %Binary, pRegistryId As %String) As %Status [ ServerOnly = 1 ]
{
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","ListUserFacilities",.tObj,pRegistryId)
	If '$$$ISOK(tSC) Quit tSC
	If '$$$ISOK(tObj.Status) Quit tObj.Status
	Set qHandle=tObj
	Set qHandle("POS")=0
	Quit $$$OK
}

ClassMethod ListUserFacilitiesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListUserFacilitiesExecute, ServerOnly = 1 ]
{
	Kill qHandle
	Quit $$$OK
}

ClassMethod ListUserFacilitiesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListUserFacilitiesExecute, ServerOnly = 1 ]
{
	Set Row=""
	Set pos=qHandle("POS")+1
	If pos>qHandle.Items.Count() {Set AtEnd=1}
	Else {
		Set tItem=qHandle.Items.GetAt(pos)
		Set Row=$Lb(tItem.ID,tItem.Facility,tItem.PrimaryFlag)
	}
	Set qHandle("POS")=pos	
	Quit $$$OK
}

/// Delete after validating (none currently)
ClassMethod DeleteData(id As %String, concurrency As %Integer = -1) As %Status
{
	Quit ..%DeleteId(id,concurrency)
}

/// Called as a generated field from HS.IHE.ATNA.Repository.Aggregation using the HCInvoke
ClassMethod GetPrimFac(pUserName, Output pFacility)
{
	Set pFacility=""
	&SQL(Select FacilityCode into :tFac FROM HS_Registry_Person.UserFacility WHERE UserClinician->UserID=:pUserName AND PrimaryFlag=1)
	If SQLCODE'=0 {
		Set pFacility="Unknown"
	} Else {
		Set pFacility=tFac
	}
	Quit $$$OK
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	Set tUserId=..UserClinician.%Id()
	Set tFacCode=..FacilityCode
	&SQL(SELECT ID INTO :tId FROM UserFacility WHERE UserClinician = :tUserId AND FacilityCode = :tFacCode)
	If 'SQLCODE&&(tId'=..%Id()) {
		Set tSC=$$$HSError($$$HSErrFacilityDuplicate)
	} Else {
		Set tSC=$$$OK
	}
	Quit tSC
}

Storage Default
{
<Data name="UserFacilityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FacilityCode</Value>
</Value>
<Value name="3">
<Value>PrimaryFlag</Value>
</Value>
<Value name="4">
<Value>Roles</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.PBAF2.UserFacilityD</DataLocation>
<DefaultData>UserFacilityDefaultData</DefaultData>
<IdLocation>^HS.Registry.PBAF2.UserFacilityD</IdLocation>
<IndexLocation>^HS.Registry.PBAF2.UserFacilityI</IndexLocation>
<StreamLocation>^HS.Registry.PBAF2.UserFacilityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

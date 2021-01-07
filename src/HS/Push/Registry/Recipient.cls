Include HS.HC

/// Used for system recipients, and extended by the person.user registry for user type recipients
Class HS.Push.Registry.Recipient Extends (%Persistent, HS.Util.DataModel.Adaptor, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

/// For users as recipients, security is managed in HS.Registry.User.Person.
/// For recipients in general (e.g., systems), hub management is required.
Parameter RESOURCE As STRING = {$$$HSHubManagement};

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Name index 
Index NameIdx On (Type, Name);

/// Recipient Name
Property Name As %String(MAXLEN = 256);

/// Whether a Receiving System or Clinician
Property Type As %String(DISPLAYLIST = ",System,Clinician,User", VALUELIST = ",S,C,U", ZENREADONLY = 1);

/// Description of clinician
Property Description As %String(MAXLEN = "");

/// Set to True to prevent recipient from being selected
Property Active As %Boolean [ InitialExpression = 1 ];

/// %HS* domains, copied from Security.Users
/// Include special consent-group roles (HSGROUP*)
/// Roles assigned to the recipient
Property Roles As list Of %String(MAXLEN = 64);

/// List receiving systems via web service call
Query ListReceivingSystems(pActiveOnly As %String, pName As %String = "", pDelivery As %Boolean = 0) As %Query(ROWSPEC = "ID:%String,Name:%String,Description:%String,Active:%Boolean")
{
}

ClassMethod ListReceivingSystemsExecute(ByRef qHandle As %Binary, pActiveOnly As %Boolean = 1, pName As %String = "", pDelivery As %Boolean) As %Status [ ServerOnly = 1 ]
{
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Push.WebServices","HS.Push.WebServicesClient","ListReceivingSystems",.tObj,pActiveOnly,pName,pDelivery)
	If '$$$ISOK(tSC) Quit tSC
	If '$$$ISOK(tObj.Status) Quit tObj.Status
	Set qHandle=tObj
	Set qHandle("POS")=0
	Quit $$$OK
}

ClassMethod ListReceivingSystemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListReceivingSystemsExecute, ServerOnly = 1 ]
{
	Kill qHandle
	Quit $$$OK
}

ClassMethod ListReceivingSystemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListReceivingSystemsExecute, ServerOnly = 1 ]
{
	Set Row=""
	Set pos=qHandle("POS")+1
	If pos>qHandle.Items.Count() {Set AtEnd=1}
	Else {
		Set tItem=qHandle.Items.GetAt(pos)
		Set Row=$Lb(tItem.ID,tItem.Name,tItem.Description,tItem.Active)
	}
	Set qHandle("POS")=pos	
	Quit $$$OK
}

Method GetExistingData(Output pId As %String) As %Status
{
	Set tName=..Name
	&sql(SELECT ID into :tId from Recipient where Name=:tName)
	Set pId=$S(SQLCODE:"",1:tId)
	Quit $$$OK
}

/// Validation before save
Method %OnValidateObject() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	
	// Only one active system allowed with the same name
	If ..Active=1,..Type= "S" {
		Set tName=..Name
		&sql(Select ID INTO :tId FROM HS_Push_Registry.Recipient Where Name = :tName and Active = 1)
		If 'SQLCODE,tId'=..%Id() {
			Set tSC = $$$HSError($$$HSErrSystemNameNotUnique)
		}
	}
		
	Quit tSC
}

Storage Default
{
<Data name="RecipientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>Roles</Value>
</Value>
</Data>
<DataLocation>^HS.Push.Registry.RecipientD</DataLocation>
<DefaultData>RecipientDefaultData</DefaultData>
<IdLocation>^HS.Registry.Person.UserD</IdLocation>
<IndexLocation>^HS.Push.Registry.RecipientI</IndexLocation>
<StreamLocation>^HS.Push.Registry.RecipientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

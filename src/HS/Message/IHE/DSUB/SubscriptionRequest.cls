Class HS.Message.IHE.DSUB.SubscriptionRequest Extends (HS.Util.EnsRequest, HS.Types.IHE.DSUB.Subscription, HS.Types.RequestInfo)
{

/// Define the patient id - use one of the three methods Document/Folder/Patient
Method SetDocumentPatientId(pID, pAssigningAuthority) As %Status
{
	Quit ..AddFilterValues("$XDSDocumentEntryPatientId",pID,pAssigningAuthority)
}

/// Define the patient id - use one of the three methods Document/Folder/Patient
Method SetFolderPatientId(pID, pAssigningAuthority) As %Status
{
	Quit ..AddFilterValues("$XDSFolderPatientId",pID,pAssigningAuthority)
}

/// Define the patient id - use one of the three methods Document/Folder/Patient
Method SetSubmissionPatientId(pID, pAssigningAuthority) As %Status
{
	Quit ..AddFilterValues("$XDSSubmissionSetPatientId",pID,pAssigningAuthority)
}

/// Using a duration such as P7DT4H36M  (7 days, 4 hours, 36 minutes)
Method SetTerminationDuration(pDuration As %String) As %Status
{
	/// tTime UTC time of termination
	Set tSC = ..GetTerminationTimeDuration(pDuration,.tTime)
	Set:$$$ISOK(tSC) ..TerminationTime=$TR($zdt(tTime,3)," ","T")_"Z"
	Quit tSC
}

/// .AddFilterValues("$XDSDocumentEntryHealthcareFacilityTypeCode","EmergencyDepartment","healthcareFacilityCodingScheme","AnotherCode","AnotherCodingScheme","AnotherCode","AnotherCodingScheme"...)<br>
/// pScheme has become optional with the requirement of IntendedRecipient and (SubmissionSet)SourceId
Method AddFilterValues(pFilterItem As %String, pCode As %String, pScheme As %String = "", pAdditionalCodeAndScheme...) As %Status
{
	try {
		Set tSC =$$$OK
		If pFilterItem="$XDSDocumentEntryPatientId"||(pFilterItem="$XDSFolderPatientId")||(pFilterItem="$XDSSubmissionSetPatientId") {
			If pCode="" || (pScheme="") Set tSC = $$$ERROR($$$GeneralError,"Both the identifier and assigning authority are required") Quit
			If $G(pAdditionalCodeAndScheme) Set tSC = $$$ERROR($$$GeneralError,"Only one patient ID may be selected") Quit
			Set ..PatientID=pCode_"^^^&"_pScheme_"&ISO"
			Set tType=..Type
			Set ..Type=$CASE(pFilterItem,"$XDSDocumentEntryPatientId":"Document","$XDSFolderPatientId":"Folder","$XDSSubmissionSetPatientId":"Submission",1:"")
			If tType'=..Type Set tSC=..ValidateFilterItems()
			Quit
		}
		Set tFilterItem = ##class(HS.Types.IHE.DSUB.SubscriptionItems).%New()
		Set tFilterItem.Item=pFilterItem
		Do tFilterItem.Values.Insert(pCode_$S(pScheme="":"",1:"^^"_pScheme))
		For tIdx=1:2:$g(pAdditionalCodeAndScheme) {
			Set tCode=$G(pAdditionalCodeAndScheme(tIdx))
			Set tScheme=$G(pAdditionalCodeAndScheme(tIdx+1))
			If tCode="" && (tScheme="") Set tSC = $$$ERROR($$$GeneralError,"non matching code/scheme pair") Quit
			Do tFilterItem.Values.Insert(tCode_$S(tScheme="":"",1:"^^"_tScheme))
		}
		Do ..FilterItems.Insert(tFilterItem)
		Set tSC=..ValidateFilterItems()
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method ValidateFilterItems() As %Status
{
	try {
		Set tSC =$$$OK
		#; type is one of Document / Folder / SubmissionSet
		Set tType = ..Type
		For tIdx=1:1:..FilterItems.Count() {
			Set tFilterItem = ..FilterItems.GetAt(tIdx).Item
			If tFilterItem'[tType Set tSC = $$$ERROR($$$GeneralError,"Filter Item ["_tIdx_"] "_ tFilterItem_" does not match type") Quit
		}
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.SubscriptionRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.SubscriptionRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="SubscriptionRequestDefaultData">
<Subscript>"SubscriptionRequest"</Subscript>
<Value name="1">
<Value>RecipientAddress</Value>
</Value>
<Value name="2">
<Value>Topic</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>FilterItems</Value>
</Value>
<Value name="5">
<Value>TerminationTime</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>BreakTheGlass</Value>
</Value>
<Value name="8">
<Value>AuthBy</Value>
</Value>
<Value name="9">
<Value>AuthType</Value>
</Value>
<Value name="10">
<Value>BTGReason</Value>
</Value>
<Value name="11">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="12">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="13">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="14">
<Value>Signature</Value>
</Value>
<Value name="15">
<Value>RequestId</Value>
</Value>
<Value name="16">
<Value>RequestingGateway</Value>
</Value>
<Value name="17">
<Value>SAMLData</Value>
</Value>
<Value name="18">
<Value>ClinicalTypes</Value>
</Value>
<Value name="19">
<Value>Consent</Value>
</Value>
<Value name="20">
<Value>RequestingUser</Value>
</Value>
</Data>
<DefaultData>SubscriptionRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

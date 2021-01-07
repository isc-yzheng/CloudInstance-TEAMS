/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class Ens.Enterprise.Portal.MsgFilter.Filter Extends EnsPortal.MsgFilter.Filter [ System = 4 ]
{

Parameter XMLTYPE = "MsgBankFilter";

Parameter HEADERCLASS = "Ens.Enterprise.MsgBank.MessageHeader";

/// List of client systems to restrict a search to.
Property ClientIDs As list Of %String(MAXLEN = "");

/// Set property searchIdentifier to the corresponding location <var>pKey</var>, if not set yet.
/// Serialize the current Filter to IRISTEMP.
Method SaveToVirtualSession(ByRef pKey As %Integer) As %Status
{
	If $G(pKey)<1 {
		Do ##class(EnsPortal.SessionEvents).Initialize()
		Set pKey = $increment(^IRIS.Temp.EnsPortal.Data(%session.SessionId,0,"MsgBank"))
	}
	Set tStatus = ..%SerializeObject(.tSerial)
	If $$$ISERR(tStatus) Quit tStatus
	Set ^IRIS.Temp.EnsPortal.Data(%session.SessionId,0,"MsgBank",pKey) = tSerial
	Do ..SaveToSession() // Also save to the CSP session
	Quit $$$OK
}

/// Deserialize a Filter from IRISTEMP using the key supplied in <var>pKey</var>.
ClassMethod LoadFromVirtualSession(ByRef pKey As %Integer, Output pFilter As EnsPortal.MsgFilter.Filter) As %Status
{
	Set tSC = $$$OK
	Set pFilter = $$$NULLOREF
	Set tSerial = $get(^IRIS.Temp.EnsPortal.Data(%session.SessionId,0,"MsgBank",pKey))
	If tSerial '= "" {
		Set pFilter = ..%Open(tSerial)
	}
	If '$IsObject(pFilter) {
		Set tSC = ..LoadFromSession(.pFilter) // fall back to last filter from this CSP session if this is a new tab
	}
	Quit tSC
}

/// Remove the Filter specified by <var>pKey</var> from IRISTEMP.
ClassMethod DeleteFromVirtualSession(ByRef pKey As %Integer) As %Status
{
	If ($G(pKey)<1) || ('$data(^IRIS.Temp.EnsPortal.Data(%session.SessionId,0,"MsgBank",pKey))) {		
		Quit $$$ERROR($$$DeleteObjectNotFound, $classname(), pKey) 
	}
	Set tNew = ..%New()
	Set tSC = tNew.SaveToVirtualSession(pKey) // replace saved filter with default filter
	Quit tSC
}

/// Serialise the current Filter to the CSP session.
Method SaveToSession() As %Status
{
	If '$IsObject($get(%session)) {
		Quit $$$OK
	}
	Kill %session.Data("Ensemble","MsgBank","SearchCriteria",$namespace)
	Set tStatus = ..%SerializeObject(.tSerial)
	If $$$ISERR(tStatus) Quit tStatus
	Set %session.Data("Ensemble","MsgBank","SearchCriteria",$namespace) = tSerial
	Quit $$$OK
}

/// Remove the current saved Filter from the CSP session.
ClassMethod DeleteFromSession() As %Status
{
	If '$IsObject($get(%session)) Quit $$$OK
	
	Kill %session.Data("Ensemble","MsgBank","SearchCriteria",$namespace)
	Quit $$$OK
}

/// Deserialise a Filter from the current CSP session, or create a new Filter object
/// if no serialised data exists.
ClassMethod LoadFromSession(Output pFilter As EnsPortal.MsgFilter.Filter) As %Status
{
	Kill pFilter
	If '$IsObject($get(%session))  {
		Set pFilter = ..%New()
	}
	Else {
		Set pFilter = ""
		Set tSerial = $get(%session.Data("Ensemble","MsgBank","SearchCriteria",$namespace))
		If tSerial '= "" {
			Set pFilter = ..%Open(tSerial)
		}
		If '$IsObject(pFilter) {
			Set pFilter = ..%New()
		}
	}
	Quit $$$OK
}

ClassMethod HasDefaultVals(pFilter As Ens.Enterprise.Portal.MsgFilter.Filter) As %Boolean
{
	Quit:(pFilter.ClientIDs.Count() > 0) 0
	Quit ##super(pFilter)
}

Storage Default
{
<Data name="FilterState">
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>SortOrder</Value>
</Value>
<Value name="3">
<Value>MaxRows</Value>
</Value>
<Value name="4">
<Value>TimeFormat</Value>
</Value>
<Value name="5">
<Value>IsError</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>StartId</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>EndTime</Value>
</Value>
<Value name="10">
<Value>EndId</Value>
</Value>
<Value name="11">
<Value>Source</Value>
</Value>
<Value name="12">
<Value>Target</Value>
</Value>
<Value name="13">
<Value>SequenceManagerSearch</Value>
</Value>
<Value name="14">
<Value>TopCount</Value>
</Value>
<Value name="15">
<Value>Terms</Value>
</Value>
<Value name="16">
<Value>ColorBy</Value>
</Value>
<Value name="17">
<Value>searchIdentifier</Value>
</Value>
<Value name="18">
<Value>ClientIDs</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

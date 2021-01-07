/// Response to a PatientSearchRequest.  The Results property contains zero or more matching PatientSearchMatch entries.
Class HS.Message.PatientSearchResponse Extends (HS.Util.EnsResponse, HS.Types.RequestInfo, HS.Util.CopyFrom) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNORENULL = "inputonly";

/// True if consent was applied to these search results (i.e. if results were filtered due to consent)
Property ConsentApplied As %Boolean [ InitialExpression = 0 ];

/// Passed into the consent engine - true if it should apply progam consent to override unconsented demographics
Property ProgramConsent As %Boolean [ InitialExpression = 0 ];

/// If results have been removed due to an infotype filter, this will be the number of results removed
Property InfoTypesFiltered As %Integer;

/// The requesting facility
Property RequestingFacility As HS.Types.Facility;

/// Number of results
Property ResultsCount As %Integer [ InitialExpression = 0 ];

/// Zero or more matches from the search
Property Results As list Of PatientSearchMatch(STORAGEDEFAULT = "array");

/// This organizes the results by MPIID
Property MPIIDList As list Of HS.Message.PatientMPIMatch;

/// For clinician mode searches - consent will include those with relationships
Property ClinicianId As %String;

Property ErrStatus As %Status;

/// The Results property is mapped as a child table and this query will return the search results in
/// resultset form for the specified search response [message id], which is more convenient than an list of objects
Query SearchResults(id As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT m.%ID,m.MPIID,m.LastName,m.MiddleName,m.FirstName,m.Sex,m.DoB,m.Facility,m.MRN,m.SSN,m.Street,m.City,m.State,m.Zip,m.RankOrScore As Rank, Max(m.RankOrScore %FOREACH(m.MPIID)) as MaxRank, m.InfoTypes, m.LookupError, Count(DISTINCT m.MPIID) As NumMPI
FROM PatientSearchMatch m, PatientSearchResponse_Results r
WHERE r.PatientSearchResponse = :id AND r.Results = m.%ID
ORDER BY MaxRank DESC, m.MPIID, Rank DESC
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
     Quit ..OnDeleteHandler($LG(oid))
}

Trigger OnDeleteSQL [ Event = DELETE ]
{
     New class,id
     Set class={%%CLASSNAMEQ} Quit:class=""
     Set id={%%ID} Quit:id=""
     Do $classmethod(class,"OnDeleteHandler",id)
     Quit
}

ClassMethod OnDeleteHandler(id) As %Status [ ServerOnly = 1 ]
{
	Try {
		Set tSC=$$$OK
		Set tObj=..%OpenId(id) quit:'$IsObject(tObj)
		For tIdx=tObj.Results.Count():-1:1 {
			Set tResult=tObj.Results.GetAt(tIdx)
			If '$IsObject(tResult) Continue
			Set tSC=tResult.%DeleteId(tResult.%Id()) Quit:$$$ISERR(tSC)
		}
		Quit:$$$ISERR(tSC)
		For tIdx=tObj.MPIIDList.Count():-1:1 {
			Set tMPIMatch=tObj.MPIIDList.GetAt(tIdx)
			If '$IsObject(tMPIMatch) Continue
			Set tSC=tMPIMatch.%DeleteId(tMPIMatch.%Id()) Quit:$$$ISERR(tSC)
		}
		Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
    Quit tSC
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.PatientSearchResponse.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.PatientSearchResponse.CustomAuditInfo"</Subscript>
</Data>
<Data name="PatientSearchResponseDefaultData">
<Subscript>"PatientSearchResponse"</Subscript>
<Value name="1">
<Value>ResultsCount</Value>
</Value>
<Value name="2">
<Value>RequestingFacility</Value>
</Value>
<Value name="3">
<Value>BreakTheGlass</Value>
</Value>
<Value name="4">
<Value>Consent</Value>
</Value>
<Value name="5">
<Value>ClinicalTypes</Value>
</Value>
<Value name="6">
<Value>RequestingUser</Value>
</Value>
<Value name="7">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="8">
<Value>Signature</Value>
</Value>
<Value name="9">
<Value>RequestId</Value>
</Value>
<Value name="10">
<Value>Type</Value>
</Value>
<Value name="11">
<Value>ConsentApplied</Value>
</Value>
<Value name="12">
<Value>RequestingGateway</Value>
</Value>
<Value name="13">
<Value>AuthBy</Value>
</Value>
<Value name="14">
<Value>AuthType</Value>
</Value>
<Value name="15">
<Value>BTGReason</Value>
</Value>
<Value name="16">
<Value>ClinicianId</Value>
</Value>
<Value name="17">
<Value>MPIIDList</Value>
</Value>
<Value name="18">
<Value>InfoTypesFiltered</Value>
</Value>
<Value name="19">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="20">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="21">
<Value>ProgramConsent</Value>
</Value>
<Value name="22">
<Value>ErrStatus</Value>
</Value>
<Value name="23">
<Value>SAMLData</Value>
</Value>
</Data>
<Data name="Results">
<Attribute>Results</Attribute>
<Structure>subnode</Structure>
<Subscript>"Results"</Subscript>
</Data>
<DefaultData>PatientSearchResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

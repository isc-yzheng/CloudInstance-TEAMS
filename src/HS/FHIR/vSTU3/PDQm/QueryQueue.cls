Class HS.FHIR.vSTU3.PDQm.QueryQueue Extends %Persistent
{

Property QueryID As %String(MAXLEN = "");

Property SearchResponse As HS.Message.PatientSearchResponse;

Property SearchRequest As HS.Message.PatientSearchRequest;

/// # of rows requested per response
Property InitialQuantity As %Integer;

/// # of rows returned so far
Property QuantityReturned As %Integer [ InitialExpression = 0 ];

/// # of MPIIDs in the Search Response
Property Quantity As %Integer [ InitialExpression = 0 ];

Property MinRank As %Integer;

Property InitialRequestDateTime As %TimeStamp;

/// Used only by PDQm
Property InitialFHIRRequest As HS.Message.FHIR.Request;

/// Used only by PDQm
Property PageSize As %Integer;

Index IDKEY On QueryID [ IdKey ];

Index InitialRequestDateTimeIndex On InitialRequestDateTime;

/// PurgeQueryQueue purges entries out of HS.FHIR.vSTU3.PDQm.QueryQueue
/// that are more than pHours hours old.
ClassMethod PurgeQueryQueue(pHours As %Integer = 24) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tCurDH = $Horolog
		Set tCurDHDay = $Piece(tCurDH,",",1)
		Set tCurDHSecs = $Piece(tCurDH,",",2)
		Set tDaysBack = pHours\24
		Set tHoursBack = pHours#24
		Set tSecondsBack = tHoursBack*3600
		Set tPurgeDay = tCurDHDay
		If tDaysBack>0 Set tPurgeDay = tPurgeDay-tDaysBack
		If tSecondsBack>tCurDHSecs Set tPurgeDay = tPurgeDay-1 Set tPurgeSecs = 86400-(tSecondsBack-tCurDHSecs)
		If tSecondsBack'>tCurDHSecs Set tPurgeSecs = tCurDHSecs - tSecondsBack
		Set tPurgeDH = tPurgeDay_","_tPurgeSecs
		Set tPurgeDT = $ZDateTime(tPurgeDH,3)
		
		Set tIndex = tPurgeDT
		For {
			Set tIndex = $Order(^HS.FHIR.vSTU3.PDQm.QueryQueueI("InitialRequestDateTimeIndex",tIndex),-1)
			If tIndex="" Quit
			Set tId = ""
			For {
				Set tId = $Order(^HS.FHIR.vSTU3.PDQm.QueryQueueI("InitialRequestDateTimeIndex",tIndex,tId))
				If tId="" Quit
				Set tSC = ##class(HS.FHIR.vSTU3.PDQm.QueryQueue).%DeleteId(tId)
				If $$$ISERR(tSC) Quit
			}
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Storage Default
{
<Data name="QueryQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SearchResponse</Value>
</Value>
<Value name="3">
<Value>SearchRequest</Value>
</Value>
<Value name="4">
<Value>InitialQuantity</Value>
</Value>
<Value name="5">
<Value>QuantityReturned</Value>
</Value>
<Value name="6">
<Value>Quantity</Value>
</Value>
<Value name="7">
<Value>MinRank</Value>
</Value>
<Value name="8">
<Value>InitialRequestDateTime</Value>
</Value>
<Value name="9">
<Value>InitialFHIRRequest</Value>
</Value>
<Value name="10">
<Value>PageSize</Value>
</Value>
</Data>
<DataLocation>^HS.FHIR.vSTU3.PDQm.QueryQueueD</DataLocation>
<DefaultData>QueryQueueDefaultData</DefaultData>
<IdLocation>^HS.FHIR.vSTU3.PDQm.QueryQueueD</IdLocation>
<IndexLocation>^HS.FHIR.vSTU3.PDQm.QueryQueueI</IndexLocation>
<StreamLocation>^HS.FHIR.vSTU3.PDQm.QueryQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

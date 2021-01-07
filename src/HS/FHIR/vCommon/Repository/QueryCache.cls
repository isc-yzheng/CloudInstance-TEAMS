Class HS.FHIR.vCommon.Repository.QueryCache Extends %Persistent
{

/// HealthShare Foundation
Parameter FOUNDATION = 1;

Property QueryID As %String(MAXLEN = "");

/// # of rows requested per response
Property PageSize As %Integer;

Property InitialRequestDateTime As %TimeStamp;

/// FHIR Resource Type
Property Type As %String;

/// FHIR Streamlet Storage Class
Property StorageClass As %String(MAXLEN = 128);

Property StreamletIds As list Of %String;

Index IDKEY On QueryID [ IdKey ];

Index InitialRequestDateTimeIndex On InitialRequestDateTime;

/// PurgeQueryCache purges entries out of HS.FHIR.vCommon.Repository.QueryCache
/// that are more than pHours hours old.
ClassMethod PurgeQueryCache(pHours As %Integer = 24) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tIndexGlobal = ##class(HS.FHIR.vCommon.StorageUtils).GetIndexGlobal(..%ClassName(1))
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
			Set tIndex = $Order(@tIndexGlobal@("InitialRequestDateTimeIndex",tIndex),-1)
			If tIndex="" Quit
			Set tId = ""
			For {
				Set tId = $Order(@tIndexGlobal@("InitialRequestDateTimeIndex",tIndex,tId))
				If tId="" Quit
				Set tSC = ..%DeleteId(tId)
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
<Data name="QueryCacheDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PageSize</Value>
</Value>
<Value name="3">
<Value>InitialRequestDateTime</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>StorageClass</Value>
</Value>
<Value name="6">
<Value>StreamletIds</Value>
</Value>
</Data>
<DataLocation>^HS.FHIR.vCommon36C6.QueryCacheD</DataLocation>
<DefaultData>QueryCacheDefaultData</DefaultData>
<IdLocation>^HS.FHIR.vCommon36C6.QueryCacheD</IdLocation>
<IndexLocation>^HS.FHIR.vCommon36C6.QueryCacheI</IndexLocation>
<StreamLocation>^HS.FHIR.vCommon36C6.QueryCacheS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

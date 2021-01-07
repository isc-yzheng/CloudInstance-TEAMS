Class HS.IHE.XCA.Common Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ Abstract, ClassType = persistent, Inheritance = right ]
{

Parameter SETTINGS = "HomeCommunity";

/// used internally for the process if not set, it will be defaulted to the HomeCommunity
Property HomeCommunity As %String;

Property HomeCommunityOID As %String(MAXLEN = 64);

Property IHEVersion As %Integer [ InitialExpression = 1 ];

Property Transformer As HS.Util.XSLTTransformer;

Property Errors As HS.Types.IHE.Errors;

/// Build a collection (list) of HS.Types.IHE.DocumentRequest objects from an inbound Retrieve request
Method getRetrieveRequestObjects(pRequest As HS.Message.XMLMessage, ByRef pRequestObjects As %ListOfObjects) As %Status
{
	try {
		Set tSC=$$$OK
		Set pRequestObjects = ##class(%ListOfObjects).%New()
		Set tReader=##class(%XML.Reader).%New()
 		Do tReader.Correlate("DocumentRequest","HS.Types.IHE.DocumentRequest")
		Set tSC=tReader.OpenStream(pRequest.ContentStream) Quit:$$$ISERR(tSC)
		
		While tReader.Next(.tRequest,.tSC) {
			Set tHomeCommunityId = tRequest.HomeCommunityId
			Set:$e(tHomeCommunityId,1,8)="urn:oid:" tHomeCommunityId=$e(tHomeCommunityId,9,*)
			If tHomeCommunityId = "" Do ..Errors.logError("XDSMissingHomeCommunityId","Error","Missing HomeCommunity Id","") Continue
			If tHomeCommunityId = ..HomeCommunityOID {
				Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForOID(tRequest.RepositoryUniqueId,"Repository","XDSb.Retrieve","SOAP")
				If '$IsObject(tEndPoint) {
					Set tErrorString = "Unable to locate endpoint using Repository UniqueId: ("_tRequest.RepositoryUniqueId_")"
					Set tCode = ##class(HS.Data.OIDMap).GetCodeForOID(tRequest.RepositoryUniqueId)
					If tCode="" {
						Set tErrorString=tErrorString_" No code is found in the OID table" 
					} Else {
						Set tErrorString=tErrorString_" No service registry entry has ("_tCode_") assigned in the Repository field"
					}
					Do ..Errors.logError("InternalError","Error",tErrorString)
					Continue
				}

				Do tRequest.AdditionalInfo.SetAt(1,"HOME")
			} Else {
				Set tHomeCommunityCode = ##class(HS.Data.OIDMap).CodeForOID(tHomeCommunityId)
				If tHomeCommunityCode = "" {
					Set tErrorString = "Unknown Home Community Id:("_tHomeCommunityId_")"
					Set tCode="XDSUnknownCommunity"
					Do ..Errors.logError(tCode,"Error",tErrorString)
					Continue
				}
				Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForOID(tHomeCommunityId,"HomeCommunity","XCA.Retrieve","SOAP",1)
				If '$IsObject(tEndPoint) {
					Set tErrorString = "Look for a service registry entry with Home Community Id:("_tHomeCommunityId_")"
					Set tCode = ##class(HS.Data.OIDMap).GetCodeForOID(tHomeCommunityId)
					If tCode="" {
						Set tErrorString=tErrorString_" No code is found in the OID table" 
					} Else {
						Set tErrorString=tErrorString_" No service registry entry has ("_tCode_") assigned in the HomeCommunity field with XCA.Retrieve in device function"
					}
					Do ..Errors.logError("InternalError","Error",tErrorString)
					Continue
				}
			}
			Set tRequest.HomeCommunityId=tHomeCommunityId 
			Set tEndPointName=$S($isObject(tEndPoint):tEndPoint.Name,1:" ")
			Do tRequest.AdditionalInfo.SetAt(tEndPointName,"ServiceName")
			Set tRequestGroup = $g(tAry("EP",tEndPointName),##class(HS.Types.IHE.DocumentRequests).%New())
			Set tAry("EP",tEndPointName)=tRequestGroup
			Do tRequestGroup.Request.Insert(tRequest)
			$$$HSTRACE("adding request "_tEndPointName_" "_tHomeCommunityId_" documents "_tRequestGroup.Request.Count())
		}
		Set tEP=""
		For  {
			Set tEP=$O(tAry("EP",tEP)) Quit:tEP=""
			Set tRequestGroup = tAry("EP",tEP)
			Do pRequestObjects.Insert(tRequestGroup)
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

Storage Default
{
<Data name="CommonDefaultData">
<Subscript>"Common"</Subscript>
<Value name="1">
<Value>HomeCommunityOID</Value>
</Value>
<Value name="2">
<Value>TraceOperations</Value>
</Value>
<Value name="3">
<Value>IHEVersion</Value>
</Value>
<Value name="4">
<Value>IHEExtension</Value>
</Value>
<Value name="5">
<Value>Transformer</Value>
</Value>
<Value name="6">
<Value>Timeout</Value>
</Value>
<Value name="7">
<Value>HomeCommunity</Value>
</Value>
<Value name="8">
<Value>Errors</Value>
</Value>
</Data>
<DefaultData>CommonDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

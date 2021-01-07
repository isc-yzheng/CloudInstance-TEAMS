Class HS.Util.SOAPClient.Operations Extends (Ens.BusinessOperation, HS.Util.SOAPClient.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter SETTINGS = "ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},-SOAPVersion,-SSLConfiguration,-SOAPCredentials,ResponseTimeout,SendSAMLAssertion,SAMLCreator,XMLValidator";

/// Class to perform xsd validation on request / response (To be used only during setup / testing), can be a very time intensive operation
Property XMLValidator As %Dictionary.Classname;

/// If the operation is interested in stopping based on the XML validation response, it can review XMLValidatorResponse results (of type HS.Util.XML.Validator)
Property XMLValidatorResponse As %Dictionary.Classname;

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	Set tSC = $$$OK
	
	Try {
		Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction")
		Do ..ValidateMessage(pRequest,tAction,"Request")
		Set tSC = ..InvokeWebService(,, tAction, pRequest, .pResponse,+pRequest.AdditionalInfo.GetAt("OneWay")) $$$HSThrowErrors(tSC)
		If 'pRequest.AdditionalInfo.GetAt("OneWay") {
			Do ..ValidateMessage(pResponse,pResponse.AdditionalInfo.GetAt("ResponseSOAPAction"),"Response")
		}
	}
	Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	
	Quit tSC
}

Method ValidateMessage(pRequest = "", pAction = "", pType = "")
{
	try {
		If ..XMLValidator]"" {
			Set ..XMLValidatorResponse = $classMethod(..XMLValidator,"Validate",pRequest,pAction)
			Set tString = ..SchemaErrorString()
			if tString]"" {
				$$$LOGERROR("Problem validating "_$s(pType="":"",1:pType_" ")_"message "_tString)
			}
			If $IsObject(..XMLValidatorResponse),..XMLValidatorResponse.%Extends("%XML.Adaptor") $$$HSTRACE("Validation Result","..XMLValidatorResponse",..XMLValidatorResponse)
		}
	} catch ex {
		$$$LOGSTATUS(ex.AsStatus())
	}
}

Method SchemaErrorString() As %String
{
	If '$IsObject(..XMLValidatorResponse) Quit ""
	Set tString=""
	If ..XMLValidatorResponse.Errors.Count() {
		For tIdx = 1:1:..XMLValidatorResponse.Errors.Count() {
			Set:tString]"" tString=tString_$c(13,10)
			Set tString=tString_..XMLValidatorResponse.Errors.GetAt(tIdx)
		}
	}
	Quit tString
}

}

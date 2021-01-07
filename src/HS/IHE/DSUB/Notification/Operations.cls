Include HS.IHE.ATNA

/// Used to send notification messages
Class HS.IHE.DSUB.Notification.Operations Extends (HS.Util.SOAPClient.Operations, HS.HC.Util.Trace.Helper, HS.Util.XSLTTransformer) [ ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "DefaultSSLConfig:Basic,-ServiceName,-XSLTDirectory,-XSLTCallbackHandlerClass,-XSLTErrorHandlerClass,XSLTCacheMode:Basic,-SOAPVersion,-SSLConfiguration,-SOAPCredentials,-ResponseTimeout,-SendSAMLAssertion,-SAMLCreator,DisableSSLCheckServerIdentity:Basic";

/// If https automatic SSL configuration assigned to subscription entry
Property DefaultSSLConfig As %String [ InitialExpression = "Client" ];

/// If doing any security related signing the request comes and generated (with a security document 
/// as a placeholder), the caller then adds the security document and calls the source again, 
/// this time it will be audited and sent to the repository
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		Set ..SSLConfiguration = ..DefaultSSLConfig
		Set tSC = ##super(pRequest,.pResponse)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}

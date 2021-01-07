/// SOAPServer.Base calls (in OnPreWebMethod - ValidateSAML, ProcessSAML) then ProcessRequest
/// 
Class HS.IHE.XUA.Processor Extends HS.HC.IHE.XUA.Processor
{

/// Boolean whether the SAML user should be validated against the user registry
Parameter ValidateUser As %Boolean = 1;

/// Validate the user against the user registry
Method ProcessRequest(pRequest As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC=$$$OK
		Set tKey="" 
		Set tDomain = ..GetDomain(pRequest.SAMLData)
		Set tUserName = pRequest.SAMLData.UserName
		Set tPassword = pRequest.SAMLData.Token
		Set pRequest.SAMLData.LoginDomain=tDomain
		#; Validate against the user registry
		#; Authenticate the user in the person registry
		If ..#ValidateUser {
			#dim tResponse As HS.Registry.Person.User.WebServices.Containers.AuthResponse
			Set tSC = ##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","SAMLAuthenticateAuthorize",.tResponse,tDomain,tUserName,tPassword)
			Quit:$$$ISERR(tSC)
			If tResponse.ErrMessage ] "" Set tSC=$$$ERROR($$$GeneralError, tResponse.ErrMessage) Quit
			If tResponse.UserID = "" {
				$$$LOGWARNING("AuthenticateAuthorize for user '"_tUserName_"@"_tDomain_"' failed")
				Set tSC =  $$$ERROR($$$GeneralError, "Authentication or authorization failure:"_tUserName_"@"_tDomain_" failed") Quit
			}
			Set:tResponse.Roles]"" pRequest.SAMLData.HSRoles=$S(pRequest.SAMLData.HSRoles="":tResponse.Roles,1:pRequest.SAMLData.HSRoles_","_tResponse.Roles)
		}
		Do pRequest.AdditionalInfo.SetAt(tUserName,"USER:UserID")
		Do pRequest.AdditionalInfo.SetAt(pRequest.SAMLData.HSRoles,"USER:Roles")
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

}

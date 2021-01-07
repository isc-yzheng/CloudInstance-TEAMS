/// IHE class for creating SAML tokens.
/// This class is subject to change and should not be presumed to be final.
/// Creating HS.IHE.XUA.Config entries to control properties of the Creator class
/// to control specific settings for their environment. 
Class HS.IHE.XUA.Creator Extends HS.HC.IHE.XUA.Creator [ LegacyInstanceContext ]
{

/// called by CommonInternalUserInformation
Method FetchUserOrganization(pData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		// Currently using GetPrimaryFacility for user, can follow up with (or replace by) full query for user facilities
		Set tFacilityCode = ""
		Set tRegistryID=pData.Working("UserToken")
		Set tSC = ##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","GetPrimaryFacility",.tFacilityCode,tRegistryID)
		If $$$ISERR(tSC) Quit 
		If tFacilityCode = "" {
			Set pData.OrganizationOID = ##class(HS.Data.OIDMap).GetOIDForCode(pData.RHIO,"undefined")
			Set pData.Organization = pData.RHIO
		} Else {
			Set tFacility = ##class(HS.Facility.Config).IDKEYOpen(tFacilityCode)
			Set pData.OrganizationOID = ##class(HS.Data.OIDMap).GetOIDForCode(tFacilityCode,"undefined")
			Set pData.Organization = $S('$IsObject(tFacility):tFacilityCode,tFacility.Name]"":tFacility.Name,1:tFacilityCode)
		}
	}Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// called by CommonInternalUserInformation
Method FetchUser(pData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		#; todo:
		#; if user logs into multiple systems, how do we know what the time was / what machine it was 
		#; how do we know the authorization mode?
		Set pData.Working("UserLoginTime")=$system.SQL.DATEADD("mi", -5, $zdatetime($ztimestamp, 3,,3))
		#; select this node name or one defined in the config
		Set pData.Working("UserDNSName")=..GetNodeName()
		Set pData.Working("UserIPAddress")=##class(%SYSTEM.INetInfo).HostNameToAddr(pData.Working("UserDNSName"))
		Set pData.Working("UserAuthorizationMode")="urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
		#dim tResponse As HS.Util.WebServices.ListItems
		Set tSC = ##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","FindUsers",.tResponse,1,,,pData.UserName)
		If $$$ISERR(tSC) Quit 
		If $$$ISERR(tResponse.Status) Set tSC = tResponse.Status Quit
	
		If tResponse.Items.Count() > 1 {
			Set tSC = $$$ERROR($$$GeneralError, "Username not unique: "_pData.UserName) Quit
		}
		ElseIf tResponse.Items.Count() = 0 { // Not found in person registry
			// do the best we can if user is not in the registry
			$$$LOGWARNING("User not found in Person Registry: "_pData.UserName)
			Set tUserFullName = pData.UserName  
			Set tUserToken = ""
		} 
		Else {
			#dim tUserData As HS.Registry.Person.User.WebServices.Containers.User
			Set tUserData = tResponse.Items.GetAt(1)
			Set tUserID = tUserData.ID
			Set tUserFullName = tUserData.Description
			Set:tUserFullName="" tUserFullName=tUserData.Name
			SEt tUserToken = tUserData.ID
		}
		Set pData.Working("UserFullName")=tUserFullName
		Set pData.Working("UserToken")=tUserToken

		#dim tUser As HS.Registry.Person.User.WebServices.Containers.User
		#dim tIdentifier As HS.Types.Identifier

		Set tRegistryID = pData.Working("UserToken")
		Set tSC = ##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","LoadUser",.tUser,tRegistryID)
		If $$$ISERR(tSC) Quit
		
		If $IsObject($G(tUser)) {
			Set pData.Working("EmailAddress")=tUser.EmailAddress
			For tIdx=1:1:tUser.Identifiers.Count() {
				Set tIdentifier = tUser.Identifiers.GetAt(tIdx)
				If $IsObject(tIdentifier) {
					Set tAA = tIdentifier.AssigningAuthorityName
					If tAA ="NPI" {
						If $g(pData.Working(tAA))="" {
							Set pData.Working(tAA) = tIdentifier.Extension
						}
						ElseIf pData.Working(tAA) '= tIdentifier.Extension {
							//As a convienience to the administrator that we have a configuration issue with the user registry for this security domain
							$$$LOGWARNING($$$FormatText("Identifier returned by registry different than in SAML token: Type=%1 SAML=%2 Registry=%3 UserID=%4", tAA, tData(tAA), tIdentifier.Extension, tUserID))
						}
					}
				}
			}	
		}
	}Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}

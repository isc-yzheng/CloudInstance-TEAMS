Class HS.Types.RequestInfo Extends (HS.Types.AuthorizationInfo, HS.Util.CopyFrom, %RegisteredObject, %XML.Adaptor, %ZEN.DataModel.ObjectDataModel) [ Inheritance = right, ProcedureBlock ]
{

Parameter DOMAIN = "HS";

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// Enabling this may be in violation of federal law ... check with your lawyers
Property BreakTheGlass As %Boolean(ZENHIDDEN = 1) [ InitialExpression = 0 ];

/// Consent information
Property Consent As %String(MAXLEN = "", ZENHIDDEN = 1);

/// Clinical types
Property ClinicalTypes As %String(MAXLEN = "", ZENHIDDEN = 1);

/// The requesting user
Property RequestingUser As %String(ZENHIDDEN = 1) [ InitialExpression = {$USERNAME} ];

/// The roles for the requesting user
Property RequestingUserRoles As %String(MAXLEN = "", ZENHIDDEN = 1) [ InitialExpression = {$ROLES} ];

/// If this is for a proxy, the $username of the proxied user
Property RequestingForProxyUserID As %String(ZENHIDDEN = 1);

/// If this is for a proxy, the internal ID of the proxied user
Property RequestingForProxyID As %String(ZENHIDDEN = 1);

/// Signature for this request
Property Signature As %String(MAXLEN = "", ZENHIDDEN = 1);

/// Request Audit ID *** Must always be set and passed around ***
Property RequestId As %String(MAXLEN = 128, ZENHIDDEN = 1);

/// An identifier for the access gateway that initiated the request
Property RequestingGateway As %String(MAXLEN = 256, ZENHIDDEN = 1) [ InitialExpression = {##Class(HS.Util.Installer.ConfigItem).GetThisComponentName()} ];

/// Type for increasing the specificity of a request
Property Type As %String(MAXLEN = 512, ZENHIDDEN = 1);

/// Additional request information
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

/// Contains SAML user / rhio / token 
Property SAMLData As HS.IHE.XUA.SAMLData;

/// Data passed in here will be copied to CustomPairs when audited
Property CustomAuditInfo As array Of %String(MAXLEN = "");

/// Copy request info from any message with an AdditionalInfo array.
/// Keys supported: "USER:UserID", "USER:Roles" and "BreakTheGlass".
ClassMethod XMLMessageToRequestInfo(pSource As %RegisteredObject, pTarget As HS.Types.RequestInfo, pPropertyName As %String = "AdditionalInfo") As %Status
{
	If '$IsObject($G(pSource)) Quit $$$ERROR($$$GeneralError, "Missing source request object")
	If '$IsObject($G(pTarget)) Quit $$$ERROR($$$GeneralError, "Missing target request object")
	Try {
		Set pTarget.SAMLData=pSource.SAMLData.%ConstructClone()
	} catch {}

	#; Make sure source object has a valid array property	
	Set tProperty=##class(%Dictionary.PropertyDefinition).%Open($LB(pSource.%ClassName(1)_"||"_pPropertyName), 0, .tSC)
	If $$$ISERR(tSC) Quit tSC		
	If (tProperty.Collection '= "array") || ((tProperty.Type '= "%String") && (tProperty.Type '= "HS.Types.AdditionalInfoItem")) {
		Quit $$$ERROR($$$GeneralError, "Source property must be an array of %String")
	}
	// SAMLData references wrapped in Try..Catch because pSource may not have that property.
	Set tUsedSAMLData = 0
	Try {
		If pSource.SAMLData.UserName]"" {
			Set pTarget.RequestingUser=pSource.SAMLData.UserName
			Set pTarget.RequestingUserRoles=pSource.SAMLData.HSRoles
			Set pTarget.BreakTheGlass=pSource.SAMLData.BreakTheGlass
			Set tUsedSAMLData = 1
		} 
	} catch {}
	If (pTarget.RequestingUser]"" && (pTarget.RequestingUserRoles]"") && (tUsedSAMLData=1)) Quit $$$OK
	#dim tArray As array of %String
	Set tArray = $property(pSource,pPropertyName)
	If $IsObject(tArray) {
		
		If tArray.IsDefined("USER:UserID") {
			Set pTarget.RequestingUser = tArray.GetAt("USER:UserID")
		}
	
		If tArray.IsDefined("USER:Roles") {
			Set pTarget.RequestingUserRoles = tArray.GetAt("USER:Roles")
		}
	
		If tArray.IsDefined("BreakTheGlass") {
			Set pTarget.BreakTheGlass = tArray.GetAt("BreakTheGlass")
		}

	}
	If pTarget.RequestingUser=""||(pTarget.RequestingUserRoles="") {
		Set tErr=$S(pTarget.RequestingUser="":$$$Text("Missing Requesting User"),1:$$$Text("Missing Requesting User Roles"))
		Do $SYSTEM.Security.Audit("%System","%Login","LoginFailure",tErr,"login failure")
		Quit $$$ERROR($$$GeneralError, tErr)
	}
	
	Quit $$$OK
}

/// Insert/Update request info from any message with an AdditionalInfo array.
/// Keys supported: "USER:UserID", "USER:Roles" and "BreakTheGlass".
ClassMethod RequestInfoToXMLMessage(pSource As HS.Types.RequestInfo, pTarget As %RegisteredObject, pPropertyName As %String = "AdditionalInfo") As %Status
{
	If '$IsObject($G(pSource)) Quit $$$ERROR($$$GeneralError, "Missing source request object")
	If '$IsObject($G(pTarget)) Quit $$$ERROR($$$GeneralError, "Missing target request object")

	Try {
		Set pTarget.SAMLData=pSource.SAMLData.%ConstructClone()
	} catch {}
	
	#; Make sure target object has a valid array property	
	Set tProperty=##class(%Dictionary.PropertyDefinition).%Open($LB(pTarget.%ClassName(1)_"||"_pPropertyName), 0, .tSC)
	If $$$ISERR(tSC) Quit tSC		
	If (tProperty.Collection '= "array") || ((tProperty.Type '= "%String") && (tProperty.Type '= "HS.Types.AdditionalInfoItem")) {
		Quit $$$ERROR($$$GeneralError, "Target property must be an array of %String")
	}

	#dim tArray As array of %String
	Set tArray = $property(pTarget,pPropertyName)
	If $IsObject(tArray) {
		Do tArray.SetAt(pSource.RequestingUser,"USER:UserID")
		Do tArray.SetAt(pSource.RequestingUserRoles,"USER:Roles")
		Do tArray.SetAt(pSource.BreakTheGlass,"BreakTheGlass")
	}
	Set:pTarget.SAMLData.UserName="" pTarget.SAMLData.UserName=pSource.RequestingUser
	Set:pTarget.SAMLData.HSRoles="" pTarget.SAMLData.HSRoles=pSource.RequestingUserRoles
	Set:pTarget.SAMLData.BreakTheGlass="" pTarget.SAMLData.BreakTheGlass=pSource.BreakTheGlass
	Quit $$$OK
}

/// Get the user information for a RequestInfo or XMLMessage object
ClassMethod GetUserInfo(pSource As %RegisteredObject, Output pUserName As %String = {$Username}, Output pUserRoles As %String = {$Roles}, Output pBreakTheGlass As %Boolean = 0, pPropertyName As %String = "AdditionalInfo") As %Status
{
	If '$IsObject($G(pSource)) Quit $$$ERROR($$$GeneralError, "Missing source request object")
	
	If pSource.%Extends(..%ClassName(1)) {
		Set pUserName = pSource.RequestingUser
		Set pUserRoles = pSource.RequestingUserRoles
		Set pBreakTheGlass = pSource.BreakTheGlass
	} 
	Else {
		If pSource.SAMLData.UserName]"" {
			Set pUserName=pSource.SAMLData.UserName
			Set pUserRoles=pSource.SAMLData.HSRoles
			Set pBreakTheGlass=pSource.SAMLData.BreakTheGlass
		} Else {
			#; Make sure source object has a valid array property	
			Set tProperty=##class(%Dictionary.PropertyDefinition).%Open($LB(pSource.%ClassName(1)_"||"_pPropertyName), 0, .tSC)
			If $$$ISERR(tSC) Quit tSC		
			If (tProperty.Collection '= "array") || ((tProperty.Type '= "%String") && (tProperty.Type '= "HS.Types.AdditionalInfoItem")) {
				Quit $$$ERROR($$$GeneralError, "Source property must be an array of %String")
			}

			#dim tArray As array of %String
			Set tArray = $property(pSource,pPropertyName)
			If $IsObject(tArray) {
		
				If tArray.IsDefined("USER:UserID") {
					Set pUserName = tArray.GetAt("USER:UserID")
				}
	
				If tArray.IsDefined("USER:Roles") {
					Set pUserRoles = tArray.GetAt("USER:Roles")
				}
	
				If tArray.IsDefined("BreakTheGlass") {
					Set pBreakTheGlass = tArray.GetAt("BreakTheGlass")
				}

			}
		}
	}
	Quit $$$OK
}

}

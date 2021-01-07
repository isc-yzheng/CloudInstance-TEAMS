Include HS.HC

/// Base Authentication & Authorization callback class
Class HS.Registry.Person.User.HSAuth [ Abstract ]
{

/// the message translation domain for CSP - this is not related to the authentication domain
Parameter DOMAIN = "HS";

/// disable user access if they haven't logged on within the past N days (unless the user gets editted)
Parameter INACTIVITYLIMIT As %Integer = 90;

/// lock the loginID after N failures in a row (if N >0)
Parameter INVALIDLOGINLIMIT As %Integer = 0;

/// After N days, the user will need to change their password
Parameter PASSWORDEXPIRATIONDAYS As %Integer = 0;

/// Used by OnValidatePW. The proposed password must satisfy this pattern
Parameter PASSWORDPATTERN As %String = "3.32ANP";

/// Used by OnValidatePW.  Password cannot match this number of past passwords
/// Set to 0 to disable past password validation
Parameter PASSWORDMATCHNUM As %Integer = 4;

/// If this domain will support an email being sent if the user forgot their password,
/// this is the name of the Ensemble configured operation used to generate the email
Parameter PWEMAILOPERATION As %String = "PasswordEmailOperation";

/// API Method: Authenticates a user.
/// Return value will be empty or a displayable error message (if there's a real error)
/// Alternatively, for authentication failures, the return value can be a $list(name value pairs), where each pair is $List(key,data)
/// If authenticated, this will output pUserName and pToken
/// The token can be anything needed for later use.  For internal HealthShare domains, we use the internal ID in the UserLoginId table
/// If fails, these will be nil
/// pServ is the service name for those who need to call external SOAP service endpoints
/// pChallengeQ is set to a challenge question in cases where we support the "forgot password" option
ClassMethod OnAuthenticate(pServ, pDomain, pLoginID, pPassword, Output pUserName, Output pToken, Output pFullName, Output pChangePW, Output pChallengeQ) As %String
{
	Set tReturn="", pUserName="",pToken="", pChangePW=0, pChallengeQ=""
	DO {
		IF pDomain="" {
			Set pDomain = ..ExtractDomainFromLoginID(.pLoginID)
		}
		//Does the user exist?
		Set tUserLoginID = ##class(HS.HC.Registry.Person.User.API).LoadUserLoginIDHSAuth(pLoginID, pDomain)
		Quit:'$IsObject(tUserLoginID)
		Set tToken=tUserLoginID.%Id()
		Set tUser=tUserLoginID.UserClinician.UserID
		Set tUserInternal=tUserLoginID.UserClinician.%Id()
		Set tSalt=tUserLoginID.Salt
		Set tPW=tUserLoginID.Password
		Set tFullName=tUserLoginID.UserClinician.Name
		Set tChangePW=tUserLoginID.ChangePassword
		Set tDatePasswordChanged=tUserLoginID.DatePasswordChanged
		Set tBadLoginCount=tUserLoginID.BadLoginCount
		Set tLastLoginDate=tUserLoginID.UserClinician.LastLoginDate
		Set tChallengeQ=tUserLoginID.ChallengeQuestion
		Set tChallengeA=tUserLoginID.ChallengeAnswer
		
		//Does the password match?
		IF $System.Encryption.PBKDF2(pPassword,$$$CachePWIterations,tSalt,$$$CachePWHashLength)'=tPW {
			//if user exists but bad login, update bad login count, and if exceeds invalid login limit, turn off password
			Set tBadLoginCount=tBadLoginCount+1
			Do ##class(HS.HC.Registry.Person.User.API).UpdateBadLoginCount(pDomain, pLoginID, tBadLoginCount)
			IF ..#INVALIDLOGINLIMIT&&(tBadLoginCount>=..#INVALIDLOGINLIMIT) {
				Do ##class(HS.HC.Registry.Person.User.API).ClearUserPassword(pDomain, pLoginID)
				Quit
			}
			IF ..#PWEMAILOPERATION'="",tChallengeQ'="", tChallengeA'="" {
				//Is the password email operation configured?
				DO ##Class(Ens.Director).ParseConfigItemName("||"_..#PWEMAILOPERATION,.tHub,.tOperation,.x)
				Set tCount=##class(HS.HC.Registry.Person.User.API).VerifyEmailOperation(tHub,tOperation)
				Quit:'tCount
				//does the user have an email address to support the forgot PW email?
				Set tUserEmail = ##class(HS.HC.Registry.Person.User.API).GetUserEmail(tUserInternal)
				Set:(tUserEmail'="") pChallengeQ=tChallengeQ
			}
			Quit
		}
		IF ..#INACTIVITYLIMIT {
			Set tLast=tLastLoginDate Set:tDatePasswordChanged>tLast tLast=tDatePasswordChanged
			IF $H-tLast>..#INACTIVITYLIMIT {
				Do ##class(HS.HC.Registry.Person.User.API).ClearUserPassword(pDomain, pLoginID)
				Quit
			}
		}
		//reset badlogincount if OK
		IF tBadLoginCount {
			Do ##class(HS.HC.Registry.Person.User.API).UpdateBadLoginCount(pDomain, pLoginID, 0)
		}
		Set:..#PASSWORDEXPIRATIONDAYS>0&&($H-tDatePasswordChanged>..#PASSWORDEXPIRATIONDAYS) tChangePW=1
		//OK
		Set pUserName=tUser,pToken=tToken, pFullName=tFullName, pChangePW=tChangePW
		
	} While 0
	
	Quit tReturn
}

/// API Method: Outputs a list of authorized roles.
/// Return value will be empty or a displayable error message (if there's a real error)
/// Outputs a list of authorized roles
ClassMethod OnAuthorize(pServ, pDomain, pLoginID, pPassword, pUserName, pToken, Output pRoles) As %String
{
	Set tUserLogin=##Class(HS.Registry.Person.UserLoginID).%OpenId(pToken)
	IF '$IsObject(tUserLogin) Quit $$$Text("User Login ID Not Found")
	Set tRoles=""
	For tI=1:1:tUserLogin.Roles.Count() {
		Set tRoles=tRoles_$S(tRoles'="":",",1:"")_tUserLogin.Roles.GetAt(tI)
	}
	Set pRoles=tRoles
	Quit ""
}

/// API Method: Returns the child of this class for a given domain
ClassMethod CallbackClass(pDomain As %String) As %String
{
	Set tClass=""
	Set tClass=##class(HS.HC.Registry.Person.User.API).GetCallbackClass(pDomain)
	Set:(tClass="") tClass="HS.Registry.Person.User.HSAuth"
	Set:$E(tClass,*-3,*)=".cls" tClass=$E(tClass,1,*-4)
	Quit tClass
}

/// API Method: Validates a password.
/// Returns "" if OK; otherwise a displayable error message 
/// pQuickAdd passed in by HS.UI.Registry.User.Add.  In this case, skip Repeat Check as this is a brand new user.
ClassMethod OnValidatePW(pPassword As %String, pDomain As %String, pLoginId As %String, pQuickAdd As %Boolean = 0, pRegistryId As %String = "") As %String
{
	Set tErrMsg=..PatternMatch(pPassword)
	If tErrMsg=""&&(pQuickAdd'=1) { Set tErrMsg=..RepeatCheck(pPassword,pDomain,pLoginId,pRegistryId) }
	Quit tErrMsg
}

/// API Method: Callback to process "forgot password" email request
ClassMethod OnRequestPWEmail(pServ, pDomain, pLoginID, pChallengeQ, pChallengeA) As %String
{
	Set tReturn="", pUserName="",pToken="", pChangePW=0
	DO {
		IF pDomain="" {
			IF pLoginID["@" {
				Set pDomain=$P(pLoginID,"@",2),pLoginID=$P(pLoginID,"@")
			} Else {
				Set pDomain = ##class(HS.HC.Registry.Person.User.API).GetDefaultDomain()
			}
		}
		//Does the user exist with this challenge Q/A
		Set tUserLoginID = ##class(HS.HC.Registry.Person.User.API).LoadUserLoginIDHSAuthChallenge(pLoginID, pDomain, pChallengeQ, pChallengeA)
		IF '$IsObject(tUserLoginID) {
			Set tReturn=$$$Text("Invalid login or answer")
			Quit
		}
		Set tToken=tUserLoginID.%Id()
		Set tUser=tUserLoginID.UserClinician.UserID
		Set tUserInternal=tUserLoginID.UserClinician.%Id()
		Set tDatePasswordChanged=tUserLoginID.DatePasswordChanged
		Set tLastLoginDate=tUserLoginID.UserClinician.LastLoginDate

		IF tUser="" {Set tReturn=$$$Text("Missing UserName") Quit  }
		IF ..#INACTIVITYLIMIT {
			Set tLast=tLastLoginDate Set:tDatePasswordChanged>tLast tLast=tDatePasswordChanged
			IF $H-tLast>..#INACTIVITYLIMIT {
				Do ##class(HS.HC.Registry.Person.User.API).ClearUserPassword(pDomain, pLoginID)
				Set tReturn=$$$Text("Exceeded Inactivity Limit") Quit
			}
		}
		//Now kick off the operation
		Set tRequest=##Class(HS.Message.Registry.Person.User.PWEMailRequest).%New()
		Set tRequest.LoginInternalID=tToken
		Set tRequest.CallbackClass=..CallbackClass(pDomain)
		Set tRequest.PWEmailOperation=..#PWEMAILOPERATION
		Set tSC=##Class(HS.Hub.Services).SendSync(tRequest,.tResponse)
		IF $$$ISERR(tSC) {Set tReturn=$ZCVT($system.Status.GetErrorText(tSC),"O","XML")}
		Else {
			If '$IsObject(tResponse) {Set tReturn="ERROR: Password email operation timed out, or did not return a response"}
			Else {Set tReturn=tResponse.ErrMessage }
		}
	} While 0
	
	Quit tReturn
}

/// API Method: Callback to generate the new password & construct the email - invoked from Ensemble PWEmailOperation
/// IF OK Returns "" and sets pUserMessage to a nice message to display to the user
/// else returns a displayable error message
ClassMethod OnGeneratePWEmail(pLoginInternalID As %String, ByRef pMailMessage As %Net.MailMessage, ByRef pUserMessage) As %String
{
	Set pMailMessage=##Class(%Net.MailMessage).%New(), pUserMessage=""
	Set tUserInternal = ##class(HS.HC.Registry.Person.User.API).GetUserInternal(pLoginInternalID)
	IF tUserInternal="" Quit $$$Text("Generate Email Can't find User")
	
	Set tUserEmail = ##class(HS.HC.Registry.Person.User.API).GetUserEmail(tUserInternal)
	IF tUserEmail="" Quit $$$Text("Generate Email Can't find Email Address")
	
	Set tNewPW=..GeneratePassword()
	Set tLogin=##Class(HS.Registry.Person.UserLoginID).%OpenId(pLoginInternalID)
	Set tLogin.PasswordExternal=tNewPW
	Set tLogin.ChangePassword=1
	Set tLogin.DatePasswordChanged=+$H
	Set tSC=tLogin.%Save()
	IF $$$ISERR(tSC) Quit $ZCVT($system.Status.GetErrorText(tSC),"O","XML")
	DO pMailMessage.To.Insert(tUserEmail)
	Set pMailMessage.Subject=$$$Text("Requested Email")
	Set pMailMessage.From=$$$Text("HealthShare")
	set pMailMessage.Charset="iso-8859-1"
	Set pMailMessage.IsHTML=1
	Set pMailMessage.IsBinary=0
	Set pMailMessage.ContentType="text/html"
	Set tHTML="You have been assigned a new temporary password: "_tNewPW
	DO pMailMessage.TextData.Write(tHTML)
	Set pUserMessage=$$$Text("Your email has been sent")
	Quit ""
}

/// API Method: Generates the password.
/// Override this to change the way that random passwords are generated.
ClassMethod GeneratePassword() As %String
{
	Set tLen=$R(3)+7, tPW=""
	For tI=1:1:tLen {
		Set type=$R(5)
		Set c=$C($Select(type>3:65+$R(26),type:97+$R(26),1:48+$R(10)))
		Set tPW=tPW_c
	}
	Quit tPW
}

/// API Method: Controls how passwords are pattern matched.
/// Override this to change the method of pattern matching on passwords.
ClassMethod PatternMatch(pPassword As %String) As %String
{
	Set tPattern=..#PASSWORDPATTERN,tErrMsg=""
	If tPattern'="",pPassword'?@tPattern {
		Set tErrMsg=..PatternError()
	}
	Quit tErrMsg
}

/// API Method: Controls how past passwords are checked.
/// Override this to change the method of checking against past passwords.
ClassMethod RepeatCheck(pPassword As %String, pDomain As %String, pLoginId As %String, pRegistryId As %String = "") As %String
{
	Set tErrMsg=""
	If (..#PASSWORDMATCHNUM > 0) {
		Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","ListRecentPasswords",.tObj,pDomain,pLoginId,..#PASSWORDMATCHNUM,pRegistryId)
		If $D(tObj),$IsObject(tObj),$$$ISOK(tObj.Status) {
			For tIdx=1:1:tObj.Items.Count() {
				Set tItem=tObj.Items.GetAt(tIdx)
				Set tPassword=tItem.Password,tSalt=tItem.Salt
				If (tPassword = $System.Encryption.PBKDF2(pPassword,$$$CachePWIterations,tSalt,$$$CachePWHashLength)) {
					Set tErrMsg=..MatchError()
					Quit
				}
			}
		}
	}
	Quit tErrMsg
}

/// API Method: Text for password-match error message.
/// Override this to change the password pattern match error message.
ClassMethod PatternError() As %String
{
	Quit $$$Text("Password must be between 3 and 32 characters.")
}

/// API Method: Text for past-password-match error message.
/// Override this to change the past-password-match error message.
ClassMethod MatchError() As %String
{
	Quit $$$Text("Cannot re-use a recent password.")
}

/// Internal helper method to identify a user's login domain based on their login ID.
/// <var>pLoginID</var> MUST be passed by reference for situations where the domain needs to be
/// removed from the login ID.
/// If <var>pLoginID</var> doesn't specify a domain, then the domain is defaulted to
/// the current default AuthDomain.
ClassMethod ExtractDomainFromLoginID(ByRef pLoginID As %String) As %String [ Internal ]
{
	If (pLoginID [ "@") {
		Set tDomain = $piece(pLoginID,"@",2)
		Set pLoginID = $piece(pLoginID,"@",1)
	}
	Else {
		Set tDomain = ##class(HS.Registry.AuthDomain).GetDefaultDomain()
	}
	Quit tDomain
}

}

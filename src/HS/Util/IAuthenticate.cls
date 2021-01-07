/// Interface for ZAUTHENTICATE callbacks, both at the user level (via <class>HS.Local.ZAUTHENTICATE</class>) and in REST / other CSP APIs (via <class>HS.Util.RESTCSPConfig</class>)
Class HS.Util.IAuthenticate [ Abstract ]
{

ClassMethod OnBeforeAA(ServiceName, ByRef Namespace, ByRef Username, ByRef password) As %Status [ Abstract ]
{
}

ClassMethod OnAfterAA(ServiceName, Namespace, Username, password, tSC, ByRef tResponse) As %Status [ Abstract ]
{
}

ClassMethod OnAfterProperties(ServiceName, Namespace, ByRef tResponse, ByRef Properties) As %Status [ Abstract ]
{
}

ClassMethod OnBeforeValidatePW(OldPassword, Username, LoginToken, ByRef NewPassword, ByRef LoginDomain, ByRef LoginUser) As %Status [ Abstract ]
{
}

ClassMethod OnBeforeUpdatePW(LoginDomain, LoginUser, UserName, ByRef NewPassword, ByRef pLoginToken, ByRef OldPassword) As %Status [ Abstract ]
{
}

ClassMethod OnGetCredentials(ByRef Username, ByRef Password, ServiceName, Namespace, ByRef Credentials) As %Status [ Abstract ]
{
}

ClassMethod OnSendTwoFactorToken(Username, ServiceName, Namespace, Application, ByRef Credentials, ByRef SecurityToken, ByRef TwoFactorTimeout, ByRef UserPhoneNumber) As %Status [ Abstract ]
{
}

ClassMethod OnBeforeForgotPassword(Namespace, ServiceName, SessionId, ByRef Username, ByRef Password) As %Status [ Abstract ]
{
}

ClassMethod OnAfterForgotPassword(ServiceName, Username, tSC, ByRef pErrText) As %Status [ Abstract ]
{
}

/// Callback to allow customers to intercept calls to the main ^ZAUTHENTICATE entry point,
/// which includes the arguments to that entry point.
/// If the main ^ZAUTHENTICATE logic for HealthShare should NOT be executed,
/// set <var>AuthenticationDelegated</var> to 1, and ensure that all of the values
/// in <var>Properties</var> are correctly initialized.
ClassMethod OnZAUTHENTICATE(ByRef AuthenticationDelegated As %Boolean = 0, ServiceName As %String, Namespace As %String, Username As %String, Password As %String, ByRef Credentials, ByRef Properties) As %Status [ Abstract ]
{
}

}

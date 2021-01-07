Include HSMOD.REST

/// <p>base class for applications to derive a REST authentication API. If there are any 
/// additions to the UrlMap, the UrlMap XData block should be copied into the subclass and added to.</p>
/// @API.Extensible 
Class HSMOD.Authentication.RESTSession.API Extends HSMOD.REST.Base
{

/// @API.Parameter
Parameter CONTENTTYPE = "application/json";

/// <p>default behavior is to disallow unknown users. Subclasses can override this.</p>
/// @API.Parameter
/// @API.Overrideable
Parameter ALLOWUNKNOWNUSER = 0;

/// Subclasses may need to alter these URL maps. 
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/login" Method="POST" Call="UserLogin" />
<Route Url="/logout" Method="POST" Call="UserLogout" />
<Route Url="/status" Method="GET" Call="UserStatus" />
</Routes>
}

/// Method to be executed after a user successfully reaches the <code>/login</code>
/// resource. Note that reaching this method implies that the user is already logged in.
ClassMethod UserLogin() As %Status
{
	// HTTP 303 was only introduced in HTTP 1.1, so use HTTP 302 for HTTP 1.0 clients
	if ($zconvert(%request.Protocol,"U") = "HTTP/1.0") {
		// TODO: replace with more standard status/error machinery (macros?)
		set %response.Status = "302 Moved Temporarily"
	} 
	else {
		set %response.Status = "303 See Other"
	}
	do %response.SetHeader("Location","status")
	quit $$$OK
}

/// End the current user session
ClassMethod UserLogout() As %Status
{
	// *Really* end the session by redirecting with IRISLogout=end.
	// Note: this doesn't run this method, so there won't be an endless redirect loop. (Ending the session bypasses before it can get this far.)
	set %response.ServerSideRedirect = "logout?IRISLogout=end"
	quit $$$OK
}

/// <p>callback for instantiating the response object to be returned by <method>UserStatus</method>. 
/// Can be overridden if an extension class needs to return a subclass of 
/// <class>HSMOD.Authentication.RESTSession.Auxil.UserStatus</class>. </p>
/// @API.Overrideable
ClassMethod CreateStatusResponse(Output pNewStatusObject As HSMOD.Authentication.RESTSession.Auxil.UserStatus) As %Status
{
	kill pNewStatusObject
	set tReturnValue = $$$OK
	
	try {
		set pNewStatusObject = ##class(HSMOD.Authentication.RESTSession.Auxil.UserStatus).%New()
	}
	catch tException {
		set tReturnValue = tException.AsStatus()
	}
	
	quit tReturnValue
}

/// <p>Callback method for subclasses to override if any extra handling needs to be applied to the output status object  
/// for <method>UserStatus</method>. This is called by the UserStatus method after populating standard properties 
/// of the response object, but before serializing to JSON. </p>
/// @API.Overrideable
ClassMethod PopulateCustomStatusData(pWorkingStatusObject As HSMOD.Authentication.RESTSession.Auxil.UserStatus) As %Status
{
	quit $$$OK
}

/// user status API method. No inputs. Output is a JSON representation of a <class>HSMOD.UserAdmin.RestAPI.Auxil.UserStatus</class>
/// object.  
ClassMethod UserStatus() As %Status
{
	if (($Username = $$$UnknownUserUsername) && (..#ALLOWUNKNOWNUSER = 0)) {
		// Don't allow unauthenticated access even if the CSP application allowed it
		set %response.Status = ..#HTTP401UNAUTHORIZED
		set %response.OutputSessionToken = 0
		quit $$$OK
	}
	
	set tSC = $$$OK
	try {		
		set tSC = ..CreateStatusResponse(.tReturnData)
		$$$ThrowOnError(tSC)
		
		set tReturnData.Username = $Username
		set tReturnData.SessionTimeout = +%session.AppTimeout

		if $$$IOwnRole($$$AllRoleName) {
			set tRoleList = $listbuild("%All")
		} 
		else {
			set tRoles = $Roles
			set tRoleList = $listfromstring(tRoles,",")
		}
		set tRoleObject = ##class(%Library.ListOfDataTypes).%New("%String")
		do tRoleObject.InsertList(tRoleList)
		
		// the roles are presented as a list of strings, for historical reasons
		set tReturnData.SessionRoles = tRoleObject
		
		set tSC = ..PopulateCustomStatusData(tReturnData)
		$$$ThrowOnError(tSC)
		
		set tSC = ##class(HS.JSON.Writer).%WriteJSON(tReturnData)
		$$$ThrowOnError(tSC)
	}
	catch tException {
		set tSC = tException.AsStatus()
	}
	do ..httpStatusResponse(tSC)
	quit $$$OK
}

}

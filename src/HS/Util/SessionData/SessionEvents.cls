Class HS.Util.SessionData.SessionEvents Extends %CSP.SessionEvents
{

/// Subclasses must either override this parameter OR override <method>GetApplication</method>()
/// to ensure that a session application is returned.
Parameter SESSIONAPPLICATION;

/// Subclasses may override this parameter to specify an alternative <class>Session</class> class.
Parameter SESSIONCLASS = "HS.Util.SessionData.Session";

/// Subclasses may override this value if they wish to manually control the creation of a <class>Session</class>,
/// or should override <method>GetCreationFlag</method>() to implement more nuanced logic.
Parameter ALWAYSCREATESESSION = 1;

/// Subclasses may override this value if they wish to prevent an existing session with the same ID
/// from being deleted. If the API call returns an error, the current session will be ended.
Parameter DELETEEXISTINGSESSION = 1;

/// Parameter that controls the string used to indicate that the session timed out.
Parameter REASONTIMEOUT = "timeout";

/// Parameter that controls the string used to indicate the user logged out.
Parameter REASONLOGOUT = "logout";

/// Parameter that controls the string used to indicate the session has ended.
Parameter REASONEND = "end";

/// Subclasses may override this method to return a dynamic application name.
/// The default value is defined by the <parameter>SESSIONAPPLICATION</parameter> parameter.
/// If no application is specified, no session will be created.
ClassMethod GetApplication() As %String
{
	Quit ..#SESSIONAPPLICATION
}

/// Subclasses may override this method to return an application-specific session ID.
/// The default implementation is to return the CSP Session ID.
ClassMethod GetSessionID() As %String
{
	Quit $select($isobject($get(%session)): %session.SessionId, 1: "")
}

/// Subclasses may override this method to use an alternative mechanism for 
/// determining whether a <class>Session</class> object should be created.
ClassMethod GetCreationFlag() As %Boolean
{
	Quit ..#ALWAYSCREATESESSION
}

ClassMethod GetSessionIdentifiers(Output pApplication As %String, Output pSessionID As %String) [ Final ]
{
	Set pApplication = ""
	Set pSessionID = ""

	Set pApplication = ..GetApplication()
	If (pApplication = "") {
		Quit
	}
	Set pSessionID = ..GetSessionID()
	Quit
}

/// Called when a new session is created and its values are initialised.
/// <p>This is called before the license for this session is allocated, and if
/// you wish to abort this session and return the standard out of licenses error
/// page then:
/// <example>
/// Set %session.EndSession=1
/// </example>
ClassMethod OnStartSession() [ Final ]
{
	If ('..GetCreationFlag()) {
		Quit
	}

	Do ..GetSessionIdentifiers(.tApplication,.tSessionID)
	If (tApplication = "") || (tSessionID = "") {
		Quit
	}
	Set tStatus = $classmethod(..#SESSIONCLASS,"CreateSession",.tSession,tApplication,tSessionID,..#DELETEEXISTINGSESSION)
	
	// TODO: How should we log errors?
	Quit
}

/// Called when the session is about to be deleted, either because of a timeout (in which case
/// <method>OnTimeout</method> is called first) or because the application
/// has explicitly closed this session. Use the %session object to examine this session. If you wish to
/// abort this deletion then:
/// <example>
/// Set %session.EndSession=0
/// </example>
ClassMethod OnEndSession()
{
	Do ..GetSessionIdentifiers(.tApplication,.tSessionID)
	If (tApplication = "") || (tSessionID = "") {
		Quit
	}

	Set tStatus = $classmethod(..#SESSIONCLASS,"EndSession",tApplication,tSessionID,..#REASONEND)
	// TODO: How should we log errors?
	Quit
}

/// Called when the CSP Daemon times out out this session before calling <method>EndSession</method>.
/// Use the %session object to examine this session. If you wish to abort this deletion then:
/// <example>
/// Set %session.EndSession=0
/// </example>
ClassMethod OnTimeout()
{
	Do ..GetSessionIdentifiers(.tApplication,.tSessionID)
	If (tApplication = "") || (tSessionID = "") {
		Quit
	}

	Set tStatus = $classmethod(..#SESSIONCLASS,"EndSession",tApplication,tSessionID,..#REASONTIMEOUT)
	// TODO: How should we log errors?
	Quit
}

/// Called when a logout. The current authentication for the session is invalidated. occurs that changed the $username or the roles this user is running with.
/// If this returns an error status then the logout will be stopped.
/// If you wish to end the session after the logout then:
/// <example>
/// Set %session.EndSession=1
/// </example>
ClassMethod OnLogout() As %Status
{
	Do ..GetSessionIdentifiers(.tApplication,.tSessionID)
	If (tApplication = "") || (tSessionID = "") {
		Quit $$$OK
	}

	Set tStatus = $classmethod(..#SESSIONCLASS,"EndSession",tApplication,tSessionID,..#REASONLOGOUT)
	// TODO: How should we log/report errors?

	Quit $$$OK
}

}

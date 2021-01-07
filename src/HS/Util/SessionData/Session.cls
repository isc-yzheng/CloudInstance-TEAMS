Include HS.HC

/// <p>This is a general purpose session class that can be used to manage the life cycle
/// of any application data that should be cleaned up when a session ends.</p>
/// <p>The data that needs to be tied to such a session should extend <class>AbstractSessionData</class>,
/// which leaves the main responsibility of the application developer to be the life cycle management of
/// the <class>Session</class> object.</p>
/// <p>For CSP or REST applications that use sessions, the management should be implemented as a subclass 
/// of <class>SessionEvents</class>, but applications may use any management scheme that addresses their use case, 
/// provided the code calls the <method>StartSession</method>() and <method>EndSession</method>() methods on the
/// intended <class>Session</class> class or subclass.</p>
Class HS.Util.SessionData.Session Extends (%Persistent, %XML.Adaptor)
{

/// Flag that controls whether a transaction should be used to wrap the 
/// <method>OnEndSession</method>() callback and the actual delete of the
/// <class>Session</class> instance.
Parameter TRANSACTIONONENDSESSION = 0;

/// Note that this index uses EXACT collation, primarily to support CSP session IDs.
Index AppSession On (Application, SessionID) [ Unique ];

/// <p>This property should be set to an application-specific value to allow multiple
/// sessions for different applications and/or use cases to coexist within a single namespace.</p>
/// <p><strong>NOTE:</strong> The following case-insensitive prefixes are reserved for use by 
/// HealthShare applications and <strong>MUST NOT</strong> be used by customer code:
/// <ul><li><code>"healthshare"</code></li>
/// <li><code>"hs"</code></li></ul></p>
Property Application As %String(COLLATION = "EXACT", MAXLEN = 100) [ Required ];

/// This value should be set to an application-specific session identifier.
/// A natural fit for session-based CSP applications will be the CSP session ID.
Property SessionID As %String(COLLATION = "EXACT", MAXLEN = 50) [ Required ];

/// API to create a new session object, which should be called on the intended 
/// <class>Session</class> class or subclass.
/// Subclasses should override <method>OnCreateSession</method>() to perform any additional initialization.
ClassMethod CreateSession(Output pSession As HS.Util.SessionData.Session, pApplication As %String = "", pSessionID As %String = "", pDeleteExistingSession As %Boolean = 0, pContext...) As %Status [ Final ]
{
	Set tStatus = $$$OK
	Try {
		Set pSession = ""

		If (pApplication = "") || (pSessionID = "") {
			Quit
		}

		If ..AppSessionExists(pApplication,pSessionID,.tSessionID) {
			If ('pDeleteExistingSession) {
				Set tStatus = $$$ERROR($$$HSErrSessionExists,pApplication,pSessionID)
				Quit
			}
			Else {
				Set tStatus = ..%DeleteId(tSessionID)
				If $$$ISERR(tStatus) {
					Quit
				}
			}
		}

		Set tSession = ..%New()
		Set tSession.Application = pApplication
		Set tSession.SessionID = pSessionID

		Set tStatus = tSession.OnCreateSession(.pContext)
		If $$$ISERR(tStatus) {
			Quit
		}

		Set tStatus = tSession.%Save()
		If $$$ISERR(tStatus) {
			Quit
		}

		Set pSession = tSession
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Subclasses may override this method to initialize the <class>Session</class>
/// object when it is created.
Method OnCreateSession(ByRef pContext) As %Status [ Internal ]
{
	Quit $$$OK
}

/// Subclasses may override this method to perform cleanup before the <class>Session</class>
/// class is deleted.
/// Note that if <parameter>TRANSACTIONONENDSESSION</parameter> is true, this method will be wrapped inside 
/// a transaction along with the main <class>Session</class> delete operation.
/// The value of <var>pReason</var> is intended to convey information about why a session was ended.
ClassMethod OnEndSession(pID As %Integer = "", pApplication As %String = "", pSessionID As %String = "", pReason As %String = "") As %Status [ Internal ]
{
	Quit $$$OK
}

/// API to end a session and clean up all the related data.
/// This API should be called on the <class>Session</class> class or subclass.
ClassMethod EndSession(pApplication As %String = "", pSessionID As %String = "", pReason As %String = "") As %Status [ Final ]
{
	Set tStatus = $$$OK
	Set tInitTLevel = $TLevel
	Try {
		If (pApplication = "") || (pSessionID = "") || '..AppSessionExists(pApplication,pSessionID,.tSessionID) {
			Quit
		}
		
		// Ensure that we invoke the right callbacks for a session that was created using a subclass
		Set tSessionOID = $$$oidForm(tSessionID)
		Set tStatus = ..%OnDetermineClass(tSessionOID,.tSessionClass)
		If $$$ISERR(tStatus) {
			Quit
		}
		
		If (tSessionClass '= "") && (tSessionClass '= $classname()) && ##class(%Dictionary.CompiledClass).%ExistsId(tSessionClass) {
			Set tStatus = $classmethod(tSessionClass,"EndSession",pApplication,pSessionID,pReason)
			Quit
		}

		If ..#TRANSACTIONONENDSESSION {
			TStart
		}
		
		Set tStatus = ..OnEndSession(tSessionID,pApplication,pSessionID,pReason)
		If $$$ISERR(tStatus) {
			Quit
		}

		Set tStatus = ..%DeleteId(tSessionID)
		If $$$ISERR(tStatus) {
			Quit
		}

		If ..#TRANSACTIONONENDSESSION {
			TCommit
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	While ($TLevel > tInitTLevel) {
		TRollback 1
	}
	Quit tStatus
}

Storage Default
{
<Data name="SessionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Application</Value>
</Value>
<Value name="3">
<Value>SessionID</Value>
</Value>
</Data>
<DataLocation>^HS.Util.SessionData.SessionD</DataLocation>
<DefaultData>SessionDefaultData</DefaultData>
<IdLocation>^HS.Util.SessionData.SessionD</IdLocation>
<IndexLocation>^HS.Util.SessionData.SessionI</IndexLocation>
<StreamLocation>^HS.Util.SessionData.SessionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

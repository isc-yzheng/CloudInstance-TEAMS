/// Every FHIR resource streamlet (subclass of HS.FHIR.vDSTU2.Repository.Resource.Abstract
/// or HS.FHIR.vSTU3.Repository.Resource.Abstract) stored in the resource repository may
/// optionally be linked to a FHIRSession via its Session property. A linked streamlet
/// will have Session="[FHIRSession.Application]||[FHIRSession.SessionId]".<br>
/// When the FHIRSession is deleted, the streamlet will also be deleted
/// (physical delete, as opposed to just being marked deleted). This is
/// implemented via the %OnDelete() method and OnDeleteSQL trigger in this
/// class. For this reason, FHIRSessions *must not* be deleted by manually
/// killing nodes in the storage global.
Class HS.FHIR.SessionData.FHIRSession Extends HS.Util.SessionData.Session
{

/// Override of property from inherited class.
/// This value should be set to an application-specific session identifier.
Property SessionID As %String(COLLATION = "EXACT", MAXLEN = 127) [ Required ];

Property SessionState As %Integer [ InitialExpression = 0 ];

/// Expires is the time in seconds from beginning of the Unix epoch when the session expires.
/// If Expires="", then session does not expire.
Property Expires As %Integer;

/// Patient MPIID as the FHIR Patient resource id.
Property PatientResourceId As %String(MAXLEN = 64);

Property Username As %String(MAXLEN = 128);

Property UserRoles As %String(MAXLEN = 2048);

/// Order by time
Index ExpiresIndex On Expires;

Method OnCreateSession(ByRef pContext) As %Status [ Internal ]
{
	If $Data(pContext(1,"Username"))#10 Set ..Username = pContext(1,"Username")
	If $Data(pContext(1,"UserRoles"))#10 Set ..UserRoles = pContext(1,"UserRoles")
	Quit $$$OK
}

Method IsExpired() As %Boolean
{
	quit ..IsExpiredHandler(..Expires)
}

ClassMethod IsExpiredSQLProc(pExpires As %Integer = 0) As %Boolean [ SqlProc ]
{
	quit ..IsExpiredHandler(pExpires)
}

ClassMethod IsExpiredHandler(pExpires As %Integer = 0) As %Boolean
{
	Set tExpired = 0
	
	If +pExpires>0 {
		Set tNow = ##class(HS.FHIR.Utils).TimeInSeconds($ZTimeStamp, 0)
		If pExpires<tNow Set tExpired = 1
	}
	
	Quit tExpired
}

/// API
/// Delete all FHIRSessions
/// Note that because of the OnDeleteSQL trigger in this class, this will also
/// delete any resource streamlets linked to a session via its Session property.
ClassMethod DeleteAllSessions() As %Status
{
	try {
		set tSC = $$$OK
		&SQL(DELETE FROM HS_FHIR_SessionData.FHIRSession)
		if (SQLCODE < 0) { set tSC = $$$ERROR($$$GeneralError, "SQL Error "_SQLCODE_", "_$system.SQL.SQLCODE(SQLCODE)) quit }
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// API
/// Delete expired FHIRSessions ("Expires" in the past)<br>
/// Note that because of the OnDeleteSQL trigger in this class, this will also
/// delete any resource streamlets linked to an expired session via its Session property.
ClassMethod DeleteExpiredSessions() As %Status
{
	try {
		set tSC = $$$OK
		&SQL(DELETE FROM HS_FHIR_SessionData.FHIRSession 
		            WHERE HS_FHIR_SessionData.FHIRSession_IsExpiredSqlProc(Expires)=1)
		if (SQLCODE < 0) { set tSC = $$$ERROR($$$GeneralError, "SQL Error "_SQLCODE_", "_$system.SQL.SQLCODE(SQLCODE)) quit }
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Final, Private, ServerOnly = 1 ]
{
	// If %OnDelete returns an error, the delete will be aborted.
    Quit ..OnDeleteHandler($LG(oid))
}

Trigger OnDeleteSQL [ Event = DELETE, Final ]
{
     New class,id,sc
     Set class={%%CLASSNAMEQ} Quit:class=""
     Set id={%%ID} Quit:id=""
     Set sc=$classmethod(class,"OnDeleteHandler",id)
     // Setting %ok to 0 will cause the delete to be aborted.
     If $$$ISERR(sc) Set %ok=0,%msg=$system.Status.GetOneErrorText(sc)
     Quit
}

/// Deletes resource streamlets that have Session="[FHIRSession.Application]||[FHIRSession.SessionId]"
ClassMethod OnDeleteHandler(id) As %Status [ Final, ServerOnly = 1 ]
{
	Try {
		Set tSC=$$$OK
		Set tObj=..%OpenId(id) quit:'$IsObject(tObj)
		set tSession = tObj.Application_"||"_tObj.SessionID
		Do ..DeleteDSTU2(tSession)
		Do ..DeleteSTU3(tSession)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
    Quit tSC
}

ClassMethod DeleteDSTU2(pSession As %String) As %Status
{
	Quit ##class(HS.FHIR.vDSTU2.Repository.Storage).DeleteSessionResources(pSession)
}

ClassMethod DeleteSTU3(pSession As %String) As %Status
{
	Quit ##class(HS.FHIR.vSTU3.Repository.Storage).DeleteSessionResources(pSession)
}

Storage Default
{
<Data name="FHIRSessionDefaultData">
<Subscript>"FHIRSession"</Subscript>
<Value name="1">
<Value>SessionState</Value>
</Value>
<Value name="2">
<Value>Expires</Value>
</Value>
<Value name="3">
<Value>PatientResourceId</Value>
</Value>
<Value name="4">
<Value>Username</Value>
</Value>
<Value name="5">
<Value>UserRoles</Value>
</Value>
</Data>
<DefaultData>FHIRSessionDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

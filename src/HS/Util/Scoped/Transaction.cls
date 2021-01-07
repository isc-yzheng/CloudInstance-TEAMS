/// This object provides a scope-safe wrapper around a transaction. A transaction is started when
/// the Start() classmethod is invoked which returns a 'Tranaction' instance.  The tranaction can be 
/// Committed by calling the Commit() method or aborted by calling the Rollback method.
/// If the transaction is unresolved when the object goes out of scope, it will be rolled back.
Class HS.Util.Scoped.Transaction Extends %RegisteredObject
{

Property closingMethod As %String [ Private ];

/// This method starts a transaction and returns the scoped object.
ClassMethod Start() As HS.Util.Scoped.Transaction
{
	return ..%New()
}

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	TSTART
	return $$$OK
}

/// Commits the transaction level begun when 'Start' was invoked.
/// <br> This method will throw a GeneralError if either Commit or Rollback was called previously.
Method Commit()
{
	do ..checkConsistency()
	Set ..closingMethod = "TCOMMIT"
	TCOMMIT
}

/// Rolls-back the transaction level begun when 'Start' was invoked
/// <br>This method will throw a GeneralError if either Commit or Rollback was called previously.
Method Rollback()
{
	do ..checkConsistency()
	Set ..closingMethod = "TROLLBACK"
	TROLLBACK 1
}

Method checkConsistency() [ Private ]
{
	if ..closingMethod '= "" {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"Transaction is complete; the '" _ ..closingMethod _ " method has already been invoked")) 
	}
}

Method %OnClose() As %Status [ Private, ServerOnly = 1 ]
{
	Set tSC = $$$OK
	if ..closingMethod = "" {
		try {
			Do ..Rollback()
		} catch ex {
			set tSC = ex.AsStatus()
		}
	}
	Quit tSC
}

}

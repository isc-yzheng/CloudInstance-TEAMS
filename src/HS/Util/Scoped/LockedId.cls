Include %occErrors

/// On Construction, this object attempts to acquire a lock.  If the
/// lock could not be acquired within 'timeoutSec' seconds, then
/// an exception is thrown.  Otherwise, the lock is held until either:
/// <br>  a) The Release method is called, or 
/// <br>  b) the object goes out of scope (is destroyed).
Class HS.Util.Scoped.LockedId Extends %RegisteredObject
{

Property IsLocked As %Boolean [ Calculated ];

Property lockedId As %String [ Private ];

Property lockType As %Boolean [ Private ];

Property persistentClassname As %String [ Private ];

Method %OnNew(pPersistentClassname As %String, pId As %String, pShared = 0, pTimeoutSec As %Integer, pThrowOnTimeout = 0) As %Status
{
 
	#dim sc as %Status = $classmethod(pPersistentClassname, "%LockId", pId, pShared, pTimeoutSec)
	if $$$ISERR(sc) {
		// $System.Status.Equals checks against only the first code when sc is multiple codes.
		// However, that is good enough, because if we get anything other than what we're
		// checking for here then we need to Throw.
		if ('pThrowOnTimeout) && ($System.Status.Equals(sc, $$$LockFailedToAcquireExclusive, $$$LockFailedToAcquireRead)) {
			// Return as not locked.  The caller may test for this condition
			return $$$OK	
		}
		$$$ThrowOnError(sc)
	}
	// We acquired the lock, initialize our state
	Set ..lockedId = pId
	Set ..lockType = pShared
	Set ..persistentClassname = pPersistentClassname
	return $$$OK
}

Method IsLockedGet() As %Boolean [ CodeMode = expression ]
{
..lockedId '= ""
}

/// Explicitly releases the lock acquried when this object was constructed.
/// If not explicitly called, the lock will be released when this object 
/// is destroyed.
Method Release()
{
    if ..lockedId '= "" {
        Set tSC = $classmethod(..persistentClassname, "%UnlockId", ..lockedId, ..lockType, 1)
    	$$$ThrowOnError(tSC)
        Set ..lockedId = ""
    }
}

/// This method ensures that the %Lock is released, if present,
/// when this object goes out of scope
Method %OnClose() As %Status [ Private, ServerOnly = 1 ]
{
    Set tSC = $$$OK
    try {
    	Do ..Release()
    } catch ex {
	    // In case the release throws
	    Set tSC = ex.AsStatus()
    }
    Quit tSC
}

}

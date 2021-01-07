/// This class may be inherited by a %Persistent object to enable critical-section locking based
/// on the id (effectively row/instance-locking).  The two methods return a LockedId object which will
/// keep the id locked for the duration of the lifetime of the returned object, unless explictly released earlier.
/// <br>See: HS.Util.Scoped.LockedId
Class HS.Util.Scoped.Lockable [ Abstract ]
{

/// Waits up to 'timeoutSecs' to acquire an exclusive lock on the specified id of this persistent class
/// Returns a LockedId object which will release the lock upon a) an explicit call to its Release method,
/// or b) when it goes out of scope.
/// <br>If the lock is acquire within 'timeoutSecs', then out, a HS.Util.Scoped.LockedId instance is returned.<br
/// Otherwise if 'throwOnTimeout' is 1 (default), the timeout status will be thrown, or, if 'throwOnTimeout' is 0 otherwise "" is returned.
ClassMethod GetExclusiveLock(pId As %String, pTimeoutSecs As %Integer, pThrowOnTimeout As %Boolean = 1) As HS.Util.Scoped.LockedId
{
	Set lock = ##class(LockedId).%New(..%ClassName(1), pId, 0, pTimeoutSecs, pThrowOnTimeout)
	if lock.IsLocked {
		return lock
	} 
	return ""
}

/// Waits up to 'timeoutSecs' to acquire shared lock on the specified id of this persistent class
/// Returns a LockedId object which will release the lock upon a) an explicit call to its Release method,
/// or b) when it goes out of scope.
/// <br>If the lock is acquire within 'timeoutSecs', then out, a HS.Util.Scoped.LockedId instance is returned.
/// Otherwise if 'throwOnTimeout' is 1 (default), the timeout status will be thrown, or, if 'throwOnTimeout' is 0 otherwise "" is returned.
ClassMethod GetSharedLock(pId As %String, pTimeoutSecs As %Integer, pThrowOnTimeout As %Boolean = 1) As HS.Util.Scoped.LockedId
{
	Set lock = ##class(LockedId).%New(..%ClassName(1), pId, 1, pTimeoutSecs, pThrowOnTimeout)
	if lock.IsLocked {
		return lock
	} 
	return ""
}

}

/// Created from: c:/temp/healthcare-security-audit2.xsd
Class HS.IHE.ATNA.Repository.Data.OID Extends %String [ ClassType = datatype ]
{

Parameter MAXLEN;

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

}

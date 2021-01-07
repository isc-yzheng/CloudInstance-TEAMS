/// Meant to be used in conjunction with "supercontainers" , i.e. containers
/// that can have a single parent object container, plust any number of child object containers.
/// Each child object would extend this class, to allow a single transaction to save the parent plus
/// multiple childen, including the ability to update specific children or to delete specific ones.
Class HS.Util.WebServices.SuperContainerListItem Extends (HS.Util.WebServices.ListItem, HS.Util.CopyFrom)
{

/// A - Add (default), D - Delete, U - Update
/// If A, then ID must be null
/// IF D or U, then ID must not be null
Property Action As %String(VALUELIST = ",A,D,U");

}

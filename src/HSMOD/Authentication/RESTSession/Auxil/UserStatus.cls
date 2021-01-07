/// User status information object returned by the API
/// @API.Object
/// @API.Extensible
Class HSMOD.Authentication.RESTSession.Auxil.UserStatus Extends %RegisteredObject
{

/// @API.Property
Property Username As %String(MAXLEN = 128);

/// @API.Property
Property SessionTimeout As %Integer;

/// @API.Property
Property SessionRoles As list Of %String;

}

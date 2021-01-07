/// Used as a dummy version of %CSP.Session, to allow background processing to
/// cache stuff in %session.Data, even though there is no %CSP.Session.
/// Some web.SDA3 code is invoking ##class(HS.UI.Util).ConfigValue to get and cache configuration registry values
/// in %session.Data.  The background parallel processing classes can use this class to make this work
Class HS.Util.SessionCache Extends %RegisteredObject
{

Property Data As %String [ MultiDimensional ];

}

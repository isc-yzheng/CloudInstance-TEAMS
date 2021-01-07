Class HS.Util.Installer.AbstractConfigItemType [ Abstract ]
{

/// Helper method to return whether a given namespace type is in the Health Connect code
/// base or in the larger HealthShare application.
ClassMethod IsFoundationConfigType() As %Boolean [ Abstract, Internal ]
{
}

/// Helper method to return the default CSP SessionEvents class that should be 
/// added to user-facing CSP applications for this ConfigItem type.
ClassMethod GetDefaultCSPSessionEventsClass() As %String [ Abstract ]
{
}

/// Helper method to return the default CSP Custom Login page that should be 
/// added to user-facing CSP applications for this ConfigItem type.
ClassMethod GetDefaultCSPCustomLoginPage() As %String [ Abstract ]
{
}

}

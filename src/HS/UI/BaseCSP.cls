/// Base class for all classes that extend <class>%CSP.Page</class> to provide overriden implementation of functions in <class>%CSP.Page</class>
Class HS.UI.BaseCSP Extends %CSP.Page
{

/// Cache resource name to apply for permission check. Default value is empty, which performs no check. 
Parameter RESOURCE;

/// All subclasses of this class MUST call <method>##super()</method>
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	If $UserName="UnknownUser" {
		Set %response.Status = "403 Forbidden"
		Quit 0
	}
	
	if ..#RESOURCE '= "" {
		if '$SYSTEM.Security.Check(..#RESOURCE,"USE") {
			Set %response.Status = "403 Forbidden"
			Quit 0
		}
	}
	
	Quit 1
}

}

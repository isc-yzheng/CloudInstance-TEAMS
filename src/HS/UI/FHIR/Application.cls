/// This is the application class for FHIR UI. Used by Forms and Installer under UI.
Class HS.UI.FHIR.Application Extends HS.UI.Application
{

/// This will only be used in 2011.1+.  Added per Yan
/// Provide finder contents for the HealthShare pages. Called from %CSP.Portal.Home.
ClassMethod GetHealthShareArray(Output pData) As %Status
{
	//Set pMetaData = $LB("name","title","link","disabled","icon","description")
	Set tDisabled = 0
	Set pData($I(n)) = $LB($$$Text("Health Management"),,$$$HSUILink("Home","HS.UI.Home.cls"),tDisabled,"portal/architect_48.gif",$$$Text("Goto Management Portal home page"))

	Quit $$$OK
}

}

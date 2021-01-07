Class HS.UI.Logout Extends HS.UI.Base
{

/// Displayed name of this page.
Parameter PAGENAME = "Logout";

Property HomeApplication As %ZEN.Datatype.string [ InitialExpression = {$S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"HS.UI.Home.cls",1:"HS.HC.UI.Home.cls")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title bar */
body {
	font-family: arial,tahoma,verdana;
	background: white;	
}
a.link {
	color: blue;
	font-family: tahoma,arial,verdana;
	font-size: 16px;
	text-decoration: underline;	
}
a.link:visited {
	color: blue;
	text-decoration: underline;
}
a.link:hover {
	color: #384492;
	text-decoration: none;
}
a.link:active {
	color: blue;

}
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<html OnDrawContent="DrawTitle" id="title" seed=""/>
<spacer height="4"/>
<html OnDrawContent="DrawMessage"></html>
<spacer height="4"/>
<link id="idLink" href="/csp/healthshare/HS.UI.Home.cls" caption="Login" align="center"/>
</page>
}

/// Logout.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = $$$OK
	try {
		Set FromURL = $G(%request.Data("FROM",1))
		Set tComponent = ..%GetComponentById("idLink")
		If tComponent.href = "/csp/healthshare/HS.UI.Home.cls" {
			If '##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance() {
				Set tComponent.href = "/csp/healthshare/HS.HC.UI.Home.cls"
			}
		}
		If FromURL '= "" Set tComponent.href = FromURL
		#; logout
		Do %session.Logout()
		Set %session.EndSession = 1
		#; give it a little time for the session to end
		H 1
		//For now, we'll suppress this page, assuming redirection works
		Set %response.Redirect=..%GetComponentById("idLink").href
	}
	catch(ex) {
		#dim ex As %Exception.AbstractException
		Set tSC = ex.AsStatus()
	}	

	Quit $$$OK
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set pShowLogout = 0
	Set pShowInfo = 0
	Set pShowAccount = 0
	Set Title = $$$TextHTML("HealthShare")
	Do %application.DrawTitle(Title,pShowLogout,pShowInfo,pShowAccount)
	Quit $$$OK
}

Method DrawMessage(pSeed As %String) As %Status
{
	&html<<center>#($$$TextHTML("You are logged out from HealthShare"))#</center>>
	Quit $$$OK
}

}

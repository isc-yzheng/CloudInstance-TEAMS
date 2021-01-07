Class HS.Test.UI.FHIR.OAuth2RemoveToken Extends HS.Test.UI.FHIR.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Remove OAuth 2.0 Access Token";

Parameter RESOURCE = "%HS_TestSuite";

XData Contents
{
<page title="FHIR Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
	
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">

<spacer height="15"/>

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<combobox label="Client: *" id="cmbOAuth2Client" size="70" tabIndex="15" title="OAuth 2.0 client defined in System Administration &gt; Security &gt; OAuth 2.0 &gt; Client. The auth and token end points are derived from the definition of this client." />

<spacer height="5"/>

<button id="btnRemoveToken" caption=" Remove Access Token " onclick="zenPage.RemoveToken()" />

</form>
</pane>
</page>
}

Method RemoveToken() [ ZenMethod ]
{
	#dim %page As %CSP.Page
	#dim %session As %CSP.Session
	
	try {
		set tSC = $$$OK
		
		set tOAuth2Client = %page.%GetValueById("cmbOAuth2Client")
		if tOAuth2Client="" &js<alert('Please specify an OAuth 2.0 client')> quit
		if '..IsValidClient(tOAuth2Client) &js<alert('Invalid OAuth 2.0 client')> quit
		
		// Don't call IsAuthorized to find a token, as it will report no token found
		// when actually there is client token stored, but is somehow invalid (most
		// likely expired).
		
		set tSC = ##class(%SYS.OAuth2.AccessToken).RemoveAccessToken(tOAuth2Client, %session.SessionId)
		if $$$ISERR(tSC) {
			&js<alert('Error removing access token - #($system.Status.GetErrorText(tSC))#')>
			set tSC = $$$OK
			quit
		} else {
			// Since we have no way of distinguish whether there was no access token
			// versus only an invalid/expired token stored, just report that the
			// RemoveAccessToken() call was successful, as it will report success
			// even when there is no token stored at all.
			&js<alert('Call to RemoveAccessToken() was successful')>
		}
		
		set %session.Data("FHIR.Test", 0, "OAuth2Client") = ""
		set %session.Data("FHIR.Test", 0, "OAuth2Scopes") = ""
		set %session.Data("FHIR.Test", 0, "OAuth2Launch") = ""
		set %session.Data("FHIR.Test", 0, "OAuth2Aud") = ""
		set %session.Data("FHIR.Test", 0, "OAuth2Iss") = ""
		set %session.Data("FHIR.Test", 0, "OAuth2Claims") = ""
		
	}
	catch (ex) { set tSC = ex.AsStatus() }
	if $$$ISERR(tSC) { &js<alert('#($system.Status.GetOneErrorText(tSC))#')> }
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tCombo=..%GetComponentById("cmbOAuth2Client")
	Set tCombo.valueList=..GetClientList()
	Set tCombo.displayList=tCombo.valueList
	
	set tOAuth2Client = $Get(%session.Data("FHIR.Test", 0, "OAuth2Client"))
	set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
	do ..%SetValueById("cmbOAuth2Client", tOAuth2Client)
	
	quit $$$OK
}

}

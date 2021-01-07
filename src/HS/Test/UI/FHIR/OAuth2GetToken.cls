Class HS.Test.UI.FHIR.OAuth2GetToken Extends HS.Test.UI.FHIR.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Get OAuth 2.0 Access Token";

Parameter RESOURCE = "%HS_TestSuite";

XData Contents
{
<page title="FHIR Test Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
	
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">

<spacer height="10"/>

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<combobox label="Client: *" id="cmbOAuth2Client" size="70" tabIndex="10" title="OAuth 2.0 client defined in System Administration &gt; Security &gt; OAuth 2.0 &gt; Client. The auth and token end points are derived from the definition of this client." />
<text label="Scopes: *" id="txtOAuth2Scopes" size="70" tabIndex="20" title="Space-delimited list of scopes for the access token." />
<text label="Launch: " id="txtOAuth2Launch" size="70" tabIndex="30" title="(optional) Value for launch scope on access token." />
<spacer height="5"/>
<dataCombo id="cmbServiceRegistry" size='70' label="EndPoint: " tabIndex="40" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateFHIRServiceRegistryRS"
	title = "Service Registry entry for a resource server endpoint. The EndPoint URL will be used as the aud value, unless aud is explicitly specified." 
	maxRows="10000">
	<parameter/>
</dataCombo>
<spacer height="5" />
<text label="aud: " id="txtAudClaim" size="70" tabIndex="50" title="(optional) aud claim value for the access token request. If specified, it overrides the URL value of the EndPoint selection as the value to use. The aud value will be included in the OAuth authorization request as the value of the 'aud' URL parameter." />
<text label="iss: " id="txtIssClaim" size="70" tabIndex="60" title="(optional) iss claim value for the access token request. If specified, this value will be included in the OAuth authorization request as value of the 'iss' URL parameter." />
<text label="Claims: " id="txtOtherClaims" size="70" tabIndex="70" title="(optional) Comma-delimited list of claim name-value pairs. For example, 'claim1=value1,claim2=value2'. If specified, this will be forumated into a JSON string that will be included in the OAuth authorization request as value of the 'claims' URL parameter." />

<spacer height="5"/>

<button id="btnGetToken" caption=" Get Access Token " tabIndex="80" onclick="zenPage.GetToken()" />

<spacer height="5"/>

<label id="lblProgress" value="" />

<spacer height="5"/>

<textarea id="textAreaToken" label="Access Token: " readOnly="true" tabIndex="90" rows="20" cols="80" />
<button id="btnCopyToken" caption="Copy to Clipboard" tabIndex="100" onclick="zenPage.copyToken()" />

<spacer height="10"/>
<text label="Auth Endpoint: " id="txtAuthEP" size="85" readOnly="true" title="OAuth 2.0 authorization endpoint obtained from OAuth 2.0 Client definition." />
<spacer height="5"/>
<text label="Token Endpoint: " id="txtTokenEP" size="85" readOnly="true" title="OAuth 2.0 token endpoint obtained from OAuth 2.0 Client definition." />
</form>
</pane>
</page>
}

ClientMethod copyToken() [ Language = javascript ]
{
  var copyText = zen('textAreaToken').findElement('control');
  copyText.select();
  document.execCommand("copy");
}

Method GetToken() [ ZenMethod ]
{
	#dim tRequest As HS.Message.FHIR.Request
	#dim tResponse As HS.Message.FHIR.Response
	#dim tServiceObj As HS.Registry.Service.HTTP
	#dim %page As %CSP.Page
	#dim %session As %CSP.Session
	
	try {
		set tSC = $$$OK
		
		set tOAuth2Client = %page.%GetValueById("cmbOAuth2Client")
		set tOAuth2Scopes = %page.%GetValueById("txtOAuth2Scopes")
		set tOAuth2Scopes = $Translate(tOAuth2Scopes, ",", " ")
		set tOAuth2Launch = %page.%GetValueById("txtOAuth2Launch")
		set tServiceName = %page.%GetValueById("cmbServiceRegistry")
		set tAudClaim = %page.%GetValueById("txtAudClaim")
		set tIssClaim = %page.%GetValueById("txtIssClaim")
		set tOtherClaimsStr = %page.%GetValueById("txtOtherClaims")
		
		if tOAuth2Client="" &js<alert('Please specify an OAuth 2.0 client')> quit
		if '..IsValidClient(tOAuth2Client) &js<alert('Invalid OAuth 2.0 client')> quit
		if tOAuth2Scopes="" &js<alert('Please specify Scopes')> quit
		
		if tOtherClaimsStr'="" {
			set tBadClaims = 0
			for i = 1:1:$Length(tOtherClaimsStr,",") {
				set tName = $Piece($Piece(tOtherClaimsStr, ",", i), "=", 1)
				set tValue = $Piece($Piece(tOtherClaimsStr, ",", i), "=", 2)
				if tName="" set tBadClaims = 1 quit
				set tOtherClaimsArr(tName) = tValue
			}
			if tBadClaims {
				&js<alert('Invalid Claims string entered')>
				quit
			}
		}
		
		if (tAudClaim="")&&(tServiceName="") &js<alert('Please select an EndPoint or enter an aud value')> quit
		if tServiceName'="" {
			set tServiceObj = ##class(HS.Registry.Service.Abstract).EndPointForNameType(tServiceName, "HTTP")
			if '$IsObject(tServiceObj) &js<alert('EndPoint not defined in Service Registry')> quit
		}
		
		// This redirect URL is the one that specifies this application.
		set tRedirectURL = $Piece(%session.Referrer,"/",1,3)
		set tRedirectURL = tRedirectURL_%session.Application
		set tRedirectURL = tRedirectURL_..%ClassName(1)_".cls"
		set tRedirectURL = tRedirectURL_"?$NAMESPACE="_$Namespace
		
		set tAuthURL = ""
		set tTokenURL = ""
		
		set tSC = ##class(HS.FHIR.Utils).GetOAuthClientInfo(tOAuth2Client, .tClientInfo)
		if $$$ISERR(tSC) &js<alert('OAuth 2.0 Client info retrieve failed - #($system.Status.GetOneErrorText(tSC))#')> quit
		
		do ..%SetValueById("txtAuthEP", tClientInfo("authorization_endpoint"))
		do ..%SetValueById("txtTokenEP", tClientInfo("token_endpoint"))
		
		set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
		set %session.Data("FHIR.Test", 0, "OAuth2ClientGetToken") = tOAuth2Client
		set %session.Data("FHIR.Test", 0, "OAuth2Scopes") = tOAuth2Scopes
		set %session.Data("FHIR.Test", 0, "OAuth2Launch") = tOAuth2Launch
		set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
		set %session.Data("FHIR.Test", 0, "OAuth2Aud") = tAudClaim
		set %session.Data("FHIR.Test", 0, "OAuth2Iss") = tIssClaim
		set %session.Data("FHIR.Test", 0, "OAuth2Claims") = tOtherClaimsStr
		set %session.Data("FHIR.Test", ..%ClassName(0), "AuthEP") = tClientInfo("authorization_endpoint")
		set %session.Data("FHIR.Test", ..%ClassName(0), "TokenEP") = tClientInfo("token_endpoint")
		
		kill error
		
		#; Check to see if somehow there is already an authorization existing for this client.
		set tIsAuthorized = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(tOAuth2Client , %session.SessionId, tOAuth2Scopes, .accessToken, .IDToken, .responseProperties, .error)
		if tIsAuthorized {
			&js<alert('This app is already authorized')>
			&js<zen('textAreaToken').setValue(#(..QuoteJS(accessToken))#);>
			quit
		}
		
		#dim error As %OAuth2.Error
		if $IsObject($Get(error)) {
			&js<alert('Error from IsAuthorized - #(error.ErrorDescription)#')>
			set %session.Data("FHIR.Test", 0, "OAuth2Scopes") = ""
			quit
		}
		
		#; Build the URL that will be used to make the actual authorization request.
		kill tProperties
		set tProperties("aud") = $Select(tAudClaim'="":tAudClaim, 1:tServiceObj.EndPoint)
		if tOAuth2Launch'="" set tProperties("launch") = tOAuth2Launch
		if tIssClaim'="" set tProperties("iss") = tIssClaim
		// claims other than iss and aud go into a JSON string.
		if $Data(tOtherClaimsArr) {
			set tClaimsObj = ##class(%Library.DynamicObject).%New()
			set tClaimName = ""
			for {
				set tClaimName = $Order(tOtherClaimsArr(tClaimName))
				if tClaimName="" quit
				Do tClaimsObj.%Set(tClaimName, tOtherClaimsArr(tClaimName))
			}
			set tClaimsJSONStr = tClaimsObj.%ToJSON()
			set tProperties("claims") = tClaimsJSONStr
		}
		
		set tURL = ##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint(tOAuth2Client, tOAuth2Scopes, tRedirectURL, .tProperties, .tIsAuthorized, .tSC)
		
		if $$$ISERR(tSC) {
			&js<alert('Error from GetAuthorizationCodeEndpoint - #($system.Status.GetErrorText(tSC))#')>
			set %session.Data("FHIR.Test", 0, "OAuth2Client") = ""
			quit
		}
		
		do ..%SetValueById("lblProgress", "Sending authorization request...")
		
		#; Invoke the authorization request URL.
		&js<zenPage.gotoPage('#(tURL)#');>
		
		set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
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
	set tOAuth2ClientGetToken = $Get(%session.Data("FHIR.Test", 0, "OAuth2ClientGetToken"))
	set tOAuth2Scopes = $Get(%session.Data("FHIR.Test", 0, "OAuth2Scopes"))
	set tOAuth2Launch = $Get(%session.Data("FHIR.Test", 0, "OAuth2Launch"))
	set tOAuth2Aud = $Get(%session.Data("FHIR.Test", 0, "OAuth2Aud"))
	set tOAuth2Iss = $Get(%session.Data("FHIR.Test", 0, "OAuth2Iss"))
	set tOAuth2Claims = $Get(%session.Data("FHIR.Test", 0, "OAuth2Claims"))
	set tServiceName = $Get(%session.Data("FHIR.Test", 0, "ServiceName"))
	set tAuthEP = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "AuthEP"))
	set tTokenEP = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "TokenEP"))
	set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
	set %session.Data("FHIR.Test", 0, "OAuth2ClientGetToken") = tOAuth2ClientGetToken
	set %session.Data("FHIR.Test", 0, "OAuth2Scopes") = tOAuth2Scopes
	set %session.Data("FHIR.Test", 0, "OAuth2Launch") = tOAuth2Launch
	set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
	set %session.Data("FHIR.Test", 0, "OAuth2Aud") = tOAuth2Aud
	set %session.Data("FHIR.Test", 0, "OAuth2Iss") = tOAuth2Iss
	set %session.Data("FHIR.Test", 0, "OAuth2Claims") = tOAuth2Claims
	set %session.Data("FHIR.Test", ..%ClassName(0), "AuthEP") = tAuthEP
	set %session.Data("FHIR.Test", ..%ClassName(0), "TokenEP") = tTokenEP
	
	do ..%SetValueById("cmbOAuth2Client", tOAuth2ClientGetToken)
	do ..%SetValueById("txtOAuth2Scopes", tOAuth2Scopes)
	do ..%SetValueById("txtOAuth2Launch", tOAuth2Launch)
	do ..%SetValueById("cmbServiceRegistry", tServiceName)
	do ..%SetValueById("txtAudClaim", tOAuth2Aud)
	do ..%SetValueById("txtIssClaim", tOAuth2Iss)
	do ..%SetValueById("txtOtherClaims", tOAuth2Claims)
	do ..%SetValueById("txtAuthEP", tAuthEP)
	do ..%SetValueById("txtTokenEP", tTokenEP)
	
	do ..%SetValueById("lblProgress", "")
	
	#dim error As %OAuth2.Error
	if (tOAuth2Client '= "") && (tOAuth2Scopes '= "") {
		set tIsAuthorized = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(tOAuth2Client , %session.SessionId, tOAuth2Scopes, .accessToken, .IDToken, .responseProperties, .error)
		if tIsAuthorized {
			do ..%SetValueById("textAreaToken", accessToken)
		} elseif $IsObject($Get(error)) {
			do ..%SetValueById("lblProgress", error.ErrorDescription)
			set %session.Data("FHIR.Test", 0, "OAuth2Scopes") = ""
			set %session.Data("FHIR.Test", 0, "OAuth2Launch") = ""
			set %session.Data("FHIR.Test", 0, "OAuth2Aud") = ""
			set %session.Data("FHIR.Test", 0, "OAuth2Iss") = ""
			set %session.Data("FHIR.Test", 0, "OAuth2Claims") = ""
			// Don't bother with checking return status on RemoveAccessToken.
			set tSC = ##class(%SYS.OAuth2.AccessToken).RemoveAccessToken(tOAuth2Client, %session.SessionId)
		}
	}
	
	quit $$$OK
}

}

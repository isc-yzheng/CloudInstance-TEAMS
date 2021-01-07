Class HS.Test.UI.FHIR.PatientDelete Extends HS.Test.UI.FHIR.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "FHIR Patient Delete";

XData Contents
{
<page title="HealthShare FHIR Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
	
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">

<spacer height="15"/>

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<dataCombo id="cmbServiceRegistry" size='70' label="EndPoint: *" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateFHIRServiceRegistryRS"
	title = "Service Registry entry for the resource server endpoint." 
	maxRows="10000">
	<parameter/>
</dataCombo>
<spacer width="5" />
<combobox id="cmbFormat" label="FHIR Format: *" size="22" tabIndex="35" dropdownHeight="80" title="If 'xml' is chosen, then the FHIR request to the resource server will add an Accept header of 'application/xml+fhir' (for DSTU2) or 'application/fhir+xml' (for STU3 and later). If 'json' is chosen, then the FHIR request to the resource server will add an Accept header of 'application/json+fhir' (for DSTU2) or 'application/fhir+json' (for STU3 and later)." />
<spacer width="5" />
<text label="Client:" id="txtOAuth2Client" size="70" tabIndex="15" title="OAuth 2.0 client defined in System Administration &gt; Security &gt; OAuth 2.0 &gt; Client. If this field has a value when the request is submitted, then the request will look for a valid access token for the specified client on this session. If one is found, then it will be passed to the target endpoint. If not found, then an error will be returned." />
<spacer height="5"/>
<text label="Resource ID: *" id="txtResourceID" size="35"/>
<spacer height="5"/>

<button id="btnSend" caption=" Submit Request " onclick="zenPage.Send()" />

<spacer height="15"/>

<textarea label="Response:" id="txtResponse" rows="20" cols="80" readOnly="true" />
</form>
</pane>
</page>
}

Method Send() [ ZenMethod ]
{
	#dim tRequest As HS.Message.FHIR.Request
	#dim tResponse As HS.Message.FHIR.Response
	#dim tService As HS.Registry.Service.HTTP
	try {
		set tSC = $$$OK
		
		set tSC = ..CheckProduction(.tText)
		if $$$ISERR(tSC) quit
		if $get(tText)'="" quit
		
		Set tServiceName = %page.%GetValueById("cmbServiceRegistry")
		If tServiceName="" &js<alert('Please choose a server')> Quit
		Set tServiceObj = ##class(HS.Registry.Service.Abstract).EndPointForNameType(tServiceName, "HTTP")
		If '$IsObject(tServiceObj) &js<alert('Server not defined in Service Registry')> Quit
		
		Set tFormat = %page.%GetValueById("cmbFormat")
		If tFormat="" &js<alert('Please choose a FHIR format')> Quit
		
		Set tOAuth2Client = %page.%GetValueById("txtOAuth2Client")
		If (tOAuth2Client'="")&&('..IsValidClient(tOAuth2Client)) &js<alert('Invalid OAuth 2.0 client')> Quit
		
		set tId = %page.%GetValueById("txtResourceID")
		if tId="" &js<alert('Please enter a Resource ID')> quit
		
		set tRequest = ##class(HS.Message.FHIR.Request).%New()
		set tRequest.Interaction = "delete"
		if tOAuth2Client'="" {
			do tRequest.AdditionalInfo.SetAt(tOAuth2Client, "OAuth2ClientName")
			do tRequest.AdditionalInfo.SetAt(%session.SessionId, "ClientSessionId")
		}
		set tRequest.BaseURL = tServiceObj.EndPoint
		set tRequest.Type = "Patient"
		set tRequest.Id = tId
		
		do tRequest.SetParameter("_format", tFormat)
		
		do ..%SetValueById("txtResponse","")
		
		do tRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		set tSC = ##class(HS.Test.Service).SendSync(tRequest, .tResponse) quit:$$$ISERR(tSC)
		
		do %page.%SetValueById("txtResponse", tResponse.Payload.Read($$$MaxLocalLength))
		do tResponse.Payload.Rewind()
		
		set tErrorOrWarning = ""
		
		if tResponse.Payload.Size>0 {
			set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(tFormat, tResponse.Payload, .tOperationOutcomeObject, "HS.FHIR.vSTU3.Model.Resource")
			if $$$ISERR(tSC) quit
			
			if tOperationOutcomeObject.%ClassName(0)="OperationOutcome" {
				set tErrorOrWarning = tOperationOutcomeObject.issue.GetAt(1).details.text.value
			}
		}
		
		if $Extract(tResponse.Status,1,3)="404" {
			&js<alert('Patient resource id #(tId)# not found')>
		} elseif ($Extract(tResponse.Status,1,3)="200")||($Extract(tResponse.Status,1,3)="204") {
			if tErrorOrWarning="" {
				&js<alert('Delete was successful')>
			} else {
				&js<alert('#(tErrorOrWarning)#')>
			}
		} else {
			&js<alert('#(tResponse.Status)#')> 
		}
		
		set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
		set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
		set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
		
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
	// Load dropdowns from parameters
	Set tCombo=..%GetComponentById("cmbFormat")
	Set tCombo.valueList=",xml,json"
	Set tCombo.displayList=tCombo.valueList
		
	set tServiceName = $Get(%session.Data("FHIR.Test", 0, "ServiceName"))
	set tOAuth2Client = $Get(%session.Data("FHIR.Test", 0, "OAuth2Client"))
	set tFormat = $Get(%session.Data("FHIR.Test", 0, "FHIRFormat"))

	set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
	set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
	set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
	
	do ..%SetValueById("cmbServiceRegistry", tServiceName)
	do ..%SetValueById("txtOAuth2Client", tOAuth2Client)
	do ..%SetValueById("cmbFormat", tFormat)
	
	quit $$$OK
}

}

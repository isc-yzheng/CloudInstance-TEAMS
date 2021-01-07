Class HS.Test.UI.FHIR.PatientSearch Extends HS.Test.UI.FHIR.Main
{

XData Contents
{
<page xmlns="http://www.intersystems.com/zen">
<text id="txtResponseId" hidden="true"/>
<tabGroup id="tabGroup" 
showTabBar="true" 
remember="false" 
currTab="1" 
width="98%"
height="1400"
enclosingStyle="margin:5px;padding:5px;">
<tab id="tabSearch" caption="Search" labelPosition="left" cellStyle="padding:4px;">
<pane paneName="searchPane"/>
</tab>
<tab id="tabResultsDetailed" caption="Search Results Detailed" labelPosition="left" cellStyle="padding:2px;" disabled="false">
<pane paneName="resultsPane"/>
</tab>
</tabGroup>
</page>
}

XData searchPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">

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
<combobox id="cmbVersion" label="FHIR Version: *" size="22" tabIndex="35" dropdownHeight="80" title="FHIR version to which the returned content is expected to comply." />
<spacer width="5" />
<text label="Client:" id="txtOAuth2Client" size="70" tabIndex="15" title="OAuth 2.0 client defined in System Administration &gt; Security &gt; OAuth 2.0 &gt; Client. If this field has a value when the request is submitted, then the request will look for a valid access token for the specified client on this session. If one is found, then it will be passed to the target endpoint. If not found, then an error will be returned." />
<spacer height="5"/>

<fieldSet id="fsParams" legend="Search Parameters" labelPosition="left">
<text label="Name: " id="txtParamName" size="35"/>
<text label="Family: " id="txtParamFamily" size="35"/>
<text label="Given: " id="txtParamGiven" size="35"/>
<text label="Birthdate: " id="txtParamBirthdate" size="35" title="yyyy-mm-dd"/>
<text label="Gender: " id="txtParamGender" size="35" title="code, system|code, or |code"/>
<text label="Identifier: " id="txtParamIdentifier" size="35" title="code, system|code, or |code"/>
</fieldSet>

<spacer height="10"/>

<button id="btnSend" caption=" Submit Request " onclick="zenPage.Send()" />

<spacer height="10"/>

<textarea label="Response:" id="txtResponse" rows="50" cols="80" readOnly="true" />
</form>
</pane>
}

XData resultsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="resultsPane" xmlns="http://www.intersystems.com/zen">
</pane>
}

Method Send() [ ZenMethod ]
{
	#dim tRequest As HS.Message.FHIR.Request
	#dim tResponse As HS.Message.FHIR.Response
	#dim tService As HS.Registry.Service.HTTP
	try {
		set tSC = $$$OK
		
		set tReadLen = $Select($system.SYS.MaxLocalLength()=3641144:3640000,1:32000)
		
		set tSC = ..CheckProduction(.tText)
		if $$$ISERR(tSC) quit
		if $get(tText)'="" quit
		
		Set tServiceName = %page.%GetValueById("cmbServiceRegistry")
		If tServiceName="" &js<alert('Please choose a server')> Quit
		Set tServiceObj = ##class(HS.Registry.Service.Abstract).EndPointForNameType(tServiceName, "HTTP")
		If '$IsObject(tServiceObj) &js<alert('Server not defined in Service Registry')> Quit
		
		Set tFormat = %page.%GetValueById("cmbFormat")
		If tFormat="" &js<alert('Please choose a FHIR format')> Quit
		
		Set tFHIRVersion = %page.%GetValueById("cmbVersion")
		If tFHIRVersion="" &js<alert('Please choose a FHIR version')> Quit
		
		Set tOAuth2Client = %page.%GetValueById("txtOAuth2Client")
		If (tOAuth2Client'="")&&('..IsValidClient(tOAuth2Client)) &js<alert('Invalid OAuth 2.0 client')> Quit
		
		set tRequest = ##class(HS.Message.FHIR.Request).%New()
		set tRequest.Interaction = "search"
		for tParamName="Name","Family","Given","Birthdate","Gender","Identifier" {
			set tVal = %page.%GetValueById("txtParam"_tParamName)
			if (tVal'="") { do tRequest.SetParameter($ZCVT(tParamName,"L"), tVal) }
		}
		if tOAuth2Client'="" {
			do tRequest.AdditionalInfo.SetAt(tOAuth2Client, "OAuth2ClientName")
			do tRequest.AdditionalInfo.SetAt(%session.SessionId, "ClientSessionId")
		}
		set tRequest.BaseURL = tServiceObj.EndPoint
		set tRequest.Type = "Patient"
		set tRequest.FHIRVersion = tFHIRVersion
		
		do tRequest.SetParameter("_format", tFormat)
		
		do ..%SetValueById("txtResponse","")
		
		do tRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		set tSC = ##class(HS.Test.Service).SendSync(tRequest, .tResponse) quit:$$$ISERR(tSC)
		
		if +tResponse.Status>399 &js<alert('#(tResponse.Status)#')>
		
		set tResultTab = %page.%GetComponentById("tabResultsDetailed")
		set tResultsPane = %page.%GetComponentById("resultsPane")
		// In case there are results there from a previous search
		do tResultsPane.%RemoveChildren()
		
		if 'tResponse.Payload.Size quit
		
		do %page.%SetValueById("txtResponse", tResponse.Payload.Read(tReadLen))

		do tResponse.Payload.Rewind()
		set tResponseString = tResponse.Payload.Read(tReadLen)
		// Remove the XML prolog if present
		if ($E(tResponseString,1,5) = "<?xml") {
			set tStart = $F(tResponseString,">")
			set tResponseString = $E(tResponseString,tStart,*)
			do tResponse.Payload.Clear()
			do tResponse.Payload.Write(tResponseString)
		}
		do tResponse.Payload.Rewind()
		if tFHIRVersion="DSTU2" {
			set tResourceSchemaRoot = "HS.FHIR.vDSTU2.Model.Resource"
		} else {
			set tResourceSchemaRoot = "HS.FHIR.vSTU3.Model.Resource"
		}
		set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(tFormat, tResponse.Payload, .tBundle, tResourceSchemaRoot) quit:$$$ISERR(tSC)
		if tBundle.%ClassName(0)="Bundle" {
			set tCount = tBundle.entry.Count()
			for tI=1:1:tCount {
				set tFieldSet = ##class(%ZEN.Component.fieldSet).%New()
				set tFieldSet.legend = "Search Result "_tI
				set tFieldSet.id = "fsResult"_tI
				set tFieldSet.labelPosition = "left"
				
				set tEntry = tBundle.entry.GetAt(tI)
				set tPatient = tEntry.resource.Patient
				set tId = tPatient.id.value
				set tIdText = ##class(%ZEN.Component.text).%New()
				set tIdText.value = tId
				set tIdText.label = "Resource ID: "
				set tIdText.readOnly = 1
				do tFieldSet.%AddChild(tIdText)
				
				if (tPatient.name.Count()>0) {
					set tName = tPatient.name.GetAt(1)
					set tFamily = ""
					if tFHIRVersion="DSTU2" {
						for tJ=1:1:tName.family.Count() { set tFamily = tFamily_tName.family.GetAt(tJ).value_" " }
					} else {
						set tFamily = tName.family.value
					}
					set tFamilyText = ##class(%ZEN.Component.text).%New()
					set tFamilyText.value = tFamily
					set tFamilyText.label = "Family name: "
					set tFamilyText.readOnly = 1
					do tFieldSet.%AddChild(tFamilyText)
					set tGiven = ""
					for tJ=1:1:tName.given.Count() { set tGiven = tGiven_tName.given.GetAt(tJ).value_" " }
					set tGivenText = ##class(%ZEN.Component.text).%New()
					set tGivenText.value = tGiven
					set tGivenText.label = "Given name: "
					set tGivenText.readOnly = 1
					do tFieldSet.%AddChild(tGivenText)
				}
				
				set tDOB = tPatient.birthDate.value
				set tDOBText = ##class(%ZEN.Component.text).%New()
				set tDOBText.value = tDOB
				set tDOBText.label = "DOB: "
				set tDOBText.readOnly = 1
				do tFieldSet.%AddChild(tDOBText)
				
				for tJ=1:1:tPatient.identifier.Count() {
					set tIdentifier = tPatient.identifier.GetAt(tJ)
					set tType = tIdentifier.type
					if $IsObject(tType)&&(tType.coding.Count() > 0) { set tTypeCode = tType.coding.GetAt(1).code.value }
					else { set tTypeCode = "" }
					set tSystem = tIdentifier.system.value
					set tValue = tIdentifier.value.value
					set tIdentifierText = ##class(%ZEN.Component.text).%New()
					set tIdentifierText.value = tSystem_"|"_tValue
					if (tTypeCode'="") { set tIdentifierText.label = "Identifier ("_tTypeCode_"): " }
					else { set tIdentifierText.label = "Identifier: " }
					set tIdentifierText.readOnly = 1
					set tIdentifierText.size = 60
					do tFieldSet.%AddChild(tIdentifierText)
				}
				
				for tJ=1:1:tPatient.address.Count() {
					set tAddress = tPatient.address.GetAt(tJ)
					set tUse = tAddress.use.value
					set tStreet = ""
					for tK=1:1:tAddress.line.Count() { set tStreet = tStreet_$S(tStreet'="":" ", 1:"")_tAddress.line.GetAt(tK).value }
					set tCity = tAddress.city.value
					set tState = tAddress.state.value
					set tZIP = tAddress.postalCode.value
					set tCountry = tAddress.country.value
					set tAddressText = ##class(%ZEN.Component.text).%New()
					if (tUse'="") { set tAddressText.label = "Address ("_tUse_"): " }
					else { set tAddressText.label = "Address: " }
					set tAddressText.value = tStreet_" "_tCity_", "_tState_" "_tZIP_" "_tCountry
					set tAddressText.size = 60
					set tAddressText.readOnly = 1
					do tFieldSet.%AddChild(tAddressText)
				}
				
				do tResultsPane.%AddChild(tFieldSet)
				
				set tSpacer = ##class(%ZEN.Component.spacer).%New()
				set tSpacer.height = 10
				do tResultsPane.%AddChild(tSpacer)
			}
		} ElseIf tBundle.%ClassName(0)="OperationOutcome" {
			Set tText = tBundle.issue.GetAt(1).details.text.value
			If tText="" Set tText = tBundle.issue.GetAt(1).diagnostics.value
			If tText="" Set tText = "unknown error"
			&js<alert('Error returned in OperationOutcome - #(tText)#')>
		} Else {
			&js<alert('Unexpected resource type returned - #(tBundle.%ClassName(0))#')>
		}
		
		set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
		set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
		set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
		set %session.Data("FHIR.Test", 0, "FHIRVersion") = tFHIRVersion
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
		
	Set tCombo=..%GetComponentById("cmbVersion")
	Set tCombo.valueList="STU3,DSTU2"
	Set tCombo.displayList=tCombo.valueList
	
	set tServiceName = $Get(%session.Data("FHIR.Test", 0, "ServiceName"))
	set tOAuth2Client = $Get(%session.Data("FHIR.Test", 0, "OAuth2Client"))
	set tFormat = $Get(%session.Data("FHIR.Test", 0, "FHIRFormat"))
	set tFHIRVersion = $Get(%session.Data("FHIR.Test", 0, "FHIRVersion"))

	set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
	set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
	set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
	set %session.Data("FHIR.Test", 0, "FHIRVersion") = tFHIRVersion
	
	do ..%SetValueById("cmbServiceRegistry", tServiceName)
	do ..%SetValueById("txtOAuth2Client", tOAuth2Client)
	do ..%SetValueById("cmbFormat", tFormat)
	do ..%SetValueById("cmbVersion", tFHIRVersion)
	
	quit $$$OK
}

}

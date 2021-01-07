Class HS.Test.UI.FHIR.PatientAdd Extends HS.Test.UI.FHIR.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Add New Patient";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textReadOnly {
	border: 1px inset threedface;
	color:#777777;
	background: #EEEEEE;
}
</style>
}

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents
{
<page title="HealthShare FHIR Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="10"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<dataCombo id="cmbServiceRegistry" size='70' label="EndPoint: *" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateFHIRServiceRegistryRS"
	title = "Service Registry entry for the resource server endpoint." 
	maxRows="10000">
	<parameter/>
</dataCombo>
<spacer width="5" />
<combobox id="cmbFormat" label="FHIR Format: *" size="22" tabIndex="35" dropdownHeight="80" title="If 'xml' is chosen, then the FHIR request to the resource server will add an Accept header and Content-Type header of 'application/xml+fhir' (for DSTU2) or 'application/fhir+xml' (for STU3 and later). If 'json' is chosen, then the FHIR request to the resource server will add an Accept header and Content-Type header of 'application/json+fhir' (for DSTU2) or 'application/fhir+json' (for STU3 and later)." />
<spacer width="5" />
<combobox id="cmbVersion" label="FHIR Version: *" size="22" tabIndex="35" dropdownHeight="80" title="FHIR version to which the sent content and/or returned content is expected to comply." />
<spacer width="5" />
<text label="Client:" id="txtOAuth2Client" size="70" tabIndex="15" title="OAuth 2.0 client defined in System Administration &gt; Security &gt; OAuth 2.0 &gt; Client. If this field has a value when the request is submitted, then the request will look for a valid access token for the specified client on this session. If one is found, then it will be passed to the target endpoint. If not found, then an error will be returned." />
<spacer height="5"/>
<hgroup label="Interaction:" labelPosition="left" id="grpInteraction">
<radioSet id="rdoInteraction" valueList="create,update" captionClass="lblNormal" tabIndex="10" />
</hgroup>
<spacer width="5" />
<checkbox label="Return Resource:" id="chkReturnResource" title="Set the HTTP PREFER header to 'return=representation' to trigger the server to echo the saved resource back in the response payload." tabIndex="25"/>
<spacer height="5"/>
<text label="Resource Id:" id="txtResourceID" size="30" tabIndex="30" title="Include Resource Id only for update"/>
<text label="Prefix:" id="txtPrefix" size="15" tabIndex="44" />
<text label="First Name:" name="FirstName" id="txtFirstName" size="30" tabIndex="50" />
<text label="Middle Name:" name="MiddleName" id="txtMiddleName" size="30" tabIndex="60" />
<text label="Last Name:" name="LastName" id="txtLastName" size="30" tabIndex="70" />
<text label="Suffix:" id="txtSuffix" size="15" tabIndex="80" />
<text label="Street:" name="Street" id="txtStreet" size="80" tabIndex="90" />
<text label="City:" name="City" id="txtCity" size="20" tabIndex="100" />
<text label="State:" name="State" id="txtState" size="10" tabIndex="110" />
<text label="Zip:" name="Zip" id="txtZip" size="10" tabIndex="120" />
<text label="Home Phone:" name="HomePhone" id="txtHomePhone" size="20" hint="(XXX-XXX-XXXX)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="130" />
<text label="Business Phone:" name="BusinessPhone" id="txtBusinessPhone" size="20" hint="(XXX-XXX-XXXX)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="140" />
<combobox id="cmbGender" label="Gender:" size="22" tabIndex="150"/>
<dateText id="dtDOB" label="Date of Birth:" size="22" minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="160"/>
<text label="Mothers Maiden Surname:" name="MothersMaidenSurname" id="txtMaidenSurname" size="20" tabIndex="170" />
<dataCombo id="cmbAA" label="AssigningAuthority:" size="80" tabIndex="180" onchange="zenPage.GetNextMRN()" 
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateAssigningAuthorityRS"
	maxRows="10000">
</dataCombo>
<text label="AssigningAuthority OID:" name="aaOID" id="txtAAOID" size="80" readOnly="1" controlClass="textReadOnly" tabIndex="190" />
<dataCombo id="cmbFacility" label="Facility:" size="80" tabIndex="200"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateFacilityRS"
	maxRows="10000">
</dataCombo>
<text label="MRN:" name="MRN" id="txtMRN" size="22" readOnly="0" tabIndex="210" />
<text label="MPIID:" name="MPIID" id="txtMPIID" size="22" readOnly="0" hidden="1" tabIndex="220" />
<spacer height="10"/>

<hgroup width="40%" cellAlign="left">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1);" tabIndex="230" />
<spacer width="5" />
<button id="btnClearDemo" caption=" Clear " onclick="zenPage.ClearDemographics();" tabIndex="240" />
<spacer width="5" />
</hgroup>
<spacer height="10"/>
<textarea label="Request Payload" id="txtRequest" rows="25" cols="80" readOnly="true" tabIndex="250" />
<spacer height="10"/>
<textarea label="Response Payload" id="txtResponse" rows="25" cols="80" readOnly="true" tabIndex="260" />
</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod ClearDemographics() [ Language = javascript ]
{
	var rtnrsrc = this.getComponentById('chkReturnResource');
	var resid = this.getComponentById('txtResourceID');
	var prefix = this.getComponentById('txtPrefix');
	var fname = this.getComponentById('txtFirstName');
	var mname = this.getComponentById('txtMiddleName');
	var lname = this.getComponentById('txtLastName');
	var suffix = this.getComponentById('txtSuffix');
	var street = this.getComponentById('txtStreet');
	var city = this.getComponentById('txtCity');
	var state = this.getComponentById('txtState');
	var zip = this.getComponentById('txtZip');
	var hphone = this.getComponentById('txtHomePhone');
	var bphone = this.getComponentById('txtBusinessPhone');
	var gender = this.getComponentById('cmbGender');
	var dob = this.getComponentById('dtDOB');
	var aa = this.getComponentById('cmbAA');
	var mmsname = this.getComponentById('txtMaidenSurname');
	var facility = this.getComponentById('cmbFacility');
	var mrn = this.getComponentById('txtMRN');
	var aaoid = this.getComponentById('txtAAOID');
	var mpiid = this.getComponentById('txtMPIID');
	
	rtnrsrc.setValue("1");
	resid.setValue("");
	prefix.setValue("");
	fname.setValue("");
	mname.setValue("");
	lname.setValue("");
	suffix.setValue("");
	street.setValue("");
	city.setValue("");
	state.setValue("");
	zip.setValue("");
	hphone.setValue("");
	bphone.setValue("");
	gender.setValue("");
	dob.setValue("");
	mmsname.setValue("");
	aa.setValue("");
	facility.setValue("");
	mrn.setValue("");
	aaoid.setValue("");
	mpiid.setValue("");
	var results=this.getComponentById("paneResults")
	for (var n = 0; n < results.children.length; n++) {
		results.removeChild(results.children[n]);
	}
}

ClientMethod GoPIXQuery() [ Language = javascript ]
{
	var queryParam = "?PATIENTMRN="+zen('txtMRN').getValue()+"&PATIENTAA="+zen('cmbAA').getValue();
	window.location="HS.Test.UI.PIXQuery.cls"+queryParam;
}

/// Get the next automatically-assigned MRN for the home facility
Method GetNextMRN() [ ZenMethod ]
{
	Set:'$D(^IHETEST.Patient.NextMRN) ^IHETEST.Patient.NextMRN=200000000
	Set tNextMRN = $I(^IHETEST.Patient.NextMRN)
	Set tAA = %page.%GetComponentById("cmbAA").value
	Set tAAOID=##class(HS.Data.OIDMap).OIDForType(tAA,"AssigningAuthority")
	&js<zen('txtMRN').setValue('#(tNextMRN)#');>
	&js<zen('txtAAOID').setValue('#(tAAOID)#');>
	If ##class(HS.Facility.Config).%ExistsId(tAA) { 
		&js<zen('cmbFacility').setValue('#(tAA)#');>
	}
}

Method Send() As %String [ ZenMethod ]
{
	try {
		set tSC = $$$OK
		
		set tSessionID=""
		
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
		
		Set tInteraction = %page.%GetValueById("rdoInteraction")
		If tInteraction="" &js<alert('Please choose an interaction (create or update)')> Quit
		
		do ..%SetValueById("txtRequest","")
		do ..%SetValueById("txtResponse","")
		
		Set pMRN = %page.%GetValueById("txtMRN")
		Set pAA = %page.%GetValueById("cmbAA")
		Set pAAOID = %page.%GetValueById("txtAAOID")
		If pMRN="" || (pAA="") &js< alert('MRN and Assigning Authority are required');> Quit
		
		Set tDOB=%page.%GetValueById("dtDOB")
		
		Set tFHIRModelRoot = "HS.FHIR.v"_tFHIRVersion_".Model"
		
		Set tPatientObj = $ClassMethod(tFHIRModelRoot_".Resource.Patient", "%New")
		Set tSC = tPatientObj.SetName(%page.%GetValueById("txtLastName"), %page.%GetValueById("txtFirstName"), %page.%GetValueById("txtMiddleName"), %page.%GetValueById("txtPrefix"), %page.%GetValueById("txtSuffix"), "usual") Quit:$$$ISERR(tSC)
		Set tAddressObj = $ClassMethod(tFHIRModelRoot_".Base.Address", "%New")
		Set tStreet = %page.%GetValueById("txtStreet")
		If tStreet'="" {
			For i = 1:1:$Length(tStreet, ";") {
				Set tP = $Piece(tStreet, ";", i)
				Set tP = $ZStrip(tP, "<>W")
				If tP'="" Set tSC = tAddressObj.SetLine(tP) Quit:$$$ISERR(tSC)
			}
		}
		Quit:$$$ISERR(tSC)
		Set tSC = tAddressObj.SetCity(%page.%GetValueById("txtCity")) Quit:$$$ISERR(tSC)
		Set tSC = tAddressObj.SetState(%page.%GetValueById("txtState")) Quit:$$$ISERR(tSC)
		Set tSC = tAddressObj.SetPostalCode(%page.%GetValueById("txtZip")) Quit:$$$ISERR(tSC)
		Set tSC = tAddressObj.SetUse("home") Quit:$$$ISERR(tSC)
		Set tSC = tPatientObj.address.Insert(tAddressObj) Quit:$$$ISERR(tSC)
		
		Set tHomePh=%page.%GetValueById("txtHomePhone")
		If tHomePh'="" {
			Set tTelecomObj = $ClassMethod(tFHIRModelRoot_".Base.ContactPoint", "%New")
			Set tSC = tTelecomObj.SetSystem("phone") Quit:$$$ISERR(tSC)
			Set tSC = tTelecomObj.SetUse("home") Quit:$$$ISERR(tSC)
			Set tSC = tTelecomObj.SetValue(%page.%GetValueById("txtHomePhone")) Quit:$$$ISERR(tSC)
			Set tSC = tPatientObj.telecom.Insert(tTelecomObj) Quit:$$$ISERR(tSC)
		}
		
		Set tBusPh=%page.%GetValueById("txtBusinessPhone")
		If tBusPh'="" {
			Set tTelecomObj = $ClassMethod(tFHIRModelRoot_".Base.ContactPoint", "%New")
			Set tSC = tTelecomObj.SetSystem("phone") Quit:$$$ISERR(tSC)
			Set tSC = tTelecomObj.SetUse("work") Quit:$$$ISERR(tSC)
			Set tSC = tTelecomObj.SetValue(%page.%GetValueById("txtBusinessPhone")) Quit:$$$ISERR(tSC)
			Set tSC = tPatientObj.telecom.Insert(tTelecomObj) Quit:$$$ISERR(tSC)
		}
		
		Set tSC = tPatientObj.SetBirthDate(tDOB) Quit:$$$ISERR(tSC)
		
		If %page.%GetValueById("txtMaidenSurname")'="" {
			Set tExtObj = $ClassMethod(tFHIRModelRoot_".Base.Extension", "%New", "http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName", "String", %page.%GetValueById("txtMaidenSurname"))
			If '$IsObject($Get(tExtObj)) Set tSC = $$$ERROR($$$GeneralError, "Mothers Maiden Name extension object not created") Quit
			Set tSC = tPatientObj.extension.Insert(tExtObj)
			If $$$ISERR(tSC) Quit
		}
		
		Set tGender = $ZConvert(%page.%GetValueById("cmbGender"),"L")
		Set tGender = $Case(tGender, "m":"male", "male":"male", "f":"female", "female":"female", "o":"other", "other":"other", :"unknown")
		Set tSC = tPatientObj.SetGender(tGender) Quit:$$$ISERR(tSC)
		Set tSC = tPatientObj.SetIdentifier(pMRN, pAAOID, , "MR", , "MR") Quit:$$$ISERR(tSC)
		
		If %page.%GetValueById("txtResourceID")'="" {
			Set tSC = tPatientObj.SetId(%page.%GetValueById("txtResourceID")) Quit:$$$ISERR(tSC)
		}
		
		#; Hard-coded values.
		Set tSC = tPatientObj.SetActive(1) Quit:$$$ISERR(tSC)
		Set tSC = tPatientObj.SetDeceasedBoolean(0) Quit:$$$ISERR(tSC)
		Set tSC = tPatientObj.SetMultipleBirthBoolean(0) Quit:$$$ISERR(tSC)
		Set tCommunicationObj = $ClassMethod(tFHIRModelRoot_".Resource.Patient.Communication", "%New")
		Set tSC = tCommunicationObj.SetLanguage("en", "English", "", "English") Quit:$$$ISERR(tSC)
		Set tSC = tCommunicationObj.SetPreferred(1) Quit:$$$ISERR(tSC)
		Set tSC = tPatientObj.communication.Insert(tCommunicationObj) Quit:$$$ISERR(tSC)
		
		Set tInteraction = %page.%GetValueById("rdoInteraction")
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(tFormat, tPatientObj, .tFHIRStream)
		If $$$ISERR(tSC) Quit
		
		Set tRequest = ##class(HS.Message.FHIR.Request).%New()
		
		If tFHIRVersion'="DSTU2" {
			If tFormat="json" {
				Set tContentType = "application/fhir+json"
			} else {
				Set tContentType = "application/fhir+xml"
			}
			Set tResourceSchemaRoot = "HS.FHIR.vSTU3.Model.Resource"
		} else {
			if tFormat="json" {
				set tContentType = "application/json+fhir"
			} else {
				set tContentType = "application/xml+fhir"
			}
			set tResourceSchemaRoot = "HS.FHIR.vDSTU2.Model.Resource"
		}
		
		Set tRequest.ContentType = tContentType
		
		Set tRequest.FHIRVersion = tFHIRVersion
		
		#; For create, resource id must not be specified.
		#; For update, resource id must be specified.
		#; Allow the UI to get it wrong, in order to test
		#; validation of create and update. 
		Set tRequest.Interaction = %page.%GetValueById("rdoInteraction")
		
		#; The HTTP PREFER header may be set to trigger the server to echo back the resource that was saved to the database.
		Set tReturnResource = %page.%GetValueById("chkReturnResource")
		If tReturnResource=1 Set tSC = tRequest.Headers.SetAt("return=representation","PREFER") Quit:$$$ISERR(tSC)
		
		Set tSC = tRequest.Payload.CopyFrom(tFHIRStream) Quit:$$$ISERR(tSC)
		
		if tOAuth2Client'="" {
			do tRequest.AdditionalInfo.SetAt(tOAuth2Client, "OAuth2ClientName")
			do tRequest.AdditionalInfo.SetAt(%session.SessionId, "ClientSessionId")
		}
		set tRequest.BaseURL = tServiceObj.EndPoint
		set tRequest.Type = "Patient"
		If %page.%GetValueById("txtResourceID")'="" set tRequest.Id = %page.%GetValueById("txtResourceID")

		#; FHIR REST API doesn't say case-sensitive, but only lists lowercase _format values.  Just make it lowercase.
		do tRequest.SetParameter("_format", tFormat)
		
		do tRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		do tFHIRStream.Rewind()
		do ..%SetValueById("txtRequest",tFHIRStream.Read($$$MaxLocalLength))
		do tFHIRStream.Rewind()
		
		set tSC = ##class(HS.Test.Service).SendSync(tRequest, .tResponse) quit:$$$ISERR(tSC)
		
		if $Extract(tResponse.Status,1,3)>399 &js<alert('#(tResponse.Status)#')>
		If tResponse.Payload.Size>0 do %page.%SetValueById("txtResponse", tResponse.Payload.Read($$$MaxLocalLength))
		
		set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
		set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
		set %session.Data("FHIR.Test", 0, "FHIRVersion") = tFHIRVersion
		set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
		set %session.Data("FHIR.Test", ..%ClassName(0), "Interaction") = tInteraction
		set %session.Data("FHIR.Test", ..%ClassName(0), "ReturnResource") = tReturnResource
		
	} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID = ""
	}
	if $$$ISERR(tSC) { &js<alert('#($system.Status.GetOneErrorText(tSC))#')> }
	Quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $isObject(tResponse) && $$$ISOK(pTest.Status) {
		Set results=%page.%GetComponentById("paneResults")
		Set tService = ..GetServiceRegistryEntry()
		Do %page.%SetValueById("txtPatientID", tResponse.MPIID_"^^^&"_$$$HomeCommunityOID_"&ISO")
		Set tAffinityDomain = $$$AffinityDomain
		If $isObject(tService) {
			If tService.OIDMapCode.GetAt("AssigningAuthority")]"" Set tAffinityDomain=tService.OIDMapCode.GetAt("AssigningAuthority")
		}
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomain)
		Set tPatientID=tResponse.MPIID_"^^^&"_tAffinityDomainOID_"&ISO"
		Set tFirstName=pGroupTest.AdditionalInfo.GetAt("FirstName")
		Set tLastName=pGroupTest.AdditionalInfo.GetAt("LastName")
		Do ..AddPatient(tPatientID,tFirstName_" "_tLastName)
		Set tPatient=tFirstName_" "_tLastName_" ("_tPatientID_")"
		Set label=##class(%ZEN.Component.label).%New()
		Set label.label=tPatient
		Do results.%AddChild(label)
	}
}

Method %OnAfterCreatePage() As %Status
{
	/// Standard list of gender display values
	Set tCombo=..%GetComponentById("cmbGender")
	Set tCombo.valueList=",male,female,other,unknown"
	Set tCombo.displayList=",male,female,other,unknown"
	
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
	set tReturnResource = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "ReturnResource"))
	set tInteraction = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Interaction"))

	set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
	set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
	set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
	set %session.Data("FHIR.Test", 0, "FHIRVersion") = tFHIRVersion
	set %session.Data("FHIR.Test", ..%ClassName(0), "ReturnResource") = tReturnResource
	set %session.Data("FHIR.Test", ..%ClassName(0), "Interaction") = tInteraction
	
	do ..%SetValueById("cmbServiceRegistry", tServiceName)
	do ..%SetValueById("txtOAuth2Client", tOAuth2Client)
	do ..%SetValueById("cmbFormat", tFormat)
	do ..%SetValueById("cmbVersion", tFHIRVersion)
	do ..%SetValueById("chkReturnResource", tReturnResource)
	do ..%SetValueById("rdoInteraction", tInteraction)
	
	Quit $$$OK
}

}

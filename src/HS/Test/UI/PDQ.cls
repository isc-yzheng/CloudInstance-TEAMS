Class HS.Test.UI.PDQ Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Search for Patient";

Parameter SERVICEREGISTRYENTRY = "PDQv3.Supplier";

Parameter SERVICEDEVICEFUNCTION = "PDQv3.Supplier|PDQv2.Supplier";

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
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="40"/>
<spacer height="15"/>
<html>Search by Patient Demographics or MRN/AA</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<hgroup>
<radioSet id="version" name="version" valueList="v2,v3" captionClass="lblNormal" onclick="zenPage.UpdateSvcParams();"/>
</hgroup>
<spacer height="5"/>
<text label="Domains:" name="Domains" id="txtDomains" size="30" hint="domainCode1,...domainCodeN" hintStyle="font-size:10px;font-weight:bold;" tabIndex="5" />
<text label="First Name:" name="FirstName" id="txtFirstName" size="30" tabIndex="6" />
<text label="Last Name:" name="LastName" id="txtLastName" size="30" tabIndex="10" />
<checkbox label="Exact Match:" id="chkExactMatch" title="Name search is exact match" tabIndex="13"/>
<text label="Street:" name="Street" id="txtStreet" size="80" tabIndex="15" />
<text label="City:" name="City" id="txtCity" size="20" tabIndex="20" />
<text label="State:" name="State" id="txtState" size="10" tabIndex="25" />
<text label="Zip:" name="Zip" id="txtZip" size="10" tabIndex="30" />
<combobox id="cmbGender" label="Gender:" size="22" tabIndex="35"/>
<dateText id="dtDOB" label="Date of Birth:" size="22" minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="60"/>
<dataCombo id="cmbAA" label="AssigningAuthority:" size="80" tabIndex="65" 
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateAssigningAuthorityRS"
	maxRows="10000">
</dataCombo>
<text label="MRN:" name="MRN" id="txtMRN" size="22" readOnly="0"/>
<checkbox label="Test w/NIST:" id="chkNIST" title="Check this check box only when you are testing PDQv3 Continuation with the NIST pre-Connectathon PDQ Supplier.  NIST wants the PDQv3 Continuation queryExtension to always be 'NIST_CONTINUATION'." tabIndex="70"/>
<spacer height="15"/>
<text label="Max Matches:" name="MaxMatches" id="txtMaxMatches" size="10" tabIndex="75" />
<text label="Continuation:" name="Continuation" id="txtContinuation" size="80" readOnly="1" controlClass="textReadOnly" tabIndex="80" />
<text label="Original Query ID:" name="OriginalQueryID" id="txtOriginalID" size="80" readOnly="1" controlClass="textReadOnly" tabIndex="85" />
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreatePIXPDQServiceRegistryRS"
	maxRows="10000">
	<parameter id="pType" value="SOAP"/>
</dataCombo><hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1);" />
<spacer width="5" />
<button id="btnContinue" caption=" Submit Continuation " onclick="zenPage.Start('btnContinue');zenPage.Continue();" />
<spacer width="5" />
<button id="btnCancel" caption=" Cancel Continuation " onclick="zenPage.Start('btnCancel');zenPage.Cancel();" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.ClearDemographics();" />
<spacer width="5" />
<button id="btnConnectMultiplev2" caption=" CAT Test " onclick="zenPage.ConnectMultiplePrompt();" />
<spacer width="5" />
</hgroup>
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
	this.getComponentById('txtDomains').setValue("");
	this.getComponentById('txtFirstName').setValue("");
	this.getComponentById('txtLastName').setValue("");
	this.getComponentById('txtStreet').setValue("");
	this.getComponentById('txtCity').setValue("");
	this.getComponentById('txtState').setValue("");
	this.getComponentById('txtZip').setValue("");
	this.getComponentById('cmbGender').setValue("");
	this.getComponentById('dtDOB').setValue("");
	this.getComponentById('cmbAA').setValue("");
	this.getComponentById('txtMRN').setValue("");
	this.getComponentById('txtMaxMatches').setValue("");
	this.getComponentById('txtContinuation').setValue("");
	this.getComponentById('txtOriginalID').setValue("");
	this.getComponentById('chkExactMatch').setValue("");
	this.getComponentById('chkNIST').setValue("");
	this.getComponentById('cmbServiceRegistry').setValue("");
	zenPage.ClearResultsPane();
}

ClientMethod GoPnR() [ Language = javascript ]
{
	var queryParam = "?PATIENTMRN="+patientId.replace("^^^&","&PATIENTAA=");
	window.location="HS.Test.UI.XDSbPnR.cls"+queryParam;
}

ClientMethod GoRSQ() [ Language = javascript ]
{
	//var patientId = zen('txtPatientID').getValue().replace("&ISO", "");
	
	var queryParam = "?PATIENTMRN="+patientId.replace("^^^&","&PATIENTAA=");
	window.location="HS.Test.UI.XDSbRSQ.cls"+queryParam;
}

Method Send() As %String [ ZenMethod ]
{
	try {
		Set tSessionID=""
		Do ..ClearRecentPatients()
		set tRequest=##class(HS.Message.PatientSearchRequest).%New()
		Set tExactMatch=%page.%GetValueById("chkExactMatch")
		Set tNIST=%page.%GetValueById("chkNIST")
		do tRequest.AdditionalInfo.SetAt(tExactMatch,"ExactMatch")
		do tRequest.AdditionalInfo.SetAt(tNIST,"TestNIST")
		if %page.%GetValueById("txtDomains")'="" {
			set tDomains = %page.%GetValueById("txtDomains")
			for i = 1:1:$Length(tDomains,",") {
				set tDomainCode = $Piece(tDomains,",",i)
				set tDomainCode = $ZStrip(tDomainCode,"<>"," ")
				do tRequest.AdditionalInfo.SetAt("","scopingOrganization_"_tDomainCode)
				do tRequest.AdditionalInfo.SetAt("","ScopingOrganizations")
			}
		}
		Set tMRN=%page.%GetValueById("txtMRN")
		If tMRN'="" {
			set tRequest.MRN=%page.%GetValueById("txtMRN")
			set tRequest.AssigningAuthority=%page.%GetValueById("cmbAA")
			set tRequest.Facility=%page.%GetValueById("cmbAA")
			Set tAA = %page.%GetComponentById("cmbAA")
			Set tAADisplay = tAA.%GetDisplayValue(tAA.value)
		} Else {
			set tRequest.LastName=%page.%GetValueById("txtLastName")
			set tRequest.FirstName=%page.%GetValueById("txtFirstName")
			set tRequest.Street=%page.%GetValueById("txtStreet")
			set tRequest.City=%page.%GetValueById("txtCity")
			set tRequest.State=%page.%GetValueById("txtState")
			set tRequest.Zip=%page.%GetValueById("txtZip")
			Set tDOB=%page.%GetValueById("dtDOB")
			set tRequest.DOB=$S(tDOB]"":$ZDH(tDOB,3,,,,,,,-1),1:"")
			set tRequest.Sex=%page.%GetValueById("cmbGender")
		}
		If +%page.%GetValueById("txtMaxMatches")>0 Set tRequest.MaxMatches = %page.%GetValueById("txtMaxMatches")
		
		Set tServiceRegistry=%page.%GetValueById("cmbServiceRegistry")
		
		Set tVersion=%page.%GetValueById("version")
		Set tHost=$S(tVersion="v3":"HS.IHE.PDQv3.Consumer.Operations",1:"HS.IHE.PDQv2.Consumer.Operations")
		
		Set %session.Data("IHE.Test",..%ClassName(0),"Domains")=$g(tDomains)
		Set %session.Data("IHE.Test",..%ClassName(0),"ExactMatch")=tExactMatch
		Set %session.Data("IHE.Test",..%ClassName(0),"NIST")=tNIST
		Set %session.Data("IHE.Test",..%ClassName(0),"MaxMatches")=tRequest.MaxMatches
		Set %session.Data("IHE.Test",..%ClassName(0),"Version")=tVersion
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry")=tServiceRegistry
		
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		If tHost]"" Do tRequest.AdditionalInfo.SetAt(tHost,"Host"),tGroup.AdditionalInfo.SetAt(tHost,"Host")
		
		If tMRN'="" {
			Set %session.Data("IHE.Test",..%ClassName(0),"Facility")=tRequest.Facility
			Set %session.Data("IHE.Test",..%ClassName(0),"AA")=tRequest.AssigningAuthority
			Set %session.Data("IHE.Test",..%ClassName(0),"AA Display")=$g(tAADisplay)
			Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=tRequest.MRN
			Do tGroup.AdditionalInfo.SetAt(tRequest.Facility,"Facility")
			Do tGroup.AdditionalInfo.SetAt(tRequest.AssigningAuthority,"AssigningAuthority")
			Do tGroup.AdditionalInfo.SetAt(tAADisplay,"AA Display")
			Do tGroup.AdditionalInfo.SetAt(tRequest.MRN,"MRN")
			
			// Clear out other demographic fields
			Set %session.Data("IHE.Test",..%ClassName(0),"LastName")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"FirstName")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"StreetLine")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"City")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"State")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"PostalCode")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"DOB")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"Sex")=""
			Do tGroup.AdditionalInfo.SetAt("","LastName")
			Do tGroup.AdditionalInfo.SetAt("","FirstName")
			Do tGroup.AdditionalInfo.SetAt("","Street")
			Do tGroup.AdditionalInfo.SetAt("","City")
			Do tGroup.AdditionalInfo.SetAt("","State")
			Do tGroup.AdditionalInfo.SetAt("","Zip")
			Do tGroup.AdditionalInfo.SetAt("","DOB")
			Do tGroup.AdditionalInfo.SetAt("","Sex")
		}
		Else {
			Set %session.Data("IHE.Test",..%ClassName(0),"LastName")=tRequest.LastName
			Set %session.Data("IHE.Test",..%ClassName(0),"FirstName")=tRequest.FirstName
			Set %session.Data("IHE.Test",..%ClassName(0),"StreetLine")=tRequest.Street
			Set %session.Data("IHE.Test",..%ClassName(0),"City")=tRequest.City
			Set %session.Data("IHE.Test",..%ClassName(0),"State")=tRequest.State
			Set %session.Data("IHE.Test",..%ClassName(0),"PostalCode")=tRequest.Zip
			Set %session.Data("IHE.Test",..%ClassName(0),"DOB")=tDOB
			Set %session.Data("IHE.Test",..%ClassName(0),"Sex")=tRequest.Sex
			Do tGroup.AdditionalInfo.SetAt(tRequest.LastName,"LastName")
			Do tGroup.AdditionalInfo.SetAt(tRequest.FirstName,"FirstName")
			Do tGroup.AdditionalInfo.SetAt(tRequest.Street,"Street")
			Do tGroup.AdditionalInfo.SetAt(tRequest.City,"City")
			Do tGroup.AdditionalInfo.SetAt(tRequest.State,"State")
			Do tGroup.AdditionalInfo.SetAt(tRequest.Zip,"Zip")
			Do:tDOB]"" tGroup.AdditionalInfo.SetAt(tDOB,"DOB")
			Do tGroup.AdditionalInfo.SetAt(tRequest.Sex,"Sex")
			
			// Clear out MRN/AA fields
			Set %session.Data("IHE.Test",..%ClassName(0),"Facility")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"AA")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"AA Display")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=""
			Do tGroup.AdditionalInfo.SetAt("","Facility")
			Do tGroup.AdditionalInfo.SetAt("","AssigningAuthority")
			Do tGroup.AdditionalInfo.SetAt("","AA Display")
			Do tGroup.AdditionalInfo.SetAt("","MRN")
		}
		Do tGroup.AdditionalInfo.SetAt(tVersion,"Version")
		Do tGroup.AdditionalInfo.SetAt(tServiceRegistry,"ServiceRegistry")
		If $g(tDomains)]"" Do tGroup.AdditionalInfo.SetAt(tDomains,"Domains")
		Do tGroup.AdditionalInfo.SetAt(tExactMatch,"ExactMatch")
		Do tGroup.AdditionalInfo.SetAt(tNIST,"NIST")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MaxMatches,"MaxMatches")
		
		
		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
		} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID = ""
	}
	Quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $isObject(tResponse) && $$$ISOK(pTest.Status) {
		Set results=%page.%GetComponentById("paneResults")
		Set tService = ..GetServiceRegistryEntry()
		Set tAffinityDomain = $$$AffinityDomain
		If $isObject(tService) {
			If tService.OIDMapCode.GetAt("AssigningAuthority")]"" Set tAffinityDomain=tService.OIDMapCode.GetAt("AssigningAuthority")
		}
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomain)
		If tResponse.Results.Count() {
			For tIdx=1:1:tResponse.Results.Count() {
				Set tItem = tResponse.Results.GetAt(tIdx)
				Set tName=tResponse.Results.GetAt(tIdx).FirstName_" "_tResponse.Results.GetAt(tIdx).LastName
				Set tIdentifierList=tItem.Identifiers
				Set tIdentifiers=""
				For tIdx2=1:1:tIdentifierList.Count() {
					Set tRoot = ##class(HS.Data.OIDMap).GetOIDForCode(tIdentifierList.GetAt(tIdx2).Root)
					Set tExtension = tIdentifierList.GetAt(tIdx2).Extension
					If tRoot=tAffinityDomainOID {
						// Only setup tPatientId for the ID that matches the Affinity Domain, and skip writing
						// it to the identifier list to avoid duplication.
						// This will NOT be present for MRN/AA searches, as results are filtered to just the 
						// AA searched for initially.
						Set tPatientId = tExtension_"^^^&"_tRoot_"&ISO"
						Continue
					}
					Set tIdentifier = tExtension_"^^^&"_tRoot_"&ISO"
					Set tIdentifiers=tIdentifiers_","_tIdentifier
				}
				If tIdx=1 {
					Do:$G(tPatientId) %page.%SetValueById("txtPatientID", tPatientId)
					Do ..AddRecentPatients(tResponse,,tAffinityDomainOID)
				}
				Set tIdentifiers=$e(tIdentifiers,2,*)
				
				Do:$G(tPatientId) ..AddRecentPatientMRNAA(tPatientId,tIdentifiers)
				
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label=tName
				// If we have tPatientId (not an MRN/AA Search), append it to the patient name.
				Set:$G(tPatientId) label.label=label.label_" ("_tPatientId_")"
				Set label.value=tIdentifiers
				Do ..LogMessage() // Just write a timestamp
				Do results.%AddChild(label)
			}
		} Else {
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label="No Patients Found"
			Do results.%AddChild(label)
		}
		Do %page.%SetValueById("txtContinuation",tResponse.AdditionalInfo.GetAt("ContinuationPointer"))
		Do %page.%SetValueById("txtOriginalID",tResponse.AdditionalInfo.GetAt("OriginalQueryID"))
	}
}

Method Continue() [ ZenMethod ]
{
	try {
		if %page.%GetValueById("txtContinuation")="" {
			set results=%page.%GetComponentById("paneResults")
			Do results.%RemoveChildren()
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label="No continuation token available"
			Do results.%AddChild(label)
			Quit
		}
		set tRequest=##class(HS.Message.PatientSearchRequest).%New()
		if %page.%GetValueById("txtDomains")'="" {
			set tDomains = %page.%GetValueById("txtDomains")
			for i = 1:1:$Length(tDomains,",") {
				set tDomainCode = $Piece(tDomains,",",i)
				set tDomainCode = $ZStrip(tDomainCode,"<>"," ")
				do tRequest.AdditionalInfo.SetAt("","scopingOrganization_"_tDomainCode)
				do tRequest.AdditionalInfo.SetAt("","ScopingOrganizations")
			}
		}
		set tRequest.LastName=%page.%GetValueById("txtLastName")
		set tRequest.FirstName=%page.%GetValueById("txtFirstName")
		set tRequest.Street=%page.%GetValueById("txtStreet")
		set tRequest.City=%page.%GetValueById("txtCity")
		set tRequest.State=%page.%GetValueById("txtState")
		set tRequest.Zip=%page.%GetValueById("txtZip")
		Set tDOB=%page.%GetValueById("dtDOB")
		set tRequest.DOB=$S(tDOB]"":$ZDH(tDOB,3,,,,,,,-1),1:"")
		set tRequest.Sex=%page.%GetValueById("cmbGender")
		Do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("txtContinuation"),"ContinuationPointer")
		Do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("txtOriginalID"),"OriginalQueryID")
		do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("chkExactMatch"),"ExactMatch")
		do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("chkNIST"),"TestNIST")
		do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("cmbServiceRegistry"),"ServiceName")
		If +%page.%GetValueById("txtMaxMatches")>0 Set tRequest.MaxMatches = %page.%GetValueById("txtMaxMatches")
		Set tHost=$S(%page.%GetValueByName("version")="v3":"HS.IHE.PDQv3.Consumer.Operations",1:"HS.IHE.PDQv2.Consumer.Operations")
		Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
		
		#dim tResponse As HS.Message.PatientSearchResponse
		#dim results as %ZEN.Component.pane

		Do ..ClearResultsPane()
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,tGroup)
		Do ..DisplayTestResult(tTest,tGroup) quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response
		Set tService = tTest.Service
		Set tAffinityDomain = $$$AffinityDomainOID
		If $isObject(tService) {
			Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tService.OIDMapCode.GetAt("AssigningAuthority"))
			Set:tAffinityDomainOID]"" tAffinityDomain=tAffinityDomainOID
		}
		
		If $IsObject(tResponse) {
			/*
			If tResponse.Results.Count() {
				Set tPatientId=tResponse.Results.GetAt(1).MPIID_"^^^&"_tAffinityDomain_"&ISO"
				Do %page.%SetValueById("txtPatientID", tPatientId)
				Set %session.Data("IHE.Test","PatientID")=tPatientId
				Do ..AddRecentPatients(tResponse,,tAffinityDomain)
				For tIdx=1:1:tResponse.Results.Count() {
					Set tItem = tResponse.Results.GetAt(tIdx)
					Do ..LogMessage(tResponse.Results.GetAt(tIdx).FirstName_" "_tResponse.Results.GetAt(tIdx).LastName_" ("_tResponse.Results.GetAt(tIdx).MPIID_"^^^&"_$$$HomeCommunityOID_"&ISO"_")",tGroup)
				}
			} Else {
				Do ..LogMessage("No patients found",tGroup)
			}
			*/
			Do %page.%SetValueById("txtContinuation",tResponse.AdditionalInfo.GetAt("ContinuationPointer"))
		}
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(tGroup))
	}
	&js<zen('btnContinue').setProperty('disabled',false);>
}

Method Cancel() [ ZenMethod ]
{
	try {
		if %page.%GetValueById("txtContinuation")="" {
			Do ..ClearResultsPane()
			Do ..LogMessage("No continuation token available")
			Quit
		}
		set tRequest=##class(HS.Message.PatientSearchRequest).%New()
		if %page.%GetValueById("txtDomains")'="" {
			set tDomains = %page.%GetValueById("txtDomains")
			for i = 1:1:$Length(tDomains,",") {
				set tDomainCode = $Piece(tDomains,",",i)
				set tDomainCode = $ZStrip(tDomainCode,"<>"," ")
				do tRequest.AdditionalInfo.SetAt("","scopingOrganization_"_tDomainCode)
				do tRequest.AdditionalInfo.SetAt("","ScopingOrganizations")
			}
		}
		set tRequest.LastName=%page.%GetValueById("txtLastName")
		set tRequest.FirstName=%page.%GetValueById("txtFirstName")
		set tRequest.Street=%page.%GetValueById("txtStreet")
		set tRequest.City=%page.%GetValueById("txtCity")
		set tRequest.State=%page.%GetValueById("txtState")
		set tRequest.Zip=%page.%GetValueById("txtZip")
		Set tDOB=%page.%GetValueById("dtDOB")
		set tRequest.DOB=$S(tDOB]"":$ZDH(tDOB,3,,,,,,,-1),1:"")
		set tRequest.Sex=%page.%GetValueById("cmbGender")
		If %page.%GetValueById("version")="v2" {
			Do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("txtContinuation"),"CancelQuery")
		} Else {
			Do tRequest.AdditionalInfo.SetAt(1,"CancelQuery")
		}
		Do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("txtOriginalID"),"OriginalQueryID")
		do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("chkNIST"),"TestNIST")
		do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("cmbServiceRegistry"),"ServiceName")
		Set tHost=$S(%page.%GetValueByName("version")="v3":"HS.IHE.PDQv3.Consumer.Operations",1:"HS.IHE.PDQv2.Consumer.Operations")
		Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
		
		#dim tResponse As HS.Message.PatientSearchResponse
		#dim results as %ZEN.Component.pane
		Do ..ClearResultsPane()
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,tGroup)
		//Do ..DisplayTestResult(tTest,tGroup) If $$$ISERR(tSC) Do ..LogMessage($ZCVT($system.Status.GetErrorText(tSC),"O","HTML"),tGroup) Quit
		Set tResponse=tTest.Response
		
		If $IsObject(tResponse) {
			Do ..LogMessage("Success",tGroup)
		} Else {
			Do ..LogMessage($ZCVT($system.Status.GetErrorText(tSC),"O","HTML"),tGroup)
		}
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(tGroup))
	}
	&js<zen('btnCancel').setProperty('disabled',false);>
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	// Load dropdowns from parameters
	Set tCombo=..%GetComponentById("cmbGender")
	Set tCombo.valueList=",M,F,O,U"
	Set tCombo.displayList=",Male,Female,Other,Unknown"

	Set tLastName=$g(%session.Data("IHE.Test",..%ClassName(0),"LastName"))
	Set tFirstName=$g(%session.Data("IHE.Test",..%ClassName(0),"FirstName"))
	Set tStreet=$g(%session.Data("IHE.Test",..%ClassName(0),"Street"))
	Set tCity=$g(%session.Data("IHE.Test",..%ClassName(0),"City"))
	Set tState=$g(%session.Data("IHE.Test",..%ClassName(0),"State"))
	Set tZip=$g(%session.Data("IHE.Test",..%ClassName(0),"Zip"))
	Set tDOB=$g(%session.Data("IHE.Test",..%ClassName(0),"DOB"))
	Set tSex=$g(%session.Data("IHE.Test",..%ClassName(0),"Sex"))
	Set tFacility=$g(%session.Data("IHE.Test",..%ClassName(0),"Facility"))
	Set tAA=$g(%session.Data("IHE.Test",..%ClassName(0),"AA"))
	Set tAADisplay=$g(%session.Data("IHE.Test",..%ClassName(0),"AA Display"))
	Set tMRN=$g(%session.Data("IHE.Test",..%ClassName(0),"MRN"))
	Set tDomains=$g(%session.Data("IHE.Test",..%ClassName(0),"Domains"))
	Set tExactMatch=$g(%session.Data("IHE.Test",..%ClassName(0),"ExactMatch"))
	Set tNIST=$g(%session.Data("IHE.Test",..%ClassName(0),"NIST"))
	Set tMaxMatches=$g(%session.Data("IHE.Test",..%ClassName(0),"MaxMatches"))
	Set tVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"Version"))
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY

	Do ..SetLogging()
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tLastName=tGroup.AdditionalInfo.GetAt("LastName")
		Set tFirstName=tGroup.AdditionalInfo.GetAt("FirstName")
		Set tStreetLine=tGroup.AdditionalInfo.GetAt("Street")
		Set tCity=tGroup.AdditionalInfo.GetAt("City")
		Set tState=tGroup.AdditionalInfo.GetAt("State")
		Set tZip=tGroup.AdditionalInfo.GetAt("Zip")
		Set tDOB=tGroup.AdditionalInfo.GetAt("DOB")
		Set tSex=tGroup.AdditionalInfo.GetAt("Sex")
		Set tFacility=tGroup.AdditionalInfo.GetAt("Facility")
		Set tAA=tGroup.AdditionalInfo.GetAt("AssigningAuthority")
		Set tAADisplay=tGroup.AdditionalInfo.GetAt("AADisplay")
		Set tMRN=tGroup.AdditionalInfo.GetAt("MRN")
		Set tDomains=tGroup.AdditionalInfo.GetAt("Domains")
		Set tExactMatch=tGroup.AdditionalInfo.GetAt("ExactMatch")
		Set tNIST=tGroup.AdditionalInfo.GetAt("NIST")
		Set tMaxMatches=tGroup.AdditionalInfo.GetAt("MaxMatches")
		Set tVersion=tGroup.AdditionalInfo.GetAt("Version")
		Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
		
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}

	Set:$g(tVersion)="" tVersion="v3"
	Do ..%SetValueById("version",tVersion)
	
	Do ..%SetValueById("txtLastName",tLastName)	
	Do ..%SetValueById("txtFirstName",tFirstName)
	Do ..%SetValueById("txtStreet",tStreet)	
	Do ..%SetValueById("txtCity",tCity)
	Do ..%SetValueById("txtState",tState)
	Do ..%SetValueById("txtZip",tZip)
	Do ..%SetValueById("cmbGender",tSex)
	Do ..%SetValueById("dtDOB",tDOB)	
	Do ..%SetValueById("cmbAA",tAA)
	Do ..%SetValueById("txtMRN",tMRN)	
	Do ..%SetValueById("version",tVersion)	
	Do ..%SetValueById("chkExactMatch",tExactMatch)	
	Do ..%SetValueById("chkNIST",tNIST)	
	Do ..%SetValueById("txtMaxMatches",tMaxMatches)
	Do ..%SetValueById("cmbServiceRegistry",tServiceRegistry)
	Quit $$$OK
}

Method UpdateServiceEntry() [ ZenMethod ]
{
	try {
		Set tSC=$$$OK
		Set tEntry=$G(%session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1)))
		#dim tServiceRegistry as %ZEN.Component.combobox = ..%GetComponentById("cmbServiceRegistry")
		#dim tVersion as %ZEN.Component.radioSet = ..%GetComponentById("version")
		Do tServiceRegistry.options.Clear()
		
		If tVersion.value="v3" {
			Set tType="SOAP",pDefaultEntry="PDQv3.Supplier"
			If tEntry="PDQv2.Supplier" Set tEntry=""
		} Else {
			Set tType="TCP",pDefaultEntry="PDQv2.Supplier"
			If tEntry="PDQv3.Supplier" Set tEntry=""
		}
		Set tSelected=""
		Set tResult = ##class(%SQL.Statement).%ExecDirect("","SELECT ID,Name FROM HS_Registry_Service.Abstract WHERE type=? and not(Name LIKE 'SYNC.%' or Name LIKE 'IHE.Test.%') ORDER BY Name",tType)
		While tResult.%Next() {
			If 'tSelected && (tResult.ID=tEntry) Set tSelected=tResult.Name
			If 'tSelected && (tResult.Name=pDefaultEntry) Set tSelected=tResult.Name
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Set tOption.text = tResult.Name
			Set tOption.value = tResult.Name
			Do tServiceRegistry.options.Insert(tOption)
			Do ..%AddComponent(tOption)

		}

		Set tServiceRegistry.value = tSelected
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method AddServiceEntries(pDefaultEntry = "") [ ZenMethod ]
{
	try {
		Set tSC=$$$OK
		Set tEntry=$G(%session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1)))
		#dim tServiceRegistry as %ZEN.Component.dataCombo = ..%GetComponentById("cmbServiceRegistry")
		#dim tVersion as %ZEN.Component.radioSet = ..%GetComponentById("version")
		Do tServiceRegistry.options.Clear()
		If tVersion.value="v3" {
			Set tType="SOAP",pDefaultEntry="PDQv3.Supplier"
			If tEntry="PDQv2.Supplier" Set tEntry=""
		} Else {
			Set tType="TCP",pDefaultEntry="PDQv2.Supplier"
			If tEntry="PDQv3.Supplier" Set tEntry=""
		}

		Set tSelected=""
		Set tResult = ##class(%SQL.Statement).%ExecDirect("","SELECT ID,Name FROM HS_Registry_Service.Abstract WHERE type=? and not(Name LIKE 'SYNC.%' or Name LIKE 'IHE.Test.%') ORDER BY Name",tType)
		While tResult.%Next() {
			If 'tSelected && (tResult.ID=tEntry) Set tSelected=tResult.ID
			If 'tSelected && (tResult.Name=pDefaultEntry) Set tSelected=tResult.ID
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Set tOption.text = tResult.Name
			Set tOption.value = tResult.ID
			Do tServiceRegistry.options.Insert(tOption)
			Do ..%AddComponent(tOption)

		}
		Set tServiceRegistry.value = tSelected
		
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method ConnectMultiple(pDomainName As %String) [ ZenMethod ]
{
	Do ..ClearResultsPane()
	Set tVersion=%page.%GetValueById("version")
	Set tHost=$S(tVersion="v3":"HS.IHE.PDQv3.Consumer.Operations",1:"HS.IHE.PDQv2.Consumer.Operations")
	Set tServiceRegistry=%page.%GetValueById("cmbServiceRegistry")
	
	// Search for full name
	Kill objSearch
	Set objSearch = ##class(HS.Message.PatientSearchRequest).%New()
	Set objSearch.LastName = "MOORE"
	Set objSearch.FirstName = "CHIP"
	Do objSearch.AdditionalInfo.SetAt(0,"ExactMatch")
	Do objSearch.AdditionalInfo.SetAt(tHost,"Host")
	Do objSearch.AdditionalInfo.SetAt(tServiceRegistry,"ServiceRegistry")
	Do ..ConnectExecute(.tGroup,objSearch,"IDX 20 - Searching by full name "_objSearch.FirstName_" "_objSearch.LastName)
	Do ..LogFinished(tGroup)
	
	// Search for last name partial
	Kill objSearch
	Set objSearch = ##class(HS.Message.PatientSearchRequest).%New()
	Set objSearch.LastName = "MO"
	Do objSearch.AdditionalInfo.SetAt(0,"ExactMatch")
	Do objSearch.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,objSearch,"IDX 70 - Searching by partial lastname "_objSearch.LastName)
	Do ..LogFinished(tGroup)
		
	// Search for MRN
	Kill objSearch
	Set objSearch = ##class(HS.Message.PatientSearchRequest).%New()
	Set objSearch.MRN = pDomainName_"-993"
	Set objSearch.AssigningAuthority = pDomainName
	Do objSearch.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,objSearch,"IDX 80 - Searching by MRN "_objSearch.MRN)
	Do ..LogFinished(tGroup)
	
	// Search by DOB
	Kill objSearch
	Set objSearch = ##class(HS.Message.PatientSearchRequest).%New()
	// YYYY-MM-DD
	Set tDOB = "1978-09-19" If tDOB'="" Set objSearch.DOB=objSearch.DOBDisplayToLogical(tDOB)
	Do objSearch.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,objSearch,"IDX 90 - Searching by DOB "_tDOB)
	Do ..LogFinished(tGroup)
	
	// Search for LastName non-exact, and Sex
	Kill objSearch
	Set objSearch = ##class(HS.Message.PatientSearchRequest).%New()
	Set objSearch.LastName = "MO"
	Do objSearch.AdditionalInfo.SetAt(0,"ExactMatch")
	Set objSearch.Sex = "F"
	Do objSearch.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,objSearch,"IDX 100 - Searching by last name non-exact "_objSearch.LastName_" and Sex "_objSearch.Sex)
	Do ..LogFinished(tGroup)
	
	// Search for LastName exact and DOB
	Kill objSearch
	Set objSearch = ##class(HS.Message.PatientSearchRequest).%New()
	Set objSearch.LastName = "MOORE"
	Do objSearch.AdditionalInfo.SetAt(1,"ExactMatch")
	// YYYY-MM-DD
	Set tDOB = "1951-07-06" If tDOB'="" Set objSearch.DOB=objSearch.DOBDisplayToLogical(tDOB)
	Do objSearch.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,objSearch,"IDX 120 - Searching by last name exact "_objSearch.LastName_" and DOB "_tDOB)
	Do ..LogFinished(tGroup)
	
	// Search for LastName exact and Street
	Kill objSearch
	Set objSearch = ##class(HS.Message.PatientSearchRequest).%New()
	Set objSearch.LastName = "MOORE"
	Do objSearch.AdditionalInfo.SetAt(1,"ExactMatch")
	Set objSearch.Street = "10 PINETREE"
	Do objSearch.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,objSearch,"IDX 140 - Searching by last name exact "_objSearch.LastName_" and Street "_objSearch.Street)
	Do ..LogFinished(tGroup)
	
	Quit
}

ClientMethod ConnectMultiplePrompt() [ Language = javascript ]
{
	var domainName = window.prompt("Please enter the domain (IHEGREEN, IHERED, IHEBLUE)");
	//var vendorLastName = window.prompt("Please enter Gazelle system name of PDQ Supplier","");
	
	switch(domainName) {
        case "":
	    return;
	    break;
	 case null:
	    return;
	    break;
	 default:
	    zenPage.ConnectMultiple(domainName);
	    break;
    }
}

Method ConnectExecute(pGroup = "", pRequest, pMsg)
{
	try {
		Set:'$IsObject(pGroup) pGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=pGroup.NewTest(pRequest,%page.%GetValueById("chkLogging"),"",pMsg)
		Set tSC = ..Execute(tTest,pGroup)
		Do ..DisplayTestResult(tTest,pGroup) quit:$$$ISERR(tSC)
		/*
		Set tResponse=tTest.Response
		If $isObject(tResponse) {
			Set results=%page.%GetComponentById("paneResults")
			Set tService = tTest.Service
			Set tAffinityDomain = $$$AffinityDomain
			If $isObject(tService) {
				Set tAffinityDomain=tService.OIDMapCode.GetAt("AssigningAuthority")
			}
			Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomain)

			If tResponse.Results.Count() {
				Set tMPIID = tResponse.Results.GetAt(1).MPIID
				If tMPIID="" && (pAA=tAffinityDomain) Set tMPIID=pMRN
				Set tPatientId=tMPIID_"^^^&"_tAffinityDomainOID_"&ISO"
				
				For tIdx=1:1:tResponse.Results.Count() {
					Set tItem = tResponse.Results.GetAt(tIdx)
					Do ..LogMessage(tResponse.Results.GetAt(tIdx).FirstName_" "_tResponse.Results.GetAt(tIdx).LastName_" ("_tResponse.Results.GetAt(tIdx).MPIID_"^^^&"_tAffinityDomainOID_"&ISO"_")",pGroup)
				}
			} Else {
				Do ..LogMessage("No patients found",pGroup)
			}
		}
		*/
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"),$g(pGroup))
	}
	Do pGroup.%Save()
}

}

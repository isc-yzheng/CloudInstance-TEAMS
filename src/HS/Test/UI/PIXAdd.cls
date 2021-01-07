Class HS.Test.UI.PIXAdd Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Add New Patient";

Parameter SERVICEREGISTRYENTRY = "PIXv3.Manager";

Parameter SERVICEDEVICEFUNCTION = "PIXv3.Manager|PIXv2.Manager";

/// Organization name will be used in the automated tests to get the Facility and used for the Patient's Last Name
Property ORGANIZATION As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\TestUI\PIX\Organization","OTHER_INTERSYS_HEALTHSHARE")} ];

/// Organization name will be used in the automated tests to get the AssigningAuthority and used for the Patient's Last Name
Property ASSIGNINGAUTHORITY As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\TestUI\PIX\AssigningAuthority","INOT")} ];

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
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="40"/>
<html>Please enter patient demographics</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<spacer height="5"/>
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
<hgroup>
<radioSet id="version" valueList="v2,v3" captionClass="lblNormal" onclick="zenPage.UpdateSvcParams();"/>
</hgroup>
<hgroup>
<radioSet id="addOrUpdate" valueList="Update,Add" captionClass="lblNormal"/>
</hgroup>
<text label="Prefix:" id="txtPrefix" size="15" tabIndex="4" />
<text label="First Name:" name="FirstName" id="txtFirstName" size="30" tabIndex="5" />
<text label="Middle Name:" name="MiddleName" id="txtMiddleName" size="30" tabIndex="6" />
<text label="Last Name:" name="LastName" id="txtLastName" size="30" tabIndex="10" />
<text label="Suffix:" id="txtSuffix" size="15" tabIndex="11" />
<text label="Street:" name="Street" id="txtStreet" size="80" tabIndex="15" />
<text label="City:" name="City" id="txtCity" size="20" tabIndex="20" />
<text label="State:" name="State" id="txtState" size="10" tabIndex="25" />
<text label="Zip:" name="Zip" id="txtZip" size="10" tabIndex="30" />
<text label="Home Phone:" name="HomePhone" id="txtHomePhone" size="20" hint="(XXX-XXX-XXXX)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="31" />
<text label="Business Phone:" name="BusinessPhone" id="txtBusinessPhone" size="20" hint="(XXX-XXX-XXXX)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="32" />
<combobox id="cmbGender" label="Gender:" size="22" tabIndex="35"/>
<dateText id="dtDOB" label="Date of Birth:" size="22" minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="60"/>
<text label="Mothers Maiden Surname:" name="MothersMaidenSurname" id="txtMaidenSurname" size="20" tabIndex="63" />
<dataCombo id="cmbAA" label="AssigningAuthority:" size="80" tabIndex="65" onchange="zenPage.GetNextMRN()"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateAssigningAuthorityRS"
	maxRows="10000">
</dataCombo>
<text label="AssigningAuthority OID:" name="aaOID" id="txtAAOID" size="80" readOnly="1" controlClass="textReadOnly" />
<dataCombo id="cmbFacility" label="Facility:" size="80" tabIndex="81"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreateFacilityRS"
	maxRows="10000">
</dataCombo>
<text label="MRN:" name="MRN" id="txtMRN" size="22" readOnly="0" />
<text label="MPIID:" name="MPIID" id="txtMPIID" size="22" readOnly="0" hidden="1" />
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreatePIXPDQServiceRegistryRS"
	maxRows="10000">
	<parameter id="pType" value="SOAP"/>
</dataCombo>
<spacer height="15"/>

<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1);" />
<spacer width="5" />
<button id="btnClearDemo" caption=" Clear " onclick="zenPage.ClearDemographics();" />
<spacer width="5" />
<button id="btnConnect1" caption=" CAT Test v2 " onclick="zenPage.Connectv2();" />
<spacer width="5" />
<button id="btnConnect2" caption=" CAT Test v3 " onclick="zenPage.Connectv3();" />
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
	var fname = this.getComponentById('txtFirstName');
	var mname = this.getComponentById('txtMiddleName');
	var lname = this.getComponentById('txtLastName');
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
	var svc = this.getComponentById('cmbServiceRegistry');
	
	fname.setValue("");
	mname.setValue("");
	lname.setValue("");
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
	svc.setValue("");
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
		Set tSessionID=""
		Do ..ClearRecentPatients()
		Set pMRN = %page.%GetValueById("txtMRN")
		Set pAA = %page.%GetValueById("cmbAA")
		If pMRN="" || (pAA="") &js< alert('MRN and Assigning Authority are required');> Quit
		
		Set tDOB=%page.%GetValueById("dtDOB")
		// If tDOB is non-null, convert the date.  This returns -1 for a bad date. 
		Set tDOB=$S(tDOB]"":$ZDH(tDOB,3,,,,,,,-1),1:"")
		If tDOB="-1" &js<alert('Date of Birth is missing or invalid');> Quit
		
		//collect patient demographics from tester input
		//Compile AddUpdateHubRequest using patient demographics
		set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
		Set tRequest.Prefix=%page.%GetValueById("txtPrefix")
		set tRequest.LastName=%page.%GetValueById("txtLastName")
		set tRequest.FirstName=%page.%GetValueById("txtFirstName")
		set tRequest.MiddleName=%page.%GetValueById("txtMiddleName")
		Set tRequest.Suffix=%page.%GetValueById("txtSuffix")
		
		set tAddress=##class(HS.Types.Address).%New()
		set tAddress.StreetLine=%page.%GetValueById("txtStreet")
		set tAddress.City=%page.%GetValueById("txtCity")
		set tAddress.State=%page.%GetValueById("txtState")
		set tAddress.PostalCode =%page.%GetValueById("txtZip")
		set tAddress.Use="H" //Home
		do tRequest.Addresses.Insert(tAddress)
		
		Set tHomePh=%page.%GetValueById("txtHomePhone")
		If tHomePh'="" {
			set tHomePhone = ##class(HS.Types.Telecom).%New()
			set tHomePhone.Use = "H"
			set tHomePhone.PhoneNumberFull = %page.%GetValueById("txtHomePhone")
			do tRequest.Telecoms.Insert(tHomePhone)
		}
		
		Set tBusPh=%page.%GetValueById("txtBusinessPhone")
		If tBusPh'="" {
			set tBusPhone = ##class(HS.Types.Telecom).%New()
			set tBusPhone.Use = "WP"
			set tBusPhone.PhoneNumberFull = %page.%GetValueById("txtBusinessPhone")
			do tRequest.Telecoms.Insert(tBusPhone)
		}
		
		set tRequest.DOB=tDOB
		set tRequest.Sex=%page.%GetValueById("cmbGender")
		set tRequest.Facility=%page.%GetValueById("cmbFacility")
		set tRequest.AssigningAuthority=%page.%GetValueById("cmbAA")
		set tAAOID = %page.%GetValueById("txtAAOID")
		set tRequest.MRN=%page.%GetValueById("txtMRN")
		set tRequest.MothersMaidenSurname = %page.%GetValueById("txtMaidenSurname")
		set tRequest.MPIID = %page.%GetValueById("txtMPIID")
		Set tAddUpdate=%page.%GetValueById("addOrUpdate")
		If tAddUpdate="Add" Set tRequest.AddOrUpdate="A"
		If tAddUpdate="Update" Set tRequest.AddOrUpdate="U"
		
		Set tSvcId=%page.%GetValueById("cmbServiceRegistry")
		#dim tSvcReg as %ZEN.Component.combobox = ..%GetComponentById("cmbServiceRegistry")
		Set tSvcName = tSvcReg.%GetDisplayValue(tSvcId)
		
		Set tVersion=%page.%GetValueById("version")
		Set tHost=$S(tVersion="v3":"HS.IHE.PIXv3.Source.Operations",1:"HS.IHE.PIXv2.Source.Operations")
		
		Set %session.Data("IHE.Test",..%ClassName(0),"Prefix")=tRequest.Prefix
		Set %session.Data("IHE.Test",..%ClassName(0),"LastName")=tRequest.LastName
		Set %session.Data("IHE.Test",..%ClassName(0),"FirstName")=tRequest.FirstName
		Set %session.Data("IHE.Test",..%ClassName(0),"MiddleName")=tRequest.MiddleName
		Set %session.Data("IHE.Test",..%ClassName(0),"Suffix")=tRequest.Suffix
		Set %session.Data("IHE.Test",..%ClassName(0),"StreetLine")=tAddress.StreetLine
		Set %session.Data("IHE.Test",..%ClassName(0),"City")=tAddress.City
		Set %session.Data("IHE.Test",..%ClassName(0),"State")=tAddress.State
		Set %session.Data("IHE.Test",..%ClassName(0),"PostalCode")=tAddress.PostalCode
		Set:tHomePh]"" %session.Data("IHE.Test",..%ClassName(0),"HP-PhoneNumberFull")=tHomePhone.PhoneNumberFull
		Set:tBusPh]"" %session.Data("IHE.Test",..%ClassName(0),"BP-PhoneNumberFull")=tBusPhone.PhoneNumberFull
		Set %session.Data("IHE.Test",..%ClassName(0),"DOB")=tDOB
		Set %session.Data("IHE.Test",..%ClassName(0),"Sex")=tRequest.Sex
		Set %session.Data("IHE.Test",..%ClassName(0),"Facility")=tRequest.Facility
		Set %session.Data("IHE.Test",..%ClassName(0),"AA")=tRequest.AssigningAuthority
		Set %session.Data("IHE.Test",..%ClassName(0),"AAOID")=tAAOID
		Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=tRequest.MRN
		Set %session.Data("IHE.Test",..%ClassName(0),"MothersMaidenSurname")=tRequest.MothersMaidenSurname
		Set %session.Data("IHE.Test",..%ClassName(0),"MPIID")=tRequest.MPIID
		
		Set %session.Data("IHE.Test",..%ClassName(0),"Version")=tVersion
		Set %session.Data("IHE.Test",..%ClassName(0),"AddUpdate")=tAddUpdate
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry")=tSvcId
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistryName")=tSvcName
		
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,%page.%GetValueById("chkLogging"))
		If tHost]"" Do tRequest.AdditionalInfo.SetAt(tHost,"Host"),tGroup.AdditionalInfo.SetAt(tHost,"Host")
		//Patient Name
		Do tGroup.AdditionalInfo.SetAt(tRequest.Prefix,"Prefix")
		Do tGroup.AdditionalInfo.SetAt(tRequest.LastName,"LastName")
		Do tGroup.AdditionalInfo.SetAt(tRequest.FirstName,"FirstName")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MiddleName,"MiddleName")
		Do tGroup.AdditionalInfo.SetAt(tRequest.Suffix,"Suffix")
		//Address
		Do tGroup.AdditionalInfo.SetAt(tAddress.StreetLine,"StreetLine")
		Do tGroup.AdditionalInfo.SetAt(tAddress.City,"City")
		Do tGroup.AdditionalInfo.SetAt(tAddress.State,"State")
		Do tGroup.AdditionalInfo.SetAt(tAddress.PostalCode,"PostalCode")
		//Telecoms
		Do:tHomePh]"" tGroup.AdditionalInfo.SetAt(tHomePhone.PhoneNumberFull,"HP-PhoneNumberFull")
		Do:tBusPh]"" tGroup.AdditionalInfo.SetAt(tBusPhone.PhoneNumberFull,"BP-PhoneNumberFull")	
		//Demographics
		Do:tDOB]"" tGroup.AdditionalInfo.SetAt(tDOB,"DOB")
		Do tGroup.AdditionalInfo.SetAt(tRequest.Sex,"Sex")
		Do tGroup.AdditionalInfo.SetAt(tRequest.Facility,"Facility")
		Do tGroup.AdditionalInfo.SetAt(tRequest.AssigningAuthority,"AssigningAuthority")
		Do tGroup.AdditionalInfo.SetAt(tAAOID,"AAOID")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MRN,"MRN")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MothersMaidenSurname,"MothersMaidenSurname")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MPIID,"MPIID")
		//Other
		Do tGroup.AdditionalInfo.SetAt(tSvcId,"ServiceRegistry")
		Do tGroup.AdditionalInfo.SetAt(tSvcName,"ServiceRegistryName")
		Do tGroup.AdditionalInfo.SetAt(tVersion,"Version")
		Do tGroup.AdditionalInfo.SetAt(tAddUpdate,"AddUpdate")
		
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
	Set tCombo.valueList=",M,F,O,U"
	Set tCombo.displayList=",Male,Female,Other,Unknown"
	
	Set tPrefix=$g(%session.Data("IHE.Test",..%ClassName(0),"Prefix"))
	Set tLastName=$g(%session.Data("IHE.Test",..%ClassName(0),"LastName"))
	Set tFirstName=$g(%session.Data("IHE.Test",..%ClassName(0),"FirstName"))
	Set tMiddleName=$g(%session.Data("IHE.Test",..%ClassName(0),"MiddleName"))
	Set tSuffix=$g(%session.Data("IHE.Test",..%ClassName(0),"Suffix"))
	Set tStreetLine=$g(%session.Data("IHE.Test",..%ClassName(0),"StreetLine"))
	Set tCity=$g(%session.Data("IHE.Test",..%ClassName(0),"City"))
	Set tState=$g(%session.Data("IHE.Test",..%ClassName(0),"State"))
	Set tPostalCode=$g(%session.Data("IHE.Test",..%ClassName(0),"PostalCode"))
	Set tHPPhoneNumberFull=$g(%session.Data("IHE.Test",..%ClassName(0),"HP-PhoneNumberFull"))
	Set tBPPhoneNumberFull=$g(%session.Data("IHE.Test",..%ClassName(0),"BP-PhoneNumberFull"))
	Set tDOB=$g(%session.Data("IHE.Test",..%ClassName(0),"DOB"))
	Set tSex=$g(%session.Data("IHE.Test",..%ClassName(0),"Sex"))
	Set tFacility=$g(%session.Data("IHE.Test",..%ClassName(0),"Facility"))
	Set tAA=$g(%session.Data("IHE.Test",..%ClassName(0),"AA"))
	Set tAAOID=$g(%session.Data("IHE.Test",..%ClassName(0),"AAOID"))
	Set tMRN=$g(%session.Data("IHE.Test",..%ClassName(0),"MRN"))
	Set tMothersMaidenName=$g(%session.Data("IHE.Test",..%ClassName(0),"MothersMaidenName"))
	Set tMPIID=$g(%session.Data("IHE.Test",..%ClassName(0),"MPIID"))
	Set tVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"Version"))
	Set tAddUpdate=$g(%session.Data("IHE.Test",..%ClassName(0),"AddUpdate"))
	Set tSvcId=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set tSvcName=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistryName"))
	Set:tSvcId="" tSvcId=..#SERVICEREGISTRYENTRY
	Set:tSvcName="" tSvcName=..#SERVICEREGISTRYENTRY
	Do ..SetLogging()
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tPrefix=tGroup.AdditionalInfo.GetAt("Prefix")
		Set tLastName=tGroup.AdditionalInfo.GetAt("LastName")
		Set tFirstName=tGroup.AdditionalInfo.GetAt("FirstName")
		Set tMiddleName=tGroup.AdditionalInfo.GetAt("MiddleName")
		Set tSuffix=tGroup.AdditionalInfo.GetAt("Suffix")
		Set tStreetLine=tGroup.AdditionalInfo.GetAt("StreetLine")
		Set tCity=tGroup.AdditionalInfo.GetAt("City")
		Set tState=tGroup.AdditionalInfo.GetAt("State")
		Set tPostalCode=tGroup.AdditionalInfo.GetAt("PostalCode")
		Set tHPPhoneNumberFull=tGroup.AdditionalInfo.GetAt("HP-PhoneNumberFull")
		Set tBPPhoneNumberFull=tGroup.AdditionalInfo.GetAt("BP-PhoneNumberFull")
		Set tDOB=tGroup.AdditionalInfo.GetAt("DOB")
		Set tSex=tGroup.AdditionalInfo.GetAt("Sex")
		Set tFacility=tGroup.AdditionalInfo.GetAt("Facility")
		Set tAA=tGroup.AdditionalInfo.GetAt("AssigningAuthority")
		Set tAAOID=tGroup.AdditionalInfo.GetAt("AAOID")
		Set tMRN=tGroup.AdditionalInfo.GetAt("MRN")
		Set tMothersMaidenName=tGroup.AdditionalInfo.GetAt("MothersMaidenName")
		Set tMPIID=tGroup.AdditionalInfo.GetAt("MPIID")
		Set tVersion=tGroup.AdditionalInfo.GetAt("Version")
		Set tAddUpdate=tGroup.AdditionalInfo.GetAt("AddUpdate")
		Set tSvcId=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
		Set tSvcName=tGroup.AdditionalInfo.GetAt("ServiceRegistryName")
		
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}
	
	Set:$g(tVersion)="" tVersion="v3"
	Set:$g(tAddUpdate)="" tAddUpdate="Add"
	Do ..%SetValueById("txtPrefix",tPrefix)
	Do ..%SetValueById("txtLastName",tLastName)	
	Do ..%SetValueById("txtFirstName",tFirstName)
	Do ..%SetValueById("txtMiddleName",tMiddleName)
	Do ..%SetValueById("txtSuffix",tSuffix)
	Do ..%SetValueById("txtStreet",tStreetLine)	
	Do ..%SetValueById("txtCity",tCity)
	Do ..%SetValueById("txtState",tState)
	Do ..%SetValueById("txtZip",tPostalCode)
	Do ..%SetValueById("txtHomePhone",tHPPhoneNumberFull)	
	Do ..%SetValueById("txtBusinessPhone",tBPPhoneNumberFull)
	Do ..%SetValueById("cmbGender",tSex)
	Do ..%SetValueById("dtDOB",tDOB)	
	Do ..%SetValueById("txtMaidenSurname",tMothersMaidenName)
	Do ..%SetValueById("cmbAA",tAA)	
	Do ..%SetValueById("txtAAOID",tAAOID)
	Do ..%SetValueById("cmbFacility",tFacility)
	Do ..%SetValueById("txtMRN",tMRN)	
	Do ..%SetValueById("txtMPIID",tMPIID)
	Do ..%SetValueById("version",tVersion)
	Do ..%SetValueById("addOrUpdate",tAddUpdate)
	Do ..%SetValueById("cmbServiceRegistry",tSvcId)

	If ##class(HS.Registry.Config).GetKeyValue("\IHE\Connectathon",0)=1 Set tControl=%page.%GetComponentById("txtMPIID") Set tControl.hidden=0
	Quit $$$OK
}

Method Connectv2() [ ZenMethod ]
{
	Do ..ClearResultsPane()
	//If '##class(HS.Facility.Config).%ExistsId(..ORGANIZATION) || ('##class(HS.AssignAuth.Config).%ExistsId(..ORGANIZATION)) {
	//	Do ..LogMessage("Ensure facility "_..ORGANIZATION_" exists and is an assigning authority")
	//	Quit
	//}
	Set:'$D(^IHETEST.Patient.NextMRN) ^IHETEST.Patient.NextMRN=200000000
	Set tHost="HS.IHE.PIXv2.Source.Operations"
	/*
	The Patient Identity Source will send its local patient identifier and Assigning Authority for three patients:

    well-known patient FARNSWORTH^STEVE
    The 2nd patient is SINGLETON^MARION (this is a patient's maiden name)
    The 3nd patient has a last name matching the Patient Identity Source's company, and a woman's first name of MARY, eg. patient "XYZmedical^MARY". Use this patient with last name matching your company name, and generate your own patient ID. (This is the patient's married name.) Later, this patient's first name is updated MARION.

	Evaluation

	The Patient Identity Source actor must demonstrate all 3 of these capabilities. If a capability is missing, the test does not pass:

    admit/register a patient with A01 or A04 or A05
    update a patient with A08
    patient identity merge with A40

	In order to verify the test the Connectathon monitor will ask the following :

    One of the two actors will have to show the HL7 messages transmitted between the 2 actors
    On the PIX Manager, patient FARNSWORTH, STEVE exists with the value of the Assigning Authority assigned to the Patient Identity Source system in this test. It is cross-referenced to FARNSWORTH^STEVE with the 'global' ID (in the Red, Green, Blue domain) which previously existed (from the PIX_Seed_Mgr test). This could be done by using a PIX Consumer to query for the Patient Identity Source's local ID, and retrieve the global ID for Farnsworth (IHERED-997, IHEGREEN-997, IHEBLUE-997).
    The patient SINGLETON^MARION was initially registered with the PIX Manager. Now she has been merged with the patient whose last name matches the company name of the Patient Identity Source actor in this test, eg "XYZmedical".
    An update (A08) was sent when the patient first name was updated from Mary to Marion. There was no change in Patient ID.
    Observe the Patient ID's that were recorded during the test. Patient ID for XYZmedical^Marion survives. Patient ID for SINGLETON^MARION has been subsumed.
		
	*/
	
	/// Create Steve Farnsworth
	set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	set tRequest.LastName="FARNSWORTH"
	set tRequest.FirstName="STEVE"
	set tAddress=##class(HS.Types.Address).%New()
	set tAddress.StreetLine="820 Jorie Blvd"
	set tAddress.City="Chicago"
	set tAddress.State="IL"
	set tAddress.PostalCode="60532"
	set tAddress.Use="H" //Home
	do tRequest.Addresses.Insert(tAddress)
	set tRequest.DOB=$ZDH("19781208",8)
	set tRequest.Sex="M"
	Set tRequest.AssigningAuthority = ..ASSIGNINGAUTHORITY
	Set tRequest.Facility=..ORGANIZATION
	set tRequest.MRN=$I(^IHETEST.Patient.NextMRN)
	Set tRequest.AddOrUpdate="A"
	Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,tRequest,"Adding Steve Farnsworth "_tRequest.MRN)
	Do ..LogFinished(tGroup)

	/// Create Marion Singleton
	set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	set tRequest.LastName="SINGLETON"
	set tRequest.FirstName="MARION"
	set tAddress=##class(HS.Types.Address).%New()
	set tAddress.StreetLine="123 Mary Blvd"
	set tAddress.City="Chicago"
	set tAddress.State="IL"
	set tAddress.PostalCode="60532"
	set tAddress.Use="H" //Home
	do tRequest.Addresses.Insert(tAddress)
	set tRequest.DOB=$ZDH("19680508",8)
	set tRequest.Sex="F"
	Set tRequest.AssigningAuthority = ..ASSIGNINGAUTHORITY
	Set tRequest.Facility=..ORGANIZATION
	set tRequest.MRN=$I(^IHETEST.Patient.NextMRN)
	Set tPriorMRN=tRequest.MRN
	Set tRequest.AddOrUpdate="A"
	Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,tRequest,"Adding Marion Singleton "_tRequest.MRN)
	Do ..LogFinished(tGroup)

	/// Create Mary ..ORGANIZATION
	set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	set tRequest.LastName=..ORGANIZATION
	set tRequest.FirstName="Mary"
	set tAddress=##class(HS.Types.Address).%New()
	set tAddress.StreetLine="899 Mary Cove Road"
	set tAddress.City="Marysville"
	set tAddress.State="IL"
	set tAddress.PostalCode="60532"
	set tAddress.Use="H" //Home
	do tRequest.Addresses.Insert(tAddress)
	set tRequest.DOB=$ZDH("19680508",8)
	set tRequest.Sex="F"
	Set tRequest.AssigningAuthority = ..ASSIGNINGAUTHORITY
	Set tRequest.Facility=..ORGANIZATION
	set tRequest.MRN=$I(^IHETEST.Patient.NextMRN)
	Set tRequest.AddOrUpdate="A"
	Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,tRequest,"Adding Mary "_..ORGANIZATION_" "_tRequest.MRN)
	Do ..LogFinished(tGroup)

	/// Update Mary to Marion
	Set tRequest.FirstName="Marion"
	Set tRequest.AddOrUpdate="U"
	Do ..ConnectExecute(.tGroup,tRequest,"Updating Mary to Marion "_..ORGANIZATION_" "_tRequest.MRN)
	Set tMRN=tRequest.MRN
	Do ..LogFinished(tGroup)

	set tRequestMerge=##class(HS.Message.MergePatientRequest).%New()
	Set tRequestMerge.MRN=tMRN
	Set tRequestMerge.AssigningAuthority=..ASSIGNINGAUTHORITY
	Set tRequestMerge.PriorAssigningAuthority=..ASSIGNINGAUTHORITY
	Set tRequestMerge.Facility=..ORGANIZATION
	Set tRequestMerge.PriorMRN=tPriorMRN
	do tRequestMerge.AdditionalInfo.SetAt(..ORGANIZATION, "familyName")
	do tRequestMerge.AdditionalInfo.SetAt("Mary", "givenName")
	Do tRequestMerge.AdditionalInfo.SetAt(tHost,"Host")
	Set tTest=tGroup.NewTest(tRequestMerge,%page.%GetValueById("chkLogging"),"","Merging Marion Singleton into Marion "_..ORGANIZATION)
	
	Set tSC = ..Execute(tTest,tGroup)
	Do ..DisplayTestResultSync(tTest,tGroup) quit:$$$ISERR(tSC)
	Do ..DisplayGroupTestName(tGroup)
	Do tGroup.%Save()
}

Method Connectv3() [ ZenMethod ]
{
	Do ..ClearResultsPane()
	//If '##class(HS.Facility.Config).%ExistsId(..ORGANIZATION) || ('##class(HS.AssignAuth.Config).%ExistsId(..ORGANIZATION)) {
	//	Do ..LogMessage("Ensure facility "_..ORGANIZATION_" exists and is an assigning authority")
	//	Quit
	//}
	Set:'$D(^IHETEST.Patient.NextMRN) ^IHETEST.Patient.NextMRN=200000000
	Set tHost="HS.IHE.PIXv3.Source.Operations"
	/*
	The Patient Identity Source will send its local patient identifier and Assigning Authority for three patients:

    well-known patient WILLIAM WALTERS
    The 2nd patient is ALICE MAIDEN (this is a patient's maiden name)
    The 3nd patient has a last name matching the Patient Identity Source's gazelle system name, and a woman's first name of ALYSSA, eg. patient "Ehrxyzmedical^ALYSSA". Use this patient with last name matching your system name, and generate your own patient ID. (This is the patient's married name.) Later, this patient's first name is updated ALICE.

	Evaluation

	The Patient Identity Source actor must demonstrate all 3 of these capabilities. If a capability is missing, the test does not pass:

    admit/register a patient with PRPA_IN201301UV02 - Patient Registry Record Added
    update a patient with PRPA_IN201302UV02 - Patient Registry Record Revised
    patient identity merge with PRPA_IN201304UV02 - Patient Registry Duplicates Resolved

	In order to verify the test the Connectathon monitor will ask the following :

    One of the two actors will have to show the HL7 messages transmitted between the 2 actors
    On the PIX Manager, patient WILLIAM WALTERS exists with the value of the local Assigning Authority assigned to the Patient Identity Source system in this test. It is cross-referenced to WILLIAM WALTERS with the 'global' ID which previously existed (from the PIX/PDQ_Load test). This could be done by using a PIX Consumer to query for the Patient Identity Source's local ID, and retrieve the global ID for WALTERS (IHERED-998, IHEGREEN-998, BLUE-998).
    The patient ALICE MAIDEN was initially registered with the PIX Manager. Now she has been merged with the patient whose last name matches the kudu system name of the Patient Identity Source actor in this test, eg "Ehrxyzmedical".
    An update (PRPA_IN201302UV02) was sent when the patient first name was updated from ALYSSA to ALICE. There was no change in Patient ID.
    Observe the Patient ID's that were recorded during the test. Patient ID for Ehrxyzmedical^ALICE survives. Patient ID for ALICE MAIDEN has been subsumed.
		
	*/
	/// Create William Walters
	set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	set tRequest.LastName="WALTERS"
	set tRequest.FirstName="WILLIAM"
	set tAddress=##class(HS.Types.Address).%New()
	set tAddress.StreetLine="3900 FLORA PL"	
	set tAddress.City="ST. LOUIS"
	set tAddress.State="MO"
	set tAddress.PostalCode="63110"
	set tAddress.Use="H" //Home
	do tRequest.Addresses.Insert(tAddress)
	/*Matt Spielman - At 2016 NA CAT Willaim Walters birthdate was entered into Gazelle as 1955-05-04; the PIX Feed test specified
	1955-05-05 which resulted in mismatches by PIX managers who had loaded from Gazelle. The date in the tool is being changed to
	1955-05-04 but may need to be changed back if they ever revert the birthdate in the tooling.
	
	*/
	set tRequest.DOB=$ZDH("19550504",8)
	set tRequest.Sex="M"
	Set tRequest.AssigningAuthority = ..ASSIGNINGAUTHORITY
	Set tRequest.Facility=..ORGANIZATION
	set tRequest.MRN=$I(^IHETEST.Patient.NextMRN)
	Set tRequest.AddOrUpdate="A"
	Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,tRequest,"Adding William Walters "_tRequest.MRN)
	Do ..LogFinished(tGroup)

	/// Create Marion Singleton
	set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	set tRequest.LastName="MAIDEN"
	set tRequest.FirstName="ALICE"
	set tAddress=##class(HS.Types.Address).%New()
	set tAddress.StreetLine="345 Alice Blvd"
	set tAddress.City="Chicago"
	set tAddress.State="IL"
	set tAddress.PostalCode="60539"
	set tAddress.Use="H" //Home
	do tRequest.Addresses.Insert(tAddress)
	set tRequest.DOB=$ZDH("19650408",8)
	set tRequest.Sex="F"
	Set tRequest.AssigningAuthority = ..ASSIGNINGAUTHORITY
	Set tRequest.Facility=..ORGANIZATION
	set tRequest.MRN=$I(^IHETEST.Patient.NextMRN)
	Set tPriorMRN=tRequest.MRN
	Set tRequest.AddOrUpdate="A"
	Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,tRequest,"Adding Alice Maiden "_tRequest.MRN)
	Do ..LogFinished(tGroup)

	/// Create Alyssa ..ORGANIZATION
	set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	set tRequest.LastName=..ORGANIZATION
	set tRequest.FirstName="ALYSSA"
	set tAddress=##class(HS.Types.Address).%New()
	set tAddress.StreetLine="899 Alyssa Cove Road"
	set tAddress.City="Alyssaville"
	set tAddress.State="IL"
	set tAddress.PostalCode="60532"
	set tAddress.Use="H" //Home
	do tRequest.Addresses.Insert(tAddress)
	set tRequest.DOB=$ZDH("19680508",8)
	set tRequest.Sex="F"
	Set tRequest.AssigningAuthority = ..ASSIGNINGAUTHORITY
	Set tRequest.Facility=..ORGANIZATION
	set tRequest.MRN=$I(^IHETEST.Patient.NextMRN)
	Set tRequest.AddOrUpdate="A"
	Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
	Do ..ConnectExecute(.tGroup,tRequest,"Adding Alyssa "_..ORGANIZATION_" "_tRequest.MRN)
	Do ..LogFinished(tGroup)

	/// Update Alyssa to Alice
	Set tRequest.FirstName="ALICE"
	Set tRequest.AddOrUpdate="U"
	Do ..ConnectExecute(.tGroup,tRequest,"Updating Alyssa to Alice "_..ORGANIZATION_" "_tRequest.MRN)
	Set tMRN=tRequest.MRN
	Do ..LogFinished(tGroup)

	set tRequestMerge=##class(HS.Message.MergePatientRequest).%New()
	Set tRequestMerge.MRN=tMRN
	Set tRequestMerge.AssigningAuthority=..ASSIGNINGAUTHORITY
	Set tRequestMerge.PriorAssigningAuthority=..ASSIGNINGAUTHORITY
	Set tRequestMerge.PriorMRN=tPriorMRN
	Set tRequestMerge.Facility=..ORGANIZATION
	do tRequestMerge.AdditionalInfo.SetAt(..ORGANIZATION, "familyName")
	do tRequestMerge.AdditionalInfo.SetAt("Alice", "givenName")
	Do tRequestMerge.AdditionalInfo.SetAt(tHost,"Host")
	Set tTest=tGroup.NewTest(tRequestMerge,%page.%GetValueById("chkLogging"),"","Merging Alice Maiden into Alice "_..ORGANIZATION)
	Set tSC = ..Execute(tTest,tGroup)
	Do ..DisplayTestResultSync(tTest,tGroup) quit:$$$ISERR(tSC)
	Do ..DisplayGroupTestName(tGroup)
	Do tGroup.%Save()
}

Method ConnectExecute(pGroup = "", pRequest, pMsg)
{
	try {
		Set:'$IsObject(pGroup) pGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=pGroup.NewTest(pRequest,%page.%GetValueById("chkLogging"),"",pMsg)
		Set tSC = ..Execute(tTest,pGroup)
		Do ..DisplayTestResultSync(tTest,pGroup) quit:$$$ISERR(tSC)
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

Method AddServiceEntries(pDefaultEntry = "") [ ZenMethod ]
{
	try {
		Set tSC=$$$OK
		Set tEntry=$G(%session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1)))
		#dim tServiceRegistry as %ZEN.Component.combobox = ..%GetComponentById("cmbServiceRegistry")
		#dim tVersion as %ZEN.Component.radioSet = ..%GetComponentById("version")
		Do tServiceRegistry.options.Clear()
		If tVersion.value="v3" {
			Set tType="SOAP",pDefaultEntry="PIXv3.Manager"
			If tEntry="PIXv2.Manager" Set tEntry=""
		} Else {
			Set tType="TCP",pDefaultEntry="PIXv2.Manager"
			If tEntry="PIXv3.Manager" Set tEntry=""
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

}

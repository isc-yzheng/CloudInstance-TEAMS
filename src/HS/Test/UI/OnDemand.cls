/// OnDemand tests for connect-a-thon
/// 1. Register patient in Geneva
/// 2. Run the "Register" test, which will create and register the on-demand document in the partner's registry
/// 3. The partner consumer retrieves and logs a screenshot in Gazelle
/// 4. Run the "update" test, which will change the DOB, street address, and add an allergy
/// 5. The partner consumer retrieves and logs a screenshot in Gazelle
Class HS.Test.UI.OnDemand Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "On Demand Documents";

Property PatientId As %String(MAXLEN = "");

Parameter SERVICEREGISTRYENTRY = "XDSb.Registry";

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="40"/>

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<text label="Full Patient ID:" name="patientID" id="txtPatientID" size="80" value="#(%page.PatientId)#"/>
<text label="HL7 Path:" name="path" id="txtPath" size="80" value=""/>
<combobox hidden="true" id="cmbServiceRegistry" name="cmbServiceRegistry" label="EndPoint: *" labelClass="caption" dropdownWidth="300"/>
<spacer height="15"/>
<hgroup width="40%" cellAlign="right">
<button id="btnRegister" caption=" Register "  onclick="zenPage.Send(1);" />
<button id="btnUpdate" caption=" Update " onclick="zenPage.Send(2);" />
<spacer width="5" />
</hgroup>
</form>
<pane id="paneResults"/>
<textarea hidden="true" label="ProvideAndRegisterDocumentSetRequest SOAP body:" id="txtRequest" cols="90" rows="20" />
<textarea hidden="true" label="PnR response:" id="txtResponse" cols="90" rows="20"/>
<spacer height="25"/>
</pane>
</page>
}

Method Send(step As %Integer = 1) [ ZenMethod ]
{
	set tSC = $$$OK
	try {
		Do ..LogClear()
		Set tPatientID = %page.%GetComponentById("txtPatientID").value
		Set tPath = %page.%GetComponentById("txtPath").value

		Set %session.Data("XDSbODD.PatientID")=tPatientID
		Set %session.Data("XDSbODD.Path")=tPath
		
		Set tID = $P(tPatientID,"^",1)
		Set tAAOID = $P(tPatientID,"&",2)
		Set tAA = ##class(HS.Data.OIDMap).GetCodeForOID(tAAOID)	
		Set tVisit=tID

		If step=1 {
			Set tDOB="19500110"
			Set tStreet="1 Memorial Drive"
		}
		ElseIf step=2 {
			Set tDOB="19400220"
			Set tStreet="999 Null Drive"
		}
				
		Set tTmpFilename = ##class(%File).TempFilename()
		Set tTmpFile = ##class(%FileCharacterStream).%New()
		Set tTmpFile.Filename = tTmpFilename
		Do tTmpFile.WriteLine("MSH|^~\&||ISCSOURCE|||||ADT^A08|||2.5")
		Do tTmpFile.WriteLine("EVN|A08|20081022094500")
		Do tTmpFile.WriteLine("PID|||"_tID_"^^^"_tAA_"^MR||InterSystems^OnDemand||"_tDOB_"|M|||"_tStreet_"^^Cambridge^MA^02142")
		Do tTmpFile.WriteLine("PV1||O|||||ISCGP001^Moore^James|||||||EO|||||HSVN-"_tVisit_"|||||||||||||||||||||||||20081022094500|20081022094500")
		Do tTmpFile.WriteLine("DG1|||T2D^Type 2 diabetes mellitus|Type 2 diabetes mellitus|200810220945|T2D||||||||||ISCGP001^Moore^James")
		Do tTmpFile.WriteLine("AL1||Food|Choc^Chocolate|Sev^Severe - Danger of Choking|Sneeze|20020101")
		if step=2 Do tTmpFile.WriteLine("AL1||Food|Nuts^Peanuts|Sev^Severe - Danger of Choking|Cough|20020101")
		Set tSC = tTmpFile.%Save() $$$ThrowOnError(tSC)
		Kill tTmpFile
		Set tSC = ##class(%File).CopyFile(tTmpFilename,tPath_"ondemand-"_tID_".hl7",1) $$$ThrowOnError(tSC)
		
		Do ..LogMessage("Done")
		If step=1 {
			Do ..LogMessage("Check Ensemble message trace, and issue query to check successful registration")
			Do ..LogMessage("Make sure consumer uploads a screenshot to gazelle before doing an update")
		}
		Do ..LogMessage("Add Note to Gazelle:")
		Do ..LogMessage($S(step=2:"After Update",1:"Before Update"))
		Do ..LogMessage("DOB = "_tDOB)
		Do ..LogMessage("Street = "_tStreet)
		Do ..LogMessage("Allergies = Chocolate"_$s(step=2:",Peanuts",1:""))
	} catch ex {
		Do ..LogException(ex)
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tDefaultPath = $SYSTEM.Util.InstallDirectory()_"Data/HSEDGE1/HL7In/"
	Set tSC= ..AddServiceRegistryEntries(..#SERVICEREGISTRYENTRY) 
	Do ..%SetValueById("txtPatientID",$g(%session.Data("XDSbODD.PatientID")))
	Do ..%SetValueById("txtPath",$g(%session.Data("XDSbODD.Path"),tDefaultPath))
	Quit $$$OK
}

Method LogClear()
{
	set results=%page.%GetComponentById("paneResults")
	do results.%RemoveChildren()
}

}

Class HS.Test.UI.XDMCreator Extends HS.Test.UI.Main
{

Parameter TARGETHOST As %String = "HS.IHE.XDM.PortableMediaCreator.Process";

/// Displayed name of this page.
Parameter PAGENAME = "Portable Media Creator";

Parameter SERVICEREGISTRYENTRY = "XDSb.Repository";

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
<html>Please select</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" >
<spacer height="5"/>
<combobox id="cmbFileType" label=" File Type:" size="90" valueList="C32,BPPC,HSP_CCD,HSP_CCD_NOFORMAT,HSP_CN,HSP_DS,HSP_Unstruct,XDLAB,XDSSD,XPHR,CAT_CDA" value="" onchange="zenPage.selectFile(zenThis.value);" />
<text label="Input Path:" name="txtPath" id="txtPath" size="80" value="c:\xdm\"/>
<text label="Filename:" name="txtFilename" id="txtFilename" size="80" value=""/>
<text label="Output Path:" id="txtOutputFilePath" size="80" value='c:/xdm/Out/'/>
<spacer height="15"/>
<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend',1)" />

<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
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

ClientMethod selectFile(value) [ Language = javascript ]
{
	if(value=="C32") {
		file='';
	} else if (value=='BPPC') { 
		file='bppc_intersystems_pdf.xml';
	} else if (value=='HSP_CCD' || value=='HSP_CCD_NOFORMAT') { 
		file='HSP_CCD_OTHER_INTERSYS_HEALTHSHARE.xml';
	} else if (value=='HSP_CN') { 
		file='HSP_CN_OTHER_INTERSYS_HEALTHSHARE.xml';
	} else if (value=='HSP_DS') { 
		file='HSP_DS_OTHER_INTERSYS_HEALTHSHARE.xml';
	} else if (value=='HSP_Unstruct') { 
		file='HSP_UnstructuredDoc_OTHER_INTERSYS_HEALTHSHARE.xml';
	} else if (value=='XDLAB') { 
		file='XDLAB_OTHER_INTERSYS_HEALTHSHARE.xml';
	} else if (value=='XDSSD') { 
		file='XDSSD_INTERSYS_PDF.xml';
	} else if (value=='XPHR') {
		file='XPHR_EXTRACT_OTHER_INTERSYS_HEALTHSHARE.xml';
	} else if (value=='CAT_CDA') {
		file='CDA_OTHER_INTERSYS_HEALTHSHARE.xml';
	}
	zen('txtFilename').setValue(file);
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('txtFilename').setValue("");
	zen('cmbFileType').setValue("");
}

Method Send() As %String [ ZenMethod ]
{
	Set tMsg = ""
	try {
		set tSC = $$$OK

		Set tFilename = %page.%GetValueById("txtFilename")
		Set tFileType = %page.%GetValueById("cmbFileType")
		Set tPath = %page.%GetValueById("txtPath")
		
		set tRequest = ##class(HS.Message.IHE.XDM.DistributeDocumentSetRequest).%New()
		Set tRequest.FilePath=%page.%GetValueById("txtOutputFilePath")
		set tStream = ##class(%Stream.FileCharacter).%New()
		set tStream.Filename = ##class(%File).NormalizeDirectory(tPath)_tFilename
		if tStream.Size = 0 Set tMsg = tMsg _" Zero Length Stream"

		set tSubSet = ##class(HS.Message.IHE.XDSb.Metadata).%New()
		set tSubSetBodyStream = ##class(%Stream.FileCharacter).%New()
		
		$$$ThrowOnError(tSC)
		
		set tDocument = ##class(HS.Types.IHE.XDSb.Document).%New()
		Do tStream.Rewind()
		set tSC = tDocument.BodyCharacter.CopyFrom(tStream) Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		set tDocument.URI = tFilename
		Do tDocument.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New( tDocument.URI))
		
		$$$ThrowOnError(tSC)
	
		Set tSubmission = ##class(HS.Types.IHE.XDSb.Submission).%New()
		Set tSubmission.ContentTypeCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"34133-9","LOINC","Summarization of Episode Note")	
		Set tDocument.MimeType="text/xml"
		Set tDocument.ClassCode = ##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"DEMO-Consult",
			"1.3.6.1.4.1.21367.100.1",
			"Consultation")			
		if tFileType = "C32" {
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"2.16.840.1.113883.10.20.1",
			"2.16.840.1.113883.3.88",
			"HL7 CCD Document")
		} ElseIf tFileType = "BPPC" {
			Set tSubSet.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New(
			"57017-6","LOINC","Privacy Policy")	
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"urn:ihe:iti:bppc-sd:2007",
			"1.3.6.1.4.1.19376.1.2.3",
			"urn:ihe:iti:bppc-sd:2007")
		} ElseIf tFileType = "HSP_CCD" {
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"urn:wustl:mir:hsp-ccd:1999",
			"1.3.6.1.4.1.21367.100.1",
			"urn:wustl:mir:hsp-ccd:1999")
		} ElseIf tFileType = "HSP_CCD_NOFORMAT" {
			// Don't set FormatCode.
		} ElseIf tFileType = "HSP_CN" {
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"urn:wustl:mir:hsp-cn:1999",
			"1.3.6.1.4.1.21367.100.1",
			"urn:wustl:mir:hsp-cn:1999")
		} ElseIf tFileType = "HSP_DS" {
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"urn:wustl:mir:hsp-ds:1999",
			"1.3.6.1.4.1.21367.100.1",
			"urn:wustl:mir:hsp-ds:1999")
		} ElseIf tFileType = "HSP_Unstruct" {
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"urn:wustl:mir:hsp-unstructured:1999",
			"1.3.6.1.4.1.21367.100.1",
			"urn:wustl:mir:hsp-unstructured:1999")
		} ElseIf tFileType = "XDLAB" {
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"urn:ihe:lab:xd-lab:2008",
			"1.3.6.1.4.1.19376.1.2.3",
			"urn:ihe:lab:xd-lab:2008")
		} ElseIf tFileType = "XDSSD" {
			Set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New("urn:ihe:iti:xds-sd:pdf:2008","1.3.6.1.4.1.19376.1.2.3","urn:ihe:iti:xds-sd:pdf:2008")
		} ElseIf tFileType = "XPHR" {
			set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New("urn:ihe:pcc:xphr:2007","1.3.6.1.4.1.19376.1.2.3","urn:ihe:pcc:xphr:2007")
		} ElseIf tFileType = "CAT_CDA" {
			//Connecathon format code from http://ihexds.nist.gov:12090/xdsref/codes/codes.xml
			set tDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"urn:hl7-org:sdwg:ccda-structuredBody:2.1",
			"1.3.6.1.4.1.19376.1.2.3",
			"urn:hl7-org:sdwg:ccda-structuredBody:2.1")
		}									
		
		Do tDocument.Descriptions.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New("PlaceHolder Description"))
		Set tDocument.PracticeSettingCode = ##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"Anesthesia","Connect-a-thon practiceSettingCodes", "Anesthesia")
		Do tStream.Rewind()
		Set tDocument.Size = tStream.Size
		Set tDocument.HealthCareFacilityTypeCode = ##class(HS.Types.IHE.XDSb.SerialClassification).%New(
			"ACC","2.16.840.1.113883.5.11", "Accident Site")
		set tSC = tSubSet.Documents.Insert(tDocument)
		Do tSubSet.Submissions.Insert(tSubmission)
		$$$ThrowOnError(tSC)
		
		Set tSubSet.Name = "Placeholder SubSetName"
		
		do tRequest.Submissions.Insert(tSubSet)
		Do tRequest.AdditionalInfo.SetAt(..#TARGETHOST,"Host")
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tRequest,0)
		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		#dim ex as %Exception.StatusException
		Set tMsg = tMsg _ " " _ex.DisplayString()
	}
	Quit tMsg _ "G:"_$G(tSessionID)
}

Method %OnAfterCreatePage() As %Status
{
	///InterSystems/NA2014/XDMOutput/
	
	// Set tRoot = $zu(12)_"Temp
	Set tRoot = "c:\xdm\Out"
	Do ..%SetValueById("txtOutputFilePath",$ClassMethod("%File","NormalizeDirectory",tRoot_"/XDM_"_$tr($zdatetime($zts,3,3,3)," :.PM-","_")))
	Quit $$$OK
}

}

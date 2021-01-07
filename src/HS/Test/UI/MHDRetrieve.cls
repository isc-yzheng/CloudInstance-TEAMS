Include HS.HC

Class HS.Test.UI.MHDRetrieve Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Retrieve Documents via MHD";

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

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">

<spacer height="5"/>
<text id="isFHIR" value="1" hidden="1" />
<html>Retrieve Document Content via URL<br/><br/>Use Find References to populate the Documents combo box</html>
<spacer height="5"/>

<combobox id="cmbVersion" label="FHIR Version:" size="22" tabIndex="35" title="FHIR version to use" />
<spacer width="5" />

<combobox id="cmbDocuments" label="Documents:" size="110" tabIndex="35" title="Documents" onchange="zenPage.Clear();zenPage.SelectDocument();"/>
<spacer height="5"/>

<text label="Document URL*:" id="txtDocumentURL" size="110" title="Document URL" hintStyle="font-size:10px;font-weight:bold;"/>
<spacer height="5"/>

<text label="Content Type*: " id="txtContentType" size="60" title="Mime Type to specify in the HTTP Accept header (e.g., text/xml, application/pdf). Can also be application/fhir+xml or applicaition/fhir+json if you want to retrieve it as a FHIR resource." hintStyle="font-size:10px;font-weight:bold;"/>
<spacer height="5"/>

<text label="Patient ID:" id="txtPatientId" readOnly="1" size="110" title="Patient ID" hintStyle="font-size:10px;font-weight:bold;"/>
<spacer height="5"/>

<text label="Format: " id="txtDocumentFormat" readOnly="1" size="110"/>

<spacer height="5"/>

<hgroup width="40%" cellAlign="left" id="grpRetrieve">
<button id="btnRetrieve" caption=" Submit Read Request " onclick="zenPage.StartSend('btnRetrieve',2)" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.Clear();" />
<spacer width="5" />
<button id="btnViewDocument" caption=" View Document " onclick="zenPage.ViewDocument();" />
<spacer width="5" />
</hgroup>

<spacer height="10"/>

<textarea label="Response:" id="txtResponse" rows="20" cols="80" readOnly="true" />
</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>

<pane id="paneResults"/>

</pane>
</page>
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('txtPatientId').setValue("");
	zen('txtDocumentURL').setValue("");
	zen('txtContentType').setValue("");
	zen('txtDocumentFormat').setValue("");
	zenPage.ClearResultsPane();
}

Method Send(pURL) As %String [ ZenMethod ]
{
	Set tSessionID=""
	
	try {
		Set tSessionID = ..SendRetrieve()
	} catch ex {
		Set tSessionID=""
	}
	
	Quit tSessionID
}

Method SelectDocument() [ ZenMethod ]
{
	try {
		Set val = %page.%GetValueById("cmbDocuments")
		Set docID= $p($p(val,"DOCID=",2),"&REPOID=")
		Set fullVal = ""
		Set tIndex = ""
		For {
			Set tIndex = $Order(%session.Data("IHE.Test","RecentDocuments",tIndex))
			If tIndex="" Quit
			If $ListGet(%session.Data("IHE.Test","RecentDocuments",tIndex),3)=docID {
				Set fullVal = %session.Data("IHE.Test","RecentDocuments",tIndex)
				Quit
			}
		}
		Set patientId = $ListGet(fullVal,1)
		Set contentType = $ListGet(fullVal,8)
		Set formatCode = $ListGet(fullVal,9)
		Set docUrl = $ListGet(fullVal,10)
		Set %page.%GetComponentById("txtPatientId").value=patientId
		Set %page.%GetComponentById("txtDocumentURL").value=docUrl
		Set %page.%GetComponentById("txtContentType").value=contentType
		Set %page.%GetComponentById("txtDocumentFormat").value=formatCode
	}	
	 catch ex {
	}
}

Method ViewDocument(objID, mimeType) [ ZenMethod ]
{
	#; ^CacheTemp.TestUI for our document will be blank if the user
	#; invoked View Document for the same retrieved document twice.
	If $Get(^CacheTemp.TestUI(objID))="" &js<alert('Please submit another read request for the document before viewing')> Quit
	Set tURL="HS.Test.UI.XMLViewer.cls?ID="_objID_"&Type="_mimeType
	&js<window.open("#(tURL)#");>
}

Method SendRetrieve() As %String
{
	try {
		set tFHIRVersion = %page.%GetValueById("cmbVersion")
		If tFHIRVersion="" &js< alert('FHIR Version is required');> Quit

		set tReadLen = $Select($system.SYS.MaxLocalLength()=3641144:3640000,1:32000)
		
		set tSessionID=""

		set tSC = ..CheckProduction(.tText)
		if $$$ISERR(tSC) quit
		if $get(tText)'="" quit
		
		if %page.%GetValueById("txtContentType")="" {
			&js<alert('Please specify Content Type')>
			quit
		}
		
		if %page.%GetValueById("txtDocumentURL")="" {
			&js<alert('Please specify Document URL')>
			quit
		}
		
		set tRequest = ##class(HS.Message.FHIR.Request).%New()
		
		set tRequest.Interaction = "read"
		
		set tRequest.ContentType = %page.%GetValueById("txtContentType")
		
		do tRequest.AdditionalInfo.SetAt(%page.%GetValueById("txtDocumentURL"),"GetURL")
		
		do ..%SetValueById("txtResponse","")
		
		do tRequest.AdditionalInfo.SetAt("MHDConsumer"_tFHIRVersion, "FHIRActor")
		
		set tSC = ##class(HS.Test.Service).SendSync(tRequest, .tResponse) $$$ThrowOnError(tSC)
		
		if $isobject($get(tResponse))=0 {
			set tSC = $$$ERROR($$$GeneralError, "Response object not returned")
			quit
		}
		
		if tResponse.Payload.Size>0 {
			do %page.%SetValueById("txtResponse", tResponse.Payload.Read(tReadLen))
			do tResponse.Payload.Rewind()
		}
		
		if $extract(tResponse.Status,1,3)'="200" {
			&js<alert('HTTP Status = #(tResponse.Status)#')>
			quit
		}
		
		#; Put the document contents into ^CacheTemp and make the View Document
		#; button invoke a pop up window with the contents.
		Set tCacheTempID = "FHIR.Test"_$job
		Set ^CacheTemp.TestUI(tCacheTempID)=tResponse.Payload.Read(tReadLen)
		Set tMimeType = tRequest.ContentType
		Set ..%GetComponentById("btnViewDocument").onclick = "zenPage.ViewDocument('"_tCacheTempID_"','"_tMimeType_"')"
		
		Set %session.Data("IHE.Test",..%ClassName(0),"FHIRVersion")=tFHIRVersion

	} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID=""
	}
	Quit tSessionID
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tCombo=..%GetComponentById("cmbVersion")
	Set tCombo.valueList="STU3,DSTU2"
	Set tCombo.displayList=tCombo.valueList
	
	Set tFHIRVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRVersion"))
	Do ..%SetValueById("cmbVersion", tFHIRVersion)
	
	Do ..AddRecentDocuments(,"cmbDocuments")	
	quit $$$OK
}

}

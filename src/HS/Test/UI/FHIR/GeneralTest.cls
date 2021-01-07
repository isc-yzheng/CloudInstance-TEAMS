Class HS.Test.UI.FHIR.GeneralTest Extends HS.Test.UI.FHIR.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "FHIR General Purpose Test UI";

XData Contents
{
<page title="FHIR Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
	
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">

<spacer height="15"/>

<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left" enctype="multipart/form-data">
<spacer height="5"/>
<dataCombo id="cmbServiceRegistry" size='70' label="EndPoint: *" tabIndex="10" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateFHIRServiceRegistryRS"
	title = "Service Registry entry for the resource server endpoint." 
	maxRows="10000">
	<parameter/>
</dataCombo>
<spacer width="5" />
<combobox id="cmbFormat" label="FHIR Format: *" size="22" tabIndex="20" dropdownHeight="80" title="If 'xml' is chosen, then the FHIR request to the resource server will add an Accept header and Content-Type header of 'application/xml+fhir' (for DSTU2) or 'application/fhir+xml' (for STU3 and later). If 'json' is chosen, then the FHIR request to the resource server will add an Accept header and Content-Type header of 'application/json+fhir' (for DSTU2) or 'application/fhir+json' (for STU3 and later)." />
<spacer width="5" />
<combobox id="cmbVersion" label="FHIR Version: *" size="22" tabIndex="30" dropdownHeight="80" title="FHIR version determines whether a conformance or capabilities request should be sent to the specified resource server. It also is a factor in determining what Accept header and Content-Type header to add to the FHIR request." />
<spacer width="5" />
<text label="Client:" id="txtOAuth2Client" size="70" tabIndex="40" title="OAuth 2.0 client defined in System Administration &gt; Security &gt; OAuth 2.0 &gt; Client. If this field has a value when the request is submitted, then the request will look for a valid access token for the specified client on this session. If one is found, then it will be passed to the target endpoint. If not found, then an error will be returned." />
<hgroup label="Interaction:" labelPosition="left" id="grpInteraction">
<radioSet id="rdoInteraction" name="interaction" tabIndex="50" valueList="create,update,read,vread,delete,history,search,conformance/capabilities,transaction,operation" captionClass="lblNormal" onchange="zenPage.OnChangeInteraction();"/>
</hgroup>
<spacer height="5"/>
<text label="Operation:" id="txtOperation" size="30" tabIndex="60" title="FHIR operation to execute (e.g., $validate). Must start with $. This value is ignored if the interaction is not 'operation'."/>
<checkbox label="Return Resource:" id="chkReturnResource" tabIndex="70" title="Applies to create, update and transaction interactions only.  When checked, sets the HTTP PREFER header to 'return=representation' to trigger the server to echo saved resources back in the response payload."/>
<hgroup width="40%" cellAlign="left">
<text label="Resource Type:" id="txtResourceType" tabIndex="81" size="30"/>
<spacer width="5"/>
<text label="Resource ID:" id="txtResourceID" tabIndex="82" size="25"/>
<spacer width="5"/>
<text label="Version ID:" id="txtVersionID" tabIndex="83" size="12"/>
</hgroup>
<hgroup width="40%" cellAlign="left">
<text label="URL Parameter Name:" id="txtParam1Name" size="30" tabIndex="91" title="Names and values of request URL parameters"/>
<spacer width="5"/>
<text label="URL Parameter Value:" id="txtParam1Value" size="40" tabIndex="92" title="Names and values of request URL parameters"/>
</hgroup>
<hgroup width="40%" cellAlign="left">
<text id="txtParam2Name" tabIndex="101" size="30"/>
<spacer width="5"/>
<text id="txtParam2Value" tabIndex="102" size="40"/>
</hgroup>
<hgroup width="40%" cellAlign="left">
<text id="txtParam3Name" tabIndex="121" size="30"/>
<spacer width="5"/>
<text id="txtParam3Value" tabIndex="122" size="40"/>
</hgroup>

<spacer height="5"/>

<hgroup width="40%" cellAlign="left">
<text label="Request Header Name:" id="txtHeader1Name" size="30" tabIndex="131" title="Names and values of request HTTP headers. PLEASE NOTE that several headers will be automatically populated based on choices made on data fields on this page. Accept (FHIR Format), Content-Type (FHIR Format), Authorization Bearer (Client), Authorization Basic (Server) and Prefer:return=representation (Return Resource) headers will already be set." />
<spacer width="5"/>
<text label="Request Header Value:" id="txtHeader1Value" size="40" tabIndex="132" title="Names and values of request HTTP headers. PLEASE NOTE that several headers will be automatically populated based on choices made on data fields on this page. Accept (FHIR Format), Content-Type (FHIR Format), Authorization Bearer (Client), Authorization Basic (Server) and Prefer:return=representation (Return Resource) headers will already be set."/>
</hgroup>
<hgroup width="40%" cellAlign="left">
<text id="txtHeader2Name" tabIndex="141" size="30"/>
<spacer width="5"/>
<text id="txtHeader2Value" tabIndex="142" size="40"/>
</hgroup>

<spacer height="5"/>

<text label="Content File:" id="txtContentFile" size="73" tabIndex="150" title="Full path and name of an operating system file to use as the source of the request Content Body. This is ignored if the interaction is NOT create, update, transaction, or operation." />

<textarea label="Content Body:" id="txtContentBody" rows="20" cols="80" readOnly="false" tabIndex="160" title="Content Body text to use for response. This is ignored if a Content File is specified. This is also ignored if the interaction is NOT create, update, transaction, or operation."/>

<spacer height="5"/>

<hgroup width="40%" cellAlign="left">
<button id="btnSend" caption=" Submit " tabIndex="170" onclick="zenPage.Send();" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " tabIndex="180" onclick="zenPage.Clear();" />
</hgroup>

<spacer height="10"/>

<textarea label="Response Headers:" id="txtHeaders" rows="13" cols="80" tabIndex="190" readOnly="true" title="HTTP response status and headers" />

<spacer height="10"/>

<textarea label="Response Body:" id="txtResponse" rows="50" cols="80" tabIndex="200" readOnly="true" title="HTTP response payload"/>
</form>
</pane>
</page>
}

ClientMethod Clear() [ Language = javascript ]
{
	zen('cmbServiceRegistry').setValue("");
	zen('cmbFormat').setValue("");
	zen('cmbVersion').setValue("");
	zen('txtOAuth2Client').setValue("");
	zen('rdoInteraction').setValue("create");
	zen('txtOperation').setValue("");
	zen('chkReturnResource').setValue(0);
	zen('txtResourceType').setValue("");
	zen('txtResourceID').setValue("");
	zen('txtVersionID').setValue("");
	zen('txtParam1Name').setValue("");
	zen('txtParam1Value').setValue("");
	zen('txtParam2Name').setValue("");
	zen('txtParam2Value').setValue("");
	zen('txtParam3Name').setValue("");
	zen('txtParam3Value').setValue("");
	zen('txtHeader1Name').setValue("");
	zen('txtHeader1Value').setValue("");
	zen('txtHeader2Name').setValue("");
	zen('txtHeader2Value').setValue("");
	zen('txtContentFile').setValue("");
	zen('txtContentBody').setValue("");
	zen('txtHeaders').setValue("");
	zen('txtResponse').setValue("");
	zenPage.ClearSessionCache();
}

Method ClearSessionCache(pURL = "") As %String [ ZenMethod ]
{
	// Clear the cache for only the page-specific controls.
	set %session.Data("FHIR.Test", ..%ClassName(0), "Interaction") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "ContentFile") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "Operation") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "ReturnResource") = 0
	set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceType") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceId") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceVersion") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param1Name") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param1Value") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param2Name") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param2Value") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param3Name") = ""
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param3Value") = ""	
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Name") = ""	
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Value") = ""	
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Name") = ""	
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Value") = ""	
	
	Quit ""
}

Method OnChangeInteraction() [ ZenMethod ]
{
	Set tInteraction = %page.%GetValueById("rdoInteraction")
	If (tInteraction="create")||(tInteraction="update")||(tInteraction="transaction")||(tInteraction="operation")||(tInteraction="patch") {
		Set %page.%GetComponentById("txtContentFile").hidden="0"
		Set %page.%GetComponentById("txtContentBody").hidden="0"
	} Else {
		Set %page.%GetComponentById("txtContentFile").hidden="1"
		Set %page.%GetComponentById("txtContentBody").hidden="1"
	}
}

Method Send() [ ZenMethod ]
{
	#dim tRequest As HS.Message.FHIR.Request
	#dim tResponse As HS.Message.FHIR.Response
	#dim tServiceObj As HS.Registry.Service.HTTP
	
	Try {
		Set tSC = $$$OK
		
		Set tSC = ..CheckProduction(.tText)
		If $$$ISERR(tSC) Quit
		If $Get(tText)'="" Quit
		
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
		If tInteraction="" &js<alert('Please choose an interaction')> Quit
		
		Set tOperation = %page.%GetValueById("txtOperation")
		If (tInteraction="operation")&&(tOperation="") &js<alert('Please specify an operation, or change the interaction')> Quit
		If (tInteraction="operation")&&($Extract(tOperation)'="$") &js<alert('Operation name must begin with $')> Quit
		
		Set tResourceType = %page.%GetValueById("txtResourceType")
		Set tResourceId = %page.%GetValueById("txtResourceID")
		Set tVersionId = %page.%GetValueById("txtVersionID")
		
		If tFHIRVersion="STU3" {
			Set tResourceSchemaRoot = "HS.FHIR.vSTU3.Model.Resource"
		} Else {
			Set tResourceSchemaRoot = "HS.FHIR.vDSTU2.Model.Resource"
		}
		
		If tResourceType'="" {
			Set tSC = ##class(HS.FHIR.Utils).ValidateResourceTypeFHIR(tResourceType, tResourceSchemaRoot, .tIsValid)
			If $$$ISERR(tSC) Quit
			If 'tIsValid &js<alert('Invalid Resource Type')> Quit
		}
		
		If (tResourceType="")&&((tInteraction="create")||(tInteraction="update")||(tInteraction="read")||(tInteraction="vread")||(tInteraction="delete")||(tInteraction="history")||(tInteraction="search")) {
			&js<alert('#(tInteraction)# interaction requires Resource Type')>
			Quit
		}
		If (tResourceId="")&&((tInteraction="read")||(tInteraction="vread")||(tInteraction="delete")||(tInteraction="history")) {
			&js<alert('#(tInteraction)# interaction requires Resource ID')>
			Quit
		}
		If (tVersionId="")&&(tInteraction="vread") &js<alert('vread interaction requires Version')> Quit
		
		If (tResourceType="")&&(tResourceId'="") &js<alert('Cannot specify a resource ID without a Resource Type')> Quit
		If (tVersionId'="")&&(tResourceId="") &js<alert('Cannot specify a Resource Version without a Resource ID')> Quit
		If (tVersionId'="")&&(tInteraction'="vread") &js<alert('Resource Version valid only on vread interaction')> Quit
		If (tInteraction="conformance")&&((tResourceType'="")||(tResourceId'="")||(tVersionId'="")) {
			&js<alert('Cannot specify Resource Type, Id, or Version on conformance interaction')> Quit
		}
		
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

		If (tInteraction="create")||(tInteraction="update")||(tInteraction="transaction")||(tInteraction="operation")||(tInteraction="patch") {
			Set tRequest.ContentType = tContentType
		} Else {
			Do tRequest.SetParameter("_format", tFormat)
		}
		If tInteraction="operation" {
			Set tRequest.Interaction = tOperation
		} ElseIf tInteraction="conformance/capabilities" {
			If tFHIRVersion'="DSTU2" {
				Set tRequest.Interaction = "capabilities"
			} Else {
				Set tRequest.Interaction = "conformance"
			}
		} Else {
			Set tRequest.Interaction = tInteraction
		}
		If tOAuth2Client'="" {
			Do tRequest.AdditionalInfo.SetAt(tOAuth2Client, "OAuth2ClientName")
			Do tRequest.AdditionalInfo.SetAt(%session.SessionId, "ClientSessionId")
		}
		Set tRequest.Type = tResourceType
		Set tRequest.Id = tResourceId
		Set tRequest.VId = tVersionId
		Set tRequest.BaseURL = tServiceObj.EndPoint
		Set tRequest.FHIRVersion = tFHIRVersion
		
		Do tRequest.SetParameter(%page.%GetValueById("txtParam1Name"), %page.%GetValueById("txtParam1Value"))
		Do tRequest.SetParameter(%page.%GetValueById("txtParam2Name"), %page.%GetValueById("txtParam2Value"))
		Do tRequest.SetParameter(%page.%GetValueById("txtParam3Name"), %page.%GetValueById("txtParam3Value"))
		
		Do tRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		Do ..%SetValueById("txtHeaders", "")
		
		Do ..%SetValueById("txtResponse", "")
		
		#; The HTTP PREFER header may be set to trigger the server to echo back the resource that was saved to the database.
		Set tReturnResource = %page.%GetValueById("chkReturnResource")
		If tReturnResource=1 {
			Do tRequest.Headers.SetAt("return=representation","PREFER")
		}
		Set tHTTPHeader1Name = %page.%GetValueById("txtHeader1Name")
		Set tHTTPHeader1Value = %page.%GetValueById("txtHeader1Value")
		Set tHTTPHeader2Name = %page.%GetValueById("txtHeader2Name")
		Set tHTTPHeader2Value = %page.%GetValueById("txtHeader2Value")
		
		Set tHTTPHeader1NameU = $ZConvert(tHTTPHeader1Name,"U")
		If (tHTTPHeader1Name'="")&&(tHTTPHeader1Value'="") {
			If (tHTTPHeader1NameU="CONTENT-TYPE")||(tHTTPHeader1NameU="ACCEPT") {
				Do %page.%SetValueById("txtHeader1Value","ALREADY SET BY FHIR VERSION - IGNORED")
			} Else {
				Do tRequest.Headers.SetAt(tHTTPHeader1Value,tHTTPHeader1Name)
			}
		}
		Set tHTTPHeader2NameU = $ZConvert(tHTTPHeader2Name,"U")
		If (tHTTPHeader2Name'="")&&(tHTTPHeader2Value'="") {
			If (tHTTPHeader2NameU="CONTENT-TYPE")||(tHTTPHeader2NameU="ACCEPT") {
				Do %page.%SetValueById("txtHeader1Value","ALREADY SET BY FHIR VERSION - IGNORED")
			} Else {
				Do tRequest.Headers.SetAt(tHTTPHeader2Value,tHTTPHeader2Name)
			}
		}
		
		Set tFileInput = %page.%GetValueById("txtContentFile")
		If tFileInput'="" {
			If '##class(%Library.File).Exists(tFileInput) &js<alert('Input file does not exist')> Quit
			If ##class(%Library.File).DirectoryExists(tFileInput) &js<alert('Input file is a directory')> Quit
			If ##class(%Library.File).GetFileSize(tFileInput)=0 &js<alert('Input file is empty')> Quit
			Set tStream = ##class(%Stream.FileCharacter).%New()
			Set tSC = tStream.LinkToFile(tFileInput)
			If $$$ISERR(tSC) Quit
			Set tSC = tRequest.Payload.CopyFrom(tStream)
			If $$$ISERR(tSC) Quit
			Do tRequest.Payload.Rewind()
		} ElseIf %page.%GetValueById("txtContentBody")'="" {
			Set tSC = tRequest.Payload.Write(%page.%GetValueById("txtContentBody"))
			If $$$ISERR(tSC) Quit
			Do tRequest.Payload.Rewind()
		}
		
		Set tSC = ##class(HS.Test.Service).SendSync(tRequest, .tResponse)
		If $$$ISERR(tSC) Quit
		
		Set tHeaderString = ""
		Set tHeaderString = tHeaderString_"HTTP Status = "_tResponse.Status
		Set tHeaderString = tHeaderString_$Char(13,10)
		Set tKey = ""
		For {
			Set tHeaderValue = tResponse.Headers.GetNext(.tKey)
			If tKey="" Quit
			Set tHeaderString = tHeaderString_$Char(13,10)_tKey_" = "_tHeaderValue
		}
		Do ..%SetValueById("txtHeaders", tHeaderString)
		
		If $IsObject(tResponse) {
			Do ..%SetValueById("txtResponse", tResponse.Payload.Read($$$MaxLocalLength))
			Do tResponse.Payload.Rewind()
		}
		
		set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
		set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
		set %session.Data("FHIR.Test", 0, "FHIRVersion") = tFHIRVersion
		set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
		set %session.Data("FHIR.Test", ..%ClassName(0), "Interaction") = tInteraction
		set %session.Data("FHIR.Test", ..%ClassName(0), "ContentFile") = tFileInput
		set %session.Data("FHIR.Test", ..%ClassName(0), "Operation") = tOperation
		set %session.Data("FHIR.Test", ..%ClassName(0), "ReturnResource") = tReturnResource
		set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceType") = tResourceType
		set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceId") = tResourceId
		set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceVersion") = tVersionId
		set %session.Data("FHIR.Test", ..%ClassName(0), "Param1Name") = %page.%GetValueById("txtParam1Name")
		set %session.Data("FHIR.Test", ..%ClassName(0), "Param1Value") = %page.%GetValueById("txtParam1Value")
		set %session.Data("FHIR.Test", ..%ClassName(0), "Param2Name") = %page.%GetValueById("txtParam2Name")
		set %session.Data("FHIR.Test", ..%ClassName(0), "Param2Value") = %page.%GetValueById("txtParam2Value")
		set %session.Data("FHIR.Test", ..%ClassName(0), "Param3Name") = %page.%GetValueById("txtParam3Name")
		set %session.Data("FHIR.Test", ..%ClassName(0), "Param3Value") = %page.%GetValueById("txtParam3Value")
		if '((tHTTPHeader1NameU="CONTENT-TYPE")||(tHTTPHeader1NameU="ACCEPT")) {
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Name") = tHTTPHeader1Name
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Value") = tHTTPHeader1Value
		} else {
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Name") = ""
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Value") = ""
		}
		if '((tHTTPHeader2NameU="CONTENT-TYPE")||(tHTTPHeader2NameU="ACCEPT")) {
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Name") = tHTTPHeader2Name
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Value") = tHTTPHeader2Value
		} else {
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Name") = ""
			set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Value") = ""
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) { &js<alert('#($system.Status.GetOneErrorText(tSC))#')> }
	
	Quit
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	// Load dropdowns from parameters
	//Set tCombo.valueList=",xml,json,application/xml+fhir,application/json+fhir,application/fhir+xml,application/fhir+json"
	Set tCombo=..%GetComponentById("cmbFormat")
	Set tCombo.valueList="xml,json"
	Set tCombo.displayList=tCombo.valueList
	
	Set tCombo=..%GetComponentById("cmbVersion")
	Set tCombo.valueList="STU3,DSTU2"
	Set tCombo.displayList=tCombo.valueList
	
	set tOAuth2Client = $Get(%session.Data("FHIR.Test", 0, "OAuth2Client"))
	set tServiceName = $Get(%session.Data("FHIR.Test", 0, "ServiceName"))
	set tFHIRVersion = $Get(%session.Data("FHIR.Test", 0, "FHIRVersion"))
	set tFormat = $Get(%session.Data("FHIR.Test", 0, "FHIRFormat"))
	set tInteraction = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Interaction"))
	set tContentFile = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "ContentFile"))
	set tOperation = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Operation"))
	set tReturnResource = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "ReturnResource"))
	set tResourceType = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "ResourceType"))
	set tResourceId = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "ResourceId"))
	set tResourceVersion = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "ResourceVersion"))
	set tParam1Name = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Param1Name"))
	set tParam1Value = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Param1Value"))
	set tParam2Name = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Param2Name"))
	set tParam2Value = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Param2Value"))
	set tParam3Name = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Param3Name"))
	set tParam3Value = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Param3Value"))
	set tHeader1Name = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Header1Name"))
	set tHeader1Value = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Header1Value"))
	set tHeader2Name = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Header2Name"))
	set tHeader2Value = $Get(%session.Data("FHIR.Test", ..%ClassName(0), "Header2Value"))
	
	set %session.Data("FHIR.Test", 0, "OAuth2Client") = tOAuth2Client
	set %session.Data("FHIR.Test", 0, "ServiceName") = tServiceName
	set %session.Data("FHIR.Test", 0, "FHIRVersion") = tFHIRVersion
	set %session.Data("FHIR.Test", 0, "FHIRFormat") = tFormat
	set %session.Data("FHIR.Test", ..%ClassName(0), "Interaction") = tInteraction
	set %session.Data("FHIR.Test", ..%ClassName(0), "ContentFile") = tContentFile
	set %session.Data("FHIR.Test", ..%ClassName(0), "Operation") = tOperation
	set %session.Data("FHIR.Test", ..%ClassName(0), "ReturnResource") = tReturnResource
	set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceType") = tResourceType
	set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceId") = tResourceId
	set %session.Data("FHIR.Test", ..%ClassName(0), "ResourceVersion") = tResourceVersion
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param1Name") = tParam1Name
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param1Value") = tParam1Value
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param2Name") = tParam2Name
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param2Value") = tParam2Value
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param3Name") = tParam3Name
	set %session.Data("FHIR.Test", ..%ClassName(0), "Param3Value") = tParam3Value
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Name") = tHeader1Name
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header1Value") = tHeader1Value
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Name") = tHeader2Name
	set %session.Data("FHIR.Test", ..%ClassName(0), "Header2Value") = tHeader2Value
	
	do ..%SetValueById("txtOAuth2Client", tOAuth2Client)
	do ..%SetValueById("cmbServiceRegistry", tServiceName)
	do ..%SetValueById("cmbVersion", tFHIRVersion)
	do ..%SetValueById("cmbFormat", tFormat)
	if tInteraction="" set tInteraction="create"
	do ..%SetValueById("rdoInteraction", tInteraction)
	do ..%SetValueById("txtContentFile", tContentFile)
	do ..%SetValueById("txtOperation", tOperation)
	do ..%SetValueById("chkReturnResource", tReturnResource)
	do ..%SetValueById("txtResourceType", tResourceType)
	do ..%SetValueById("txtResourceID", tResourceId)
	do ..%SetValueById("txtVersionID", tResourceVersion)
	do ..%SetValueById("txtParam1Name", tParam1Name)
	do ..%SetValueById("txtParam1Value", tParam1Value)
	do ..%SetValueById("txtParam2Name", tParam2Name)
	do ..%SetValueById("txtParam2Value", tParam2Value)
	do ..%SetValueById("txtParam3Name", tParam3Name)
	do ..%SetValueById("txtParam3Value", tParam3Value)
	do ..%SetValueById("txtHeader1Name", tHeader1Name)
	do ..%SetValueById("txtHeader1Value", tHeader1Value)
	do ..%SetValueById("txtHeader2Name", tHeader2Name)
	do ..%SetValueById("txtHeader2Value", tHeader2Value)
	
	If (tInteraction="create")||(tInteraction="update")||(tInteraction="transaction")||(tInteraction="operation")||(tInteraction="patch") {
		Set %page.%GetComponentById("txtContentFile").hidden="0"
		Set %page.%GetComponentById("txtContentBody").hidden="0"
	} Else {
		Set %page.%GetComponentById("txtContentFile").hidden="1"
		Set %page.%GetComponentById("txtContentBody").hidden="1"
	}
	
	quit $$$OK
}

}

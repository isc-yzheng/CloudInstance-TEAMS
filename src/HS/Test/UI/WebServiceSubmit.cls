Include (HS.IHE.PDQ, HS.IHE.PIX, HS.IHE.XDSb, HS.IHE.XCA, HS.IHE.DSUB, HS.IHE.XCPD, HS.IHE.HPD)

/// 
Class HS.Test.UI.WebServiceSubmit Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Submit";

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
<page title="HealthShare Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="40"/>
<tabGroup id="tabGroup" showTabBar="true" remember="false">
<tab caption="Request" >
<vgroup layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	OnCreateResultSet="CreateServiceRegistryRS"
	onchange="zenPage.updateEndpoint(zenPage.getComponentById('cmbServiceRegistry').getValue())"
	maxRows="10000">
	<parameter/>
</dataCombo>

<!--<combobox id="cmbServiceRegistry" size='80' label="EndPoint:" dropdownWidth="800" labelClass="caption" onchange="zenPage.updateEndpoint(zenPage.getComponentById('cmbServiceRegistry').getValue())" />-->
</vgroup>
<hgroup>
<text label="Host:" id="txtHost" size="30" />
<text label="Port:" id="txtPort" size="30"  />
<text label="SSLConfig:" id="txtSSLConfig" size="30" />
</hgroup>
<vgroup layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<text label="URL:" id="txtURL" size="60" />
<combobox id="cmbAction" size='80' label="Action:" dropdownWidth="800" labelClass="caption" onchange="zenPage.updateAction()" />
<text label="Action:" id="txtAction" size="60" />
</vgroup>
<spacer height="15"/>
<textarea label="Request:" id="txtRequest" cols="90" rows="20"/>
<spacer height="25"/>
<button id="btnSend" caption=" Send " onclick="zenPage.Start('btnSend');zenPage.Send();" />
<button id="btnShowXMLRQ" caption=" Show XML " onclick="zenPage.ShowXML('txtRequest');" />
</tab>
<tab caption="Response">
<spacer height="15"/>
<textarea label="Response:" id="txtResponse" cols="90" rows="20"/>
<spacer height="25"/>
<button id="btnShowXMLRS" caption=" Show XML " onclick="zenPage.ShowXML('txtResponse');" />
<spacer height="10"/>
</tab>
</tabGroup>
<pane id="paneResults"/>
</pane>
</page>
}

Method updateEndpoint(id) [ ZenMethod ]
{
	Set %session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1))=id
	//Set tSR=##class(HS.Registry.Service.SOAP).%OpenId(id)
	Set tSR=##class(HS.Registry.Service.Abstract).EndPointForNameType(id,"SOAP")
	Set %page.%GetComponentById("txtHost").value=tSR.Host
	Set %page.%GetComponentById("txtPort").value=tSR.Port
	Set %page.%GetComponentById("txtURL").value=tSR.URL
	
	
	//this.getComponentById('txtAction').setValue(this.getComponentById('cmbAction').getValue());
}

ClientMethod updateAction() [ Language = javascript ]
{
	this.getComponentById('txtAction').setValue(this.getComponentById('cmbAction').getValue());
}

Method Send() [ ZenMethod ]
{
	try {
		/*

				
		POST /csp/connect/HS.IHE.PDQv3.Supplier.Services.cls HTTP/1.1
		User-Agent: Mozilla/4.0 (compatible; Cache;)
		Host: localhost:54321
		Accept-Encoding: gzip
		Content-Length: 2158
		Content-Type: application/soap+xml; charset=UTF-8; action="urn:hl7-org:v3:PRPA_IN201305UV02"

		<SOAP-ENV:Header>
		<wsa:Action SOAP-ENV:mustUnderstand="true">urn:hl7-org:v3:PRPA_IN201305UV02</wsa:Action>
		<wsa:From><wsa:Address>http://JAMESS-MACBOOK-PRO.LOCAL:57783/csp/healthshare/hsregistry/HS.IHE.PDQv3.Consumer.Operations.cls</wsa:Address></wsa:From>
		<wsa:MessageID>urn:uuid:ACF87B60-97B2-11E2-A88B-F6B11902FD00</wsa:MessageID><wsa:ReplyTo><wsa:Address>http://www.w3.org/2005/08/addressing/anonymous</wsa:Address></wsa:ReplyTo>
		<wsa:To>http://localhost:54321/csp/connect/HS.IHE.PDQv3.Supplier.Services.cls</wsa:To>  
		</SOAP-ENV:Header>		

		au header
		 <SOAP-ENV:Header>
			<wsa:Action>http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010/SealedMessageDelivery/deliverRequest</wsa:Action>
			<wsa:From><wsa:Address>http://www.w3.org/2005/08/addressing/anonymous</wsa:Address></wsa:From>
			<wsa:MessageID>C090BC17-1CCE-4E35-93A1-02471D4402B5</wsa:MessageID>
			<wsa:To>http://www.w3.org/2005/08/addressing/anonymous</wsa:To>
	    </SOAP-ENV:Header>
		
		*/


		Set tSC=$$$OK
		Set tRequest = %page.%GetValueById("txtRequest")
		Set tHost = %page.%GetValueById("txtHost")
		Set tPort = %page.%GetValueById("txtPort")
		Set tURL = %page.%GetValueById("txtURL")
		Set tAction = %page.%GetValueById("txtAction")
		If tHost="" || (tPort="") Do ..LogMessage("Host and port are required") Quit
		Set tSSLConfig = %page.%GetValueById("txtSSLConfig")
		Set %session.Data("IHE.Test.LastHost",..%ClassName(1))=tHost
		Set %session.Data("IHE.Test.LastPort",..%ClassName(1))=tPort
		Set %session.Data("IHE.Test.LastSSLConfig",..%ClassName(1))=tSSLConfig
		Set %session.Data("IHE.Test.LastURL",..%ClassName(1))=tURL
		Set %session.Data("IHE.Test.LastAction",..%ClassName(1))=tAction

		Set tNL=$c(13,10)
		if tRequest '[ "POST" {
			//Set %page.%GetComponentById("txtLength").value=$l(tRequest)
			//If $e(tRequest,1,10)'["<?xml" Set tRequest="<?xml version='1.0' encoding='UTF-8' ?>"_tNL_tRequest
			Set tRequest="POST "_tURL_" HTTP/1.1"_tNL_
						"User-Agent: Mozilla/4.0 (compatible; Cache;)"_tNL_
						"Host: "_tHost_":"_tPort_tNL_
						"Content-Length: "_$l(tRequest)_tNL_
						"Content-Type: application/soap+xml; charset=UTF-8; action="""_tAction_""""_tNL_tNL_tRequest
		}
		Set %session.Data("IHE.Test.LastRequest",..%ClassName(1))=$p(tRequest,tNL_tNL,2)
		
		Set tResponse=%page.%GetComponentById("txtResponse")
		Set tResponse.value=""
		//Set tResponse=##class(%Stream.GlobalBinary).%New()
		#dim socket as %IO.ServerSocket = ##class(%IO.ServerSocket).%New() 
		Set tDest=##class(%IO.Socket).%New() If '$IsObject(tDest) Do ..LogMessage("Destination socket failed") Quit
		Set tDest.SSLConfig=tSSLConfig
		If 'tDest.Open(tHost,tPort,1.5,.tSC) Do ..LogMessage("Destination socket failed to connect") Quit
		Quit:$$$ISERR(tSC)
		If 1 {
			Do tDest.Write(tRequest)
		} Else {
			Set tFile="/intersystems/dropbox/na2014/files/marvin-chunk.txt"
			Set tF=##class(%Stream.FileBinary).%New()
			Do tF.LinkToFile(tFile)
			While 'tF.AtEnd {
				Set v=tF.Read() do tDest.Write(v)
			}		
			//Do tDest.CopyFrom(tF)
		}
		Set tHadDest = 1,tMode="in",tList=$lb(tDest.Name)
		While tDest.IsOpen {
			#; see if there's any data
			Set tReady=$system.Socket.Select(tList,5)
			If tReady="" continue
			s (tIn,tOut)=""
			If tReady[tDest.Name Set tIn=tDest.Read(,0,.tSCin)
			#; Write to both sockets
			//Do:""'=tOut tDest.Write(tOut,,.tSCoutW),tLog.InputStream.Write(tOut)
			If ""'=tIn Set tResponse.value=tResponse.value_tIn
			Quit:tIn["</SOAP-ENV:Envelope>"
			#; save each read in case an external program wants to track our progress
			//Set tSC=tLog.%Save() If $$$ISERR(tSC) Quit
			#; %Save resets the Streams, we need to MoveToEnd
			//Do tLog.InputStream.MoveToEnd(),tLog.OutputStream.MoveToEnd()
		}
	} catch ex {
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","HTML"))
	}
	&js<zen('btnSend').setProperty('disabled',false);
	zenPage.hsResetAutoLogout();
	>
	Quit $$$OK
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tHost=$G(%session.Data("IHE.Test.LastHost",..%ClassName(1)))
	Set tPort=$G(%session.Data("IHE.Test.LastPort",..%ClassName(1)))
	Set tURL=$G(%session.Data("IHE.Test.LastURL",..%ClassName(1)))
	Set tAction=$G(%session.Data("IHE.Test.LastAction",..%ClassName(1)))
	Set tSSLConfig=$G(%session.Data("IHE.Test.LastSSLConfig",..%ClassName(1)))
	Set %page.%GetComponentById("txtHost").value=tHost
	Set %page.%GetComponentById("txtPort").value=tPort
	Set %page.%GetComponentById("txtSSLConfig").value=tSSLConfig
	Set %page.%GetComponentById("txtURL").value=tURL
	Set %page.%GetComponentById("txtAction").value=tAction
	Set tLastRequest = $g(%session.Data("IHE.Test.LastRequest",..%ClassName(1)))
	Set:tLastRequest="" tLastRequest = "<soap:Envelope xmlns:soap=""http://www.w3.org/2003/05/soap-envelope"">"_$c(13)_"<soap:Header/>"_$c(13)_"<soap:Body> "_$c(13,13)_"</soap:Body>"_$c(13)_"</soap:Envelope>"
	Set %page.%GetComponentById("txtRequest").value=tLastRequest
	Do ..AddActions()
	Do ..AddServiceEntries()

	Quit $$$OK
}

Method AddActions()
{
	#define addAction(%combo,%name,%value) Set value=$zcvt(%value,"O","HTML"),tOption = ##class(%ZEN.Auxiliary.option).%New(),tOption.text = %name,tOption.value = value Do %combo.options.Insert(tOption),..%AddComponent(tOption)

	#dim tAction as %ZEN.Component.combobox = ..%GetComponentById("cmbAction")
	$$$addAction(tAction,"PDQ",$$$PDQv3QueryAction(1))
	$$$addAction(tAction,"PDQ Continue",$$$PDQv3ContinueAction(1))
	$$$addAction(tAction,"PDQ Cancel",$$$PDQv3CancelAction(1))
	$$$addAction(tAction,"PIX Add",$$$PIXv3AddAction(1))
	$$$addAction(tAction,"PIX Revise",$$$PIXv3ReviseAction(1))
	$$$addAction(tAction,"PIX Merge",$$$PIXv3MergeAction(1))
	$$$addAction(tAction,"PIX Query",$$$PIXv3QueryAction(1))
	$$$addAction(tAction,"XDSb Query",$$$XDSbQueryAction(1))
	$$$addAction(tAction,"XDSb Query Multi-Patient",$$$XDSbQueryMultiPatientAction(1))
	$$$addAction(tAction,"XDSb Register",$$$XDSbRegisterAction(1))
	$$$addAction(tAction,"XDSb Update Document Set",$$$XDSbUpdateDocumentSetAction(1))
	$$$addAction(tAction,"XDSb Delete Document Set",$$$XDSbDeleteDocumentSetAction(1))
	$$$addAction(tAction,"XDSb Register OnDemand",$$$XDSbRegisterOnDemandAction(1))
	$$$addAction(tAction,"XDSb Provide and Register",$$$XDSbProvideAndRegisterAction(1))
	$$$addAction(tAction,"XDSb Retrieve",$$$XDSbRetrieveAction(1))
	$$$addAction(tAction,"DSUB Subscribe",$$$DSUBSubscribeRequestAction(1))
	$$$addAction(tAction,"DSUB Unsubscribe",$$$DSUBUnsubscribeRequestAction(1))
	$$$addAction(tAction,"XCA Query",$$$XCAQueryAction(1))
	$$$addAction(tAction,"XCA Retrieve",$$$XCARetrieveAction(1))
	$$$addAction(tAction,"XCPD Query",$$$XCPDPatientDiscoveryAction(1))
	$$$addAction(tAction,"HPD Query",$$$HPDQueryAction)
}

}

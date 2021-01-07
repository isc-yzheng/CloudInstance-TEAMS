Include Ensemble

/// 
/// 
/// This a template page that provides a standard
/// template for subclasses within the ICE IHE Test application
Class HS.Test.UI.Main Extends HS.HC.UI.Util [ CompileAfter = HS.Test.UI.Menu ]
{

Parameter HSDEPLOY = 0;

Parameter RESOURCE = "%HS_TestSuite";

Parameter SERVICEREGISTRYENTRY;

/// Class name of application this page belongs to.
Parameter APPLICATION = "HS.UI.Application";

/// Displayed name of this page.
Parameter PAGENAME = "MainPage";

Parameter TESTSERVICENAME = "IHE.Test";

Parameter TESTSERVICEPORT = 54321;

Parameter SINGLETAB = 1;

Property IsConnectathon As %Boolean [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\IHE\Connectathon",0)=1} ];

Property TESTGROUPID As %String(ZENURL = "TestGroupID");

/// Which business host to send this request to, versus updating the HS.Test.Service code
Parameter TARGETHOST As %String;

/// Domain used for localization.
/// Parameter DOMAIN = "";
/// Define the title that will be displayed within subclasses
Property StdTitle As %ZEN.Datatype.string [ InitialExpression = {..#PAGENAME} ];

/// Title displayed within this pane.
Property title As %ZEN.Datatype.caption;

/// Category displayed within this pane (above the title).
Property category As %ZEN.Datatype.caption [ InitialExpression = "Intersystems Implementation" ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* default styles */
body {
	background: #FFFFE0;
	font-family: verdana;
	min-height: 500px
}

.pageTitle {
	color: black;
	background: #c5d6d6;
	background-image: url(images/titlegradient.png);
	background-repeat: repeat-y;
	background-position: right;
	width: 100%;
	padding: 0px;
	border-bottom: 1px solid darkblue;
	font-size: 1.4em;
	font-family: verdana;
	text-align: center;
}

table.iheTestTitle {
	color: black;
	background: #c5d6d6;
	width: 100%;
	padding: 0px;
	margin: 0px;
	border-bottom: 1px solid darkblue;
	font-size: 1.4em;
	font-family: verdana;
	text-align: center;
}

.text {
	  border: 1px inset threedface;
}

.comboboxInput {
	  border: 1px inset threedface;
}

.menuTable {
	background: rgb(47,98,128);
	width: 100%;
	height: 100%;
	border: 0px;
}

a.menuItem {
	color: white;
	padding-top: 20px;
	padding-left: 0px;
	padding-right: 0px;
	border: 0px;
	margin: 1px;
	text-align: left;
	width:230px
}

a.menuItem:hover {
	color:#000000;
	background: #71AFBC;
	padding-top: 20px;
	padding-left: 0px;
	padding-right: 0px;
	border: 0px;
	margin: 1px;
	text-align: left;
	width:230px
}

a.menuItemSelected {
	background: #FFFFA0;
	color: rgb(47,98,128);
	padding-top: 20px;
	padding-left: 0px;
	padding-right: 0px;
	border: 0px;
	margin: 1px;
	text-align: left;
	width:230px
}

a.menuItemSelected:hover {
	color:#000000;
	background: #71AFBC;
	padding-top: 20px;
	padding-left: 0px;
	padding-right: 0px;
	border: 0px;
	margin: 1px;
	text-align: left;
	width:230px
}

/* body of tab group */
.tabGroupBody {
	background: #FFFFE0;
	padding-left: 20px;
	font-family: verdana;
	min-height: 500px
}

iframe.Body {
	background: #FFFFE0;
	padding-left: 20px;
	font-family: verdana;
	min-height: 500px
}

/* selected tab */
td.tabGroupButtonOn {
	background: #FFFFE0;
	color: rgb(47,98,128);
}

/* div for tab group */
#tabGroup {
	height: 100%;
	width: 100%;
}

iframe {
	height: 750px;
	width: 1000px;
	scroll: auto;
}

/* form field styles */
/*
.zenLabel {
	font-family: verdana;
	font-size: 0.8em;
	padding-right: 0px;
}
*/
/* checkbox styles */
.checkboxCaption {
	font-family: verdana;
	font-size: 0.8em;
	padding-right: 0px;
}

</style>
}

/// This XML block defines the contents of this page.
/// There are 4 main panes defined for the standard page:
/// menu	table
/// message	details
/// The contents of these panes are provided by subclasses.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen">
<html id="title" OnDrawContent="DrawTitle" seed="Test Utility"/>
<hgroup>
<vgroup valign="top"   >
<pane paneName="menuPane"/>
</vgroup>
<spacer width="20"/>
<vgroup valign="top">
<tabGroup id="topTabGroup" showTabBar="true" remember="true">
<tab id="frameTab1" caption='Configuration' height="1500px" width="900px" >
<iframe id="frame1" src="HS.Test.UI.Config.cls"/>
</tab>
</tabGroup>
</vgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of the menu pane.
XData menuPane
{
<pane id="sideMenu" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<lookoutMenu id="lookout" expandable="false" height="600" width="250" remember="true">
<tab caption="Main" id="menuMain">
<menuItem caption="Configuration" onclick="zenPage.ShowItem('HS.Test.UI.Config.cls','Configuration')"/>
<menuItem caption="History" onclick="zenPage.ShowItem('HS.Test.UI.History.cls','History')"/>
<menuItem id="menuMainAttachment" hidden="true" caption="Attachment Viewer" onclick="zenPage.MessageView()" />
<menuItem caption="EndPoints" onclick="zenPage.ShowItem('HS.UI.Registry.Services.cls?HideMenu=1','Endpoints')"  />
<menuItem caption="Trace" onclick="zenPage.ShowItem('/csp/sys/TCPTrace.LogUI.cls','Trace')"  />
<menuItem caption="WS Submit" onclick="zenPage.ShowItem('HS.Test.UI.WebServiceSubmit.cls','Web Service Submit')"  />
</tab>
<tab caption="PIX and PDQ" id="menuPIXPDQ">
<menuItem caption="Patient Add" onclick="zenPage.ShowItem('HS.Test.UI.PIXAdd.cls','PIX Add');"/>
<menuItem caption="Patient Search (PIX)" onclick="zenPage.ShowItem('HS.Test.UI.PIXQuery.cls','PIX Search');"/>
<menuItem caption="Patient Search (PDQ)" onclick="zenPage.ShowItem('HS.Test.UI.PDQ.cls','PDQ');"/>
<menuItem caption="Patient Merge" onclick="zenPage.ShowItem('HS.Test.UI.PIXMerge.cls','PIX Merge');"/>
</tab>
<tab caption="XDSb" id="menuXDSb">
<menuItem caption="Query" onclick="zenPage.ShowItem('HS.Test.UI.XDSbRSQ.cls','XDSb Search')" />
<menuItem caption="Retrieve" onclick="zenPage.ShowItem('HS.Test.UI.XDSbRetrieve.cls','XDSb Retrieve')" />
<menuItem caption="Provide &amp; Register" onclick="zenPage.ShowItem('HS.Test.UI.XDSbPnR.cls','XDSb Provide And Register')" />
<menuItem id="menuXDSbMU" hidden="true" caption="Metadata Update" onclick="zenPage.ShowItem('HS.Test.UI.XDSbMU.cls','Metadata Update')" />
<menuItem id="menuXDSbDelete" caption="Delete Documents" onclick="zenPage.ShowItem('HS.Test.UI.XDSbDelete.cls','Delete Documents')" />
<menuItem id="menuXDSbOnDemand" hidden="true" caption="OnDemand" onclick="zenPage.ShowItem('HS.Test.UI.OnDemand.cls','XDSb OnDemand')" />
</tab>
<tab caption="XDM" id="menuXDM">
<menuItem caption="XDM Creator" onclick="zenPage.ShowItem('HS.Test.UI.XDMCreator.cls','XDM Creator')" />
</tab>
<tab caption="DSUB" id="menuDSUB">
<menuItem caption="DSUB" onclick="zenPage.ShowItem('HS.Test.UI.DSUB.cls','DSUB')" />
</tab>
<tab caption="XCPD" id="menuXCPD">
<menuItem caption="XCPD Query" onclick="zenPage.ShowItem('HS.Test.UI.XCPDQuery.cls','XCPD Query')" />
</tab>
<tab caption="Australian" id="menuAU">
<menuItem id='IHISearch' caption="IHI Search" onclick="zenPage.ShowItem('HS.Test.UI.AU.IHISearch.cls','IHI Search')"/>
<menuItem id='CreateProvisionalIHI' caption="Create Provisional IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.CreateProvisionalIHI.cls','Create Provisional IHI')"/>
<menuItem id='CreateUnverifiedIHI' caption="Create Unverified IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.CreateUnverifiedIHI.cls','Create Unverified IHI')"/>
<menuItem id='UpdateIHI' caption="Update IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.UpdateIHI.cls','Update IHI')"/>
<menuItem id='MergeProvisionalIHI' caption="Merge Provisional IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.MergeProvisionalIHI.cls','Merge Provisional IHI')"/>
<menuItem id='NotifyDuplicateIHI' caption="Notify Duplicate IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.NotifyDuplicateIHI.cls','Notify Duplicate IHI')"/>
<menuItem id='NotifyReplicaIHI' caption="Notify Replica IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.NotifyReplicaIHI.cls','Notify Replica IHI')"/>
<menuItem id='UpdateProvisionalIHI' caption="Update Provisional IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.UpdateProvisionalIHI.cls','Update Provisional IHI')"/>
<menuItem id='ResolveProvisionalIHI' caption="Resolve Provisional IHI" onclick="zenPage.ShowItem('HS.Test.UI.AU.ResolveProvisionalIHI.cls','Resolve Provisional IHI')"/>
<menuItem id='IHIBatchSearch' caption="IHI Batch Search" onclick="zenPage.ShowItem('HS.Test.UI.AU.IHIBatchSearch.cls','IHI Batch Search')"/>
<menuItem id='DoesPCEHRExist' caption="Does PCEHR Exist" onclick="zenPage.ShowItem('HS.Test.UI.AU.DoesPCEHRExist.cls','Does PCEHR Exist')"/>
<menuItem id='GainPCEHRAccess' caption="Gain PCEHR Access" onclick="zenPage.ShowItem('HS.Test.UI.AU.GainPCEHRAccess.cls','Gain PCEHR Access')"/>

<menuItem id='RemoveDocument' caption="Remove PCEHR Document" onclick="zenPage.ShowItem('HS.Test.UI.AU.RemoveDocument.cls','Remove an existing PCEHR Document')"/>
<menuItem caption="XDSb Query" onclick="zenPage.ShowItem('HS.Test.UI.AU.XDSbRSQ.cls','XDSb Search')" />
<menuItem caption="XDSb Retrieve" onclick="zenPage.ShowItem('HS.Test.UI.AU.XDSbRetrieve.cls','XDSb Retrieve')" />
<menuItem caption="XDSb Provide &amp; Register" onclick="zenPage.ShowItem('HS.Test.UI.AU.XDSbPnR.cls','XDSb Provide and Register')" />

</tab>
<tab caption="PIX and PDQ (FHIR)" id="menuFHIRPIX">
<menuItem caption="Patient Search (PIXm)" onclick="zenPage.ShowItem('HS.Test.UI.PIXmQuery.cls','PIXm Search');"/>
<menuItem caption="Patient Search (PDQm)" onclick="zenPage.ShowItem('HS.Test.UI.PDQm.cls','PDQm Search and Retrieve');"/>
</tab>
<tab caption="MHD (FHIR)" id="menuFHIRMHD">
<menuItem caption="Find Manifests" onclick="zenPage.ShowItem('HS.Test.UI.MHDFindManifests.cls','MHD Find Document Manifests');"/>
<menuItem caption="Find References" onclick="zenPage.ShowItem('HS.Test.UI.MHDFindReferences.cls','MHD Find Document References');"/>
<menuItem caption="Retrieve" onclick="zenPage.ShowItem('HS.Test.UI.MHDRetrieve.cls','MHD Retrieve');"/>
<menuItem caption="Provide Document Bundle" onclick="zenPage.ShowItem('HS.Test.UI.MHDProvide.cls','MHD Provide Document Bundle')" />
</tab>

</lookoutMenu>
</pane>
}

XData serviceRegistry [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	sql="SELECT ID,Name FROM HS_Registry_Service.Abstract WHERE ((? is null) or %UPPER(name) [ %UPPER(?)) and not(Name LIKE 'SYNC.%' or Name LIKE 'IHE.Test.%') ORDER BY Name"
	sqlLookup="SELECT Name FROM HS_Registry_Service.Abstract WHERE ID =?"
	editable="true"
	searchKeyLen="10"
	maxRows="10000"
/>
}

XData asyncPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<timer id="timer" ontimeout="zenPage.timeout();" timeout="0"/>
<text id="txtTimerCount" hidden="true"/>
<text id="txtTimerSearchID" hidden="true"/>
<text id="txtTimerSessionID" hidden="true"/>
<label id="lblTimerTicks"/>
<text id="txtGroupID" hidden="true"/>
<text id="txtTestID" hidden="true"/>
</pane>
}

Method ShowXML(objName) [ ZenMethod ]
{
	Set taObject = %page.%GetValueById(objName)
	If taObject="" &js<alert('nothing to show');> Quit
	Set tTestServiceName=$g(%session.Data("IHE.Test","TestServiceName"),..#TESTSERVICENAME)
	Set ^CacheTemp.TestUI(tTestServiceName)=taObject
	Set tURL="HS.Test.UI.XMLViewer.cls?ID="_tTestServiceName
	&js<window.open("#(tURL)#");>
}

Method AddErrorToResultsPane(tSC As %Status = "", pClear = 1)
{
	set results=%page.%GetComponentById("paneResults")
	Do:pClear results.%RemoveChildren()
	Set label=##class(%ZEN.Component.label).%New()
	Set label.label=$system.Status.GetErrorText(tSC)
	Do results.%AddChild(label)
}

ClientMethod MessageView() [ Language = javascript ]
{
	var message = prompt('Message ID: ');
	if (message==null) return;
	if(message!='') {
		var url="HS.Test.UI.XMLMessage.Viewer.cls?MSG="+message
		window.open(url);
	}
}

ClientMethod StartSend(pButton, pURL = "") [ Language = javascript ]
{
	// Clear out any existing Group/Search IDs to prevent subsequent searches from reusing prior search data
	zenPage.hsResetAutoLogout();
	var txtGroupID = zenPage.getComponentById('txtGroupID')
	txtGroupID.setProperty("value",'');
	var txtTimerSearchID = zenPage.getComponentById('txtTimerSearchID')
	txtTimerSearchID.setProperty("value",'');
	
	zenPage.ToggleButton(pButton,1);
	var SearchId = zenPage.Send(pURL);
	if(SearchId=='Failed') {
		return;
	}
	if(SearchId == '') {
		zenPage.ToggleButton(pButton,0);
	} else {
		zenPage.timeout();
	}
}

ClientMethod jsShowItem(pItem, pText) [ Language = javascript ]
{
	zenPage.hsResetAutoLogout();
	zenPage.ShowItem(pItem,pText);
}

Method ShowItem(pItem, pText) [ ZenMethod ]
{
	try {
		#dim tg as %ZEN.Component.tabGroup
		Set tg=%page.%GetComponentById("topTabGroup")
		Set tab="",tSelection=""
		If ..#SINGLETAB {
			Do tg.children.Clear()
			Set tSelection=1
		} Else {
			For tIdx=1:1:tg.children.Count() {
				Set tItem=tg.children.GetAt(tIdx)
				if tItem.caption=pText Set tab=tItem,tSelection=tIdx Quit
			}
		}
		If tab="" {
			Set tab = ##class(%ZEN.Component.tab).%New()
			Set tab.caption=pText
			Set tFrame=##class(%ZEN.Component.iframe).%New()
			Set tFrame.src=pItem
			Do tab.%AddChild(tFrame)
			Do tg.%AddChild(tab)
			Set tSelection=tg.children.Count()
		}
		If tg.children.Count()=1 {
			Do tab.%Activate()
		} Else {
			&js<setTimeout(function(){zenPage.getComponentById('topTabGroup').showTab(#(tSelection)#)},100);>
		}
	} catch ex {
	}
}

Method DrawTitle(pSeed As %String) As %Status
{
	do %application.DrawTitle(pSeed)
	Quit $$$OK
}

Method AddServiceRegistryEntries(tDefaultEntry = "", tDeviceFunction = "")
{
	try {
		Set tSC=$$$OK
		Set tEntry=$G(%session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1)))
		Set:tEntry="" tEntry=tDefaultEntry
		#dim tServiceRegistry as %ZEN.Component.combobox
		Set tServiceRegistry = ..%GetComponentById("cmbServiceRegistry")
		If tDeviceFunction'="" Set tParams("DeviceFunction")=tDeviceFunction
		#; If someday we decide to limit the types of Services, then set tParams("Type") = vertical bar delimited list of Types (SOAP, TCP, etc.)
		Set tSC = ##Class(HS.Util.ContextSearch).ServiceNameItemsByParam("","",.tItems,.tParams)
		If $$$ISERR(tSC) {
			Set tError = $system.Status.GetErrorText(tSC)
			Set tError = $ZCVT(tError,"O","HTML")
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Set tOption.text = tError
			Set tOption.value = tError
			Do tServiceRegistry.options.Insert(tOption)
			Do ..%AddComponent(tOption)
			Quit
		}
		Set tItems=$O(tItems(""),-1)
		For tIdx=1:1:tItems {
			If tItems(tIdx)="IHE.Test" Continue
			If tItems(tIdx)=tDefaultEntry Set tSelected=tIdx
			Set tOption = ##class(%ZEN.Auxiliary.option).%New()
			Set tOption.text = tItems(tIdx)
			Set tOption.value = tItems(tIdx)
			Do tServiceRegistry.options.Insert(tOption)
			Do ..%AddComponent(tOption)

		}
		Set tServiceRegistry.value = tEntry
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method AddServiceEntries(pDefaultEntry = "", pRegistryCombo = "cmbServiceRegistry")
{
	try {
		Set tSC=$$$OK
		Set tEntry=$G(%session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1)))
		#dim tServiceRegistry as %ZEN.Component.combobox = ..%GetComponentById(pRegistryCombo)
		Set tSelected=""
		Set tResult = ##class(%SQL.Statement).%ExecDirect("","SELECT ID,Name FROM HS_Registry_Service.Abstract WHERE not(Name LIKE 'SYNC.%' or Name LIKE 'IHE.Test.%') ORDER BY Name")
		Set tOption = ##class(%ZEN.Auxiliary.option).%New()
		Set tOption.text = ""
		Set tOption.value = ""
		Do tServiceRegistry.options.Insert(tOption)
		Do ..%AddComponent(tOption)
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

ClassMethod GetLastTraceEntryLogged() As %Integer
{
	New $namespace
	Set $namespace="%SYS"
	Quit $G(^TCPTrace.LogD)
}

ClassMethod GetLastTrace(pHost, pPort, pTxtRequest, pTxtResponse, pLastEntry) As %Status
{
	New $namespace
	Set $namespace="%SYS"
	&sql(SET TRANSACTION ISOLATION LEVEL READ COMMITTED)
	For tIdx=1:1:10 {
		Set tRS = ##class(%SQL.Statement).%New()
		Set tResult= tRS.%ExecDirect("","select top 1 ID from TCPTrace.Log where outboundaddress=? and OutboundPort=? and id>? order by id desc",pHost,pPort,pLastEntry)
		If tResult.%Next() {
			Set tObj=##class(TCPTrace.Log).%OpenId(tResult.ID)
			set %page.%GetComponentById(pTxtRequest).value=tObj.InputStream.Read(3000000)
			set %page.%GetComponentById(pTxtResponse).value=tObj.OutputStream.Read(3000000)
			Quit
		}
		Hang .5
	}
	Quit $$$OK
}

ClassMethod GetTraceID(pHost, pPort, pInboundPort, pLastEntry) As %String
{
	New $namespace
	Set $namespace="%SYS",tID=""
	For tIdx=1:1:10 {
		Set tRS = ##class(%SQL.Statement).%New()
		Set tResult= tRS.%ExecDirect("","select top 1 ID from TCPTrace.Log where outboundaddress=? and OutboundPort=? and InboundPort=? and id>? order by id",pHost,pPort,pInboundPort,pLastEntry)
		If tResult.%Next() {
			Set tID=tResult.ID
			Quit
		}
		Hang .5
	}
	Quit tID
}

ClassMethod GetLastTraceID(pHost, pPort, pLastEntry) As %String
{
	New $namespace
	Set $namespace="%SYS",tID=""
	For tIdx=1:1:10 {
		Set tRS = ##class(%SQL.Statement).%New()
		Set tResult= tRS.%ExecDirect("","select top 1 ID from TCPTrace.Log where outboundaddress=? and OutboundPort=? and id>? order by id desc",pHost,pPort,pLastEntry)
		If tResult.%Next() {
			Set tID=tResult.ID
			Quit
		}
		Hang .5
	}
	Quit tID
}

Method GetServiceRegistryEntry() As HS.Registry.Service.Abstract
{
	Quit:'$isObject(%page.%GetComponentById("cmbServiceRegistry")) ""
	Set tServiceName=%page.%GetComponentById("cmbServiceRegistry").value
	Set tType=$S(%page.%GetValueByName("version")="v2":"TCP",%page.%GetValueByName("version")="v3":"SOAP",1:"HTTP")
	Quit ##class(HS.Registry.Service.Abstract).EndPointForNameType(tServiceName,tType)
}

Method Execute(pTest As HS.Test.UI.Test, pGroup As HS.Test.UI.TestGroup = "", pRegistryCombo = "cmbServiceRegistry") As %Status
{
	// MIKE NA2014 - add pRegistryCombo so MU tests can support one enpoint for query and another for admin calls
	try {
		Set tSC=$$$OK
		Set tRequest=pTest.Request
		Set tUseTrace=pTest.LogTransaction
		Set pTest.Status=$$$OK

		#; not all requests have requesting user
		try { Set:tRequest.RequestingUser="" tRequest.RequestingUser=$g(%session.Data("IHE.Test","SAMLUsername")) Set:tRequest.RequestingUserRoles="" tRequest.RequestingUserRoles="%All" } catch ex {}
		#; not all requests have saml data user
		try { Set:tRequest.SAMLData.UserName="" tRequest.SAMLData.UserName=$g(%session.Data("IHE.Test","SAMLUsername")) Set:tRequest.SAMLData.HSRoles="" tRequest.SAMLData.HSRoles="%All" } catch ex {}

		Set tServiceID = ..GetServiceRegistryID(pRegistryCombo)
		Do:tServiceID pTest.ServiceSetObjectId(tServiceID)
		Set tServiceObject=pTest.Service
		If $isObject(tServiceObject) {
			Set %session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1))=tServiceObject.%Id()
			If tServiceObject.Type="SOAP" {
				Do ..LogMessage("Service URL:"_tServiceObject.EndPoint,pGroup)
			} ElseIf tServiceObject.Type="TCP" {
				Do ..LogMessage("Service:"_tServiceObject.Host_":"_tServiceObject.Port,pGroup)
			}
			if tUseTrace {
				Set tSC= ..GetNewTestService(tServiceObject,.tNewServiceObject)
				If $$$ISERR(tSC) {
					Set pTest.Status=tSC
					Quit
				} Else {
					Set tServiceObject=tNewServiceObject
				}
			}
		}
		Do:$isObject(tServiceObject) tRequest.AdditionalInfo.SetAt(tServiceObject.Name,"ServiceName")
		Set tSC = ..CheckProduction()
		If $$$ISERR(tSC) Set pTest.Status=tSC Quit
		Set tLastEntry = ..GetLastTraceEntryLogged()
		set tSC= ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionId)
		Set pTest.SessionId=tSessionId
		Set pTest.Response=tResponse
		Set pTest.Status=tSC
		// TODO: GetLastTrace unconditionally returns $$$OK, so moved the call down here.
		Set:tUseTrace pTest.TransactionLogID=..GetLastTraceID(pTest.Service.Host,pTest.Service.Port,tLastEntry)
		do:$isObject(pGroup) pGroup.%Save()
	} catch ex {
		Set tSC=ex.AsStatus()
		Set pTest.Status=tSC

	}
	Do:$IsObject(pGroup) pGroup.%Save()

	Quit tSC
}

Method ExecuteAsync(pTest As HS.Test.UI.Test, pGroup As HS.Test.UI.TestGroup = "", pServiceRegistry = "cmbServiceRegistry") As %String [ ZenMethod ]
{
	try {
		Set tSC=$$$OK
		Set tRequest=pTest.Request
		Set tUseTrace=pTest.LogTransaction
		Set tTestItemNumber = pGroup.Tests.Count()  // get the item in the list before doing anything (top)
		Set pTest.Status=$$$OK
		#; not all requests have requesting user
		try { Set:tRequest.RequestingUser="" tRequest.RequestingUser=$g(%session.Data("IHE.Test","SAMLUsername")) Set:tRequest.RequestingUserRoles="" tRequest.RequestingUserRoles="%All" } catch ex {}
		#; not all requests have saml data user
		try { Set:tRequest.SAMLData.UserName="" tRequest.SAMLData.UserName=$g(%session.Data("IHE.Test","SAMLUsername")) Set:tRequest.SAMLData.HSRoles="" tRequest.SAMLData.HSRoles="%All" } catch ex {}
		
		Set tServiceID = ..GetServiceRegistryID(pServiceRegistry)
		//Set tServiceCombo = %page.%GetComponentById("cmbServiceRegistry").value
		Do:tServiceID pTest.ServiceSetObjectId(tServiceID)
		Set tServiceObject=pTest.Service
		If $isObject(tServiceObject) {
			Set %session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1))=tServiceObject.%Id()
			Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry")=tServiceObject.Name
			
			If tServiceObject.Type="SOAP" {
				Do ..LogMessage("Service URL:"_tServiceObject.EndPoint,pGroup)
			} ElseIf tServiceObject.Type="TCP" {
				Do ..LogMessage("Service:"_tServiceObject.Host_":"_tServiceObject.Port,pGroup)
			} ElseIf tServiceObject.Type="HTTP" {
				Do ..LogMessage("Service:"_tServiceObject.Host_":"_tServiceObject.Port,pGroup)
			}
			if tUseTrace {
				Set tSC= ..GetNewTestService(tServiceObject,.tNewServiceObject)
				If $$$ISERR(tSC) {
					Set pTest.Status=tSC
					Quit
				} Else {
					Set tServiceObject=tNewServiceObject
				}
			}
		}
		Do:$isObject(tServiceObject) tRequest.AdditionalInfo.SetAt(tServiceObject.Name,"ServiceName")
		Set tSC = ..CheckProduction()
		If $$$ISERR(tSC) Set pTest.Status=tSC Quit
		Set tLastEntry = ..GetLastTraceEntryLogged()
		set tSC= ##class(HS.Test.Service).SendAsync(tRequest,.tSearchId)
		Set pTest.Status=tSC
		Set:tUseTrace pTest.TransactionLogID=..GetTraceID(pTest.Service.Host,pTest.Service.Port,tServiceObject.Port,tLastEntry)
		If 'pGroup.%Id() {
			Set tSC=pGroup.%Save()
			If $$$ISERR(tSC) {
				&js<alert('Error saving group: #($zcvt($system.Status.GetErrorText(tSC),"O","JS"))#');>
				Set %page.%GetComponentById("txtTimerSearchID").value="Failed"
				Quit
			}
		}
		Quit:$$$ISERR(tSC)
		Set %page.%GetComponentById("txtTimerSearchID").value=tSearchId
		Set %page.%GetComponentById("txtGroupID").value=pGroup.%Id()
		Set %page.%GetComponentById("txtTestID").value=tTestItemNumber  // get the item in the list before doing anything (top)
	} catch ex {
		Set tSC=ex.AsStatus()
		Set pTest.Status=tSC
		&js< alert('#($zcvt($system.Status.GetErrorText(tSC),"O","JS"))#');>
	}
	If $IsObject(pGroup) {
		Set tSC=pGroup.%Save()
		If $$$ISERR(tSC) {
			&js<alert('Error saving group: #($zcvt($system.Status.GetErrorText(tSC),"O","JS"))#');>
		}
	}
	//Do:$IsObject(pGroup) pGroup.%Save()
	Quit $S($$$ISOK(tSC):tSearchId,1:"")
}

Method ExecuteEntry(pRequest, ByRef pResponse = "", ByRef pSessionId, pUseTrace = 1) As %Status
{
	try {
		// TODO: This doesn't seem to clear the text out of the pane, no matter where this code is placed.
		#dim results as %ZEN.Component.pane
		set results=%page.%GetComponentById("paneResults")
		Do results.%RemoveChildren()

		#; not all requests have requesting user
		try { Set pRequest.RequestingUser=$g(%session.Data("IHE.Test","SAMLUsername")),pRequest.RequestingUserRoles="%All" } catch ex {}
		#; not all requests have saml data user
		try { Set pRequest.SAMLData.UserName=$g(%session.Data("IHE.Test","SAMLUsername")),pRequest.SAMLData.HSRoles="%All" } catch ex {}
		Set tHasService = $isObject(%page.%GetComponentById("cmbServiceRegistry"))
		if tHasService {
			if pUseTrace {
				Set tSC= ..GetTestService(.tServiceName,.tHost,.tPort,.tTestServiceName,.tTestServiceHost,.tTestServicePort)
				If $$$ISOK(tSC) {
					Set %session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1))=tServiceName
					Do pRequest.AdditionalInfo.SetAt(tTestServiceName,"ServiceName")
				} Else {
					Do ..AddErrorToResultsPane(tSC)
					Quit
				}
			} Else {
				Set tServiceName=%page.%GetComponentById("cmbServiceRegistry").value
				Do pRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
			}
		}
		Set tSC = ..CheckProduction()
		If $$$ISERR(tSC) Do ..AddErrorToResultsPane(tSC) Quit
		Set tLastEntry = ..GetLastTraceEntryLogged()
		set tSC= ##class(HS.Test.Service).SendSync(pRequest,.pResponse,,.pSessionId)
		If $$$ISERR(tSC) {
			Do ..AddErrorToResultsPane(tSC)
			If %page.%GetComponentById("txtResponse").value="" set %page.%GetComponentById("txtResponse").value=$system.Status.GetErrorText(tSC)
			Quit
		}
		If '$IsObject(pResponse) {
			Do ..AddErrorToResultsPane($$$ERROR($$$GeneralError,"No response object"),0)
			if %page.%GetComponentById("txtResponse").value="" set %page.%GetComponentById("txtResponse").value="No response object"
			Quit
		}
		// TODO: GetLastTrace unconditionally returns $$$OK, so moved the call down here.
		Set:tHasService tSC = ..GetLastTrace(tHost,tPort,"txtRequest","txtResponse",tLastEntry)
	} catch ex {
		Set tSC=ex.AsStatus()
	}

	Quit tSC
}

/// Given a TestService object create a Test.IHE.{username} service entry and return it in pServiceObject
Method GetNewTestService(pServiceObject As HS.Registry.Service.Abstract, ByRef pNewServiceObject As HS.Registry.Service.Abstract) As %Status
{
	try {
		Set tSC=$$$OK
		Set tTestServiceName=$g(%session.Data("IHE.Test","TestServiceName"),..#TESTSERVICENAME)
		Set tTestServicePort=$g(%session.Data("IHE.Test","TestServicePort"),..#TESTSERVICEPORT)
		Set tSC = ..CreateTraceEntry(pServiceObject,tTestServiceName,tTestServicePort)
		Quit:$$$ISERR(tSC)
		Set tChange=0
				
		Set pNewServiceObject=##class(HS.Registry.Service.Abstract).EndPointForNameType(tTestServiceName,pServiceObject.Type)
		If '$IsObject(pNewServiceObject) {
			Set pNewServiceObject=pServiceObject.%ConstructClone(0)
			Set pNewServiceObject.Name=tTestServiceName
			Set tChange=1
		} Else {
			If pServiceObject.Type="SOAP" {
				Do pNewServiceObject.ParseURL(pServiceObject.EndPoint)
				#; need to revisit as the array object OIDMapCode will always be different values
				#; also proxies will not work
				For tField="MTOM","OIDMapCode","SecurityClass","XUAConfiguration","SendSAMLAssertion","ProxyHost","SOAPVersion","EncryptX509TokenProfile","SignX509TokenProfile","KerberosTokenProfileConfig","UsernameTokenProfileConfig","MTOM","ProxyHost","ProxyPort","ProxyHTTPS","ProxyHTTPTunnel","ProxyHTTPSSLConnect","HTTPCredentialsConfig" {
					If $property(pNewServiceObject,tField)'=$property(pServiceObject,tField) {
						Set $property(pNewServiceObject,tField)=$property(pServiceObject,tField)
						Set tChange=1
					}
				}
			} ElseIf pServiceObject.Type="TCP" {
				For tField="OIDMapCode","StayConnected" {
					If $property(pNewServiceObject,tField)'=$property(pServiceObject,tField) {
						Set $property(pNewServiceObject,tField)=$property(pServiceObject,tField)
						Set tChange=1
					}
				}
			} ElseIf pServiceObject.Type="HTTP" {
				For tField="OIDMapCode","StayConnected","URL","HTTPCredentialsConfig" {
					If $property(pNewServiceObject,tField)'=$property(pServiceObject,tField) {
						Set $property(pNewServiceObject,tField)=$property(pServiceObject,tField)
						Set tChange=1
					}
				}
			}
		}
		Set:pNewServiceObject.Host'="localhost" pNewServiceObject.Host="localhost",tChange=1
		Set:pNewServiceObject.Port'=tTestServicePort pNewServiceObject.Port=tTestServicePort,tChange=1
		If tChange Set tSC= pNewServiceObject.%Save()
	}Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method GetTestService(Output pServiceName, Output pHost, Output pPort, ByRef pTestServiceName = "", ByRef pTestServiceHost = "localhost", ByRef pTestServicePort = "") As %Status
{
	try {
		#dim tTestService as HS.Registry.Service.Abstract
		#dim tEndPoint as HS.Registry.Service.Abstract
		Set tSC=$$$OK
		Set:pTestServiceName="" pTestServiceName=$g(%session.Data("IHE.Test","TestServiceName"),..#TESTSERVICENAME)
		Set:pTestServicePort="" pTestServicePort=$g(%session.Data("IHE.Test","TestServicePort"),..#TESTSERVICEPORT)
		Set pServiceName=%page.%GetComponentById("cmbServiceRegistry").value
		Set tPIXPDQ = $ZCVT($Extract(pServiceName,1,5),"U")
		If $Extract(tPIXPDQ,1,3)="PIX"!($Extract(tPIXPDQ,1,3)="PDQ") {
			Set tOK = 1
			If $Extract(tPIXPDQ,4,5)="V2",%page.%GetValueByName("version")="v3" Set tOK = 0
			If $Extract(tPIXPDQ,4,5)="V3",%page.%GetValueByName("version")="v2" Set tOK = 0
			If tOK=0 Set tSC = $$$ERROR($$$GeneralError,"Mismatch between version and service") Quit
		}
		Set tType=$S(%page.%GetValueByName("version")="v2":"TCP",1:"SOAP")
		Set tEndPoint = ##class(HS.Registry.Service.Abstract).EndPointForNameType(pServiceName,tType)
		Set pHost=tEndPoint.Host
		Set pPort=tEndPoint.Port
		Set tSC = ..CreateTCPTraceEntry(pTestServiceName,pTestServicePort,pPort,pHost,tEndPoint.SSLConfig)
		Quit:$$$ISERR(tSC)
		Set tTestService=##class(HS.Registry.Service.Abstract).EndPointForNameType(pTestServiceName,tType)
		If '$IsObject(tTestService) {
			Set tTestService=tEndPoint.%ConstructClone(0)
			Set tTestService.Name=pTestServiceName
		} Else {
			If tType="SOAP" Do tTestService.ParseURL(tEndPoint.EndPoint)
		}
		Set tTestService.Host=pTestServiceHost
		Set tTestService.Port=pTestServicePort
		If tType="SOAP" {
			For tField="MTOM","OIDMapCode","SecurityClass","XUAConfiguration","SendSAMLAssertion","SSLConfig","ProxyHost" {
				Set $property(tTestService,tField)=$property(tEndPoint,tField)
			}
		}
		If tType="TCP" {
			For tField="SSLConfig","OIDMapCode" {
				Set $property(tTestService,tField)=$property(tEndPoint,tField)
			}
		}
		
		If tTestService.%Id()=""||(pServiceName'=$Get(%session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1)))) 
		Set tSC= tTestService.%Save()
		
	}Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod GetDefaultTracePort(pName, pPort)
{
	New $namespace
	try {
		Set tPort=pPort
		Set $namespace="%SYS"
		Set tObj=##class(TCPTrace.Config).%OpenId(pName)
		If $isObject(tObj) { Set tPort=tObj.InboundPort}
	}Catch ex {
	}
	Quit tPort
}

/// If the trace port exists...update it to the new port
ClassMethod SetDefaultTracePort(pName, pPort)
{
	New $namespace
	try {
		Set tSC=$$$OK
		Set $namespace="%SYS"
		Set tObj=##class(TCPTrace.Config).%OpenId(pName)
		If $isObject(tObj) { Set tObj.InboundPort=pPort Set tSC=tObj.%Save()}
		
	}Catch ex {
	}
	Quit tSC
}

ClassMethod CreateTraceEntry(pServiceObject As HS.Registry.Service.Abstract, pName As %String = "IHE.Test.Service", pInboundPort) As %Status
{
	New $namespace
	Set tSC=$$$OK
	try {
		Set $namespace="%SYS"
		Set tObj=##class(TCPTrace.Config).%OpenId(pName)
		If $isObject(tObj) {
			If tObj.InboundPort'=pInboundPort {
				Set tObj.Running=0
				Set tSC = tObj.%Save() Hang 1
			}
		} Else {
			Set tObj=##class(TCPTrace.Config).%New()
		}
			
		Set tObj.ConfigName=pName
		Set tObj.InboundPort=pInboundPort
		Set tObj.OutboundPort=$S(pServiceObject.Port]"":pServiceObject.Port,pServiceObject.SSLConfig="":80,1:443)
		Set tObj.OutboundAddress=pServiceObject.Host
		Set tObj.OutboundSSL=pServiceObject.SSLConfig
		Set tObj.Active=1
		Set tSC=tObj.%Save()
		
		Set tRS = ##class(%SQL.Statement).%New()
		Set tResult= tRS.%ExecDirect("","select ID from TCPTrace.Config where inboundport=? and ID<>? and runningStatus=1",pInboundPort,pName)
		If tResult.%Next() {
			Set tSC = $$$ERROR($$$GeneralError,"Port in use by "_tResult.ID)
			&js< alert('Port in use by #(tResult.ID)#');>
			Quit
		}
		Job ##class(TCPTrace.Config).Run(tObj.%Id())
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod CreateTCPTraceEntry(pName As %String = "IHE.Test.Service", pInboundPort, pOutboundPort, pOutboundAddress, pSSLConfig) As %Status
{
	New $namespace
	Set tSC=$$$OK
	try {
		Set $namespace="%SYS"
		Set tObj=##class(TCPTrace.Config).%OpenId(pName)
		If $isObject(tObj) {
			If tObj.InboundPort'=pInboundPort {
				Set tObj.Running=0
				Set tSC = tObj.%Save() Hang 1
			}
		} Else {
			Set tObj=##class(TCPTrace.Config).%New()
		}
			
		Set tObj.ConfigName=pName
		Set tObj.InboundPort=pInboundPort
		Set tObj.OutboundPort=pOutboundPort
		Set tObj.OutboundAddress=pOutboundAddress
		Set tObj.OutboundSSL=pSSLConfig
		//Set tObj.InboundSSL=$S(pSSLConfig="":"",1:pSSLConfig_"_Server")
		Set tObj.Active=1
		Set tSC=tObj.%Save()
		
		Set tRS = ##class(%SQL.Statement).%New()
		Set tResult= tRS.%ExecDirect("","select ID from TCPTrace.Config where inboundport=? and ID<>? and runningStatus=1",pInboundPort,pName)
		If tResult.%Next() {
			Set tSC = $$$ERROR($$$GeneralError,"Port in use by "_tResult.ID)
			&js< alert('Port in use by #(tResult.ID)#');>
			Quit
		}
		Job ##class(TCPTrace.Config).Run(tObj.%Id())
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod CheckProduction(Output pText) As %Status [ ZenMethod ]
{
	try {
		set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.tState) quit:$$$ISERR(tSC)
		If tState'=$$$eProductionStateRunning {
			Set pText="Check to see that the production is running"
			&js< alert('#(pText)#');>
			Quit
		}
		If ($G(%session.Data("Test.IHE","ProductionService"))="") {
			If $$$ISERR(##class(HS.Util.Installer.Upgrade.Abstract).OpenProduction(tProductionName,.tProd)) {
				Set pText="Unable to open production when checking for test service"
				&js< alert('#(pText)#');>
				Quit
			}
			If '##class(HS.Util.Installer.Upgrade.Abstract).ConfigItemExists(tProd,"HS.Test.Service") {
				Set pText="Unable to locate test service on production"
				&js< alert("Unable to locate test service on production");>
				Quit
			}
			Set %session.Data("Test.IHE","ProductionService")=1
		}
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method GetServiceName()
{
	Set tTestServiceName=$g(%session.Data("IHE.Test","TestServiceName"),..#TESTSERVICENAME),tTestServicePort=$g(%session.Data("IHE.Test","TestServicePort"),..#TESTSERVICEPORT)
	Do ..GetTestService(.tService,.tHost,.tPort,.tTestServiceName,.tTestServiceHost,.tTestServicePort)
}

Method AddRecentPatientMRNAA(pPatientId = "", pIdentifiers = "", pCombo = "")
{
	Merge tSVRecentPatientsMRNAA = %session.Data("IHE.Test","RecentPatientsMRNAA",pPatientId)
	
	If $G(pIdentifiers)'="" {
		Set Count=$Length(pIdentifiers,",")
		Set tRecentPatientsMRNAA=Count
		Set tIdx=1
		For i=Count:-1:1 {
			Set tIdentifier = $p(pIdentifiers,",",tIdx)
			Set tRecentPatientsMRNAA(tIdx)=$lb(tIdentifier)
			Set tSeen(tIdentifier)=""
			Set tIdx=$i(tIdx)
		}
	}
	Set (tValueList,tDisplayList)=""
	For tIdx=1:1:+$g(tSVRecentPatientsMRNAA) {
		Set tItem = tSVRecentPatientsMRNAA(tIdx)
		Set tSourcePatientId=$li(tItem)
		If $D(tSeen(tSourcePatientId)) Continue
		Set tRecentPatientsMRNAA($i(tRecentPatientsMRNAA))=tItem
		Set tSeen(tSourcePatientId)="",tValueList=tValueList_","_tSourcePatientId
		Set tDisplayList=tValueList
	}
	
	Merge %session.Data("IHE.Test","RecentPatientsMRNAA",pPatientId)=tRecentPatientsMRNAA
	
	set:pCombo]"" %page.%GetComponentById(pCombo).displayList=$e(tDisplayList,2,*)
	set:pCombo]"" %page.%GetComponentById(pCombo).valueList=$e(tValueList,2,*)
}

Method AddRecentPatients(pResponse = "", pCombo = "", pAffinityDomainOID = {$$$AffinityDomainOID})
{
	Merge tSVRecentPatients = %session.Data("IHE.Test","RecentPatients")
	Set tRecentPatients=0,(tValueList,tDisplayList)=""
	If $isObject(pResponse) {
		For tIdx=1:1:pResponse.Results.Count() {
			Set tPatientId=pResponse.Results.GetAt(tIdx).MPIID_"^^^&"_pAffinityDomainOID_"&ISO"
			Set tPatientName = pResponse.Results.GetAt(tIdx).FirstName_" "_pResponse.Results.GetAt(tIdx).LastName
			Set tRecentPatients($i(tRecentPatients))=$lb(tPatientId,tPatientName)
			Set tSeen(tPatientId)="",tValueList=tValueList_","_tPatientId
			Set tDisplayList=tDisplayList_","_..%EscapeComma(tPatientName)
			
		}
	}
	For tIdx=1:1:+$g(tSVRecentPatients) {
		Set tItem = tSVRecentPatients(tIdx)
		Set tPatientId=$li(tItem)
		If $D(tSeen(tPatientId)) Continue
		Set tRecentPatients($i(tRecentPatients))=tItem
		Set tSeen(tPatientId)="",tValueList=tValueList_","_tPatientId
		Set tDisplayList=tDisplayList_","_..%EscapeComma($li(tItem,2))
	}
	Merge %session.Data("IHE.Test","RecentPatients")=tRecentPatients
	set:pCombo]"" %page.%GetComponentById(pCombo).displayList=$e(tDisplayList,2,*)
	set:pCombo]"" %page.%GetComponentById(pCombo).valueList=$e(tValueList,2,*)
}

Method AddPatient(pPatientID, pPatientName)
{
	Merge tSVRecentPatients = %session.Data("IHE.Test","RecentPatients")
	Set tRecentPatients=0
	Set tSeen(pPatientID)="",tRecentPatients($i(tRecentPatients))=$lb(pPatientID,pPatientName)
	For tIdx=1:1:+$g(tSVRecentPatients) {
		Set tItem = tSVRecentPatients(tIdx)
		Set tPatientId=$li(tItem)
		If $D(tSeen(tPatientId)) Continue
		Set tRecentPatients($i(tRecentPatients))=tItem
		Set tSeen(tPatientId)=""
	}
	Merge %session.Data("IHE.Test","RecentPatients")=tRecentPatients
}

Method ClearRecentPatients()
{
	Kill %session.Data("IHE.Test","RecentPatients")
	Kill %session.Data("IHE.Test","RecentPatientsMRNAA")
}

Method AddRecentDocuments(pResponse = "", pCombo = "", pPatientID = "")
{
	try {
		Set tPatientName=""
		For tIdx=1:1:%session.Data("IHE.Test","RecentPatients") {
			Set tPatientID=$lg($g(%session.Data("IHE.Test","RecentPatients",tIdx)),1)
			Set:tPatientID]"" tPatients(tPatientID)=%session.Data("IHE.Test","RecentPatients",tIdx)
		}
		Merge tSVRecentDocuments = %session.Data("IHE.Test","RecentDocuments")
		Set tRecentDocuments=0,(tValueList,tDisplayList)=""
		If $isObject(pResponse) {
			For tIdx = 1:1:pResponse.Documents.Count() {
				Set tDocument = pResponse.Documents.GetAt(tIdx)
				Set tRepoID = tDocument.RepositoryUniqueId
				If '((($Extract(tRepoID,1,2)="1.")||($Extract(tRepoID,1,2)="2."))&&($Translate(tRepoID,"0123456789.")="")) Set tRepoID = ##class(HS.Data.OIDMap).GetOIDForCode(tRepoID, tRepoID)
				Set tPatientID = tDocument.PatientId
				Set tPatientID = $S(tDocument.PatientId]"":tDocument.PatientId,1:pPatientID)
				Set tPatientName=$S(tPatientID]"":$lg($G(tPatients(tPatientID)),2),1:"")
				Set tRepo=##class(HS.Data.OIDMap).GetCodeForOID(tRepoID,"Unknown Repo")
				Set tDocID=tDocument.UniqueId
				Set tCT=tDocument.CreationTime
			    Set tMime=tDocument.MimeType
				set tDisplayList = tDisplayList_","_"@"_tCT_" ("_..%EscapeComma(tPatientName)_")"_tDocID_" ["_tRepo_"]" 
				set tValueList = tValueList_","_"DOCID="_tDocID_"&REPOID="_tDocument.RepositoryUniqueId_"&HOMEID="_tDocument.HomeCommunityId
				Set tPatientName=""
				Set tRecentDocuments($i(tRecentDocuments))=$lb(tPatientID,tPatientName,tDocID,tRepoID,tRepo,tDocument.HomeCommunityId,tCT,tMime,tDocument.FormatCode.Code,tDocument.URI)
				Set tSeen(tDocID_tRepoID)=tRecentDocuments
			}
		}
		For tIdx=1:1:+$g(tSVRecentDocuments) {
			Set tItem = tSVRecentDocuments(tIdx)
			Set tSeen=$li(tItem,3)_$li(tItem,4)
			If $D(tSeen(tSeen)) Continue
			Set tRecentDocuments($i(tRecentDocuments))=tItem
			Set tSeen(tSeen)="",tValueList=tValueList_",DOCID="_$li(tItem,3)_"&REPOID="_$li(tItem,4)_"&HOMEID="_$li(tItem,6)
			Set tPatientID=$lg(tItem)
			Set tPatientName=$S(tPatientID="":"",1:$lg($G(tPatients(tPatientID)),2))
		    Set tDisplayList=tDisplayList_","_"@"_$lg(tItem,7)_" ("_tPatientName_") "_$lg(tItem,3)_" ["_$lg(tItem,5)_"]"
		}
		Merge %session.Data("IHE.Test","RecentDocuments")=tRecentDocuments
		set:pCombo]"" %page.%GetComponentById(pCombo).displayList=$e(tDisplayList,2,*)
		set:pCombo]"" %page.%GetComponentById(pCombo).valueList=$e(tValueList,2,*)
	} catch ex {
	}
}

ClientMethod ToggleButton(pButton, pDisabled) [ Language = javascript ]
{
	this.getComponentById(pButton).setProperty('disabled',pDisabled);
}

ClientMethod Start(pButton, pClear) [ Language = javascript ]
{
	this.getComponentById(pButton).setProperty('disabled',1);
}

Method ClearResultsPane() [ ZenMethod ]
{
	set results=%page.%GetComponentById("paneResults")
	Do results.%RemoveChildren()
	Quit
}

Method DisplayGroupTestName(pGroupTest As HS.Test.UI.TestGroup)
{
	set results=%page.%GetComponentById("paneResults")
	set msg = ##class(%ZEN.Component.html).%New()
	set msg.content = $ZCVT(pGroupTest.Name_" ("_pGroupTest.%Id()_")","O","HTML")
	Do results.%AddChild(msg)
}

Method DisplayGroupTestResult(pGroupTest As HS.Test.UI.TestGroup, pClear = 1)
{
	set results=%page.%GetComponentById("paneResults")
	If pClear {
		Do results.%RemoveChildren()
	}
	For tIdx = 1:1:pGroupTest.Tests.Count() { 
		Set tTest = pGroupTest.Tests.GetAt(tIdx)
		Do ..DisplayTestResult(tTest,pGroupTest,0)
	}
	set msg = ##class(%ZEN.Component.html).%New()
	set msg.content = $ZCVT(pGroupTest.ClassName_" "_pGroupTest.Name_" Test Id: "_pGroupTest.%Id(),"O","HTML")
	Do results.%AddChild(msg)
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	try {
		set results=%page.%GetComponentById("paneResults")
		Do:pClear results.%RemoveChildren()
		Set tResponse=pTest.Response
		Set tSession=pTest.SessionId
		Set tSC = pTest.Status
		#dim results as %ZEN.Component.pane

		If pTest.Comment]"" {
			set msg = ##class(%ZEN.Component.html).%New()
			set msg.content = $ZCVT($S(pTest.Code="":"",1:":"_pTest.Code)_pTest.Comment,"O","HTML")
			Do results.%AddChild(msg)
		}
		If $$$ISERR(tSC) {
			set msg = ##class(%ZEN.Component.html).%New()
			set msg.content = $ZCVT($system.Status.GetErrorText(tSC),"O","HTML")
			Do results.%AddChild(msg)
		}	
		
		If tSession]"" {
			Set button=##class(%ZEN.Component.button).%New()
			Set button.caption="Session:"_tSession
			Set url="EnsPortal.VisualTrace.zen?SESSIONID="_tSession
			Set button.onclick="javascript:window.open('"_url_"');"
			Do results.%AddChild(button)

			Do:..IsConnectathon ..AddContentButton("Request Data",tSession,"ServiceRequest","RequestContent")
			Do:..IsConnectathon ..AddContentButton("Response Data",tSession,"ServiceResponse","ResponseContent")
			
		}
		If pTest.TransactionLogID]"" {
			Set button=##class(%ZEN.Component.button).%New()
			Set button.caption="Log:"_pTest.TransactionLogID
			Set url="HS.Test.UI.LogViewer.cls?ID="_pTest.TransactionLogID
			Set button.onclick="javascript:window.open('"_url_"');"
			Do results.%AddChild(button)
		}
	} catch ex {
		set msg = ##class(%ZEN.Component.html).%New()
		set msg.content = $ZCVT($system.Status.GetErrorText(ex.AsStatus()),"O","HTML")
		Do results.%AddChild(msg)
	}
}

Method DisplayTestResultSync(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	try {
		set results=%page.%GetComponentById("paneResults")
		Do:pClear results.%RemoveChildren()
		Set tResponse=pTest.Response
		Set tSession=pTest.SessionId
		Set tSC = pTest.Status
		#dim results as %ZEN.Component.pane

		If pTest.Comment]"" {
			set msg = ##class(%ZEN.Component.html).%New()
			set msg.content = $ZCVT($S(pTest.Code="":"",1:":"_pTest.Code)_pTest.Comment,"O","HTML")
			Do results.%AddChild(msg)
		}
		If $$$ISERR(tSC) {
			set msg = ##class(%ZEN.Component.html).%New()
			set msg.content = $ZCVT($system.Status.GetErrorText(tSC),"O","HTML")
			Do results.%AddChild(msg)
		}	
		
		If tSession]"" {
			Set button=##class(%ZEN.Component.button).%New()
			Set button.caption="Session:"_tSession
			Set url="EnsPortal.VisualTrace.zen?SESSIONID="_tSession
			Set button.onclick="javascript:window.open('"_url_"');"
			Do results.%AddChild(button)

			Do:..IsConnectathon ..AddContentButton("Request Data",tSession,"ServiceRequest","RequestContent")
			Do:..IsConnectathon ..AddContentButton("Response Data",tSession,"ServiceResponse","ResponseContent")
			
		}
		If pTest.TransactionLogID]"" {
			Set button=##class(%ZEN.Component.button).%New()
			Set button.caption="Log:"_pTest.TransactionLogID
			Set url="HS.Test.UI.LogViewer.cls?ID="_pTest.TransactionLogID
			Set button.onclick="javascript:window.open('"_url_"');"
			Do results.%AddChild(button)
		}
	} catch ex {
		set msg = ##class(%ZEN.Component.html).%New()
		set msg.content = $ZCVT($system.Status.GetErrorText(ex.AsStatus()),"O","HTML")
		Do results.%AddChild(msg)
	}
}

/// finished a section
Method LogFinished(pGroup = "")
{
	Set pMsg = " -----------------------Step Complete------------------------------"
	If $IsObject(pGroup) {
		Set tTest=pGroup.NewTest("","","",pMsg)
		Do pGroup.%Save()
	}
	#dim results as %ZEN.Component.pane
	set results=%page.%GetComponentById("paneResults")
	set msg = ##class(%ZEN.Component.html).%New()
	set msg.content = pMsg
	Do results.%AddChild(msg)
}

Method LogMessage(pMsg As %String = "", pGroup = "", pMethod = "", pDateSwitch = 1)
{
	Set:pDateSwitch pMsg = "["_$ZDT($H,3)_"] "_pMsg
	If $IsObject(pGroup) {
		Set tTest=pGroup.NewTest("","",pMethod,pMsg)
		Do pGroup.%Save()
	}
	
	#dim results as %ZEN.Component.pane
	set results=%page.%GetComponentById("paneResults")
	set msg = ##class(%ZEN.Component.html).%New()
	set msg.content = $ZCVT($S(pMethod="":"",1:pMethod_":")_pMsg,"O","HTML")
	Do results.%AddChild(msg)
}

Method SetLogging() As %Status
{
	Set %page.%GetComponentById("chkLogging").value=+$g(%session.Data("IHE.Test","LogTransactions"),0)
	Quit $$$OK
}

Method PostAsyncExecuteDisplay(pGroup, pHistory = 0)
{
	Do ..DisplayGroupTestResult(pGroup,'pHistory)
	If 'pHistory && 'pGroup.AdditionalInfo.GetAt("DoNotReEnable") &js<zen('btnSend').setProperty('disabled',false);>
}

Method GetSearchStatus(SearchId As %String) As %String [ ZenMethod ]
{
	Set status = "Unknown"
	Set tSC = ##class(HS.Test.Service).GetResponse(SearchId,.response,.status,.tSessionId)
	// As of JGM081, SessionId returned by reference.  
	// Handle cases of earlier versions, looking at EnsRuntimeAppData global
	Set:'$G(tSessionId) tSessionId = $G($$$EnsRuntimeAppData("ProcessInputAsync",SearchId,"session"))
	Set tGroupId = %page.%GetValueById("txtGroupID")
	If tGroupId="" {
		&js<alert('emptygroup');>
	}
	Set tGroup=##class(HS.Test.UI.TestGroup).%OpenId(tGroupId)
	
	Set tTest = tGroup.Tests.GetAt(%page.%GetValueById("txtTestID"))
	If tSessionId]"" {
		Set tTest.SessionId=tSessionId
		Do %page.%SetValueById("txtTimerSessionID",tSessionId)
	} 
	If status="Waiting" {
		// We're still waiting ...
	} Else {
		Set:$$$ISOK(tSC) tTest.Response=response
		Set tTest.Status=tSC
	}
	Set tSC = tGroup.%Save()

	Do ..PostAsyncExecuteDisplay(tGroup) 
	Quit $ZCVT(status,"O","HTML")
}

/// Executing call - start timeout
ClientMethod timeout() [ Language = javascript ]
{
	var timer = zenPage.getComponentById('timer');
	var SearchId = zenPage.getComponentById("txtTimerSearchID").value;
	
	if(SearchId=='Failed') {
		zenPage.getComponentById('lblTimerTicks').setProperty("value",'');
		zen('btnSend').setProperty('disabled',false);
		return;
	}
	if(SearchId=='') {
		status='Waiting'
	} else {
		status = zenPage.GetSearchStatus(SearchId);
	}
	
	
	var txtTimerCount = zenPage.getComponentById('txtTimerCount')
	timerCount = txtTimerCount.value;
	timerCount = ++timerCount;
	var lblTimerTicks = zenPage.getComponentById('lblTimerTicks')
	if (status == "Waiting") {
		timeout=1000;
		if(timerCount>5) timeout=2500;
		timer.timeout=timeout;
		var numTicks = ((timerCount - 1) % 31) +1
		var ticks = "...............................".substring(0,numTicks)
		lblTimerTicks.setProperty("value",ticks);
		timer.startTimer();
	} else {
		lblTimerTicks.setProperty("value",'');
		timerCount=0;
	}
	txtTimerCount.setProperty("value",timerCount);
}

Method %OnAfterCreatePage() As %Status
{
	If ..%ClassName(1)="HS.Test.UI.Main" {
		Set one=0
		Set tConnectathon = ##class(HS.Registry.Config).GetKeyValue("\IHE\Connectathon",0)
		Set tControl=%page.%GetComponentById("lookout")
		Set tCount=tControl.children.Count()
		For tIdx=tCount:-1:1 {
			Set tChild = tControl.children.GetAt(tIdx)
				
			If tChild.%IsA("%ZEN.Component.tab")  {
				/// go throug children, if we don't have the class then hide the item, if the group has no items, remove it
				try {
					Set tShowOne=0
					For tIdxChild = 1:1:tChild.children.Size {
						Set tItem = tChild.children.GetAt(tIdxChild)
						Set tClass = $p($p(tItem.onclick,"ShowItem('",2),".cls")
						If $e(tClass,1,4)="/csp" continue
						If tClass]"" && ('##class(%Library.ClassDefinition).%ExistsId(tClass)) {
							Set tItem.hidden=1
						} Else {
							Set tShowOne=1
						}
					}
					If 'tShowOne {
						Do tControl.children.RemoveAt(tIdx)
						Continue
					}
				} catch ex {
				}
					//		onclick="zenPage.ShowItem('HS.Test.UI.History.cls','History')"
				If tChild.id="menuAU" {
					Do:'##class(HS.Registry.Config).GetKeyValue("\AustralianCustomisations\AustralianMenuEnabled") tControl.children.RemoveAt(tIdx)
					continue
				} ElseIf tConnectathon=0 {
					If tChild.id="menuXDM" {Do tControl.children.RemoveAt(tIdx) continue}
				}
			}
		}
		If tConnectathon {
			For tControlName = "menuXDSbOnDemand","menuMainAttachment","menuXDSbMU" {
				Set tControlItem = %page.%GetComponentById(tControlName) 
				Set tControlItem.hidden=0
			}
		}
	}
	Quit $$$OK
}

Method LogException(ex, pGroup = "")
{
	Do ..LogMessage(ex.DisplayString(),pGroup)
}

Method LogStatus(pSC As %Status, pGroup = "")
{
	Do ..LogMessage($SYSTEM.Status.GetErrorText(pSC),pGroup)
}

Method CreateServiceRegistryRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tSQL="SELECT Name FROM HS_Registry_Service.Abstract WHERE ( %UPPER(name) [ %UPPER(?) or (? is null) ) and not(Name LIKE 'SYNC.%' or Name LIKE 'IHE.Test.%') ORDER BY Name"
	Set tRS= ##class(%SQL.Statement).%ExecDirect("",tSQL,pInfo.parms(1),pInfo.parms(1))
	Set tSC=$S(tRS.SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"SQLCODE:"_tRS.SQLCODE))
    Set pInfo.queryExecuted=1
	Quit tRS
}

Method CreatePIXPDQServiceRegistryRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tSQL="SELECT Name FROM HS_Registry_Service.Abstract WHERE ( %UPPER(name) [ %UPPER(?) or (? is null) ) and (type=?) and not(Name LIKE 'SYNC.%' or Name LIKE 'IHE.Test.%') ORDER BY Name"
	Set tRS= ##class(%SQL.Statement).%ExecDirect("",tSQL,pInfo.parms(1),pInfo.parms(1),pInfo.parms(2))
	Set tSC=$S(tRS.SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"SQLCODE:"_tRS.SQLCODE))
    Set pInfo.queryExecuted=1
	Quit tRS
}

Method CreateFacilityRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tSQL="select FacilityCode As Code, Name As Name from HS_Facility.Config where ( %UPPER(name) [ %UPPER(?) or (? is null) ) ORDER BY Name"
	Set tRS= ##class(%SQL.Statement).%ExecDirect("",tSQL,pInfo.parms(1),pInfo.parms(1))
	Set tSC=$S(tRS.SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"SQLCODE:"_tRS.SQLCODE))
    Set pInfo.queryExecuted=1
	Quit tRS
}

Method CreateAssigningAuthorityRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tSQL="select oidmap->identitycode as Code,(oidmap->identitycode _' ['_ oidmap->OID _']') as Description from HS_Data.OIDMAP_identitytypes where identitytypes='AssigningAuthority' and ( %UPPER(oidmap->identitycode) [ %UPPER(?) or (? is null) ) order by oidmap->identitycode"
	Set tRS= ##class(%SQL.Statement).%ExecDirect("",tSQL,pInfo.parms(1),pInfo.parms(1))
	Set tSC=$S(tRS.SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"SQLCODE:"_tRS.SQLCODE))
    Set pInfo.queryExecuted=1
	Quit tRS
}

Method UpdateSvcParams() [ ZenMethod ]
{
	Set tVersion = ..%GetValueById("version")
	//Set tService = ..%GetComponentById("cmbServiceRegistry")
	If tVersion = "v2" {
		&js<zenPage.getComponentById('pType').setProperty('value','TCP');>
	} ElseIf (tVersion = "PDQm")||(tVersion = "PIXm") {
		&js<zenPage.getComponentById('pType').setProperty('value','HTTP');>
	} Else {
		&js<zenPage.getComponentById('pType').setProperty('value','SOAP');>
	}
	
	&js<
		var tService = zenPage.getComponentById('cmbServiceRegistry');
		tService.setValue("");
		tService.clearCache();
		tService.executeQuery();
	>
}

ClientMethod updatePatientID(object) [ Language = javascript ]
{
	var value = object.value;
	var newvalue = zenPage.GetPatientID(value);
	object.setProperty("value",newvalue);
}

Method GetPatientID(pPatientID) As %String [ ZenMethod ]
{
	Set pPatientID=$zstrip(pPatientID,"<>W")
	If '$f(pPatientID,"^") Set pPatientID=pPatientID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	Quit pPatientID
}

Method GetServiceRegistryID(pServiceRegistryCombo = "cmbServiceRegistry") As %Integer
{
	Quit:'$isObject(%page.%GetComponentById(pServiceRegistryCombo)) ""
	Set tServiceValue = %page.%GetValueById(pServiceRegistryCombo)
	// PIX/PDQ/PIXm/PDQm all have a component named version.
	If $IsObject(%page.%GetComponentById("version")) {
		Set tType=$S(%page.%GetValueById("version")="v2":"TCP",%page.%GetValueById("version")="v3":"SOAP",1:"HTTP")
	} ElseIf $IsObject(%page.%GetComponentById("isFHIR")) {
		// Hidden control "isFHIR" can designate a page as a FHIR-related page.
		Set tType=$S(%page.%GetValueById("isFHIR")=1:"HTTP",1:"SOAP")
	} Else {
		Set tType="SOAP"
	}
	If tServiceValue?1N.N {
		Set tOBJ = ##class(HS.Registry.Service.Abstract).%OpenId(tServiceValue)
	} Else {
		Set tOBJ=##class(HS.Registry.Service.Abstract).EndPointForNameType(tServiceValue,tType)
	}
	Quit $S($IsObject(tOBJ):tOBJ.%Id(),1:"")
}

Method ExportFile(pCaption, pSessionId, pComment, pSubComment, pExtension = "txt") [ ZenMethod ]
{
	Set tID = ..CreateTempID(pSessionId,pComment,pSubComment)
	If tID="" {&js< alert(' nothing found ');> }
	Else {
		Set filename=$tr(pCaption_"_"_pSessionId," ","_")_"."_pExtension
		&js<window.open("HS.Test.UI.XMLViewer.cls?ID=#(tID)#&Type=txt&Filename=#(filename)#");>}
}

Method AddContentButton(pCaption = "", pSessionId = "", pComment = "", pSubComment = "", pExtension = "txt")
{
	set results=..%GetComponentById("paneResults")
	set msg = ##class(%ZEN.Component.button).%New()
	Set msg.caption = pCaption
	Set msg.onclick="zenPage.ExportFile('"_pCaption_"','"_pSessionId_"','"_pComment_"','"_pSubComment_"','"_pExtension_"');"
	Do results.%AddChild(msg)
}

ClassMethod CreateTempID(pSession = "", pComment = "", pSubComment = "", pStripXMLMessage = 1) As %String
{
	Set tRequest=..GetTraceMessage(pSession,pComment)
	Quit:'$IsObject(tRequest) ""
	Set (tItemFound,tIdx)=""
	For tItemIdx=1:1:tRequest.Items.Count() {
		Set tItem=tRequest.Items.GetAt(tItemIdx)
		If tItem.ItemName=pSubComment || (pSubComment="") Set tItemFound=tItem Quit
	}
	If $IsObject(tItemFound) {
		Set tIdx=$i(^CacheTemp.TestUI)
		Set msg = $zcvt(tItemFound.ItemValue,"I","XML")
		Set msg = (tItemFound.ItemValue)
		if pStripXMLMessage,$e(msg,1,11)="<XMLMessage" {
			Set start=$f(msg,"<ContentStream>"),end=$f(msg,"</ContentStream>")-17
			Set msg=$e(msg,start,end)
		}
		Set ^CacheTemp.TestUI(tIdx)=msg
	}
	Quit tIdx
}

ClassMethod GetTraceMessage(pSession, pComment) As HS.Util.Trace.Request
{
	Set tArgs=1,tArgs(tArgs)=pSession
	Set tSQL="select ID from hs_util_trace.request where id in (select MessageBodyId from Ens.MessageHeader where sessionid=? and MessageBodyClassName='HS.Util.Trace.Request' ) "
	If pComment]"" {
		Set tSQL=tSQL_" AND Comment = ?",tArgs($i(tArgs))=pComment
	}
	Set tSQL=tSQL_" order by id"
	Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,tArgs...),tResult=""
	break
	If tRS.%Next() {
		Set tResult=##class(HS.Util.Trace.Request).%OpenId(tRS.ID)
	}
	Quit tResult
}

Method CreateCodedEntryRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	#; p1 is the typed text and p2 is the CodeType (any type of <parameter value=''/> setting 
	Set tSQL="select ID,(Code _' ['_ CodingScheme _'] '_ Description) as Description from HS_IHE.CodedEntry where ( %UPPER(Code _' ['_ CodingScheme _']') [ %UPPER(?) OR (? IS NULL)) AND CodeType=? order by Code"
	Set tRS= ##class(%SQL.Statement).%ExecDirect("",tSQL,pInfo.parms(1),pInfo.parms(1),pInfo.parms(2))
	Set tSC=$S(tRS.SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"SQLCODE:"_tRS.SQLCODE))
    Set pInfo.queryExecuted=1
	Quit tRS
}

}

/// FHIR Test Utility main menu.
Class HS.Test.UI.FHIR.Main Extends HS.Test.UI.Main
{

Parameter HSDEPLOY = 0;

Parameter RESOURCE = "%HS_TestSuite";

Parameter SERVICEREGISTRYENTRY;

/// Class name of application this page belongs to.
Parameter APPLICATION = "HS.UI.FHIR.Application";

/// Displayed name of this page.
Parameter PAGENAME = "MainPage";

Parameter TESTSERVICENAME = "FHIR.Test";

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
<html id="title" OnDrawContent="DrawTitle" seed="FHIR Test Utility"/>
<hgroup>
<vgroup valign="top"   >
<pane paneName="menuPane"/>
</vgroup>
<spacer width="20"/>
<vgroup valign="top">
<tabGroup id="topTabGroup" showTabBar="true" remember="true">
<tab id="frameTab1" caption='Patient create / update' height="1500px" width="900px" >
<iframe id="frame1" src="HS.Test.UI.FHIR.PatientAdd.cls"/>
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
<lookoutMenu id="lookout" expandable="false" height="600" width="240" remember="true">
<tab caption=" " id="menuMain">
<menuItem caption="Patient create / update" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.PatientAdd.cls','Patient create / update')"/>
<menuItem caption="Patient search" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.PatientSearch.cls','Patient search')"/>
<menuItem caption="Patient read / vread" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.PatientRead.cls','Patient read / vread')"/>
<menuItem caption="Patient history" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.PatientHistory.cls','Patient history')"/>
<menuItem caption="Patient delete" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.PatientDelete.cls','Patient delete')"/>
<menuItem caption="Get Access Token" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.OAuth2GetToken.cls','Get New OAuth 2.0 Access Token')"/>
<menuItem caption="Remove Access Token" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.OAuth2RemoveToken.cls','Remove OAuth 2.0 Access Token')"/>
<menuItem caption="General FHIR Testing" onclick="zenPage.ShowItem('HS.Test.UI.FHIR.GeneralTest.cls','General FHIR Testing')"/>
</tab>
</lookoutMenu>
</pane>
}

XData serviceRegistry [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	sql="SELECT ID,Name FROM HS_Registry_Service.Abstract WHERE (Type='HTTP') ORDER BY Name"
	sqlLookup="SELECT Name FROM HS_Registry_Service.Abstract WHERE ID =?"
	editable="true"
	searchKeyLen="10"
	maxRows="10000"
/>
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
			If tItems(tIdx)="FHIR.Test" Continue
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

Method Execute(pTest As HS.Test.UI.Test, pGroup As HS.Test.UI.TestGroup = "", pRegistryCombo = "cmbServiceRegistry") As %Status
{
	// MIKE NA2014 - add pRegistryCombo so MU tests can support one enpoint for query and another for admin calls
	try {
		Set tSC=$$$OK
		Set tRequest=pTest.Request
		Set tUseTrace=pTest.LogTransaction
		Set pTest.Status=$$$OK

		#; not all requests have requesting user
		try { Set:tRequest.RequestingUser="" tRequest.RequestingUser=$g(%session.Data("FHIR.Test","SAMLUsername")) Set:tRequest.RequestingUserRoles="" tRequest.RequestingUserRoles="%All" } catch ex {}
		#; not all requests have saml data user
		try { Set:tRequest.SAMLData.UserName="" tRequest.SAMLData.UserName=$g(%session.Data("FHIR.Test","SAMLUsername")) Set:tRequest.SAMLData.HSRoles="" tRequest.SAMLData.HSRoles="%All" } catch ex {}
		Set pServiceName=%page.%GetComponentById("cmbServiceRegistry").value

		Set tServiceCombo = %page.%GetComponentById(pRegistryCombo)
		Do:$IsObject(tServiceCombo) pTest.ServiceSetObjectId(tServiceCombo.value)
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
		try { Set:tRequest.RequestingUser="" tRequest.RequestingUser=$g(%session.Data("FHIR.Test","SAMLUsername")) Set:tRequest.RequestingUserRoles="" tRequest.RequestingUserRoles="%All" } catch ex {}
		#; not all requests have saml data user
		try { Set:tRequest.SAMLData.UserName="" tRequest.SAMLData.UserName=$g(%session.Data("FHIR.Test","SAMLUsername")) Set:tRequest.SAMLData.HSRoles="" tRequest.SAMLData.HSRoles="%All" } catch ex {}
		
		Set tServiceID = ..GetServiceRegistryID(pServiceRegistry)
		//Set tServiceCombo = %page.%GetComponentById("cmbServiceRegistry").value
		Do:tServiceID pTest.ServiceSetObjectId(tServiceID)
		Set tServiceObject=pTest.Service
		If $isObject(tServiceObject) {
			Set %session.Data("IHE.Test.LastServiceRegistry",..%ClassName(1))=tServiceObject.%Id()
			Set %session.Data("FHIR.Test",..%ClassName(0),"ServiceRegistry")=tServiceObject.Name
			
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
		try { Set pRequest.RequestingUser=$g(%session.Data("FHIR.Test","SAMLUsername")),pRequest.RequestingUserRoles="%All" } catch ex {}
		#; not all requests have saml data user
		try { Set pRequest.SAMLData.UserName=$g(%session.Data("FHIR.Test","SAMLUsername")),pRequest.SAMLData.HSRoles="%All" } catch ex {}
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
		Set tTestServiceName=$g(%session.Data("FHIR.Test","TestServiceName"),..#TESTSERVICENAME)
		Set tTestServicePort=$g(%session.Data("FHIR.Test","TestServicePort"),..#TESTSERVICEPORT)
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
				For tField="MTOM","OIDMapCode","SecurityClass","XUAConfiguration","SendSAMLAssertion","SSLConfig","ProxyHost","SOAPVersion","EncryptX509TokenProfile","SignX509TokenProfile","KerberosTokenProfileConfig","UsernameTokenProfileConfig","MTOM","ProxyHost","ProxyPort","ProxyHTTPS","ProxyHTTPTunnel","ProxyHTTPSSLConnect","HTTPCredentialsConfig" {
					If $property(pNewServiceObject,tField)'=$property(pServiceObject,tField) {
						Set $property(pNewServiceObject,tField)=$property(pServiceObject,tField)
						Set tChange=1
					}
				}
			} ElseIf pServiceObject.Type="TCP" {
				For tField="SSLConfig","OIDMapCode","StayConnected" {
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
		Set:pTestServiceName="" pTestServiceName=$g(%session.Data("FHIR.Test","TestServiceName"),..#TESTSERVICENAME)
		Set:pTestServicePort="" pTestServicePort=$g(%session.Data("FHIR.Test","TestServicePort"),..#TESTSERVICEPORT)
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

Method GetServiceName()
{
	Set tTestServiceName=$g(%session.Data("FHIR.Test","TestServiceName"),..#TESTSERVICENAME),tTestServicePort=$g(%session.Data("FHIR.Test","TestServicePort"),..#TESTSERVICEPORT)
	Do ..GetTestService(.tService,.tHost,.tPort,.tTestServiceName,.tTestServiceHost,.tTestServicePort)
}

Method SetLogging() As %Status
{
	Set %page.%GetComponentById("chkLogging").value=+$g(%session.Data("FHIR.Test","LogTransactions"),0)
	Quit $$$OK
}

Method LogStatus(pSC As %Status, pGroup = "")
{
	Do ..LogMessage($SYSTEM.Status.GetErrorText(pSC),pGroup)
}

Method CreateFHIRServiceRegistryRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tSQL="SELECT Name FROM HS_Registry_Service.HTTP WHERE (Type='HTTP') ORDER BY Name"
	Set tRS= ##class(%SQL.Statement).%ExecDirect("",tSQL)
	Set tSC=$S(tRS.SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"SQLCODE:"_tRS.SQLCODE))
    Set pInfo.queryExecuted=1
	Quit tRS
}

/// Return true if the specified OAuth 2.0 client is defined.
/// Otherwise, return false.
Method IsValidClient(pClientName As %String) As %Boolean
{
	Set tValid = 0
	Try {
		New $Namespace
		Set $Namespace = "%SYS"
		Set tObj = ##class(OAuth2.Client).%OpenId(pClientName)
		If $IsObject(tObj) Set tValid = 1
		Kill tObj
	} Catch ex {
		Set tValid = 0
	}
	Quit tValid
}

/// Return a comma-delimited string of OAuth 2.0 clients defined via
/// System Administration &gt; Security &gt; OAuth 2.0 &gt; Client.
ClassMethod GetClientList() As %String
{
	Set tClientList = ""
	Try {
		New $Namespace
		Set $Namespace = "%SYS"
		Set tSQL = "SELECT ID FROM OAuth2.Client"
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tSC = tStatement.%Prepare(.tSQL)
		If $$$ISERR(tSC) Quit
		#dim tSQLResultSet As %SQL.StatementResult
		set tSQLResultSet = tStatement.%Execute()
		While tSQLResultSet.%Next() {
			If tClientList'="" Set tClientList = tClientList_","
			Set tClientList = tClientList_tSQLResultSet.ID
		}
	} Catch ex {
		Set tClientList = ""
	}
	Quit tClientList
}

}

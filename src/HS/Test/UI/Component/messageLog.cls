/// A component to display a message log on screen
Class HS.Test.UI.Component.messageLog Extends (%ZEN.Component.composite, HS.Test.UI.Component.hsComponent) [ Inheritance = right ]
{

Property IsConnectathon As %Boolean [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\IHE\Connectathon",0)=1} ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite xmlns="http://www.intersystems.com/zen">
<pane id="paneResults">
</pane>
</composite>
}

Method LogMessage(pMsg As %String = "", pGroup = "", pMethod = "", pDateSwitch = 1)
{
	Set:pDateSwitch pMsg = "["_$ZDT($H,3)_"] "_pMsg
	If $IsObject(pGroup) {
		Set tTest=pGroup.NewTest("","",pMethod,pMsg)
		Do pGroup.%Save()
	}
	
	#dim results as %ZEN.Component.pane
	set results=..%GetChildById("paneResults")
	set msg = ##class(%ZEN.Component.html).%New()
	set msg.content = $ZCVT($S(pMethod="":"",1:pMethod_":")_pMsg,"O","HTML")
	Do results.%AddChild(msg)
}

Method LogException(ex, pGroup = "")
{
	Do ..LogMessage(ex.DisplayString(),pGroup)
}

Method LogStatus(pSC As %Status, pGroup = "")
{
	Do ..LogMessage($SYSTEM.Status.GetErrorText(pSC),pGroup)
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
	set results=..%GetChildById("paneResults")
	set msg = ##class(%ZEN.Component.html).%New()
	set msg.content = pMsg
	Do results.%AddChild(msg)
}

Method ClearResult() [ ZenMethod ]
{
	#dim results as %ZEN.Component.pane
	set results=..%GetChildById("paneResults")
	Do results.%RemoveChildren()
}

Method DisplayGroupTestResult(pGroupTest As HS.Test.UI.TestGroup, pClear = 1)
{
	set results=..%GetChildById("paneResults")
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

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0) [ Private ]
{
	try {
		set results=..%GetChildById("paneResults")
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

Method AddContentButton(pCaption = "", pSessionId = "", pComment = "", pSubComment = "", pExtension = "txt") [ Private ]
{
	set results=..%GetChildById("paneResults")
	set msg = ##class(%ZEN.Component.button).%New()
	Set msg.caption = pCaption
	Set msg.onclick="zenPage.ExportFile('"_pCaption_"','"_pSessionId_"','"_pComment_"','"_pSubComment_"','"_pExtension_"');"
	Do results.%AddChild(msg)
}

}

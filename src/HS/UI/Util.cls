Include (%ZHSLIB, HS.Upgrade, HS.HC.UI.Home, HS.HC, HS.HC.Invoke)

/// Common methods for HS UI.
Class HS.UI.Util Extends HS.HC.UI.Util [ Abstract ]
{

/// Create a set of links common to the patients search page, clinical message center, relationship & subscription pages.
/// <br /> <var>pThisPage</var> may be set to avoid a redundant link to the current page. 
/// <br /> <var>pMode</var> is use by the viewer header - nil for the old style from patient search screen, "portal"
/// for the new style where you want to return to the portal page. 
ClassMethod CommonLinkMenu(pThisPage As %String, pMode As %String = "") As %Status
{
	Set tShare("CSPSHARE") = 1, tHomePage="", tSearchPage="", tMessPage="", tRelPage="", tSubPage="", tLoginLink="", tProxyPage=""
	IF '$D(%session.Data("HomePage")) {
		Set %session.Data("HomePage")=""
		For tResource="%Admin_Manage","%HSAdmin_ConsentManagement","%HSAdmin_FacilityConsentManagement","%HSAdmin_GatewayManagement","%HSAdmin_GroupAssignment","%HSAdmin_GroupManagement","%HSAdmin_HubManagement","%HSAdmin_InstallationManagement","%HSAdmin_RelationshipManagement","%HSAdmin_UserManagement"
		{
			IF $SYSTEM.Security.Check(tResource,"USE") {
				Set %session.Data("HomePage")=$S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"HS.UI.Home.cls",1:"HS.HC.UI.Home.cls")
				Quit
			}
		}
	}
	If %session.Data("HomePage")'="" {
		//Set tLoginLink=%session.Data("HomePage")
		Set tHomePage=##class(%CSP.Page).Link("/csp/healthshare/"_%session.Data("HomePage"),.tShare)
	}
	//If has rights to patient search, create link to that
	IF $SYSTEM.Security.Check("%HS_PatientSearch","USE") {
		Set tSearchPage=..GetSearchPage(), tPortalPage=..GetPortalPage()
	}
	//If clinician, create links around message center
	IF ##Class(HS.Registry.Person.User).SessionUserClinician()'="",pMode'="Portal" {
		Set:$$$HSLicensed("Clinical Message Delivery")&&$SYSTEM.Security.Check("%HS_Messaging","USE") tMessPage=$$$HSUILink("MessageCenter","HS.UI.Push.MessageCenter.cls")
		Set:$$$HSLicensed("Clinical Message Delivery")&&$SYSTEM.Security.Check("%HS_Messaging","USE") tSubPage=$$$HSUILink("Clinician\Subscriptions","HS.UI.Push.ClinSubscriptions.cls")
		Set:%session.Data("UserType")="C" tRelPage=$$$HSUILink("Clinician\Relationships","HS.UI.Push.ClinRelationships.cls")
	}
	IF $$$HSLicensed("Clinical Message Delivery"),##Class(HS.Registry.Person.User).SessionUserClinician()'="",pMode="Portal",$SYSTEM.Security.Check("%HS_Messaging","USE") {
		Set tMessPage=..GetPortalMessagesPage()
	}
	
	//If can proxy, set up the select proxy link
	IF %session.Data("CanProxy") {
		Set tProxyPage=$$$HSUILink("User\SelectProxy","HS.UI.SelectProxy.cls")
	}
	
	// Set Edit Account Page
	Set tAccountPage=$$$HSUILink("Registry\User\Individual","HS.UI.Registry.User.Individual.cls")

	&html<
  	<table border="0" cellpadding="0" cellspacing="0">
    <tr align="left" valign="top">>
    
    IF pThisPage="PatientViewer"&&(tHomePage'="") {
	    &html<<td style="padding-right:30px;"><a class="headerlink" href='#(tHomePage)#'>#($$$TextHTML("HealthShare Management Home"))#</a></td>>
    }
    If pThisPage="PatientViewer"&&(pMode="Portal") {
	    &html<<td style="padding-right:30px;"><a class="headerlink" href='#(tPortalPage)#'>#($$$TextHTML("Clinician Portal"))#</a></td>>
    } ElseIF (pThisPage'="PatientSearch")&&(tSearchPage'="") {
	    &html<<td style="padding-right:30px;"><a class="headerlink" href='#(tSearchPage)#'>#($$$TextHTML("Patient Search"))#</a></td>>
    }
    
    If pThisPage="PatientViewer"&&($System.Security.Check("%HS_PatientSummaryReporting","USE")) && '$Data(%request.Data("viewsummary", 1)) {
	    Set msgPatientSummary = $$$Text("Click to display a summary report","HS")
	    &html<<td style="padding-right:30px;"><a class="headerlink" href="javascript:zenPage.openSummary();">#($$$TextHTML("View Summary"))#</a></td>>
	    //&html<<td style="padding-right:30px;"><a class="headerlink" href="javascript:zenPage.openSummary();>#" title="#(msgPatientSummary)#" #($$$TextHTML("View Summary"))#</a></td>>
    }
    If $$$HSLicensed("Clinical Message Delivery")&&(pThisPage="PatientViewer")&&($System.Security.Check("%HS_PatientSummaryReporting","USE"))&&$SYSTEM.Security.Check("%HS_Messaging","USE")&&(%session.Data("MessageRepository")'="") {
	    // If viewsummary is 1, we are access from (v2) Clinical Viewer. We need to hide Send Summary menu to avoid duplicate buttons. Otherwise, we will show Send Summary menu.
	    if '$Data(%request.Data("viewsummary", 1)) {
	    	&html<<td style="padding-right:30px;"><a class="headerlink" href="javascript:zenPage.sendSummary('send');">#($$$TextHTML("Send Summary"))#</a></td>>
		}
	    &html<<td style="padding-right:30px;"><a class="headerlink" href="javascript:zenPage.sendSummary('down');">#($$$TextHTML("Download Summary"))#</a></td>>
    }
    
    IF pThisPage'="ClinMessageCenter"&&(tMessPage'="") {
	    Set tClinMessCtr=$$$TextHTML("Messages")_" ("_..GetFolderCount("Inbox")_")"
	    &html<<td style="padding-right:30px;"><a class="headerlink" href='#(tMessPage)#'>#(tClinMessCtr)#</a></td>>
    }
    IF pThisPage'="ClinSubscriptions"&&(tSubPage'="") {
	    &html<<td style="padding-right:30px;"><a class="headerlink" href='#(tSubPage)#'>#($$$TextHTML("Subscriptions"))#</a></td>>
    }
    IF pThisPage'="ClinRelationships"&&(tRelPage'="") {
	    &html<<td style="padding-right:30px;"><a class="headerlink" href='#(tRelPage)#'>#($$$TextHTML("Relationships"))#</a></td>>    
    }
    
    IF pThisPage'="SelectProxy"&&(tProxyPage'="") {
	    //&html<<td style="padding-right:30px;"><a class="headerlink" href='#(tProxyPage)#'>#($$$TextHTML("Proxy"))#</a></td>>
	    &html<<td style="padding-right:30px;"><a class="headerlink" href="javascript:zenPage.launchPopupWindow('#(tProxyPage)#','ProxyPage','modal=no,width=500px,height=500px');">#($$$TextHTML("Proxy"))#</a></td>>
    }
    IF pThisPage="PatientViewer"&&(tAccountPage'="") {
	   &html<<td style="padding-right:30px;"><a class="headerlink" href="javascript:zenPage.launchPopupWindow('#(tAccountPage)#','EditUser','modal=no,width=1210,height=630');">#($$$TextHTML("My Account"))#</a></td>> 
    }
    
	Set tLoginLink=..GetLoginLink()
    IF pThisPage="PatientViewer" {
	    &html<<td style="padding-right:30px;"><a class="headerlink" href='#(tLoginLink)#'>#($$$TextHTML("Logout"))#</a></td>>
	    Set tLink=..GetSearchPage()
	    &html<<div style="display: none"><label id="idHSLogout" style="display: none">#(tLink)#</label></div>> 
    }
    
    &html<
	</tr>
	</table> 
	>
	Quit $$$OK
}

ClassMethod GetLoginLink(pFrom As %String = "") As %String
{
	IF pFrom="" {
		If $D(%session.Data("HomePage")) {Set pFrom=%session.Data("HomePage")}
		ELSEIF $SYSTEM.Security.Check("%HS_PatientSearch","USE") {Set pFrom=..GetSearchPage()}
		ELSEIF ##Class(HS.Registry.Person.User).SessionUserClinician()'="" {Set pFrom=$$$HSUILink("MessageCenter","HS.UI.Push.MessageCenter.cls")}
	}
	Set tQuery("FROM")=pFrom
	Quit $$$HSUILinkQuery("Logout","HS.UI.Logout.cls",tQuery)
}

ClassMethod GetSearchPage() As %String
{
	Quit $$$HSUILink("PatientSearch","HS.UI.PatientSearch.cls")
}

ClassMethod GetPortalPage() As %String
{
	Quit $$$HSUILink("ClinicianPortal","HS.UI.ClinicianPortal.cls")
}

ClassMethod GetPortalMessagesPage() As %String
{
	Set tQuery("Mode")="messages"
	Quit $$$HSUILinkQuery("ClinicianPortal","HS.UI.ClinicianPortal.cls",tQuery)
}

ClassMethod GetFolderCount(pType) As %Integer
{
	Set tClinicianId=##class(HS.Registry.Person.User).SessionUserClinician()
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Push.WebServices","HS.Push.WebServicesClient","FolderDocumentCount",.tCount,tClinicianId,pType)
	Quit $S($$$ISOK(tSC):tCount,1:$$$Text("Not Found"))
}

/// Returns patient summary types (XML plus report types) in session data sorted by description
ClassMethod %GetSummaryTypes()
{
	If '$D(%session.Data("SummaryTypes")) {
		$$$HCInvoke(,,"XMLSummaryType",.tSummaryType)
		Set tDesc="" For {
			Set tDesc=$O(tSummaryType(tDesc),1,tCode) Quit:tDesc=""
			Set %session.Data("SummaryTypes",tDesc)=tCode
		}
		Set %session.Data("SummaryTypes",$$$Text("Patient Summary (HTML)"))="HTML"
		Set %session.Data("SummaryTypes",$$$Text("Patient Summary (PDF)"))="PDF"
	}
}

/// Returns patient summary reports in session data sorted by name in session data, plus the default report 
ClassMethod %GetSummaryReports()
{
	Set tSC=$$$OK
	If '$D(%session.Data("SummaryReports")) {
		Set tRS=##class(%ResultSet).%New("HS.Reports.Patient.Config:ListReportsLocal")
		Set tSC=tRS.Execute()
		While (tRS.Next(.tSC)) {
			Quit:$$$ISERR(tSC)
			Set %session.Data("SummaryReports",tRS.Name)=tRS.ID
		}
	}
}

ClassMethod CheckTimeoutForNavApp()
{
	/*
	When the v2 clinical viewer is unloaded, its JS code calls a method called TimeoutSession() in the viewerlib 
	class system.Router, which is a TrakCare class. That method sets the current session timeout to 10. If this happens 
	because the user is using the navigation app to switch to some other CV app hosted on the same CSP web app, 
	the user will be "spontaneously" logged out very soon. 
	
	So this method is called by the OnPreHTTP methods of the classes that are the entry points for the other CV apps 
	hosted in the navigation app. It attempts to catch this scenario and restore the timeout. 
	*/
	if %session.AppTimeout = 10 {
		set %session.AppTimeout = ##class(%ZHSLIB.SessionEventUtil).GetCSPApplicationTimeout()
	}
}

}

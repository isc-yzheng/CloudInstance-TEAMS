Include (Ensemble, HS.HC.Invoke)

/// Base HealthShare UI class
Class HS.UI.Base Extends HS.UI.BaseUtil
{

Parameter HSDEPLOY = 0;

/// Class name of application this page belongs to.
Parameter APPLICATION = "HS.UI.Application";

/// Domain used for localization.
Parameter DOMAIN = "HS";

/// When running HealthShare, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter HSHELPKEY;

Parameter FAVORITEICON As COSEXPRESSION = "$$$ISCFAVORITEICON";

Property HomeApplication As %ZEN.Datatype.string [ InitialExpression = {$S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"HS.UI.Home.cls",1:"HS.HC.UI.Home.cls")} ];

/// Override this instead of %OnPreHTTP for all HS.UI Zen classes
ClassMethod %OnHSPreHTTP() As %Boolean [ CodeMode = expression, ServerOnly = 1 ]
{
1
}

/// Utility method.  Can add this to your %OnHSPreHTTP by having its expression be:
/// ..%CheckProductionRunning()
ClassMethod %CheckProductionRunning(pFromPopup As %Boolean = 0) As %Boolean [ ServerOnly = 1 ]
{
	Set tSC= ##class(Ens.Director).GetProductionStatus(,.tState)
	if $$$ISERR(tSC) || (tState'=$$$eProductionStateRunning) {
		// If pFromPopup flag is present, pass it as a URL parameter
		Set %response.Redirect="HS.UI.SystemNotRunning.cls"_$S(pFromPopup=1:"?FromPopup=1",1:"")
	}
	Quit 1
}

///  This looks up an alternate application class in the HealthShare registry, and will use that
///  instead of the default HS.UI.Application
///  The alternate application class should extend HS.UI.Application
ClassMethod %OnCreateApplication(Output pStatus As %Status, pApplicationName As %String) As %ZEN.application [ Final ]
{
	Set pStatus=$$$OK
	Set:'$D(%session.Data("UILink","Application"),tClass) tClass=##class(HS.Registry.Config).GetKeyValue("\UI\Application",pApplicationName),%session.Data("UILink","\UI\Application")=tClass
	Set:$E(tClass,*-3,*)=".cls" tClass=$E(tClass,1,*-4)
	Quit $zobjclassmethod(tClass,"%New")
}

/// Executes once to get user preferences and possibily set a custom timeout period.
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	If $namespace'="HSLIB" {
		Set tSC=$$$OK
		; HealthShare will update user preferences when not defined
		If '$D(%session.Data("User")) $$$HCInvoke(tSC,$$$OK,"GetUserPrefs",$username)
		If $$$ISOK(tSC) && $D(%session.Data("User")) {
			Set tTimeout=%session.Data("User","Timeout")
			Set:tTimeout]"" %session.AppTimeout=tTimeout
		}
	}
	Set tCurrAppTimeout = ##class(%ZHSLIB.SessionEventUtil).GetCSPApplicationTimeout()
	If tCurrAppTimeout && (tCurrAppTimeout < %session.AppTimeout) Set %session.AppTimeout = tCurrAppTimeout
	Quit ##super()
}

ClientMethod onlogoutHandler() [ Language = javascript ]
{
	this.triggerLogoutNotification();
	
	var page=self.document.getElementById('idHSLogout');
	if (page) {
		var loginPage=page.innerHTML+'?IRISLogout=end';
	} else {
		var loginPage = '/csp/healthshare/'+this.HomeApplication+'?IRISLogout=end';
	}
	var prefix = '' + document.location.pathname;
	if (prefix.indexOf('/csp/healthshare/' != -1)) {
		prefix = prefix.substring(0,prefix.indexOf('/csp/healthshare/'));
	}
	else {
		prefix = '';
	}
	document.location = loginPage;
	// avoid reloading the page
	return false;
}

/// Show documentation.
ClientMethod showHelp() [ Language = javascript ]
{
	var url=this.GetDocPage();
	var wid = self.screen.width;
	var hgt = self.screen.height;
	if (parseInt(navigator.appVersion)>3) {
		if (navigator.appName == "Netscape") {
			wid = window.innerWidth;
			hgt = window.innerHeight;
		}
		if (navigator.appName.indexOf("Microsoft") != -1) {
	 		wid = document.body.offsetWidth;
	 		hgt = document.body.offsetHeight;
		}
	}
	wid = wid * 0.8;
	hgt = hgt * 0.8;
	var top = self.screen.height * 0.1;
	var left = self.screen.width * 0.1;
	//YSD2331 zenLaunchPopupWindow(url,'Help Window','left='+left+',top='+top+',width='+wid+',height='+hgt+',status,scrollbars,resizable,location=1,toolbar=1,menubar=1,modal=no');
	var features = 'left='+left+',top='+top+',width='+wid+',height='+hgt+',status,scrollbars,resizable,location=1,toolbar=1,menubar=1';
	var popup = window.open(url,'HelpWindow',features);
	popup.focus();
	return false;
}

ClassMethod GetDocPage() As %String [ ZenMethod ]
{
	Set tDocPage="/csp/docbook/DocBook.UI.HomePageZen.cls"
	Set:..#HSHELPKEY'="" tDocPage="/csp/docbook/DocBook.UI.Page.cls?KEY="_..EscapeURL(..#HSHELPKEY)
	Set tQuery("CSPSHARE") = 1
	Set tDocPage = ##class(%CSP.Page).Link(tDocPage,.tQuery)
	Quit tDocPage
}

ClientMethod hsResetAutoLogout() [ Language = javascript ]
{
		if (zenAutoLogoutTimerID) {
		self.clearTimeout(zenAutoLogoutTimerID);
		zenAutoLogoutTimerID = self.setTimeout("zenAutoLogout()",zenAutoLogoutTime);
	}
	zenPage.hsBubbleResetAutoLogout() ;
}

/// Call this from an child page to reset the Zen autologout timer on the parent page(s)
ClientMethod hsBubbleResetAutoLogout() [ Language = javascript ]
{
    var win = window;
    try { // protect against cross-domain issues
    	if (win) {
	    	var parent = win.parent;
	    	if (parent && parent.zenPage && parent.zenPage.hsResetAutoLogout &&(typeof parent.zenPage.hsResetAutoLogout == 'function')) {
		    	parent.zenPage.hsResetAutoLogout() ;
	    	}
    	}
    }
    catch(ex) {
        // handle exception here
    }
}

}

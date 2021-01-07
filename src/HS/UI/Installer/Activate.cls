/// Activate a configuration.
Class HS.UI.Installer.Activate Extends (HS.UI.Base, %CSP.Portal.standardDialog)
{

Parameter PAGENAME = "Activate Configuration";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

Property msgactivate As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Are you sure you want to proceed with re-activating this configuration?")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
body {
	background: #ffffff;
	font-family: "Source Sans Pro",Futura,Arial,sans-serif;
}
#header {
	position: relative;
}
.stdTitle {
	color:#000000;
	background: #ffffff;
	border-bottom: none;
	font-family: Montserrat,Futura,Arial,sans-serif; 
	font-size: 16px;
	font-weight: 700;
	letter-spacing: 0.75px;
	margin: 20px 20px 10px 20px;
	text-transform: uppercase;
	white-space: nowrap;
}
.stdSubTitle {
	color:#000000;
	font-family: Montserrat,Futura,Arial,sans-serif;
	font-style: italic;
	font-size: 12px;
	font-weight: normal;
	letter-spacing: 0.75px;
	margin: 4px 20px;	
	white-space: nowrap;
}
.stdTitleBorder {
	border: 1px solid #CBCBCB;
	border-radius: 4px;	
}
.labelTitle {
	color: black;
	font-size: 14px;
	font-weight: bold;
	text-decoration: bold;
}
.warningTitle {
	color: red;
	font-size: 18px;
	font-weight: bold;
	text-decoration: bold;
}
#taskStatus {
	color: blue;
	font-size: 20px;
	font-weight: normal;
	text-decoration: bold;
}
.labelTitle1 {
	color: blue;
	font-size: 1.0em;
}

</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" 
	title="#(%page.dialogTitle)#">
<html id="header" OnDrawContent="%DrawTitle" />

<pane paneName="dialogBody" id="body" />

<!--
<hgroup id="footer" width="100%" cellAlign="right">
<hgroup id="buttonHolder" cellAlign="right">
<button id="btnCancel" controlClass="commandButton" caption="Cancel" onclick="zenPage.dialogCancel();" />
<spacer width="5" />
<button id="btnFinish" controlClass="commandButton" caption="Save" onclick="zenPage.saveForm();"/>
</hgroup>
</hgroup>
-->
</page>
}

XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding:20;">
<label id="result" controlClass="redText" value="" containerStyle="padding-left:10px;"/>
<spacer height="6"/>
<hgroup>
<spacer width="20"/>
<vgroup cellAlign="center">
<label id="lblTitle" align="center" labelClass="labelTitle" label="This job will be run in the background. Click [Start] to proceed."/>
<spacer height="4"/>
<label id="lblTitle1" align="center" labelClass="labelTitle1" label=""/>
<spacer height="4"/>
<label id="id_Warning" align="center" label="This configuration has already been activated. Are you sure you want to run it again?" labelClass="warningTitle" hidden="true"/>
<spacer height="4"/>

<hgroup>
<button id="btnStart" caption="Start" enclosingClass="button" align="center" onclick="zenPage.backgroundTask();" title="Click to start the job"/>
<spacer width="10"/>
<button id="btnClose" caption="Close" onclick="zenPage.closePopup();"/>
</hgroup>
<html id="taskStatus"></html>
<text id="PID" hidden="true"/>
</vgroup>
</hgroup>
</pane>
}

/// User clicked the Close button. If user has run the Activate then signal to refresh table. Otherwise simply cancel window.
/// If user closed window before the job is finished then the table won't have the most up-to-date info. i.e. the Activated flag may still be 0.
ClientMethod closePopup() [ Language = javascript ]
{
	
	if (zenPage.getComponentById("btnStart").getProperty("disabled") == true) {
		this.firePopupAction('saved');
	} else {
		this.cancelPopup();
	}
}

ClientMethod backgroundTask() [ Language = javascript ]
{
	var activated = !zenPage.getComponentById("id_Warning").getProperty("hidden");
	
	if (activated == 1) {
		var confirmation = confirm(this.msgactivate);
	} else {
		var confirmation = 1;
	}
	
	if (confirmation) {
		var PID = zenPage.getComponentById("PID").getValue();
		if (PID == "") {
			alert("ID is not available. Cannot start this job. ");
			return;
		} else {
			zenPage.getComponentById("taskStatus").setProperty("content","Job Started. Please wait...");
			zenPage.getComponentById("btnStart").setProperty("disabled",true);
			this.RunBackgroundTask(PID);
		}
	} else {
		this.cancelPopup();
	}
}

ClassMethod RunBackgroundTask(pID As %Integer) [ ZenMethod ]
{
	#; Run method BackgroundTask in a background job.
	Do ..%RunBackgroundMethod("StartActivation",pID)
}

/// This task is run in the background.
ClassMethod StartActivation(ID)
{
	Set tSC = $$$OK
	Set $ZT = "Trap"
	Set %HSBackgroundLog=1
	Do ..%SetBackgroundMethodStatus("Job Started. Please wait...")
	//Set tSC = ..RunActivate(ID)
	Set tModel = ##class(HS.Util.Installer.ConfigItem).%OpenId(ID)
	Set Type = tModel.Type
	Set Name = tModel.Name
	Set tVars("DBInstallDirectory")=tModel.DatabaseLocation
	If ( "^AccessGateway^Bus^EdgeGateway^Hub^"[("^"_Type_"^")){
		set tVars("Kits")=tModel.KitsList
		set tSC=tModel.Install(Name,.tVars)
		; clear kit list after install
		set tModel.KitsList=""
		do tModel.%Save()
	} Else {
		set tSC=tModel.Install(Name,.tVars)
	}		

	If $$$ISOK(tSC) {
		Do ..%EndBackgroundMethod()
	} Else {
		#; server method error out
		Set pMsg = $ZCVT($System.Status.GetErrorText(tSC),"O","JS")
		Do ..%SetBackgroundMethodStatus(pMsg)
	} 
Done
	Quit
Trap
	Set $ZT = ""
	Set pMsg = $ZCVT($ZE,"O","JS")
	Do ..%SetBackgroundMethodStatus(pMsg)
	GoTo Done
}

/// This server-side callback method is called whenever the client
/// calls to monitor the current background task.
/// Typically a subclass uses this to send back JavaScript to update
/// a progress bar.
ClassMethod %OnMonitorBackgroundTask(pTaskID As %String, pStatus As %String)
{
	#; write status into HTML component
	&js<
	var html = zenPage.getComponentById('taskStatus');
	html.setProperty('content','#($zconvert(..EscapeHTML(pStatus),"O","JS"))#');
	>
}

/// This server-side callback method is called whenever the client
/// calls to monitor the current background task and the task is complete.
/// Typically a subclass uses this to send back JavaScript to update
/// the page.
ClassMethod %OnFinishBackgroundTask(pTaskID As %String)
{
	#; Clear HTML component
	&js<
	var html = zenPage.getComponentById('taskStatus');
	html.setProperty('content','Activation Done.');
	>
}

/// Client-side callback to update task status.<br>
/// <var>taskInfo</var> is an associative array (object) containing
/// task status indexed by taskid.
ClientMethod ontaskHandler(taskInfo) [ Language = javascript ]
{
	var html = zenPage.getComponentById('taskStatus');
	if (null == taskInfo) {
		// no tasks
		html.setProperty('content','');
	}
	else {
		// get task info
		var msg = '';
		for (task in taskInfo) {
			msg += 'Task: ' + task + ': ' + taskInfo[task] + '<br>';
		}
		html.setProperty('content',msg);
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set PID = $G(%request.Data("ID",1))
	Set ..%GetComponentById("PID").value = PID
	Set Name = ""
	Set tModel = ##class(HS.Util.Installer.ConfigItem).%OpenId(PID)
	If $IsObject(tModel) Set Name = tModel.Name
	Set msg = $ZCVT($$$FormatText($$$Text("ID: %1, Name: %2"),PID,Name),"O","HTML")
	Set ..%GetComponentById("lblTitle1").label = "("_msg_")"

	Set modelClass = tModel.%ClassName(1)
	Set tObj = $zobjclassmethod(modelClass,"%OpenId",PID)
	If tObj.Activated = 1 Set ..%GetComponentById("id_Warning").hidden = 0
	
	Set ..backgroundTimerInterval=200 //5 times per second
	Quit $$$OK
}

Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Activate Configuration")
}

Method %OnGetSubtitle() As %String
{
	Quit ""
}

}

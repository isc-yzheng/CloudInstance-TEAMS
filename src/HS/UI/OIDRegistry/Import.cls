/// Utility to Import OID Registry items
Class HS.UI.OIDRegistry.Import Extends HS.HC.UI.Template
{

/// Displayed name of this page.
Parameter PAGENAME = "OID Registry Import";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_InstallationManagement";

/// When running Foundation, this will be part of the docbook link, i.e. DocBook.UI.PortalHelpPage.cls?Key=thisvalue
Parameter FOUNDATIONHELPKEY = "FADM_ch_OID_registry";

/// Page title
Property PageTitle As %ZEN.Datatype.caption [ InitialExpression = {$$$TextHTML("OID Registry Import")} ];

Property msgFromFile As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS(" Load from file? ")} ];

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#">
<html id="titleBar" OnDrawContent="DrawTitle"/>
<text id="id" hidden="true"/>
<pane paneName="links"/>
<hgroup>
<spacer width="20"/>
<vgroup>
<pane paneName="selectionPane"/>
</vgroup>
</hgroup>
</page>
}

XData selectionPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" id="selectionPane" width="100%">
<spacer height="5"/>
<hgroup id="gp1" >
<vgroup valign="top" cellStyle="padding: 2px">
<button id="btnFile" caption="Select File..." onclick="zenPage.launchPopupWindow('%ZEN.Dialog.fileSelect.cls','FileSelectWindow','status,scrollbars,resizable,width=660,height=700');"/>
<label id="lblfilename" controlClass="clinStyle" valign="bottom" width="800"/>
</vgroup>
<spacer width="10"/>
</hgroup>
<html id="taskStatus"></html>
</pane>
}

/// After searching for a file
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	var ask=this.msgFromFile+value;
	if(confirm(ask)) {
		zen('lblfilename').setValue(value);
		zenPage.backgroundTask();
	}
}

ClientMethod backgroundTask() [ Language = javascript ]
{
	var fullpath = zenPage.getComponentById("lblfilename").getValue();
	var filename = fullpath.substring(fullpath.lastIndexOf('/')+1);
	if (fullpath == "" || filename == "") {
		alert("Filename is not available. Cannot start this job. ");
		return;
	} else {
		zenPage.getComponentById("taskStatus").setProperty("content","Job Started. Please wait...");
		this.RunBackgroundTask(fullpath);
	}
}

ClassMethod RunBackgroundTask(pFileName As %String) [ ZenMethod ]
{
	#; Run method BackgroundTask in a background job.
	Do ..%RunBackgroundMethod("StartLoad",pFileName)
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

ClassMethod StartLoad(pFileName)
{
	Set tSC = $$$OK
	Set $ZT = "Trap"
	Set %HSBackgroundLog=1
	Do ..%SetBackgroundMethodStatus("Job Started. Please wait...")
	Set tSC=##Class(HS.Data.OIDMap).ImportFromFile(pFileName)

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
/// calls to monitor the current background task and the task is complete.
/// Typically a subclass uses this to send back JavaScript to update
/// the page.
ClassMethod %OnFinishBackgroundTask(pTaskID As %String)
{
	Set tTotal = $G(^ISC.HS.OIDRegistry($Username,"Total"),0)
	Set tErrors=$G(^ISC.HS.OIDRegistry($Username,"Errors"),0) 
	
	// Build message to report into local variable strings.
	Set tTotalMsg = "Total Items processed: "_tTotal_"<P>"
	Set tErrorMsg = $Select(tErrors=0:"",1:"<P>Errors reported during import ("_tErrors_").<BR>")
	Set tErrorMsg = tErrorMsg_"<BR>See Global ^ISC.HS.OIDRegistry("""_$Username_""") for details."
	
	#; Update HTML component
	&js<
	var html = zenPage.getComponentById('taskStatus');
	html.setProperty('content','OID Registry Load Completed. <p>'+'#($ZCVT(tTotalMsg,"O","JS"))#'+'#($ZCVT(tErrorMsg,"O","JS"))#');
	>
}

}

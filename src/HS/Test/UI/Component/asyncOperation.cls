Include Ensemble

/// a component to monitor an async operation
Class HS.Test.UI.Component.asyncOperation Extends (%ZEN.Component.composite, HS.Test.UI.Component.hsComponent) [ Inheritance = right ]
{

Property logger As HS.Test.UI.Component.messageLog;

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
<form labelPosition="left">
<label label="Timer Ticks" id="lblTimerTicks" />
<timer id="timer" ontimeout="zenThis.composite.timeout();" timeout="0"/>
<checkbox id="statsCheckbox" label="Show stats?" onchange="zenThis.composite.getChildById('statsDiv').setHidden(!zenThis.value)"/>
</form>
<form id="statsDiv" hidden="true" labelPosition="left">
<text label="Timer Count" id="txtTimerCount" />
<text label="Timer Search Id" id="txtTimerSearchID" />
<text label="Timer Session Id" id="txtTimerSessionID" />
<text label="Group Id" id="txtGroupID" />
<text label="Test Id" id="txtTestID" />
</form>
</composite>
}

ClientMethod execute(buttonToDisable, callback) [ Language = javascript ]
{
	// Note: this method is intended to be called in a button callback via asyncOperation.this. This has two consequences
	// 1) "zenThis" will be the button that was click on. 
	// 2) "this" will be the asyncOperation component.
	
	// Clear out any existing Group/Search IDs to prevent subsequent searches from reusing prior search data
	var txtGroupID = this.getChildById('txtGroupID')
	txtGroupID.setProperty("value",'');
	var txtTimerSearchID = this.getChildById('txtTimerSearchID')
	txtTimerSearchID.setProperty("value",'');
	
	this.toggleButton(buttonToDisable,1);
	var SearchId = callback();
	if(SearchId=='Failed') {
		return;
	}
	if(SearchId == '') {
		this.toggleButton(buttonToDisable,0);
	} else {
		this.timeout();
	}
}

ClientMethod toggleButton(pButton, pDisabled) [ Language = javascript ]
{
	pButton.setProperty('disabled',pDisabled);
}

/// Executing call - start timeout
ClientMethod timeout() [ Language = javascript ]
{
	var timer = this.getChildById('timer');
	var SearchId = this.getChildById("txtTimerSearchID").value;
	
	if(SearchId=='Failed') {
		this.getChildById('lblTimerTicks').setProperty("value",'');
		zen('btnSend').setProperty('disabled',false);
		return;
	}
	if(SearchId=='') {
		status='Waiting'
	} else {
		status = this.GetSearchStatus(SearchId);
	}
	
	
	var txtTimerCount = this.getChildById('txtTimerCount')
	timerCount = txtTimerCount.value;
	timerCount = ++timerCount;
	var lblTimerTicks = this.getChildById('lblTimerTicks')
	if (status == "Waiting") {
		var timeoutMilliseconds=(timerCount>5) ?2500:1000;
		timer.timeout= timeoutMilliseconds;
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

Method GetSearchStatus(SearchId As %String) As %String [ ZenMethod ]
{
	Set status = "Unknown"
	Set tSC = ##class(HS.Test.Service).GetResponse(SearchId,.response,.status,.tSessionId)
	// As of JGM081, SessionId returned by reference.  
	// Handle cases of earlier versions, looking at EnsRuntimeAppData global
	Set:'$G(tSessionId) tSessionId = $G($$$EnsRuntimeAppData("ProcessInputAsync",SearchId,"session"))
	Set tGroupId = ..%GetChildById("txtGroupID").value
	If tGroupId="" {
		&js<alert('emptygroup');>
	}
	Set tGroup=##class(HS.Test.UI.TestGroup).%OpenId(tGroupId)
	
	Set tTest = tGroup.Tests.GetAt(..%GetChildById("txtTestID").value)
	If tSessionId]"" {
		Set tTest.SessionId=tSessionId
		Set ..%GetChildById("txtTimerSessionID").value = tSessionId
	} 
	If status="Waiting" {
		// We're still waiting ...
	} Else {
		Set:$$$ISOK(tSC) tTest.Response=response
		Set tTest.Status=tSC
	}
	Set tSC = tGroup.%Save()

	Do ..%PostAsyncExecuteDisplay(tGroup) 
	Quit $ZCVT(status,"O","HTML")
}

Method %PostAsyncExecuteDisplay(pGroup, pHistory = 0)
{
	Do ..logger.DisplayGroupTestResult(pGroup,'pHistory)
	If 'pHistory && 'pGroup.AdditionalInfo.GetAt("DoNotReEnable") &js<zen('btnSend').setProperty('disabled',false);>
}

}

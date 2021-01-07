/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsPortal.Dialog.ImportJBH Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

/// User needs WRITE permissions on either the %Ens_Code resource or the %Ens_JBH resource to view this page.
Parameter RESOURCE = "%Ens_Code:WRITE,%Ens_JBH:WRITE";

Parameter PRIVATE = 1;

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

Parameter CLOSEONESC = 2;

Parameter CLOSEONENTER = 1;

Parameter PAGENAME = "Generate Java Business Host";

Property JarFile As %ZEN.Datatype.className(ZENURL = "JARFILE");

Property JavaClass As %ZEN.Datatype.string(ZENURL = "JAVACLASS");

Property COSName As %ZEN.Datatype.string(ZENURL = "COSNAME");

Property Format As %ZEN.Datatype.string(ZENURL = "FORMAT");

Property Credentials As %ZEN.Datatype.string(ZENURL = "CREDENTIALS");

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Generate Java Business Host")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit ""
}

ClientMethod applyDetails() [ Language = javascript ]
{
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return '';
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" align="left" valign="middle" >
<label id="classname" enclosingClass="label" value="" enclosingStyle="padding-left: 10px;padding-bottom: 5px;" />
<label id="msgWait" enclosingClass="msg" enclosingStyle="padding-left: 10px;"/>
<label id="msgSuccess" enclosingClass="msg" hidden="true" enclosingStyle="padding-left: 10px;"/>
<label id="msgFailed" enclosingClass="msgError" hidden="true" enclosingStyle="padding-left: 10px;"/>
<iframe id="outputFrame" frameBorder="false" height="400" width="600"/>
</pane>
}

XData Style
{
<style type="text/css">
.label {
	font-weight: bold;
}
.msg {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.msgError {
	color: #da4848;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
}
</style>
}

/// Update label and set source for frame object
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Set tNameLabel = ..%GetComponentById("classname")
	If $IsObject(tNameLabel) Set tNameLabel.value = $$$FormatText($$$Text("Generating Business Host : %1"),..COSName)
	Set tWait = ..%GetComponentById("msgWait")
	If $IsObject(tWait) Set tWait.value = $$$TextHTML("Please wait, progress messages will appear below...")
	Set tSuccess = ..%GetComponentById("msgSuccess")
	If $IsObject(tSuccess) Set tSuccess.value = $$$FormatText($$$Text("Successfully generated class '%1'"),..COSName)
	Set tFailure = ..%GetComponentById("msgFailed")
	If $IsObject(tFailure) Set tFailure.value = $$$FormatText($$$Text("Failed to generate class '%1'"),..COSName)
	Set tOutputFrame = ..%GetComponentById("outputFrame")
	If $IsObject(tOutputFrame) {
		Set tQuery("JARFILE") = ..JarFile 
		Set tQuery("JAVACLASS") = ..JavaClass
		Set tQuery("COSNAME") = ..COSName
		Set tQuery("FORMAT") = ..Format
		Set tQuery("CREDENTIALS") = ..Credentials

		Set tOutputFrame.src = ..Link("EnsPortal.GenerateJBHFrame.cls", .tQuery)
	}
	Quit $$$OK
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	// make sure final messages are hidden now, but can be shown later
	document.getElementById('msgFailed').hidden = true;
	document.getElementById('msgSuccess').hidden = true;
	zen('msgFailed').setHidden(false);
	zen('msgSuccess').setHidden(false);
	
	this.invokeSuper('onloadHandler',[]);
}

ClientMethod onresizeHandler() [ Language = javascript ]
{
	this.adjustSizes();
}

ClientMethod adjustSizes() [ Language = javascript ]
{
	try{
		var totalHeight = zenGetWindowHeight();
		var totalWidth = zenGetWindowWidth();
		var frame = zenPage.getComponentById('outputFrame');
		var framew = totalWidth - 15;
		var frameh = totalHeight - 190;
		frame.setProperty('height',frameh);
		frame.setProperty('width',framew);
		if ((self.body.scrollWidth == self.body.offsetWidth) && (self.body.scrollLeft == 0 )) {
			frame.setProperty('height',totalHeight - 170);
		}
	}
	catch(ex){
		alert('Error in adjustSizes()');
	}
}

}

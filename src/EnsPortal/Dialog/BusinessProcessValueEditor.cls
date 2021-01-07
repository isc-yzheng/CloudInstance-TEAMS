/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This dialog lets users edit values for items within the Business Process BPL editor
/// or the Data Transformation DTL editor.
Class EnsPortal.Dialog.BusinessProcessValueEditor Extends (EnsPortal.Dialog.standardDialog, EnsPortal.Util.CodeEditorBase) [ System = 4 ]
{

/// User must have READ permissions on either the %Ens_Code or the %Ens_BPL resource to view this page.
Parameter RESOURCE = "%Ens_Code:READ,%Ens_BPL:READ";

/// User must have WRITE permissions on either the %Ens_Code or the %Ens_BPL resource to view this page.
Parameter EDITRESOURCE = "%Ens_Code:WRITE,%Ens_BPL:WRITE";

Parameter APPLYBUTTON = 0;

/// Name of property
Property propertyName As %ZEN.Datatype.string(ZENURL = "PROPERTY");

/// Type of property
Property propertyType As %ZEN.Datatype.string(ZENURL = "TYPE");

/// Value of property
Property propertyValue As %ZEN.Datatype.string(ZENURL = "VALUE");

/// Programming language for the BP.
Property bpLanguage As %ZEN.Datatype.string(ZENURL = "LANG");

/// Id of main value property.
Property ctrlId As %ZEN.Datatype.string;

/// Csv list of properties in BP context.
Property contextList As %ZEN.Datatype.string(MAXLEN = 30000, ZENURL = "CONTEXTLIST");

/// Name of context super class.
Property classContextSuper As %ZEN.Datatype.string(ZENURL = "CONTEXTSUPER");

/// Name of response class.
Property classResponse As %ZEN.Datatype.string(ZENURL = "RESPONSE");

/// Name of request class.
Property classRequest As %ZEN.Datatype.string(ZENURL = "REQUEST");

/// Csv list of activity names in BP.
Property activityList As %ZEN.Datatype.string(MAXLEN = 30000, ZENURL = "NAMES");

XData Style
{
<style type="text/css">

.zenLabel {
	font-size: 12px;
	color: #404040;
	padding-top: 3px;
	padding-left: 1px;
	display: block;
}

.zenHint {
	font-size: 11px;
	color: #606060;
	padding-bottom: 2px;
}

.radioButtonCaption,
a.multiSelectSetCaption {
	color: #404040;
	font-size: 11pt;
}

#desc1, #desc2 {
	color: #404040;
	font-size: 10pt;
}
</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" width="100%">

<html id="desc1"/>

<text id="ctrlValue" hidden="true" size="60" label="Value" onkeydown="return zenPage.ctrlKeyDown(zenEvent);"/>
<textarea id="ctrlCode" hidden="true" rows="30" cols="30" label="Code" onkeydown="return zenPage.ctrlKeyDown(zenEvent,true);" controlStyle="overflow: auto;"/>
<textarea id="ctrlExpression" hidden="true" rows="2" cols="50" label="Expression" onkeydown="return zenPage.ctrlKeyDown(zenEvent,true);"/>
<combobox id="ctrlPropList" hidden="true" size="30" editable="true" unrestricted="true" dropdownWidth="250px" hzScroll="true" label="Property" ondblclick="zenPage.dialogFinish();" onkeydown="return zenPage.ctrlKeyDown(zenEvent);"/>
<multiSelectSet id="ctrlMulti" hidden="true"/>

<vgroup id="groupHost" hidden="true">
<spacer height="5"/>
<combobox id="ctrlProduction" size="50" label="Production" unrestricted="true" editable="true" hint="Name of production containing host" onchange="zenPage.changeProduction(zenThis.getValue());"/>

<spacer height="5"/>
<radioButton id="radioHost" name="hostType" caption="Business Operation" optionValue="operation" onchange="zenPage.hostChange();"/>
<combobox id="ctrlOperation" size="40" unrestricted="true" editable="true"/>

<spacer height="5"/>
<radioButton name="hostType" caption="Business Process" optionValue="process" onchange="zenPage.hostChange();" />
<combobox id="ctrlProcess" size="40" unrestricted="true" editable="true"/>

<spacer height="5"/>
<radioButton name="hostType" caption="Business Process Component" optionValue="component" onchange="zenPage.hostChange();" />
<combobox id="ctrlComponent" size="40" unrestricted="true" editable="true"/>

<spacer height="5"/>
<radioButton name="hostType" caption="Context Variable" optionValue="variable" onchange="zenPage.hostChange();"/>
<combobox id="ctrlVariable" size="40" unrestricted="true" editable="true" hint="Variable containing name of host to send request to"/>

</vgroup>

<html id="desc2"/>

</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Value Editor")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Edit a property value")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	// escape contents as they may contain % characters and core Zen code 
	// attempts to decode the contents
	return encodeURIComponent(this.propertyValue);
}

ClientMethod validate() [ Language = javascript ]
{
	if (this.ctrlId == '') {
		return true;
	}
	var value = zen(this.ctrlId).getValue();
	var isValid = true;
	switch (this.propertyType) {
		case 'code':
		case 'expression':
			var opener = this.getOpener();
			if (opener && opener.zenPage && opener.zenPage.validateCode) {
				isValid = opener.zenPage.validateCode(value, window, true);
			}
			break;
		
	}
	return isValid;
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br/>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		if (this.checkEdit()) {
			if (!this.validate()) {
				return false;
			}
			if (this.ctrlId!="") {
				this.propertyValue = zen(this.ctrlId).getValue();
			}
		
			var prod = '';
			if (this.propertyType == 'host') {
				prod = zen('ctrlProduction').getValue();
				switch(zen('radioHost').getValue()) {
				case 'operation':
					this.propertyValue = zen('ctrlOperation').getValue();
					break;
				case 'process':
					this.propertyValue = zen('ctrlProcess').getValue();
					break;
				case 'component':
					this.propertyValue = zen('ctrlComponent').getValue();
					break;
				case 'variable':
					this.propertyValue = zen('ctrlVariable').getValue();
					break;
				} 
			}

			if ('' != prod) {
				var ok = zenPage.SetLastProduction(prod);
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

/// This callback, if defined, is called when the dialog page is loaded.
ClientMethod ondialogStart() [ Language = javascript ]
{
	if ((this.propertyType == 'code') && (this.propertyValue == '')) {
		var opener = this.getOpener();
		if (opener && opener.zenPage && opener.zenPage._currProperty) {
			var parentCtrl = opener.zenPage.getComponentById(opener.zenPage._currProperty);
			if (parentCtrl) {
				this.propertyValue = parentCtrl.getValue();
				zen('ctrlCode').setValue(this.propertyValue);
			}
		}
	}
	if (this.ctrlId!='') {
		var ctrl = zen(this.ctrlId);
		if (ctrl) {
			try {
				ctrl.focus();
				if (this.propertyType != 'code') ctrl.select();
			}
			catch (ex) {
			}
		}
	}

	this.hostChange();
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Try {

		Set tDesc1 = ""
		Set tDesc2 = ""
		Set tNewLabel = ""
		Set ..ctrlId = "ctrlValue"

		// general settings
		If (..propertyType="expression") {
			If ($$$LOWER(..bpLanguage)["basic") {
				Set tDesc1 = $$$Text("Enter a valid BASIC expression.")
			}
			Else {
				Set tDesc1 = $$$Text("Enter a valid ObjectScript expression.")
			}
			Set ..ctrlId = "ctrlExpression"
		}
		ElseIf (..propertyType="code") {
			If ($$$LOWER(..bpLanguage)["basic") {
				Set tDesc1 = $$$Text("Enter valid BASIC code.")
			}
			Else {
				Set tDesc1 = $$$Text("Enter valid ObjectScript code.")
			}
			Set ..ctrlId = "ctrlCode"
			Set tNewLabel = $$$Text("Code")
			#; Ensure that we auto-indent the code block
			Set tCodeEditor = ..%GetComponentById("ctrlCode")
			Set tCodeEditor.onkeypress = "return zenPage.codeKeyPress(zenThis,zenEvent);"
		}
		ElseIf (..propertyType="sql") {
			Set tDesc1 = $$$Text("Enter a valid embedded SQL select statement.")
			Set tDesc2 = $$$Text("For example, SELECT SSN INTO :context.SSN FROM MyApp.PatientTable WHERE PatID = :request.PatID")
			Set ..ctrlId = "ctrlCode"
			Set tNewLabel = $$$Text("SQL Statement")
		}
		ElseIf (..propertyType="property") {
			Set tDesc1 = $$$Text("Enter a property name.")
			Set ..ctrlId = "ctrlPropList"

			Set tPropList = ..%GetPropertyList(,1)
			Set ..%GetComponentById("ctrlPropList").valueList = tPropList
			
			If (tPropList="") {
				Set ..ctrlId = "ctrlValue"
				Set tDesc2 = $$$Text("This item has no context properties defined.")
			}

		}
		ElseIf (..propertyType="value") {
			If ($$$LOWER(..bpLanguage)["basic") {
				Set tDesc1 = $$$Text("Enter a valid BASIC expression or select a property.")
			}
			Else {
				Set tDesc1 = $$$Text("Enter a valid ObjectScript expression or select a property.")
			}
			Set ..ctrlId = "ctrlPropList"
			Set tPropList = ..%GetPropertyList(,1)
			Set tControl = ..%GetComponentById("ctrlPropList")
			Set tControl.valueList = tPropList
			Set tControl.size = 40
			Set tControl.label = $$$Text("Value")
			
			If (tPropList="") {
				Set ..ctrlId = "ctrlValue"
				Set tDesc2 = $$$Text("This item has no context properties defined.")
			}
		}
		ElseIf (..propertyType="labels") {
			Set tDesc1 = $$$Text("Enter a label name.")
			Set ..ctrlId = "ctrlPropList"
			Set ..%GetComponentById("ctrlPropList").valueList = ..activityList
		}
		ElseIf (..propertyType="calls") {
			Set tDesc1 = $$$Text("Enter one or more call activity names.")
			Set ..ctrlId = "ctrlMulti"

			Set ..%GetComponentById("ctrlMulti").valueList = ..activityList
			Set ..%GetComponentById("ctrlMulti").displayList = ..activityList
		}
		ElseIf (..propertyType="duration") {
			Set tDesc1 = $$$Text("Specifies a duration as an expression that evaluates to an XML duration value.")
			Set tDesc2 = $$$Text("A string of one or more characters; for example ""PT60S"" for 60 seconds or ""P1Y2M3DT10H30M"" for 1 year, 2 months, 3 days, 10 hours, and 30 minutes.")
			Set ..ctrlId = "ctrlValue"
		}
		ElseIf (..propertyType="dateTime") {
			Set tDesc1 = $$$Text("Specifies a future time at which a delay or timeout will expire, as an expression that evaluates to an XML dateTime value.")
			Set tDesc2 = $$$Text("A string of one or more characters; for example ""2003:10:19T10:10""")
			Set ..ctrlId = "ctrlValue"
		}
		ElseIf (..propertyType="xslurl") {
			Set tDesc1 = $$$Text("URI of the XSLT definition that controls the transformation. The URI may begin with one of the following strings: ""file:"" ""http:"" ""url:"" or ""xdata:""")
			Set tDesc2 = $$$Text("A string of up to 250 characters; for example, ""http://www.intersystems.com/transform.xsl""")
			Set ..ctrlId = "ctrlValue"
		}
		ElseIf (..propertyType="xpath") {
			Set tDesc1 = $$$Text("Enter a valid XPATH expression.")
			Set tDesc2 = $$$Text("For example, ""name[@last='Presley']""")
			Set ..ctrlId = "ctrlValue"
		}
		ElseIf (..propertyType="host") {
			Set tDesc1 = $$$Text("The configured name of the business host to send the request to.")
			Set ..%GetComponentById("groupHost").hidden = 0
			Set ..ctrlId = ""

			Set tProdList = ..%GetProductionList()
			Set ..%GetComponentById("ctrlProduction").valueList = tProdList

			Set tLastProd = $G(^EnsPortal.Settings($UserName,"LastProduction"))
			Set ..%GetComponentById("ctrlProduction").value = tLastProd

			Set tBOList = ..GetHostList(tLastProd,"operation")
			Set ..%GetComponentById("ctrlOperation").valueList = tBOList

			Set tBPList = ..GetHostList(tLastProd,"process")
			Set ..%GetComponentById("ctrlProcess").valueList = tBPList

			Set tBPCList = ..GetHostList(tLastProd,"component")
			Set ..%GetComponentById("ctrlComponent").valueList = tBPCList

			Set tPropList = ..%GetPropertyList(1)
			Set ..%GetComponentById("ctrlVariable").valueList = tPropList

			// make a good guess as to what type of host this is.
			If ($E(..propertyValue)="@") {
				Set ..%GetComponentById("ctrlVariable").value = ..propertyValue
				Set ..%GetComponentById("radioHost").value = "variable"
			}
			ElseIf ((","_tBPList_",")[(","_..propertyValue_",")) {
				Set ..%GetComponentById("ctrlProcess").value = ..propertyValue
				Set ..%GetComponentById("radioHost").value = "process"
			}
			ElseIf ((","_tBPCList_",")[(","_..propertyValue_",")) {
				Set ..%GetComponentById("ctrlComponent").value = ..propertyValue
				Set ..%GetComponentById("radioHost").value = "component"
			}
			Else {
				Set ..%GetComponentById("ctrlOperation").value = ..propertyValue
				Set ..%GetComponentById("radioHost").value = "operation"
			}
		}
	
		If (..ctrlId'="") {
			Set tControl = ..%GetComponentById(..ctrlId)
			Set tControl.value = ..propertyValue
			Set tControl.hidden = 0
			If tNewLabel '= "" {
				Set tControl.label = tNewLabel
			}
		}

		Set ..%GetComponentById("desc1").content = tDesc1
		Set ..%GetComponentById("desc2").content = tDesc2

	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Click on host radio button.
ClientMethod hostChange() [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }
	
	var type = zen('radioHost').getValue();

	switch(type) {
	case 'operation':
		zen('ctrlProcess').setDisabled(true);
		zen('ctrlComponent').setDisabled(true);
		zen('ctrlOperation').setDisabled(false);
		zen('ctrlVariable').setDisabled(true);
		break;
	case 'process':
		zen('ctrlProcess').setDisabled(false);
		zen('ctrlComponent').setDisabled(true);
		zen('ctrlOperation').setDisabled(true);
		zen('ctrlVariable').setDisabled(true);
		break;
	case 'component':
		zen('ctrlProcess').setDisabled(true);
		zen('ctrlComponent').setDisabled(false);
		zen('ctrlOperation').setDisabled(true);
		zen('ctrlVariable').setDisabled(true);
		break;
	case 'variable':
		zen('ctrlProcess').setDisabled(true);
		zen('ctrlComponent').setDisabled(true);
		zen('ctrlOperation').setDisabled(true);
		zen('ctrlVariable').setDisabled(false);
		break;
	}
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	switch(popupName) {
	}
}

/// Key handler for value edit control.
ClientMethod ctrlKeyDown(evt, escOnly) [ Language = javascript ]
{
	switch(evt.keyCode) {
	case zenENTER:
		if (!escOnly) {
			if (evt) {
				if (evt.stopPropagation) {
					evt.stopPropagation();
				}
			}
			// force control to update value before closing the dialogue window
			var control = zen(this.ctrlId);
			if (control) {
				switch (this.ctrlId) {
					case 'ctrlPropList':
						control.inputChangeHandler()
						break;
				}
			}
			this.dialogFinish();
		}
		break;
	case zenESC:
		this.dialogCancel();
		break;
	}
	return true;
}

/// Change in production select.
ClientMethod changeProduction(prod) [ Language = javascript ]
{
	if (!this.checkEdit()) { return false; }
	
	var bpList = this.GetHostList(prod,"process");
	var bpcList = this.GetHostList(prod,"component");
	var opList = this.GetHostList(prod,"operation");

	zen('ctrlProcess').setProperty('valueList',bpList);
	zen('ctrlProcess').setProperty('displayList',bpList);

	zen('ctrlComponent').setProperty('valueList',bpcList);
	zen('ctrlComponent').setProperty('displayList',bpcList);

	zen('ctrlOperation').setProperty('valueList',opList);
	zen('ctrlOperation').setProperty('displayList',opList);
}

/// Build a csv-list of available productions.
Method %GetProductionList() As %String
{
	Set tList = ""
	Do ##class(EnsPortal.Utils).GetProductionList(.tProdList)

	Set p = $O(tProdList(""))
	While (p'="") {
		Set tList = tList _ $S(tList="":"",1:",") _ p
		Set p = $O(tProdList(p))
	}
	Quit tList
}

/// Build a csv-list of available host names.
ClassMethod GetHostList(pProduction As %String, pType As %String) As %String [ ZenMethod ]
{
	Set tList = ""
	If (pProduction'="") {
		Do ##class(EnsPortal.Utils).GetItemsForProduction(pProduction,pType,.tHostList)

		Set p = $O(tHostList(""))
		While (p'="") {
			Set tList = tList _ $S(tList="":"",1:",") _ p
			Set p = $O(tHostList(p))
		}
	}
	Quit tList
}

/// Build a csv-list of available properties.
Method %GetPropertyList(pIndirect As %Boolean = 0, pIncludeVariable As %Boolean = 0) As %String
{
	Set tList = ""
	Try {
		// context list
		For p=1:1:$L(..contextList,",") {
			Set tProp = $P(..contextList,",",p)
			If (tProp'="") {
				Set tPropList("context",tProp) = ""
			}
		}

		// get properties for classes
		Set tSC = ..%GetPropertiesForClass(..classContextSuper,.tCList)
		Merge tPropList("context") = tCList

		Set tSC = ..%GetPropertiesForClass(..classRequest,.tCList)
		Merge tPropList("request") = tCList

		Set tSC = ..%GetPropertiesForClass(..classResponse,.tCList)
		Merge tPropList("response") = tCList

		If pIncludeVariable {
			Set tPropList("request") = ""
			Set tPropList("response") = ""
			Set tPropList("context") = ""
		}

		Set k = $O(tPropList(""))
		While (k'="") {
			If pIncludeVariable Set tList = tList _ $S(tList="": "", 1: ",") _ $S(pIndirect: "@", 1: "") _ k
			Set p = $O(tPropList(k,""))
			While (p'="") {
				Set tList = tList _ $S(tList="":"",1:",") _ $S(pIndirect:"@",1:"")_ k _ "." _ p
				Set p = $O(tPropList(k,p))
			}
			Set k = $O(tPropList(k))
		}

	}
	Catch (ex) {
		Set tList = $ZE
	}
	Quit tList
}

/// Return an array of properties for the given class.
Method %GetPropertiesForClass(pClass As %String, Output pList) As %Status
{
	Set tSC = $$$OK
	Try {
		Kill pList
		If (pClass="") Quit

		Set tSC = ##class(Ens.Rule.Utils).GetPropertyList(.tList,pClass)
		If $$$ISERR(tSC) Quit

		Set k = $O(tList(""))
		While (k'="") {
			Set tName = $LG(tList(k),1)
			Set:tName'="" pList(tName) = ""
			Set k = $O(tList(k))
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Remember last production.
ClassMethod SetLastProduction(pProd As %String) As %Boolean [ ZenMethod ]
{
	Set tOK = 1
	Try {
		If (pProd'="") {
			Set ^EnsPortal.Settings($UserName,"LastProduction") = pProd
		}
	}
	Catch(ex) {
		Set tOK = 0
	}
	Quit tOK
}

/// This client event, if present, is fired when the page is resized.
ClientMethod adjustSize() [ Language = javascript ]
{
	this.invokeSuper('adjustSize',arguments);
	if (this.propertyType == 'code' || this.propertyType == 'sql') {
		var body = self.document.getElementById('body');
		var code = zen('ctrlCode');
		if (code && body) {
			var codeEl = code.findElement('control');
			if (codeEl) {
				var bodyWidth = body.clientWidth ? body.clientWidth : body.scrollWidth;
				var bodyHeight = body.clientHeight ? body.clientHeight : body.scrollHeight;
				var codeWidth = codeEl.clientWidth ? codeEl.clientWidth : codeEl.scrollWidth;
				var codeHeight = codeEl.clientHeight ? codeEl.clientHeight : codeEl.scrollHeight;
				
				var plusSQL = 10 * (this.propertyType == 'sql')

				if (bodyWidth > (codeWidth + 30)) {
					codeEl.style.width = (bodyWidth - 30) + 'px';
				}
				else if (bodyWidth < (codeWidth + 30)) {
					codeEl.style.width = (bodyWidth < 300 ? 300 : bodyWidth - 30) + 'px';
				}
				if (bodyHeight > (codeHeight + 80 + plusSQL)) {
					codeEl.style.height = (bodyHeight - 80 - plusSQL) + 'px';
				}
				else if (bodyHeight < (codeHeight + 80) + plusSQL) {
					codeEl.style.height = (bodyHeight < 280 ? 280 : bodyHeight - 80 - plusSQL) + 'px';
				}
			}
		}
	}
}

}

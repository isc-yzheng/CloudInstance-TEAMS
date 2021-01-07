/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Zen based DICOM Settings UI
Class EnsPortal.DICOM.Setting Extends EnsPortal.Template.standardPage [ System = 4 ]
{

/// User must have WRITE permissions on the %Ens_ProductionConfig resource to view this page.
Parameter RESOURCE = "%Ens_ProductionConfig:WRITE";

Parameter PAGENAME = "DICOM Setting";

Property msgAdd As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Use the form below to create a new DICOM association context setting in %1: ")} ];

Property msgEdit As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Edit DICOM association context setting in %1: ")} ];

/// Message that is built with the namespace in it.
Property msgTable As %ZEN.Datatype.caption;

Property msgDeleteContext1 As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please click on the Abstract Syntax you want to delete first and try again.")} ];

Property msgDeleteContext2 As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Are you sure you want to delete this abstract syntax?")} ];

Property msgDeleteContext3 As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Presentation context deleted.")} ];

Property msgEditContext As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please click on the Abstract Syntax you want to edit first and try again.")} ];

Property msgTS As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Please check at least one Transfer Syntax.")} ];

Property msgLegendAdd As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Add Presentation Context")} ];

Property msgPreserve As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("You have changed the Calling AET and Called AET combination. Click [OK] to preserve the old association or [Cancel] to delete the old association.")} ];

Property msgExists As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("This Calling AET and Called AET combination already exists.")} ];

/// The last selected PID
Property PID As %ZEN.Datatype.string(ZENURL = "PID");

Property isNew As %String(ZENURL = "isNew") [ InitialExpression = "0" ];

/// This is the index number that user is currently editing.
Property editIndex As %Integer [ InitialExpression = "-1" ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
#tree {
	border: 1px gray solid;
	height: 250px;
	overflow: auto;
}
/* Override static setting of 399px */
.tabGroupBody {
	width: auto;
}
.fieldSet {
}
</style>
}

/// This XML block defines the contents of the table pane.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<spacer height="10" />
<hgroup id="idButton" >
<text id="PID" hidden="true"/>
<label id="result" controlClass="redText" value=""/>
</hgroup>
<tabGroup id="tabs" showTabBar="true" currTab="1" width="700" hidden="false">
<tab id="tab1" caption="Association Context">
<spacer height="5" />
<vgroup id="fld" cellStyle="padding:5px;" labelPosition="left" >
<text id="txtCallingAET" label="Calling AET:" labelClass="caption" maxlength="16" size="30" hint="Required. Enter no more than 16 characters." hintClass="helpText" />
<text id="txtCalledAET" label="Called AET:" labelClass="caption" maxlength="16" size="30" hint="Required. Enter no more than 16 characters." hintClass="helpText" />
<text id="txtName" label="Name:" labelClass="caption" maxlength="64" size="62" hint="Optional. Enter no more than 64 characters." hintClass="helpText" />
<textarea id="txtDescription" label="Description:" labelClass="caption" cols="48" rows="5" hint="Optional. Enter no more than 254 characters." hintClass="helpText" />
<hgroup containerStyle="padding-bottom:2px;">
<button controlClass="commandButton" name="btnSave" id="btnSave" caption="Save" onclick="zenPage.saveSetting();"/>
<button controlClass="commandButton" caption="Close" onclick="return zenPage.cancelSetting();" containerStyle="padding-left:4px;"/>
</hgroup>
<spacer height="5"/>
</vgroup>
</tab>

<tab id="tab2" caption="Presentation Context" enclosingStyle="padding:10px;" disabled="true">
<spacer height="5" />
<hgroup enclosingStyle="background:#CBE6EB;border:1px gray solid;" cellStyle="padding-right:2px;" labelPosition="left">
<image id="imgReturn" src="images/SmLeftArrow.png" width="15" height="15" alt="Return to list." onclick="zenPage.upOneLevel();"/>
<link id="linkReturn" href="javascript:zenPage.upOneLevel();" caption="Return" containerStyle="font-size:0.7em;" title="Return to list."/>
<spacer width="4px"/>
<image id="imgAdd" src="images/file.png" width="16" height="16" alt="Add a new presentation context." onclick="zenPage.addContext();"/>
<link id="linkAdd" href="javascript:zenPage.addContext();" caption="Add" containerStyle="font-size:0.7em;" title="Add a new presentation context."/>
<spacer width="4px"/>
<image id="imgDelete" src="images/cut.png" width="16" height="16" alt="Click on an abstract syntax then click here to delete." onclick="zenPage.deleteContext();"/>
<link id="linkDelete" href="javascript:zenPage.deleteContext();" caption="Delete" containerStyle="font-size:0.7em;" title="Click on an abstract syntax then click here to delete." />
<spacer width="4px"/>
<image id="imgEdit" src="images/datetext.gif" width="16" height="16" alt="Click on an abstract syntax then click here to edit." onclick="zenPage.editContext();"/>
<link id="linkEdit" href="javascript:zenPage.editContext();" caption="Edit" containerStyle="font-size:0.7em;" title="Click on an abstract syntax then click here to edit." />
<spacer width="4px"/>
</hgroup>
<dynaTree
	id="tree" showLines="true"
	OnGetTreeInfo="GetTreeInfo"
	onupdate="zenPage.treeCount();">
	<parameter paramName="pid" value="20"/>
</dynaTree>
<vgroup id="fld1" cellStyle="padding:5px;" hidden="true">
<listBox id="comboAS" label="Abstract Syntax: (Required - select one from the list)" labelClass="caption" enclosingStyle="font-size:11px;"/>
<label id="idListRequired" label="Please choose an abstract syntax from the list." labelClass="redText" hidden="true"/>
<hgroup id="g1" cellVAlign="middle" >
<listBox name="lst" id="lst" label="Available Transfer Syntax" labelClass="caption" enclosingStyle="font-size:11px;" ondblclick="zenPage.arrowClick('lst','lstselect');" listWidth="270px" listHeight="100px" hzScroll="true">
</listBox>
<spacer width="4"/>
<button id="btnL1" caption="&lt;" onclick="zenPage.arrowClick('lstselect','lst');"/>
<button id="btnR1" caption="&gt;" onclick="zenPage.arrowClick('lst','lstselect');"/>
<spacer width="4"/>
<listBox name="lstselect" id="lstselect" label="Selected Transfer Syntax" labelClass="caption" enclosingStyle="font-size:11px;" ondblclick="zenPage.arrowClick('lstselect','lst');" listWidth="270px" listHeight="100px" hzScroll="true">
</listBox>
</hgroup>
<label id="idCheckRequired" label="Please select at least one transfer syntax." labelClass="redText" hidden="true"/>
<hgroup containerStyle="padding-bottom:4px;">
<button controlClass="commandButton" name="btnSave1" id="btnSave1" caption="Save" containerStyle="padding-left:4px;" onclick="zenPage.saveContext();"/>
<button controlClass="commandButton" caption="Cancel" onclick="zenPage.upOneLevel();" containerStyle="padding-left:4px;"/>
</hgroup>
<spacer height="5"/>
</vgroup>

</tab>
</tabGroup>
</pane>
}

/// User click one of the arrows. id passed in is the list box id.
ClientMethod arrowClicked(id) [ Language = javascript ]
{
	zenPage.arrowMoved(zenPage.getComponentById(id));
}

/// User double clicked one of the listboxes. Update imply message. 
ClientMethod arrowMoved(thisObj) [ Language = javascript ]
{
	try {
		var id = thisObj.getProperty("id");
		arrowClicked(id);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Enable fields for presentation context. Initialize all fields.
ClientMethod addContext() [ Language = javascript ]
{
	this.hideTree(true);
	zenPage.getComponentById("fld1").setProperty("legend",this.msgLegendAdd);
	this.editIndex = -1;
	var comboAS = zenPage.getComponentById("comboAS");
	comboAS.setHidden(false);
	comboAS.focus();
	this.loadAva();
}

/// Cancel out of Add/Edit.
ClientMethod cancelSetting() [ Language = javascript ]
{
	var page = "EnsPortal.DICOM.Settings.zen";
	this.gotoPage(page);
	return;
}

/// Delete existing presentation context from a known assiciation.
ClientMethod deleteContext() [ Language = javascript ]
{
	try {
		var tree = zenPage.getComponentById("tree");
		var nodeCount = tree.getProperty("nodeCount");
		var index = tree.getProperty("selectedIndex");
		if (index >= nodeCount) {
			var parent = tree.getNodeParent(index);
			if (parent < 0) return;
			index = parent;
			tree.setProperty("selectedIndex",index);
		}
		var as = tree.getProperty("text");
		if (index < 0) {
			alert(this.msgDeleteContext1);
			return;
		}
		var ok = confirm(this.msgDeleteContext2);
		if (ok == false) return;
		
		var ok = this.DeleteDataContext(this.PID,index);
		if (ok == 1) {
			tree.refreshContents();
			ok = this.msgDeleteContext3 + "("+as+")";
			//zenPage.getComponentById("result").setProperty("value",ok);
		} else {
			alert(ok);
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Enable fields for presentation context. Load fields.
ClientMethod editContext() [ Language = javascript ]
{
	try {
		var tree = zenPage.getComponentById("tree");
		var nodeCount = tree.getProperty("nodeCount");
		var index = tree.getProperty("selectedIndex");
		if (tree.getNodeParent(index)) {
			var parent = tree.getNodeParent(index);
			if (parent >= 0) {
				index = parent;
				tree.setProperty("selectedIndex",index);
			}
		}
		if (index < 0) {
			alert(this.msgEditContext);
			return;
		}
		zen("lst").resetOptions();
		zen("lstselect").resetOptions();
		this.editIndex = index;
		// Now load data for this context
		var tAS = this.EditDataContext(this.PID,index);
		this.hideTree(true);
		var comboAS = zenPage.getComponentById("comboAS");
		comboAS.setValue(tAS);
		comboAS.setHidden(true);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Show or hide Transfer Syntax under a Abstract Syntax.
ClientMethod expandNode(node) [ Language = javascript ]
{
	var tree = zenPage.getComponentById("tree");
	tree.toggleExpanded(node);
}

/// When user clicks Add for Presentation Context, we hide the tree (flag=true).
/// After user saves changes, or cancel out, we show the tree (flag=false).
ClientMethod hideTree(flag) [ Language = javascript ]
{
	zenPage.getComponentById("tree").setHidden(flag);
	var fld1 = zenPage.getComponentById("fld1");
	var imgAdd = zenPage.getComponentById("imgAdd");	
	var imgDelete = zenPage.getComponentById("imgDelete");	
	var imgEdit = zenPage.getComponentById("imgEdit");	
	var linkAdd = zenPage.getComponentById("linkAdd");	
	var linkDelete = zenPage.getComponentById("linkDelete");
	var linkEdit = zenPage.getComponentById("linkEdit");
	if (flag == true) {
		fld1.setHidden(false);
		imgAdd.setHidden(true);
		imgDelete.setHidden(true);
		imgEdit.setHidden(true);
		linkAdd.setHidden(true);
		linkDelete.setHidden(true);
		linkEdit.setHidden(true);
		/// reset the listbox and hide warning messages in case they are shown.
	 	zenPage.getComponentById("comboAS").setProperty("selectedIndex",-1);
	 	zenPage.getComponentById("idListRequired").setHidden(true);
	 	zenPage.getComponentById("idCheckRequired").setHidden(true);
	} else {
		fld1.setHidden(true);
		imgAdd.setHidden(false);
		linkAdd.setHidden(false);
		imgEdit.setHidden(false);
		linkEdit.setHidden(false);
		this.treeCount();
	}
}

/// Return selected transfer syntax as string
ClientMethod getSyntax() As %String [ Language = javascript ]
{
	var groups = zenPage.getComponentById("lstselect");
	var total = groups.getOptionCount();
	var selectedSyntax = "";
	for (var x = 0; x < total; x++) {
		selectedSyntax = selectedSyntax + groups.getOptionValue(x) + ",";
	}
	return selectedSyntax
}

/// Clear the Avaliable and Selected list boxes and reload the Available box.
ClientMethod loadAva() [ Language = javascript ]
{
	zen("lstselect").resetOptions();	
	zen("lst").resetOptions();
	this.LoadAvaContext();
}

/// Get user selection and send to server to save presentation context settings.
ClientMethod saveContext() [ Language = javascript ]
{
	try {
		var comboAS = zenPage.getComponentById("comboAS");
		var selectedSyntax = this.getSyntax();
		var idListRequired = zenPage.getComponentById("idListRequired");
		var idCheckRequired = zenPage.getComponentById("idCheckRequired");
		var ok = 1;
		if (comboAS.getValue() == "") {
			idListRequired.setHidden(false);
			ok = 0;
		} else {
			idListRequired.setHidden(true);
		}
		if (selectedSyntax == "") {
			idCheckRequired.setHidden(false);	
			ok = 0;
		} else {
			idCheckRequired.setHidden(true);
		}
		if (ok == 0) return;

		var proxy = this.SaveDataContext(this.PID,comboAS.getValue(),selectedSyntax,this.editIndex);
		if (proxy.ok == 1) {
			this.PID = proxy.PID;
			// Refresh tree:
			var tree = zenPage.getComponentById("tree");
			tree.refreshContents();
			this.hideTree(false);
			// if this is a Save Context then expand the edited node
			if (this.editIndex > -1) tree.selectItem(this.editIndex);
			comboAS.setProperty("selectedIndex",-1);
		} else {
			alert(proxy.Message);
		}
	} 
  catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Get user selection and send to server to save settings.
ClientMethod saveSetting() [ Language = javascript ]
{
	try {
		var calling = zenPage.getComponentById("txtCallingAET");
		var called = zenPage.getComponentById("txtCalledAET");
		var ok = 1;
		// if entering a new association, check if required fields are filled.
		var isnew = 0;
		var isRename = 0;
		var preserve = 0;
		if (this.PID.length < 1) {
			isnew = 1;
			if (this.CheckAllBlanks(calling.getValue()) == 1) {
				calling.setProperty("hintClass","redText")
				calling.focus();
				ok = 0;
			} else {
				calling.setProperty("hintClass","helpText")
			}
			if (this.CheckAllBlanks(called.getValue()) == 1) {
				called.setProperty("hintClass","redText")
				if (ok == 1) called.focus();
				ok = 0;
			} else {
				called.setProperty("hintClass","helpText")
			}
		} else {
			var newid = calling.getValue()+"||"+called.getValue();
			// if user modified ID values:
			if (newid != this.PID) {
				isRename = 1;
				//check if this new id already exists
				var IDExists = this.IDExists(newid);
				if (IDExists) {
					alert(this.msgExists);
					ok = 0;
				} else {
					if (confirm(this.msgPreserve) == true) preserve = 1;
				}
			}
		}
		if (ok == 0) {
			// reset previous result message, if any
			zenPage.getComponentById("result").setValue("");
			return;
		}
		var name = zenPage.getComponentById("txtName");
		var desc = zenPage.getComponentById("txtDescription");
		var proxy = this.SaveData(this.PID,calling.getValue(),called.getValue(),name.getValue(),desc.getValue(),preserve);
		if (proxy.ok == 1) {
			// if it's a new PID, take to Presentation Context
			if (isnew == 1) {
				this.PID = proxy.PID;
				var tabs = zenPage.getComponentById("tabs");
				zenPage.getComponentById("tab2").setProperty("disabled",false);
				tabs.setProperty("currTab",2);
				calling.setProperty("disabled",true);
				calling.setProperty("hintClass","helpText")
				called.setProperty("disabled",true);
				called.setProperty("hintClass","helpText")
				zenPage.getComponentById("result").setProperty("value",proxy.Message)
				this.isNew = 0;
			} else if (isRename == 1) {
				// make sure page edits new PID, not old one
				this.PID = proxy.PID;
			}
		} 
		zenPage.getComponentById("result").setProperty("value",proxy.Message);
	} 
  catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// check total Abstract Syntax tree count for presentation context.
/// this method is triggled from onupdate from the tree control.
ClientMethod treeCount() [ Language = javascript ]
{
	if (zenPage.getComponentById("tree").getProperty("nodeCount")<1) {
		this.toggleDelete(true);
	} else {
		this.toggleDelete(false);
	}
}

/// show or hide image and link Delete for presentation context
ClientMethod toggleDelete(flag) [ Language = javascript ]
{
	zenPage.getComponentById('imgDelete').setHidden(flag);
	zenPage.getComponentById('linkDelete').setHidden(flag);
	zenPage.getComponentById('imgEdit').setHidden(flag);
	zenPage.getComponentById('linkEdit').setHidden(flag);
}

/// load tree based on given PID
ClientMethod treeLoad() [ Language = javascript ]
{
	var tree = this.getComponentById('tree');
	//tree.parameters["pid"].value = pid;
	tree.refreshContents();
}

/// Up one level:
/// If tree is currently hidden, then go to Association list.
/// Else, go to Presentation list.
ClientMethod upOneLevel() [ Language = javascript ]
{
	var treeState = zenPage.getComponentById("tree").getHidden();
	if (treeState == true) {
		this.hideTree(false);
	} else {
		this.cancelSetting();
	}
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	Quit:'tSC tSC
	
	Set msgTable = $$$FormatText($S(%page.isNew=1:%page.msgAdd,1:%page.msgEdit),$namespace)
	Set ..%GetComponentById("Text1").value = msgTable
	Set %page.msgTable = msgTable
	
	#; Load Abstract Syntax select box once:
	Set tCombo = ..%GetComponentById("comboAS")
	Set item = ""
	Set item = $O(^EnsDICOM.Dictionary("as","t",item))
	While item '= "" {
		Set tOption = ##class(%ZEN.Auxiliary.option).%New()
		Do tCombo.options.Insert(tOption)
		Do ..%AddComponent(tOption)
		Set tOption.text = item
		Set tOption.value = ^(item)
		Set item = $O(^EnsDICOM.Dictionary("as","t",item))
	}
	If %page.PID '= "" {
		Set ..%GetComponentById("tab2").disabled = 0
		// Need this to be sync call to avoid problem for delete
		Do ..UpdateDetails(%page.PID)
	}

	#; Load Transer Syntax into Available listbox:
	Set tCombo = ..%GetComponentById("lst")
	Set item = ""
	Set item = $O(^EnsDICOM.Dictionary("ts","u",item))
	While item '= "" {
		Set tOption = ##class(%ZEN.Auxiliary.option).%New()
		Do tCombo.options.Insert(tOption)
		Do ..%AddComponent(tOption)
		Set tOption.text = ^(item)
		Set tOption.value = item
		Set item = $O(^EnsDICOM.Dictionary("ts","u",item))
	}
	Quit $$$OK
}

ClassMethod CheckAllBlanks(string) As %Boolean [ ZenMethod ]
{
	Quit $ZStrip(string,"<>W")=""
}

/// Delete a presentation context from an association 
ClassMethod DeleteDataContext(pid, pindex) As %String [ ZenMethod ]
{
	Set $ZT="Error"
	Set t = ##class(EnsLib.DICOM.Util.AssociationContext).%OpenId(pid)
	If '$IsObject(t) Quit $$$FormatText($$$Text("Unable to open id: %1"),pid)
	Set tIndex = pindex + 1
	Do t.PresentationContexts.RemoveAt(tIndex)
	Set tSC = t.%Save()
	If $$$ISERR(tSC) {
		Set ok = $System.Status.GetErrorText(tSC)
	} Else {
		Set ok = 1
	}
	Kill t
	Quit ok
Error	///
	Set $ZT=""
	Set tSC = $$$SystemError
	Quit $system.Status.GetErrorText(tSC)
}

/// Edit a presentation context from an association 
ClassMethod EditDataContext(pid, pindex) As %String [ ZenMethod ]
{
	Set $ZT="Error"
	Set t = ##class(EnsLib.DICOM.Util.AssociationContext).%OpenId(pid)
	If '$IsObject(t) Quit $$$FormatText($$$Text("Unable to open id: %1"),pid)
	Set tIndex = pindex + 1
	Set t1 = t.PresentationContexts.GetAt(tIndex)
	Set tTSCount = t1.TransferSyntaxes.Count()
	Set tAS = t1.AbstractSyntax	
	Set tEdit = $$$FormatText($$$Text("Edit %1"),$G(^EnsDICOM.Dictionary("as","u",tAS)))
	&js< zenPage.getComponentById("fld1").setProperty("legend",'#(tEdit)#');>
	#; First build the selected box:
	Set tSub = 1
	While tSub '> tTSCount {
		#; Get selected and build it into Selected box
		Set tTS = t1.TransferSyntaxes.GetAt(tSub)
		Set tTSU = $G(^EnsDICOM.Dictionary("ts","u",tTS))
		&js< zenPage.getComponentById("lstselect").appendOption('#(tTS)#','#($ZCVT(tTSU,"O","JS"))#'); >
		#; Build it into the selected array:
		Set sel(tTS) = tTSU
		Set tSub = tSub + 1
	}
	#; Second build the available box:
	Set item = ""
	Set item = $O(^EnsDICOM.Dictionary("ts","u",item))
	While item '= "" {
		If '$D(sel(item)) {
			Set itemtext = ^(item)
			&js< zenPage.getComponentById("lst").appendOption('#(item)#','#(itemtext)#'); >
		}
		Set item = $O(^EnsDICOM.Dictionary("ts","u",item))
	}
	Kill sel,item
	#; Return the current abstract syntax value
	Quit tAS
Error	///
	Set $ZT=""
	Set tSC = $$$SystemError
	Quit $system.Status.GetErrorText(tSC)
}

/// Build presentation context tree
ClassMethod GetTreeInfo(pRoot As %String, Output pTree, ByRef pParms) As %Status
{
	Set PID = %page.PID
	Set t = ##class(EnsLib.DICOM.Util.AssociationContext).%OpenId(PID)
	If '$IsObject(t) Quit $$$OK
	Set lblAS = $$$TextHTML("Abstract Syntax: ")
	Set lblTS = $$$TextHTML("Transfer Syntax: ")
	Set tCount = t.PresentationContexts.Count()
	If tCount < 1 Quit 1
	Set tTotal = tCount
	Set tItem = 1
	Set tExpanded = 0
	While tItem '> tCount {
		Set pTree(0,"ch",tItem) = ""
		
		Set t1 = t.PresentationContexts.GetAt(tItem)
		Set tAS = t1.AbstractSyntax
		Set tASU = $G(^EnsDICOM.Dictionary("as","u",tAS))
		Set tTSCount = t1.TransferSyntaxes.Count()
		Set tChildren = $S(tTSCount>0:1,1:0)
		#; $LB(text,value,haschildren,link,expanded,icon,tooltip,style)
		Set tNode = tItem-1
		Set tLink = $S(tChildren:"javascript:zenPage.expandNode('"_tNode_"')",1:"")
		Set pTree(tItem) = $LB(lblAS_tASU,lblAS_tAS,tChildren,tLink,tExpanded,,tAS)

		Set tSub = 1
		While tSub '> tTSCount {
			Set tTS = t1.TransferSyntaxes.GetAt(tSub)
			Set tTSU = $G(^EnsDICOM.Dictionary("ts","u",tTS))
			Set tTotal = tTotal + 1
			Set pTree(tTotal) = $LB(lblTS_tTSU,lblTS_tTSU,0,"",tExpanded,,tTS)
			Set pTree(tItem,"ch",tTotal) = ""
			Set tSub = tSub + 1
		}	
		Set tItem = tItem + 1	
	}
	Kill t
	Quit $$$OK
}

/// Load available context list box from JS
ClassMethod LoadAvaContext() [ ZenMethod ]
{
	Set $ZT="Error"	
	Set item = ""
	Set item = $O(^EnsDICOM.Dictionary("ts","u",item))
	While item '= "" {
		Set itemtext = ^(item)
		&js< zenPage.getComponentById("lst").appendOption('#(item)#','#(itemtext)#'); >
		Set item = $O(^EnsDICOM.Dictionary("ts","u",item))
	}
	Quit
Error	///
	Set $ZT=""
	Set tSC = $$$SystemError
	Quit
}

/// Save general association data to server
ClassMethod SaveData(pid, calling, called, name, desc, preserve) As %ZEN.proxyObject [ ZenMethod ]
{
	Set $ZT="Error"
	
	#dim tContainer as EnsLib.DICOM.Util.AssociationContext

	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 0
	Set tProxy.PID = pid
	Set isClone = 0
	If ##class(EnsLib.DICOM.Util.AssociationContext).%ExistsId(pid) {
		Set tContainer = ##class(EnsLib.DICOM.Util.AssociationContext).%OpenId(pid)
		Set tNewId = calling_"||"_called
		If pid '= tNewId {
			Set isClone = 1
			Set tContainer = tContainer.%ConstructClone(1)
		}
	} Else {
		Set tContainer = ##class(EnsLib.DICOM.Util.AssociationContext).%New()
	}
	Set tContainer.CallingAET = calling
	Set tContainer.CalledAET = called
	Set tContainer.Name = name
	Set tContainer.Description = desc
	
	Set tSC = tContainer.%Save()
	If '$$$ISOK(tSC) {
		Set tProxy.Message = $System.Status.GetErrorText(tSC)
		If $E(tProxy.Message,7,12) = "#5805:" Set tProxy.Message = $$$TextHTML("This Calling AET and Called AET combination already exists.")
	} Else {
		Set tProxy.ok = 1
		Set tProxy.Message = $$$TextHTML("Association saved.")
		Set tProxy.PID = tContainer.%Id()
		If isClone = 1, preserve = 0 {
			Do ##class(EnsLib.DICOM.Util.AssociationContext).%DeleteId(pid)
		}
	}
	Kill tContainer
	Quit tProxy
Error	///
	Set $ZT=""
	Set tSC = $$$SystemError
	Set tProxy.Message = $system.Status.GetErrorText(tSC)
	Quit tProxy
}

/// Save presentation context to server
ClassMethod SaveDataContext(pid, comboAS, selectedSyntax, editIndex) As %ZEN.proxyObject [ ZenMethod ]
{
	Set $ZT="Error"
	
	#dim tContainer as EnsLib.DICOM.Util.AssociationContext

	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 0
	Set tProxy.PID = pid
	Set tProxy.Message = ""

	Set tContainer = ##class(EnsLib.DICOM.Util.AssociationContext).%OpenId(pid)
	If '$IsObject(tContainer) {
		Set tProxy.Message = $$$FormatText($$$Text("Unable to open id: %1"),pid)
		Quit tProxy
	}
	If editIndex '< 0 {
		#; the editIndex is the tree's index which is 0 based, so we need to add 1 here:
		Set tIndex = editIndex+1
		Set tContext = tContainer.PresentationContexts.GetAt(tIndex)
		Set tTSCount = tContext.TransferSyntaxes.Count()
		#; Remove all current transfer syntaxes - do this to preserve the position of the current presentation
		For t = 1:1:tTSCount Do tContext.TransferSyntaxes.RemoveAt(1)
		#; Reset the selected transfer syntaxes below
	} Else {
		#; Add a new one:
		Set tContext = ##class(EnsLib.DICOM.Util.PresentationContext).%New()
		Set tContext.AbstractSyntax = comboAS
		Do tContainer.PresentationContexts.Insert(tContext)
	}
	#; Set selected transer syntaxes
	For x=1:1 Set tSyntax = $P(selectedSyntax,",",x) Quit:tSyntax=""  Do tContext.TransferSyntaxes.Insert(tSyntax)
	#; Save all
	Set tSC = tContainer.%Save()
	If '$$$ISOK(tSC) {
		Set tProxy.Message = $System.Status.GetErrorText(tSC)
	} Else {
		Set tProxy.ok = 1
		Set tProxy.Message = $$$TextHTML("Presentation Context saved.")
		Set tProxy.PID = tContainer.%Id()
	}
	Quit tProxy
Error	///
	Set $ZT=""
	Set tSC = $$$SystemError
	Set tProxy.Message = $system.Status.GetErrorText(tSC)
	Quit tProxy
}

/// Update contents of rule.
/// This method is called when user clicked a row to "Edit".
/// Load data into the fields.
Method UpdateDetails(pid) As %Boolean [ ZenMethod ]
{
	// try to open the object
	Set tContainer = ##class(EnsLib.DICOM.Util.AssociationContext).%OpenId(pid)
	If '$IsObject(tContainer) {
		Set ok = $$$TextHTML("Cannot open object!")
	} Else {
		Set calling = tContainer.CallingAET
		Set called = tContainer.CalledAET
		Set name = tContainer.Name
		Set desc = tContainer.Description
		Set ..%GetComponentById("txtCallingAET").value = $ZCVT(calling,"O","HTML")
		Set ..%GetComponentById("txtCalledAET").value = $ZCVT(called,"O","HTML")
		Set ..%GetComponentById("txtName").value = $ZCVT(name,"O","HTML")
		Set ..%GetComponentById("txtDescription").value = $ZCVT(desc,"O","HTML")	
		Set ok = 1
	}
	if ok'=1 &html<UpdateDetails: #(ok)#>
	Quit 1
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',[]);
	this.treeCount();
	// IE wants to draw the div 1 pixel too short, so we add them here
	if (zenIsIE) {
		var tabGroup = zen('tabs');
		tabGroup.ieResizeBody = function() { return }; // Workaround for IE
		var tabBody = tabGroup.getTabBodyElement();
		if (tabBody) {
			var tabHeight = tabBody.offsetHeight;
			tabBody.style.height = (tabHeight + 1)+'px';
		}
	}
}

ClassMethod IDExists(pid) As %Boolean [ ZenMethod ]
{
	Quit ##class(EnsLib.DICOM.Util.AssociationContext).%ExistsId(pid)
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("DICOM Setting")
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Do ..%GetRootLink(.pLink)
	
	Set tURL = "EnsPortal.DICOM.Settings.zen?home="_$G(%request.Data("home",1))
	Set pLink($I(pLink)) = $LB($$$Text("DICOM Settings","Ensemble"),tURL)
	
	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($classname(),"O","URL")_".zen?home="_$G(%request.Data("home",1)))
	Quit $$$OK
}

}

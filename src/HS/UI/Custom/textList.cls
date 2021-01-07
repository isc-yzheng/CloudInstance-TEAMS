/// Enter text with an associated list box to show selections from the database that match the entry in the text box
/// Possible values are stored in a hidden data listbox 
/// Optionally allows multiple selections in the text box.
Class HS.UI.Custom.textList Extends %ZEN.Component.composite [ DependsOn = HS.UI.Custom.listBox ]
{

/// Whether multiple entries are allowed
Property allowMultiple As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Name of the class containing the class query that will
/// be used to create a <class>%ResultSet</class> object.
Property queryClass As %ZEN.Datatype.className;

/// Name of the class query that will
/// be used to create a <class>%ResultSet</class> object.
Property queryName As %ZEN.Datatype.classMember(MEMBERTYPE = "QUERY");

/// SQL statement that, if present, will be used to 
/// create a <class>%ResultSet</class> object.<br>
/// If defined, this takes precedence over 
/// <property>queryClass</property> and <property>queryName</property>.
Property sql As %ZEN.Datatype.sql;

/// Height of the listbox that shows the possible choices
Property listHeight As %ZEN.Datatype.integer [ InitialExpression = 400 ];

/// Width of the listbox that shows the possible choices
Property listWidth As %ZEN.Datatype.integer [ InitialExpression = 310 ];

/// If true, allow this component to display vertical scroll bars
Property vtScroll As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// The list of logical values selected
Property value As %ZEN.Datatype.list;

/// List of display values selected
Property display As %ZEN.Datatype.list;

/// The type of entity we're looking up
Property entity As %ZEN.Datatype.caption [ InitialExpression = "entry" ];

/// Method to call in the parent window when an entry is selected
Property onSelect As %ZEN.Datatype.eventHandler;

/// Internal indicator to let the onblur method knows not to hide the listbox when focus is in it
Property inListBox As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Optional sting to mark the end of the portion of the selection to display
Property endString As %ZEN.Datatype.string;

Property msgMultipleNotAllowed As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Multiple entries are not allowed here.")} ];

Property msgInvalidEntry As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("is invalid.  Please delete and re-select.")} ];

/// The XML namespace for this component.
Parameter NAMESPACE = "http://www.intersystems.com/zen/hs";

Parameter DOMAIN = "HS";

/// If true, then the include files generated for this component, are placed in the
/// common /csp/broker directory and not the local /csp/*namespace* directory.<br/>
/// This is intended for use with packages that are mapped so as to be visible to every namespace.<br/>
/// All Zen classes within the same package must have the same value for this parameter.
/// It is the developer's responsibility to ensure this.
Parameter USECOMMONDIRECTORY As BOOLEAN = 1;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

/* @doc="Item within listBox. Set the font size for this form." */
.listBox {
	border: 1px #77A8D0 solid;
}
.listBoxItem {
	font-size: 12px;
	font-family: verdana;
}
/* @doc="Selected item within listBox." */
.listBoxItemSelected {
	font-size: 12px;
	font-family: verdana;
	font-weight: normal;
}
/* @doc="Selected item with focus within listBox." */
.listBoxItemFocus {
	font-size: 12px;
	font-family: verdana;
	font-weight: normal;
}

</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite cellStyle="padding-bottom:0px" xmlns="http://www.intersystems.com/zen" xmlns:hs="http://www.intersystems.com/zen/hs">
<dataListBox id="lstAll" hidden="true"/>
<!-- Note: onblur is set in %DrawHTML for the text and listBox controls -->
<text id="txt" onkeyup="zenThis.composite.textKeyHandler(zenThis);"/>
<hs:listBox id="lst"
name="lst" 
hidden="true" 
hzScroll="false"
valign="top"
enclosingStyle="position:absolute;"
onclick="zenThis.composite.select();"
ondblclick="zenThis.composite.select();"
onkeydown="zenThis.composite.listKeyHandler(evt);"
onfocus="zenThis.composite.listGotFocus();"
 />
</composite>
}

Method %DrawHTML()
{
	/// Make textbox as wide as the composite
	Set tTxt=..%GetChildById("txt")
	Set tTxt.size=..width
	Set tTxt.onblur="zenPage.getComponentById('"_..id_"').hideList(1);"
	
	/// Size the list of possibilities, and set the scrollbar
	Set tLst=..%GetChildById("lst")
	Set tLst.listHeight=..listHeight
	Set tLst.listWidth=..listWidth
	Set tLst.vtScroll = ..vtScroll
	
	// Hide listbox when focus leaves it
	Set tLst.onblur="zenPage.getComponentById('"_..id_"').setInListBox(false);"
	Set tLst.onblur=tLst.onblur_";zenPage.getComponentById('"_..id_"').hideList(1);"
	
	/// Set up hidden dataListBox to get all values from the database
	Set tListAll=..%GetChildById("lstAll")
	Set tListAll.sql=..sql
	Set tListAll.queryClass=..queryClass
	Set tListAll.queryName=..queryName
		
	do ##super()
}

/// Process a key entered in the text box 
ClientMethod textKeyHandler(textCtrl) [ Language = javascript ]
{
	var BACKSP=8;
	
	// Handle control characters
	if ((zenEvent.keyCode >= 16)&&(zenEvent.keyCode <= 20)) return;
	switch (zenEvent.keyCode) {
		case zenENTER: zenThis.composite.select();return;
		case zenDOWN: zenThis.composite.focusList();return;
		case zenESC: this.getChildById('lst').setHidden(1);return;
		case zenLEFT: return;
		case zenRIGHT: return;
		case zenUP: return;
	}
	
	// Get the last entry
	var textCtrl=this.getChildById("txt");
	var textArr=textCtrl.getValue().split(";")
	var last=textArr.length-1;
	var text=zenThis.composite.format(textArr[last]);
	
	// Check for only one allowed
	if ((last>0)&&(!this.allowMultiple)) {
		alert(this.msgMultipleNotAllowed);
		textCtrl.setValue(textArr[last-1]);
		this.display[last]='';
		return;
	}
	
	// They may have changed prior selections, need to refresh
	zenThis.composite.refreshSelection();
	
	// Update the prior entry, catching the case where they delete the prior entry and enter a new character in one stroke
	var prior=text.length==1?"":this.display[last]
	this.display[last]=text;

	// Handle additions or deletions to the last entry
	var charCode = zenEvent.charCode ? zenEvent.charCode : zenEvent.keyCode;
	if ((charCode > 32)||(zenEvent.keyCode==zenDELETE)||(zenEvent.keyCode==BACKSP)) { 
		zenThis.composite.match(text,prior,1);
	}
}

/// Match entered text against the list of possiblities
ClientMethod match(text, prior, show) [ Language = javascript ]
{
	var lst=this.getChildById("lst");
	lst.resetOptions();

	// Copy matching options from the full list.
	// Match only on last ";" piece.
	if (text == "") {
		if (show) lst.setHidden(1);
	} else if (text != prior||show) {
		var lstAll=this.getChildById("lstAll");
		var optionCount=lstAll.getOptionCount();
		
		for (i=0; i<optionCount; i++) {
			var optionText=lstAll.getOptionText(i);
			if (text == optionText.substring(0,text.length).toUpperCase()) {
				lst.appendOption(lstAll.getOptionValue(i),optionText);	
			}
		}
		var lstCnt=lst.getOptionCount()
		if ( lstCnt > 0) {
			var height=lst.getOptionCount()*16+2;
			if (height > this.listHeight) height=this.listHeight;
			lst.setProperty('listHeight', height);
			lst.selectItem(0);
		}
		if (show) { lst.setHidden(lstCnt==0); }
	}
}

/// Refresh prior entries in case they changed
ClientMethod refreshSelection() [ Language = javascript ]
{
	var textCtrl=this.getChildById("txt");
	var textArr=textCtrl.getValue().split(";");
	var textCount=textArr.length;
	var priorCount=this.value.length;
	var newValue = new Array();
	var newDisplay = new Array();
	var k=-1; var next=0;

	for (idx=0; idx<textCount; idx++) {
		// Find prior selection 
		var text=zenThis.composite.format(textArr[idx])
		var valFound=""
		var dispFound=""
		for (j=next; j<priorCount; j++) {
			var display=this.display[j]	
			if ((text==display)&&(text != '')) {
			  	valFound=this.value[j];
			  	dispFound=text;
			  	next=j+1;
			  	break;
			}
		}
		
		// Try matching again if the display has no corresponding value
		if (valFound == '') {
			zenThis.composite.match(text,'',0);
			var lst=this.getChildById("lst");
			if (lst.getOptionCount() == 1) {
				var optionText=zenThis.composite.format(lst.getOptionText(0));
				if (optionText == text) {
					valFound=lst.getOptionValue(0);
					dispFound=text;
				}
			}
		}
		
		// Record this selection
		newValue[++k]=valFound;
		newDisplay[k]=dispFound;
		
		// Let parent window know that a prior selection changed
		if ((this.value.length > 0)||(valFound != '')) {
			if (valFound != this.value[k]) {
				zenThis.composite.tlSelect(k+1, valFound); 
			}
		}		
	}
	
	// Preserve list of selections	
	this.value=newValue;
	this.display=newDisplay;
}

/// Select an entry from the list
ClientMethod select() [ Language = javascript ]
{
	var lst=this.getChildById("lst");
	var idx=lst.selectedIndex;
	if (idx > -1) {
		// Add the complete entry and re-set the listbox
		zenThis.composite.addValue(lst.getOptionValue(idx),zenThis.composite.truncate(lst.getOptionText(idx)),0);
		lst.setHidden(1);
		lst.selectedIndex=-1
		
		// Let parent window know that the current selection changed;
		zenThis.composite.tlSelect(this.value.length,this.value[this.value.length-1]);
	}
}

/// Process keys entered in the list box
ClientMethod listKeyHandler(evt) [ Language = javascript ]
{
	if (evt.keyCode == zenESC) {
		this.getChildById('lst').setHidden(1);	
	}
	
	// Select the current entry when the user presses Enter while in the match list
	if ((evt.keyCode == zenENTER)||(evt.keyCode == zenTAB)) {
		zenThis.composite.select();	 
	}
}

/// Add to or replace the current selection
ClientMethod addValue(logical, display, delay) [ Language = javascript ]
{
	// Remove the last (partial) entry
	var txtCtrl=this.getChildById("txt");
	var textArr=txtCtrl.getValue().split(";");
	var last=textArr.length-1;
	var space=last>0?' ':'';
	var text=txtCtrl.getValue();
	var lastChar=text.lastIndexOf(";")+1;
	txtCtrl.setValue(text.substring(0,lastChar)+space);
	this.display[last]='';
	
	if (this.allowMultiple) {
		var oldDisp=txtCtrl.getValue();
		var displayText=oldDisp+display+"; ";
		var last=this.value.length; 
		if ((last > 0)&&(this.display[last-1] == '')) last=last-1;
	} else {
		var displayText=display;
		var last=0;
	}
	
	// Record internal and external values
	this.value[last]=logical;
	this.display[last]=zenPage.getComponentById(this.getProperty("id")).format(display);
	
	if (delay == undefined) {
		zenPage.getComponentById(this.getProperty("id")).displayText(displayText);
	} else {
		// Need the delay to ensure that focus doesn't get clawed back
		setTimeout("zenPage.getComponentById('"+this.getProperty("id")+"').displayText('"+displayText+"')",delay);
	}
}

/// Show revised text
ClientMethod displayText(display) [ Language = javascript ]
{
	// Need to set focus before setting text to go to the end of the text
	var txtCtrl=this.getChildById('txt');
	txtCtrl.focus();
	txtCtrl.setValue(display);
}

/// Force hide of the list of possibilities 
ClientMethod hideList(defer) [ Language = javascript ]
{
	if (defer) {
		// to give focus time to reach the listbox (setTimeout doesn't work in onblur, reason unknown)
		setTimeout("zenPage.getComponentById('"+this.getProperty("id")+"').hideList(0)",200);
	} else if (this.getInListBox()) {
		zenThis.composite.setInListBox(false);
	} else {
		this.getChildById('lst').setHidden(1);
	}
}

/// Put focus in the list if it's visible
ClientMethod focusList() [ Language = javascript ]
{
	var lst=this.getChildById('lst');
	if (!lst.getHidden()) { 
		zenThis.composite.setInListBox(true);
		lst.focus(); 
	}
}

/// Select the first entry if not already in the list (i.e. used tab, not down-arrow to get in)
ClientMethod listGotFocus() [ Language = javascript ]
{
	if (!this.getInListBox()) {
		zenThis.composite.select();
	}
}

/// Validate that selected entries have not been manually editted.
ClientMethod validate() [ Language = javascript ]
{
	var textArr=this.getChildById("txt").getValue().split(";")
	var selectCount=this.value.length;
	var msg='';
	for (i=0; i<selectCount; i++) {
		if (this.value[i] == '') {
			var display=zenPage.getComponentById(this.getProperty("id")).format(textArr[i]);
			if (display != '') {
				msg=msg+this.entity+' '+zenPage.getComponentById(this.getProperty("id")).trim(textArr[i])+' '+this.msgInvalidEntry+"\n";
			}
		}
	}
	
	return msg
}

/// Return the list of internal values selected
ClientMethod getValue() [ Language = javascript ]
{
	return this.value;
}

/// Set the value of the control (used when multiples are not allowed)
Method %SetValue(pLogical As %String, pDisplay As %String = "")
{
	Set ..value=pLogical
	Set:pDisplay="" pDisplay=..%GetDisplayValue(pLogical)
	Set ..%GetChildById("txt").value=pDisplay
}

/// Get the display value from the internal value stored in the hidden data listbox
Method %GetDisplayValue(pValue As %String) As %String
{
	Quit ..%GetChildById("lstAll").%GetDisplayValue(pValue)
}

/// Returns the display value given the internal value (without going to the server)
ClientMethod getDisplayValue(value) [ Language = javascript ]
{
	var lstAll=this.getChildById('lstAll');
	var optionCount=lstAll.getOptionCount();
		
	for (i=0; i<optionCount; i++) {
		if (value == lstAll.getOptionValue(i)) {
			return lstAll.getOptionText(i);	
		}
	}
	
	return ''
}

/// Refresh the list of all entries
ClientMethod refreshList(sync) [ Language = javascript ]
{
	this.getChildById('lstAll').refreshContents(sync);
}

/// Format the display by stripping leading/trailing spaces and converting to uppercase
ClientMethod format(text) [ Language = javascript ]
{
	return zenPage.getComponentById(this.getProperty("id")).trim(text).toUpperCase();
}

/// Format the display by stripping leading/trailing spaces
ClientMethod trim(text) [ Language = javascript ]
{
	var len=text.length;
    while (text.substring(0,1) == ' ') { text = text.substring(1, len) };
    while (text.substring(len-1,len) == ' ') { text = text.substring(0, len-1) };
	return text
}

/// Optionally truncate the value selected from the dropdown for display in the textbox
ClientMethod truncate(text) [ Language = javascript ]
{
	var display=text;
	if (this.endString != '') { 
		var end=text.indexOf(this.endString);
		if (end > 0) {
			display=text.substring(0,end)
		}
	}
	return display;
}

/// Set focus to the text control
ClientMethod focus() [ Language = javascript ]
{
	this.getChildById('txt').focus();
}

/// Set a flag indicating whether focus is in the list box
ClientMethod setInListBox(flag) [ Language = javascript ]
{
	this.inListBox=flag;
}

/// Return the flag indicating whether focus is in the list box
ClientMethod getInListBox(flag) [ Language = javascript ]
{
	return this.inListBox;
}

/// Invoke other actions in the parent window
ClientMethod tlSelect(current, value) [ Language = javascript ]
{
	if (this.onSelect != '') {
		zenInvokeCallbackMethod(zenThis.composite.onSelect,zenThis.composite,'onSelect','current',current,'value',value);
	}
}

}

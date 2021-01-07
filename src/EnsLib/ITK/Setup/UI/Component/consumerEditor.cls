/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.Component.consumerEditor Extends %ZEN.Component.composite [ System = 4 ]
{

Property obj As EnsLib.ITK.Setup.UI.Consumer;

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite xmlns="http://www.intersystems.com/zen">
<hgroup>
<hidden name="ConsumerName" id="hdnConsumerName"/>
<text name="DisplayText" id="txtDisplayText" readOnly="true"/>
<image src="deepsee/zoom_24.png" id="btnRule" title="Open the Edit Consumer dialog" onclick="this.showConsumerDetails();"/>
<hidden name="PopupName" id="hdnPopupName"/>
</hgroup>
</composite>
}

/// Launch the profile info dialog.
ClientMethod showConsumerDetails() [ Language = javascript ]
{
	// get the class name or alias from the list
	var name = this.getChildById('hdnConsumerName').getValue();
	var popup = this.getChildById('hdnPopupName').getValue();
	var parms = {
		CONSUMERNAME:name
	};
	zenPage.launchPopupWindow(zenLink('EnsLib.ITK.Setup.UI.' + popup + '.zen'),zenPage.addPopupSuffix('EditConsumerRegistry'),'status,scrollbars,resizable=yes,width=1000,height=600',parms);
}

/// Set the value of a named property.<br>
/// Assume that subclasses that simply wrap HTML controls
/// have named the control 'control' or else have overridden
/// this method.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	//alert('p: ' + property + ', v: ' + value + ', v2: ' + value2);
	switch(property) {
	case 'value':
		// Format is "ConsumerName|DisplayText|PopupName"
		var items = value.split("|")
		var hdn = this.getChildById('hdnConsumerName')
		if (hdn) {
			hdn.setValue(items[0]);
		}
		var sel = this.getChildById('txtDisplayText')
		if (sel) {
			sel.setValue(items[1]);
		}
		var popup = this.getChildById('hdnPopupName')
		if (popup && items.length > 2) {
			popup.setValue(items[2]);	
		}
		// no break;
	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

/// Return the value of a named property (i.e. a setting).<br>
/// Returns null if this is not a property of this object.<br>
/// <var>key</var> is an optional argument used for properties
/// (such as collections) that may need a key to find a specific value.
ClientMethod getProperty(property, key) As %String [ Language = javascript ]
{
	switch(property) {
	case 'value':
		var hdn = this.getChildById('hdnConsumerName');
		var sel = this.getChildById('txtDisplayText');
		var pop = this.getChildById('hdPopupName');
		if (hdn && sel && pop) return hdn.getValue() + "|" + sel.getValue() + "|" + pop.getValue();
		// no break;
	default:
		// dispatch
		return this.invokeSuper('getProperty',arguments);
	}
}

/// Client-side method to set the value associated with this control.
/// <var>value2</var> is an optional, second parameter used by some controls
/// (such as <class>dataCombo</class>).
ClientMethod setValue(value, value2) [ Final, Language = javascript ]
{
	this.setProperty('value',value,value2);
}

ClientMethod getValue() [ Final, Language = javascript ]
{
	return this.getProperty('value');
}

/// The server has just installed us as a fresh code-generated component. Recover the old value and replace ourselves in the page list.
ClientMethod onRefreshContents() [ Final, Language = javascript ]
{
	var old = zenPage.composites[this.id];
	this.setValue(old.getValue());
	zenPage.composites[this.id] = this;
}

/// This client event, if present, is fired when a popup page has specified
/// this component as its parent and fires an action.<br>
/// <var>popupName</var> is the name of the popup window sending the action.<br>
/// <var>action</var> is the name of the action.<br>
/// <var>value</var> is the value associated with the action.<br>
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
}

/// Create children on client side so we can use them immediately. Note that the server may substitute fresh code-generated objects later.
ClientMethod createChildren(form) [ Language = javascript ]
{
	var hgroup = zenPage.createComponent('hgroup');
	
	var hdn = zenPage.createComponent('hidden');
	hdn.name='ConsumerName';
	
	hdn.setProperty('id', this.id+'.hdn'+hdn.name);
	
	hgroup.addChild(hdn);
	
	var txt = zenPage.createComponent('text');
	txt.name="DisplayText";
	//alert(this.id+".txt"+txt.name);
	txt.setProperty('id',this.id+".txt"+txt.name);
	txt.size=30;
	//sel.setProperty('context',"Ens.ContextSearch/BusinessPartners");
	txt.onchange = "zenPage.settingChanged('"+escape(this.index)+"','"+escape(form.index)+"');"
	txt.onkeyup = "zenPage.settingChanged('"+escape(this.index)+"','"+escape(form.index)+"');"
	hgroup.addChild(txt);
	
	var btn = zenPage.createComponent('image');
	btn.src="deepsee/zoom_24.png";
	btn.setProperty('id',this.id+"."+"btn"+txt.name);
	btn.title="Edit services accepted by this consumer.";
	btn.onclick="zenPage.getComponentById('"+this.id+"').showConsumerDetails();"
	hgroup.addChild(btn);

	var pop = zenPage.createComponent('hidden');
	pop.name='PopupName';
	pop.setProperty('id', this.id+'.hdn'+pop.name);
	hgroup.addChild(pop);
	
	this.addChild(hgroup);

	this.childrenCreated = true;

	return '';
}

}

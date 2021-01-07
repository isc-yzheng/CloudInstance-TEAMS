/// Works around the ZEN listbox not generating events
/// Add other events as needed, or deprecate when Prodlog 72543 is addressed
Class HS.UI.Custom.listBox Extends %ZEN.Component.listBox
{

/// The XML namespace for this component.
Parameter NAMESPACE = "http://www.intersystems.com/zen/hs";

/// If true, then the include files generated for this component, are placed in the
/// common /csp/broker directory and not the local /csp/*namespace* directory.<br/>
/// This is intended for use with packages that are mapped so as to be visible to every namespace.<br/>
/// All Zen classes within the same package must have the same value for this parameter.
/// It is the developer's responsibility to ensure this.
Parameter USECOMMONDIRECTORY As BOOLEAN = 1;

/// If true, allow this component to display vertical scroll bars
Property vtScroll As %ZEN.Datatype.boolean [ InitialExpression = 1 ];

/// Draw HTML for this listBox.
/// Note that the actual value is placed in a hidden control.
/// CUSTOM -- Can suppress the vertical scroll bar
Method %DrawHTML()
{
	Set lbStyle = ""
	Set:'..hzScroll lbStyle = "overflow-x: hidden;"
	Set:'..vtScroll lbStyle = lbStyle_"overflow-y: hidden;"
	Set:..listWidth'="" lbStyle = lbStyle_"width: " _ ..listWidth _ ";"
	Set:..listHeight'="" lbStyle = lbStyle_"height: " _ ..listHeight _ ";"
	Set:lbStyle'="" lbStyle = "style="""_lbStyle_""""

	#; find displayValue
	Set tDisplay = ..%GetDisplayValue(..value)

	#; hidden field to hold value
	&html<<input type="hidden" id="#(..%MakeId("hidden"))#" #(..%Name())# #(..%Attr("tabindex",..tabIndex))# #(..%Attr("value",..value))#/>>

	#; invisible field to catch key events
	&html<<div style="position:relative; display:block; height:0px; width:0px; overflow:hidden; fontSize:0px; lineHeight:0px" >>
	&html<<input type="text" id="#(..%MakeId("invisible"))#" style="top:0px;left:0px;position:absolute;border: 0px solid green;width:0;height:0;" onkeydown="zenPage.getComponent(#(..index)#).lbKeyDownHandler(event);" onkeypress="zenPage.getComponent(#(..index)#).lbKeyPressHandler(event);" onfocus="if(zenPage){zenPage.getComponent(#(..index)#).lbKeyFocus();}" onblur="zenPage.getComponent(#(..index)#).lbKeyBlur();"/>>
	&html<</div>>
	
	#; draw listBox
	Set tCls = $S(+..disabled:"listBoxDisabled",1:..controlClass)
	&html<<div class="#(tCls)#" #(lbStyle)# #(..%Attr("title",..title))# id="#(..%MakeId("list"))#">>

	#; call server-side method to fill in contents of listBox
	#; (this may or may not be implemented)
	Do ..%DrawListContents()

	&html<</div>>
}

/// User has clicked an item in the list box.
/// CUSTOM -- invoke callback
ClientMethod clickItem(idx) [ Language = javascript ]
{
	if ((this.disabled)||(this.readOnly)) return;

	var args = new Array();
	args[0] = idx;
	this.invokeSuper('clickItem', args);
	
	if (this.onclick != '') {
		zenInvokeCallbackMethod(this.onclick,this,'onclick');
	}
}

/// Process keypress event within the invisible edit control.
/// CUSTOM -- invoke callback
ClientMethod lbKeyPressHandler(evt) [ Language = javascript ]
{
	if ((this.disabled)||(this.readOnly)) return false;

	var args = new Array();
	args[0] = evt;
	this.invokeSuper('lbKeyPressHandler', args);
	
	var ret=true;
	if (this.onkeypress != '') {
		evt = evt ? evt : window.event;
		ret = zenInvokeCallbackMethod(this.onkeypress,this,'onkeypress','evt',evt);
	}
	
	return ret
}

/// Process keydown event within the invisible edit control.
/// CUSTOM -- invoke callback
ClientMethod lbKeyDownHandler(evt) [ Language = javascript ]
{
	if ((this.disabled)||(this.readOnly)) return false;

	var args = new Array();
	args[0] = evt;
	this.invokeSuper('lbKeyDownHandler', args);
	
	var ret=true;
	if (this.onkeydown != '') {
		evt = evt ? evt : window.event;
		ret = zenInvokeCallbackMethod(this.onkeydown,this,'onkeydown','evt',evt);
	}
	
	return ret
}

/// Focus passed to the invisible edit control.
/// CUSTOM -- invoke callback
ClientMethod lbKeyFocus() [ Language = javascript ]
{
	var args = new Array();
	this.invokeSuper('lbKeyFocus', args);
	
	if (this.onfocus != '') {
		zenInvokeCallbackMethod(this.onfocus,this,'onfocus');
	}
}

/// Focus taken from the invisible edit control.
/// CUSTOM -- invoke callback
ClientMethod lbKeyBlur() [ Language = javascript ]
{
	var args = new Array();
	this.invokeSuper('lbKeyBlur', args);

	if (this.onblur != '') {
		zenInvokeCallbackMethod(this.onblur,this,'onblur');
	}
}

}

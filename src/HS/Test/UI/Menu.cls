Class HS.Test.UI.Menu Extends %ZEN.Component.menuItem
{

/// XML namespace for this component.
Parameter NAMESPACE = "http://www.intersystems.com/ihetest";

/// Domain used for localization.
Parameter DOMAIN = "IHETest";

/// Store state of menuItem (currently selected or not)
Property Selected As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

XData Style
{
<style type="text/css">
/* active menu item: this is used for top-level items
	when their submenu is displayed.
*/
a.menuItemSelected {
	display: block;
	color: darkblue;
	padding: 2px 3px 2px 3px;
	text-decoration: none;
	white-space: nowrap;
	vertical-align: middle;
	border: none;
	margin: 1px 1px 1px 1px;
}

/* @doc="Mouse over menu item." */
a.menuItemSelected:hover {
	background: #FFFFA0;
	border: 1px darkblue dotted;
	margin: 0px 0px 0px 0px;
}

a.menuItemSelected:link, a.menuItemSelected:visited, a.menuItemSelected:active {
}

</style>
}

/// Draw contents of menu cell
Method %DrawMenuCell(pShowArrow As %Boolean = 0)
{
	Set tAllowed = 1

	If (..linkResource '= "") {
  		#; Only show link if allowed to go there
		Set tAllowed = $system.Security.Check(..linkResource,"USE")
	}
	Set clickCB = ""
	Set href = ""
 	If (tAllowed) {
		If (..onclick'="") {
			Set href = ""
			Set ..secureLink = "#"
			Set clickCB = "if(zenRunMethod)zenRunMethod("_..index_",'onActionHandler');zenFireEvent("_..index_",'"_$ZCVT(..onclick,"O","JS")_"','menuClick');"
		}
		Else {
			Set tLink = $$$ZENVAL(..link)
			Set href = $Case(tLink,"":"",:"href="""_%page.%Link(tLink)_"""")
			Set ..secureLink = $Case(tLink,"":"",:""_%page.%Link(tLink)_"")
			Set clickCB = "if(zenRunMethod){zenRunMethod("_..index_",'onActionHandler');}"
		}
	}

	Set ..secureCallback = clickCB
	
	if (tAllowed && '..disabled) {
		Set cls = "menuItem"
		
		if (..Selected)
		{
			Set cls="menuItemSelected"	
		}
	}
	Else {
		Set cls = "menuItemDisabled"
		Set href = "disabled"
		Set clickCB = ""
	}

	Set img = ..image
	Set:img="" img = "images/spacer.gif"

	If (pShowArrow) {
		Set arrow = "<span align=""right"">&#187;</span>"
	}
	Else {
		Set arrow = "&nbsp;"
	}

	&html<<a id="#(..%MakeId("a"))#" #(..%Attr("title",..title))# #(..%Attr("target",..target))# onclick="#(clickCB)#" onmouseover="if(zenRunMethod){zenRunMethod(#(..index)#,'onShowHelpHandler',true);}" onmouseout="if(zenRunMethod){zenRunMethod(#(..index)#,'onShowHelpHandler',false);}" class="#(cls)#" #(href)#><img alt=" " width="#(..imageWidth)#" height="#(..imageHeight)#" src="#(img)#" border="0" />&nbsp;#($ZCVT(..caption,"O","HTML"))#&nbsp;#(arrow)#</a>>
}

}

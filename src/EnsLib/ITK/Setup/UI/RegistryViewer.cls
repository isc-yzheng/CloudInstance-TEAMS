/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsUI)

/// Created using the page template: Default
Class EnsLib.ITK.Setup.UI.RegistryViewer Extends EnsPortal.ProductionConfig [ System = 4 ]
{

/// User needs READ permissions on the %Ens_ProductionConfig resource to view this page.
/// Viewing this page also requires READ permissions on the %Ens_ITK resource, but this check is
/// performed in the <method>%OnAfterCreatePage</method>() callback.
Parameter RESOURCE = "%Ens_ProductionConfig:READ";

/// User needs WRITE permissions on the %Ens_ProductionConfig resource to make changes 
/// to the Production configuration.
/// Making ITK-specific changes on this page requires WRITE permissions on the %Ens_ITK resource,
/// but those checks are performed separately.
Parameter EDITRESOURCE = "%Ens_ProductionConfig:WRITE";

/// Class name of application this page belongs to.
Parameter APPLICATION = "EnsPortal.Application";

/// Displayed name of this page.
Parameter PAGENAME = "RegistryViewer";

/// Domain used for localization.
Parameter DOMAIN = "ITK";

/// If this page has multiple views, this is its initial display mode.
Parameter DEFAULTVIEWMODE = "sender";

Parameter INDEXMULTIPLE = 100000;

Property IndexSettings As %ArrayOfDataTypes [ InitialExpression = {..SetIndexCategories()} ];

/*
/// Index number of current selected item.
Property currItem As %String [ InitialExpression = "-1" ];
*/
/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

XData SVGStyle
{
<style type="text/css">

	.numServicesR {
		fill: #FFFFCC;
		fill-opacity: 1.0;
		stroke: #808080;
		stroke-width: 0.25;
	}
	
	.numServicesRHover {
		fill: #FFAA77;
		fill-opacity: 1.0;
		stroke: #A0A0A0;
		stroke-width: 0.25;
	}

	.numServicesRSelect {
		fill: #FFEEAA;
		fill-opacity: 1.0;
		stroke: #808080;
		stroke-width: 2.5;
		stroke-opacity: 0.5;
	}

	.numServicesRSelectHover {
		fill: #FFAA77;
		fill-opacity: 1.0;
		stroke: #808080;
		stroke-width: 2.5;
		stroke-opacity: 1.0;
	}

	
	.numServicesT {
		font-size: 8pt;
		fill: black;
		stroke: none;
		font-family: arial;
		text-anchor: middle;
		pointer-events: none;
	}
	

	
</style>
}

XData SVGDef
{
<defs>
		<marker id="arrowHead" viewBox="0 0 10 10" refX="18" refY="5" 
		    markerUnits="userSpaceOnUse" orient="auto"
		    markerWidth="10" markerHeight="10">
		    <polyline points="0,0 10,5 0,10 1,5" />
		</marker>	
	</defs>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>	

	<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
	
	<timer id="statusTimer" timeout="0" ontimeout="zenPage.refreshStatusHandler();"/>
	
	<!-- Provide Production information in JSON format -->
	<jsonProvider id="productionInfo"
		 OnGetArray="GetProductionArray"
	/>

	<!-- Provide settings information in JSON format -->
	<jsonProvider id="settingsInfo"
		 OnGetArray="GetSettingsArray"
	>
	<parameter id="siHostName" paramName="hostName"/>
	<parameter paramName="productionName" value="#(%page.productionId)#"/>
	</jsonProvider>
	
	<!-- Provide settings information by id in JSON format -->
	<jsonProvider id="settingsInfoById"
		 OnGetArray="GetSettingsArrayById"
	>
	<parameter id="siItemId" paramName="itemId"/>
	<parameter id="siItemClass" paramName="itemClass"/>
	<parameter id="siHostId" paramName="hostId"/>
	<parameter paramName="productionName" value="#(%page.productionId)#"/>
	</jsonProvider>
	
	<!-- Provide Production information in JSON format -->
	<jsonProvider id="senderList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.SenderRegistry"/>
	 	<parameter paramName="type" value="sender"/>
	 </jsonProvider>
	 
	 <jsonProvider id="senderSystemList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.SystemDefinition"/>
	 	<parameter paramName="type" value="senderSystem"/>
	 	<parameter paramName="query" value="GetSenderSystems"/>
	 </jsonProvider>
	 
	 <jsonProvider id="systemList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.SystemDefinition"/>
	 	<parameter paramName="type" value="system"/>
	 </jsonProvider>
	 
	 <jsonProvider id="serviceList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.ServiceDefinition"/>
	 	<parameter paramName="type" value="service"/>
	 </jsonProvider>
	 
	 <jsonProvider id="subscriptionList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.SubscriptionRules"/>
	 	<parameter paramName="type" value="subscription"/>
	 </jsonProvider>
	 
	 <jsonProvider id="distributionList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.DistributionRules"/>
	 	<parameter paramName="type" value="distribution"/>
	 </jsonProvider>
	 
	 <jsonProvider id="consumerList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.ConsumerServiceRegistry"/>
	 	<parameter paramName="type" value="consumer"/>
	 </jsonProvider>
	 
	 <jsonProvider id="consumerSystemList"
	 	OnGetArray="GetPropertyArray">
	 	<parameter paramName="class" value="EnsLib.ITK.Setup.UI.Consumer"/>
	 	<parameter paramName="type" value="consumerSystem"/>
	 	<parameter paramName="query" value="GetAll"/>
	 </jsonProvider>
	 
	 <jsonProvider id="busservList"
	 	OnGetArray="GetListenerArray">
	 </jsonProvider>
	 		 	
	
	<hgroup id="mainGroup" cellVAlign="top">
		<vgroup id="diagramPane">
		<html id="diagramHeader" OnDrawContent="DrawDiagramHeader"/>
		<svgFrame id="svg" width="0" height="400">
		<ownerDraw id="svgDiagram"
		height="500" width="800" 
		 onrender="zenPage.drawDiagram(zenThis,'');"/>
		</svgFrame>
		</vgroup>
		<vgroup id="propertyPane">
		<html id="propertyTitle">
		<div id="componentName"><br/></div>
		</html>
		<tabGroup id="propertyTabs" showTabBar="true">
		<tab id="tabSettings" caption="Settings" labelPosition="left">
		<vgroup>
		<spacer height="5" />
		<hgroup id="grpSettingsScroll" aux="%" cellVAlign="middle" labelPosition="left" cellStyle="padding:0px;" hidden="true">
		<spacer width="5" />
		<button id="btnApply" caption="Apply" controlClass="commandButton" onclick="zenPage.applyChanges();" />
		<spacer width="8" />
		<image id="btnExpandAll" src="images/arrow1D.gif" title="Expand all" onclick="zenPage.expandAll(zenPage.settingsExpanded);" hidden="false"/>
		<spacer width="8" />
		<image id="btnItemDefaults" src="images/goto.png" title="Select settings defaults" onclick="zenPage.selectSettingsDefaults();" hidden="false"/>
		<spacer width="10" />
		<text size="20" id="ctrlSearch" label="Search:" labelClass="zenLabel settingLabel" title="Show all settings whose name, type, category, or value contains the search value" enclosingStyle="padding-left:0px; padding-bottom: 3px;" onchange = "zenPage.searchChanged();" onkeyup = "zenPage.searchChanged();" />
		<image id="btnClearSearch" src="images/MacCloseB.png" title="Clear Search Text" onclick="zenPage.clearSearch();" />
		</hgroup>
		<html id="settingsLoading" hidden="true">
		<span class="msgLoading"> #(%page.msgLoading)# </span>
		</html>
		<form id="settingsForm" labelPosition="top" onrefresh="zenPage.renderHelpText();" enclosingStyle="overflow:auto; height:500px;">
		</form>
		</vgroup>
		</tab>
		<tab id="tabActions" caption="Actions">
		<vgroup width="80%">
		<spacer height="15" />
		<hgroup id="grpTest" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="portal/our_process_a_48.gif"/>
		<vgroup>
		<button id="btnTest" caption="Test" controlClass="commandButton" title="Send a test message to this item" onclick="zenPage.testItem();"/>
		<label controlClass="zenLabel" label="Test this item"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		<hgroup id="grpDelete" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="deepsee/cancel_48.png"/>
		<vgroup>
		<button id="btnDelete" caption="Delete" controlClass="commandButton" title="Delete this item from the Production configuration" onclick="zenPage.deleteItem();"/>
		<label controlClass="zenLabel" label="Delete this item from the Production"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		<hgroup id="grpCopy" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="portal/mini_sites_48.gif"/>
		<vgroup>
		<button id="btnCopy" caption="Copy" controlClass="commandButton" title="Add a duplicate copy of this item to the Production under a new name" onclick="zenPage.copyItem();"/>
		<label controlClass="zenLabel" label="Create a duplicate copy of this item"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		<hgroup id="grpChangeClass" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="portal/table_properties_48.gif"/>
		<vgroup>
		<button id="btnChangeClass" caption="Change Class" controlClass="commandButton" title="Select another class to associate with this item" onclick="zenPage.changeClass();"/>
		<label controlClass="zenLabel" label="Change the class name for this item"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		<hgroup id="grpDocument" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="portal/report_48.gif"/>
		<vgroup>
		<button id="btnDocument" caption="Document" controlClass="commandButton" title="Generate or view documentation for this Production" onclick="zenPage.documentProduction();"/>
		<label controlClass="zenLabel" label="Production documentation"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		<hgroup id="grpExport" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="portal/software_development_48.gif"/>
		<vgroup>
		<button id="btnExport" caption="Export" controlClass="commandButton" title="Construct and export a package for deployment into another Production from this item and the components directly connected to it" onclick="zenPage.exportItem();"/>
		<label controlClass="zenLabel" label="Export for deployment"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		<hgroup id="grpNew" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="portal/write_48.gif"/>
		<vgroup>
		<button id="btnNew" caption="New" controlClass="commandButton" title="Leave this Production and build a new Production" onclick="zenPage.newProduction();"/>
		<label controlClass="zenLabel" label="Build a new Production"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		<hgroup id="grpOpen" cellStyle="padding: 10px;" cellVAlign="top">
		<image src="portal/folder_48.gif"/>
		<vgroup>
		<button id="btnOpen" caption="Open" controlClass="commandButton" title="Leave this Production and open a different Production" onclick="zenPage.loadProduction();"/>
		<label controlClass="zenLabel" label="Open a different Production"/>
		<spacer height="10" />
		</vgroup>
		</hgroup>
		</vgroup>
		</tab>
		</tabGroup>
		</vgroup>
		</hgroup>
		</pane>
}

ClassMethod SetIndexCategories() As %ArrayOfDataTypes
{
	Set tCat = ##class(%ArrayOfDataTypes).%New()
	Do tCat.SetAt("system",1)
	Do tCat.SetAt(1,"system")
	Do tCat.SetAt("busserv",2)
	Do tCat.SetAt(2, "busserv")
	Do tCat.SetAt("sender",3)
	Do tCat.SetAt(3, "sender")
	Do tCat.SetAt("senderSystem",4)
	Do tCat.SetAt(4, "senderSystem")
	Do tCat.SetAt("consumerSystem",5)
	Do tCat.SetAt(5, "consumerSystem")
	Do tCat.SetAt("subscription",6)
	Do tCat.SetAt(6, "subscription")
	
	
	Quit tCat
}

Method GetIndexStart(pType As %String) As %Integer [ ZenMethod ]
{
	Set:..IndexSettings.Count()=0 ..IndexSettings = ..SetIndexCategories()
	Quit ..#INDEXMULTIPLE * ..IndexSettings.GetAt(pType)
}

Method GetIndexType(pIndex As %Integer) As %String [ ZenMethod ]
{
	Set:..IndexSettings.Count()=0 ..IndexSettings = ..SetIndexCategories()
	Quit ..IndexSettings.GetAt(pIndex\..#INDEXMULTIPLE)
}

ClassMethod GetIndexLocal(pIndex As %Integer) As %String [ ZenMethod ]
{
	Quit pIndex # ..#INDEXMULTIPLE
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Registry Viewer")
}

Method DrawDiagramHeader(pSeed As %String) As %Status
{
	Set tProd = %page.productionId
	Do ..LocalizeProductionStatus($$$eProductionStateStopped, .tProductionStateMessage, .tProductionCSS)
	
	&html<
	<div style="margin-left:20px;margin-right:20px">
	<table border="0" width="100%" valign="bottom" cellspacing="0" cellpadding="0">
	<tr><td nowrap width="15%"><span class="#(tProductionCSS)#" id="statusMsg">&nbsp; #(tProductionStateMessage)# &nbsp;</span>&nbsp;</td>
	>
	If ..currViewMode '= "bus" {
		If tProd '= "" {
			&html<<td nowrap width="*">&nbsp;&nbsp;&nbsp;</td>> // spacer
			// Item selection in case of multiple items with the same name; initially hidden
			&html<<td nowrap width="15%" id="id_spanChoose" align="center" class="dgmAction" style="cursor:default;visibility:hidden;" title='#($ZCVT($$$Text("Choose which item to edit, among several that have the same config name"),"O","HTML"))#'>
				#($$$TextHTML("Item:"))#
				<select id="id_Choose" onchange="zenPage.switchDuplItem();" class="dgmSelect">
				</select>&nbsp;&nbsp;&nbsp;</td>>

			// Legend
			&html<<td nowrap width="12%" align="center"><a title='#($ZCVT($$$Text("Show legend for shapes and colors"),"O","HTML"))#' class="dgmAction" href="#" onclick="zenPage.showLegend(); return false;">
				#($ZCVT($$$Text("Legend"),"O","HTML"))#</a>&nbsp;&nbsp;&nbsp;</td>>
			
			// Production settings
			&html<<td nowrap width="12%" align="center"><a title='#($ZCVT($$$Text("Display general settings for the Production"),"O","HTML"))#' class="dgmAction" href="#" onclick="zenPage.selectItem(-1); return false;">
				#($ZCVT($$$Text("Production Settings"),"O","HTML"))#</a>&nbsp;&nbsp;&nbsp;</td>>
		}
	} else {
		Set msgEnt = $$$TextHTML("Service Bus View")
		&html<<td nowrap width="5%">&nbsp;</td>
		<td style="padding:10px; color:#404040;font-size:9pt;"><b>#(msgEnt)#</b>>
	}
	&html<
	</tr></table>
	>
	&html<
		<table border="0" width="100%" cellspacing="0" class="dgmHostBar">
		<tr>
		>
	If (..currViewMode = "sender") {
		
		Set tHeader(1) = $LB("sender",$$$Text("Systems"),$$$Text("Systems that send to the switchboard"),1)
		Set tHeader(2) = $LB("dummy",$$$Text(""),$$$Text(""),0)
		Set tHeader(3) = $LB("listener",$$$Text("Listeners"),$$$Text("Business Services that accept incoming connections"),1)
		Set msgAdd = $$$Text("Add")
		Set hlpAdd = $$$Text("Add a new item to this column")
	} Elseif (..currViewMode = "subscription") {
		Set tHeader(1) = $LB("sender",$$$Text("Senders"),$$$Text("Systems that send to the switchboard"),0)
		Set tHeader(2) = $LB("dummy",$$$Text(""),$$$Text(""),0)
		Set tHeader(3) = $LB("consumer",$$$Text("Consumers"),$$$Text("Systems that consume messages from the switchboard"),1)
		Set msgAdd = $$$Text("Add")
		Set hlpAdd = $$$Text("Add a new item to this column")		
		
	}

		Set margin = 20
		Set wid = 180
		Set x = 0
		For n = 1:1:3 {
			Set tType = $LG(tHeader(n),1)
			Set tName = $LG(tHeader(n),2)
			Set tTitle = $LG(tHeader(n),3)
			Set tAddButton = $LG(tHeader(n),4)
			&html<
			<td class="dgmHeaderLabel" valign="bottom">
				<div id="dgmHdr_#(n)#" title="#(tTitle)#" class="dgmHeader" style="left:#(x+margin)#px;width:#(wid)#px">
				#(tName)#&nbsp;
				>
			If tAddButton {
				&html<
					<a title="#(hlpAdd)#" class="dgmHeaderCmd" href="#" onclick="zenPage.addItem('#(tType)#');return false;"><img border="0" alt="#(msgAdd)#" valign="bottom" src="deepsee/ds_plus_16.gif"/></a>
					>
			}
			&html<
				&nbsp;</td>
				</div></td>
				<td width="80%">&nbsp;</td>
				>
			Set x = x + (margin + wid)
		}
		&html<
		</tr></table>
		>
	
	&html<
	</div>
	>
	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = $$$Text("ITK Configuration")

	// Set pViewIcons(2) = $LB("productions",$$$Text("Show Production view"),"portal/view_box4.png")
	Set pViewIcons(1) = $LB("sender",$$$Text("Show systems, senders and listeners"),"portal/view_box_list.png")
	//Set pViewIcons(2) = $LB("consumer",$$$Text("Show consumer view"),"portal/view_box_grid.png")
	Set pViewIcons(2) = $LB("subscription",$$$Text("Show consumers, subscriptions and distribution rules"),"portal/view_bus.png")
	
	// command buttons
	Set iCmd=0
	// $LB(id,caption,help,onclick,hidden)
	If ""=..productionId {
		If ..canEdit {
			Set pCommands($I(iCmd)) = $LB("cmdNew",$$$Text("New"),$$$Text("Create a new ITK Switchboard Production definition"),"zenPage.newProduction();")
		}
		Set pCommands($I(iCmd)) = $LB("cmdOpen",$$$Text("Open"),$$$Text("Open an ITK Switchboard Production definition"),"zenPage.loadProduction();")
	} Else {
		If $system.Security.Check("%Ens_ProductionRun","USE") {
			Set pCommands($I(iCmd)) = $LB("cmdStart",$$$Text("Start"),$$$Text("Start this Production"),"zenPage.startProduction();")
			Set pCommands($I(iCmd)) = $LB("cmdStop",$$$Text("Stop"),$$$Text("Stop this Production"),"zenPage.stopProduction();")
			Set pCommands($I(iCmd)) = $LB("cmdUpdate",$$$Text("Update"),$$$Text("Update Production"),"zenPage.updateProduction('update');",1)
			Set pCommands($I(iCmd)) = $LB("cmdRecover",$$$Text("Recover"),$$$Text("Recover Production from a crash"),"zenPage.recoverProduction();",1)
			Set pCommands($I(iCmd)) = $LB("cmdReconcile",$$$Text("Reconcile"),$$$Text("Reconcile Production to the ITK Registry"),"zenPage.reconcileProduction();",1)
		}
	}
	// sort options
	Set pSortOptions(1) = $LB("name",$$$Text("Name"),$$$Text("Sort items by name"))
	Set pSortOptions(2) = $LB("status",$$$Text("Status"),$$$Text("Sort items by current status"))
	Set pSortOptions(3) = $LB("ordinal",$$$Text("Number"),$$$Text("Sort items by ordinal position"))

	Quit $$$OK
}

/// Make a call to GetProductionArray but filter out business services that
/// don't have a classname of EnsLib.ITK.Framework.Service.SOAPRequestHandler
Method GetListenerArray(ByRef pParameters, Output pMetaData, Output pData) As %Status
{
	Set tSC = $$$OK
	If (..productionId'="") {
		Set tSC = ..GetProductionArray(.pParameters, .pMetaData, .tDataStaging)

		Set tClassIndex = $LF(pMetaData, "classname")
		Quit:tClassIndex<=0 tSC

		Set tIndex = ""
		Set tCount = 0
		For {
			Set tIndex = $Order(tDataStaging(tIndex),1,tHost)
			Quit:tIndex=""
	
			If $LI(tHost,tClassIndex) = "EnsLib.ITK.Framework.Service.SOAPRequestHandler" {
				Set pData($I(tCount)) = tHost
			}
		}
	}
	
	Quit tSC
}

ClassMethod GetSettingsArrayById(ByRef pParameters, Output pMetaData, Output pData) As %Status
{
	if $G(pParameters("itemClass"))="" Quit ##super(.pParameters, .pMetaData, .pData)
	Quit ..GetSettingsArray(.pParameters, .pMetaData, .pData)
}

ClassMethod GetSettingsArray(ByRef pParameters, Output pMetaData, Output pData) As %Status
{
	Set tSC = $$$OK
	// Work out if we have an item selected
	Set tItemId = $G(pParameters("itemId"))
	// Replace underscores with spaces
	set tItemId = $TR(tItemId, "_", " ")
	Set tClassName = $G(pParameters("itemClass"))
	If (tItemId = "") || (tItemId = -1) {
		Set pParameters("HostName") = "$Production||"_%page.productionId
		Quit ##super(.pParameters, .pMetaData, .pData)
	}
	// If there isn't a classname, it could be a proper production host, so 
	// defer to the superclass
	if (tClassName = "") Quit ##super(.pParameters, .pMetaData, .pData)
	

	// Get the ITK item
	try {
		// First try the open method that passes the prod id
		Set tRegItem = $CLASSMETHOD(tClassName, "OpenWithHost", tItemId, %page.productionId)
	} catch (ex) {
		// If that failed, use the regular open
		Set tRegItem = $CLASSMETHOD(tClassName, "%OpenId", tItemId)
	}
	If tRegItem=$$$NULLOREF Set tSC=$$$ERROR($$$EnsErrGeneral,"Failed to open "_tClassName_" with id "_tItemId) Quit
	
	Set pMetaData=$LB("IsAdapter","Name","Value","ValueSource","DefaultValue","DefaultSource","Description","DataType","MAXLEN","MINVAL","MAXVAL","VALUELIST","DISPLAYLIST","IsRequired","LocalizedName","Category","LocalizedCategory","EditorContext")
	Kill pData
	if tRegItem.%IsA("Ens.Settings") {
		Set tSC = tRegItem.PopulateVirtualSettings()
		Quit:$$$ISERR(tSC) tSC
		

		For i=1:1:tRegItem.VirtualSettings.Count() {
			Set pData(i)=tRegItem.VirtualSettings.GetAt(i)
		}

		Goto Exit
	}
	
	// Now create the required data
	Set tClass = ##class(%Dictionary.ClassDefinition).%OpenId(tClassName)
 	
 	// Go through the indicies and find properties that are part of the IdKey as can't update these
 	Set idProps = ""
 	For i=1:1:tClass.Indices.Count() {
		If tClass.Indices.GetAt(i).IdKey {
			Set idProps = $LFS(tClass.Indices.GetAt(i).Properties)
			Quit
		}
			
 	}
  	
	For j=1:1:tClass.Properties.Count() {
		Set tProp = tClass.Properties.GetAt(j)
		Set pData(j) = $LB("Core",tProp.Name, $PROPERTY(tRegItem, tProp.Name), $Case($LF(idProps,tProp.Name)>0,0:$$$eConfigSettingValueTypeProperty,1:$$$eConfigSettingValueTypeReadOnly),,,tProp.Description,tProp.Type,,,,"","",tProp.Required,tProp.Name,"Basic",,)
	}
	
Exit
	Quit tSC
}

ClassMethod GetPropertyArray(ByRef pParameters, Output pMetaData, Output pData) As %Status
{
	Set tSC = $$$OK
	Set pClass = pParameters("class")
	Set tType = pParameters("type")
	Set tQuery = $G(pParameters("query"))
	// Get the properties
	Set tClass = ##class(%Dictionary.ClassDefinition).%OpenId(pClass)
 	Quit:tClass=$$$NULLOREF $$$ERROR($$$EnsErrGeneral,"Failed to get def for class "_pClass)
 	
 	Set tPropList = "id,name,type,zclass"
 	For i=1:1:tClass.Properties.Count() {
 		Set tPropList = tPropList_","_tClass.Properties.GetAt(i).Name	
 	}
 	
 	// Make a list	
	Set pMetaData=$ListFromString(tPropList)   //$LB("businessServiceName","invokingApplication","webService","invocationPattern","validatePayload","id")
	
	Try {
		// Get the Property values
		Set rs = ##class(%ResultSet).%New(pClass_":"_$SELECT(tQuery'="":tQuery, 1:"Extent"))
		Set tSC = rs.Execute()
		If $$$ISERR(tSC) Quit
		Set i = 0
		
		While rs.Next() {
			Set id = rs.Data("ID")
			
			// open the item
			try {
				Set tRegItem = $CLASSMETHOD(pClass, "OpenWithHost", id, %page.productionId)
			} catch ex {
				// Most likely, the OpenWithHost method didn't exist, so try regular open
				Set tRegItem = $CLASSMETHOD(pClass, "%OpenId", id)
			}
			If tRegItem=$$$NULLOREF Set tSC=$$$ERROR($$$EnsErrGeneral,"Failed to open "_pClass_" with id "_id) Quit
			
			Set tList = $TR(id," ","_")_","_id_","_tType_","_pClass
		 	For j=1:1:tClass.Properties.Count() {
			 	Set tList = tList_","_$PROPERTY(tRegItem, tClass.Properties.GetAt(j).Name)
		 	}
			Set i=i+1
			Set pData(i) = $LFS(tList)  //$LB(tRegItem.BusinessServiceName, tRegItem.SourceAppName, tRegItem.WebServiceName, tRegItem.InvocationPattern, tRegItem.ValidatePayload, tRegItem.%Id())
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Return the Registry model object.
ClientMethod getRegistryModel(id, update) [ Language = javascript ]
{
	var json = this.getComponentById(id);
	if (update) {
		json.reloadContents();
	}
	var data = json.getContentObject();
	return data;
}

/// Render the svg diagram.
ClientMethod drawDiagram(svg, cat) [ Language = javascript ]
{
	zenPage.stopTimers();
	
	if (!svg) {
		return;
	}
	
	this.currItem = -1;

	// clear contents of ownerDraw component
	svg.unrender();
	
	if (zenPage.productionId != '') {
		switch (this.currViewMode) {		
			case 'subscription':
				this.drawSubscriptions(svg, cat);
				zenPage.startTimers();
				break;
			case 'sender':
				this.drawSenders(svg, cat);
				zenPage.startTimers();
				break;
		}
	} else {
		// Disable tabs
		zenSetProp('tabSettings','disabled',true);
		zenSetProp('tabQueue','disabled',true);
		zenSetProp('tabEventLog','disabled',true);
		zenSetProp('tabMessages','disabled',true);
		zenSetProp('tabJobs','disabled',true);
		zenSetProp('tabActions','disabled',true);

		// Clear "Loading..." messages
		var grp = zen('settingsLoading'); grp.setHidden(true);

		// Display a hint message
		var label = svg.document.createElementNS(SVGNS,'text');
		label.setAttribute('class','messageText');
		label.setAttribute('x',50);
		label.setAttribute('y',50);
		var textNode = svg.document.createTextNode('Open an ITK Switchboard Production to display its configuration.');
		label.appendChild(textNode);
		svg.svgGroup.appendChild(label);

	}
}

ClientMethod drawSenders(svg, cat) [ Language = javascript ]
{
	var configSenders = this.getRegistryModel('systemList', true);

    // In order to use the generic list drawing of the standard portal
    // we need to provide an array of objects for the swim lanes
    hostObj = new Array(3);
    // First lane is the systems
    hostObj[0] = new Array();
    var defaultState = (zenPage.productionState==1?'ok':'stopped');
    if (configSenders) for (var n = 0; n < configSenders.children.length; n++ ) {
        var host = configSenders.children[n];
        host._index = zenPage.GetIndexStart('system') + n;
        // This is to allow connections to be made from this item
        host.hostType = 'service';
        host.status = defaultState;
        host.isMissingClass = 0;
        hostObj[0][hostObj[0].length] = host;
    }
    // Nothing in the second lane
    hostObj[1] = new Array();
    // Third lane is the business services
    configListeners = this.getRegistryModel('busservList',true);


    hostObj[2] = new Array();
    if (configListeners) for (var n = 0; n < configListeners.children.length; n++) {
        var host = configListeners.children[n];
        switch (host.hostType) {
        case 'service':
            // Change the host type to allow connections to be made to this item
            host.hostType = 'busserv';
            if (host.status != 'disabled') host.status = defaultState;
            host._index = zenPage.GetIndexStart('busserv')+ n;
            hostObj[2][hostObj[2].length] = host;
            break;

        }
    }

	this.drawListing(svg, hostObj);
}

ClientMethod drawSubscriptions(svg, cat) [ Language = javascript ]
{
	var configSenders = this.getRegistryModel('senderSystemList', true);

    // In order to use the generic list drawing of the standard portal
    // we need to provide an array of objects for the swim lanes
    hostObj = new Array(3);
    // First lane is the source systems
    hostObj[0] = new Array();
    var defaultState = (zenPage.productionState==1?'ok':'stopped');
    if (configSenders) for (var n = 0; n < configSenders.children.length; n++ ) {
        var host = configSenders.children[n];
        host._index = zenPage.GetIndexStart('senderSystem') + n;
        // This is to allow connections to be made from this item
        host.hostType = 'service';
        host.status = defaultState;
        host.isMissingClass = 0;
        hostObj[0][hostObj[0].length] = host;
    }
    // Nothing in the second lane
    hostObj[1] = new Array();
    // Third lane is the consumers
    configConsumers = this.getRegistryModel('consumerSystemList',true);


    hostObj[2] = new Array();
    if (configConsumers) for (var n = 0; n < configConsumers.children.length; n++) {
        var host = configConsumers.children[n];
        // Change the host type to allow connections to be made to this item
        host.hostType = 'consumerSystem';

        if (host.BusHostStatus) {
	        if (host.BusHostStatus == 'ok') {
		        host.status = defaultState;
	        } else {
		        host.status = host.BusHostStatus;
	        }
        } else {
	    	host.status = 'inactive';
        }
        host.isMissingClass = 0;
        host._index = zenPage.GetIndexStart('consumerSystem')+ n;
        hostObj[2][hostObj[2].length] = host;
    }

	this.drawListing(svg, hostObj);
}

/// Update contents of the tabs
ClientMethod updatePropertySheetTabs(host, skipSettings) [ Language = javascript ]
{
	if (!skipSettings) this.updateITKSettings(host);
	this.updateActions(host);
	this.showMsgBox(false);
	return true;
}

/// Select the item with the given id.
ClientMethod selectItem(itemNo, force, skipSettings) [ Language = javascript ]
{
	if (!skipSettings && (this.currItem != itemNo) || force) {
		// prompt if unsaved settings
		if (this.pageModified && this.currItem != itemNo) {
			var oldHost = this.getHost();
			if (this.currItem < 0) { var conf = $$$Text("Changes made to Production settings will be lost. Proceed?") }
			else { var conf = $$$FormatText($$$Text("Changes made to item '%1' settings will be lost. Proceed?"),oldHost.name) }
			if (!confirm(conf)) {
				// user chose to keep changes
				var ctl = document.getElementById('id_Category');
				if (ctl.value != zenPage.currCategory) {
					// category was being changed; revert
					try {
						var ctl = document.getElementById('id_Category').options;
						var c = zenPage.currCategory;
						for (i = 0; i < ctl.length; i++) {
							if (ctl[i].value == c) {
								ctl[i].selected = true;
								break;
							}
						}
					}
					catch(ex) {
					}
				}
				return false;
			}
			// clear changed flags after ok to abandon changes
			var form = zen('settingsForm');
			if (form) form.changedSetting = {};
			this.pageModified = false;
			this.stopTimers();
			this.KillModifiedSettings();
			zenPage.startTimers(0);	
		}
		if (zenPage.productionId == '') {
			return false;
		}

		var host = zenPage.getHost(itemNo);

		if (!skipSettings) {
			// hide previous contents of tabs and show "Loading..." message
			var grp = zen('settingsForm'); grp.setHidden(true);
			var grp = zen('grpSettingsScroll'); grp.setHidden(true);
			var grp = zen('settingsLoading'); grp.setHidden(false);
		}

		// unhighlight old
		var frame = zen('svg');
		var rect = frame.getSVGDocument().getElementById('item_' + this.currItem);
		if (rect) {
			var oldClass = rect.getAttribute('class');
			var newClass = oldClass.replace('Select','');
			rect.setAttribute('class',newClass);
			try {
				var rectDupl = frame.getSVGDocument().getElementById('id_duplBox');
				if (rectDupl) rectDupl.parentNode.removeChild(rectDupl);
			} catch(ex) { }
			document.getElementById('id_spanChoose').style.visibility = "hidden";
		}

		this.currItem = itemNo;

		zenPage.stopTimers();
		zenPage.KillModifiedSettings();

		if (host.isMissingClass && host.isMissingClass > 0) {
			if (!this.canEdit) {
				alert($$$Text("Cannot retrieve all information for this item because its associated class does not exist or is not successfully compiled:") + ' ' + host.classname);
				this.currHostId = '';
			}
			else {
				var propTabs = zen('propertyTabs');
				zenPage.currTabNo = propTabs.getCurrTabNo();
				zenPage.updateActions(host);
				propTabs.showTab(6);
				zenSetProp('tabSettings','disabled',true);
				var rect = frame.getSVGDocument().getElementById('item_' + this.currItem);
				if (rect) rect.setAttribute('class','itemRectRedSelect');
				this.currHostId = host.id;
				var div = self.document.getElementById('componentName');
				div.innerHTML = host.name;
				div.title = host.description;
			}
			return false;
		}

		// highlight new
		if (zenPage.currTabNo > 0) {
			zenSetProp('tabSettings','disabled',false);
			zen('propertyTabs').showTab(zenPage.currTabNo);
			zenPage.currTabNo = 0;
		}
		if (host && this.currItem > -1) {
			var rect = frame.getSVGDocument().getElementById('item_' + this.currItem);
			if (rect) rect.setAttribute('class','itemRectSelect');
			this.currHostId = host.id;
			if (this.currViewMode == 'list') {
				if (!host.hasDups) {
					// check if this host has duplicates
					var dups = new Array();
					dups = zenPage.GetDuplicateItems(zenPage.productionId,host.name);
					host.hasDups = new Array();
					var k = 0;
					for (var i in dups) {
						host.hasDups[k] = new Array();
						host.hasDups[k][0] = i;
						host.hasDups[k][1] = dups[i];
						k++;
					}
					// save in hostObj for future selections
					var loc = zenPage.findHostObj(itemNo); var n = Math.floor(loc/10); var ln = loc % 10;
					hostObj[ln][n].hasDups = host.hasDups.slice(0);
				}
				if (host.hasDups.length > 1) {
					// there is one or more duplicates, show count indicator and select control
					zenPage.drawDuplBox(itemNo,host.hasDups.length);
					zenPage.redrawItemDuplControl(host);
					// to do: onclick an option: name order just update the host; status or number order, reload the diagram, look for the item to select it (HCR)
				}
			}
		} else {
			this.currHostId = '';
		}

		// update property sheet for new item (delay is needed for IE to catch up)
		setTimeout(function() {
			var done = zenPage.updatePropertySheet(host,skipSettings);
			zenPage.startTimers(0);	
		}, 100);
	}

	return true;
}

/// User has pressed add item command - show corresponding add host wizard dialog.
ClientMethod addItem(type) [ Language = javascript ]
{
	if (!this.checkHelper('ITKWrite')) {
		return false;
	}
	var ret = false;

	if (zenPage.productionId != '') {
		var parms = {
			PRODUCTION: zenPage.productionId,
			TYPE: type
			};
		switch (type) {
		case 'listener':
			ret = zenLaunchPopupWindow(zenLink('EnsLib.ITK.Setup.UI.AddListener.zen'),this.addPopupSuffix('NewListenerWizard'),'status,scrollbars,resizable=yes,width=350,height=250',parms);
			break;
		case 'sender':
		case 'consumer':
			ret = zenLaunchPopupWindow(zenLink('EnsLib.ITK.Setup.UI.AddSystem.zen'),this.addPopupSuffix('NewSystemWizard'),'status,scrollbars,resizable=yes,width=350,height=300',parms);
			break;
		case 'operation':
			ret = zenLaunchPopupWindow(zenLink('EnsPortal.Dialog.ProductionAddOperation.zen'),this.addPopupSuffix('NewOperationWizard'),'status,scrollbars,resizable=yes,width=900,height=600',parms);
			break;
		}
	}
	return ret;
}

/// Adjust sizes of components on the page.
ClientMethod adjustSizes() [ Language = javascript ]
{
	// Prevent any adjustments if the window height and width did not actually change
	var pageWidth = (zenIsIE ? document.body.scrollWidth : document.body.clientWidth); 
	var pageHeight = document.body.offsetHeight;
	if ((auxVarHeight == pageHeight) && (auxVarWidth == pageWidth)) {
		// No need to adjust sizes, so simply return
		return;
	}
	auxVarHeight = pageHeight;
	auxVarWidth = pageWidth;

	var updated = false;
	try {
		var ribbonDiv = zen('toolRibbon').getEnclosingDiv();
		var dgmhdrDiv = zen('diagramHeader').getEnclosingDiv();
		var propDiv = zen('propertyPane').getEnclosingDiv();
		var dgmDiv = zen('diagramPane').getEnclosingDiv();
		var proptitleDiv = zen('propertyTitle').getEnclosingDiv();
		var proptabsDiv = zen('propertyTabs').getEnclosingDiv();
		var formDiv = zen('settingsForm').getEnclosingDiv();

		propDiv.style.display = 'block';
		dgmhdrDiv.style.display = 'block';

		var svg = zen('svg');
		var svgDiv = svg.getEnclosingDiv();
		var svgDiagram = zen('svgDiagram');

		// find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 25;
		var svgHgt = hgt - dgmhdrDiv.offsetHeight - 1;
		var svgWid = winWidth - propDiv.offsetWidth - 25;
		hgt = (hgt < 1 ? 1 : hgt);
		svgHgt = (svgHgt < 1 ? 1 : svgHgt);
		svgWid = (svgWid < 1 ? 1 : svgWid);

		if (svgWid < 100) {
			dgmDiv.style.display = 'none';
		}
		else {
			dgmDiv.style.display = 'block';
		}

		// Deal with IE box model
		var hdrWid = (svgWid - (zenIsIE * 40));
		hdrWid = (hdrWid < 1 ? 1 : hdrWid);
		dgmhdrDiv.style.width = hdrWid + 'px';
		// Check the width calculated by the browser (esp. IE)
		var hdrOffset = dgmhdrDiv.offsetWidth;
		if (svgWid < hdrOffset) {
			svgWid = hdrOffset;
		}
		dgmDiv.style.width = svgWid + 'px';
		ribbonDiv.style.width = (winWidth-25) + 'px';

		propDiv.style.height = hgt - 1 + 'px';

		var tabBodyHgt = (hgt - proptitleDiv.offsetHeight - 31);
		tabBodyHgt = (tabBodyHgt < 1 ? 1 : tabBodyHgt);
		zen('propertyTabs').setBodySize(tabBodyHgt,395);
		formDiv.style.width="380px";
		var grpHgt=zen('grpSettingsScroll').getEnclosingDiv().offsetHeight+40;
		var formDivHgt = ((tabBodyHgt-grpHgt) < 1 ? 1 : tabBodyHgt-grpHgt);
		formDiv.style.height=formDivHgt+'px';
		
		// columns widths in diagram
		var gutter = 20;
		var colWid = (svgWid - gutter) / 3 - gutter;
		colWid = (colWid < 1 ? 1 : colWid);

		for (var n = 0; n < 3; n++) {
			var col = self.document.getElementById('dgmHdr_'+(n+1));
			if (col) {
				col.style.width = colWid + 'px';
				col.style.left = gutter + (n * (colWid + gutter)) + 'px';
			}
		}

		if (null == this._percent) {
			svg.setProperty('height',svgHgt);
			svg.setProperty('width',svgWid);
			svgDiagram.setProperty('width',svgWid);
			this.updateView(true);
			updated = true;
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
	return updated;
}

ClientMethod getCurrHost(itemNo) [ Language = javascript ]
{
	if (!itemNo) itemNo = zenPage.currItem;
	if (itemNo == -1) {
		item = new Object();
		item.name = '$Production||'+zenPage.productionId;
		item.id = -1;
		item.type= "";
	} else {
		var config = zenPage.getRegistryModel(zenPage.GetIndexType(itemNo) + 'List');
		var index = zenPage.GetIndexLocal(itemNo);
		
		if (!config) return null;
		var item = config.children[index];
	}
	return item;
}

/// This is called when a new config item is selected.
/// It should update the various property sheets.
ClientMethod updatePropertySheet(host, skipSettings) [ Language = javascript ]
{
	
	// Update property pane's name caption
	var div = self.document.getElementById('componentName');
	if (div) {
		if (zenPage.productionId == '') {
			div.innerHTML = '&nbsp;';
		} else {
			div.innerHTML = (host.id != -1) ? host.name : '<i>' + $$$Text('ITK Settings') + '</i>';
			//div.title = (host.id != -1) ? host.description : host.name.split('||')[1];
		}
	}

	// Update tabs (delay is needed for IE to catch up and display new property name)
	setTimeout(function() {
		return zenPage.updatePropertySheetTabs(host,skipSettings);
	}, 50);
}

/// Update the settings form for the given host item.<br/>
ClientMethod updateITKSettings(host, searchStr) [ Language = javascript ]
{
	var parm = zen('siItemId');
	parm.value = host.id;
	var parm2 = zen('siItemClass');
	parm2.value = host.zclass;
	this.updateSettings(host, searchStr);
	
	// Add a text property on the end to give the user instructions
	var form = zen('settingsForm');
	var spacer = zenPage.createComponent('spacer');
	spacer.aux = '%';
	spacer.height = '15';
	var ctrllb = zenPage.createComponent('label');
	ctrllb.controlClass = 'infoLabel';
	ctrllb.enclosingStyle = 'margin-left:10px;';
	form.addChild(spacer);
	if (host.id < 0) {
		if (this.currViewMode == 'sender') {
			ctrllb.value = $$$Text('Draw a line between a System and a Listener to create a Sender.  Click on the dot beside a component to view the senders connecting to it.');		
		} else {
			ctrllb.value = $$$Text('Draw a line between a Sender and a Consumer to create a Subscription.  Click on the dot beside a component to view the subscriptions connecting to it.');		
		}
	} else {
		switch (host.type) {
			case 'system':
				ctrllb.value = $$$Text('This component represents an external system.');
				break;
			case 'senderSystem':
				ctrllb.value = $$$Text('This component represents an external sending system.  Only systems with entries in the Sender Registry are shown.  To edit the Sender Registry switch to the Sender view');
				break;
			case 'consumerSystem':
				ctrllb.value = $$$Text('This component represents an external consuming system.  Setup the services to be consumed and the distribution rules for this consumer here.  To create a Subscription, draw a line from a Sender to a Consumer.');
				break;
			default:
				ctrllb.value = $$$Text('This component is a listener within the switchboard.  It can be configured here or in the production.');
				break;
		}	
	}
	form.addChild(ctrllb);
	form.refreshContents();
}

/// Mouse up handler.
ClientMethod backgroundMouseUpHandler(evt) [ Language = javascript ]
{
	//evt.stopPropagation();
	var svg = zen('svg');
	// turn off mouse events
	svg.svgGroup.removeEventListener('mousemove',this._mmHandler,false);
	svg.svgGroup.removeEventListener('mouseup',this._muHandler,false);


	if (this._currRubberBand) {
		this.endRubberBand();
		if (this._startTarget) {
			this._startTarget.setAttribute("class","itemNormal");
		}
		if (this._connectTarget) {
			this._connectTarget.setAttribute("class","itemNormal");
		}
		if (null !== this._connectTargetNo && null !== this._itemNo) {
			this.connectItems(this._itemNo,this._connectTargetNo);
		}
	}

	
	if ((null!==this._itemNo) && this._downX == evt.clientX) {
		this.showConnectors(true,this._itemNo);
	}

	this._downX = null;
	this._downY = null;
	this._itemNo = null;
	this._canConnect = false;
	this._connectTarget = null;
	this._connectTargetNo = null;
	this._startTarget = null;
}

/// Show connectors for the given listing item.
ClientMethod showConnectors(display, itemNo) [ Language = javascript ]
{
	var type = zenPage.GetIndexType(itemNo);
	if (!type) type = this.currViewMode;
	switch (type) {
		case 'system':
		case 'busserv':
		case 'sender':
			var sysConfig = this.getRegistryModel('systemList');
			if (!sysConfig) return;
			var bsConfig = this.getRegistryModel('busservList');
			if (!bsConfig) return;
			var senderConfig = this.getRegistryModel('senderList', true);
			if (!senderConfig) return;
			var config = {children: sysConfig.children.concat(bsConfig.children) };
			var configs = { system: sysConfig, busserv: bsConfig, connector: senderConfig};
			var connector = {leftType: 'system', leftProperty: 'SourceAppName', rightType: 'busserv' , rightProperty: 'BusinessServiceName'};
			break;
		case 'senderSystem':
		case 'consumerSystem':
		case 'subscription':
			var senderConfig = this.getRegistryModel('senderSystemList');
			if (!senderConfig) return;
			var consumerConfig = this.getRegistryModel('consumerSystemList');
			if (!consumerConfig) return;
			var subConfig = this.getRegistryModel('subscriptionList', true);
			if (!subConfig) return;
			var config = {children: senderConfig.children.concat(consumerConfig.children) };
			var configs = { senderSystem: senderConfig, consumerSystem: consumerConfig, connector: subConfig};
			var connector = {leftType: 'senderSystem', leftProperty: 'SourceApplication', rightType: 'consumerSystem'  , rightProperty: 'Subscriber'};
			break;
		default:
			var config = {children: new Array()};
	}
	
	// clear existing connectors
	var frame = zen('svg');
	var group = frame.getSVGDocument().getElementById('connectorGroup');
	while (group.firstChild) {
		group.removeChild(group.firstChild);
	}

	// unaccent connected items
	for (var n = 0; n < config.children.length; n++) {
		var item = config.children[n];
		if (item._label && item._rect && item._dot) {
			item._dot.setAttribute('r',item._r);
			item._label.setAttribute('style','');

			switch(item.status) {
			case 'error':
				item._dot.setAttribute('style','fill: red;');
				item._rect.setAttribute('style','fill: red; stroke: black;');
				item._label.setAttribute('style','fill: white;');
				break;
			}
		}
	}		

	if (!display) {
		// start timers
		zenPage.startTimers();
		return;
	}

	// stop timers
	zenPage.stopTimers();

	// show waiting message
	this.showMsgBox(true);

	// continued... (delay is needed for IE to catch up and update display)
	setTimeout(function() {
		zenPage.showConnectorsContd(itemNo,configs, frame, group, connector);
	}, 50);
}

ClientMethod showConnectorsContd(itemNo, configs, frame, group, connector) [ Language = javascript ]
{
	// get lists of connections
	var inputList = new Array();
	var outputList = new Array();

	this.getConnectorInfo(itemNo,inputList,outputList,configs, connector);

	// create new connectors
	// track items that are connected
	var hlist = new Object();

	var hostType = zenPage.GetIndexType(itemNo);
	var host = configs[hostType].children[zenPage.GetIndexLocal(itemNo)];
	if (host) {
		hlist[itemNo] = 1;
		// inputs
		for (var n = 0; n < inputList.length; n++) {
			var otherNo = inputList[n];
			if (!hlist[otherNo]) hlist[otherNo] = 0;
			hlist[otherNo]++;
			
			if (hlist[otherNo] == 1) {
				var otherHost = configs[zenPage.GetIndexType(otherNo)].children[zenPage.GetIndexLocal(otherNo)];
			
				var line = frame.getSVGDocument().createElementNS(SVGNS,'line');
				line.setAttribute('class','listingConnectorLine');
				line.setAttribute('x1',host._cx1);
				line.setAttribute('y1',host._cy1);
				line.setAttribute('x2',otherHost._cx2);
				line.setAttribute('y2',otherHost._cy2);
				group.appendChild(line);		

				// ouput dot for other
				var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
				dot.setAttribute('cx',otherHost._cx2);
				dot.setAttribute('cy',otherHost._cy2);
				dot.setAttribute('r',otherHost._r);
				dot.setAttribute('class','itemNormal');
				dot.setAttribute('style','fill: white;');
				dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
				group.appendChild(dot);

				var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
				dot.setAttribute('cx',otherHost._cx2);
				dot.setAttribute('cy',otherHost._cy2);
				dot.setAttribute('r',otherHost._r/2);
				dot.setAttribute('class','itemNormal');
				dot.setAttribute('style','fill: orange;');
				dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
				group.appendChild(dot);
				
				// Box with number of services
				
				this.createNumServicesBox(frame, group, otherNo, host, otherHost, host._cx1 - otherHost._cx2, host._cy1 - otherHost._cy2);
			}
		}
		
		// Loop through hlist to update service counts
		for (var itemNo in hlist) {
			var label = frame.getSVGDocument().getElementById('svcs_' + itemNo);
			if (!label) continue;
			var textNode = frame.getSVGDocument().createTextNode(hlist[itemNo]);
			label.appendChild(textNode);	
		}

		// outputs
		var hlist2 = new Object();
		for (var n = 0; n < outputList.length; n++) {
			var otherNo = outputList[n];
			if (!hlist2[otherNo]) hlist2[otherNo] = 0;
			hlist2[otherNo]++;

			if (hlist2[otherNo] == 1) {
				var otherHost = configs[zenPage.GetIndexType(otherNo)].children[zenPage.GetIndexLocal(otherNo)];
				var line = frame.getSVGDocument().createElementNS(SVGNS,'line');
				line.setAttribute('class','listingConnectorLine');
				line.setAttribute('x1',host._cx2);
				line.setAttribute('y1',host._cy2);
				line.setAttribute('x2',otherHost._cx1);
				line.setAttribute('y2',otherHost._cy1);
				group.appendChild(line);
			

				// input dot for other
				var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
				dot.setAttribute('cx',otherHost._cx1);
				dot.setAttribute('cy',otherHost._cy1);
				dot.setAttribute('r',otherHost._r);
				dot.setAttribute('class','itemNormal');
				dot.setAttribute('style','fill: white;');
				dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
				group.appendChild(dot);

				var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
				dot.setAttribute('cx',otherHost._cx1);
				dot.setAttribute('cy',otherHost._cy1);
				dot.setAttribute('r',otherHost._r/2);
				dot.setAttribute('class','itemNormal');
				dot.setAttribute('style','fill: orange;');
				dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
				group.appendChild(dot);
				
				// Box with number of services
				this.createNumServicesBox(frame, group, otherNo, host, otherHost, host._cx2 - otherHost._cx1, host._cy2 - otherHost._cy1);
				
			}
		}
		
		// Loop through hlist to update service counts
		for (var itemNo in hlist2) {
			// Add to first hlist for later use
			hlist[itemNo] = hlist2[itemNo];
			var label = frame.getSVGDocument().getElementById('svcs_' + itemNo);
			if (!label) continue;
			var textNode = frame.getSVGDocument().createTextNode(hlist2[itemNo]);
			label.appendChild(textNode);	
		}

		// input dot for this host
		var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
		dot.setAttribute('cx',host._cx1);
		dot.setAttribute('cy',host._cy1);
		dot.setAttribute('r',host._r);
		dot.setAttribute('class','itemNormal');
		dot.setAttribute('style','fill: white');
		dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
		group.appendChild(dot);

		var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
		dot.setAttribute('cx',host._cx1);
		dot.setAttribute('cy',host._cy1);
		dot.setAttribute('r',host._r/2);
		dot.setAttribute('class','itemNormal');
		dot.setAttribute('style','fill: blue');
		dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
		group.appendChild(dot);

		// ouput dot for this host
		var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
		dot.setAttribute('cx',host._cx2);
		dot.setAttribute('cy',host._cy2);
		dot.setAttribute('r',host._r);
		dot.setAttribute('class','itemNormal');
		dot.setAttribute('style','fill: white;');
		dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
		group.appendChild(dot);

		var dot = frame.getSVGDocument().createElementNS(SVGNS,'circle');
		dot.setAttribute('cx',host._cx2);
		dot.setAttribute('cy',host._cy2);
		dot.setAttribute('r',host._r/2);
		dot.setAttribute('class','itemNormal');
		dot.setAttribute('style','fill: blue');
		dot.setAttribute('onmousedown','zenPage.showConnectors(false);');
		group.appendChild(dot);

		// unaccent non-connected items
		var config = { children: configs[connector.leftType].children.concat(configs[connector.rightType].children) };
		for (var n = 0; n < config.children.length; n++) {
			var item = config.children[n];
			if (item._label && item._rect && item._dot) {
				if (!hlist[n]) {
					item._dot.setAttribute('r',host._r/2);
					item._label.setAttribute('style','fill: #D0D0D0;');

					switch(item.status) {
					case 'error':
						item._dot.setAttribute('style','fill: red;');
						item._rect.setAttribute('style','fill: #FFA0A0; stroke: gray;');
						item._label.setAttribute('style','fill: white;');
						break;
					}
				}
			}
		}
	}
}

ClientMethod createNumServicesBox(frame, group, otherNo, host, otherHost, dx, dy) [ Language = javascript ]
{
	// Box with number of services
	var ratio = 40.0 / Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
	var rect = frame.getSVGDocument().createElementNS(SVGNS,'rect');
	var id = (dx > 0?otherHost.name + "|" + host.name:host.name + "|" + otherHost.name);
	rect.setAttribute('id',id)
	var x = (dx < 0?otherHost._cx1:otherHost._cx2);
	x += (dx * ratio);
	rect.setAttribute('x', x - 8);
	rect.setAttribute('width',16);
	rect.setAttribute('height',16);
	var y = (dy < 0?otherHost._cy1:otherHost._cy2);
	y += (dy * ratio);
	rect.setAttribute('y', y - 8);
	rect.setAttribute('rx',2);
	rect.setAttribute('ry',2);
	rect.setAttribute('class','numServicesR');

	rect.addEventListener('mouseup',new Function('evt','zenPage.servicesClick(evt,\''+id+'\',false);'),false);
	rect.addEventListener('mouseover',new Function('evt','evt.target.setAttribute("class","numServicesRHover");'),false);
	rect.addEventListener('mouseout',new Function('evt','evt.target.setAttribute("class","numServicesR");'),false);
	
	group.appendChild(rect);

	var label = frame.getSVGDocument().createElementNS(SVGNS,'text');
	label.setAttribute('id','svcs_' + otherNo);
	label.setAttribute('class','numServicesT');

	label.setAttribute('x',x);
	label.setAttribute('y',y + 3);
	label.setAttribute('text-anchor','middle');
	
	group.appendChild(label);
}

/// User clicked on a sender line
ClientMethod servicesClick(evt, itemNo) [ Language = javascript ]
{
	if (!evt) {
		evt = window.event;
	}
	if (evt.detail == 2) {
		// two consecutive clicks = double-click: enable/disable item
		zenPage.itemDblClick(evt, itemNo);
		return;
	}

	// single-click: select item
	try {
		if (this.currItem == itemNo) {
			// item is already selected, nothing to do
			return;
		}
	}
	catch (ex) {
	}

	this._currEl = evt.target;
	// Open the popup windows for senders
	var mode = zenPage.currViewMode
	switch (mode) {
		case 'sender':
			this.openEditSenders(itemNo);
			break;
		case 'subscription':
			this.openEditSubscriptions(itemNo);
			break;
	}

			
//	this.selectItem(itemNo);
//	this.showConnectors(false);
}

/// User clicked on a sender line
ClientMethod openEditSenders(itemNo) [ Language = javascript ]
{
	var parms = new Object();
	parms.itemNo = itemNo;
	zenPage.launchPopupWindow(zenLink('EnsLib.ITK.Setup.UI.EditSenders.zen'),this.addPopupSuffix('EditSenderRegistry'),'status,scrollbars,resizable=yes,width=900,height=600',parms);
}

/// User clicked on a sender line
ClientMethod openEditSubscriptions(itemNo) [ Language = javascript ]
{
	var parms = new Object();
	parms.itemNo = itemNo;
	zenPage.launchPopupWindow(zenLink('EnsLib.ITK.Setup.UI.EditSubscriptions.zen'),this.addPopupSuffix('EditSubscriptions'),'status,scrollbars,resizable=yes,width=900,height=600',parms);
}

/// Save settings for the given configuration item or general Production.
ClassMethod SaveITKSettingsToServer(pProductionId As %String, pHostId As %String, pHostClass As %String, pCoreSettings As %ZEN.proxyObject, pHostSettings As %ZEN.proxyObject, pAdapterSettings As %ZEN.proxyObject, pMessages As %ZEN.proxyObject, pExpandoStates As %String) As %String [ ZenMethod ]
{
	Set tSC = $$$OK, tMsg = ""
	Try {
		Set pMessages.message = ""
		Set pMessages.doUpdate = 0

		Do:$IsObject(pCoreSettings) pCoreSettings.%CopyToArray(.tCoreValues)
		Do:$IsObject(pHostSettings) pHostSettings.%CopyToArray(.tHostValues)
		Do:$IsObject(pAdapterSettings) pAdapterSettings.%CopyToArray(.tAdapterValues)

		If ""=pHostId {
			Set tSC = $$$ERROR($$$EnsErrGeneral,"Unable to apply settings because configuration item not identified")
			Quit
		} ElseIf -1=pHostId {
			#; Do Production settings
			Merge tSettInfo = %session.Data("ProdConf_Settings") // v(Name) = $LB(Target, Value, ValueSource, DefaultValue, DefaultSource)
			Merge tSettReset = %session.Data("ProdConf_Settings_Reset",1) // Settings that were selected to be reset

			Set tProd = ##class(Ens.Config.Production).%OpenId(pProductionId,,.tSC)
			If '$IsObject(tProd) || $$$ISERR(tSC) {
				Set tSC = $$$ERROR($$$EnsErrGeneral,"Unable to apply settings because configuration for Production '"_pProductionId_"' could not be opened:"_$$$StatusDisplayString(tSC))
				Quit
			}
			#; First apply Production Core properties
			Set tProp=""  For { Set tProp = $O(tCoreValues(tProp))  Quit:(tProp = "")
				Try { // Not all values are actual properties
					Set tSC = $classmethod("Ens.Config.Production", tProp_"IsValid", tCoreValues(tProp))
					If $$$ISERR(tSC) {
						Set pMessages.error = "settCore"_tProp, tTarget="Core"
						Quit
					}
					Set $property(tProd, tProp) = tCoreValues(tProp)
				} Catch(ex) {
					Set tSC = ex.AsStatus()
				}
				Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC)

			#; Now apply the dynamic setting values.
			$$$ASSERT(pProductionId=tProd.Name)
			Set tName=""  For { Set tName = $O(tHostValues(tName))  Quit:(tName = "")
				If pProductionId'="" {
					Set tSC = $classmethod(pProductionId, tName_"IsValid", tHostValues(tName))
					If $$$ISERR(tSC) {
						Set pMessages.error = "sett"_tName, tTarget = ""
						Quit
					}
				}
				Set tValue = tHostValues(tName)
				If $D(tSettReset(tName)) && (tValue=$LG(tSettInfo(tName),4)) {
					Set isReset = 1 // User selected to reset to default and current value still matches the default
				}
				Else {
					Set isReset = 0
				}
				Kill tSettReset(tName)
				Set tSetting = tProd.FindSettingByName(tName) 
				If $IsObject(tSetting) {
					If 'isReset {
						Set tSetting.Value = tValue
					}
					Else {
						// Remove this setting because it is being reset, will acquire the default
						Set tSC = ..RemoveSettingByName(tProd, tName, "")
					}
				}
				Else {
					If 'isReset {
						Set tSetting = ##class(Ens.Config.Setting).%New()
						Set tSetting.Name = tName
						Set tSetting.Value = tValue
						Do tProd.Settings.Insert(tSetting)
					}
				}
			}
			Quit:$$$ISERR(tSC)
			Set tName = ""
			For {
				Set tName = $O(tSettReset(tName))
				Quit:tName=""
				Set tSC = ..RemoveSettingByName(tProd, tName, "")
				Quit:$$$ISERR(tSC)
			}
			Quit:$$$ISERR(tSC)
			Set tSC = tProd.%Save()
			Quit:$$$ISERR(tSC)

		} Else {
			#; Do Item settings
			Merge tSettings("Host") = tHostValues
			Merge tSettings("Adapter") = tAdapterValues
			Merge tSettInfo = %session.Data("ProdConf_Settings") // v(Name) = $LB(Target, Value, ValueSource, DefaultValue, DefaultSource)
			Merge tSettReset = %session.Data("ProdConf_Settings_Reset",1) // Settings that were selected to be reset
			Kill tHostValues, tAdapterValues

			If '$system.Security.Check("%Ens_ProductionConfig","WRITE") {
				// Check only enabled/disabled has been changed
				If $data(tSettings) {
					Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation)
					Quit
				}
				Set k="" For { Set k = $O(tCoreValues(k))  Quit:""=k
					Continue:k="Enabled"
					// Other setting has been changed
					Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation)
					Quit
				}
				Quit:$$$ISERR(tSC)
			}
			
			Set tItem = $CLASSMETHOD(pHostClass, "%OpenId", pHostId, .tSC)
			If '$IsObject(tItem) || $$$ISERR(tSC) {
				Set tSC = $$$ERROR($$$EnsErrGeneral,"Unable to apply settings because configuration item id '"_pHostId_"' could not be opened:"_$$$StatusDisplayString(tSC))
				Quit
			}
			
			//Set tProd = tItem.Production
			#; First apply item Core properties
			Set tProp=""  For { Set tProp = $O(tCoreValues(tProp))  Quit:(tProp = "")
				Try { // Not all values are actual properties
					Set tSC = $classmethod(pHostClass, tProp_"IsValid", tCoreValues(tProp))
					If $$$ISERR(tSC) {
						Set pMessages.error = "settCore"_tProp, tTarget="Core"
						Quit
					}
					Set $property(tItem, tProp) = tCoreValues(tProp)
					Set:"Enabled"=tProp&&'tCoreValues(tProp) pMessages.doUpdate = 1 ; special case for disabling
				} Catch(ex) {
					Set tSC = ex.AsStatus()
				}
				Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC)
			
			Set tName = ""
			For {
				Set tName = $O(tSettReset(tName))
				Quit:tName=""
				Set tSC = ..RemoveSettingByName(tItem, tName, "")
				Quit:$$$ISERR(tSC)
			}
			Quit:$$$ISERR(tSC)
			
			Set tSC = tItem.%Save()
			Quit:$$$ISERR(tSC)
		}
		Do ..StoreExpandoStates($S(-1=pHostId:"$Production",1:tItem.%Oid()),pExpandoStates)
	} Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		If $IsObject($get(pMessages)) && (pMessages.error '= "") {
			Set tMsg = $$$FormatText($$$Text("Invalid value for %1 setting '%2'"),tTarget, $E(pMessages.error,4+$L(tTarget)+1,*))_$c(13,10)
		}
		Set tMsg = tMsg _ $$$StatusDisplayString(tSC)
	}
	Quit tMsg
}

/// Get the information needed to display connectors for the given item.<br/>
/// <var>itemNo</var> is the index number of the item.<br/>
/// <var>inputList</var> is an array of index numbers of items that connect to the input.<br/>
/// <var>outputList</var> is an array of index numbers of items that connect to the output.<br/>
ClientMethod getConnectorInfo(itemNo, inputList, outputList, configs, connector) [ Language = javascript ]
{
	var hostType = zenPage.GetIndexType(itemNo);
	if (!hostType || hostType == '') return;
	var host = configs[hostType].children[zenPage.GetIndexLocal(itemNo)];
	if (host && '' !== host.id) {
		
		var list = configs.connector;
		var leftIndexStart = zenPage.GetIndexStart(connector.leftType);
		var rightIndexStart = zenPage.GetIndexStart(connector.rightType);
		
		if (list) {
			// list is of the form:
			// list[n] = {itemName,isTarget}

			// transform to input/output
			for (var n = 0; n < list.children.length; n++) {
				var conn = list.children[n];
				
				if (hostType == connector.leftType) {
					if (conn[connector.leftProperty] == host.name) {
						// find host item number with name of source/target connection child
						var hostNo = '';
						for (var h = 0; h < configs[connector.rightType].children.length; h++) {
							var item = configs[connector.rightType].children[h];
							if (item.name==conn[connector.rightProperty]) {
								hostNo = h;
								break;
							}
						}
						if (''!==hostNo) outputList[outputList.length] = rightIndexStart + hostNo;
					}	
				} else if (hostType == connector.rightType){
					if (conn[connector.rightProperty] == host.name) {
						// find host item number with name of source/target connection child
						var hostNo = '';
						for (var h = 0; h < configs[connector.leftType].children.length; h++) {
							var item = configs[connector.leftType].children[h];
							if (item.name==conn[connector.leftProperty]) {
								hostNo = h;
								break;
							}
						}
					
						if (''!==hostNo) inputList[inputList.length] = leftIndexStart + hostNo;
					}
				}
			}
		}
		this.showMsgBox(false);
	}
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != 'ok') return false;
	popupName = this.removePopupSuffix(popupName);
	switch(popupName) {

    case 'EditSenderRegistry':
    case 'EditSubscriptions':
        this.updateView(false,true);
        break;
    case 'EditConsumerRegistry':
    case 'NewListenerWizard':
        if (action != 'ok' || value == false) {
        	break;
        }
        if (value) {
            if (zenPage.productionState == '1') {
                zenPage.updateProduction('update');
            }
        }
    case 'NewSystemWizard':
    case 'ReconcileProduction':
        this.updateView();
        break;
 	case 'NewProductionWizard':
 		zenPage.stopTimers();
		setTimeout(function() {
			self.document.location = zenLink('EnsLib.ITK.Setup.UI.RegistryViewer.zen?PRODUCTION=' + encodeURIComponent(value));
		}, 300);
		break;
	case 'ProductionOpen':
		zenPage.stopTimers();
		// strip off .cls extension
		var t = value.toString().split('.');
		t.length = t.length - 1;
		var name = t.join('.');
		setTimeout(function() {
			self.document.location = zenLink('EnsLib.ITK.Setup.UI.RegistryViewer.zen?PRODUCTION=' + encodeURIComponent(name));
		}, 300);
		break;			
	default:
        this.invokeSuper('onPopupAction',[popupName,action,value]);
    }

	return true;
}

/// Update diagram.
ClientMethod updateView(skipSettings, showConnectors) [ Language = javascript ]
{
	zenPage.refreshDiagramHeaderStates();
	var svg = zenPage.getComponentById('svgDiagram');
	if (svg) {
		var itemNo = zenPage.currItem;
		svg.render();
		zenPage.currItem = itemNo;
		zenPage.selectItem(zenPage.currItem,true,skipSettings);
		if (showConnectors) this.showConnectors(true,zenPage.currItem);
	}
	
	var refreshElement = document.getElementById('id_refresh');
	if (refreshElement) {
		refreshElement.style.backgroundColor = ''; // in case the diagram was reloading, clear the background
	}
}

/// Try to make a connection from start item to end item. 
/// This works by launching the sender popup window.
ClientMethod connectItems(startNo, endNo) [ Language = javascript ]
{
	if (!this.checkHelper('ITKWrite')) {
		return false;
	}
	
	var leftConfig = this.getRegistryModel(zenPage.GetIndexType(startNo) + 'List');
	if (!leftConfig) return;
	var rightConfig = this.getRegistryModel(zenPage.GetIndexType(endNo) + 'List');
	if (!rightConfig) return;
	
	// Convert system id into name
	var left = leftConfig.children[zenPage.GetIndexLocal(startNo)].name;
	// Convert listener id into name
	var right = rightConfig.children[zenPage.GetIndexLocal(endNo)].name;
	
	// Construct the itemNo for the window which is "Left name|Right name"
	switch (zenPage.GetIndexType(startNo)) {
		case 'system':
			this.openEditSenders(left + "|" + right);
			break;
		case 'senderSystem':
			this.openEditSubscriptions(left + "|" + right);
			break;			
	}
}

ClientMethod updateActions(host) [ Language = javascript ]
{
	try {
		if (host.id < 0) {
			// Production actions

			// "Test" does not apply
			var grp = zen('grpTest'); grp.setHidden(true);

			// "Export"
			var grp = zen('grpExport'); grp.setHidden(true);

			// "Document"
			var grp = zen('grpDocument'); grp.setHidden(true);

			// "New"
			var grp = zen('grpNew'); grp.setHidden(!this.canEdit);

			// "Open"
			var grp = zen('grpOpen'); grp.setHidden(false);

			// "Delete" does not apply
			var grp = zen('grpDelete'); grp.setHidden(true);

			// "Copy" does not apply
			var grp = zen('grpCopy'); grp.setHidden(true);
			
			// "Change Class" does not apply
			var grp = zen('grpChangeClass'); grp.setHidden(true);

		}
		else {
			// Item actions
			if (!host.isMissingClass) {
				var grp = zen('grpTest'); grp.setHidden(true);

				// "Export"
				var grp = zen('grpExport'); grp.setHidden(true);

				// "Copy"
				var grp = zen('grpCopy'); grp.setHidden(true);
			}
			else {
				// "Test" does not apply if class is missing
				var grp = zen('grpTest'); grp.setHidden(true);

				// "Export" does not apply if class is missing
				var grp = zen('grpExport'); grp.setHidden(true);

				// "Copy"
				var grp = zen('grpCopy'); grp.setHidden(true);
			}

			// "Document" does not apply
			var grp = zen('grpDocument'); grp.setHidden(true);

			// "New" is not available in this context
			var grp = zen('grpNew'); grp.setHidden(true);

			// "Open" is not available in this context
			var grp = zen('grpOpen'); grp.setHidden(true);

			// "Delete"
			var grp = zen('grpDelete'); grp.setHidden(!this.canEdit);


			// "Change Class"
			var grp = zen('grpChangeClass'); grp.setHidden(true);
			hostHelper = new Object();
			hostHelper.name = host.name;
			hostHelper.id = host.id;
			hostHelper.classname = host.classname;
			hostHelper.hostType = host.hostType;
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in updateActions');
	}
}

/// Delete current config item.
ClientMethod deleteItem() [ Language = javascript ]
{
	if (!this.checkHelper('ITKWrite')) {
		return false;
	}

	var host = this.getCurrHost();
	if (!host || host.id < 0) return false;
	if (!host.type && (host.hostType == 'service' || host.hostType == 'busserv')) host.type = 'busserv';
	var confirmMsg;
	switch(host.type) {
		case 'system':


			if (!confirmMsg) confirmMsg = 'Deleting a System will delete any related Senders, Consumers, Subscriptions and Distribution Rules.  \n\nAre you sure you wish to delete this System?';
		case 'consumerSystem':
			if (!confirmMsg) confirmMsg = 'Deleting a Consumer will delete any related Subscriptions and Distribution Rules.  \n\nAre you sure you wish to delete this Consumer?';
		case 'senderSystem':
			if (!confirmMsg) confirmMsg = 'Deleting a Sender will delete any related Subscriptions.  \n\nAre you sure you wish to delete this Sender?';
		case 'busserv':
			if (!confirmMsg) confirmMsg = 'Deleting a Listener will delete any related Senders and Subscriptions. \n\nDo you wish to delete this item?';
			if (confirm(confirmMsg)) {
				zenPage.stopTimers();
				var ok = this.DeleteRegistryItem(host.type, host.id);



				zenPage.startTimers(50);
			}
			break;

	}

	if (ok !== undefined) {
		if (ok != '') {
			alert(ok);
		}
		else {
			this.selectItem(-1,true);
			this.updateView();
		}
		return true;
	}
	
	return false;
}

Method ReconcileSwitchboard() As %String [ ZenMethod ]
{
	Set tSC = ##class(EnsLib.ITK.UI.Reconcile).ReconcileProduction(%page.productionId)
	Quit:$$$ISERR(tSC) $ZCVT($$$StatusDisplayString(tSC),"O","JS")
	Quit ""
}

Method DeleteRegistryItem(pType As %String, pId As %String) As %String [ ZenMethod ]
{
	Set tSC = $$$OK
	If pType = "system" {
		TSTART
		// Delete the senderSystem
		try {
			Set tMsg = ..DeleteRegistryItem("senderSystem",pId)
			Quit:tMsg'=""
			// Delete the consumerSystem
			
			Set tMsg = ..DeleteRegistryItem("consumerSystem",pId)
			Quit:tMsg'=""
			
			// Now delete the system definition
			Set tSC = ##class(EnsLib.ITK.Setup.SystemDefinition).%DeleteId(pId)
		} catch (ex) {
			Set tSC = ex.AsStatus()
		}
		
		If (tMsg'="") Set tSC = $$$ERROR($$$GeneralError,tMsg)
		If $$$ISERR(tSC) {
			TROLLBACK
		} Else {
			TCOMMIT
		}

	} elseif pType = "consumerSystem" {
		try {
			NEW SQLCODE
			// Start a transaction
			TSTART
			// Delete all subscriptions to this consumer
			&sql(DELETE FROM EnsLib_ITK_Setup.SubscriptionRules
				WHERE Subscriber = :pId)
			
			If (SQLCODE < 0) {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
				Quit
			}

			// Delete all distribution rules going to this consumer
			&sql(DELETE FROM EnsLib_ITK_Setup.DistributionRules 
				WHERE TargetComponent = :pId)
			
			If (SQLCODE < 0) {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
				Quit
			}

			// Delete all consumer registry items for this pId
			&sql(DELETE FROM EnsLib_ITK_Setup.ConsumerServiceRegistry 
				WHERE ConsumerName = :pId)
			
			If (SQLCODE < 0) {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
				Quit
			}
			
			// Remove the business operation from the production
			// We have the operation name, so need to find the item Id
			Set tProd = ##class(Ens.Config.Production).%OpenId(%page.productionId)
			Set tBusOp = tProd.FindItemByConfigName(%page.productionId_"||"_pId_"|EnsLib.ITK.Framework.Operation.SOAPOperation")
			If $IsObject(tBusOp) {
				Set tMsg = ..DeleteConfigItem(%page.productionId, tBusOp.%Id())
				If tMsg '= "" {
					TRollback
					Set tSC = $$$ERROR($$$GeneralError,tMsg)
					Quit
				}
			}
			
			// Commit
			TCommit
		} Catch (ex) {
			// rollback
			TRollback
			Set tSC = ex.AsStatus()
		}
		


				
	}  elseif pType = "senderSystem" {
		try {
			NEW SQLCODE
			// Start a transaction
			TSTART
			// Delete all senders for this system
			&sql(DELETE FROM EnsLib_ITK_Setup.SenderRegistry
				WHERE SourceAppName = :pId)
			
			If (SQLCODE < 0) {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
				Quit
			}
			
			// Delete all subscriptions for this sender system
			&sql(DELETE FROM EnsLib_ITK_Setup.SubscriptionRules
				WHERE SourceApplication = :pId)
					
			If (SQLCODE < 0) {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
				Quit
			}
			
			// Commit
			TCommit
		} Catch (ex) {
			// rollback
			TRollback
			Set tSC = ex.AsStatus()
		}
		
		
	}  elseif pType = "busserv" {
		try {
			NEW SQLCODE
			// Start a transaction
			TSTART
			// Delete senders connected to this listener
			Set tItem = ##class(Ens.Config.Item).%OpenId(pId)
			Set tName = tItem.Name
			Kill tItem
			&sql(DELETE FROM EnsLib_ITK_Setup.SenderRegistry
				WHERE BusinessServiceName = :tName)
			
			If (SQLCODE < 0) {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
				Quit
			}
			
			// Now delete any subscriptions for which there are no
			// senders
			&sql(DELETE FROM EnsLib_ITK_Setup.SubscriptionRules subs
				WHERE NOT EXISTS (
					SELECT 1 FROM EnsLib_ITK_Setup.SenderRegistry sender
					WHERE sender.SourceAppName = subs.SourceApplication
					AND sender.WebServiceName = subs.SourceService)
					)
					
			If (SQLCODE < 0) {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,$SYSTEM.SQL.SQLCODE(SQLCODE))
				Quit
			}
			
			// Delete the business service from the production
			Set tMsg = ..DeleteConfigItem(%page.productionId, pId)
			If tMsg '= "" {
				TRollback
				Set tSC = $$$ERROR($$$GeneralError,tMsg)
				Quit
			}
			// Commit
			TCommit
		} Catch (ex) {
			// rollback
			TRollback
			Set tSC = ex.AsStatus()
		}
	}
	
	Quit:$$$ISERR(tSC) $ZCVT($$$StatusDisplayString(tSC),"O","JS")
	Quit ""
}

ClassMethod UpdateProductionStatus(ByRef pStates As %ZEN.proxyObject) As %Integer [ ZenMethod ]
{
	Set pStates.needsReconcile = 0
	If pStates.productionId'="" {
		do ##class(EnsLib.ITK.UI.Production).GetITKMissingItems(pStates.productionId,.items)
		If (items.Count() > 0) Set pStates.needsReconcile = 1
	}
	
	Quit ##super(pStates)
}

/// Add a Reconcile button
/// Show or hide "Update" button and set its own color.
/// <var>show</var>=true indicates the button is to be shown, and false to be hidden.
ClientMethod showUpdateButton(show, states) [ Language = javascript ]
{
	var btn = document.getElementById('command_cmdReconcile');
	if (btn) {
		if (states.needsReconcile == 1) {
			btn.style.backgroundColor = 'red'; // was '#F08080'
			btn.style.color = 'yellow';
			btn.style.visibility = 'visible';
			btn.title = 'This ITK Switchboard needs to be reconciled due to configuration changes.'
		} else {
			btn.style.visibility = 'hidden';
		}
	}
	zenPage.invokeSuper('showUpdateButton',[show,states]);
}

/// The Production needs to be reconciled, this function will ensure the output is 
/// captured and reported to the user.
ClientMethod reconcileProduction() [ Language = javascript ]
{
	var parms = {
			$ID1: zenPage.productionId
			};
	zenPage.stopTimers();
	zenLaunchPopupWindow(zenLink('EnsLib.ITK.UI.Reconcile.zen'),this.addPopupSuffix('ReconcileProduction'),'status,scrollbars,resizable=yes,width=700,height=600', parms);
	zenPage.startTimers(2000);
}

ClientMethod newProduction() [ Language = javascript ]
{
	if (!this.checkHelper('ITKWrite')) {
		return false;
	}
	// Show Wizard dialog.
	var parms = {
			};
	zenLaunchPopupWindow(zenLink('EnsLib.ITK.Setup.UI.ProductionWizard.zen'),this.addPopupSuffix('NewProductionWizard'),'status,scrollbars,resizable=yes,width=900,height=600',parms);
}

/// Save settings for the given configuration item or general Production.
ClassMethod SaveSettingsToServer(pProductionId As %String, pHostId As %String, pCoreSettings As %ZEN.proxyObject, pHostSettings As %ZEN.proxyObject, pAdapterSettings As %ZEN.proxyObject, pMessages As %ZEN.proxyObject, pExpandoStates As %String) As %String [ ZenMethod ]
{
	New $$$EnsProdSettings
	Set tSC = $$$OK, tMsg = ""
	Try {

		// Detect a change to a consumerSystem and change the host id 
		// to that of the wrapped business operation
		If pExpandoStates["expConsumer=" {
			Set tCS = ##class(EnsLib.ITK.Setup.UI.Consumer).OpenWithHost(pHostId, pProductionId)
			Set pHostId = tCS.BusHost.%Id()
		}
		
		$$$EnsProdSettingsSetModified(0)
		Set name = pMessages.name
		Set enabled = pMessages.enabled
		Set pMessages.message = ""
		Set pMessages.doUpdate = 0
		Set pMessages.newId = ""

		Do:$IsObject(pCoreSettings) pCoreSettings.%CopyToArray(.tCoreValues)
		Do:$IsObject(pHostSettings) pHostSettings.%CopyToArray(.tHostValues)
		Do:$IsObject(pAdapterSettings) pAdapterSettings.%CopyToArray(.tAdapterValues)

		Set tModifiedConfigItem = ""
		If ""=pHostId {
			Set tSC = $$$ERROR($$$EnsErrGeneral,"Unable to apply settings because configuration item not identified")
			Quit
		} ElseIf -1=pHostId {
			#; Do Production settings
			Set tAuditName = ""
			Merge tSettInfo = %session.Data("ProdConf_Settings") // v(Name) = $LB(Target, Value, ValueSource, DefaultValue, DefaultSource)
			Merge tSettReset = %session.Data("ProdConf_Settings_Reset",1) // Settings that were selected to be reset

			Set tProd = ##class(Ens.Config.Production).%OpenId(pProductionId,,.tSC)
			If '$IsObject(tProd) || $$$ISERR(tSC) {
				Set tSC = $$$ERROR($$$EnsErrGeneral,"Unable to apply settings because configuration for Production '"_pProductionId_"' could not be opened:"_$$$StatusDisplayString(tSC))
				Quit
			}
			Set $$$EnsProdSettingsProperty("prod") = tProd
			#; First apply Production Core properties
			Set tProp=""  For { Set tProp = $O(tCoreValues(tProp),1,tValue)  Quit:(tProp = "")
				Try { // Not all values are actual properties
					If tValue'="" { // don't validate empty-string values
						Set tSC = $classmethod("Ens.Config.Production", tProp_"IsValid", tValue)
						If $$$ISERR(tSC) {
							Set pMessages.error = "settCore"_tProp, tTarget="Core"
							Quit
						}
					}
					If ($property(tProd, tProp) '= tValue) {
						Set $property(tProd, tProp) = tValue
						$$$EnsProdSettingsSetModified(1)
					}
				} Catch {
					Set tSC = $$$SystemError
				}
				Set tActions(tProp)=">>"_tValue_$S($$$ISERR(tSC):"(ERROR)",1:"")
				Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC)

			#; Now apply the dynamic setting values.
			$$$ASSERT(pProductionId=tProd.Name)
			Set tName=""  For { Set tName = $O(tHostValues(tName),1,tValue)  Quit:(tName = "")
				If pProductionId'="" && (tValue'="") { // don't validate empty-string values
					Set tSC = $classmethod(pProductionId, tName_"IsValid", tValue)
					If $$$ISERR(tSC) {
						Set pMessages.error = "sett"_tName, tTarget = ""
						Quit
					}
				}
				If $D(tSettReset(tName)) && (tValue=$LG(tSettInfo(tName),4)) {
					Set isReset = 1 // User selected to reset to default and current value still matches the default
				} Else {
					Set isReset = 0
				}
				Kill tSettReset(tName)
				Set tSetting = tProd.FindSettingByName(tName) 
				If $IsObject(tSetting) {
					If 'isReset {
						If (tSetting.Value '= tValue) {
							Set tSetting.Value = tValue
							$$$EnsProdSettingsSetModified(1)
						}
					} Else {
						// Remove this setting because it is being reset, will acquire the default
						Set tSC = ..RemoveSettingByName(tProd, tName, "")
					}
				} Else {
					If 'isReset {
						Set tSetting = ##class(Ens.Config.Setting).%New()
						Set tSetting.Name = tName
						Set tSetting.Value = tValue
						Do tProd.Settings.Insert(tSetting)
						$$$EnsProdSettingsSetModified(1)
					}
				}
				Set tActions(tName) = ">>"_tValue_$S(isReset:"(RESET)",1:"")_$S($$$ISERR(tSC):"(ERROR)",1:"")
			}
			Quit:$$$ISERR(tSC)
			Set tName=""  For { Set tName = $O(tSettReset(tName))  Quit:tName=""
				Set tSC = ..RemoveSettingByName(tProd, tName, "")
				Set tActions(tName_" RESET") = ""
				Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC)
			Set tSC = tProd.%Save()  Quit:$$$ISERR(tSC)

		} Else {
			#; Do Item settings
			Set tAuditName = name
			Merge tSettings("Host") = tHostValues
			Merge tSettings("Adapter") = tAdapterValues
			Merge tSettInfo = %session.Data("ProdConf_Settings") // v(Name) = $LB(Target, Value, ValueSource, DefaultValue, DefaultSource)
			Merge tSettReset = %session.Data("ProdConf_Settings_Reset",1) // Settings that were selected to be reset
			Kill tHostValues, tAdapterValues

			If '$system.Security.Check("%Ens_ProductionConfig","WRITE") {
				// Check only enabled/disabled has been changed
				If $data(tSettings) {
					Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation)
					Quit
				}
				Set k="" For { Set k = $O(tCoreValues(k))  Quit:""=k
					Continue:k="Enabled"
					// Other setting has been changed
					Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation)
					Quit
				}
				Quit:$$$ISERR(tSC)
			}
			Set tItem = ##class(Ens.Config.Item).%OpenId(pHostId,,.tSC)
			If '$IsObject(tItem) || $$$ISERR(tSC) {
				// Check if the item has acquired a new ID due to changes by another user or application
				Set tFullName=pProductionId_"||"_name_"|"_pMessages.commentOrClassname
				Set tItem=##class(Ens.Config.Production).OpenItemByConfigName(tFullName,.tSC2)
				Set:$$$ISERR(tSC2)||'$IsObject(tItem) tSC2 = $$$ERROR($$$EnsErrGeneral,"Also unable to open item by name '"_tFullName_"' :"_$$$StatusDisplayString(tSC2))
				If $$$ISOK(tSC2) {
					Set tSC = $$$OK
				} Else {
					Set tSC = $$$ERROR($$$EnsErrGeneral,"Unable to apply settings because configuration item id '"_pHostId_"' could not be opened: "_$$$StatusDisplayString(tSC))
					Set tSC = $$$ADDSC(tSC,tSC2)
					Quit
				}
				Set:pHostId'=tItem.%Id() pMessages.newId = tItem.%Id()
			}
			Set tProd = tItem.Production
			Set $$$EnsProdSettingsProperty("prod") = tProd

			#; First apply item Core properties
			Set tWasEnabled = tItem.Enabled
			Set tProp=""  For { Set tProp = $O(tCoreValues(tProp),1,tValue)  Quit:(tProp = "")
				Try { // Not all values are actual properties
					If tValue'="" { // don't validate empty-string values
						Set tSC = $classmethod("Ens.Config.Item", tProp_"IsValid", tValue)
						If $$$ISERR(tSC) {
							Set pMessages.error = "settCore"_tProp, tTarget="Core"
							Quit
						}
					}
					If $property(tItem, tProp) '= tValue {
						Set $property(tItem, tProp) = tValue
						$$$EnsProdSettingsSetModified(1)
						Set $$$EnsProdSettingsOref(tItem) = 1
					}
					Set:"Enabled"=tProp&&'tValue pMessages.doUpdate = 1 ; special case for disabling
				} Catch {
					Set tSC = $$$SystemError
				}
				Set tActions(tProp)=">>"_tValue_$S($$$ISERR(tSC):"(ERROR)",1:"")
				Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC)

			#; Now apply the dynamic setting values. 
			For tTarget = "Host","Adapter" {
				Set tSrcClass = $select(tTarget = "Host" : tItem.ClassName, tTarget = "Adapter" : tItem.AdapterClassName(), 1:"")
				Set tName=""  For { Set tName = $O(tSettings(tTarget,tName),1,tValue)  Quit:(tName = "")
					If tSrcClass'="" && (tValue'="") { // don't validate empty-string values
						Set tSC = $classmethod(tSrcClass, tName_"IsValid", tValue)
						If $$$ISERR(tSC) {
							Set pMessages.error = "sett"_tTarget_tName
							Quit
						}
					}
					If $D(tSettReset(tName)) && (tValue=$LG(tSettInfo(tName),4)) {
						Set isReset = 1 // User selected to reset to default and current value still matches the default
					} Else {
						Set isReset = 0
					}
					Kill tSettReset(tName)
					Set tSetting = tItem.FindSettingByName(tName, tTarget)
					If $IsObject(tSetting) {
						If 'isReset {
							If (tSetting.Value '= tValue) {
								Set tSetting.Value = tValue
								$$$EnsProdSettingsSetModified(1)
								Set $$$EnsProdSettingsOref(tSetting) = 1
							}
						} Else {
							// Remove this setting because it is being reset, will acquire the default
							Set tSC = ..RemoveSettingByName(tItem, tName, tTarget)
						}
					} Else {
						If 'isReset {
							Set tSetting = ##class(Ens.Config.Setting).%New()
							Set tSetting.Name = tName
							Set tSetting.Target = tTarget
							Set tSetting.Value = tValue
							Do tItem.Settings.Insert(tSetting)
							$$$EnsProdSettingsSetModified(1)
							Set $$$EnsProdSettingsOref(tSetting) = 1
						}
					}
					Set tActions(tName) = ">>"_tValue_$S(isReset:"(RESET)",1:"")_$S($$$ISERR(tSC):"(ERROR)",1:"")
				}
				Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC)

			#; Remove settings from the item if they are in the Reset list
			Set tName=""  For { Set tName = $O(tSettReset(tName))  Quit:tName=""
				Set tSC = ..RemoveSettingByName(tItem, tName, "")
				Set tActions(tName_" RESET") = ""
				Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC)

			#; Save the item
			Set tSC = tItem.%Save()  Quit:$$$ISERR(tSC)
			Set tModifiedConfigItem = tItem

			#; If we enabled this one, disable any same-name peers
			If tItem.Enabled && 'tWasEnabled {
				#; Scan list of all matching enabled production items, and select the first we find that's a perfect match
				Set pMessages.commentOrClassname = $S(tItem.Comment'="":tItem.Comment, 1:tItem.ClassName) // Update this property as it may have just been changed
				Set tFoundItem=tProd.findItemByName(name,pMessages.commentOrClassname,.tSC,.tEnabledItems)  Quit:$$$ISERR(tSC)
				$$$ASSERT((tFoundItem=tItem) && (tFoundItem.Enabled=1))
				For i=1:1:tEnabledItems {
					If tEnabledItems(i)'=tFoundItem {
						Set tEnabledItems(i).Enabled=0
						Set tSC=tEnabledItems(i).%Save()
						Set tSC3 = $$$AuditModifyProductionConfig(pProductionId,name,"Item disabled because another item with the same name was enabled")
						Quit:$$$ISERR(tSC)
					}
				}
				Quit:$$$ISERR(tSC)
			}
		}
		If $$$EnsProdSettingsModified Do ##class(Ens.Config.Production).SetModified(tProd.Name)
		Set tSC = tProd.SaveToClass(tModifiedConfigItem)  Quit:$$$ISERR(tSC)
		Set tSC = ##class(Ens.Director).GetProductionStatus(.tCurrentProduction, .tCurrentStatus)
		If $$$ISERR(tSC) {
			$$$LOGSTATUS(tSC)
			Quit
		}
		If (tCurrentProduction = tProd.Name) && (tCurrentStatus = $$$eProductionStateRunning) && $S(-1=pHostId:1,1:tItem.Enabled) {
			Set pMessages.doUpdate = 1
		} ElseIf tCurrentStatus'=$$$eProductionStateRunning {
			Set pMessages.doUpdate = 0
		}
		Do ..StoreExpandoStates($S(-1=pHostId:"$Production",1:tItem.Name),pExpandoStates)
	} Catch {
		Set tSC = $$$SystemError
	}
	If $$$ISOK(tSC) {
		Do ..KillModifiedSettings()
	} Else {
		If $IsObject($get(pMessages)) && (pMessages.error '= "") {
			Set tMsg = $$$FormatText($$$Text("Invalid value for %1 setting '%2'"),tTarget,$E(pMessages.error,4+$L(tTarget)+1,*))_$c(13,10)
		}
		Set tMsg = tMsg _ $$$StatusDisplayString(tSC)
	}
	Set tSC2 = $$$AuditModifyProductionConfig(pProductionId,$G(tAuditName),.tActions)

	Quit tMsg
}

ClientMethod showLegend() [ Language = javascript ]
{
	zenLaunchPopupWindow(zenLink('EnsLib.ITK.Setup.UI.ProductionConfigurationLegend.zen'),'','status=no,scrollbars=no,resizable=no,width=728,height=638,left=400');
}

/// User double-clicked on an item.
ClientMethod itemDblClick(evt, itemNo) [ Language = javascript ]
{
	var type = zenPage.GetIndexType(itemNo)
	switch (type) {
		case "system":
		case "senderSystem":
			// Doesn't make sense to enable or disable, so perform a no-op
			break;
		case "consumerSystem":
			// Check that it is backed by a business op
			var host = this.getHost(itemNo);
			if (!host.BusHost) break;
		default:
			this.invokeSuper('itemDblClick',[evt,itemNo]);
	}
}

/// Status indicators auto-refresh timer handler.
ClientMethod refreshStatusHandler() [ Language = javascript ]
{
	if (!zenPage || (zenPage.productionId=='') || (!zenPage.enableAutoRefresh)) {
		return;
	}

	var allChanges = zenPage.GetChangedStatuses(zenPage.productionId);
	if (allChanges!==null) {
		var whatChanged = allChanges.split("#")

		if (whatChanged[0]=='1') {
			zenPage.refreshDiagramHeaderStates(); // Production status has changed, redraw the diagram header
		}
		if (whatChanged.length > 1) {
			var changed = whatChanged[1]; // list of item status changes
			if (changed != '') {
				var toUpdate = changed.split(";")
				for (var i=0; i < toUpdate.length; i++) {
					// update hostObj and diagram status indicator
					var done = false;
					var s = toUpdate[i].split(",");
					for (var lane = 0; lane < 3; lane++) {
						for (var n = 0; n < hostObj[lane].length; n++) {
							if (hostObj[lane][n].id == s[0] || (hostObj[lane][n].BusHost && hostObj[lane][n].BusHostId == s[0])) {
								hostObj[lane][n].status = s[1];
								hostObj[lane][n].connectStatus = s[2];
								zenPage.updateDotColor(hostObj[lane][n]._dot,hostObj[lane][n]);
								done = true;
								break;
							}
						}
						if (done) break;
					}
				}
			}
		}
	}
	zen('statusTimer').setProperty('timeout',5100); // 5.1 seconds status refresh interval
	zen('statusTimer').startTimer(); // set next check
	zenPage.refreshRate = 5.1;
}

Method %OnAfterCreatePage() As %Status
{
	// We can assume that the user has %Ens_ProductionConfig:READ by dint of us getting this far
	If '$system.Security.Check("%Ens_ITK","READ") {
		Set %response.Status = "403 Forbidden"
		Quit $$$ERROR($$$AccessDenied)
	}
	Quit ##super()
}

/// Also include ITK resources in security helper
ClassMethod GetSecurityHelper() As %ZEN.proxyObject [ ZenMethod ]
{
	Set tSecurityHelper = ##super()
	If $IsObject(tSecurityHelper) {
		Set tSecurityHelper.ITKWrite = $system.Security.Check("%Ens_ITK","WRITE")
	}
	Quit tSecurityHelper
}

}

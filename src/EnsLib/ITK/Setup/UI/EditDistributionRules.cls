/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.EditDistributionRules Extends EnsLib.ITK.Setup.UI.EditMasterDetail [ System = 4 ]
{

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter PAGENAME = "Edit Distribution Rules";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

Property ConsumerName As %String(ZENURL = "CONSUMERNAME");

Property ModelClass As %String [ InitialExpression = "EnsLib.ITK.Setup.UI.DistributionRuleModel" ];

XData Style
{
}

XData masterPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="mpane">
<tablePane id="masterTable" dataSource="query" initialExecute="true" onselectrow="zenPage.rowSelected(zenThis)" valueColumn="ID"
	tableName="EnsLib_ITK_Setup.DistributionRules" whereClause="TargetComponent = ?" 
	fixedHeaders="true" showZebra="true" enclosingStyle="height:400px; overflow-y: auto; overflow-x: hidden">
	<parameter value="#(%page.ConsumerName)#"/>
	<column colName="ID" hidden="true"/>
	<column colName="TargetComponent" hidden="true"/>
	<column colName="ServiceName" header="Service Name"/>
	<column colName="DistributionMode" header="Distribution Mode"/>
	<column colName="LogicalAddress" header="Logical Address"/>
</tablePane>
</pane>
}

XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
 <dataCombo id="serviceCombo" label="Web Service" dataBinding="ServiceName" required="true" size="38"
  sql="SELECT ServiceName FROM EnsLib_ITK_Setup.ConsumerServiceRegistry WHERE ConsumerName = ?">
 <parameter value="#(%page.ConsumerName)#"/>
 </dataCombo>
 <radioSet id="distModeRadio" required="true" dataBinding="DistributionMode" valueList="Authoritative,Non-Authoritative" label="Distribution Mode"/>
 <text id="logicalAddressTxt" label="Logical Address" required="true" dataBinding="LogicalAddress" maxlength="250" size="40"/>
</pane>
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit "Define the distribution rules for the target consumer "_..ConsumerName
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit "Edit Distribution Rules"
}

ClientMethod rowSelected(selected) [ Language = javascript ]
{
  var id = zenPage.invokeSuper('rowSelected', [selected]);
  var serviceCombo = zenPage.getComponentById('serviceCombo');	  
  serviceCombo.setProperty('disabled',(id!='0'));
}

/// insert a new row into the model ready for editing
ClientMethod resetModel() [ Language = javascript ]
{
  zenPage.invokeSuper('resetModel');
  var controller = zenPage.getComponentById('modelData');
  zen('distModeRadio').setValue('Authoritative');
  controller.setDataByName('TargetComponent', zenPage.ConsumerName);
  controller.setDataByName('DistributionMode','Authoritative');
}

}

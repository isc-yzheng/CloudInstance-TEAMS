/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.EditConsumers Extends EnsLib.ITK.Setup.UI.EditMasterDetail [ System = 4 ]
{

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter PAGENAME = "Edit Consumer Registry";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

Property ConsumerName As %String(ZENURL = "CONSUMERNAME");

Property ModelClass As %String [ InitialExpression = "EnsLib.ITK.Setup.UI.ConsumerModel" ];

XData Style
{
<style type="text/css"> 
</style>
}

XData masterPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="mpane">
<tablePane id="masterTable" dataSource="query" initialExecute="true" onselectrow="zenPage.rowSelected(true)" valueColumn="ID"
	tableName="EnsLib_ITK_Setup.ConsumerServiceRegistry" whereClause="ConsumerName = ?" 
	showZebra="true">
	<parameter value="#(%page.ConsumerName)#"/>
	<column colName="ID" hidden="true"/>
	<column colName="ConsumerName" hidden="true"/>
	<column colName="ServiceName" header="Service Name"/>
	<column colName="InvocationPattern" header="Invocation Pattern"/>
	<column colName="PartialLogicalEndpoint" header="Partial Logical Endpoint"/>
	<column colName="PartialPhysicalEndpoint" header="Partial Physical Endpoint"/>
</tablePane>
</pane>
}

XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
 <dataCombo id="serviceCombo" label="Web Service" dataBinding="ServiceName" size="38" required="true"
  sql="SELECT ServiceName FROM EnsLib_ITK_Setup.ServiceDefinition WHERE ServiceName NOT IN (SELECT ServiceName FROM EnsLib_ITK_Setup.ConsumerServiceRegistry WHERE ConsumerName = ? ) ORDER BY ServiceName">
 <parameter value="#(%page.ConsumerName)#"/>
 </dataCombo>
 <radioSet id="invocationRadio" required="true" dataBinding="InvocationPattern" valueList="Asynchronous,Synchronous" label="Invocation Pattern"/>
 <text id="logicalEndpointTxt" label="Partial Logical Endpoint" dataBinding="PartialLogicalEndpoint" maxlength="250" size="40" required="true"/>
 <text id="physicalEndpointTxt" label="Partial Physical Endpoint" dataBinding="PartialPhysicalEndpoint" maxlength="250" size="40"/>
 <spacer width="5"/>
</pane>
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit "Define the services that the "_..ConsumerName_" system can consumer from the ITK switchboard"
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit "Edit Consumer Registry"
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
  zen('invocationRadio').setValue('Asynchronous');
  controller.setDataByName('ConsumerName', zenPage.ConsumerName);
  controller.setDataByName('InvocationPattern','Asynchronous');
}

}

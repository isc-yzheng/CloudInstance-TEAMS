/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.EditSenders Extends EnsLib.ITK.Setup.UI.EditMasterDetail [ System = 4 ]
{

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter PAGENAME = "Edit Sender Registry";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 0;

Property ItemNo As %String(ZENURL = "itemNo");

Property System As %String;

Property Listener As %String;

Property ModelClass As %String [ InitialExpression = "EnsLib.ITK.Setup.UI.SenderModel" ];

XData Style
{
}

XData masterPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="mpane">
<tablePane id="masterTable" dataSource="query" initialExecute="true" onselectrow="zenPage.rowSelected(true)" valueColumn="ID"
	tableName="EnsLib_ITK_Setup.SenderRegistry" whereClause="SourceAppName = ? AND BusinessServiceName = ?" 
	fixedHeaders="true" showZebra="true" enclosingStyle="height:400px; overflow-y: auto; overflow-x: hidden">
	<parameter value="#(%page.System)#"/>
	<parameter value="#(%page.Listener)#"/>
	<column colName="ID" hidden="true"/>
	<column colName="SourceAppName" hidden="true"/>
	<column colName="BusinessServiceName" hidden="true"/>
	<column colName="WebServiceName"/>
	<column colName="InvocationPattern"/>
	<column colName="ValidatePayload"/>
</tablePane>
</pane>
}

XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
 <dataCombo id="serviceCombo" label="Web Service" dataBinding="WebServiceName" required="true" size="38"
  sql="SELECT ServiceName FROM EnsLib_ITK_Setup.ServiceDefinition WHERE ServiceName NOT IN (SELECT WebServiceName FROM EnsLib_ITK_Setup.SenderRegistry WHERE SourceAppName = ? AND BusinessServiceName = ?) ORDER BY ServiceName">
 <parameter value="#(%page.System)#"/>
 <parameter value="#(%page.Listener)#"/>
 </dataCombo>
 <radioSet id="invocationRadio" dataBinding="InvocationPattern" valueList="Asynchronous,Synchronous,Derived" label="Invocation Pattern" required="true"/>
 <checkbox dataBinding="ValidatePayload" label="Validate Payload?"/>
</pane>
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit "Define the services that the "_..System_" system can send to the "_..Listener_" listener"
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit "Edit Sender Registry"
}

Method %OnAfterCreatePage() As %Status
{
	Set ..System = $P(..ItemNo,"|",1)
	Set ..Listener = $P(..ItemNo,"|",2)
	Quit ##super()
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
  controller.setDataByName('SourceAppName', zenPage.System);
  controller.setDataByName('BusinessServiceName', zenPage.Listener);
  controller.setDataByName('InvocationPattern','Asynchronous');
}

}

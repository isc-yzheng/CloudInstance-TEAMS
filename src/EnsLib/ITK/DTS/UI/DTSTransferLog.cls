/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Created using the page template: Title Page
Class EnsLib.ITK.DTS.UI.DTSTransferLog Extends EnsPortal.Template.standardPage [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:READ";

/// Class name of application this page belongs to.
Parameter APPLICATION;

/// Displayed name of this page.
Parameter PAGENAME = "DTS Transfer Log";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title bar */
#title {
	background: #C5D6D6;
	color: black;
	font-family: Verdana;
	font-size: 1.5em;
	font-weight: bold;
	padding: 5px;
	border-bottom: 1px solid black;
	text-align: center;
}
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<html id="title">DTS Transfer Log</html>
<vgroup>
<spacer height="70"/>
<tableNavigatorBar tablePaneId="table" 
	showPageSize="true"
	showFilter="false" width="550"/>
<spacer height="30"/>
<tablePane id="table" 
tableName="EnsLib_ITK_DTS_Framework.TransferLog"
width="1500" 
bodyHeight="485"
pageSize="20" 
showZebra="true" 
useSnapshot="true" 
dataSource="columns">
<column colName="FileName" width="27%" cellTitle="File Name" />
<column colName="WorkflowId" width="15%" cellTitle="WorkFlow"/>
<column colName="DTSId" width="27%"  cellTitle="DTS ID"/>
<column colName="Sender" width="6%" cellTitle="Sender"/>
<column colName="Destination" width="6%" cellTitle="Destination"/>
<column colName="Result_DateTime" width="11%" cellTitle="DateTime"/>
<column colName="Result_Status" width="8%" cellTitle="Status"/>
</tablePane>
</vgroup>
</page>
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This is a master of all Applications and Devices that connect to ITK.
Class EnsLib.ITK.Setup.SystemDefinition Extends (%Persistent, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: This is a master of all Applications and Devices that connect to ITK.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property ApplicationName As %String [ Required ];

Property ApplicationRouter As %String;

Index U1 On ApplicationName [ IdKey, Unique ];

Query GetSenderSystems() As %SQLQuery(CONTAINID = 1)
{
	SELECT DISTINCT %ID FROM EnsLib_ITK_Setup.SystemDefinition a
	WHERE EXISTS (SELECT 1 FROM EnsLib_ITK_Setup.SenderRegistry b WHERE b.SourceAppName = a.ApplicationName)
}

Storage Default
{
<Data name="SystemDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeploymentName</Value>
</Value>
<Value name="3">
<Value>ApplicationNames</Value>
</Value>
<Value name="4">
<Value>ApplicationName</Value>
</Value>
<Value name="5">
<Value>ApplicationRouter</Value>
</Value>
</Data>
<DataLocation>^EnsITK.SystemDefinitionD</DataLocation>
<DefaultData>SystemDefinitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsITK.SystemDefinitionD</IdLocation>
<IndexLocation>^EnsITK.SystemDefinitionI</IndexLocation>
<StreamLocation>^EnsITK.SystemDefinitionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

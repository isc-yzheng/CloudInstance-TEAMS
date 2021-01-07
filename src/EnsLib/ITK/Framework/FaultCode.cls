/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Stores Fault Codes as defined in ITK Vocabulary.
Class EnsLib.ITK.Framework.FaultCode Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Stores Fault Codes as defined in ITK Vocabulary.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property FaultCode As %String [ Required ];

Property FaultText As %String [ Required ];

Relationship CodeSystem As EnsLib.ITK.Framework.FaultVocabulary [ Cardinality = parent, Inverse = VocabularyRef ];

Index KeyIndex On FaultCode [ IdKey, Unique ];

Storage Default
{
<Data name="FaultCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CodeSystem</Value>
</Value>
<Value name="3">
<Value>FaultCode</Value>
</Value>
<Value name="4">
<Value>FaultText</Value>
</Value>
</Data>
<DataLocation>^EnsITK.FaultCodeD</DataLocation>
<DefaultData>FaultCodeDefaultData</DefaultData>
<IdLocation>^EnsITK.FaultCodeD</IdLocation>
<IndexLocation>^EnsITK.FaultCodeI</IndexLocation>
<StreamLocation>^EnsITK.FaultCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

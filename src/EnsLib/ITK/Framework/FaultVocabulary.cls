/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Master of all ITK Fault Vocabulary Codes.
Class EnsLib.ITK.Framework.FaultVocabulary Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Master of all ITK Fault Vocabulary Codes.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property VocabularyOID As %String;

Relationship VocabularyRef As EnsLib.ITK.Framework.FaultCode [ Cardinality = children, Inverse = CodeSystem ];

Index IDIdx On VocabularyOID [ IdKey, Unique ];

Storage Default
{
<Data name="FaultVocabularyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VocabularyOID</Value>
</Value>
</Data>
<DataLocation>^EnsITK.FaultVocabularyD</DataLocation>
<DefaultData>FaultVocabularyDefaultData</DefaultData>
<IdLocation>^EnsITK.FaultVocabularyD</IdLocation>
<IndexLocation>^EnsITK.FaultVocabularyI</IndexLocation>
<StreamLocation>^EnsITK.FaultVocabularyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

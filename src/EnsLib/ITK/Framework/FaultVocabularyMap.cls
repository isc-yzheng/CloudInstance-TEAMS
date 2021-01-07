/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A map of IRIS error codes to ITK Fault codes.
Class EnsLib.ITK.Framework.FaultVocabularyMap Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: A map of IRIS error codes to ITK Fault codes.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property ITKFaultCode As %String [ Required ];

Property VocabularyId As %String [ Required ];

Property VocabularyCode As %String [ Required ];

Index UniqueIndex On (ITKFaultCode, VocabularyId) [ IdKey, Unique ];

Storage Default
{
<Data name="FaultVocabularyMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ITKFaultCode</Value>
</Value>
<Value name="3">
<Value>VocabularyCode</Value>
</Value>
</Data>
<DataLocation>^EnsITK.FaultVocabularyMapD</DataLocation>
<DefaultData>FaultVocabularyMapDefaultData</DefaultData>
<IdLocation>^EnsITK.FaultVocabularyMapD</IdLocation>
<IndexLocation>^EnsITK.FaultVocabularyMapI</IndexLocation>
<StreamLocation>^EnsITK.FaultVocabularyMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

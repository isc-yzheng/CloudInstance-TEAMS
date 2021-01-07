/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Defines a set of properties derived from Document objects of class 'EnsLib.HL7.Message'
/// that can be used in SQL to locate and join to messages of interest.
Class EnsLib.HL7.SearchTable Extends (%Persistent, Ens.VDoc.SearchTable) [ ClassType = persistent, CompileAfter = EnsLib.HL7.Message, Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS = "EnsLib.HL7.Message";

Parameter EXTENTSIZE = 4000000;

/* Re-declare indices because the superclass is abstract */
Index indexValue On (PropId, PropValue, DocId) [ IdKey, Unique ];

Index indexDocId On (DocId, PropId, PropValue) [ Unique ];

XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
<Items>
<Item DocType=""  PropName="MSHTypeName" Unselective="true">{1:9.1}_"_"_{1:9.2}</Item>
<Item DocType=""  PropName="MSHControlID" PropType='String:CaseSensitive' >{1:10}</Item>
<Item DocType=""  PropName="PatientID"   >[PID:2.1]</Item>
<Item DocType=""  PropName="PatientID"   >[PID:3().1]</Item>
<Item DocType=""  PropName="PatientID"   >[PID:4().1]</Item>
<Item DocType=""  PropName="PatientName" >[PID:5()]</Item>
<Item DocType=""  PropName="PatientAcct" >[PID:18.1]</Item>
</Items>
}

Storage Default
{
<Data name="SearchTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EnsLib.HL7.SearchTableD</DataLocation>
<DefaultData>SearchTableDefaultData</DefaultData>
<ExtentSize>4000000</ExtentSize>
<IdLocation>^EnsLib.HL7.SearchTableD</IdLocation>
<IndexLocation>^EnsLib.HL7.SearchTableI</IndexLocation>
<StreamLocation>^EnsLib.HL7.SearchTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

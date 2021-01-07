/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.EDI.ASTM.SearchTable Extends (%Persistent, Ens.VDoc.SearchTable) [ ClassType = persistent, CompileAfter = EnsLib.EDI.ASTM.Document, Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS = "EnsLib.EDI.ASTM.Document";

Parameter EXTENTSIZE = 4000000;

/* Re-declare indices because the superclass is abstract */
Index indexValue On (PropId, PropValue, DocId) [ IdKey, Unique ];

Index indexDocId On (DocId, PropId, PropValue) [ Unique ];

XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
<Items>
<Item DocType=""  PropName="Identifier" >Identifier</Item>
</Items>
}

Storage Default
{
<Data name="SearchTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EnsLib.EDI.ASTM.SearchTableD</DataLocation>
<DefaultData>SearchTableDefaultData</DefaultData>
<ExtentSize>4000000</ExtentSize>
<IdLocation>^EnsLib.EDI.ASTM.SearchTableD</IdLocation>
<IndexLocation>^EnsLib.EDI.ASTM.SearchTableI</IndexLocation>
<StreamLocation>^EnsLib.EDI.ASTM.SearchTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

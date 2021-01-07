Class HS.Types.IHE.XDSb.SerialClassification Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = "inputonly";

Property IID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property Code As %String(MAXLEN = "");

Property CodingScheme As %String(MAXLEN = "");

/// This property only has a value with a generic classification with no distinct storage slot (such as patientid or uniqueid)
Property ClassificationScheme As %String(MAXLEN = "");

Property Names As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Name", XMLPROJECTION = "ELEMENT");

/// Only defined with a generic classificiation with no distinct storage slot 
Property Descriptions As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Description", XMLPROJECTION = "ELEMENT");

/// Only defined with a generic classificiation with no distinct storage slot (such as patientid or uniqueid)
Property Slots As list Of HS.Types.IHE.XDSb.Slot(XMLNAME = "Slot", XMLPROJECTION = "ELEMENT");

/// Code, Scheme, Name
Method %OnNew(pCode = "", pScheme = "", pName = "") As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set i%Code=$G(pCode)
	Set i%CodingScheme=$G(pScheme)
	If pName]"" {
		Do ..Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(pName))
	}
	Quit $$$OK
}

ClassMethod Create(Code = "", Scheme = "", Description = "") As SerialClassification
{
	Quit ..%New(Code,Scheme,Description)
}

Storage Default
{
<Data name="SerialClassificationState">
<Value name="1">
<Value>IID</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CodingScheme</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
<Value name="5">
<Value>ClassificationScheme</Value>
</Value>
<Value name="6">
<Value>Slots</Value>
</Value>
<Value name="7">
<Value>Title</Value>
</Value>
<Value name="8">
<Value>Comments</Value>
</Value>
<Value name="9">
<Value>Names</Value>
</Value>
<Value name="10">
<Value>Descriptions</Value>
</Value>
</Data>
<State>SerialClassificationState</State>
<StreamLocation>^HS.Types.I3C1E.SerialClassE18CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

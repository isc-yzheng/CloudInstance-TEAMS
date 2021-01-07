/// Created from: C:\InterSystems\esignature.xsd
Class HS.AU.SMD.ApproverType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/cdaPackage/xsd/eSignature/2012";

Parameter XMLNAME = "ApproverType";

Parameter XMLSEQUENCE = 1;

Property PersonId As %xsd.anyURI(XMLNAME = "personId") [ Required ];

Property PersonName As HS.AU.SMD.PersonNameType(XMLNAME = "personName") [ Required ];

Storage Default
{
<Data name="ApproverTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonId</Value>
</Value>
<Value name="3">
<Value>PersonName</Value>
</Value>
</Data>
<Data name="ApproverTypeState">
<Value name="1">
<Value>PersonId</Value>
</Value>
<Value name="2">
<Value>PersonName</Value>
</Value>
</Data>
<DataLocation>^HS.AU.SMD.ApproverTypeD</DataLocation>
<DefaultData>ApproverTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.AU.SMD.ApproverTypeD</IdLocation>
<IndexLocation>^HS.AU.SMD.ApproverTypeI</IndexLocation>
<State>ApproverTypeState</State>
<StreamLocation>^HS.AU.SMD.ApproverTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

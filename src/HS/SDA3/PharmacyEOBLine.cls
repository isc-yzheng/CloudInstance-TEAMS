Class HS.SDA3.PharmacyEOBLine Extends (HS.SDA3.SuperClass, HS.SDA3.AbstractEOBLine)
{

Property Extension As HS.Local.SDA3.PharamacyEOBLineExtension;

/// NDC Code for a non-compound drug.
Property DrugCode As HS.SDA3.CodeTableDetail.DrugProduct;

/// The list of ingredients in the compound medication.
Property CompoundMedication As list Of HS.SDA3.CodeTableDetail.DrugProduct;

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>Extension</Value>
</Value>
<Value name="14">
<Value>DeniedReasonCode</Value>
</Value>
<Value name="15">
<Value>CompoundMedication</Value>
</Value>
<Value name="16">
<Value>LineCounter</Value>
</Value>
<Value name="17">
<Value>DrugCode</Value>
</Value>
<Value name="18">
<Value>InOutNetwork</Value>
</Value>
<Value name="19">
<Value>Quantity</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

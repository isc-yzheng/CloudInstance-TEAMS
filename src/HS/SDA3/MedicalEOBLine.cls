Class HS.SDA3.MedicalEOBLine Extends (HS.SDA3.SuperClass, HS.SDA3.AbstractEOBLine)
{

Property Extension As HS.Local.SDA3.MedicalEOBLineExtension;

/// Revenue or cost center code.
Property RevenueCode As HS.SDA3.CodeTableDetail.Revenue;

/// Medical procedure a patient received from a health care provider.
/// Coding methods include: CPT-4 and HCFA Common Procedure Coding System Level II - (HCPCSII).
Property ProcedureCode As HS.SDA3.CodeTableDetail.Procedure;

/// Modifier(s) for the procedure represented on this line.
/// Identifies special circumstances related to the performance of the service.
Property ProcedureModifiers As list Of HS.SDA3.CodeTableDetail.ProcedureModifier;

/// Allowed number of units.
Property AllowedUnits As HS.SDA3.Numeric;

/// Place of service or where product was supplied.
Property PlaceOfService As HS.SDA3.CodeTableDetail.PlaceOfService;

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
<Value>InOutNetwork</Value>
</Value>
<Value name="16">
<Value>LineCounter</Value>
</Value>
<Value name="17">
<Value>AllowedUnits</Value>
</Value>
<Value name="18">
<Value>PlaceOfService</Value>
</Value>
<Value name="19">
<Value>ProcedureCode</Value>
</Value>
<Value name="20">
<Value>ProcedureModifiers</Value>
</Value>
<Value name="21">
<Value>Quantity</Value>
</Value>
<Value name="22">
<Value>RevenueCode</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

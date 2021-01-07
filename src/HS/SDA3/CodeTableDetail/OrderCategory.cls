/// Before being processed into the Viewer Cache, if an OrderCategory has an<br>
/// SDACodingStandard that is not null and is not the Preferred Code System,<br>
/// then it will be set to null and a warning logged in the Event Log. See the<br>
/// HS documentation for more info on the Preferred Code System.<br><br>
/// OrderCategory is processed "in-line" in the Viewer Cache in<br>
/// web.SDA3.Order:UpdateOrder since it needs to know about its "parent" order<br>
/// type (LAB, RAD, MED, VXU, or OTH). In addition to Code, Description, and<br>
/// SDACodingStandard, OrderCategory is also matched on the parent order type,<br>
/// except the Viewer Cache doesn't support the same range of values for order<br>
/// type that SDA does. Order type is stored in the Viewer Cache in the<br>
/// ARCICOrderType property of ARCItemCat. HealthShare maps the SDA order type<br>
/// "LAB" to "L" for "LabTrak", "MED" and "VXU" to "R" for "Drug", and "RAD"<br>
/// and "OTH" to "N" for "Normal". So technically, two OrderCategories with the<br>
/// same Code, Description, and SDACodingStandard, one for a Medication and the<br>
/// other for a Vaccination, could match each other in the Viewer Cache.<br>
/// However, an OrderCategory for a LabOrder will never match one for a<br>
/// Medication.<br><br>
/// OrderCategory also populates User.HS.OECOrderCategory, which ARCItemCat<br>
/// contains a reference to (ARCICOrdCatDR). The Code and Description of the<br>
/// linked ARCItemCat and OECOrderCategory should be the same.
Class HS.SDA3.CodeTableDetail.OrderCategory Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.OrderCategoryExtension;

/// VIEWERLIB: User.HS.ARCItemCat(ARCICCode)<br>
/// VIEWERLIB: User.HS.OECOrderCategory(ORCATCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.ARCItemCat(ARCICDesc)<br>
/// VIEWERLIB: User.HS.OECOrderCategory(ORCATDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

Storage Default
{
<Data name="CodeTableDetailState">
<Value name="1">
<Value>SDATableName</Value>
</Value>
<Value name="2">
<Value>SDACodingStandard</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>InternalReference</Value>
</Value>
<Value name="6">
<Value>ErrorStatus</Value>
</Value>
<Value name="7">
<Value>TrakInternalOrderType</Value>
</Value>
<Value name="8">
<Value>OrderType</Value>
</Value>
<Value name="9">
<Value>EId</Value>
</Value>
<Value name="10">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="11">
<Value>Extension</Value>
</Value>
<Value name="12">
<Value>OriginalText</Value>
</Value>
<Value name="13">
<Value>PriorCodes</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

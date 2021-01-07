/// Order is processed "in-line" in the Viewer Cache in<br>
/// web.SDA3.Order:UpdateOrder since it needs to know about its "parent"<br>
/// OrderCategory and order type. A reference to the "parent" OrderCategory (as<br>
/// an ARCItemCat) is stored in the ARCIMItemCatDR property.<br><br>
/// In addition to Code, Description, and SDACodingStandard, Orders are also<br>
/// matched on their "parent" order type (LAB, RAD, MED, VXU, or OTH), although<br>
/// this matching is only approximate. See<br>
/// HS.SDA3.CodeTableDetail.OrderCategory for more info. The parent<br>
/// OrderCategory is sometimes used as a match property as well, depending on<br>
/// the value of the Configuration Registry key:<br>
/// <pre>
/// \Viewer\OrderCategory\AlwaysUseInbound
/// </pre>
/// If the value of the key is 1, then two Orders must match on OrderCategory<br>
/// to be considered a match. Else, the Orders can match even if the<br>
/// OrderCategories do not match, so long as they match on Code, Description,<br>
/// SDACodingStandard, and order type. In this case, the existing OrderCategory<br>
/// will be used, and the inbound value basically discarded. This can be useful<br>
/// for setting up the Access Gateway as the "source of truth" for the category<br>
/// of orders via the SITE-Default-OrderItem.txt file, so that orders can be<br>
/// grouped by category in the Clinical Viewer.<br><br>
/// If an inbound Order has no "parent" OrderCategory, then on add to the<br>
/// Viewer Cache (no match found on Code, Description, SDACodingStandard, and<br>
/// OrderType), the OrderCategory with Code and Description = [order type]<br>
/// will be defaulted in. If a match is found on Code, Description,<br>
/// SDACodingStandard, and OrderType but the inbound Order has no parent<br>
/// OrderCategory, then the comparison will be called a match and the existing<br>
/// OrderCategory used.
Class HS.SDA3.CodeTableDetail.Order Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.OrderExtension;

/// VIEWERLIB: User.HS.ARCItmMast(ARCIMCode)<br>
/// VIEWERLIB: User.HS.ARCItmMast(ARCIMAbbrev)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.ARCItmMast(ARCIMDesc)
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
<Value>OrderType</Value>
</Value>
<Value name="8">
<Value>OrderCategory</Value>
</Value>
<Value name="9">
<Value>EId</Value>
</Value>
<Value name="10">
<Value>OriginalText</Value>
</Value>
<Value name="11">
<Value>PriorCodes</Value>
</Value>
<Value name="12">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="13">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

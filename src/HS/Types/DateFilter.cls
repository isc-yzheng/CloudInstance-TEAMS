Class HS.Types.DateFilter Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// If the FromDate is not specified, then we're including all dates up to the ThruDate
/// FromDate is inclusive.  If not specified, 0 is assumed.
Property FromDate As %Date;

/// Deprecated and not used.  We only use the FromDate, which from the UI reflects "Days Back"
/// If the ThruDate is not specified, then we're including all dates starting with the FromDate.
/// ThruDate is inclusive.  If not specified, 999999 is assumed
Property ThruDate As %Date;

/// If the InfoType is not specified, then the date filter applies to all infotypes
/// The InfoType can be an OrderType (e.g. LAB), or include a sub-type for OrderCategory (e.g. LAB.MIC)
///  or can include a sub-sub-type for PharmacyStatus (e.g. MED..F)
Property InfoType As %String(MAXLEN = 220);

Storage Default
{
<Data name="DateFilterState">
<Value name="1">
<Value>FromDate</Value>
</Value>
<Value name="2">
<Value>ThruDate</Value>
</Value>
<Value name="3">
<Value>InfoType</Value>
</Value>
</Data>
<State>DateFilterState</State>
<StreamLocation>^HS.Types.DateFilterS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

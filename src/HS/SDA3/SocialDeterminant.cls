Class HS.SDA3.SocialDeterminant Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.SocialDeterminantExtension;

/// Streamlet cache:<br>
/// In the OnInactivate method of the Streamlet class, if the Status is not<br>
/// already "I", it is set to "I".<br>
/// In the OnValidate method, if the Status is null, it is defaulted to "A" for<br>
/// "Active".<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QStatus)
Property Status As %String(MAXLEN = 50);

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QComments)
Property Comments As %String(MAXLEN = "");

/// Upstream system or inbound interface chooses to flag specific values as needing special attention<br>
/// In Clinical Viewer, will highlight row as red and display text indicating warning state.<br><br>
/// Viewer Cache:<br>
/// The value that is inserted into the Viewer Cache and ultimately displayed<br>
/// to the user is the Description of one of the "YESNO" standard type items in<br>
/// Trak, which can be configured. If Warning=1 the Description of the "Y" item<br>
/// will be shown, and if Warning=0 the Description of the "N" value will be<br>
/// shown. If Warning="", an empty string ("") will be inserted and shown.<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QWarning)
Property Warning As HS.SDA3.Boolean;

/// Social Determinant Code<br>
/// Ex. "Access to public transportation"<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QDescription)
Property SocialDeterminantCode As HS.SDA3.CodeTableDetail.SocialDeterminantCode;

/// The coded value associated with the social determinant.<br>
/// Social Determinant value could be coded, numeric or text.<br>
/// For properties SocialDeterminantValueCoded, SocialDeterminantValueNumeric and <br>
/// SocialDeterminantValueText, only one of them will be populated.<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QValue)
Property SocialDeterminantValueCoded As HS.SDA3.CodeTableDetail.SocialDeterminantValueCode;

/// The text value associated with the social determinant<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QValue)
Property SocialDeterminantValueText As HS.SDA3.StrippedString(MAXLEN = 32000);

/// The numeric value associated with the social determinant<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QValue)
Property SocialDeterminantValueNumeric As HS.SDA3.Numeric;

/// The unit of measure associated with Property SocialDeterminantValueNumeric<br><br>
/// Viewer Cache:<br>
/// If SocialDeterminantValueNumeric is not null, then it is appended with this<br>
/// value (either the Description, or the Code if that is null) before being<br>
/// inserted into the Viewer Cache.<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QValue)
Property SocialDeterminantUnitOfMeasure As HS.SDA3.CodeTableDetail.UoM;

/// Not used.
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// The person who noted the observation.<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QUESUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// The organization or system which created the record.<br><br>
/// Viewer Cache:
/// EnteredAt is not inserted into the Viewer Cache as a code table entry but<br>
/// rather a string value, either the Description, or if that is null, the<br>
/// Code.<br><br>
/// VIEWERLIB: questionnaire.QSOCIALDET(QEnteredAt)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// The date when the value was recorded.<br><br>
/// VIEWERLIB: questionnaire.QPROGRAMS(QUESDate) + questionnaire.QPROGRAMS(QUESTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// VIEWERLIB: Not stored.<br>
/// Not used.
Property CreatedBy As HS.SDA3.CodeTableDetail.User;

/// VIEWERLIB: Not stored.<br>
/// Not used.
Property CreatedTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: Not stored.<br>
/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// VIEWERLIB: Not stored.<br>
/// Not used.
Property FromTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: Not stored.<br>
/// Not used.
Property ToTime As HS.SDA3.TimeStamp;

/// Used for the social determinant identifier
Property ExternalId As %String(MAXLEN = 220);

/// Default streamlet processing will utilize EncounterNumber for matching. <br>
/// It is strongly recommended that EncounterNumber is NOT populated for SocialDeterminant data.
Property EncounterNumber As %String(MAXLEN = 220);

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
<Value>Status</Value>
</Value>
<Value name="15">
<Value>Comments</Value>
</Value>
<Value name="16">
<Value>Warning</Value>
</Value>
<Value name="17">
<Value>SocialDeterminantCode</Value>
</Value>
<Value name="18">
<Value>SocialDeterminantValueCoded</Value>
</Value>
<Value name="19">
<Value>SocialDeterminantValueNumeric</Value>
</Value>
<Value name="20">
<Value>SocialDeterminantValueText</Value>
</Value>
<Value name="21">
<Value>SocialDeterminantUnitOfMeasure</Value>
</Value>
<Value name="22">
<Value>CreatedBy</Value>
</Value>
<Value name="23">
<Value>CreatedTime</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

/// Generic SDA3 custom object, to hold a collection of NVPairs<br><br>
/// To display CustomObjects in the Clinical Viewer:<br>
/// 1. In [install-dir]\distlib\trak\misc\, create a file<br>
/// SITE-Default-CustomObject.txt. Copy to it the single entry from the<br>
/// HS-Default file:<br>
/// PROGRAMS^Program Membership^ProgramName,ProgramDescription<br>
/// 2. Add an entry for each type of CustomObject in the form:<br>
/// Code^Description^Fields<br>
/// Where "Fields" is a comma-delimited list of fields (NVPair Names) the<br>
/// CustomObject can have. "Code" is the CustomType of the CustomObjects to<br>
/// be displayed. "Description" is what will appear in the viewer.<br>
/// 3. Load this data into the Access Gateway by doing a reset:<br>
/// do ##class(HS.Util.Installer.AccessGateway).Reset()<br>
/// 4. Log in to Trak to edit the viewer.<br>
/// 5. The CustomObjects will be displayed via a Questionnaire Profile. Either<br>
/// create a new chart to display the profile or pick an existing one to add it<br>
/// to.<br>
/// 6. On the Chart Setup screen, click "Add/Edit Questionnaire Profile".<br>
/// 7. Fill in a name for the Questionnaire Profile, and under Questionnaire<br>
/// Group, select the option corresponding to the desired CustomType. (This<br>
/// list is populated by the Codes and Descriptions from either the HS- or<br>
/// SITE-Default-CustomObject.txt file.)  Click "Update".<br>
/// 8. Add the newly created Questionnaire Profile to the chart and click<br>
/// "Update".<br>
/// 9. On the chart, the columns that will contain the Values from CustomPairs<br>
/// will initially be called "Significant Answer 1", "Significant Answer 2",<br>
/// etc. The Column Editor may be used to control which columns are displayed,<br>
/// and the Layout Editor may be used to set the names of the columns.<br>
Class HS.SDA3.CustomObject Extends HS.SDA3.SuperClass
{

/// A short string classifying this custom object<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, the InfoSubType property<br>
/// of the streamlet is set to the value of the CustomType, converted to<br>
/// uppercase. Also, ActionScope matches on CustomType. See the ActionScope<br>
/// property for more info.<br><br>
/// Viewer cache:<br>
/// If the Clinical Viewer is configured to display CustomObjects (see above),<br>
/// they will be grouped by CustomType.<br><br>
/// VIEWERLIB: Not stored
Property CustomType As %String;

/// In addition to CustomType, this is one of the match properties used to<br>
/// determine if an inbound CustomObject matches an existing one.  This will<br>
/// probably be computed from some concatenation of Values from CustomPairs.<br><br>
/// VIEWERLIB: Not stored
Property CustomMatchKey As %String(MAXLEN = 220);

/// The generic container to hold all sorts of data about this object<br><br>
/// Viewer cache:<br>
/// When the Access Gateway is reset and the HS- or SITE-Default-<br>
/// CustomObject.txt file is loaded, a class will be generated in the Access<br>
/// namespace for each entry in the file. The name of the class will be<br>
/// "questionnaire.Q[ShortUpperCode]", where [ShortUpperCode] is the first 10<br>
/// characters of the Code from the file, converted to uppercase. A property<br>
/// will be generated in this class for each field named in the entry. The name<br>
/// of the property will be "Q[field]", where [field] is the field from the<br>
/// entry.<br>
/// When attempting to load a CustomObject into the Viewer Cache, first a check<br>
/// is made to see if there is a class for the object's CustomType. If there<br>
/// is, the CustomPairs list is iterated over and every NVPair whose Name<br>
/// corresponds to a property of the class will have its Value stored in that<br>
/// property.<br><br>
/// VIEWERLIB: questionnaire.Qxxx(Qyyy)
Property CustomPairs As list Of HS.SDA3.NVPair;

/// Viewer cache:<br>
/// For this property to be stored in the Viewer Cache, there must be an entry<br>
/// in the HS- or SITE-Default-CustomObject.txt file with Code=CustomType of<br>
/// this object. The class it is stored to will be<br>
/// "questionnaire.Q[ShortUpperCode]", where [ShortUpperCode] is the first 10<br>
/// characters of the Code from the file, converted to uppercase.<br><br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: questionnaire.Qxxx(QUESUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// Viewer cache:<br>
/// For this property to be stored in the Viewer Cache, there must be an entry<br>
/// in the HS- or SITE-Default-CustomObject.txt file with Code=CustomType of<br>
/// this object. The class it is stored to will be<br>
/// "questionnaire.Q[ShortUpperCode]", where [ShortUpperCode] is the first 10<br>
/// characters of the Code from the file, converted to uppercase.<br><br>
/// VIEWERLIB: questionnaire.Qxxx(QUESDate) + questionnaire.Qxxx(QUESTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Supported values:<br>
/// D = Delete<br>
/// C = Clear All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// See the annotation on the superclass property for more information on how<br>
/// ActionScope is used.<br>
/// If the ActionCode of an inbound CustomObject is "C" and ActionScope is not<br>
/// null, then only CustomObjects with CustomType = ActionScope<br>
/// (case-insensitive) will be deleted.<br><br>
/// VIEWERLIB: Not stored
Property ActionScope As %String;

ClassMethod GetStreamletClass(pType)
{
	// No extension available
	Quit "HS.SDA3.Streamlet.CustomObject"
}

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
<Value>CustomType</Value>
</Value>
<Value name="12">
<Value>CustomMatchKey</Value>
</Value>
<Value name="13">
<Value>CustomPairs</Value>
</Value>
<Value name="14">
<Value>UpdatedOn</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

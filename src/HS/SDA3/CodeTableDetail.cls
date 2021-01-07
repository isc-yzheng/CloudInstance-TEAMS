/// The base class for all SDA code table objects. Every code table class<br>
/// should either extend this or HS.SDA3.CodeTableTranslated.<br>
/// For each class that extends CodeTableDetail, if it gets loaded into the<br>
/// Viewer Cache, the location that each property gets loaded into will be<br>
/// documented on that property. Unless otherwise noted in the class, matching<br>
/// between CodeTableDetails and their Viewer Cache counterparts is done on<br>
/// Code, Description, and SDACodingStandard.
Class HS.SDA3.CodeTableDetail Extends (%SerialObject, %XML.Adaptor, HS.SDA3.QuickXML) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// Ignore all nulls (i.e. don't store $C(0)), but do not export empty tags
Parameter XMLIGNORENULL = "inputonly";

/// Tells the generator for ToQuickXML that this is a CodeTableDetail, to check<br>
/// for delete instructions. If both Code and Description are a pair of double<br>
/// quotes (the delete instruction), then it won't output the CodeTableDetail<br>
/// at all.
Parameter ISCODETABLE = 1;

/// Deprecated, but left here for compatibiliy with old inbound SDA XML Streams
Property SDATableName As %String(XMLIO = "IN");

/// The coding standard. e.g. "3.2.45.7.34", "LOINC", etc.<br>
/// SDACodingStandard may not contain the caret ("^") symbol as this is<br>
/// reserved for internal use.<br>
/// If the SDA is being loaded into the Streamlet Cache via the ECR Manager<br>
/// operation or the Aggregation Cache via the Access Manager operation, then<br>
/// if the operation specifies an InboundCodeSystemProfile (referring to a Code<br>
/// System Profile in the Terminology Registry), and that profile specifies a<br>
/// default code system for this code table, and if SDACodingStandard is null,<br>
/// then SDACodingStandard will be defaulted to the default code system for<br>
/// this code table. If the code table will be transformed to or from FHIR,<br>
/// SDACodingStandard may be one of the CodeSystems in the FHIR ValueSet.
Property SDACodingStandard As %String(MAXLEN = 32000);

/// The external code, e.g. "M"<br><br>
/// When the CodeTableDetail is imported via the XMLImportSDAString method,<br>
/// Code will not be imported if it contains only punctuation and/or<br>
/// whitespace, unless it is the SDA3 delete instruction (two double quotes).<br>
/// There is one exception to this for HS.SDA3.CodeTableDetail.UoM, in which<br>
/// case Code may be a percent sign ("%").<br><br>
/// Code may not contain the caret ("^") symbol as this is reserved for<br>
/// internal use. In the Viewer Cache only, TAB ($c(9)) is also a reserved<br>
/// character and will be replaced with a space. For LabTestItems in the Viewer<br>
/// Cache, backslash ("\") is also reserved and will be replaced with<br>
/// an underscore ("_").
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// The description, as displayed to the user, e.g. "Male"<br><br>
/// When the CodeTableDetail is imported via the XMLImportSDAString method,<br>
/// Description will not be imported if it contains only punctuation and/or<br>
/// whitespace, unless it is the SDA3 delete instruction (two double quotes).<br>
/// There is one exception to this for HS.SDA3.CodeTableDetail.UoM, in which<br>
/// case Description may be a percent sign ("%"). Then, if Description is null<br>
/// or the same as Code, and SDACodingStandard and Code are not null, then<br>
/// HealthShare will attempt to find an entry in the Code Registry matching on<br>
/// Code and SDACodingStandard (converted to uppercase). If a match is found,<br>
/// Description will be defaulted from that entry. Note that this takes place<br>
/// after SDACodingStandard is defaulted, so the defaulted value of<br>
/// SDACodingStandard may be used for matching.<br><br>
/// Description may contain caret ("^") characters in the SDA, however this<br>
/// character is reserved in the Viewer Cache, so in the Viewer Cache only, "^"<br>
/// will be replaced with an underscore ("_"). Also in the Viewer Cache only,<br>
/// TAB ($c(9)) is reserved and will be replaced with a space, and for<br>
/// LabTestItems, backslash ("\") is reserved will be replaced with an<br>
/// underscore.
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// The coding system version ID, e.g. piece 7 from an HL7v2.5 CNE or CWE<br>
/// structure
Property CodeSystemVersionId As %String(MAXLEN = 32000);

/// Only used when loading CodeTableDetails into the Viewer Cache<br>
/// When a CodeTableDetail is successfully added or matched in the Viewer<br>
/// Cache, this is the ID of the added or matched entry in the corresponding<br>
/// Viewer table.
Property InternalReference As %String(XMLPROJECTION = "NONE");

/// Deprecated - no longer used, but kept here for compatibility in case this<br>
/// comes in from old SDA2
Property EId As %String(XMLIO = "IN");

/// The error (if any) that occurred loading this entry into the Viewer Cache,<br>
/// as a %Status
Property ErrorStatus As %String(MAXLEN = 32000, XMLPROJECTION = "NONE");

/// When the %codetables3 variable is defined, this callback will index the new<br>
/// CodeTableDetail in %codetables3, which is then used to process<br>
/// CodeTableDetails into the Viewer Cache. Therefore %codetables3 should be<br>
/// initialized (killed and set to 0) before instantiating any SDA (either<br>
/// through XML correlation or manually creating SDA objects) that is intended<br>
/// to be loaded into the Viewer Cache. Note that CodeTableDetails created with<br>
/// %ConstructClone() do not invoke this callback.
Method %OnNew() As %Status
{
 if $data(%codetables3) set %codetables3(+##this) = ##this
 quit $$$OK
}

/// Returns a comma-delimited list of SDATableNames, alphabetically, starting<br>
/// and ending with commas
ClassMethod SDATableNames() As %String [ CodeMode = objectgenerator ]
{
	set tRS = ##class(%ResultSet).%New("%DynamicQuery:SQL")
	set tSC = tRS.Prepare("SELECT ID FROM %Dictionary.ClassDefinition WHERE ID %STARTSWITH 'HS.SDA3.CodeTableDetail.'")
	if $$$ISERR(tSC) { do DisplayError^%apiOBJ(tSC) quit }
	set tSC = tRS.Execute()
	if $$$ISERR(tSC) { do DisplayError^%apiOBJ(tSC) quit }
	set tList = ""
	while tRS.Next(.tSC) {
		if $$$ISERR(tSC) { quit }
		set tList = tList_","_$P(tRS.Data("ID"), ".", $L(tRS.Data("ID"), "."))
	}
	if $$$ISERR(tSC) { do DisplayError^%apiOBJ(tSC) quit }
	set tList = tList_","
	do %code.WriteLine(" quit """_tList_"""")
}

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
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="6">
<Value>InternalReference</Value>
</Value>
<Value name="7">
<Value>EId</Value>
</Value>
<Value name="8">
<Value>ErrorStatus</Value>
</Value>
</Data>
<State>CodeTableDetailState</State>
<StreamLocation>^HS.SDA3.CodeTableDetailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

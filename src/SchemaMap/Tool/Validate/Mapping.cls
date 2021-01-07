Include SchemaMap

/// Provides utility methods for validating potential mappings and anticipating 
/// their side effects on potential transformations.
/// <p>
/// These methods offer an optional, formatted text output argument
/// that the caller can use either to output the results of this analysis 
/// to HTML pages for the UI (format "HTML"), 
/// to DTL <annotation> tag content in DTL classes (format "DTL"), or
/// to exported HTML formatted status reports (format "HTMLReport").
/// The rules for the format called "DTL" here are valid for any XML tag content.
/// <p>
/// "HTML" is the default.
Class SchemaMap.Tool.Validate.Mapping [ Abstract ]
{

/// The primary purpose of this method is to produce validation messages.
/// To get them, it performs validation of the mappings for the fromPath
/// and returns the information as a list of formatted messages using
/// the format supplied in the first argument.
/// <p>
/// Messages can be output 
/// to HTML pages for the UI (format "HTML"), 
/// to DTL <annotation> tag content in DTL classes (format "DTL"), or
/// to exported HTML formatted status reports (format "HTMLReport").
/// The rules for the format called "DTL" here are valid for any XML tag content.
/// <p>
/// "HTML" is the default.
/// <p>
/// Use case 1: If there are no MapIssues for the input path, the output arguments 
/// appendIssues and appendNotes will both contain empty strings. The caller can check for this.
/// <p>
/// Use case 2: If there are no MapIssues but there is interesting info needed for a specific format, 
/// appendIssues contains an empty string and appendNotes contains the useful info message.
/// For example, when the format is "DTL" the caller needs to send an annotation
/// to a generated DTL transformation to identify the value set that applies to a code type.
/// Value set info are not needed when format is "HTML" because this info is already visible in the UI.Edit page.
/// <p>
/// As an example of passing in a separator set that is for composing a DTL annotation rather than 
/// composing an HTML display, see SchemaMap.DTL.Generate.cls:WriteXDataBlock.
ClassMethod GetInfo(format As %String(VALUELIST=",HTML,DTL") = "HTML", from As %String = "", to As %String = "", mapping As %RegisteredObject, issueType As %String = "AutoHandled,Validation", Output appendIssues As %String, Output appendNotes As %String) As %Status
{
}

}

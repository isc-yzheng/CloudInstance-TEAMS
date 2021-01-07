Include SchemaMap

/// Provides utility methods for choosing and formatting text messages for output
/// to HTML pages for the UI (format "HTML"), 
/// to DTL <annotation> tag content in DTL classes (format "DTL"), or
/// to exported HTML formatted status reports (format "HTMLReport").
/// The rules for the format called "DTL" here are valid for any XML tag content.
/// <p>
/// "HTML" is the default.
Class SchemaMap.Tool.Data.Message [ Abstract ]
{

ClassMethod GetSeparatorsForValidation(format = "HTML", join, stop, urgentStart, urgentEnd, outerFirst, outerNext, outerBreak, outerClose, outerEnd, innerFirst, innerNext, innerBreak, innerClose, innerEnd) As %Status
{
}

ClassMethod GetResourceLabel(schema As %String, path As %String) As %String
{
}

ClassMethod GetFHIRCodeHelp(schema As %String, path As %String, valueSet As %String = "", codeType As %String, codeValue As %String, codeStatus As %String = "", Output codeHelp) As %Status
{
}

ClassMethod GetFHIRCodeTitle(schema As %String, path As %String, codeType As %String, codeValue As %String, Output codeTitle) As %Status
{
}

ClassMethod GetFHIRReferenceHelp(schema As %String, path As %String, valueSet As %String, Output refHelp) As %Status
{
}

/// Explanations for flags for data type relationships within resource hierarchical structure (FHIR).
/// For flag definitions see SchemaMap.inc.
ClassMethod GetFHIRComplexTypeHelp(type As %Integer) As %String
{
}

/// Explanations for macros for getting information about data type relationships within resource hierarchical structure (FHIR).
/// For macro definitions see SchemaMap.inc.
ClassMethod GetFHIRComplexTypeHelpMacro(type As %Integer) As %String
{
}

/// Returns line-ending formatted text that explains
/// ALL flags for data type relationships within resource hierarchical structure (FHIR).
/// For flag definitions see SchemaMap.inc.
ClassMethod GetFHIRComplexTypeHelpAll() As %String
{
}

/// Returns line-ending formatted text that lists and explains
/// ALL paths with data type relationships within resource hierarchical structure
/// for the specified FHIR schema (FHIR2 or FHIR3).
/// This is to support work on recursive nesting within resources in the schema.
ClassMethod GetFHIRComplexTypeHelpVerbose(schema As %String, Output text) As %Status
{
}

/// Stores (for later retrieval) line-ending formatted text that lists and explains
/// ALL paths with data type relationships within resource hierarchical structure
/// for the specified FHIR schema (FHIR2 or FHIR3).
/// This is to support work on recursive nesting within resources in the schema.
ClassMethod BuildFHIRComplexTypeHelp(schema As %String) As %Status
{
}

ClassMethod GetFHIRComplexTypeHelpMacroAll(schema As %String, Output text) As %Status
{
}

ClassMethod GetCodeTableDetailHelp(schema As %String, Output text) As %Status
{
}

/// SDA3 HTML
ClassMethod BuildCodeTableDetailHelp(schema) As %Status
{
}

/// Path Message HTML
/// <p>
/// This method is for drawing the drop-down list that is offered to choose fields to map "To" in the UI Edit popup.
/// <p>
/// Called to generate text for displaying information as HTML in the UI so that a developer can select 
/// only the appropriate elements as targets of a mapping "to" this schema (SchemaMap.Tool.UI.Edit:DrawToFields does this).
/// The "likely" values are used by the UI to pre-populate choices in select drop-downs in an intuitive way.
ClassMethod GetPathsFieldsText(schema As %String, path As %String, likelyResource As %String = "", likelyElement As %String = "", Output text) As %Status
{
}

/// Message HTML
/// For exporting HTML reports, set excludeClassLinks to 1 (true).
ClassMethod GetLinkToSpec(schema, resource, excludeClassLinks As %Boolean = 0) As %String
{
}

/// Message HTML
ClassMethod GetLinkToFHIRSpec(schema, resource) As %String
{
}

/// Message HTML
ClassMethod GetFHIRBaseElementURL(resource) As %String
{
}

/// Message HTML
/// the caller must already know this is a FHIR value set
ClassMethod GetLinkToFHIRValueSet(schema, name) As %String
{
}

/// Message HTML
ClassMethod GetLinkToSDA3Spec(resource) As %String
{
}

/// Decorates a data type value for display in HTML, including links to other resources in either of the two schemas being compared.
ClassMethod DataDecorate(schema As %String = "", dataRaw As %String = "", separator As %String = " ", excludePrimitives As %Boolean = 1, externalLinksOnly As %Boolean = 0, sort As %String = "", pair As %String = "", autoMapped As %Boolean = 0, backboneHeader As %Boolean = 0, excludeClassLinks As %Boolean = 0) As %String
{
}

/// Path Message HTML
/// <p>
/// This method is for drawing the drop-down list that is offered in the detailed info display for a field,
/// under the label "Children". This drop-down list appears in the info display only if the field is an object.
/// The purpose of this field is to navigate down a level in the resource structure, if desired.
/// <p>
/// Given a schema and path, returns information about that path in that schema, in the argument called fieldText.
/// The input argument purpose explains the purpose of the fieldText, generally HTML for the UI.
/// <p>
/// path is expected to be a full field path with a resource or class name, a colon separator, and a field path after the colon.
/// However, a path that consists of only a resource or class name with no colon and no field path is also supported.
/// <p>
/// This method initializes the argument called fieldText to an empty string, then returns information in it. 
/// This information consists of the path, plus additions like (List) (Object) to describe what kind of resource or element the path represents.
/// <p>
/// Currently this method is often called when we are getting a list of fields for some particular purpose. 
/// Usually a list of this kind needs a container at the start and end. So:
/// first says whether this is the first field in such a list; last says whether this is the last field in such a list.
/// first and last give us the cue to provide the start or end of the required container.
/// <p>
/// Currently the formatting of the message created in fieldText is HTML for the UI.
/// Other formatting should be possible.
ClassMethod GetFieldText(purpose As %String, schema As %String, path As %String, from As %String, to As %String, first As %Boolean = 1, last As %Boolean = 1, Output fieldText As %String) As %Status
{
}

/// Path Message HTML
/// <p>
/// This method is for drawing one option in the drop-down list that is offered in 
/// the detailed info display for a field, under the label "Children". 
/// <p>
/// GetFieldChildrenText is the method that GetFieldText calls for each direct child of the path input to GetFieldInfo.
/// As GetFieldText is currently written, GetFieldText is called only if we already know this path is an object.
/// Most of the comments for GetFieldText apply to this method (see GetFieldText).
/// <p>
/// Note this method does not recurse down levels; it returns only direct child fields of the input path.
/// Omit order, or set it to an empty string, to get the list of fields in alphabetical order.
/// Set order to "spec" to get the results in the same order as in the schema CSV file (for FHIR, this is FHIR spec order).
ClassMethod GetFieldChildrenText(purpose As %String, schema As %String, path As %String, type As %String, order As %String = "", Output fieldText As %String) As %Status
{
}

/// A comma-separated string of GetMapFlagLabel values.
/// If the input argument is empty or not supplied, return information about all map issues.
ClassMethod GetMapIssuesDisplay(mapIssues As %String = "") As %String
{
}

/// Provide the short descriptive label for an issue flag defined in SchemaMap.inc
/// in the macros MapIssueFlag, MappIssueRoot, and MapIssueType. The tool can use 
/// a new flag only if it is defined in SchemaMap.inc, here, and GetMapFlagDescription()
/// <p>
/// For the full sentence description of an issue flag see GetMapFlagDescription()
/// <p> 
/// SchemaMap.inc defines every issue as one of these two types: A (auto-handled) or U (unhandled). 
/// For documentation see GetMapIssueTypeLabel() and GetMapIssueLabelDescription().
/// <p>
/// Some of the flags here are reserved for future use;
/// for example E "Source is an Extension" because we do not yet handle 
/// customized fields that we encounter in source data.
ClassMethod GetMapFlagLabel(mapFlag As %String = "") As %String
{
}

/// Provide the full sentence description for an issue flag defined in SchemaMap.inc
/// in the macros MapIssueFlag, MappIssueRoot, and MapIssueType. The tool can use 
/// a new flag only if it is defined in SchemaMap.inc, here, and GetMapFlagDescription()
/// <p>
/// For the short descriptive label of an issue flag see GetMapFlagLabel()
/// <p> 
/// SchemaMap.inc defines every issue as one of these two types: A (auto-handled) or U (unhandled). 
/// For documentation see GetMapIssueTypeLabel() and GetMapIssueLabelDescription().
/// <p>
/// Some of the flags here are reserved for future use;
/// for example E "Source is an Extension" because we do not yet handle 
/// customized fields that we encounter in source data.
ClassMethod GetMapFlagDescription(mapFlag As %String = "") As %String
{
}

ClassMethod GetMapFlagRootLabel(mapFlag As %String = "") As %String
{
}

ClassMethod GetMapIssueTypeLabel(issueType As %String = "") As %String
{
}

ClassMethod GetMapIssueTypeDescription(issueType As %String = "") As %String
{
}

ClassMethod GetMapClinicalTypeDescription(clinicalType As %String = "") As %String
{
}

/// HTML-formatted content for a quick guide to ObjectScript syntax and Schema Mapper path syntax, for use where needed
ClassMethod SyntaxGuide() As %String
{
}

ClassMethod TimeStamp() As %String
{
}

/// Provide help text regarding the action icons for the Actions column in the mapping display table.
ClassMethod HelpIcon() As %String
{
}

ClassMethod FAQ() As %String
{
}

ClassMethod TargetSchemaInfo(from As %String = "", to As %String = "", resource As %String = "") As %String
{
}

ClassMethod FHIRCodeObjectValue(from As %String = "", fromPath As %String = "", sourceValue As %String = "", to As %String = "", toPath As %String = "", toLeaf As %String = "", mapSource As %Boolean = 0, dependsOn As %String = "", exclude As %String = "", toDefault As %String = "", issueType As %String(VALUELIST=",Provided,Missing") = "Provided", flag As %String = "", resource As %String = "") As %String
{
}

/// As in %CSP.Page
ClassMethod EscapeHTML(in) As %String [ CodeMode = expression, ServerOnly = 1 ]
{
}

}

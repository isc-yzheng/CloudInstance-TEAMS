Class HS.Types.FHIR.Error Extends %RegisteredObject
{

/// Error severity code, should be an IssueSeverity code (http://hl7.org/fhir/issue-severity).
Property Severity As %String;

/// Error type code, should be an IssueType code (http://hl7.org/fhir/issue-type).
Property Code As %String;

/// Brief text description of the error.
Property DetailsText As %String(MAXLEN = "");

/// Code for more detailed categorization of the error.  Examples are the
/// operation outcome codes from HL7 (http://hl7.org/fhir/operation-outcome).
Property DetailsCode As %String(MAXLEN = "");

/// Text description associated with the DetailsCode.
Property DetailsDescription As %String(MAXLEN = "");

/// Additional diagnostic information about the issue.
Property Diagnostics As %String(MAXLEN = "");

/// Error location, as an XPath expression.
Property Location As %String(MAXLEN = "");

/// Error location, as a FHIRPath expression.
Property Expression As %String(MAXLEN = "");

}

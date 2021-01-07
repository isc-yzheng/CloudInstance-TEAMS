/// a set of metadata that provides technical and workflow context to the resource. 
/// The metadata items are all optional, 
/// though some or all of them may be required in particular implementations or contexts of use.
Class HS.FHIR.DTL.vSTU3.Model.Base.Meta Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Version specific identifier.
Property versionId As %String(MAXLEN = 1000000, XMLNAME = "versionId", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// When the resource version last changed.
Property lastUpdated As %String(MAXLEN = 1000000, XMLNAME = "lastUpdated", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Profiles this resource claims to conform to.
Property profile As list Of %String(MAXLEN = 1000000, XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Security Labels applied to this resource.
/// <p>
/// security-labels is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property security As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "security", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Tags applied to this resource.
/// <p>
/// any FHIR3 code may be used; 
/// common-tags shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property tag As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "tag", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Meta";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Meta";

}

/// External repository which contains detailed report related with observedSeq in this resource.
Class HS.FHIR.DTL.vSTU3.Model.Element.Sequence.repository Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// directlink | openapi | login | oauth | other
/// <p>
/// repository-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend repository-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// URI of the repository.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Repository's name.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Id of the dataset that used to call for dataset in repository.
Property datasetId As %String(MAXLEN = 1000000, XMLNAME = "datasetId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Id of the variantset that used to call for variantset in repository.
Property variantsetId As %String(MAXLEN = 1000000, XMLNAME = "variantsetId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Id of the read.
Property readsetId As %String(MAXLEN = 1000000, XMLNAME = "readsetId", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Sequence.repository";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Sequence.repository";

}

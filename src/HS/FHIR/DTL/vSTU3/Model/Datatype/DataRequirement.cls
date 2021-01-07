/// The DataRequirement structure defines a general data requirement for a knowledge asset such as a decision support rule or quality measure.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.DataRequirement Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// The type of the required data.
/// <p>
/// all-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend all-types and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// The profile of the required data.
Property profile As list Of %String(MAXLEN = 1000000, XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Indicates that specific structure elements are referenced by the knowledge module.
Property mustSupport As list Of %String(MAXLEN = 1000000, XMLNAME = "mustSupport", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What codes are expected.
Property codeFilter As list Of HS.FHIR.DTL.vSTU3.Model.Element.DataRequirement.codeFilter(XMLNAME = "codeFilter", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What dates/date ranges are expected.
Property dateFilter As list Of HS.FHIR.DTL.vSTU3.Model.Element.DataRequirement.dateFilter(XMLNAME = "dateFilter", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DataRequirement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DataRequirement";

}

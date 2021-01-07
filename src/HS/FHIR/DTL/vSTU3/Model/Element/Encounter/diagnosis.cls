/// The list of diagnosis relevant to this encounter.
Class HS.FHIR.DTL.vSTU3.Model.Element.Encounter.diagnosis Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Reason the encounter takes place (resource)
/// <p>
/// Condition | Procedure
Property condition As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "condition", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Role that this diagnosis has within the encounter (e.g. 
/// admission, 
/// billing, 
/// discharge...)
/// <p>
/// diagnosis-role is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in diagnosis-role, 
/// you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Ranking of the diagnosis (for each role type)
Property rank As %Integer(XMLNAME = "rank", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter.diagnosis";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter.diagnosis";

}

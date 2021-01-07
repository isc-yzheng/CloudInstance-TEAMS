/// Same source and target systems.
Class HS.FHIR.DTL.vSTU3.Model.Element.ConceptMap.group Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Code System (if value set crosses code systems)
Property source As %String(MAXLEN = 1000000, XMLNAME = "source", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Specific version of the  code system.
Property sourceVersion As %String(MAXLEN = 1000000, XMLNAME = "sourceVersion", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// System of the target (if necessary)
Property target As %String(MAXLEN = 1000000, XMLNAME = "target", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Specific version of the  code system.
Property targetVersion As %String(MAXLEN = 1000000, XMLNAME = "targetVersion", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Mappings for a concept from the source set.
Property element As list Of HS.FHIR.DTL.vSTU3.Model.Element.ConceptMap.group.element(XMLNAME = "element", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// When no match in the mappings.
Property unmapped As HS.FHIR.DTL.vSTU3.Model.Element.ConceptMap.group.unmapped(XMLNAME = "unmapped", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.group";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.group";

}

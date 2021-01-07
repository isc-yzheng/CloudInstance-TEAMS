/// Group of multiple entities.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Group Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique id.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// person | animal | practitioner | device | medication | substance
/// <p>
/// group-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend group-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Descriptive or actual.
Property actual As %Boolean(XMLNAME = "actual", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Kind of Group members.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Label for Group.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Number of members.
Property quantity As %Integer(XMLNAME = "quantity", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Trait of group members.
Property characteristic As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Group.characteristic(XMLNAME = "characteristic", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who or what is in group.
Property member As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Group.member(XMLNAME = "member", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Group";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Group";

}

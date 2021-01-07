/// Represents a defined collection of entities that may be discussed or acted upon collectively but which are not expected to act collectively and are not formally or legally recognized; 
/// i.e. 
/// a collection of entities that isn't an organization.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Group Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique id.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this group's record is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// person | animal | practitioner | device | medication | substance
/// <p>
/// group-type is the REQUIRED FHIR3 ValueSet for codes; 
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
/// any FHIR3 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

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
Property characteristic As list Of HS.FHIR.DTL.vSTU3.Model.Element.Group.characteristic(XMLNAME = "characteristic", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who or what is in group.
Property member As list Of HS.FHIR.DTL.vSTU3.Model.Element.Group.member(XMLNAME = "member", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Group";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Group";

}

/// Unique identifiers used for system.
Class HS.FHIR.DTL.vDSTU2.Model.Element.NamingSystem.uniqueId Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// oid | uuid | uri | other
/// <p>
/// namingsystem-identifier-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend namingsystem-identifier-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// The unique identifier.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Is this the id that should be used for this type.
Property preferred As %Boolean(XMLNAME = "preferred", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When is identifier valid?
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NamingSystem.uniqueId";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NamingSystem.uniqueId";

}

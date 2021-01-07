/// An address expressed using postal conventions (as opposed to GPS or other location definition formats). 
/// This data type may be used to convey addresses for use in delivering mail as well as for visiting locations which might not be valid for mail delivery. 
/// There are a variety of postal address formats defined around the world.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.Address Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// home | work | temp | old - purpose of this address
/// <p>
/// address-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend address-use and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// postal | physical | both
/// <p>
/// address-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend address-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Text representation of the address.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Street name, 
/// number, 
/// direction & P.O. 
/// Box etc.
Property line As list Of %String(MAXLEN = 1000000, XMLNAME = "line", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name of city, 
/// town etc.
Property city As %String(MAXLEN = 1000000, XMLNAME = "city", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// District name (aka county)
Property district As %String(MAXLEN = 1000000, XMLNAME = "district", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Sub-unit of country (abbreviations ok)
Property state As %String(MAXLEN = 1000000, XMLNAME = "state", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Postal code for area.
Property postalCode As %String(MAXLEN = 1000000, XMLNAME = "postalCode", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Country (e.g. 
/// can be ISO 3166 2 or 3 letter code)
Property country As %String(MAXLEN = 1000000, XMLNAME = "country", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Time period when address was/is in use.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Address";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Address";

}

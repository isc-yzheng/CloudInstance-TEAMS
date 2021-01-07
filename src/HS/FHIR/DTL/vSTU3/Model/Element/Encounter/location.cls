/// List of locations where the patient has been.
Class HS.FHIR.DTL.vSTU3.Model.Element.Encounter.location Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Location the encounter takes place.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// planned | active | reserved | completed
/// <p>
/// encounter-location-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend encounter-location-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Time period during which the patient was present at the location.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter.location";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter.location";

}

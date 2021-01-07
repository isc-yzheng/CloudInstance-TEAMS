/// Vision supply authorization.
Class HS.FHIR.DTL.vDSTU2.Model.Element.VisionPrescription.dispense Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Product to be supplied.
/// <p>
/// any FHIR2 code may be used; 
/// vision-product shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property product As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "product", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// right | left
/// <p>
/// vision-eye-codes is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend vision-eye-codes and you may NOT use codes from other ValueSets.
Property eye As %String(MAXLEN = 1000000, XMLNAME = "eye", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Lens sphere.
Property sphere As %Decimal(XMLNAME = "sphere", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Lens cylinder.
Property cylinder As %Decimal(XMLNAME = "cylinder", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Lens axis.
Property axis As %Integer(XMLNAME = "axis", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Lens prism.
Property prism As %Decimal(XMLNAME = "prism", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// up | down | in | out
/// <p>
/// vision-base-codes is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend vision-base-codes and you may NOT use codes from other ValueSets.
Property base As %String(MAXLEN = 1000000, XMLNAME = "base", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Lens add.
Property add As %Decimal(XMLNAME = "add", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Contact lens power.
Property power As %Decimal(XMLNAME = "power", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Contact lens back curvature.
Property backCurve As %Decimal(XMLNAME = "backCurve", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Contact lens diameter.
Property diameter As %Decimal(XMLNAME = "diameter", XMLPROJECTION = "ATTRIBUTE");

/// SimpleQuantity
/// <p>
/// Lens wear duration.
Property duration As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "duration", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Lens add.
Property color As %String(MAXLEN = 1000000, XMLNAME = "color", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Lens add.
Property brand As %String(MAXLEN = 1000000, XMLNAME = "brand", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Notes for coatings.
Property notes As %String(MAXLEN = 1000000, XMLNAME = "notes", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "VisionPrescription.dispense";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "VisionPrescription.dispense";

}

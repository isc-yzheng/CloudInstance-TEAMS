/// Data that comes from a series of measurements taken by a device, 
/// which may have upper and lower limits. 
/// The data type also supports more than one dimension in the data. 
/// A SampledData provides a concise way to handle the data produced by devices that sample a particular physical state at a high frequency. 
/// A typical use for this is for the output of an ECG or EKG device. 
/// The data type includes a series of raw decimal values (which are mostly simple integers), 
/// along with adjustments for scale and factor.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// SimpleQuantity
/// <p>
/// Zero value and units.
Property origin As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "origin", XMLPROJECTION = "ELEMENT") [ Required ];

/// decimal
/// <p>
/// Number of milliseconds between samples.
Property period As %Decimal(XMLNAME = "period", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// decimal
/// <p>
/// Multiply data by this before adding to origin.
Property factor As %Decimal(XMLNAME = "factor", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Lower limit of detection.
Property lowerLimit As %Decimal(XMLNAME = "lowerLimit", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Upper limit of detection.
Property upperLimit As %Decimal(XMLNAME = "upperLimit", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Number of sample points at each time point.
Property dimensions As %Integer(XMLNAME = "dimensions", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Decimal values with spaces, 
/// or "E" | "U" | "L"
Property data As %String(MAXLEN = 1000000, XMLNAME = "data", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SampledData";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SampledData";

}

/// Unique Device Identifier (UDI) Barcode string.
Class HS.FHIR.DTL.vSTU3.Model.Element.Device.udi Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Mandatory fixed portion of UDI.
Property deviceIdentifier As %String(MAXLEN = 1000000, XMLNAME = "deviceIdentifier", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Device Name as appears on UDI label.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Regional UDI authority.
Property jurisdiction As %String(MAXLEN = 1000000, XMLNAME = "jurisdiction", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// UDI Human Readable Barcode String.
Property carrierHRF As %String(MAXLEN = 1000000, XMLNAME = "carrierHRF", XMLPROJECTION = "ATTRIBUTE");

/// base64Binary
/// <p>
/// UDI Machine Readable Barcode String.
Property carrierAIDC As %Binary(XMLNAME = "carrierAIDC", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// UDI Issuing Organization.
Property issuer As %String(MAXLEN = 1000000, XMLNAME = "issuer", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// barcode | rfid | manual +
/// <p>
/// udi-entry-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend udi-entry-type and you may NOT use codes from other ValueSets.
Property entryType As %String(MAXLEN = 1000000, XMLNAME = "entryType", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Device.udi";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Device.udi";

}

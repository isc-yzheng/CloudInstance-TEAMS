Class HS.Types.PatientInfo Extends (%RegisteredObject, HS.Types.PersonInfo, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Additional patient information
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

/// Facility for this patient info
Property Facility As HS.Types.Facility;

/// Assigning Authority for the MRN - temporarily updating the MAXLEN to support PIX / PDQ transformation to Request with a post conversion to the code
Property AssigningAuthority As %String(MAXLEN = 512);

/// This patient's MRN (from the above assigning authority)
Property MRN As HS.Types.MRN;

/// The master/patient index id
Property MPIID As %String;

///  Other identifiers with assigning authority
Property Identifiers As list Of HS.Types.Identifier(STORAGEDEFAULT = "list");

/// Extension class for custom properties
Property Extension As HS.Local.SDA3.PatientExtension;

/// To allow arbitrary custom data to be added - this specifies a classname, whose object contents
/// will be serialed into CustomXMLString
Property CustomClassName As %String(MAXLEN = 64);

/// If a CustomClassName is used, this should represent the XML export of an object of that class.
/// The top tag should be "CustomXML"
Property CustomXMLString As %String(MAXLEN = "");

}

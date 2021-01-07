Include %soap

/// Implementation of Australian E-health XML secured payload profiles.
/// Document ATS 5821-2010
Class HS.AU.SMD.SignedPayloadDataType Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/SignedPayload/2010";

Parameter XMLPREFIX = "sp";

Property Content As HS.AU.SMD.BaseDataType(XMLNAME = "content", XMLREF = 1, XMLTYPECONSTRAINT = "choice") [ Required ];

Property ID As %String(MAXLEN = "", XMLNAME = "id", XMLPROJECTION = "attribute") [ Required ];

/// Create a new signedPayloadData with id set.
ClassMethod Create() As HS.AU.SMD.EncryptedPayloadDataType
{
	Set signedPayloadData=..%New()
	If signedPayloadData.ID="" {
		If $$$CheckSOAPTestMode {
			Set signedPayloadData.ID="id-payload"
		} Else {
			Set signedPayloadData.ID="Id-"_$system.Util.CreateGUID()
		}
	}
	Quit signedPayloadData
}

}

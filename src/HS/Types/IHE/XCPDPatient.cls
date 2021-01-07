Class HS.Types.IHE.XCPDPatient Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property HomeCommunityId As %String(MAXLEN = 73);

Property PatientId As %String(MAXLEN = "");

Property AdditionalInfo As array Of %String(MAXLEN = 1024, XMLPROJECTION = "NONE");

}

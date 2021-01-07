Class HS.Types.IHE.XCPDPatients Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Patients As list Of HS.Types.IHE.XCPDPatient;

}

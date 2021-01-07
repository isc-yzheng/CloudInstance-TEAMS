/// Generic mapping of status values
Class HS.Types.IHE.Status Extends %String
{

Parameter VALUELIST = ",Approved,Deprecated,Submitted";

Parameter DISPLAYLIST = ",urn:oasis:names:tc:ebxml-regrep:StatusType:Approved,urn:oasis:names:tc:ebxml-regrep:StatusType:Deprecated,urn:oasis:names:tc:ebxml-regrep:StatusType:Submitted";

Parameter XMLNAME = "status";

Parameter XMLPROJECTION = "ATTRIBUTE";

Parameter XMLLISTPARAMETER = "DISPLAYLIST";

}

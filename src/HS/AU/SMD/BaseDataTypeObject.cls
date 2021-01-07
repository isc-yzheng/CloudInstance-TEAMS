/// Implementation of Australian E-health XML secured payload profiles.
/// Document ATS 5821-2010
/// Abstract super class of all data which may be signed.
Class HS.AU.SMD.BaseDataTypeObject Extends HS.AU.SMD.BaseDataType
{

Parameter XMLNAME;

Property Content As %Stream.GlobalCharacter(XMLPROJECTION = "content");

}

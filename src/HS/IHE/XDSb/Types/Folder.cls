Class HS.IHE.XDSb.Types.Folder Extends ObjectRef [ Inheritance = right ]
{

Parameter XMLIGNORENULL = "INPUTONLY";

Property AvailabilityStatus As HS.Types.IHE.Status(XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

Property CodeList As list Of HS.IHE.XDSb.Types.CodedValue(XMLPROJECTION = "ELEMENT");

Property Comments As %String(MAXLEN = "");

Property LastUpdateTime As %String(MAXLEN = "");

Property PatientId As %String(CONTENT = "ESCAPE", MAXLEN = "");

Property Title As %String(MAXLEN = "");

Property UniqueId As %String(MAXLEN = "");

Property Version As %String;

}

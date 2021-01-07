Class HS.Types.AuthorizationInfo Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.ObjectDataModel) [ Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Who authorized this request
Property AuthBy As %String(MAXLEN = "", ZENHIDDEN = 1);

/// What type of authorization request Verbal, Written etc.
Property AuthType As %String(MAXLEN = "", ZENHIDDEN = 1);

/// What is the reason for issuing a break the glass
Property BTGReason As %String(MAXLEN = "", ZENHIDDEN = 1);

}

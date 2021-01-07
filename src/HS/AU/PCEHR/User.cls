/// Created from: /schema/common/pcehr_commontypes.xsd
Class HS.AU.PCEHR.User Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock, SqlTableName = _User ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLNAME = "User";

Parameter XMLSEQUENCE = 1;

Property IDType As %String(MAXLEN = "", VALUELIST = ",HPII,PortalUserIdentifier,LocalSystemIdentifier", XMLNAME = "IDType") [ Required ];

Property ID As %String(MAXLEN = "", XMLNAME = "ID") [ Required ];

Property Role As %String(MAXLEN = "", XMLNAME = "role");

Property UserName As %String(MAXLEN = "", XMLNAME = "userName") [ Required ];

Property UseRoleForAudit As %Boolean(XMLNAME = "useRoleForAudit") [ Required ];

}

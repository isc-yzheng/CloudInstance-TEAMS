/// Created from: /schema/common/pcehr_commontypes.xsd
Class HS.AU.PCEHR.AccessingOrganisation Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLNAME = "accessingOrganisation";

Parameter XMLSEQUENCE = 1;

Property OrganisationID As %String(MAXLEN = "", XMLNAME = "organisationID") [ Required ];

Property OrganisationName As %String(MAXLEN = "", XMLNAME = "organisationName") [ Required ];

Property AlternateOrganisationName As %String(MAXLEN = "", XMLNAME = "alternateOrganisationName");

}

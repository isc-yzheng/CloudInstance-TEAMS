/// Moved properties to base class HS.IHE.XUA.SAMLData due to inability to easily support SerialObject Polymorphism
Class HS.AU.PCEHR.SecurityHeader.Data Extends HS.IHE.XUA.SAMLData
{

Property IDType As %String(MAXLEN = "", VALUELIST = ",HPII,PortalUserIdentifier,LocalSystemIdentifier") [ InitialExpression = "HPII" ];

Property ClientSystemType As %String(MAXLEN = "", VALUELIST = ",CIS,CSP,CRP,HI,Medicare,CPP,CCP,Other") [ InitialExpression = "CIS" ];

/// Deprecated us HSRoles from SAMLData
Property Role As %String;

Storage Default
{
<Type>%Storage.Serial</Type>
}

}

Class HS.Types.FacilityInfo Extends (%RegisteredObject, HS.Util.DataModel.Adaptor, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Name of this facility
/// Displayed to the user, e.g. St Lukes Hospital, Windsor
Property Name As %String(MAXLEN = 256);

/// "Coded" value for the facility, as sent by the Gateway
/// A unique value for the whole HealthShare network
/// e.g. STLW
Property FacilityCode As %String(MAXLEN = 256);

/// Facility description
/// Free text description of the facility to display to the user
/// e.g. St Lukes Hospital, 1 George Street, Windosr, MA 10213, USA
Property Description As %String(MAXLEN = "");

/// Contact
Property Contact As HS.Types.Contact;

/// MPI's ID for the facility
/// The ID used by the MPI (e.g. Quadramed or Initiate) which may
/// be different from the HealthShare FacilityCode
/// e.g. ST001
Property FacilityId As %String(MAXLEN = 256, ZENREADONLY = 0);

Property GatewayName As %String(MAXLEN = 256, ZENHIDDEN = 1);

Property ConsentGroup As %String(MAXLEN = "");

Property IPAddresses As list Of %String(MAXLEN = "", STORAGEDEFAULT = "array");

Property ExternalHIE As %Boolean [ InitialExpression = 0 ];

/// OID property is not used - this is leftover from a very early version
/// The facility's OID is stored in the OID registry (HS.Data.OIDMap).
Property OID As %String(MAXLEN = 64);

/// Roles (which includes consent groups) that this facility is allowed to assign
Property Roles As list Of %String(MAXLEN = 64);

/// For selecting the best patient record
Property Tier As %Integer;

/// Determines whether can records for this facility can be manually edited
Property HomeFacility As %Boolean;

/// Whether this facility will serve as an assigning authority
Property AssigningAuthority As %Boolean;

/// If true updates from HSPD will not change contact information
Property IgnoreProviderUpdates As %Boolean;

}

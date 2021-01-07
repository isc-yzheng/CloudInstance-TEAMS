Class HS.Types.GatewayInfo Extends (%RegisteredObject, HS.Util.DataModel.Adaptor, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Gateway name, e.g. philhp:HSGATEWAY (MAXLEN consistent with HSComponentName now)
Property Name As %String(MAXLEN = 320);

/// Gateway endpoint (the web service URL)
/// e.g. http://philhp:57773/csp/hsgateway/ensemble/HS.Gateway.WebServices.cls
Property EndPoint As HS.Types.EndPoint(ZENREADONLY = 1);

Property OID As %String(MAXLEN = 64);

/// Gateway status
/// R = Registered   : The Gateway is running
/// U = Unregistered : The Gateway is stopped (not currently implemented)
/// D = Disabled     : The Gateway is disabled 
/// NQ = NotifyQuery : Notify and Query Gateway Reset flag
Property Status As %String(DISPLAYLIST = ",Registered,Unregistered,Disabled,NotifyQuery", VALUELIST = ",R,U,D,NQ", ZENHIDDEN = 1);

/// Gateway Type.  As of version 10, the Hub/Registry is also treated as a gateway
Property Type As %String(DISPLAYLIST = ",Edge,Access,Bus,Registry,Flash", VALUELIST = ",E,A,B,R,F", ZENREADONLY = 1);

/// no longer used, replaced by CacheType
Property ConsumeAndForward As %Boolean;

/// see HS.Util.AbstractEdgeProduction
Property CacheType As %String;

/// This property is set by the gateway registration request, based on a production setting
Property FeedAnalytics As %Boolean;

/// The HealthShare (HSCORE) version for this gateway
Property Version As %String;

}

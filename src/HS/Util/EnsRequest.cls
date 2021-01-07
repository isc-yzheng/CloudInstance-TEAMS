Include HS.Upgrade

/// Base class for HealthShare Ensemble Requests
Class HS.Util.EnsRequest Extends Ens.Request
{

/// If XMLIGNOREINVALIDTAG is set = 1, then unexpected elements will be ignored.
/// We use this to allow our web services to be extensible and to work across version boundaries.
/// With this set to one, we can, for instance, update the hub/registry to a new version, where some of the
/// xml messages have new properties, and have that communicate with a gateway running a previous version,
/// where the properties aren't there.
Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// If XMLIGNORENULL is set = "inputonly", then both missing tags in the XML and empty
/// strings are input as "".  Output of "" and $c(0) are for XMLIGNORENULL = 0:
/// $c(0) is output as an empty tag (i.e. &lt;tag&gt;&lt;/tag&gt;) and "" is output as no tag.<br><br>
Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

Property HSCoreVersion [ InitialExpression = {$S($D(^|"HSLIB"|rINC("hslibBuild")):+($parameter("HS.Util.Installer","Version")_"."_$parameter("HS.Util.Installer","MaintenanceVersion")),1:"")} ];

/// Can be set by a new service to allow the web client to not attempt to invoke a service that
/// doesn't exist on a gateway running an older version
Property HSMinVersion;

/// Comma-delimited list of the properties to be cleared
Property %ClearFields As %String(MAXLEN = "");

Storage Default
{
<Data name="EnsRequestDefaultData">
<Subscript>"EnsRequest"</Subscript>
<Value name="1">
<Value>HSCoreVersion</Value>
</Value>
<Value name="2">
<Value>HSMinVersion</Value>
</Value>
<Value name="3">
<Value>%ClearFields</Value>
</Value>
</Data>
<DefaultData>EnsRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

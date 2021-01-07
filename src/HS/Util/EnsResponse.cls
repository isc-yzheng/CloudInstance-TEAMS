Include HS.Upgrade

/// Base class for HealthShare Ensemble Responses
Class HS.Util.EnsResponse Extends Ens.Response
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

/// Can be set by the web client when attempting to invoke a service on a gateway running on a version that's too old
Property HSMinVersionError As %Boolean;

Storage Default
{
<Data name="EnsResponseDefaultData">
<Subscript>"EnsResponse"</Subscript>
<Value name="1">
<Value>HSCoreVersion</Value>
</Value>
<Value name="2">
<Value>HSMinVersionError</Value>
</Value>
</Data>
<DefaultData>EnsResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

Class HS.Util.Installer.Kit.EnsembleActivityMonitor Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String;

ClassMethod AddOperation() As %Status
{
	try {
		Set tSC=$$$OK
		Quit:$System.Version.GetMajor()<2016  //only supported starting with 2016.1
		Set tSC= ..ProductionMods(,"EnsembleItems",1) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData EnsembleItems
{
<Items>
  <Item Name="Ens.Activity.Operation.Local" Category="" ClassName="Ens.Activity.Operation.Local" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

}

Class HS.Sync.Tracker.Hub Extends (%Persistent, %XML.Adaptor)
{

Property Version As %String [ Required ];

Property HighTx As %Integer [ Required ];

Index VersionIndex On Version [ Data = HighTx, Unique ];

ClassMethod OnInstall(pNamespace = "HSREGISTRY", pIsUpgrade = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		New $namespace
		Set $namespace = pNamespace
		$$$ThrowOnError(##class(%ZHSLIB.HealthShareMgr).ComponentVersion("HSLIB",.tVersion))
		Set tMajorMinor = $P(tVersion,".",1,2)
		If '..VersionIndexExists(tMajorMinor) {
			Set tHubTracker = ..%New()
			Set tHubTracker.Version = tMajorMinor
			Set tHubTracker.HighTx = $S(pIsUpgrade:$G(^OBJ.JournalT,0),1:0)
			$$$ThrowOnError(tHubTracker.%Save())
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get transactions on hub versions
/// 	pVersions(<version>) = <tx>
///   pHubVersion = <current hub version>
ClassMethod GetHubVersions(Output pVersions, Output pHubVersion As %String) As %Status
{
	Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT Version,HighTx FROM HS_Sync_Tracker.Hub")
	While tRS.%Next() {
		#; Ensure numeric array index for proper sort order (since 16.0 is really string "16.0" while 16.01 is numeric as expected)
		If tRS.Version]"",tRS.HighTx]"" Set pVersions(+tRS.Version) = tRS.HighTx
	}
	Set pHubVersion = $O(pVersions(""),-1)
	Quit $$$OK
}

Storage Default
{
<Data name="HubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Version</Value>
</Value>
<Value name="3">
<Value>HighTx</Value>
</Value>
</Data>
<DataLocation>^HS.Sync.Tracker.HubD</DataLocation>
<DefaultData>HubDefaultData</DefaultData>
<IdLocation>^HS.Sync.Tracker.HubD</IdLocation>
<IndexLocation>^HS.Sync.Tracker.HubI</IndexLocation>
<StreamLocation>^HS.Sync.Tracker.HubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

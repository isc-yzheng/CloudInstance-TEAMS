Include (%occStatus, HS.FHIRServer)

Class HS.FHIRServer.Util.DeviceStream Extends %Stream.Object
{

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	$$$ThrowStatus( $$$ERROR($$$NotImplemented) )
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
}

Method %OnReload() As %Status [ Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

Method Write(data As %CacheString) As %Status
{
	Write data
	QUIT $$$OK
}

Method WriteLine(data As %CacheString = "") As %Status
{
	Write data,!
	QUIT $$$OK
}

Method Read(ByRef len As %Integer = 32656, ByRef sc As %Status) As %CacheString
{
	$$$ThrowStatus( $$$ERROR($$$NotImplemented) )
}

Method ReadLine(ByRef len As %Integer = 32000, ByRef sc As %Status, ByRef eol As %Boolean) As %CacheString
{
	$$$ThrowStatus( $$$ERROR($$$NotImplemented) )
}

Method ReadLineIntoStream(ByRef sc As %Status) As %Stream.Object
{
	$$$ThrowStatus( $$$ERROR($$$NotImplemented) )
}

}

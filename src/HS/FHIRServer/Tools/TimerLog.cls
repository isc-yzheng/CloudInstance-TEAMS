Include HS.FHIRServer

Class HS.FHIRServer.Tools.TimerLog Extends %RegisteredObject
{

Property startTime As %Numeric;

Property description As %String;

Method %OnNew(description As %String, showStart As %Boolean = 0) As %Status
{
	Set ..startTime = $ZHOROLOG
	Set ..description = description
	if showStart {
		$$$FSLog("Begin: " _ description)
	}
	return $$$OK
}

Method Complete(result As %String = "")
{
	if ..startTime {
	    Do ..log($S(result'="":result_": ", 1:"Complete: "))
		set ..startTime = 0		
	}
}

Method Progress(msg As %String = "")
{
	if ..startTime {
	    Do ..log(msg_": ")
	}
}

Method log(prefix) [ Private ]
{
	if ..startTime {
		$$$FSLog(prefix _ ..description _ " after " _ ($ZH - ..startTime) _ " secs.")
	}
}

/// This method ensures that the %Lock is released, if present,
/// when this object goes out of scope
Method %OnClose() As %Status [ Private, ServerOnly = 1 ]
{
    Set tSC = $$$OK
    Do ..log("Exit: ")
    Quit tSC
}

}

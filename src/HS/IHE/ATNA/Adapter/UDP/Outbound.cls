Class HS.IHE.ATNA.Adapter.UDP.Outbound Extends Ens.OutboundAdapter [ Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter SETTINGS = "UDPHost,UDPPort";

Parameter MAXSIZE = 32768;

/// You can specify an IPv4 address (172.16.61.196), or
/// an IPv6 address (::1), or a host name
/// To find your local host name, for testing, you can Write $SYSTEM.INetInfo.LocalHostName()
Property UDPHost As %String [ InitialExpression = "127.0.0.1" ];

Property UDPHostAddress As %String(MAXLEN = 128);

Property UDPPort As %Integer [ InitialExpression = 3001 ];

Property Client As %Net.UDP [ Private ];

Method OnInit() As %Status
{
	#dim eOnInit As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set ..Client = ##class(%Net.UDP).%New(,,,..#MAXSIZE)
		If '$IsObject(..Client) Set tStatus = $$$ERROR($$$GeneralError,"failed to init")
		Set ..UDPHostAddress=..Client.GetHostAddr(..UDPHost)
	}
	Catch eOnInit {
		Set tStatus = eOnInit.AsStatus()
	}
	
	Quit tStatus
}

Method SendMessageString(pString As %String = "") As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set tLen= ..Client.Send(pString,..UDPHostAddress,..UDPPort)
		If 'tLen,pString="" Set tStatus=$$$EnsError("Sent UDP to: "_..UDPHost_" "_..UDPPort_" but sent 0 characters")
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

}

Class HS.IHE.ATNA.Adapter.UDP.Inbound Extends Ens.InboundAdapter [ Inheritance = right, ProcedureBlock ]
{

Parameter SERVICEINPUTCLASS = "Ens.StringContainer";

Parameter MAXSIZE = 32768;

Parameter SETTINGS = "UDPPort";

Parameter OpeningTag = "<AuditMessage";

Parameter ClosingTag = "</AuditMessage>";

Property UDPPort As %Integer [ InitialExpression = 3001 ];

Property Client As %Net.UDP [ Private ];

Method OnInit() As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set ..Client = ##class(%Net.UDP).%New(..UDPPort,,5,,..#MAXSIZE)
		If '$IsObject(..Client) Set tStatus = $$$ERROR($$$GeneralError,"failed to init")
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

Method OnTask() As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set tAuditString = ..Client.Recv(5) //5 second loop timeout
		If tAuditString="" {
			Set ..BusinessHost.%WaitForNextCallInterval = 1 Quit
		}
		Set ..BusinessHost.%WaitForNextCallInterval = 0
		If tAuditString '[ ..#OpeningTag {
			Set tStatus = $$$ERROR($$$GeneralError, "Opening tag '" _ ..#OpeningTag _ "' not found in message")
			Quit
		}
		If $P(tAuditString,..#OpeningTag,2,999)'[..#ClosingTag {
			Set tStatus = $$$ERROR($$$GeneralError, "Closing tag '" _ ..#ClosingTag _ "' not found in message")
			Quit
		}
		Set tRequest = ##class(HS.Message.IHE.ATNA.InboundSubmission).%New(tAuditString,$system.INetInfo.AddrToHostName(..Client.LastAddr))
		Set tStatus = ..BusinessHost.ProcessInput(tRequest, .tResponse)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

}

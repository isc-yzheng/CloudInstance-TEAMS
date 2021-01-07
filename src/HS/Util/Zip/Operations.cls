Class HS.Util.Zip.Operations Extends (HS.HC.Util.Trace.Helper, Ens.BusinessOperation) [ Inheritance = right, ProcedureBlock ]
{

Parameter DOMAIN = "HS";

Parameter ADAPTER = "HS.Util.Zip.Adapter";

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.ZipRequest"> 
		<Method>ZipRequest</Method>
	</MapItem>

</MapItems>
}

Method ZipRequest(pRequest As HS.Message.ZipRequest, Output pResponse As HS.Message.ZipResponse) As %Status
{
	If (##class(HS.Registry.Config).GetKeyValue("\ZipUtility\ZipCommand")="") || (##class(HS.Registry.Config).GetKeyValue("\ZipUtility\UnZipCommand")="") {
		Quit $$$ERROR($$$GeneralError,$$$Text("Zip Configuration is not configured, please define config registry entries \ZipUtility\ZipCommand and \ZipUtility\UnZipCommand"))
	}
	If pRequest.Operation="ToZip" {
		Quit ..Adapter.Zip(pRequest,.pResponse)
	} ElseIf pRequest.Operation="FromZip" {
		Quit ..Adapter.UnZip(pRequest,.pResponse)
	}
	Quit $$$ERROR($$$GeneralError,"Unknown Operation")
}

/// This user callback method is called via initConfig() from %OnNew() 
Method OnInit() As %Status
{
	If (##class(HS.Registry.Config).GetKeyValue("\ZipUtility\ZipCommand")="") || (##class(HS.Registry.Config).GetKeyValue("\ZipUtility\UnZipCommand")="") {
		$$$LOGERROR($$$Text("Zip Configuration is not configured, please define config registry entries \ZipUtility\ZipCommand and \ZipUtility\UnZipCommand"))
	}
	Quit $$$OK
}

}

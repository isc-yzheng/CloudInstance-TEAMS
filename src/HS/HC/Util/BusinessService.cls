/// HS.HC.BusinessService is a simple business service for directing a specified request message to a specified business host.
Class HS.HC.Util.BusinessService Extends Ens.BusinessService
{

/// @API<br>
/// Send a request synchronously to the specified target dispatch name (i.e., another Interoperability
/// host in the current production for the current namespace) and receive and return the response.<br>
/// <br>
/// @Input pTargetDispatchName (required) Config item name of an Interoperability business host.<br>
/// @Input pRequest (required) Interoperability based request message.<br>
/// @Output pResponse Interoperability based response message.<br>
/// @Input pTimeout Timeout.<br>
/// @Input Description Request text description.<br>
/// @Output pSessionId Message processing session id.
ClassMethod SendSync(pTargetDispatchName As %String, pRequest As Ens.Request, ByRef pResponse As Ens.Response, pTimeout As %Numeric = -1, pDescription As %String = "", ByRef pSessionId) As %Status
{
	Set pSessionId = ""
	
	If $Get(pTargetDispatchName)="" {
		Quit $$$ERROR($$$GeneralError, "Target dispatch name not specified")
	} ElseIf '$IsObject($Get(pRequest)) {
		Quit $$$ERROR($$$GeneralError, "Request object not specified")
	}
	
	#dim tService As Ens.BusinessService
	
	Set tSC = ##class(Ens.Director).CreateBusinessService($ClassName(), .tService)
	
	If $$$ISOK(tSC) {
		Set tSC = tService.SendRequestSync(pTargetDispatchName, pRequest, .pResponse, pTimeout, pDescription)
		
		Set pSessionId = tService.%SessionId
	}
	
	Quit tSC
}

}

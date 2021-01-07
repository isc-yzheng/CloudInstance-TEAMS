Class HS.Test.BusinessService Extends Ens.BusinessService
{

/// Use this method to dispatch an Ensemble business invocation synchronously
Method SendRequestSync(pTargetDispatchName As %String, pRequest As %Library.Persistent, ByRef pResponse As %Library.Persistent, pTimeout As %Numeric = -1, pDescription As %String = "") As %Status
{
	$$$sysTRACE("call to "_pTargetDispatchName)
	Set tTimeCalled=$ZH
	Set tTargetConfigName = $G($$$DispatchNameToConfigName(pTargetDispatchName))  Quit:""=tTargetConfigName $$$EnsError($$$EnsErrBusinessDispatchNameNotRegistered,pTargetDispatchName)
	Set tTargetBusinessClass = $$$ConfigClassName(tTargetConfigName)
	Set tSessionId = ..%SessionId
	Set:$IsObject(..%RequestHeader)&&(""=..%RequestHeader.TimeCreated) tRequestHeader=..%RequestHeader
	$$$SyncCommitSet(tSyncCommit)
	Set tSC=$classmethod(tTargetBusinessClass,"acceptRequestSync",..%ConfigName,tTargetConfigName,.pRequest,.pResponse,.tSessionId,pTimeout,.tRequestHeader,pDescription)
	$$$SyncCommitClear(tSyncCommit)
	Set (..%SessionId,$$$JobSessionId)=tSessionId
	If ($IsObject($Get(pResponse)))&&(pResponse.%IsA("HS.Message.FHIR.Base")) {
		// Since all legacy FHIR code that calls ..SendSync (which calls this method)
		// looks for the .Payload property for the payload content, move the content
		// back to .Payload, clear the QuickStream, and blank out QuickStreamId.
		If ('pResponse.Payload.Size)&&(pResponse.QuickStreamId'="") {
			Set tQStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
			If $IsObject(tQStream) {
				Do pResponse.Payload.CopyFrom(tQStream)
				Do tQStream.Clear()
			}
			Set pResponse.QuickStreamId = ""
		}
	}
	If $$$ISOK(tSC) {
		Set ..%RequestHeader=tRequestHeader, $$$JobCurrentHeaderId=tRequestHeader.%Id()
	}
	$$$catTRACE("timing","duration of sync call: "_($ZH-tTimeCalled))
	Quit tSC
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Accepts objects of type Ens.StreamContainer and saves the encapsulated stream data to a file using the File OutboundAdapter.
Class EnsLib.File.PassthroughOperation Extends Ens.BusinessOperation [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

/// Name of file to output the document(s) to. May include timestamp specifiers. The %f specifier if present will be 
/// replaced with the name of the document's original source filename (stripped of characters illegal in target filenames).<p>
/// See the method Ens.Util.File.CreateTimestamp() for documentation of timestamping options.
Property Filename As %String(MAXLEN = 1000, MINLEN = 1) [ InitialExpression = "%f_%Q%!+(_a)", Required ];

Parameter SETTINGS As %String = "Filename:Basic";

Method OnMessage(pRequest As Ens.StreamContainer, Output pResponse As %Persistent) As %Status
{
	Quit:'$IsObject(pRequest.Stream) $$$ERROR($$$EnsErrGeneral,"No Stream contained in StreamContainer Request")
	If "@"'=$E(..Adapter.FilePath) {
		Set tFilename=..Adapter.CreateFilename(##class(%File).GetFilename(pRequest.OriginalFilename),..Filename)
		Set tSC=..Adapter.PutStream(tFilename, pRequest.Stream)
		Do pRequest.%Save() ; re-save in case PutStream() optimization changed the Stream filename
	} Else {
		#; Forward to agent
		If pRequest.Stream.%Extends("%Library.FileStreamAdaptor") {
			#; copy to a global stream in a new container
			Set tStream=##class(%FileBinaryStream).%New()
			Merge tStream.Attributes=pRequest.Stream.Attributes
			Set tSC=tStream.CopyFrom(pRequest.Stream)
			Set tSC=tStream.SaveStream()  Quit:$$$ISERR(tSC) tSC
			Set tMsg=##class(Ens.StreamContainer).%New(tStream)
		} Else {
			Set tMsg=pRequest
		}
		Set tFilename=##class(Ens.Util.File).CreateTimestamp(##class(%File).GetFilename(pRequest.OriginalFilename),..Filename)
		Set tAgent=$P(..Adapter.FilePath,":"), tTimeout=+$P(tAgent,"(",2), tAgent=$P(tAgent,"(")  Set:'tTimeout tTimeout=-1
		Set tSC=..EnQueueToService(tAgent,tMsg,..%RequestHeader,,tFilename) ; !!! Sync(...,,tTimeout,..%RequestHeader.Description)
	}
	Quit tSC
}

ClassMethod EnQueueToService(pTargetQueueName As %String, pRequest As %RegisteredObject, pOriginalHeader As Ens.MessageHeader, Output pNewHeader As Ens.MessageHeader, pDescription As %String = "") As %Status [ Internal ]
{
	Set tSC = ##class(Ens.MessageHeader).NewRequestMessage(.pNewHeader,pRequest,pOriginalHeader.SessionId) Quit:$$$ISERR(tSC) tSC
	Set pNewHeader.CorrespondingMessageId = pOriginalHeader.%Id()
	Set pNewHeader.SourceConfigName = pOriginalHeader.TargetConfigName
	Set pNewHeader.TargetConfigName = $P(pTargetQueueName,":")
	Set pNewHeader.SourceBusinessType = $$$eHostTypeOperation
	Set pNewHeader.TargetBusinessType = $$$eHostTypeService
	Set pNewHeader.TargetQueueName = pTargetQueueName
	Set pNewHeader.Description = pDescription
	Quit ##class(Ens.Queue).EnQueue(pNewHeader)
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("FilePath",.tValue) {
		If "@"=$E(tValue) {
			Set tAgent=$E($P(tValue,":"),2,*)
			#; if agent package is installed, call it to find the appropriate agent Service connection.
			try {
				Set tSC=$classmethod("EnsLib.Agent.Interface","GetAgentService",tAgent,pItem.Name,.tAgentService)
				Set:""'=tAgentService&&$$$ISOK(tSC) pArray(tAgentService)=""
			} catch {  }
		}
	}
}

}

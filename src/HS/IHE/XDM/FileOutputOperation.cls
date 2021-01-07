/// Accepts objects of type Ens.StreamContainer and saves the encapsulated stream data to a file using the File OutboundAdapter.
Class HS.IHE.XDM.FileOutputOperation Extends (Ens.BusinessOperation, HS.Util.BaseHost, HS.HC.Util.Trace.Helper) [ ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

/// Output zip file as a "XDM_"_$tr($zdatetime($zts,3,3,3)," :.PM-","_")_".zip"
/// Output file set into pRequest.FilePath directory or into generated directory with timestamp
Method OnMessage(pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest, Output pResponse As HS.Message.IHE.XDM.DistributeDocumentSetResponse) As %Status
{
	try {
		Set pResponse=##class(HS.Message.IHE.XDM.DistributeDocumentSetResponse).%New(),tSC=$$$OK
		
		Set tSavePath = ..Adapter.FilePath
		Set tBasePath = $s(pRequest.FilePath]"":pRequest.FilePath, 1:..Adapter.FilePath_$tr($zdatetime($now(),8,9,3)," :","_"))
		if pRequest.Files.Items.Count() {
			For tIdx=1:1:pRequest.Files.Items.Count() {
				Set tItem=pRequest.Files.Items.GetAt(tIdx)
				Set tDirectory = ##class(%File).NormalizeDirectory(tBasePath _"/"_tItem.Path)
				Set tSC = ..SetAdapterFilePath(tDirectory)
				$$$HSTRACE("Writing item to file", "tBasePath, ..Adapter.FilePath, tDirectory, tItem, tSC", tBasePath, ..Adapter.FilePath, tDirectory, tItem, tSC)
				Quit:$$$ISERR(tSC)
				Set tSC=..Adapter.PutStream(tItem.Filename, tItem.File)
			}
		} Else {
			Set tFilename= "XDM_"_$tr($zdatetime($zts,3,3,3)," :.PM-","_")_".zip"
			Set tSC = ..SetAdapterFilePath(tBasePath)
			$$$HSTRACE("Writing to single file", "tBasePath, tFilename, tSC", tBasePath, tFilename, tSC)
			Quit:$$$ISERR(tSC)
			Set tSC=..Adapter.PutStream(tFilename, pRequest.Files.File)
		}
		Set ..Adapter.FilePath=tSavePath
	} catch ex {
		Set tSC=ex.AsStatus()
		$$$HSTRACE("Caught exception", "ex, tSC", ex, tSC)
	}
	Set pResponse.Status=tSC
	Quit $$$OK
}

Method SetAdapterFilePath(pDirectory) [ Private ]
{
	Set tExists = ##class(%File).DirectoryExists(pDirectory)
	If '##class(%File).DirectoryExists(pDirectory) { 
		Set tSC = ##class(%File).CreateDirectoryChain(pDirectory)
	} else {
		Set tSC = $$$OK
	}
	Quit:$$$ISERR(tSC)
	Set ..Adapter.FilePath = pDirectory
	quit tSC
}

}

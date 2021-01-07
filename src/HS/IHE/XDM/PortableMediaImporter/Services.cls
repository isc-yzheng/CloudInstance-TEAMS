/// Allows import of XDM ZIP Archives. Converts XDM into XDR.
Class HS.IHE.XDM.PortableMediaImporter.Services Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Parameter SETTINGS = "FileSpec,-ConfirmComplete,-SubdirectoryLevels,ImporterProcess:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// The ZIP file stream will be sent to the Zip Operation to uncompress the files
Property ImporterProcess As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDM.PortableMediaImporter.Process" ];

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	try {
		If pInput.%IsA("%Stream.Object") {
			Set tRequest = ##class(HS.Message.ZipRequest).%New()
			Set tRequest.File = pInput.%ConstructClone()
			Set tRequest.Operation="FromZip"
		} Else {
			Set tRequest = pInput
		}
		
	//		set tRequest = ##class(HS.Message.XMLMessage).%New()
	//	set tRequest.ContentStream = pInput.%ConstructClone()
		
		set tSC = ..SendRequestAsync(..ImporterProcess,tRequest)
		
	} catch eException {
		#dim eException as %Exception.StatusException
		$$$LOGERROR(eException.DisplayString())	
		
	}
	
	Quit $$$OK
}

ClassMethod GetFiles(pDirectory = "", pProcess = "HS.IHE.XDM.PortableMediaImporter.Process") As %Status
{
	Set tSC = ##class(Ens.Director).CreateBusinessService(..%ClassName(1),.tService)
	Quit:$$$ISERR(tSC) tSC
	Set tRequest = ##class(HS.Message.ZipRequest).%New()
	Set tSC = ##class(HS.Util.Zip.Adapter).GetFiles(pDirectory,.tRequest,pDirectory)
	Quit:$$$ISERR(tSC) tSC
	Set tSC = tService.SendRequestAsync(pProcess,tRequest)
	Quit tSC
}

}

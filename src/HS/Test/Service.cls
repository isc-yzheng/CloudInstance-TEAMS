/// A simple test service which will take message objects and route to the appropriate operation.  AddUpdateHubRequest to the PIX Manager etc
Class HS.Test.Service Extends HS.Test.BusinessService [ ProcedureBlock ]
{

/// HealthShare Foundation 
Parameter FOUNDATION = 1;

/// Handle patient search requests of the PIX type (mrn & aa) 
Property PIXConsumerOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PIXv3.Consumer.Operations" ];

/// Handle patient search requests of the PDQ type [not mrn & aa unless AdditionalInfo.SetAt(1,"PDQ")]
Property PDQConsumerOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PDQv3.Consumer.Operations" ];

/// Handle AddUpdateHub request messages adding to PIX manager
Property SourceOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PIXv3.Source.Operations" ];

/// Handle XDSb Query / Retrieve requests
Property XDSbConsumerOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Consumer.Operations" ];

/// Handle XDSb Provide and register request
Property XDSbSourceOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.DocumentSource.Operations" ];

/// Handle XDSb Metadata update requests
Property XDSbAdministratorOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Administrator.Operations" ];

Property XDSbRegistryOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

/// Handle SearchAndFetchRequest for XDS.b PnR
Property AccessGatewayOperations As Ens.DataType.ConfigName [ InitialExpression = "GATEWAY" ];

Property ZipOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.Util.Zip.Operations" ];

Property MHDConsumerOperationsDSTU2 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.MHD.Consumer.Operations.DSTU2" ];

Property MHDConsumerOperationsSTU3 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.MHD.Consumer.Operations.STU3" ];

Property MHDSourceOperationsDSTU2 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.MHD.DocumentSource.Operations.DSTU2" ];

Property MHDSourceOperationsSTU3 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.MHD.DocumentSource.Operations.STU3" ];

Property PDQmConsumerOperationsDSTU2 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.PDQm.Consumer.Operations.DSTU2" ];

Property PDQmConsumerOperationsSTU3 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.PDQm.Consumer.Operations.STU3" ];

Property PIXmConsumerOperationsDSTU2 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.PIXm.Consumer.Operations.DSTU2" ];

Property PIXmConsumerOperationsSTU3 As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.PIXm.Consumer.Operations.STU3" ];

Property FHIRRESTOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIR.REST.Operation" ];

Parameter SETTINGS As %String = "PIXConsumerOperations,PDQConsumerOperations,XDSbConsumerOperations,SourceOperations,XDSbSourceOperations,XDSbAdministratorOperations,ZipOperations,AccessGatewayOperations,MHDConsumerOperationsDSTU2,MHDConsumerOperationsSTU3,MHDSourceOperationsDSTU2,MHDSourceOperationsSTU3,PDQmConsumerOperationsDSTU2,PDQmConsumerOperationsSTU3,PIXmConsumerOperationsDSTU2,PIXmConsumerOperationsSTU3,FHIRRESTOperations";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	Set tSC=""
	try {
		If pInput.AdditionalInfo.GetAt("Host")]"" {
			Set tSC=..SendRequestSync(pInput.AdditionalInfo.GetAt("Host"),pInput,.pOutput)
			Quit
		}
		If pInput.AdditionalInfo.GetAt("Operation")]"" {
			Set tSC=..SendRequestSync(pInput.AdditionalInfo.GetAt("Operation"),pInput,.pOutput)
		}
	} Catch ex {
	}
	Quit:tSC]"" tSC
	If (pInput.%Extends("HS.Types.RequestInfo"))||(pInput.%IsA("HS.Message.FHIR.Request")) {
		Set tFHIRActor = pInput.AdditionalInfo.GetAt("FHIRActor")
	} Else {
		Set tFHIRActor = ""
	}
	If tFHIRActor'="" {
		If tFHIRActor="MHDConsumerDSTU2" {
			Quit ..SendRequestSync(..MHDConsumerOperationsDSTU2,pInput,.pOutput)
		} ElseIf tFHIRActor="MHDConsumerSTU3" {
			Quit ..SendRequestSync(..MHDConsumerOperationsSTU3,pInput,.pOutput)
		} ElseIf tFHIRActor="MHDSourceDSTU2" {
			Quit ..SendRequestSync(..MHDSourceOperationsDSTU2,pInput,.pOutput)
		} ElseIf tFHIRActor="MHDSourceSTU3" {
			Quit ..SendRequestSync(..MHDSourceOperationsSTU3,pInput,.pOutput)
		} ElseIf tFHIRActor="PDQmConsumerDSTU2" {
			Quit ..SendRequestSync(..PDQmConsumerOperationsDSTU2,pInput,.pOutput)
		} ElseIf tFHIRActor="PDQmConsumerSTU3" {
			Quit ..SendRequestSync(..PDQmConsumerOperationsSTU3,pInput,.pOutput)
		} ElseIf tFHIRActor="PIXmConsumerDSTU2" {
			Quit ..SendRequestSync(..PIXmConsumerOperationsDSTU2,pInput,.pOutput)
		} ElseIf tFHIRActor="PIXmConsumerSTU3" {
			Quit ..SendRequestSync(..PIXmConsumerOperationsSTU3,pInput,.pOutput)
		}
	} ElseIf pInput.%IsA("HS.Message.AddUpdateHubRequest") {
		Quit ..SendRequestSync(..SourceOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.PatientSearchRequest") {
		If pInput.MRN]"" && (pInput.AssigningAuthority]"") && (pInput.AdditionalInfo.GetAt("PDQ")="") {
			Quit ..SendRequestSync(..PIXConsumerOperations,pInput,.pOutput)
		}
		Quit ..SendRequestSync(..PDQConsumerOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.IHE.XDSb.DeleteDocumentSetRequest") || pInput.%IsA("HS.Message.IHE.XDSb.UpdateDocumentSetRequest") {
		Quit ..SendRequestSync(..XDSbAdministratorOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.IHE.XDSb.QueryRequest") {
		Quit ..SendRequestSync(..XDSbConsumerOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.IHE.XDSb.RetrieveRequest") {
		Quit ..SendRequestSync(..XDSbConsumerOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.IHE.XDSb.ProvideAndRegisterRequest") {
		Quit ..SendRequestSync(..XDSbSourceOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.IHE.XDSb.RegisterRequest") {
		Quit ..SendRequestSync(..XDSbSourceOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.MergePatientRequest") {
		Quit ..SendRequestSync(..SourceOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.IDUpdateNotificationRequest") {
		Quit ..SendRequestSync(..XDSbRegistryOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.ZipRequest") {
		Quit ..SendRequestSync(..ZipOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.FHIR.Request") {
		Quit ..SendRequestSync(..FHIRRESTOperations,pInput,.pOutput)
	} ElseIf pInput.%IsA("HS.Message.SearchAndFetchRequest"){
		Quit ..SendRequestSync(..AccessGatewayOperations,pInput,.pOutput)
	}
	Quit $$$EnsError($$$EnsErrRequestNotHandled,pInput.%ClassName(1))
}

ClassMethod SendSync(pInput As Ens.Request, ByRef pOutput As Ens.Response, pTimeout As %Numeric = -1, ByRef pSessionId = "") As %Status
{
	#dim tSC As %Status
	#dim tService As Ens.BusinessService
	Set pSessionId=""
	Set tSC = ##class(Ens.Director).CreateBusinessService(..%ClassName(1),.tService)
	Set:$$$ISOK(tSC) tSC = tService.ProcessInput(pInput,.pOutput,pTimeout)
	Set pSessionId=tService.%SessionId
	Quit tSC
}

ClassMethod SendAsync(pInput As Ens.Request, ByRef pSessionId As %String) As %Status
{
	Quit ..CallProcessInputAsync(..%ClassName(1),pInput,.pSessionId)
}

ClassMethod GetResponse(pRequestId As %String, ByRef pResponse As Ens.Response, ByRef pStatus As %String, ByRef pSessionId As %String) As %Status
{
	#dim tSC As %Status
	If $System.Version.GetMajor()>= 2015 {
		// As of JGM081, SessionId returned by reference
		// This first appears in 2015.1
		Set tSC = ..CheckProcessInputAsyncStatus(pRequestId,.pResponse,.pSessionId)
	}
	Else {
		// Handle cases of earlier core technology versions
		Set tSC = ..CheckProcessInputAsyncStatus(pRequestId,.pResponse)
	}
	Set:$$$ISOK(tSC) pStatus=$S($IsObject(pResponse):"Done",1:"Waiting")
	Set:$$$ISERR(tSC) pStatus="Error"
	
	Quit tSC
}

/// Set tSC=##class(HS.Test.Service).SendFile("/wtemp/test.xml","urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b","HS.Util.SOAPClient.Operations","XDSb.Repository",.Response)
ClassMethod SendFile(pFilename As %String = "", pAction As %String = "", pOperation As %String = "", pServiceName As %String = "", ByRef pResponse As Ens.Response) As %Status
{
	try {
		If pAction="" Set tSC=$$$ERROR($$$GeneralError,"Action is required") Quit
		If pServiceName="" Set tSC=$$$ERROR($$$GeneralError,"ServiceName is required") Quit
		Set tFile=##class(%FileCharacterStream).%New()
		Set tSC= tFile.LinkToFile(pFilename) Quit:$$$ISERR(tSC)
		If tFile.Size=0 Set tSC = $$$ERROR($$$GeneralError,"File is empty") Quit
		Set tMessage=##class(HS.Message.XMLMessage).%New()
		Do tMessage.AdditionalInfo.SetAt(pServiceName,"ServiceName")
		Do tMessage.AdditionalInfo.SetAt(pOperation,"Operation")
		Do tMessage.AdditionalInfo.SetAt(pAction,"SOAPAction")
		Do tMessage.ContentStream.CopyFrom(tFile)
		Set tSC = ..SendSync(tMessage,.pResponse)
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

}

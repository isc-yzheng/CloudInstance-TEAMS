Include HS.HC

/// HS.FHIR.FromSDA.DTL.Transaction.Process takes an SDA Container as input,
/// converts it into a FHIR resource Bundle, forwards the Bundle to a specified
/// business host, receives the response from the business host, and returns a
/// success / fail status based on the return from the business host.
Class HS.FHIR.FromSDA.DTL.Transaction.Process Extends (Ens.BusinessProcess, HS.FHIR.FromSDA.DTL.Base) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},TransmissionMode,FullTransactionResponse";

/// Specifies the business host to which to forward the FHIR request
/// message after it is built by the DTL transformation.
Property TargetConfigName As Ens.DataType.ConfigName;

/// batch = Send all generated FHIR resources in a single transaction interaction in a Bundle of type "batch".<br>
/// transaction = Send all generated FHIR resources in a single transaction interaction in a Bundle of type "transaction".<br>
/// individual = Send each generated FHIR resource in its own individual create interaction.
Property TransmissionMode As %String(DISPLAYLIST = ",batch,transaction,individual", VALUELIST = ",batch,transaction,individual") [ InitialExpression = "transaction" ];

/// If checked, the FHIR request message that this process sends to the target
/// config will be created with the "PREFER" header value set to 
/// "return=representation". Per the FHIR spec, this header indicates to a FHIR
/// server that every created or updated resource should be returned in its
/// entirety as it is saved (ie, with any modifications applied by the server).
/// Whether the server actually does this depends on the server. In general,
/// this setting should be left unchecked except during debugging or if the
/// FHIR client has a specific need to receive back the created/updated
/// resources, as requesting this information is likely to increase response
/// time from the FHIR server.
Property FullTransactionResponse As %Boolean [ InitialExpression = 0 ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC=$$$OK
		
		If ..CustomDTLPackage=..#STANDARDPACKAGE Set tSC = $$$ERROR($$$GeneralError, "CustomDTLPackage cannot equal the standard DTL package name - input message rejected") Quit
		If ..TargetConfigName="" Set tSC = $$$ERROR($$$GeneralError, "No TargetConfigName configured for FHIR request message - input message rejected") Quit
		
		Set tQuickStreamId = ""
		
		If pRequest.%IsA("Ens.StreamContainer") {
			Set pResponse = ##class(Ens.StreamContainer).%New()
			Set tApplication = ""
			Set tSessionId = ""
			Set tPatientResourceId = ""
			Set tQuickStreamId = pRequest.Attributes.GetAt("QuickStreamId")
			If tQuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tQuickStreamId)
				Set tStreamRef = tQuickStream
			} Else {
				Set tStreamRef = pRequest.Stream
			}
			Set tSC = ..ProcessSDARequest(tStreamRef, tApplication, tSessionId, tPatientResourceId)
		} ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			Set pResponse = ##class(HS.Message.XMLMessage).%New()
			Set tApplication = pRequest.AdditionalInfo.GetAt("SessionApplication")
			Set tSessionId = pRequest.AdditionalInfo.GetAt("SessionId")
			Set tPatientResourceId = pRequest.AdditionalInfo.GetAt("PatientResourceId")
			Set tQuickStreamId = pRequest.AdditionalInfo.GetAt("QuickStreamId")
			If tQuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tQuickStreamId)
				Set tStreamRef = tQuickStream
			} Else {
				Set tStreamRef = pRequest.ContentStream
			}
			Set tSC = ..ProcessSDARequest(tStreamRef, tApplication, tSessionId, tPatientResourceId)
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.%ClassName(1)) Quit
		}
		
		If (tQuickStreamId'="")&&($IsObject($Get(tQuickStream))) Do tQuickStream.Clear()
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method ProcessSDARequest(pSDAStream As %Stream.GlobalCharacter, pSessionApplication As %String, pSessionId As %String, pPatientResourceId As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Get the host and web server port of the current HealthShare
		#; instance, to be used for populating the FHIR request message
		#; HOST header.  The HOST header needed in the FHIR request
		#; message when the message is being routed for processing in
		#; the local production, as opposed to being passed to an
		#; external server.
		Set tSC = ##class(%RoutineMgr).GetWebServerPort(.tPort)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "Could not get web server port") Quit
		Set tHost = $ZConvert($$$HSNetworkHostName, "L")
		Set tLocalHostAndPort = tHost_$Select(tPort'="":":",1:"")_tPort
		
		#; Method Overview:
		#;
		#; The input is an SDA Container stream.
		#; Transform the SDA Container into an HS FHIR request message, using DTL.
		#; Route the FHIR request message to TargetConfigName.
		#; Receive the HS FHIR response from TargetConfigName.
		#; Transform the FHIR response into a %Status return status, and return it.
		
		#dim tSDAContainer As HS.SDA3.Container
		#dim tFHIRRequest As HS.Message.FHIR.Request
		#dim tFHIRResponse As HS.Message.FHIR.Response
		
		Set tSC = ..InitializeMessage(.tFHIRRequest, ..FHIRFormat)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..InitializeBundle(.tBundle, ..TransmissionMode)
		If $$$ISERR(tSC) Quit
		
		Set tSDAContainer = ##class(HS.SDA3.Container).%New()
		Set tSC = tSDAContainer.InitializeXMLParse(pSDAStream, "SDA3")
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..TransformSDAContainer(tSDAContainer, pPatientResourceId, ..TransmissionMode, .tBundle, .tFHIRStream)
		If $$$ISERR(tSC) Quit
		
		#; "individual" is not a transaction type or interaction.
		#; This mode causes each entry in the Bundle to be sent
		#; to TargetConfigName individually, not as a transaction.
		If ..TransmissionMode="individual" {
			For i = 1:1:tBundle.entry.Count() {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tBundle.entry.GetAt(i).resource, .tFHIRResource)
				If $$$ISERR(tSC) Quit
				Set tFHIRResourceType = tFHIRResource.%ClassName(0)
				Set tSingleFHIRRequest = ##class(HS.Message.FHIR.Request).%New()
				Set tSingleFHIRRequest.Interaction = "create"
				Set tSingleFHIRRequest.ContentType = tFHIRRequest.ContentType
				Set tSingleFHIRRequest.Type = tFHIRResourceType
				Set tSingleFHIRRequest.Id = tFHIRResource.id.value
				Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(tSingleFHIRRequest.ContentType, tFHIRResource, .tFHIRStream, ..FormatFHIROutput)
				If $$$ISERR(tSC) Quit
				Do tSingleFHIRRequest.Payload.CopyFrom(tFHIRStream)
				Do:..FullTransactionResponse tSingleFHIRRequest.Headers.SetAt("return=representation","PREFER")
				#; Set the HOST header to provide for the case where the transaction is
				#; being routed within this production (e.g., to HS.FHIR.Server.Process).
				Do tSingleFHIRRequest.Headers.SetAt(tLocalHostAndPort,"HOST")
				Set tSingleFHIRRequest.SessionApplication = tFHIRRequest.SessionApplication
				Set tSingleFHIRRequest.SessionId = tFHIRRequest.SessionId
				Set tSingleFHIRRequest.FormatFHIROutput = ..FormatFHIROutput
				Set tSC = ..SendRequestSync(..TargetConfigName, tSingleFHIRRequest, .tFHIRResponse)
				If $$$ISERR(tSC) Quit
				Set tSC = ..ProcessFHIRResponse(tFHIRResponse, .tFHIRStatus)
				If $$$ISERR(tSC) Quit
				If $$$ISERR(tFHIRStatus) Set tSC = tFHIRStatus Quit
			}
			Quit
		}
			
		Do tFHIRRequest.Payload.CopyFrom(tFHIRStream)
		
		Do:..FullTransactionResponse tFHIRRequest.Headers.SetAt("return=representation","PREFER")
		
		#; Set the HOST header to provide for the case where the transaction is
		#; being routed within this production (e.g., to HS.FHIR.Server.Process).
		Do tFHIRRequest.Headers.SetAt(tLocalHostAndPort,"HOST")
		
		Set tFHIRRequest.FormatFHIROutput = ..FormatFHIROutput
		
		Set tFHIRRequest.SessionApplication = pSessionApplication
		Set tFHIRRequest.SessionId = pSessionId
		
		If ..TransmissionMode="transaction" Do tFHIRRequest.AdditionalInfo.SetAt(1,"ConvertUUIDs")
		
		Set tSC = ..SendRequestSync(..TargetConfigName, tFHIRRequest, .tFHIRResponse)
		If $$$ISERR(tSC) Quit
			
		Set tSC = ..ProcessFHIRResponse(tFHIRResponse, .tFHIRStatus)
		If $$$ISERR(tSC) Quit
		If $$$ISERR(tFHIRStatus) Set tSC = tFHIRStatus Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ProcessFHIRResponse evaluates the FHIR response message and formulates a return status code.
Method ProcessFHIRResponse(pFHIRResponse As HS.Message.FHIR.Response, ByRef pFHIRSC As %Status) As %Status
{
	Set tSC = $$$OK
	
	Set pFHIRSC = $$$OK
	
	Try {
		#; If Status is 200 OK or 201 Created or 202 Accepted, then don't
		#; worry about any warnings that might be in an OperationOutcome.
		If (+pFHIRResponse.Status=200)||(+pFHIRResponse.Status=201)||(+pFHIRResponse.Status=202) Quit
		
		#; The only expected Payload is an OperationOutcome resource or a Bundle of OperationOutcome resources.
		If pFHIRResponse.Payload.Size>0 {
			Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pFHIRResponse.ContentType, pFHIRResponse.Payload, .tHSFHIRObj)
			If $$$ISERR(tSC) Quit
			If tHSFHIRObj.%ClassName(0)="Bundle" {
				For i = 1:1:tHSFHIRObj.entry.Count() {
					Set tEntry = tHSFHIRObj.entry.GetAt(i)
					If '$IsObject(tEntry.resource.OperationOutcome) Set tSC = $$$ERROR($$$GeneralError, "Unexpected payload in FHIR response") Quit
					For j = 1:1:tEntry.resource.OperationOutcome.issue.Count() {
						Set tIssue = tEntry.resource.OperationOutcome.issue.GetAt(j)
						If tIssue.severity.value="error" {
							If tIssue.diagnostics.value'="" Set pFHIRSC = $$$ERROR($$$GeneralError, tIssue.diagnostics.value) Quit
						}
					}
				}
			} ElseIf tHSFHIRObj.%ClassName(0)="OperationOutcome" {
				For i = 1:1:tHSFHIRObj.issue.Count() {
					Set tIssue = tHSFHIRObj.issue.GetAt(i)
					If tIssue.severity.value="error" {
						If tIssue.diagnostics.value'="" Set pFHIRSC = $$$ERROR($$$GeneralError, tIssue.diagnostics.value) Quit
					}
				}
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Unexpected payload in FHIR response") Quit
			}
			Kill tHSFHIRObj
		}
		If $$$ISERR(tSC) Quit
		If $$$ISERR(pFHIRSC) Quit
		
		Set pFHIRSC = $$$ERROR($$$GeneralError, "FHIR response status = "_pFHIRResponse.Status)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>CustomDTLPackage</Value>
</Value>
<Value name="3">
<Value>TargetConfigName</Value>
</Value>
<Value name="4">
<Value>FHIRFormat</Value>
</Value>
<Value name="5">
<Value>UUIDForResourceId</Value>
</Value>
<Value name="6">
<Value>FormatFHIROutput</Value>
</Value>
<Value name="7">
<Value>TransmissionMode</Value>
</Value>
<Value name="8">
<Value>FullTransactionResponse</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

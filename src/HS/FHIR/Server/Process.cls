/// HS.FHIR.Server.Process provides the means to manipulate or transform an incoming FHIR
/// message, and forwards the message a designated business host.
Class HS.FHIR.Server.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper, HS.Util.BaseHost) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},CustomProcessor:Basic,DTLPipeline:Basic,ResourceSchemaRoot:Basic,-TransactionOperations:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},-DocumentManager,-OperationManager:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},-RepositoryOperations:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},";

/// Specifies a DTL Pipeline that transforms the inbound FHIR messages. <br>
/// It runs after the CustomProcessor.
Property DTLPipeline As Ens.DataType.ConfigName;

/// Business host to which to forward the FHIR request message.
Property TargetConfigName As Ens.DataType.ConfigName;

/// *** This property is no longer used.
Property TransactionOperations As Ens.DataType.ConfigName;

/// *** This property is no longer used.
Property DocumentManager As Ens.DataType.ConfigName;

/// *** This property is no longer used.
Property OperationManager As Ens.DataType.ConfigName;

/// *** This property is no longer used.
Property RepositoryOperations As Ens.DataType.ConfigName;

/// The class package that is the root of all resource schemas for the desired data model.
Property ResourceSchemaRoot As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Model.Resource" ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC=$$$OK
		
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			If (pRequest.Interaction'="conformance")&&(pRequest.Interaction'="capabilities") {
				Set tSC = ..ProcessFHIRRequest(pRequest, .pResponse)
			} Else {
				Set tSC = ..ProcessMetadataRequest(pRequest, .pResponse)
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.%ClassName(1)) Quit
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method ProcessFHIRRequest(pFHIRRequest As HS.Message.FHIR.Request, Output pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Method Overview:
		#;
		#; FHIR Request is the input.
		#; FHIR Request may be manipulated by CustomProcessor.
		#; TargetConfigName must have a value.
		
		#; FHIR Response is received back from where the Request was routed to.
		#; FHIR Response may be manipulated by CustomProcessor.
		#; Return the FHIR Response.
		
		#; Check for invalid resource type on the interactions that are expected
		#; to include a resource type in their request URLs and have an incoming
		#; Payload.  When invalid, return only HTTP status 404 Not Found.  The
		#; check for invalid resource type within the Payload of these requests
		#; will be done when FHIRToHSFHIR is executed on the Payload.
		
		If ..TargetConfigName="" {
			Set tSC = $$$ERROR($$$GeneralError, "Message not processed - TargetConfigName setting not defined on business host")
			Quit
		}
		
		If (pFHIRRequest.Interaction="create")||(pFHIRRequest.Interaction="update")||(pFHIRRequest.Interaction="patch")||($Extract(pFHIRRequest.Interaction)="$") {
			If pFHIRRequest.Type'="" {
				Set tSC = ##class(HS.FHIR.Utils).ValidateResourceTypeFHIR(pFHIRRequest.Type, ..ResourceSchemaRoot, .tIsValid)
				If $$$ISERR(tSC) Quit
				If 'tIsValid {
					Set tSC = pFHIRRequest.NewResponse(.pFHIRResponse)
					If $$$ISERR(tSC) Quit
					Set pFHIRResponse.Id = pFHIRRequest.Id
					Set pFHIRResponse.Type = pFHIRRequest.Type
					Set pFHIRResponse.Status = 404
					Quit
				}
			}
		}
		
		// Conformance/Capabilities requests are immune to transformation.
		If '((pFHIRRequest.Interaction="conformance")||(pFHIRRequest.Interaction="capabilities")) {
			If (..CustomProcessor'="")||(..DTLPipeline'="") {
				// The payload content, if any, for this request message will be held
				// in either the Payload property or in a QuickStream. The developer
				// of the CustomProcessor will need to use the request message instance
				// method GetPayloadOref() to obtain the pointer to the object that
				// holds the payload content, if any.
				If $$$ISERR(tSC) Quit
				If ..CustomProcessor'="" {
					$$$OnPre(.tStop, pFHIRRequest, .tNewRequest)
					If $Get(tStop) Quit
					If $$$ISERR(tSC) Quit
					#; If success but no returned object, assume that it is because the
					#; pre processing method does not exist, i.e., CustomProcessor is
					#; defined, but it is used only for post processing.
					If $IsObject($Get(tNewRequest)) {
						Kill pFHIRRequest
						Set pFHIRRequest = tNewRequest
					}
				}
				If ..DTLPipeline'="" {
					Set tSC = $ClassMethod(..DTLPipeline, "Transform", pFHIRRequest, .tNewRequest)
					If $$$ISERR(tSC) Quit
					If $IsObject($Get(tNewRequest)) {
						Kill pFHIRRequest
						Set pFHIRRequest = tNewRequest
					}
				}
				If $$$HSTRACING {
					If pFHIRRequest.QuickStreamId'="" {
						Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pFHIRRequest.QuickStreamId)
						$$$HSTRACE("Request after pre-processing", "pFHIRRequest,tQuickStream", pFHIRRequest.%ConstructClone(1), tQuickStream)
					} Else {
						$$$HSTRACE("Request after pre-processing", "pFHIRRequest", pFHIRRequest.%ConstructClone(1))
					}
				}
				If $$$ISERR(tSC) Quit
			}
		}
		
		Set tSC = ..SendRequestSync(..TargetConfigName, pFHIRRequest, .tFHIRResponse)
		#; If tSC is an error then let HS.FHIR.Service catch it and create an OperationOutcome from it.
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..ProcessFHIRResponse(pFHIRRequest, tFHIRResponse, .pFHIRResponse)
		If $$$ISERR(tSC) Quit
		
		If $$$HSTRACING {
			If pFHIRResponse.QuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pFHIRResponse.QuickStreamId)
				$$$HSTRACE("FHIR response message to be returned", "pFHIRResponse,tQuickStream", pFHIRResponse, tQuickStream)
			} Else {
				$$$HSTRACE("FHIR response message to be returned", "pFHIRResponse", pFHIRResponse)
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// ProcessFHIRResponse carries out any response post processing defined by CustomProcessor.
Method ProcessFHIRResponse(pFHIRRequest As HS.Message.FHIR.Request, pFHIRResponseIn As HS.Message.FHIR.Response, Output pFHIRResponseOut As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If ..CustomProcessor="" Set pFHIRResponseOut = pFHIRResponseIn Quit
		
		#; Copy any AdditionalInfo from the original request into the
		#; response input object.  Do not overwrite any AdditionalInfo
		#; already in the response input object.
		Set tKey = ""
		For {
			Set tVal = pFHIRRequest.AdditionalInfo.GetNext(.tKey)
			If tKey="" Quit
			If 'pFHIRResponseIn.AdditionalInfo.IsDefined(tKey) {
				Do pFHIRResponseIn.AdditionalInfo.SetAt(tVal,tKey)
			}
		}
		
		// The payload content, if any, for this response message will be held
		// in either the Payload property or in a QuickStream. The developer
		// of the CustomProcessor will need to use the response message instance
		// method GetPayloadOref() to obtain the pointer to the object that
		// holds the payload content, if any.
		$$$OnPost(pFHIRResponseIn, .pFHIRResponseOut)
		If $$$ISERR(tSC) Quit
		#; If success but no returned object, assume that it is because the
		#; post processing method does not exist, i.e., CustomProcessor is
		#; defined, but it is used only for pre processing.
		If '$IsObject($Get(pFHIRResponseOut)) Set pFHIRResponseOut = pFHIRResponseIn
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method ProcessMetadataRequest(pRequest As HS.Message.FHIR.Request, pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tHasFHIRTarget = 0
		
		If ..TargetConfigName'="" {
			Set tProductionClass = ##class(Ens.Director).GetActiveProductionName()
			Set tProductionObj = ##class(Ens.Config.Production).%OpenId(tProductionClass)
			#dim tItem As Ens.Config.Item
			For i = 1:1:tProductionObj.Items.Count() {
				Set tItem = tProductionObj.Items.GetAt(i)
				If tItem.Name = ..TargetConfigName {
					If tItem.ClassName[".FHIR." Set tHasFHIRTarget = 1 Quit
				}
			}
			Kill tProductionClass
			Kill tProductionObj
		}
		
		If tHasFHIRTarget=1 {
			Set tSC = ..SendRequestSync(..TargetConfigName, pRequest, .pResponse)
			#; If tSC is an error then let HS.FHIR.Service catch it and create an OperationOutcome from it.
			Quit
		}
		
		Set tResourceId= pRequest.AdditionalInfo.GetAt("ConformanceId")
		If tResourceId'="" {
			Set tVersion = "DSTU2"
			Set tXDataName = "InterSystemsNoRepoConformanceDSTU2"
		} Else {
			Set tResourceId = pRequest.AdditionalInfo.GetAt("CapabilityStatementId")
			If tResourceId'="" {
				Set tVersion = "STU3"
				Set tXDataName = "InterSystemsNoRepoCapabilitySTU3"
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Conformance/CapabilityStatement resource id not specified")
				Quit
			}
		}
		
		Set tSC = pRequest.NewResponse(.pResponse)
		If $$$ISERR(tSC) Quit
		
		Set pResponse.ContentType = pRequest.ContentType
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tSC = ##class(HS.FHIR.Utils).GetCapabilityStatementFromXData(pRequest.ContentType, tXDataName, ..%ClassName(1), ..ResourceSchemaRoot, tResourceId, pRequest.BaseURL, pRequest.AdditionalInfo.GetAt("OAuthClient"), ('pRequest.AdditionalInfo.GetAt("DisableCORS")=1), pRequest.FormatFHIROutput, .tResponseStream)
		If $$$ISERR(tSC) Quit
		
		If $$$HSTRACING {
			If pResponse.QuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
				$$$HSTRACE("FHIR response message to be returned", "pResponse,tQuickStream", pResponse, tQuickStream)
			} Else {
				$$$HSTRACE("FHIR response message to be returned", "pResponse", pResponse)
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

XData InterSystemsNoRepoConformanceDSTU2
{
<Conformance xmlns="http://hl7.org/fhir">
  <placeholder>resource_id</placeholder>
  <text>
    <status value="generated"/>
    <div xmlns="http://www.w3.org/1999/xhtml">
      <p>Conformance resource for InterSystems Health Connect FHIR</p>
    </div>
  </text>
  <placeholder>url</placeholder>
  <version value="1"/>
  <name value="InterSystems Conformance statement"/>
  <status value="draft"/>
  <experimental value="true"/>
  <publisher value="InterSystems Corporation"/>
  <date value="2018-03-16"/>
  <kind value="instance"/>
  <placeholder>software</placeholder>
  <implementation>
    <description value="InterSystems FHIR"/>
    <placeholder>implementation_url</placeholder>
  </implementation>
  <fhirVersion value="1.0.2"/>
  <acceptUnknown value="extensions"/>
  <format value="xml"/>
  <format value="json"/>
  <rest>
    <mode value="server"/>
    <security>
      <placeholder>security_oauth_uris_extension</placeholder>
      <placeholder>security_cors</placeholder>
      <placeholder>security_service</placeholder>
    </security>
    <resource>
      <type value="Basic"/>
      <interaction><code value="read"/></interaction>
    </resource>
  </rest>
</Conformance>
}

XData InterSystemsNoRepoCapabilitySTU3
{
<CapabilityStatement xmlns="http://hl7.org/fhir">
   <placeholder>resource_id</placeholder>
   <text>
      <status value="generated"/>
      <div xmlns="http://www.w3.org/1999/xhtml">
                                                         <p>CapabilityStatement resource for InterSystems FHIR</p>
                                                                                                                       </div>
   </text>
   <placeholder>url</placeholder>
   <version value="1"/>
   <name value="InterSystems FHIR CapabilityStatement"/>
   <status value="draft"/>
   <experimental value="true"/>
   <date value="2018-03-05"/>
   <publisher value="InterSystems Corporation"/>
   <kind value="instance"/>
   <placeholder>software</placeholder>
   <implementation>
      <description value="InterSystems FHIR"/>
      <placeholder>implementation_url</placeholder>
   </implementation>
   <fhirVersion value="3.0.1"/>
   <acceptUnknown value="no"/>
   <format value="xml"/>
   <format value="json"/>
   <rest>
      <mode value="server"/>
      <security>
       <placeholder>security_oauth_uris_extension</placeholder>
      	<placeholder>security_cors</placeholder>
      	<placeholder>security_service</placeholder>
      </security>
      <resource>
         <type value="Basic"/>
         <interaction>
            <code value="read"/>
         </interaction>
      </resource>
   </rest>
</CapabilityStatement>
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>CustomProcessor</Value>
</Value>
<Value name="2">
<Value>CustomProcessorIsValid</Value>
</Value>
<Value name="3">
<Value>TargetConfigName</Value>
</Value>
<Value name="4">
<Value>TransactionOperations</Value>
</Value>
<Value name="5">
<Value>DocumentManager</Value>
</Value>
<Value name="6">
<Value>OperationManager</Value>
</Value>
<Value name="7">
<Value>RepositoryOperations</Value>
</Value>
<Value name="8">
<Value>DTLPipeline</Value>
</Value>
<Value name="9">
<Value>TraceOperations</Value>
</Value>
<Value name="10">
<Value>ResourceSchemaRoot</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

/// An extension to the base RespondingGateway class that if no documents are returned, the PIX manager is queried to 
/// determine whether the patient exists.  This allows vendors to cache the patient ID returned by XCPD and realize that
/// the patient ID has been retired (due to the error - XDSUnknownPatientId) 
Class HS.IHE.XCA.RespondingGateway.QueryIfPatientExistsProcess Extends HS.IHE.XCA.RespondingGateway.Process
{

Parameter SETTINGS = "PIXConsumer";

/// The PIX consumer needs to query the PIX manager to determine whether the patient ID still exists
Property PIXConsumer As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PIXv3.Consumer.Operations" ];

/// Override QueryRequest to query for the patient when there are no documents returned
Method QueryRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=##super(pRequest,.pResponse) Quit:$$$ISERR(tSC)
	Do pResponse.ContentStream.Rewind() Set tSC = ##class(HS.IHE.Util).GetXPathValue(pResponse.ContentStream,"/query:AdhocQueryResponse/rim:RegistryObjectList/*","@id",.tID,.tDoc)
	#; if tID="" there are no documents or registry packages in the response look for the patient
	If tID="" { 
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pResponse.ContentStream,"/query:AdhocQueryResponse","@status",.tStatus,.tDoc)
		#; make sure that the reason we have no documents is not a failure
		If tStatus["urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success" {
			//no documents
			Set tSR= ##class(HS.Message.PatientSearchRequest).%New()
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$XDSDocumentEntryPatientId']/rim:ValueList/rim:Value","text()",.tMPIID)
			Set tSR.MRN=$zstrip($p(tMPIID,"^^^"),"<>","'")
			Set tSR.AssigningAuthority=$$$AffinityDomain
			Set tSR.Facility=$$$AffinityDomain
			Set tSC = ..SendRequestSync(..PIXConsumer,tSR,.tSResponse)
			#; patient id is not found if ErrStatus is not $$$OK
			If tSResponse.ErrStatus'=$$$OK {
				Do pResponse.ContentStream.Rewind()
				Set tString = "<query:AdhocQueryResponse xmlns:query='urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0' xmlns='urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0' status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'>"_
							"<RegistryErrorList highestSeverity='urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error'>"_
							"<RegistryError location='' errorCode='XDSUnknownPatientId' codeContext='Unknown patient' severity='urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error'/>"_
							"</RegistryErrorList><RegistryObjectList/></query:AdhocQueryResponse>"
				Do pResponse.ContentStream.Write(tString)
				Do pResponse.ContentStream.Rewind()
			}
		}
	}
	Quit $$$OK
}

Storage Default
{
<Data name="QueryIfPatientExistsProcessDefaultData">
<Subscript>"QueryIfPatientExistsProcess"</Subscript>
<Value name="1">
<Value>PIXConsumer</Value>
</Value>
</Data>
<DefaultData>QueryIfPatientExistsProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

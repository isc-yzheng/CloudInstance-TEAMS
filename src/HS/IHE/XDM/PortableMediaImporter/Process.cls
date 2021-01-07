Include (HS.HC, HS.IHE.XDM, HS.IHE.ATNA, HS.IHE.XDSb)

/// 
Class HS.IHE.XDM.PortableMediaImporter.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper, HS.IHE.Common.Actor.Base)
{

Parameter SETTINGS = "ZIPTarget:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},ProcessTarget:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},MetadataTransform,FromMetadataTransform";

/// The ZIP file stream will be sent to the Zip Operation to uncompress the files
Property ZIPTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.Util.Zip.Operations" ];

/// Once converted, the message can be sent for further processing
Property ProcessTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDR.Recipient.CommonProcess" ];

/// The XSL file used to transform the XDM METADATA.XML file into a internal XDSb Metadata object
Property MetadataTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

/// The XSL file used to transform an internal XDSb Metadata object into an XDM METADATA.XML file
Property FromMetadataTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/MetadataObject-to-Message.xsl" ];

/// holder of the transformer object
Property Transformer As HS.Util.XSLTTransformer;

Method OnRequest(pRequest As HS.Message.ZipRequest, Output pResponse As Ens.Response) As %Status
{
	try {
		$$$GetTransformer(..Transformer)
		#dim tZipResponse as HS.Message.ZipResponse
		#; inbound request could be a zip file which needs to be uncompressed, or a collection of files

		#; if a zip file 
		If pRequest.Operation="FromZip" {
			///Send request to Zip Operation
			$$$HSTRACE("ZipRequest","ZipRequest",pRequest)
			set tSC = ..SendRequestSync(..ZIPTarget, pRequest, .tZipResponse)
			$$$ThrowOnError(tSC)
			$$$HSTRACE("ZipResponse","ZipResponse",tZipResponse)
		} Else {
			#; already a collection of files
			Set tZipResponse = pRequest
		}
				
		//Check for contents in the ZipResponse
		Throw:'tZipResponse.Items.Count() ##class(%Exception.General).%New("No Files in Archive",,"The provided XDM did not contain any files")
		
		//Now iterate through each METADATA.xml file and convert them into XDR transactions
		#dim tZipItem  as HS.Types.ZipItem
		#dim tMetadata as HS.Message.IHE.XDSb.Metadata
		#dim tAttachment as %Stream.GlobalBinary
		for tI=1:1:tZipResponse.Items.Count() {
			set tZipItem = tZipResponse.Items.GetAt(tI)
			if $zcvt(tZipItem.Filename,"U")="METADATA.XML" {
				set tMetadataStream = tZipItem.File
				set tSC = ..Transformer.TransformIntoObject(tMetadataStream, ..MetadataTransform /* "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" */, .tMetadata, .tParams, "HS.Message.IHE.XDSb.Metadata","Metadata",1)
				$$$HSTRACE("Inbound metata","tMetadata",tMetadata)
				Set tMetadata.Name=$$$XDSbRegisterRequest
				$$$ThrowOnError(tSC)
				for tJ=1:1:tMetadata.Documents.Count() {
					set tAttachment = ..FindZipItemByName(tMetadata.Documents.GetAt(tJ).URI, tZipItem.Path, tZipResponse)
					$$$HSTRACE("FindFile","URI,Path,Attachment",tMetadata.Documents.GetAt(tJ).URI, tZipItem.Path, tAttachment)
					throw:tAttachment="" ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Could not open attachment "_tZipItem.Path _tMetadata.Documents.GetAt(tJ).URI))
					if tAttachment.Size {
						set tMetadata.Documents.GetAt(tJ).Body=tAttachment
						$$$HSTRACE("Document body","Document body",tAttachment.Read(9999999999))
					}
				}
				set tParams("messageName")=$$$XDSbProvideAndRegisterRequest
				#dim tXDRRequest as HS.Message.XMLMessage
				Set tMetadata.Name=$$$XDSbProvideAndRegisterRequest
				set tSC = ..Transformer.TransformFromObject(tMetadata, ..FromMetadataTransform /*"IHE/XDSb/Version1/MetadataObject-to-Message.xsl"*/, .tPnRStream, .tParams)
				Set tXDRRequest=##class(HS.Message.XMLMessage).%New()
				Do tXDRRequest.ContentStream.CopyFrom(tPnRStream)
				$$$ThrowOnError(tSC)
				set tXDRRequest.Name = $$$XDRProvideAndRegisterRequest
				
				$$$HSTRACE("Request","Request",tXDRRequest)
				set tSC = ..SendRequestSync(..ProcessTarget,tXDRRequest,.tXDRResponse)
				$$$HSTRACE("Response","Response",tXDRResponse)
				$$$ThrowOnError(tSC)
				
				set tSC = $$$ATNAEvent("XDSbRepository",tXDRRequest,tXDRResponse,tSC) $$$ThrowOnError(tSC)
				
				set tXDRRequest.Name = $$$XDMDistributeDocumentSetOnMediaRequest
				set tSC = $$$ATNAEvent("XDMPMI",tXDRRequest,tXDRResponse,tSC) $$$ThrowOnError(tSC)
				
				$$$HSTRACE("XDR Response","XDR Response", tXDRResponse)
				
				set pResponse = tXDRResponse
			}
			
			set tMetadata = ""	
			set tZipItem=""
		}
		
		
	} catch eException {
		#dim eException as %Exception.StatusException
		$$$LOGERROR(eException.DisplayString())	
		
	}
	
	Quit $$$OK
}

ClassMethod FindZipItemByName(pName As %String = "", pPath As %String = "", pZipResponse As HS.Message.ZipResponse) As %Stream.GlobalBinary
{
	set tAttachment = ""
	for i=1:1:pZipResponse.Items.Count() {
		#dim tZipItem as HS.Types.ZipItem
		set tZipItem = pZipResponse.Items.GetAt(i)
		if ((tZipItem.Path_tZipItem.Filename) = (pPath_pName)) {
			$$$LOGINFO("File: "_pPath_pName_" -- "_pZipResponse.Items.GetAt(i).Path_pZipResponse.Items.GetAt(i).Filename)
			set tAttachment = pZipResponse.Items.GetAt(i).File
		}
	}
	Quit tAttachment
}

Method ConvertXDR()
{
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>ProcessTarget</Value>
</Value>
<Value name="3">
<Value>MetadataTransform</Value>
</Value>
<Value name="4">
<Value>Transformer</Value>
</Value>
<Value name="5">
<Value>ZIPTarget</Value>
</Value>
<Value name="6">
<Value>FromMetadataTransform</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

/// Specialied SOAP server that enables passing attachments as temp-files instead of binary global streams
Class HS.IHE.Common.Services.SOAPServer.FileStream Extends HS.IHE.Common.Services.SOAPServer.Base
{

/// override: copy attach body to temp file
/// 
/// services may override this to base this decision off the SOAP action. For example, write-transactions may want to keep
/// using the Body stream, while read-transactions would use temp files to reduce DB size and journal activity
/// 
Method OnSetAttachmentBody(pAction As %String, pFrom As %Net.MIMEPart, pTo As HS.IHE.Common.Messages.MIMEAttachment) As %Status
{
	Quit pTo.SaveBodyToFile(pFrom.Body)
}

/// override: clear temp files after processing
/// 
Method OnFinalizeProcessBodyNode(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage, pSC As %Status) As %Status
{
	Set tSC = $$$OK
	Try {
		If $IsObject($G(pRequest)) Do ..clearTempFiles(pRequest)
		If $IsObject($G(pResponse)) Do ..clearTempFiles(pResponse)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method clearTempFiles(pMessage As HS.Message.XMLMessage)
{
	#dim tAtt As HS.IHE.Common.Messages.MIMEAttachment
	Set tIdx="" 
	For { 
		Set tAtt = pMessage.StreamCollection.GetNext(.tIdx) Quit:tIdx=""
		If tAtt.FilePath'="" {
			#; ignore failures, next production start will purge the temp-dir
			Set tSC = ##class(%File).Delete(tAtt.FilePath)
		}
	}
}

}

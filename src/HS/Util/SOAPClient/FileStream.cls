/// Specialied SOAP client that enables passing attachments as temp-files instead of binary global streams
Class HS.Util.SOAPClient.FileStream Extends HS.Util.SOAPClient.Base
{

/// override: copy attach body to temp file
/// 
/// operations may override this to base this decision off the SOAP action. For example, write-transactions may want to keep
/// using the Body stream, while read-transactions would use temp files to reduce DB size and journal activity
/// 
Method OnSetAttachmentBody(pAction As %String, pFrom As %Net.MIMEPart, pTo As HS.IHE.Common.Messages.MIMEAttachment) As %Status
{
	Quit pTo.SaveBodyToFile(pFrom.Body)
}

}

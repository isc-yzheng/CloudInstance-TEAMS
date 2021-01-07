/// HS.IHE.HL7v2.Services extends EnsLib.HL7.Service.TCPService to
/// override OnDocumentEnd() to be able to pass the IP Address of the TCP
/// sender.
Class HS.IHE.HL7v2.Services Extends EnsLib.HL7.Service.TCPService
{

Method OnDocumentEnd(pDocument As EnsLib.EDI.Document, pSource As %String, pStatus As %Status) As %Status
{
	Set pDocument.Envelope = ..Adapter.IOAddr
	Quit ##super(pDocument, pSource, pStatus)
}

}

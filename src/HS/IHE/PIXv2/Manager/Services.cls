/// HS.IHE.PIXv2.Manager.Services extends EnsLib.HL7.Service.TCPService to
/// override OnDocumentEnd() to be able to pass the IP Address of the TCP
/// sender to HS.IHE.PIX.Manager.Process.
Class HS.IHE.PIXv2.Manager.Services Extends EnsLib.HL7.Service.TCPService
{

Method OnDocumentEnd(pDocument As EnsLib.EDI.Document, pSource As %String, pStatus As %Status) As %Status
{
	Set pDocument.Envelope = ..Adapter.IOAddr
	
	Set tSC = ##super(pDocument, pSource, pStatus)
	
	Quit tSC
}

}

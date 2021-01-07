Class HS.Test.Types.Attachment Extends HS.Test.Types.Base
{

Property ContentId As %String(MAXLEN = "", XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property ContentType As %String(MAXLEN = "", XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

Property ContentTransferEncoding As %String(MAXLEN = "", XMLNAME = "encoding", XMLPROJECTION = "ATTRIBUTE");

/* The content is specified by one (and only one) of these properties */
/// Load the content from a URL/file/XData
Property Location As %String(MAXLEN = "", XMLNAME = "location", XMLPROJECTION = "ATTRIBUTE");

/// Use for binary/base64 content
Property Body As %CSP.BinaryStream;

/// Use for text/XML content
Property Text As %Stream.GlobalCharacter(CONTENT = "MIXED");

Method GetBody(Output pSC As %Status = {$$$OK}) As %CSP.BinaryStream
{
	If ..Location ] "", ..Location '= $C(0) {
		Set pSC = ##class(Ens.Util.URLStream).GetURLStream(..Location, .tStream) Quit:$$$ISERR(pSC)
		Set pSC = ..Body.CopyFrom(tStream) Quit:$$$ISERR(pSC)
		Do ..Body.Rewind()
	}
	ElseIf $IsObject(..Text) {
		Set pSC = ..Body.CopyFrom(..Text) Quit:$$$ISERR(pSC)
		Do ..Body.Rewind()
	}
	Quit ..Body
}

}

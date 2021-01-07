/// XDSb Document Viewer
Class HS.Test.UI.XMLViewer Extends HS.Test.UI.Main
{

Parameter PAGENAME = "XML Viewer";

/// Allow IE to cache pages (otherwise, PDF streams will not show)
Parameter CLIENTCACHE As BOOLEAN = 1;

Property XMLID As %String(ZENURL = "ID");

XData Style
{
<style type="text/css">
body {
	font-family: arial,tahoma,verdana;
	font-size:8pt;
	background: white;	
}
h2 {
	color: #3D2423;	
	font-size:18px;
}
a:link {
	color: darkblue;
}
a:visited {
	color: darkblue;
}
a:hover {
	color: #990000;
}
a:active {
	color: darkblue;
}
</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
</page>
}

ClassMethod %OnHSPreHTTP() As %Boolean
{
	Try {
		Kill %stream
		Set tSC=$$$OK

		Set %stream=##class(%GlobalCharacterStream).%New()
		Set id=%request.Get("ID")
		If id="" Quit
		Set type=%request.Get("Type")
		Set:type="" type="text/xml"
		Set fileext=$p(type,"/",2) Set:fileext="" fileext=type
		Set filename=%request.Get("Filename") Set:filename="" filename="document."_fileext
		If $D(^CacheTemp.TestUI(id)) {
			Set txtPosStart=$f(^CacheTemp.TestUI(id),"SOAP-ENV:Envelope")-18
			Set txtPosEnd=$f(^CacheTemp.TestUI(id),"SOAP-ENV:Envelope",txtPosStart+18)
			If txtPosStart<0 {
				Do %stream.Write(^CacheTemp.TestUI(id))
			} else{
				Do %stream.Write($E(^CacheTemp.TestUI(id),txtPosStart,txtPosEnd))
			}
			If type="TXT" || (type="HTM") {
			} Else {
				Set %response.ContentType = type
				Do %response.SetHeader("content-disposition","attachment;filename="_filename)
			}
			Kill ^CacheTemp.TestUI(id)
		}
		
	} Catch ex { Set tSC=ex.AsStatus() }
	If $$$ISERR(tSC) {
		Set %response.ContentType = "text/html"

		Set %stream=##class(%GlobalCharacterStream).%New()
		Do %stream.WriteLine("<!-- ERROR")
		Do %stream.WriteLine($SYSTEM.Encryption.Base64Encode(tSC))
		Do %stream.WriteLine("-->")
		Do %stream.Write("Error loading document<br/>")
		Do %stream.Write($ZCVT($SYSTEM.Status.GetErrorText(tSC),"O","HTML"))
	}
	Quit 1
}

/// Write the stream
ClassMethod OnPage() As %Status
{
	If $IsObject($G(%stream)) {
		Do %stream.Rewind()
		Set tSC=%stream.OutputToDevice()
		Kill %stream
		Quit tSC
	} Else {
		W "Document not found."
		Quit $$$OK
	}
}

}

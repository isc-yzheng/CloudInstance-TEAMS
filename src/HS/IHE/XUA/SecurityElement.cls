/// 
Class HS.IHE.XUA.SecurityElement Extends %SOAP.Security.Element
{

/// This property has no XML projection of its own, as it is used to contain all the intended output XML.
Property Content As %String(MAXLEN = "", XMLPROJECTION = "NONE");

Property Id As %String(MAXLEN = "", REFNAMESPACE = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd", XMLPROJECTION = "ATTRIBUTE", XMLREF = 1) [ Internal, Transient ];

/// Indicates that this element was originally encrypted
Property WasEncrypted As %Boolean(XMLPROJECTION = "none") [ Internal, Transient ];

/// If this is the decrypted version of an EncryptedData element, then the original element
Property OriginalElement As %SOAP.Security.Element(XMLPROJECTION = "none") [ Internal, Transient ];

/// The XMLExport method is overridden to allow the contents of <property>AssertionContent</property>
/// to be used for output. In practice, the content is intended to be a SAML Assertion that Cach&eacute;
/// can't produce using the <class>%SAML.Assertion</class> class.
Method XMLExport(top As %String, format As %String, namespaces As %XML.Namespaces, attrs, createId As %String, typeAttr As %String, ByRef oreflist, ByRef idlist, initialIndent As %String, local As %Boolean, mimeAttachments As %Net.MIMEPart) As %Status [ CodeMode = call, ServerOnly = 1 ]
{
..XMLExportInternal()
}

Method XMLExportInternal() As %Status
{
	$$$XMLSetBuffer(..Content)
	$$$XMLWrite
	Quit $$$OK
}

ClassMethod AssertionXML(pAssertion As %SAML.Assertion = "", pDocument As %XML.Document = "", Output pAssertionXML As %String, pCanonicalize As %Boolean = 1) As %Status
{
	Set tStatus = $$$OK
	Set pAssertionWrapper = ""
	Try {
		If ('$IsObject(pAssertion)) || ('$IsObject(pDocument)) {
			Set tStatus = $$$ERROR($$$ObjectInstanceRequired)
			Quit
		}
		If 'pAssertion.NodeId {
			Set tStatus = $$$ERROR($$$GeneralError,"Assertion must have a NodeId")
			Quit
		}
		Set tNode = pDocument.GetNode(pAssertion.NodeId)
		#dim tNode As %XML.Node
		If ('$IsObject(tNode)) || (tNode.LocalName '= "Assertion") {
			Set tStatus = $$$ERROR($$$GeneralError,"Assertion node not found in incoming document")
			Quit
		}
		
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 0
		Set tStatus = tWriter.OutputToString()
		If $$$ISERR(tStatus) Quit
		If pCanonicalize {
			Set tCanonicalizationMethod = $$$SOAPWSexcc14n
			If $IsObject(pAssertion.WSSecuritySignature) && $IsObject(pAssertion.WSSecuritySignature.SignedInfo) {
				Set tSignedInfo = pAssertion.WSSecuritySignature.SignedInfo
				If $IsObject(tSignedInfo.CanonicalizationMethod) && (tSignedInfo.CanonicalizationMethod.Algorithm '= "") {
					Set tCanonicalizationMethod = tSignedInfo.CanonicalizationMethod.Algorithm
					If (tCanonicalizationMethod = $$$SOAPWSexcc14n) && $IsObject(tSignedInfo.CanonicalizationMethod.InclusiveNamespaces) {
						Set tInclusive = tSignedInfo.CanonicalizationMethod.InclusiveNamespaces.PrefixList
						For i=1:1:$length(tInclusive," ") {
							If $piece(tInclusive," ",i) '= "" Set tPrefixList($piece(tInclusive," ",i)) = ""
						}
					}
					ElseIf (tCanonicalizationMethod = $$$SOAPWSc14n) {
						Set tPrefixList = "c14n"
					}
				}
			}
			Set tStatus = tWriter.Canonicalize(tNode,.tPrefixList)
			If $$$ISERR(tStatus) Quit
		}
		Else {
			Set tStatus = tWriter.Tree(tNode)
			If $$$ISERR(tStatus) Quit
		}
		Set pAssertionXML = tWriter.GetXMLString(.tStatus)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

}

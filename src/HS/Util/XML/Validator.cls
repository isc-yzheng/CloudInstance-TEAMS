Include (HS.IHE.XDSb, HS.IHE.XCA, HS.IHE.XCPD, HS.IHE.DSUB, HS.IHE.PIX, HS.IHE.PDQ, HS.IHE.HPD)

Class HS.Util.XML.Validator Extends Ens.Util.XML.Validator
{

ClassMethod HostURL() As %String
{
	Quit "file:///"_$zu(12)_"../dev/wsdls"
}

/// Using the action in the AdditionalInfo (to find the Schema) and the Stream Validate this object
ClassMethod Validate(pRequest As HS.Message.XMLMessage = "", pSOAPAction As %String = "", pXMLMessageID = "", pSchemaSpecification = "") As HS.Util.XML.Validator
{
	try {
		Set tThis=..%New()
		If pRequest = "" {
			If pXMLMessageID {
				Set pRequest=##class(HS.Message.XMLMessage).%OpenId(pXMLMessageID)
			}
		}
		Set tAction = $S(pSOAPAction]"":pSOAPAction,1:pRequest.AdditionalInfo.GetAt("SOAPAction"))
		If pSchemaSpecification="" {
			Set tSchemaSpec = ..GetSchema(tAction)
		} Else {
			Set tSchemaSpec = pSchemaSpecification
		}
		Set tHostURL=..HostURL()
		For  {
			Set tPos = $find(tSchemaSpec,"{hosturl}")
			Quit:'tPos
			If tPos Set tSchemaSpec=$Extract(tSchemaSpec,1,tPos-10)_tHostURL_$Extract(tSchemaSpec,tPos,*)
		}
		If tSchemaSpec["unknownschema-for-" {
			Do tThis.Errors.Insert(tSchemaSpec)
		} Else {
			Set tSC=##class(%XML.SAX.Parser).ParseStream(pRequest.ContentStream,tThis,"",,,tSchemaSpec)
		}
	} Catch ex {
	}
	Quit tThis
}

ClassMethod GetSchema(pAction As %String = "") As %String
{
	Try {
		Set tString=""
		If pAction = $$$PDQv3QueryAction(1) || (pAction = $$$XCPDPatientDiscoveryAction(1)) {
			Set tString="urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201305UV02.xsd"
		} ElseIf pAction = $$$XDSbQueryAction(1) || 
				(pAction = $$$XDSbQueryMultiPatientAction(1)) || 
				(pAction=$$$XDSbRegisterAction(1)) ||
				(pAction=$$$XDSbQueryResponseAction(1)) {
			Set tString = "urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0 {hosturl}/schema/ebRS/query.xsd, urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0  {hosturl}/schema/ebRS/lcm.xsd"
		} ElseIf pAction=$$$PIXv3AddAction(1) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201301UV02.xsd"
		} ElseIf pAction=$$$PIXv3ReviseAction(1) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201302UV02.xsd"
		} ElseIf pAction=$$$PIXv3MergeAction(1) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201304UV02.xsd"
		} ElseIf pAction=$$$PIXv3QueryAction(1) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201309UV02.xsd"
		} ElseIf pAction=$$$PIXv3AddResponseAction(1) || (pAction=$$$PIXv3ReviseResponseAction(1))  || (pAction=$$$PIXv3MergeResponseAction(1)) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/MCCI_IN000002UV01.xsd"
		} ElseIf pAction=$$$PIXv3QueryResponseAction(1) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201310UV02.xsd"
		} ElseIf pAction=$$$PDQv3QueryResponseAction(1) || (pAction=$$$PDQv3ContinueResponseAction(1)) || (pAction=$$$XCPDPatientDiscoveryResponseAction(1)) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/PRPA_IN201306UV02.xsd"
		} ElseIf pAction=$$$PDQv3ContinueAction(1) || (pAction=$$$PDQv3CancelAction(1)) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/QUQI_IN000003UV01.xsd"
		} ElseIf pAction=$$$PDQv3CancelResponseAction(1) {
			Set tString = "urn:hl7-org:v3 {hosturl}/schema/HL7V3/NE2008/multicacheschemas/MCCI_IN000002UV01.xsd"
		} ElseIf pAction= $$$DSUBSubscribeRequestAction(1) || (pAction= $$$DSUBSubscribeResponseAction(1)){
			Set tString = "http://www.w3.org/2003/05/soap-envelope http://www.w3.org/2003/05/soap-envelope http://www.w3.org/2005/08/addressing http://www.w3.org/2005/08/addressing/ws-addr.xsd http://docs.oasis-open.org/wsn/b-2 http://docs.oasis-open.org/wsn/b-2.xsd urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0 {hosturl}/schema/ebRS/rim.xsd"
		} ElseIf pAction= $$$DSUBNotficationRequestAction(1) {
			Set tString = "http://www.w3.org/2003/05/soap-envelope http://www.w3.org/2003/05/soap-envelope http://www.w3.org/2005/08/addressing http://www.w3.org/2005/08/addressing/ws-addr.xsd http://docs.oasis-open.org/wsn/b-2 http://docs.oasis-open.org/wsn/b-2.xsd urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0 {hosturl}/schema/ebRS/rim.xsd urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0 {hosturl}/schema/ebRS/lcm.xsd"
		} ElseIf pAction= $$$XDSbRetrieveResponseAction(1) || (pAction= $$$XCARetrieveResponseAction(1)) {
			Set tString = "urn:ihe:iti:xds-b:2007 {hosturl}/schema/IHE/XDS.b_DocumentRepository.xsd"
		} ElseIf pAction = $$$HPDQueryAction || (pAction = $$$HPDFeedAction)||(pAction = $$$HPDQueryResponseAction) || (pAction = $$$HPDFeedResponseAction) {
			Set tString="urn:oasis:names:tc:DSML:2:0:core {hosturl}/schema/IHE/HPD.xsd"
		} Else {
			Set tString="unknownschema-for-"_pAction
		}
	} Catch ex {
	}
	Quit tString
}

}

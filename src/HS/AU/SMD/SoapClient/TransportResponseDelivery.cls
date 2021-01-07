Class HS.AU.SMD.SoapClient.TransportResponseDelivery Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://dummy.example.com";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/svc/TransportResponseDelivery/2010";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "TransportResponseDeliveryService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.2;

Method deliver(response As %ListOfObjects(ELEMENTTYPE="HS.AU.Types.SMD.TransportResponseType",XMLPROJECTION="element",XMLNAME="response")) As HS.AU.Types.SMD.DeliverStatusType [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("deliver").Invoke($this,"",.response)
}

}

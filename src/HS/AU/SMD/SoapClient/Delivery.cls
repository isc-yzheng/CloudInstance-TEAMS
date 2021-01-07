Class HS.AU.SMD.SoapClient.Delivery Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Use unwrapped message style for document binding style.
Parameter ARGUMENTSTYLE = "message";

/// This is the URL used to access the web service.
Parameter LOCATION = "http://dummy.example.com";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 0;

/// This is the name of the Service
Parameter SERVICENAME = "SealedMessageDeliveryService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.2;

Method deliver(body As HS.AU.Types.SMD.Deliver(XMLNAME="deliver")) As HS.AU.Types.SMD.DeliveryResponse(XMLNAME="deliverResponse") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("deliver").Invoke($this,"",.body)
}

}

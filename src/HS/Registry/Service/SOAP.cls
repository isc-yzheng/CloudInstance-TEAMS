/// 
Class HS.Registry.Service.SOAP Extends HS.Registry.Service.HTTP
{

Property SOAPVersion As %String;

Property EncryptX509TokenProfile As %String;

Property SAMLTokenProfileConfig As %String;

Property KerberosTokenProfileConfig As %String;

Property UsernameTokenProfileConfig As %String;

Property MTOM As %Boolean [ InitialExpression = 0 ];

/// Definition of the XUA configuration
Property XUAConfiguration As HS.IHE.XUA.Config;

Property Type As %String(MAXLEN = 255) [ InitialExpression = "SOAP", Required ];

/// Controls whether SAML tokens should be sent in the Security headers for the SOAP call.
/// If using a XUAConfiguration and SendSAMLAssertion = 0 default it to 2 (create)
/// If the "Forward" option is selected, the SAMLCreator class will be used to forward a SAML
/// assertion if one is found in the Ensemble request message.
/// If the "Create" option is selected, the SAMLCreator class will be used to create a new SAML
/// assertion based on the data in the Ensemble request message.
/// The "Create then Forward" and "Forward then Create" option both indicate that an assertion should be
/// created in addition to forwarding an assertion if one is found, and the order they are added to the Security header
/// depends on the specific option chosen. If either approach fails to create an assertion, then an error will be thrown.
/// The "Forward or Create" option will attempt to forward an assertion, but if one can't be found in the request, an assertion will then
/// be created. If both operations fail, an error will be thrown.
Property SendSAMLAssertion As %Integer(DISPLAYLIST = ",No,Forward,Create,Create then Forward,Forward then Create,Forward or Create", VALUELIST = ",0,1,2,3,4,5") [ InitialExpression = 0 ];

/// An optional class which extends HS.Util.SOAPClient.Base for the purpose of overriding the AddSecurity method to define different security options
Property SecurityClass As %Dictionary.Classname;

Storage Default
{
<Data name="SOAPDefaultData">
<Subscript>"SOAP"</Subscript>
<Value name="1">
<Value>SOAPVersion</Value>
</Value>
<Value name="2">
<Value>EncryptX509TokenProfile</Value>
</Value>
<Value name="3">
<Value>SAMLTokenProfileConfig</Value>
</Value>
<Value name="4">
<Value>KerberosTokenProfileConfig</Value>
</Value>
<Value name="5">
<Value>UsernameTokenProfileConfig</Value>
</Value>
<Value name="6">
<Value>SignX509TokenProfile</Value>
</Value>
<Value name="7">
<Value>MTOM</Value>
</Value>
<Value name="8">
<Value>XUAConfiguration</Value>
</Value>
<Value name="9">
<Value>SendSAMLAssertion</Value>
</Value>
<Value name="10">
<Value>SecurityClass</Value>
</Value>
</Data>
<DefaultData>SOAPDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

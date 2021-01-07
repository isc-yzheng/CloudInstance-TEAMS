Class HS.AU.ELS.CertRefCache Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// This property describes the usage for this key
Property UseQualifier As %String(DISPLAYLIST = ",P,T,PT", MAXLEN = 250, VALUELIST = ",http://ns.nehta.gov.au/Qcr/Use/Payload/KeyEnc/1.0,http://ns.nehta.gov.au/Qcr/Use/Transport/KeyEnc/1.0,http://ns.nehta.gov.au/Qcr/Use/PayLoadTransport/KeyEnc/1.0") [ Required ];

/// This property describes the type of certificate: eg:  http://ns.electronichealth.net.au/qcr/type/pem/2010
Property QualifiedCertRefType As %String(MAXLEN = 250) [ InitialExpression = "http://ns.electronichealth.net.au/qcr/type/pem/2010", Required ];

/// This property holds the key value (----- BEGIN CERTIFICATE ---  ...etc)
Property QualifiedCertRefValue As %String(MAXLEN = 30000) [ Internal, Required ];

Storage Default
{
<Data name="CertRefCacheState">
<Value name="1">
<Value>UseQualifier</Value>
</Value>
<Value name="2">
<Value>QualifiedCertRefType</Value>
</Value>
<Value name="3">
<Value>QualifiedCertRefValue</Value>
</Value>
</Data>
<State>CertRefCacheState</State>
<StreamLocation>^HS.AU.ELS.CertRefCacheS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

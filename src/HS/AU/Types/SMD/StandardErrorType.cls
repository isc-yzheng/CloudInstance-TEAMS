Class HS.AU.Types.SMD.StandardErrorType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/wsp/xsd/StandardError/2010";

Parameter XMLNAME = "StandardErrorType";

Parameter XMLSEQUENCE = 1;

Property ErrorCode As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/wsp/xsd/StandardError/2010", VALUELIST = ",servicePermanentUnavailable,serviceTemporaryUnavailable,certificateSkiMissing,certificateKeyUsage,invalidCredentials,notAuthenticated,notAuthorised,badParam,badlyFormedMsg,badTimestamp,badSignature,badEncryption,badSigEncOrder,badCertificateTransmitted,badWsaAction,badWsaMessageId,badWsaTo,badAlgorithmDataEncryption,badAlgorithmKeyEncryption,badAlgorithmC14N,badAlgorithmDigest,badAlgorithmSignature", XMLNAME = "errorCode", XMLREF = 1);

Property Message As %String(MAXLEN = "", XMLNAME = "message");

Storage Default
{
<Data name="StandardErrorTypeState">
<Value name="1">
<Value>ErrorCode</Value>
</Value>
<Value name="2">
<Value>Message</Value>
</Value>
</Data>
<State>StandardErrorTypeState</State>
<StreamLocation>^HS.AU.TypesB46.StandardErroAFBS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

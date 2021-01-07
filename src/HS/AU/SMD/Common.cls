/// 
/// This class holds common functions used by Secure Messaging and Delivery Send/Receive business operations and services.
/// 
Class HS.AU.SMD.Common Extends %RegisteredObject [ Abstract, ClassType = "", ProcedureBlock ]
{

/// Create a signed and encrypted payload object version of the object 'obj' passed in using
/// obj					a registered cache object that extends %XML.Adapter
/// x509Sign			an X509Credentials object that should containt the certificate to sign the payload with. (This org's certificate)
/// x509Encrypt			an X509Credentials object that should contain the certificate to encrypt the payload with
/// encryptedPayload	a ByRef returnd object of a signed and encrypted payload object 
/// MoreSigningCerts	a LIST collection of $LIST Strings made up of X509Alias and Passwords - for all senders signing this content
/// 
/// Returns 			%Status
ClassMethod SignAndEncrypt(obj As %RegisteredObject, x509Sign As %SYS.X509Credentials = "", x509Encrypt As %SYS.X509Credentials = "", ByRef encryptedPayload As HS.AU.SMD.EncryptedPayloadType, MoreSigningCerts As %ListOfDataTypes = "") As %Status
{
	IF x509Sign'="" {
		
		; SIGN object with Organisation's credential =======================================================================
		set payload=##class(HS.AU.SMD.SignedPayloadType).Create(obj,x509Sign,.sc)
		if (payload="") || $$$ISERR(sc) {
			quit $$$ERROR($$$GeneralError,"Error creating SignedPayload with ("_x509Sign.Alias_"): "_$system.Status.GetErrorText(sc))
		}
		
		; Add other signatures.
		if $IsObject(MoreSigningCerts),MoreSigningCerts.Count()>0	{
			for i=2:1:MoreSigningCerts.Count() {
				set sc=$$$OK
				set senderX509=MoreSigningCerts.GetAt(i)
				do payload.AddSignature($lg(senderX509,1),$lg(senderX509,2)) quit:$$$ISERR(sc)
			}
			quit:$$$ISERR(sc) $$$ERROR($$$GeneralError,"Error adding other Signature keys: "_$system.Status.GetErrorText(sc))
		}
		
	} else {
		quit $$$ERROR($$$GeneralError,"Error preparing payload (no Organisation signature supplied).")
	}
 

	// get Organisation's X509
	; ENCRYPT signedPayload using credential ===================================================
	set encryptedPayload=##class(HS.AU.SMD.EncryptedPayloadType).Create(payload,x509Encrypt,.sc)
	if (encryptedPayload="") || $$$ISERR(sc) {
		quit $$$ERROR($$$GeneralError,"Error Create EncryptedPayload: "_$system.Status.GetErrorText(sc))
	}
	
	// Will only encrypt with 1 organisation key.
	; Add other encryrpted keys.
	;for i=2:1:encryptWithCerts.Count() {
	;	set sc=$$$OK
	;	set encryptX509=encryptWithCerts.GetAt(i)
	;	do encryptedPayload.AddEncryptedKey($lg(encryptX509,1),$lg(encryptX509,2)) quit:$$$ISERR(sc)
	;}
	;quit:$$$ISERR(sc) $$$ERROR($$$GeneralError,"Error Adding other Encrypted keys: "_$system.Status.GetErrorText(sc))

	quit $$$OK
}

}

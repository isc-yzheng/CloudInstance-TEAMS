Class HS.AU.ELS.InteractionCache Extends (%Persistent, %XML.Adaptor)
{

/// Target is the HPIO that can have one or more interactions.  http://ns.electronichealth.net.au/id/hi/hpio/1.0/8003620000030515
Property Target As %String(MAXLEN = 250) [ Required ];

/// Service category describes the type of document
Property ServiceCategory As %String(MAXLEN = 250) [ Required ];

/// Immediate / Deferred 
Property ServiceInterface As %String(MAXLEN = 250) [ Required ];

/// EndPoint
Property ServiceEndpoint As %String(MAXLEN = 250) [ Required ];

/// Provider
Property ServiceProvider As %String(MAXLEN = 250) [ Required ];

Property CreatedDateTime As %TimeStamp [ InitialExpression = {$ZDT($h,3)}, ReadOnly ];

Property UpdatedDateTime As %TimeStamp [ SqlComputeCode = {set {updatedDateTime}=$ZDT($h,3)}, SqlComputed, SqlComputeOnChange = %%UPDATE ];

Property CertRef As list Of HS.AU.ELS.CertRefCache(STORAGEDEFAULT = "array");

/// Standard qualifier string for HPIO numbers.  This is not normally changed.
///  http://ns.electronichealth.net.au/id/hi/hpio/1.0/8003620000030515
Property IHIQualifier As %String [ Calculated, ReadOnly, SqlComputeCode = {set {*}=$piece({Target},"/",1,$length({Target},"/")-1)}, SqlComputed ];

/// Organisation IHI number: example: 8003620000030515
Property HPIO As %String [ Calculated, ReadOnly, SqlComputeCode = {set {*}=$piece({Target},"/",$length({Target},"/"))}, SqlComputed ];

Index UniqueIndex On (Target, ServiceInterface, ServiceCategory, ServiceEndpoint) [ Unique ];

/// This method returns an X509 credentials object with the certificate that interaction requires 
/// for the purpose defined in 'useQualifier'
/// the x509 object returned is used to encrypt the payload, and/or the transport.
Method GetX509(pUseQualifier As %String = "P", ByRef px509 As %SYS.X509Credentials) As %Status
{
	set tSC=$$$OK
	
	Try {
		if pUseQualifier="T" {
			set tSC=$$$ERROR($$$GeneralError,"The use of this interaction's certificate for 'Transport' purposes (WS_Security) is not suported.")
			quit
		}
		Set tUseQualifier=##class(HS.AU.ELS.CertRefCache).UseQualifierDisplayToLogical(pUseQualifier)
		Set tUsePT=##class(HS.AU.ELS.CertRefCache).UseQualifierDisplayToLogical("PT")
		
		Set tSQL = "select CertRef_QualifiedCertRefValue as QualifiedCertRefValue from HS_AU_ELS.InteractionCache_CertRef WHERE InteractionCache->target=? and (CertRef_UseQualifier=? OR CertRef_UseQualifier=?)"
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,..Target,tUseQualifier,tUsePT)
		If tRS.SQLCODE'=0 Set tSC = $$$ERROR($$$GeneralError, "SQL statement failed - SQLCODE="_tRS.SQLCODE) Quit
	
		set px509=""
		If tRS.%Next() {
			set px509=##Class(%SYS.X509Credentials).%New()
			Set px509.Certificate=..GetCertificate(tRS.QualifiedCertRefValue)
		}
	
	} catch ex {
		set tSC=ex.AsStatus()
	}	
	
	quit tSC
}

ClassMethod GetCertificate(pString As %String) As %String
{
	Set cert=$tr(pString,$c(13),"")
	Set begin="-----BEGIN CERTIFICATE-----"_$c(10)
	Set end=$c(10)_"-----END CERTIFICATE-----"
	If ($length(cert,begin)'=2) || ($length(cert,end)'=2) {
		Set cert=""
	} Else {
		Set cert=$piece($piece(cert,begin,2),end,1)
	}
	Quit $system.Encryption.Base64Decode(cert)
}

ClassMethod GetInteractions(ByRef pInteractions As %ListOfObjects, pTarget As %String, pServiceCategory As %String, pServiceInterface As %String) As %Status
{
	set tSC=$$$OK
	set pInteractions=##class(%ListOfObjects).%New()
	
	Try {
		Set tSQL = "Select ID From HS_AU_ELS.InteractionCache Where target=? AND serviceCategory=? AND serviceInterface=?"
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,pTarget,pServiceCategory,pServiceInterface)
		If tRS.SQLCODE'=0 Set tSC = $$$ERROR($$$GeneralError, "SQL statement failed - SQLCODE="_tRS.SQLCODE) Quit
	
		While tRS.%Next() {
			set it=..%OpenId(tRS.ID)
			do pInteractions.Insert(it)
		}
	} catch ex {
		set tSC=ex.AsStatus()
		set pInteractions=##class(%ListOfObjects).%New()
	}
	
	quit tSC
}

/// This callback method is invoked when the current object is added to the SaveSet,
/// either because %Save() was invoked on this object or on an object that references this object.
/// %OnAddToSaveSet can modify the current object. It can also add other objects to the current
/// SaveSet by invoking %AddToSaveSet or remove objects by calling %RemoveFromSaveSet.
/// 
/// <P>If this method returns an error status then %Save() will fail and the transaction
/// will be rolled back.
Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Private, ServerOnly = 1 ]
{
	if 'insert {
		; on update only - update the 'updatedDateTime' flag.
		set ..UpdatedDateTime=$zdt($h,3)
	}
	Quit $$$OK
}

Query Items() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Target,ServiceCategory,ServiceInterface,ServiceEndpoint FROM InteractionCache
}

Storage Default
{
<Data name="CertRef">
<Attribute>CertRef</Attribute>
<Structure>subnode</Structure>
<Subscript>"CertRef"</Subscript>
</Data>
<Data name="InteractionCacheDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Target</Value>
</Value>
<Value name="3">
<Value>ServiceCategory</Value>
</Value>
<Value name="4">
<Value>ServiceInterface</Value>
</Value>
<Value name="5">
<Value>ServiceEndpoint</Value>
</Value>
<Value name="6">
<Value>ServiceProvider</Value>
</Value>
<Value name="7">
<Value>CreatedDateTime</Value>
</Value>
<Value name="8">
<Value>UpdatedDateTime</Value>
</Value>
</Data>
<DataLocation>^HS.AU.ELS.InteractionCacheD</DataLocation>
<DefaultData>InteractionCacheDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.AU.ELS.InteractionCacheD</IdLocation>
<IndexLocation>^HS.AU.ELS.InteractionCacheI</IndexLocation>
<StreamLocation>^HS.AU.ELS.InteractionCacheS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Include %ZHSLIB

Class HS.Util.Installer.Kit.PostInstall.Demo.OIDEntries Extends HS.Util.Installer.Kit.PostInstall.Base
{

/// pNamespaces can be used to determine other configuration information
ClassMethod RunHub(pNamespaces As HS.Util.Installer.Kit.Namespaces, pArgs...) As %Status
{
	try {
		#; various things that need to be setup in a bus installation
		Set tSC = $$$OK
		If $$$WriteProg Write !, "Adding default OID's"
		Do ##class(HS.Data.OIDMap).FileOID("HomeCommunity","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.300","Home Community")
		Do ##class(HS.IHE.Util).SetAffinityDomain("HomeCommunity")
		Do ##class(HS.IHE.Util).SetHomeCommunity("HomeCommunity")
		Do ##class(HS.Data.OIDMap).FileOID("EXTERNAL","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.310","External System","Facility")
		Set tSC = ..AddOIDEntries(,"OIDEntries") Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData OIDEntries
{
<Items>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.1</OID><IdentityCode>HSREPOSITORY</IdentityCode><IdentityTypes><OIDType><Description>Repository</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.1.2</OID><IdentityCode>HSACCESS</IdentityCode><IdentityTypes><OIDType><Description>Repository</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.2.1</OID><IdentityCode>CGH</IdentityCode><IdentityTypes><OIDType><Description>Facility</Description></OIDType><OIDType><Description>AssigningAuthority</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.2.2</OID><IdentityCode>EMERGENCY</IdentityCode><IdentityTypes><OIDType><Description>Facility</Description></OIDType><OIDType><Description>AssigningAuthority</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.2.3</OID><IdentityCode>HC6</IdentityCode><IdentityTypes><OIDType><Description>Facility</Description></OIDType><OIDType><Description>AssigningAuthority</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.2.4</OID><IdentityCode>MGH</IdentityCode><IdentityTypes><OIDType><Description>Facility</Description></OIDType><OIDType><Description>AssigningAuthority</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.2.5</OID><IdentityCode>PHLS</IdentityCode><IdentityTypes><OIDType><Description>Facility</Description></OIDType><OIDType><Description>AssigningAuthority</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.2.6</OID><IdentityCode>SDA</IdentityCode><IdentityTypes><OIDType><Description>Facility</Description></OIDType><OIDType><Description>AssigningAuthority</Description></OIDType></IdentityTypes></Item>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.2.7</OID><IdentityCode>UMC</IdentityCode><IdentityTypes><OIDType><Description>Facility</Description></OIDType><OIDType><Description>AssigningAuthority</Description></OIDType></IdentityTypes></Item>
</Items>
}

XData RepositoryOIDEntries
{
<Items>
<Item>
<OID>1.3.6.1.4.1.21367.2010.1.2.300.1</OID>
<IdentityCode>HSREPOSITORY</IdentityCode>
<IdentityType>
<Description>Repository</Description>
</IdentityType>
</Item>
</Items>
}

}

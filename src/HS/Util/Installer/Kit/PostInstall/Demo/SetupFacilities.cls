Include %ZHSLIB

/// Setup Facilities for XDSb Registry and / or Source
/// 1 Facility for the 
Class HS.Util.Installer.Kit.PostInstall.Demo.SetupFacilities Extends HS.Util.Installer.Kit.Base
{

/// pNamespaces can be used to determine other configuration information
ClassMethod RunHub(pNamespaces As HS.Util.Installer.Kit.Namespaces, pArgs...) As %Status
{
	try {
		Set tSC=..SetupFacility("EXTERNAL","EXTERNAL",1) Quit:$$$ISERR(tSC)
		If pArgs(1)="XCAEQ" {
			Set tSC=..SetupFacility("XCOMMUNITY","XCOMMUNITY","HSXEDGE")
			Set tSC = ##class(HS.AssignAuth.Config).AddAssigningAuthority("XCOMMUNITY","XCOMMUNITY","")
			Quit
		} ElseIf pArgs(1)="XCA" {
			Set tSC=..SetupFacility("XCADocuments","XCADocuments","HSCONSUMER")
		} ElseIf $G(pArgs(1))="XDS" {
			Set tSC=..SetupFacility("Documents","Documents","HSCONSUMER")
			Set:$$$ISOK(tSC) tSC=..SetupExternalDirect()
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod SetupFacility(pCode, pName, pExternalOrGateway) As %Status
{
	try {
		Set tSC = $$$OK
		If ##class(HS.Facility.Config).%ExistsId(pCode) Quit

		If $$$WriteProg Write !,"Setup facility "_pCode
		Set tFacility=##class(HS.Facility.Config).%New()
		Set tFacility.FacilityCode=pCode
		Set tFacility.Name=pName
		If pExternalOrGateway = 1 {
			Set tFacility.ExternalHIE = 1
		} Else {
			Set tSC = ##class(HS.Util.Installer.Kit.Base).DemoFindGatewayByName(pExternalOrGateway, .tGWID) Quit:$$$ISERR(tSC)
			If tGWID="" Set tSC =  $$$ERROR($$$GeneralError,"Gateway not found: "_pExternalOrGateway) Quit
			Do tFacility.GatewaySetObjectId(tGWID)
		}
		Set tSC = tFacility.%Save()
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod SetupExternalDirect()
{
	try {
		Set tSC = $$$OK
		Set tFacCode="ExternalDirectFacility"
		Do ##class(HS.Registry.Config).AddNewKey("\IHE\ExternalDirectFacility",tFacCode)
		Set tFacility = ##class(HS.Facility.Config).%OpenId(tFacCode)
		If '$IsObject(tFacility) Set tFacility=##class(HS.Facility.Config).%New()
		Set tFacility.FacilityCode=tFacCode
		Set tFacility.Name=tFacCode
		Set tFacility.AssigningAuthority=1
		Set tSC = ##class(HS.Util.Installer.Kit.Base).DemoFindGatewayByName("HSREPOSITORY",.tGWID)
		Do tFacility.GatewaySetObjectId(tGWID)
		Set tSC=tFacility.%Save() Quit:$$$ISERR(tSC)
		Set tOID="1.3.6.1.4.1.21367.2010.1.2.300.2.0"
		Set tSC=##class(HS.Data.OIDMap).FileOID(tFacCode,"Facility",tOID,"","AssigningAuthority")
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

}

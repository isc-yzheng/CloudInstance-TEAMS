/// The default Hub Web Services component.<br> 
/// Provides a SOAP interface to the hub for use by other parts of HealthShare.
Class HS.AU.HI.WebServices Extends EnsLib.SOAP.Service [ ProcedureBlock ]
{

Parameter WSADDRESSING = "AUTO";

Parameter ADAPTER;

Parameter SECURITYIN = "allow";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.intersystems.com/hs/au/hiws";

/// If the SOAPMETHODINHERITANCE parameter is true (1), then WebMethods are inherited from
/// any super class. 
/// The default for the SOAPMETHODINHERITANCE parameter is false (0) which means no WebMethods
/// are inherited from a super class.
Parameter SOAPMETHODINHERITANCE = 0;

/// Name of the WebService.
Parameter SERVICENAME = "HS.AU.HI.WebServices";

Parameter XMLIGNOREINVALIDTAG As BOOLEAN [ Internal ] = 1;

Parameter OUTPUTTYPEATTRIBUTE = 1;

Parameter SETTINGS As %String = "QueryProcess";

Property QueryProcess As Ens.DataType.ConfigName [ InitialExpression = "HS.AU.HI.Management.Process" ];

/// Given a HPI-I number and LastName ensure the number is valid (validate now or has been validated in the last 24 hours)
Method ValidHPII(pRequest As HS.AU.Message.HI.SearchIndividualProviderRequest) As HS.AU.Message.HI.SearchIndividualProviderResponse [ WebMethod ]
{
	Set tSC = ..SendRequestSync(..QueryProcess,pRequest,.tResponse)
	If $$$ISERR(tSC) Quit ""
	
	Quit tResponse
}

/// Given a HPI-O number ensure the number is valid (validate now or has been validated in the last 24 hours)
Method ValidHPIO(pRequest As HS.AU.Message.HI.SearchOrganisationProviderRequest) As HS.AU.Message.HI.SearchOrganisationProviderResponse [ WebMethod ]
{
	Set tSC = ..SendRequestSync(..QueryProcess,pRequest,.tResponse)
	If $$$ISERR(tSC) Quit ""
	
	Quit tResponse
}

Method OnPreWebMethod() [ ServerOnly = 1 ]
{
	If '$SYSTEM.Security.Check("%HS_WebServices","USE") {
		$$$LOGERROR("Resource Error")
		Set tFault = ..MakeSecurityFault("FailedAuthentication")
		Do ..ReturnFault(tFault)
	}
	Quit
}

}

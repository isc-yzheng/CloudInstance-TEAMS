Class HS.Util.InboundAdapterNoWait Extends Ens.Adapter [ ClassType = "", ProcedureBlock ]
{

/// The minimum interval between invocations of the adapter by the Ensemble framework. For adapters that poll for
/// external events, this is the polling interval. However, most polling adapters will process all inputs immediately
/// if several are detected at one time. This is also the interval at which each Business Service will check for shutdown requests.
Property CallInterval As %Numeric(MINVAL = 0.1) [ InitialExpression = 5 ];

Parameter SETTINGS = "CallInterval";

Property BusinessHost As Ens.BusinessService;

Parameter SERVICEINPUTCLASS As STRING = "%RegisteredObject";

Parameter SERVICEOUTPUTCLASS As STRING = "%RegisteredObject";

/// default InboundAdapter behavior: always call ProcessInput on CallInterval
Method OnTask() As %Status
{
	Set tSC = ..BusinessHost.ProcessInput($$$NULLOREF)
	//With Ens.InboundAdapter, there's no way for the business service to decide whether or not to
	//wait for the next call interval.  By suppressing the Set ..BusinessHost.%WaitForNextCallInterval=1,
	//this permits (and requires!) the business service to manage this.  Its OnProcessInput should start
	//by setting this to 1, and then set it to 0 if it doesn't want to wait.

	//Set ..BusinessHost.%WaitForNextCallInterval=1 - we don't do this here
	Quit tSC
}

}

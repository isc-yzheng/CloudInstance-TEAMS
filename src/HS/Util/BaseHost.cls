Include (HS.HC.BaseHost, HS.HC.TraceHelper)

/// Update the host class with 
/// <li>Add SETTINGS parameter to host - Parameter SETTINGS = "CustomProcessor:Basic"; </li>
/// <li>Add oninit code - Method OnInit() As %Status <br>{ 	Quit ..ValidateCustomProcessor() }</li>
Class HS.Util.BaseHost
{

Parameter DOMAIN = "HS";

/// Class name which contains the override OnPre/OnPost methods.  Not all OnPre/OnPost methods must be defined.<br>
/// Tracing within the methods of the custom processor can be accomplished using <li>$$$HSTRACECALLED (traceoperations set to non-null and not minimal or errorsonly),</li>
/// <li>$$$HSTRACECALLEDMIN (*MINIMAL*),</li>
/// <li> $$$HSTRACECALLEDERROR (*ERRORSONLY*)</li><br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Terminate processing in the calling method by setting pStopProcessing = 1 or returning an Error status <br><br>
/// Both OnPre and OnPost methods will be defined as ClassMethods, not instance methods.<br>
/// OnPre method signatures are a copy of the method signature with OnPre prepended to the name and pHost,pStop prepended to the variable list<br>
/// OnPost method signatures are a copy of the method signature with OnPost prepended to the name and pHost prepended to the variable list<br>
Property CustomProcessor As %String(MAXLEN = 512);

Property CustomProcessorIsValid As %Boolean [ InitialExpression = 1, Internal ];

/// $$$OnPre(.tStop,.pRequest,.pResponse) Quit:$g(tStop)
/// $$$OnPost(.pRequest,.pResponse)
/// Tracing can be accomplished using $$$HSTRACECALLED (traceoperations set to non-null and not minimal or errorsonly), $$$HSTRACECALLEDMIN (*MINIMAL*), $$$HSTRACECALLEDERROR (*ERRORSONLY*)
Method InvokeCustom(pMethod, args...)
{
	#dim ex as %Exception.SystemException
	Quit:'..CustomProcessorIsValid $$$OK
	New %HSTraceHost
	$$$HSTRACEHOSTSTART($this)
	Set tSC=$$$OK
	Try {
		Set tSC = $classMethod(..CustomProcessor,pMethod,$this,args...)
	} Catch ex {
		Set tSC = ex.AsStatus()
		If tSC ["METHOD DOES NOT EXIST" Set tSC=$$$OK
		If tSC ["CLASS DOES NOT EXIST" Set ..CustomProcessorIsValid=0,tSC=$$$OK
	}
	Quit tSC
}

Method ValidateCustomProcessor() As %Status
{
	If ..CustomProcessor="" Set ..CustomProcessorIsValid=0 Quit $$$OK
	If $g(%healthshare("CustomProcessorExists",..CustomProcessor)) Set ..CustomProcessorIsValid=1 Quit $$$OK
	If ##class(%ClassDefinition).%ExistsId(..CustomProcessor) Set %healthshare("CustomProcessorExists",..CustomProcessor)=1,..CustomProcessorIsValid=1 Quit $$$OK
	Set ..CustomProcessorIsValid=0
	Quit $$$ERROR($$$GeneralError,$$$FormatText("Custom Processor class %1 does not exist",..CustomProcessor))
}

}

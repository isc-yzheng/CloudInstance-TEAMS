Class HS.Util.WebServices.ServiceStatus Extends (%RegisteredObject, %XML.Adaptor, %JSON.Adaptor) [ Inheritance = right ]
{

/// If this parameter is true then JSON-enabling methods will be generated. 
/// Otherwise, the method generators do not produce a runnable method.
Parameter %JSONENABLED = 0;

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Status As %Status;

Property %User As %String [ InitialExpression = {$Username} ];

Property %Roles As %String(MAXLEN = "") [ InitialExpression = {$Roles} ];

Property %Gateway As %String [ InitialExpression = {$namespace} ];

}

/// Used by a web service query to return an item in a list
Class HS.Util.WebServices.ListItem Extends (%RegisteredObject, %XML.Adaptor, %JSON.Adaptor) [ Inheritance = right ]
{

/// If this parameter is true then JSON-enabling methods will be generated. 
/// Otherwise, the method generators do not produce a runnable method.
Parameter %JSONENABLED = 0;

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property ID As %String;

Property Name As %String(MAXLEN = 250);

}

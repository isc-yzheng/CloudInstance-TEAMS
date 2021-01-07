Class HS.Util.Status.Metadata.ViolationMessage Extends (%RegisteredObject, %XML.Adaptor) [ System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/util/status";

Property Type As %String(VALUELIST = ",OnInsert,OnUpdate,OnUpdateReferencedClass,OnUpdateReferencingClass,OnDelete", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property Value As %String(MAXLEN = 1024, XMLPROJECTION = "CONTENT") [ Required ];

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.JMS.Message Extends Ens.Request
{

Property text As %String(MAXLEN = "");

Property type As %String [ InitialExpression = "TextMessage" ];

Property messageId As %String(MAXLEN = "");

Property properties As array Of EnsLib.JMS.Property(XMLITEMNAME = "property", XMLKEYNAME = "key", XMLPROJECTION = "COLLECTION");

Method getNextPropertyKey(previousKey As %String = "") As %String
{
	quit ..properties.Next(previousKey)
}

Method getPropertyType(key As %String) As %String
{
	quit ..properties.GetAt(key).type
}

Method getProperty(key As %String) As %String
{
	quit ..properties.GetAt(key).value
}

Method getByteProperty(key As %String) As %String
{
	quit ..properties.GetAt(key).value
}

Method getBooleanProperty(key As %String) As %Boolean
{
	quit ..properties.GetAt(key).value
}

Method getShortProperty(key As %String) As %Integer
{
	quit ..properties.GetAt(key).value
}

Method getIntProperty(key As %String) As %Integer
{
	quit ..properties.GetAt(key).value
}

Method getIntegerProperty(key As %String) As %Integer
{
	quit ..properties.GetAt(key).value
}

Method getLongProperty(key As %String) As %Integer
{
	quit ..properties.GetAt(key).value
}

Method getFloatProperty(key As %String) As %Double
{
	quit ..properties.GetAt(key).value
}

Method getDoubleProperty(key As %String) As %Double
{
	quit ..properties.GetAt(key).value
}

Method getStringProperty(key As %String) As %String
{
	quit ..properties.GetAt(key).value
}

Method setProperty(key As %String, value As %String, type As %String = "String") As %Status
{
	do ..properties.SetAt(##class(EnsLib.JMS.Property).%New(value,type),key)
	quit $$$OK
}

Method setByteProperty(key As %String, value As %String) As %Status
{
	quit ..setProperty(key,value,"Byte")
}

Method setBooleanProperty(key As %String, value As %Boolean) As %Status
{
	quit ..setProperty(key,value,"Boolean")
}

Method setShortProperty(key As %String, value As %Integer) As %Status
{
	quit ..setProperty(key,value,"Short")
}

Method setIntProperty(key As %String, value As %Integer) As %Status
{
	quit ..setProperty(key,value,"Integer")
}

Method setIntegerProperty(key As %String, value As %Integer) As %Status
{
	quit ..setProperty(key,value,"Integer")
}

Method setLongProperty(key As %String, value As %Integer) As %Status
{
	quit ..setProperty(key,value,"Long")
}

Method setFloatProperty(key As %String, value As %Double) As %Status
{
	quit ..setProperty(key,value,"Float")
}

Method setDoubleProperty(key As %String, value As %Double) As %Status
{
	quit ..setProperty(key,value,"Double")
}

Method setStringProperty(key As %String, value As %String) As %Status
{
	quit ..setProperty(key,value,"String")
}

Storage Default
{
<Data name="MessageDefaultData">
<Subscript>"Message"</Subscript>
<Value name="1">
<Value>text</Value>
</Value>
<Value name="2">
<Value>type</Value>
</Value>
<Value name="3">
<Value>messageId</Value>
</Value>
</Data>
<Data name="properties">
<Attribute>properties</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.JMS.Message.properties"</Subscript>
</Data>
<DefaultData>MessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

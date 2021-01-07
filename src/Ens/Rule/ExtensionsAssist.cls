/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Rule Assist class that supports Rule extension classes and provides APIs for associated UI plug-in components
Class Ens.Rule.ExtensionsAssist Extends (Ens.Rule.Assist, %CSP.REST) [ Abstract ]
{

/// REST URL Map for the Trigger API
XData UrlMap
{
<Routes>
<Route Url="/context/:classname"               Method="GET"     Call="GetContextProperties"/>
<Map Prefix="/:name"              Forward="Ens.Rule.Extension"/>
<Route Url="/"                                 Method="GET"     Call="GetExtensions"/>
<Route Url=""                                  Method="GET"     Call="GetExtensions"/>
</Routes>
}

ClassMethod GetContextProperties(Svc As EnsLib.REST.Service, InStream As %CSP.BinaryStream, Output OutStream As %GlobalBinaryStream, pClassname As %String)
{
	Set tSC = $$$OK
	try {
		Set tSC = ..ContextList(pClassname,.body)
		If $$$ISERR(tSC) { Set OutStream.Attributes("ResponseCode")=..#HTTP400BADREQUEST  Quit }
		Do OutStream.Write(body.%ToJSON())
		Set OutStream.Attributes("Content-Type")="application/json; charset=""UTF-8"""
	} catch ex {
		Set tSC=ex.AsStatus()
		Return:'$$$IsdefObject(OutStream) tSC
		Set OutStream.Attributes("ResponseCode")=..#HTTP500INTERNALSERVERERROR
	}
	If $$$ISERR(tSC) {
		Set OutStream.Attributes("Content-Type")="text/plain; charset=""UTF-8"""
		Do OutStream.Write($P($$$StatusDisplayString(tSC)," / ["))
	}
	Quit $$$OK
}

/// Return a dynamic array of objects describing the set of properties of the named rule context class
ClassMethod ContextList(pContextClassname As %String, ByRef pBody As %DynamicArray) As %Status [ Internal ]
{
	Quit:'##class(%Dictionary.CompiledClass).%ExistsId(pContextClassname) $$$ERROR($$$GeneralError,"Extension Context class '"_pContextClassname_"' not found")
	Quit:'$classmethod(pContextClassname,"%Extends","Ens.Rule.ExtensionInputs") $$$ERROR($$$GeneralError,"Extension Context class '"_pContextClassname_"' does not extend 'Ens.Rule.ExtensionInputs'")

	Set tSC = ##class(Ens.Rule.ExtensionsAssist).ExtensionsList(,.dtMap)
	Quit:$$$ISERR(tSC) tSC

	Set tXDataObj = ##class(%Dictionary.CompiledXData).%OpenId(pContextClassname_"||InputTypesSpec",,.tSC)  Quit:$$$ISERR(tSC) tSC
	Set:$$$ISOK(tSC) propTypes = ##class(%Library.DynamicObject).%FromJSON($S(tXDataObj.Data.Size:tXDataObj.Data,1:"{}"))
	Quit:$$$ISERR(tSC) $$$ERROR($$$GeneralError,"Extension Context class '"_pContextClassname_"' InputTypesJSON parameter '"_$parameter(pContextClassname,"InputTypesJSON")_"' is not well formed:"_$$$StatusDisplayString(tSC))
	Set pBody = []
	&sql(DECLARE Cgcp CURSOR FOR
		SELECT Name, Type, RuntimeType, Collection INTO :propName, :propType, :propRuntimeType, :propCollection
		FROM %Dictionary.CompiledProperty
		WHERE parent = :pContextClassname AND $EXTRACT(Name,1) <> '%' AND Private<>1 AND Internal<>1 AND Calculated<>1)
	&sql(OPEN Cgcp) For { &sql(FETCH Cgcp) Quit:SQLCODE
		Set pluginType = propTypes.%Get(propName)
		If $IsObject(pluginType) {
			If $D(dtMap(pluginType.type),pluginClass)#2 {
				Set pluginName = $parameter(pluginClass,"PluginName")
			} Else { Set (pluginClass,pluginName) = "" }
			Do pBody.%Push({"name":(propName),"irisType":(propType),"pluginType":(pluginType.type),"pluginSchema":(pluginType.pluginSchema),"pluginClass":(pluginClass),"pluginName":(pluginName)})
		} Else {
			&sql(SELECT ClassType INTO :classType FROM %Dictionary.CompiledClass WHERE name = :propType)
			If SQLCODE {
				Set tSC=$$$ERROR($$$GeneralError,"SELECT Error for ClassType of context property '"_propName_"' class '"_propType_"'; SQLCODE = "_SQLCODE_$S(""=%msg:"", 1:" / "_%msg))
				Quit
			}
			If $Case(classType,"datatype":0,"donotuse":0,"":0,:1) {
				Do pBody.%Push({"name":(propName),"irisType":(propType),"pluginType":"IRISClass","pluginSchema":(propType),"pluginClass":"Ens.Rule.ClassdefExtension","pluginName":"IRISClass"})
			} Else {
				Do pBody.%Push({"name":(propName),"irisType":(propType)})
			}
		}
	} Set tCode=SQLCODE,tMsg=$G(%msg) &sql(CLOSE Cgcp) Set:'SQLCODE SQLCODE=tCode,%msg=tMsg
	Set:SQLCODE&&(SQLCODE'=100) tSC=$$$ERROR($$$GeneralError,"FETCH Error for properties of context class "_pContextClassname_"; SQLCODE = "_SQLCODE_$S(""=%msg:"", 1:" / "_%msg))

	// warn on leftover properties or inputs or inputTypes (but not shortage of inputTypes if default ok)

	Quit tSC
}

/// Return a payload JSON array of objects describing the set of installed Rule Extension classes
ClassMethod GetExtensions(Svc As EnsLib.REST.Service, InStream As %CSP.BinaryStream, Output OutStream As %GlobalBinaryStream)
{
	Set tSC = $$$OK
	try {
		Set tSC = ..ExtensionsList(.body)
		Quit:$$$ISERR(tSC)

		Do OutStream.Write(body.%ToJSON())
		Set OutStream.Attributes("Content-Type")="application/json; charset=""UTF-8"""
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		Quit:'$$$IsdefObject(OutStream) tSC
		Set OutStream.Attributes("Content-Type")="text/plain; charset=""UTF-8"""
		Set OutStream.Attributes("ResponseCode")=..#HTTP500INTERNALSERVERERROR
		Do OutStream.Write($P($$$StatusDisplayString(tSC)," / ["))
	}
	Quit $$$OK
}

/// Return a dynamic array of objects describing the set of installed Rule Extension classes
ClassMethod ExtensionsList(ByRef pBody As %DynamicArray, ByRef pDTmap) As %Status [ Internal ]
{
	Set pBody = []
	Set tRS = ##class(%Library.ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
	Set tSC = tRS.Execute("Ens.Rule.Extension","%YZ")
	While $$$ISOK(tSC) && tRS.Next(.tSC) { Set name = tRS.Data("Name")
		Set dataTypes = $parameter(name,"DataTypes")
		For i = 1:1:$L(dataTypes,",") { Set tDT = $ZStrip($P(dataTypes,",",i),"<>W")
			Set:""'=tDT pDTmap(tDT) = name
		}
		Do pBody.%Push({"class":(name), "plugin":($parameter(name,"PluginName")), "dataTypes":(dataTypes)})
	} Set:tSC'=0 tSCc=tRS.Close() Set tSC=$S(tSC'=0&&$$$ISERR(tSC):tSC, tSC'=0:tSCc, 1:$$$ERROR($$$GeneralError,"Failed to create %ResultSet "_$$$StatusDisplayString($g(%objlasterror))))
	Quit tSC
}

ClassMethod GetDescription() As %String
{
	quit $$$Text("Extended Business Rule","Ensemble")
}

}

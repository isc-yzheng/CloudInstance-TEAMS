/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Base class for Rule Extension classes that support Rule Editor plugins
Class Ens.Rule.Extension Extends %CSP.REST [ Abstract ]
{

/// Manual forwarding to config item class
ClassMethod DispatchRequest(pUrl As %String, pMethod As %String, pForwarded As %Boolean = 0, pArgs...) As %Status
{
	Quit:$classname()'="Ens.Rule.Extension" ##class(%CSP.REST)$this.DispatchRequest(pUrl,pMethod,pForwarded,pArgs...)
	Set tForward = $ZConvert(pArgs(4),"L")
	Set sc=$$GetAllDerivedClasses^%occLibrary("Ens.Rule.Extension",.derived)
	Set class="" For { Set class=$O(derived(class)) Quit:""=class  Continue:class="Ens.Rule.Extension"
		Set plugin = $$$comMemberKeyGet(class,$$$cCLASSparameter,"PluginName",$$$cPARAMdefault)
		Continue:""=plugin
		Quit:$ZConvert(plugin,"L")=tForward
	}
	Quit:""=class $$$ERROR($$$GeneralError,"No extension class found with plugin name '"_tForward_"' from URL piece '"_pUrl_"'")
	Set tSC = $classmethod(class,"DispatchRequest",pUrl,pMethod,1,pArgs...)
	Set tOutStream = pArgs(3)
	If $$$ISERR(tSC) {
		Set tOutStream.Attributes("Content-Type")="text/plain; charset=""UTF-8"""
		Set tOutStream.Attributes("ResponseCode")=..#HTTP500INTERNALSERVERERROR
		Do tOutStream.Write($$$StatusDisplayString(tSC))
	}
	Quit $$$OK
}

}

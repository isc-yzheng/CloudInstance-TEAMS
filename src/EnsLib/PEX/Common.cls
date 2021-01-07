/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class EnsLib.PEX.Common [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// Gateway Server
Property %gatewayHost As %String [ InitialExpression = "127.0.0.1", Internal ];

/// Gateway Port
Property %gatewayPort As %Integer [ InitialExpression = 44444, Internal ];

/// Number of seconds to wait on each attempt to connect to the Gateway
Property %gatewayTimeout As %Numeric(MAXVAL = 30000, MINVAL = 0) [ InitialExpression = 5 ];

/// One or more Classpaths (separated by '|' character) needed in addition to the ones configured in the Java Gateway Service
Property %gatewayExtraClasspaths As %String(MAXLEN = "");

/// The Gateway connection object
Property %gatewayConnection As %Net.Remote.Gateway;

/// The proxy object for the Gateway connection
Property %gatewayProxy As %RegisteredObject;

Property %remoteClassname As %String(MAXLEN = "") [ Internal ];

Property %remoteSettings As %String(MAXLEN = "") [ Internal ];

Method OnInit() As %Status
{
	set tSC = $$$OK
	try {
		set tSC = ..CheckGatewayConnection() quit:$$$ISERR(tSC)
		set remoteSettings = $tr(..%remoteSettings,$c(13))
		for i=1:1:$l(remoteSettings,$c(10)) {
			set oneLine = $p(remoteSettings,$c(10),i)
			set property = $p(oneLine,"=",1) continue:property=""
			set value = $p(oneLine,"=",2,*)
			try {
				set $property(..%gatewayProxy,property) = value
			} catch ex {
				$$$LOGWARNING(ex.DisplayString())
			}
		}
		do ..%gatewayProxy.dispatchOnInit($this)
	} catch ex {
		set tSC = ex.AsStatus()
		do ..CheckGatewayDisconnection()
	}
	quit tSC
}

Method OnTearDown() As %Status
{
	set tSC = $$$OK
	try {
		set tSC = ..CheckGatewayConnection() quit:$$$ISERR(tSC)
		do ..%gatewayProxy.dispatchOnTearDown($this)
	} catch ex {
		set tSC = ex.AsStatus()
	}
	do ..Disconnect()
	quit tSC
}

Method Connect() As %Status
{
	set tSC = $$$OK
	try {
		if $isObject(..%gatewayConnection)&&('..%gatewayConnection.Closed) quit
		;
		set classpaths = ##class(%ListOfDataTypes).%New()
		set delimiter = $s($system.Version.GetOS()="Windows":";",1:":")
		set extraClasspaths = $tr(..%gatewayExtraClasspaths,delimiter,"|")
		for i=1:1:$l(extraClasspaths,"|") set onePath = $p(extraClasspaths,"|",i) if onePath'="" do classpaths.Insert(onePath)
		;
		set ..%gatewayConnection = ##class(%Net.Remote.Gateway).%New()
		set tSC = ..%gatewayConnection.%Connect(..%gatewayHost,..%gatewayPort,$znspace,..%gatewayTimeout,classpaths) quit:$$$ISERR(tSC)
		;
		set ..%gatewayProxy = ##class(%Net.Remote.Object).%New(..%gatewayConnection,..%remoteClassname)
		;
		if ..%Extends("EnsLib.PEX.InboundAdapter") || ..%Extends("EnsLib.PEX.OutboundAdapter") {
			do ..%gatewayProxy.setIrisHandles($this,..BusinessHost)
		} elseif $this.%Extends("EnsLib.PEX.BusinessProcess") {
			do ..%gatewayProxy.setIrisHandles($this,$$$NULLOREF)
		} else {
			do ..%gatewayProxy.setIrisHandles($this,..Adapter)
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	if $$$ISERR(tSC) set (..%gatewayConnection,..%gatewayProxy) = $$$NULLOREF
	quit tSC
}

Method Disconnect() As %Status
{
	if $isObject(..%gatewayConnection) do ..%gatewayConnection.%Disconnect()
	set (..%gatewayConnection,..%gatewayProxy) = $$$NULLOREF
	quit $$$OK
}

Method CheckGatewayDisconnection() As %Boolean
{
	set isConnected = 0
	try { set isConnected = $$$ISOK(..%gatewayConnection.%Ping(,,,1,..%gatewayConnection.GatewayDevice)) } catch {}
	if 'isConnected set (..%gatewayConnection,..%gatewayProxy) = $$$NULLOREF
	quit isConnected
}

Method CheckGatewayConnection() As %Status
{
	quit ..Connect()
}

Method dispatchSendRequestSync(target, request, timeout, description) As %String
{
	if request'="",$isObject(request)=0 set request = ..deserialize(request)
	set tSC = ..SendRequestSync(target,request,.objResponse,timeout,description)
	if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
	if $isObject($g(objResponse)),objResponse.%IsA("EnsLib.PEX.Message") set objResponse = ..serialize(objResponse)
	quit $g(objResponse)
}

Method dispatchSendRequestAsync(target, request, description)
{
	if request'="",$isObject(request)=0 set request = ..deserialize(request)
	set tSC = ..SendRequestAsync(target,request,description)
	if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
	quit
}

ClassMethod serialize(message As EnsLib.PEX.Message) As %String
{
	if $g(message)=$$$NULLOREF quit ""
	quit message.%classname_":"_message.%jsonObject.%ToJSON()
}

ClassMethod deserialize(serialized As %String = "") As EnsLib.PEX.Message
{
	if serialized = "" {
		set message = $$$NULLOREF
	} else {
		set message = ##class(EnsLib.PEX.Message).%New()
		set message.%classname = $p(serialized,":",1)
		set json = $p(serialized,":",2,*)
		if json="" set json = "{}"
		set message.%jsonObject = ##class(%DynamicObject).%FromJSON(json)
	}
	quit message
}

}

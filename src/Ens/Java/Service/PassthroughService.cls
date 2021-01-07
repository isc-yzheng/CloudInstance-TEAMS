/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessService to create a Java
/// Business Service.
Class Ens.Java.Service.PassthroughService Extends Ens.Java.Service.Standard [ Abstract ]
{

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SendAsync";

Property SendAsync As %Boolean [ InitialExpression = 1 ];

/// Configuration item(s) to which to send file stream messages
Property TargetConfigNames As %String(MAXLEN = 1000);

/// Wrap the input stream object in a StreamContainer message object and send it.
Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	#dim tSC,tSC1 As %Status = $$$OK
	#dim tSource,iTarget,tOneTarget As %String
	#dim tSyncCommit As %Integer
	
	Set tSource = ..JarFile
	If $IsObject(pInput) {
		Set tRequest = ##class(Ens.StreamContainer).%New(pInput)
	} Else {
		Set tRequest = ##class(Ens.StringContainer).%New(pInput)
	}
	$$$SyncCommitSet(tSyncCommit)
	For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
		If tRequest.%IsA("Ens.StreamContainer") {
			$$$sysTRACE("Sending input Stream "_tRequest.Stream_"("_tRequest.Stream.Size_")"_$S(..SendAsync:" Async",1:" Sync")_" from '"_tSource_"' to '"_tOneTarget_"'")
		} Else {
			$$$sysTRACE("Sending input String "_tRequest.StringValue_$S(..SendAsync:" Async",1:" Sync")_" from '"_tSource_"' to '"_tOneTarget_"'")
		}
		If ..SendAsync {
			Set tSC1=..SendRequestAsync(tOneTarget,tRequest)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
		} Else {
			Set tSC1=..SendRequestSync(tOneTarget,tRequest,.pOutput)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
		}
	}
	$$$SyncCommitClear(tSyncCommit)
	Quit tSC
}

/// Return an array of connections for drawing lines on the config diagram.
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsErrors)

Class Ens.Util.XML.XDataEntityResolver Extends %XML.SAX.EntityResolver [ ClassType = "", ProcedureBlock, System = 3 ]
{

Property TargetClassName As %String;

Method resolveEntity(pPublicID As %String, pSystemID As %String) As %Library.Integer
{
	Set $ZT="Trap",tSC=$$$OK,tStream=$$$NULLOREF
	do {
		
		#; Pick out public or system ID
		If pPublicID]"" {
			Set tID=pPublicID
		} Else {  
 			Set tID=pSystemID
 		}
 		
 		#; Load the entity stream from the repository
 		Set tSC=..EntityFromXDATA(.tStream,..TargetClassName,tID)
 		If $$$ISERR(tSC) Quit
 		
 		If '$IsObject(tStream) Quit
 		
 		#; Wrap the returned stream
 		Set tStream=##class(%XML.SAX.StreamAdapter).%New(tStream)
 		If '$IsObject(tStream) Set tSC=%objlasterror Quit
 
	} while (0)
Exit
	Quit tStream
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

ClassMethod EntityFromXDATA(Output pStream As %BinaryStream, pClassName As %String, pXDATAName As %String) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	do {
		Set tClass=##class(%Dictionary.ClassDefinition).%OpenId(pClassName,0,.tSC)
		If $$$ISERR(tSC) Quit
		$$$ASSERT($IsObject(tClass))

		Set pStream=$$$NULLOREF		
		Set tIndex = tClass.XDatas.FindObjectId(pClassName_"||"_pXDATAName)
		If tIndex'="" {
			#; Get XDATA as stream
			Set pStream = tClass.XDatas.GetAt(tIndex).Data
			Quit:$IsObject(pStream)
		}
		#; If not found in ClassDefinition, try in CompiledClass		
		Set tClass=##class(%Dictionary.CompiledClass).%OpenId(pClassName,0,.tSC)
		If $$$ISERR(tSC) Quit
		$$$ASSERT($IsObject(tClass))
	
		Set tIndex = tClass.XDatas.FindObjectId(pClassName_"||"_pXDATAName)
		If tIndex'="" {
			#; Get XDATA as stream
			Set pStream = tClass.XDatas.GetAt(tIndex).Data
			$$$ASSERT($IsObject(pStream))
			Quit
		}
		Set tSC=$$$ERROR($$$EnsErrXDataBlockNotDefined,pClassName,pXDATAName)
	} while (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method %OnNew(initvalue As %RawString) As %Status [ Private, ProcedureBlock = 1 ]
{
	Set ..TargetClassName=initvalue
	Quit $$$OK
}

}

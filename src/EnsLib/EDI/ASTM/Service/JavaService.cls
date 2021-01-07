/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessService to create a Java
/// Business Service which treats incoming data as ASTM Virtual Documents.
Class EnsLib.EDI.ASTM.Service.JavaService Extends (Ens.Java.Service.AbstractEDI, EnsLib.EDI.ASTM.Service.Standard) [ Abstract ]
{

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As EnsLib.EDI.ASTM.Document) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tDocument As EnsLib.EDI.ASTM.Document
	
	If $IsObject(pInput) {
		Set tDocument=##class(EnsLib.EDI.ASTM.Document).ImportFromLibraryStream(pInput, .tSC)
	} Else {
		Set tDocument=##class(EnsLib.EDI.ASTM.Document).ImportFromString(pInput, .tSC)
	}
	Quit:$$$ISERR(tSC) tSC

	Quit ..standardOnProcessInput(tDocument, .pOutput)
}

}

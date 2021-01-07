/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessService to create a Java
/// Business Service which treats incoming data as EDIFACT Virtual Documents.
Class EnsLib.EDI.EDIFACT.Service.JavaService Extends (Ens.Java.Service.AbstractEDI, EnsLib.EDI.EDIFACT.Service.Standard) [ Abstract ]
{

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As EnsLib.EDI.EDIFACT.Document) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tDocument As EnsLib.EDI.EDIFACT.Document
	
	If $IsObject(pInput) {
		Set tDocument=##class(EnsLib.EDI.EDIFACT.Document).ImportFromLibraryStream(pInput, .tSC)
	} Else {
		Set tDocument=##class(EnsLib.EDI.EDIFACT.Document).ImportFromString(pInput, .tSC)
	}
	Quit:$$$ISERR(tSC) tSC

	Quit ..standardOnProcessInput(tDocument, .pOutput)
}

}

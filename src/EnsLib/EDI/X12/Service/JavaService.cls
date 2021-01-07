/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessService to create a Java
/// Business Service which treats incoming data as X12 Virtual Documents.
Class EnsLib.EDI.X12.Service.JavaService Extends (Ens.Java.Service.AbstractEDI, EnsLib.EDI.X12.Service.Standard) [ Abstract ]
{

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As EnsLib.EDI.X12.Document) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tDocument As EnsLib.EDI.X12.Document
	
	If $IsObject(pInput) {
		Set tDocument=##class(EnsLib.EDI.X12.Document).ImportFromLibraryStream(pInput, .tSC,,, ..DefRepSep,..DefCompSep,..DefSegTerm)
	} Else {
		Set tDocument=##class(EnsLib.EDI.X12.Document).ImportFromString(pInput, .tSC,,, ..DefRepSep,..DefCompSep,..DefSegTerm)	
	}
	Quit:$$$ISERR(tSC) tSC

	Quit ..standardOnProcessInput(tDocument, .pOutput, tSC)
}

}

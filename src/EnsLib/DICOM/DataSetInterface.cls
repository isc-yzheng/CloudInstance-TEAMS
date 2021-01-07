/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class EnsLib.DICOM.DataSetInterface Extends %RegisteredObject [ Abstract, System = 4 ]
{

// -------------------------------------------------------------------------------------------

/// This VDOC Compliant method gets the value of the given property.<br>
/// This is implemented by the document class.<br>
/// <var>pPropertyPath</var> contains the property path.<br>
/// For this class it is only applicable to the CommandSet and DataSet properties<br>
/// pFormat can be defined or not. If defined it can take the values "",0 or 1.<br>
/// pFormat of "" is the same as not defined.<br>
/// pFormat of 0 means return an empty string and not an error if the value does not exist. <br>
/// pFormat of 1 means force an error if a value does not exist. <br>
Method GetValueAt(pPropertyPath As %String, pFormat As %String, Output pSC As %Status, pDummy) As %String
{
	#; Subclass Responsibility
	$$$ASSERT(0)
	Quit ""
}

Method SetValueAt(pValue As %String, pPropertyPath As %String, pAction As %String = "set", pKey As %String = "") As %Status
{
	#; Subclass Responsibility
	$$$ASSERT(0)
	Quit ""
}

/// This VDOC Compliant method gets the next index for a subscripted VDOC reference
Method GetNextIndex(pPropertyPath As %String, pIndex As %String = "", Output pSC As %Status = {$$$OK}) As %String
{
	#; Subclass Responsibility
	$$$ASSERT(0)
	Quit ""
}

/// Retrieve the ValueRepresentation of the specified property
Method GetVRAt(pPropertyPath As %String, Output pVR As %String) As %Status
{
	#; Subclass Responsibility
	$$$ASSERT(0)
	Quit ""
}

/// Set the ValueRepresentation of the specified property
Method SetVRAt(pPropertyPath As %String, pVR As %String) As %Status
{
	#; Subclass Responsibility
	$$$ASSERT(0)
	Quit ""
}

// -------------------------------------------------------------------------------------------

Method OutputHtmlToDevice() As %Status
{
	#; Subclass Responsibility
	$$$ASSERT(0)
}

Method OutputVDocToDevice() As %Status
{
	#; Subclass Responsibility
	$$$ASSERT(0)
	Quit ""
}

Method OutputXmlToDevice() As %Status
{
	#; Subclass Responsibility
	$$$ASSERT(0)
	Quit ""
}

}

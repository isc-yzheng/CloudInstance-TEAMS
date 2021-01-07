/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsDICOM)

/// This class represents a DICOM Presentation Context. The Presentation Context specifies the Abstract Syntax ( request service )
/// and one or more Transfer Syntaxes. Presentation Contexts exist solely as members of a list within the related AssociationContext
/// class
Class EnsLib.DICOM.Util.PresentationContext Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, System = 4 ]
{

/// This holds the Abstract Syntax
Property AbstractSyntax As %String [ Required ];

/// This holds the list of Transfer Syntaxes
Property TransferSyntaxes As list Of %String;

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	#dim tSC As %Status  = $$$OK
	#dim tI  As %Integer
	#dim tTS As %String
	
	do {
		#; Allow the special wildcard
		If ..AbstractSyntax="*" Quit
		
		#; Ensure the Abstract Syntax is recognized
		If ..AbstractSyntax=""||'($Data(^EnsDICOM.Dictionary("as","u",..AbstractSyntax))) { 
			Set tSC=$$$EnsError($$$EnsDICOMUnrecognizedAbstractSyntax,..AbstractSyntax) Quit
		}
		
		#; Ensure the transfer syntaxes are supported
		For tI=1:1:..TransferSyntaxes.Count() {
			Set tTS=..TransferSyntaxes.GetAt(tI) If '$$$TRANSFERSYNTAXISSUPPORTED(tTS) {
				Set tSC=$$$EnsError($$$EnsDICOMTransferSyntaxNotSupported,tTS) Quit
			}
		}
		
	} while (0)
	Quit tSC
}

Method %OnNew(initvalue As %RawString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..AbstractSyntax=$Get(initvalue)
	Quit $$$OK
}

Storage Default
{
<Data name="PresentationContextState">
<Value name="1">
<Value>AbstractSyntax</Value>
</Value>
<Value name="2">
<Value>TransferSyntaxes</Value>
</Value>
</Data>
<State>PresentationContextState</State>
<StreamLocation>^EnsLib.DICO5A3.Presentation7E1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// This is the DTL Compiler. It it called primarily during the compilation
/// process of subclasses of Ens.DataTransformDTL that define a DTL XDATA block. 
/// However, it can be called to directly compile a file or a stream containing DTL
/// 
/// These debug flags affect the diagnostic output of the compiler:-
/// ^Ens.Debug("ShowGeneratedXML") - Displays xml reconstructed from the parse
/// tree to the current device
Class Ens.DTL.Compiler Extends %RegisteredObject [ ClassType = "", ProcedureBlock, System = 3 ]
{

/// This holds the language of the current compilation
Property Language As %String;

/// This holds the root of the Parse Tree
Property Transform As Ens.DTL.Transform;

/// This holds the name of the data transform class
Property ClassName As %String;

/// This holds the method implementation stream
Property Implementation As %RawString [ Transient ];

Property Indent As %String [ InitialExpression = {$char(9)} ];

/// Accesor for Language
Method LanguageGet() As %String
{
	#; Language is specfied by the Transform
	Set tLanguage=..Transform.Language
	
	#; Only legal languages are objectscript (cache) and basic
	$$$ASSERT(tLanguage=$$$objectscript||(tLanguage=$$$basic))
	
	Quit tLanguage
}

ClassMethod ParseStream(Output pTransform As Ens.DTL.Transform, pStream As %BinaryStream) As %Status
{
	Set tSC=$$$OK
	Try {

		Set tParser=##class(Ens.DTL.Parser).%New()
		$$$ASSERT($IsObject(tParser))
		
		#; Import the Transform definition from the specified stream
		Set tSC=tParser.ParseStream(.pTransform,pStream)	
	
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Parse the DTL contained in the supplied stream and generate a stream
/// containing the implementation of the Transform method
ClassMethod CompileStream(pStream As %BinaryStream, pClass As %Dictionary.ClassDefinition, pMethod As %Stream.MethodGenerator) As %Status
{
	Set tSC=$$$OK
	Try {

		Set tSC=..ParseStream(.tTransform,pStream)
		If $$$ISERR(tSC) Quit
		
		$$$ASSERT($IsObject(tTransform)&&tTransform.%Extends("Ens.DTL.Transform"))
	
		#; Create a validation context
		Set tValidationContext=##class(Ens.DTL.ValidationContext).%New()
		$$$ASSERT($IsObject(tValidationContext))
		
		#; Now do sanity Check
		Set tValidateStatus=$$$OK,tSC=tTransform.Validate(.tValidateStatus,tValidationContext)
		If $$$ISERR(tSC) Quit
		
		#; Display it for now
		If $$$ISERR(tValidateStatus) Do $System.Status.DisplayError(tValidateStatus)
		
		If tValidationContext.IsFatal=1 {
			Set tSC=$$$ERROR($$$EnsErrDTLCannotBeCompiled) Quit
		}
		
		If $G(^Ens.Debug("ShowGeneratedXML")) {
			
			#; Generate the XML
			Set tSC=..GenerateXML(tTransform)
			If $$$ISERR(tSC) Quit
		}
		
		#; Generate the Code
		Set tSC=..GenerateCode(tTransform,pClass,pMethod)
	
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod GenerateCode(pTransform As Ens.DTL.Transform, pClass As %Dictionary.ClassDefinition, pMethod As %Stream.MethodGenerator) As %Status
{
	Set tSC=$$$OK
	Try {
		#; Create an instance of the compiler
		Set tCompiler=##class(Ens.DTL.Compiler).%New()
		$$$ASSERT($IsObject(tCompiler))

		#; Initialize it
		Set tCompiler.Transform=pTransform
		Set tCompiler.ClassName=pClass.Name
		Set tCompiler.Implementation=pMethod

		#; Generate the code
		Set tSC=pTransform.GenerateCode(tCompiler)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod GenerateXML(pTransform As Ens.DTL.Transform) As %Status
{
	Set tSC=$$$OK
	Try {
			
		Set tStream=##class(%GlobalBinaryStream).%New()
		$$$ASSERT($IsObject(tStream))
			
		Do tStream.WriteLine(""),tStream.WriteLine("<?xml version='1.0' ?>")
		Set tSC=pTransform.GenerateXML(tStream)
		If $$$ISERR(tSC) Quit
		
		Do tStream.OutputToDevice()
		
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method AddIndent()
{
	Set ..Indent = ..Indent _ $char(9)
}

Method RemoveIndent()
{
	If $length(..Indent) > 1 {
		Set ..Indent = $extract(..Indent,1,*-1)
	}
}

}

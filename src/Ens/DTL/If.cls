/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class represents the If Action. A supplied condition expression is evaluated. If the condition evaluates to true
/// the sequence of activities defined within the True activity list are executed. If the conditions evaluates to false then
/// the sequence of activities defined within the False activity list are exectued. At least one of the True or False activity
/// lists MUST be none empty.
Class Ens.DTL.If Extends Ens.DTL.Action [ ClassType = "", ProcedureBlock, System = 3 ]
{

XData Example
{
<if condition="1">
 <true>
 	<trace value="condition evaluates to true"/>
 </true>
 <false>
 	<trace value="condition evaluates to false"/>
 </false>
</if>
}

Parameter TAGNAME = "if";

/// This holds the selection condition
Property Condition As %String;

/// This holds the activities to be performed if the condition
/// evaluates to true
Property True As Ens.DTL.ActionList;

/// This holds the activities to be performed if the condition
/// evaluates to be false
Property False As Ens.DTL.ActionList;

Method GenerateCode(pCompiler As Ens.DTL.Compiler) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tCondition = ..Condition
		Set tLanguage = pCompiler.Language

		#; replace {} with document interface API
		Set tCondition = ##class(Ens.VDoc.Utils).GetGetCode(tCondition,tLanguage,1)
		#; correctly resolve the collection syntax for non-VDoc references
		If (tCondition [ ".(") {
			Set tCondition = ##class(Ens.DTL.Transform).decoratePropString(tCondition)
		}
		Set tStartIf = $select(pCompiler.Language = $$$objectscript: "{", 1: "Then")
		Set tEndIf = $select(pCompiler.Language = $$$objectscript: "}", 1: "End If")
		
		#; <true> only
		If (..True.Count()>0 && (..False.Count() = 0))
		{
			$$$PCIndent(pCompiler.Indent,"If ("_tCondition_") " _ tStartIf)
			Do pCompiler.AddIndent()
			Set tSC=..True.GenerateCode(pCompiler)
			If $$$ISERR(tSC) Quit
			Do pCompiler.RemoveIndent()
			$$$PCIndent(pCompiler.Indent,tEndIf)
		} 
		#; <false> only
		elseif (..False.Count()>0 && (..True.Count() = 0))
		{	
			Set tFalseCondition = $select(pCompiler.Language = $$$objectscript: "('("_tCondition_"))", 1: "Not ("_tCondition_")")
			$$$PCIndent(pCompiler.Indent,"If "_tFalseCondition_tStartIf)
			Do pCompiler.AddIndent()
			Set tSC=..False.GenerateCode(pCompiler)
			If $$$ISERR(tSC) Quit
			Do pCompiler.RemoveIndent()
			$$$PCIndent(pCompiler.Indent,tEndIf)
		} 
		else 
		#; <true> and <false>
		{
			Set tElse = $select(pCompiler.Language = $$$objectscript: "} Else {", 1: "Else")
			$$$PCIndent(pCompiler.Indent,"If ("_tCondition_") " _ tStartIf)
			Do pCompiler.AddIndent()
			Set tSC=..True.GenerateCode(pCompiler)
			If $$$ISERR(tSC) Quit
			Do pCompiler.RemoveIndent()
			$$$PCIndent(pCompiler.Indent,tElse)
			Do pCompiler.AddIndent()
			Set tSC=..False.GenerateCode(pCompiler)
			If $$$ISERR(tSC) Quit
			Do pCompiler.RemoveIndent()
			$$$PCIndent(pCompiler.Indent,tEndIf)
		} 
		
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method GenerateXML(pStream As %BinaryStream) As %Status
{
	Set tSC=$$$OK
	Try {
		Do pStream.Write("<if ")
		
		#; Generate the condition
		Do pStream.Write("condition="_$$$EA(..Condition))
		If ..Disabled Do pStream.Write("disabled="_$$$EA(1))

		If '..Expanded Do ..WriteExpandedAttribute(pStream)

		Do pStream.WriteLine(">")
		
		Do ..WriteAnnotationXML(pStream,0)
		
		#; The Schema ensures that there is at most one <true> or <false> element
		#; and requires that at least one <true> or <false> element be present
		If ..True.Count() {
			
			#; Generate the optional <true> activity list
			Do pStream.WriteLine("<true>")
			Set tSC=..True.GenerateXML(pStream)
			If $$$ISERR(tSC) Quit
			Do pStream.WriteLine("</true>")
		}
		
		If ..False.Count() {
			
			#; Generate the optional <false> activity list
			Do pStream.WriteLine("<false>")
			Set tSC=..False.GenerateXML(pStream)
			If $$$ISERR(tSC) Quit
			Do pStream.WriteLine("</false>")
		}
		
		if (..True.Count() = 0 && (..False.Count() = 0)) {
			
			#; Generate empty <true> and <false> tags to satify schema
			Do pStream.WriteLine("<true/>")
			Do pStream.WriteLine("<false/>")
		}
		
		Do pStream.WriteLine("</if>")
		
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method %OnNew(initvalue As %RawString) As %Status [ Private ]
{
	Set tSC=$$$OK
	Try {
		Set ..True=##class(Ens.DTL.ActionList).%New()
		$$$ASSERT($IsObject(..True))
		
		Set ..False=##class(Ens.DTL.ActionList).%New()
		$$$ASSERT($IsObject(..False))
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Perform a sanity check on the nodes in the parse tree
Method Validate(ByRef pStatus As %Status, pContext As Ens.DTL.ValidationContext) As %Status
{
	Set tSC=$$$OK
	Try {
		#; Must know the condition we want to test
		If ..Condition="" {
			Set pStatus=$$$ADDSC(pStatus,$$$ERROR($$$EnsErrDTLNodeValidation,"condition",..DisplayName()))
		}
		
		#; Both true and false should be validated
		Set tSC=..True.Validate(.pStatus,pContext)
		If $$$ISERR(tSC) Quit
		
		Set tSC=..False.Validate(.pStatus,pContext)
		If $$$ISERR(tSC) Quit
		
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Provide a user readable string which identifies this node
Method DisplayName() As %String
{
	Quit "If"
}

}

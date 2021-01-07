/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Allows conditions to be evaluated and actions to be performed depending
/// upon their truth value.
Class Ens.DTL.Switch Extends Ens.DTL.Action [ ClassType = "", ProcedureBlock, System = 3 ]
{

XData Example
{
<switch>
<case condition='source.StringValue=""'>
	<assign property="target.StringValue" value="DNF"/>
</case>
<case condition='source.StringValue="1"'>
	<assign property="target.StringValue" value="Gold"/>
</case>
<case condition='source.StringValue="2"'>
	<assign property="target.StringValue" value="Silver"/>
</case>
<case condition='source.StringValue="1"'>
	<assign property="target.StringValue" value="Bronze"/>
</case>
<default>
	<assign property="target.StringValue" value="Finished"/>
</default>
</switch>
}

Parameter TAGNAME = "switch";

Property Cases As Ens.DTL.CaseList;

Method %OnNew(initvalue As %RawString) As %Status [ Private ]
{
	#dim tSC=$$$OK
	#dim ex As %Exception.AbstractException

	Try {
		Set ..Cases=##class(Ens.DTL.CaseList).%New()
		$$$ASSERT($IsObject(..Cases))

	} Catch ex {

		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

Method GenerateCode(pCompiler As Ens.DTL.Compiler) As %Status
{

	#dim tSC=$$$OK
	#dim ex As %Exception.AbstractException

	Try {

		#dim tOpenedIf As %Boolean = 0
		#dim tI, tCase, tCondition
		#dim tOpeningIfCase = 0

		For tI=1:1:..Cases.Count() {

			Set tCase=..Cases.GetAt(tI)
			If tCase.Disabled Continue
			If tOpeningIfCase = 0 Set tOpeningIfCase = tI

			If pCompiler.Language=$$$objectscript {

				If tCase.%ClassName()="Case" {

					#; This value supports the VDoc syntax
					Set tCondition=##class(Ens.VDoc.Utils).GetGetCode(tCase.Condition,$$$objectscript,1)
					#; correctly resolve the collection syntax for non-VDoc references
					If (tCondition [ ".(") {
						Set tCondition = ##class(Ens.DTL.Transform).decoratePropString(tCondition)
					}

					If tI=tOpeningIfCase {

						$$$PCIndent(pCompiler.Indent,"If ("_tCondition_") {")
						Set tOpenedIf = 1
						Do pCompiler.AddIndent()

					} else {

						Do pCompiler.RemoveIndent()
						$$$PCIndent(pCompiler.Indent,"} elseif ("_tCondition_") {")
						Do pCompiler.AddIndent()
					}

				} else {

					#; It's the default but ought not be 1. Only code if something to write
					if tOpenedIf && (tCase.Actions.Count()) {

							Do pCompiler.RemoveIndent()
							$$$PCIndent(pCompiler.Indent,"} else {")
							Do pCompiler.AddIndent()

					}

				}

			} else {

				If tCase.%ClassName()="Case" {

					#; This value supports the VDoc syntax
					Set tCondition=##class(Ens.VDoc.Utils).GetGetCode(tCase.Condition,"",1)
					#; correctly resolve the collection syntax for non-VDoc references
					If (tCondition [ ".(") {
						Set tCondition = ##class(Ens.DTL.Transform).decoratePropString(tCondition)
					}

					If tI=1 {

						$$$PCIndent(pCompiler.Indent,"If ("_tCondition_") Then")
						Set tOpenedIf = 1

					} else {

						$$$PCIndent(pCompiler.Indent,"ElseIf ("_tCondition_") Then")

					}

				} else {

					#; It's the default but ought not be 1
					if tOpenedIf && (tCase.Actions.Count()) $$$PCIndent(pCompiler.Indent,"Else")

				}

			}

			#; Dont generate code unless there are some activites to perform
			if (tCase.Actions.Count()) {

				Set tSC=tCase.GenerateCode(pCompiler)
				If $$$ISERR(tSC) Quit

			}

		}

		if tOpenedIf {

			If pCompiler.Language=$$$objectscript {

				Do pCompiler.RemoveIndent()
				$$$PCIndent(pCompiler.Indent,"}")

			} else {

				$$$PCIndent(pCompiler.Indent,"End If")

			}

		}

	} Catch ex {

		Set tSC = ex.AsStatus()

	}

	Quit tSC
}

/// Perform a sanity check on the nodes in the parse tree
Method Validate(ByRef pStatus As %Status, pContext As Ens.DTL.ValidationContext) As %Status
{
	#dim tSC=$$$OK
	#dim ex As %Exception.AbstractException

	Try {

		#; Delegate to the cases
		Set tSC=..Cases.Validate(.pStatus,pContext)

	} Catch ex {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

Method GenerateXML(pStream As %BinaryStream) As %Status
{
	#dim tSC=$$$OK
	#dim ex As %Exception.AbstractException

	Try {

		Do pStream.Write("<switch ")

		If ..Disabled Do pStream.Write(" disabled="_$$$EA(1))

		If '..Expanded Do ..WriteExpandedAttribute(pStream)

		If ..Annotation'=""||(..Cases.Count()) {

			Do pStream.WriteLine(">")
			Do ..WriteAnnotationXML(pStream,0)

			Set tSC=..Cases.GenerateXML(pStream)
			If $$$ISERR(tSC) Quit

			Do pStream.WriteLine("</switch>")

		} else {

			Do pStream.WriteLine("/>")

		}

	} Catch ex {

		Set tSC = ex.AsStatus()

	}

	Quit tSC
}

/// Provide a user readable string which identifies this node
Method DisplayName() As %String
{
	Quit "Switch"
}

}

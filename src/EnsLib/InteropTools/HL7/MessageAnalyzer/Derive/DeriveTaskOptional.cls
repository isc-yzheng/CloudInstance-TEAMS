/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.DeriveTaskOptional [ Abstract ]
{

ClassMethod StepImpl(pIndex As %Integer, pTree As Tree, pType As %String, pAnySpecial As %Boolean, ByRef pItems, pConfig As Config, pSession As Logger) As Tree
{
	If pType="C" {
		
		Set tNewTree=pTree.Clone()
		
		// look for empty items in the choice
		Set tEmpty=""
		Set tSomeNonEmpty=0
		For tI=1:1:$Get(pItems) {
		
			// unless it's a structure ..
			If $Data(pItems(tI),tItem)#10 {
		
				If tItem="" {
					Set tEmpty=$ListBuild(tI)_tEmpty // add in reverse order to minimize tree-shuffling when we delete
				}
				Else {
					Set tSomeNonEmpty=1
				}
			}
		}
		
		// if any of the items are empty, but not ALL of the items are empty ..
		If tEmpty'="",tSomeNonEmpty {
		
			// delete the empty items
			Set tPtrI=0 While $ListNext(tEmpty,tPtrI,tElemI) {
				Do tNewTree.DeletePointerAt(pIndex,tElemI)
			}
			
			// create an optional node containing the current (choice) node, updating references to the choice to be references to the optional
			Set tOptionalIndex=##class(TreeModel).CreateOptional(pIndex,tNewTree,"")
			
			Quit tNewTree
		}
	}
	
	Else {
		$$$THROW("Don't know how to handle node type '"_pType_"'")
	}
	
	Quit ""
}

}

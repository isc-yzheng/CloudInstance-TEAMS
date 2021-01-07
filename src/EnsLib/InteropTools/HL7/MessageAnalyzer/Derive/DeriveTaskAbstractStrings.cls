/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.DeriveTaskAbstractStrings
{

ClassMethod StepImpl(pIndex As %Integer, pTree As Tree, pType As %String, pAnySpecial As %Boolean, ByRef pItems, pConfig As Config, pLogger As Logger) As Tree
{
	If pType="C" {
		
		If pAnySpecial {
			$$$LOGOUTPUTIFCONFIG1X(pLogger,"DeriveTaskAbstractStrings: Don't know how to handle special items in choice","LOGABSTRACTSTRINGS",pConfig)
			Quit ""
		}
		
		If ##class(TreeModel).IsChoiceWithEmptyString(pTree,pIndex) {		
			$$$LOGOUTPUTIFCONFIG1X(pLogger,"DeriveTaskAbstractStrings: Can't handle empty string in choice","LOGABSTRACTSTRINGS",pConfig)
			Quit "" // the Optional heuristic will fix this
		}

		Set tNewTree=pTree.Clone()
		
		Set tLines=##class(TreeModel).AsAbstractStringsLines(pTree,pIndex)
		
		If $ListLength(tLines)<2 {
			Quit "" // no point in abstract strings analysis if there are fewer than 2 rows
		}
		
		Set tAS=##class(AbstractStrings).%New(tLines,1,pConfig,pLogger)
		
		Kill tCollections
		Do tAS.GetCollections(.tCollections)
		
		Do tNewTree.DeleteAllPointersAt(pIndex)
		
		Set tPatterns=""
		Set tAnyErrors=0
		For tI=1:1:tCollections {
		
			Set tColl=tCollections(tI)
	
			Set $ListBuild(tError,tOnePattern)=tColl.DerivePattern("Collection"_tI,tNewTree,pIndex)
			If tError="" {
			
				$$$DBOUT("Tree pattern="_tNewTree.Pattern())
				$$$DBOUT("Derived pattern="_tOnePattern)
				
				Set tPatterns=tPatterns_$ListBuild(tOnePattern)
			}
			Else {
			
				$$$DBOUT(".. failed to derive pattern for '"_tColl.ShowCLIList()_"': "_tError)
				
				$$$LOGOUTPUTIFCONFIG1X(pLogger,"DeriveTaskAbstractStrings: Failed to derive pattern for '"_tColl.ShowCLIList()_"': "_tError,"LOGABSTRACTSTRINGS",pConfig)
				Set tAnyErrors=1
			}
		}
	
		If (tPatterns="") || tAnyErrors {
			Quit "" // no patterns derived
		}
		
		If $$$DBFLAG {ZWrite tPatterns Write !}
		
		If tPatterns=pTree.Pattern() {
			Write "SAME PATTERN DERIVED",!
			Quit ""
		}
	
		Quit tNewTree
	}	

	Else {
		$$$THROW("DeriveTaskAbstractStrings: Don't know how to handle node type '"_pType_"'")
	}
	
	Quit ""
}

}

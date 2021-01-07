/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser.MarkingTraverser Extends BaseTraverser
{

Property MarkSeen As %String [ MultiDimensional, Private ];

/// Aliases(contextvar,aliastype)=listofelementnames
/// <p>
/// aliastype is 0 for NoteProgress, 1 for BacktrackElement
Property Aliases As %List [ MultiDimensional, Private ];

Property DontTrim As %String [ MultiDimensional, Private ];

Property Trim As %Integer [ MultiDimensional, Private ];

Method Seen(pElement As ElementBase)
{
	#Dim tAliases,tMarkSeen,tDontTrim
	
	If '$Data(..MarkSeen(pElement.ElementName)) {
		Do pElement.OnMarkingTraversal(.tMarkSeen,.tAliases,.tDontTrim,..Machine)
		Merge ..MarkSeen=tMarkSeen
		Merge ..Aliases=tAliases
		Merge ..DontTrim=tDontTrim
	}
}

Method Unseen(pUnseenNames As %List)
{
	// not of interest
}

Method Finalize()
{
	#Dim tContextVar,tNoteProgressList,tBacktrackList,tI,tNP,tBT,tMismatch,tTrim,tCollSize

	// collect trim list from aliases
	Set tContextVar="" While 1 {
		Set tContextVar=$Order(..Aliases(tContextVar)) If tContextVar="" {Quit}
		
		// omit dont-trim vars and vars without both lists
		If '$Data(..DontTrim(tContextVar)),$Data(..Aliases(tContextVar,0),tNoteProgressList)#10,$Data(..Aliases(tContextVar,1),tBacktrackList)#10 {
		
			// the list lengths must match
			If $ListLength(tNoteProgressList)=$ListLength(tBacktrackList) {
			
				Set tCollSize=$ListLength(tNoteProgressList)
				
				// the list length must exceed 1 for there to be anything to trim
				If tCollSize>1 {
				
					// check that the context vars match up
					Set tMismatch=0
					For tI=1:1:tCollSize {
						Set tNP=$List(tNoteProgressList,tI)
						Set tBT=$List(tBacktrackList,tI)
						Set tNPCV=..Machine.GetAt(tNP).GetContextVar()
						Set tBTCV=..Machine.GetAt(tBT).GetContextVar()
						If tNPCV'=tBTCV {
							Set tMismatch=1
							Quit
						}
					}
					
					// unless there was a mismatch ..
					If 'tMismatch {
						Set ..Trim($List(tNoteProgressList,1))=tCollSize-1
						Set ..Trim($List(tBacktrackList,tCollSize))=tCollSize-1
					}
				}
			}
		}
	}
}

Method GetTrimList(Output pTrim)
{
	$$$SHOULDBEUNDEF(pTrim)
	
	Merge pTrim=..Trim
}

}

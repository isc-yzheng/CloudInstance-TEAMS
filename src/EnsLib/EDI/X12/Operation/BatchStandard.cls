/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.EDI.X12.Operation.BatchStandard Extends EnsLib.EDI.X12.Operation.Standard [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// Name of file to output the document(s) to. May include timestamp specifiers. The %f specifier if present will be 
/// replaced with the name of the document's original source stream (stripped of characters illegal in filenames).<p/>
/// See the method Ens.Util.File.CreateTimestamp() for documentation of timestamping options.
Property Filename As %String(MAXLEN = 1000, MINLEN = 1) [ InitialExpression = "%f_%Q", Required ];

/// When writing a message that has a batch parent, output the batch headers first, and follow up with
///  the batch trailers when triggered by the final batch parent header message or by a file name change. <br/>
/// All child messages of a batch parent message will be written out unless already written previously while AutoBatchParentSegs=true.
Property AutoBatchParentSegs As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS As %String = "Filename:Basic,AutoBatchParentSegs,AutoBatchCompletionTimeout";

/// How long to wait before adding the trailing segments to batch output which has been unmodified for a period of time, but does not yet have
/// the trailing segments necessary to make a complete batch document.
/// 0 means never timeout.
/// This is only relevant if AutoBatchParentSegs is turned on.   
Property AutoBatchCompletionTimeout As %Numeric [ InitialExpression = 0 ];

/// This user callback method is called just after %OnNew()
Method OnInit() As %Status
{
	If ..AutoBatchCompletionTimeout {
		#; Check for any files which are already open and set the KeepaliveInterval
		Do ..completeUnfinishedBatches()
	} Else {
		Set ..Adapter.KeepaliveInterval = 0
	}
	Quit ##super()
}

/* (override the InitialExpression inherited for this Setting from the base class) */
/// This method is for File and FTP Operations: per-message batch output with no reply. TCP and HTTP Operations
/// receive reply messages and only support entire batch output.
Method OnMessage(pRequest As EnsLib.EDI.X12.Document, Output pResponse As EnsLib.EDI.X12.Document) As %Status
{
	#def1arg Files(%k) $$$EnsStaticAppData(..%ConfigName,"Files",%k)
	#def1arg Count(%k) $$$EnsStaticAppData(..%ConfigName,"Count",%k)
	#def1arg Parents(%k) $$$EnsStaticAppData(..%ConfigName,"Parents",%k)
	#def1arg OpenFiles(%k) $$$EnsStaticAppData(..%ConfigName,"OpenFiles",%k)
	#define MapCtlChars(%s) $TR(%s,$C(1,2,3,9,10,11,13,28),"123tlsre")

	Set pResponse=$$$NULLOREF
	Set tSC=..validateAndIndex(pRequest)  Quit:$$$ISERR(tSC) tSC

	Set tParentRef=pRequest.ParentId, tId=pRequest.%Id()
	Set tDoParent=tParentRef&&..AutoBatchParentSegs&&'..Adapter.Overwrite
	If 'tDoParent {
		Set tKey=tId, tOldFilename=$G($$$Files(tKey))
		If ""'=tOldFilename { ; we've already done output for this batch; finish it out now.
			Set tSC=..outputHeaders(tKey,$G($$$Parents(tKey)),"")
			Kill $$$Files(tKey),$$$Parents(tKey),$$$Count(tKey),$$$OpenFiles(tOldFilename)
			Quit tSC
		}
		Set tFilename=..Adapter.CreateFilename(##class(%File).GetFilename($P(pRequest.Source,$C(13))),..Filename)
		Set tSeparators=$S(""'=..Separators:..Separators, 1:pRequest.Separators)
	} Else {
		#; Get the filename and output appropriate header and trailer segments
		Set tParentIds=pRequest.ParentIds
		Set tKey=$P($LI(tParentIds,-1),":")
		Set tTopParent=##class(EnsLib.EDI.X12.Document).%OpenId(tKey)

		Set tFilename=..Adapter.CreateFilename(##class(%File).GetFilename($P(tTopParent.Source,$C(13))),..Filename)
		Set tOldFilename=$G($$$Files(tKey))

		If tOldFilename'=tFilename {
			#; New output; finish previous Batch if any
			If ""'=tOldFilename {
				$$$catTRACE("file","Finishing old file "_tOldFilename_" using key "_tKey_", parents '"_$G($$$Parents(tKey))_"'")
				Set tSC=..outputHeaders(tKey,$G($$$Parents(tKey)),"")
				If $$$ISERR(tSC) $$$LOGSTATUS(tSC)  Set tSC=$$$OK ; not fatal; start the new one anyway
				Kill $$$Files(tKey),$$$Parents(tKey),$$$Count(tKey),$$$OpenFiles(tOldFilename)
			}
			#; Output starting Batch headers up to the current segment
			Quit:'pRequest.SegCount tSC
			
			If $D($$$OpenFiles(tFilename)) {  ; want to make sure we add trailers before headers if file already open
				If '..fileExists(tFilename) {
					Set tOldParentIds = $$$OpenFiles(tFilename)
					Set tOldKey=$P($LI(tOldParentIds,-1),":")
					Kill $$$Files(tOldKey),$$$Parents(tOldKey),$$$Count(tOldKey),$$$OpenFiles(tFilename)
				} Else {
					Set tOldParentIds = $$$OpenFiles(tFilename)
					Set tOldKey=$P($LI(tOldParentIds,-1),":")
					$$$catTRACE("file","Continuing file "_tFilename_" using key "_tKey_", old parents '"_tOldParentIds_"', parents '"_tParentIds_"'")
					Set tSC = ..outputHeaders(tOldKey,tOldParentIds,"")
					If $$$ISERR(tSC) $$$LOGSTATUS(tSC)  Set tSC=$$$OK ; not fatal; start the new one anyway
					Kill $$$Files(tOldKey),$$$Parents(tOldKey),$$$Count(tOldKey),$$$OpenFiles(tFilename)
				}
			} Else {
				$$$catTRACE("file","Starting "_tFilename_" using key "_tKey_", parents "_tParentIds)
			}
			Set tSeparators=$S(""'=..Separators:..Separators, 1:tTopParent.Separators)
			Set $$$Files(tKey)=tFilename, $$$Files(tKey,"seps")=tSeparators
			Set $$$OpenFiles(tFilename)=tParentIds
			Set tSC=..outputHeaders(tKey,"",tParentIds)  Quit:$$$ISERR(tSC) tSC
		} ElseIf tParentIds'=$G($$$Parents(tKey)) {
			#; Output intermediate Batch trailers/headers

			#; Ignore any batch parent whose children we already have done output for, or empty message
			Set tLastCountRefHavingMyId=$O($$$Count(tKey,tId+1_":"),-1)
			Set tChildrenDone=$S(+tId'=+tLastCountRefHavingMyId:0, 1:$G($$$Count(tKey,tLastCountRefHavingMyId)))

			$$$catTRACE("file","Continuing file "_tFilename_" using key "_tKey_", old parents '"_$G($$$Parents(tKey))_"', parents '"_tParentIds_"'")
			Set tSC=..outputHeaders(tKey,$G($$$Parents(tKey)),tParentIds)  Quit:$$$ISERR(tSC) tSC
			If ""=tParentIds {
				Kill $$$Files(tKey),$$$Parents(tKey),$$$Count(tKey), $$$OpenFiles(tFilename)
				Quit tSC
			}
			If +tChildrenDone||'pRequest.SegCount {
				Set $$$Parents(tKey)=tParentIds
				Set $$$OpenFiles(tFilename) = tParentIds
				Quit tSC
			}
		}
		Set tSeparators=$$$Files(tKey,"seps")
	}	
	#; Output the main Document
	Set tSC=..outputDocument(tFilename,pRequest,tSeparators,'tDoParent)  Quit:$$$ISERR(tSC) tSC
	If 'tDoParent {
		$$$sysTRACE("After writing document "_pRequest_"/"_tId_" to file "_tFilename_" using framing "_$$$MapCtlChars(..%outFraming))
	} Else {
		Set $$$Parents(tKey)=tParentIds
		Set $$$OpenFiles(tFilename)=tParentIds
		Set $$$OpenFiles(tFilename,"LastModified") = $zdatetime($ztimestamp,-2)
		Set:'$G($$$OpenFiles("OldestUnmodified")) $$$OpenFiles("OldestUnmodified") = $$$OpenFiles(tFilename,"LastModified")
		Set tCount=$S($D($$$Count(tKey,tParentRef),tCount):tCount+1, 1:1), $$$Count(tKey,tParentRef)=tCount
		$$$sysTRACE("After writing message "_tCount_" at level "_$LL(tParentIds)_" "_pRequest_"/"_tId_" to file "_tFilename_" using key "_tKey_" and framing "_$$$MapCtlChars(..%outFraming))
	}
	If ..AutoBatchCompletionTimeout && $G($$$OpenFiles("OldestUnmodified")) {
		#; Make sure to check again once AutoBatchCompletionTimeout has passed since the oldest remaining open file was last modified. 
		Set ..Adapter.KeepaliveInterval = (..AutoBatchCompletionTimeout - ($zdatetime($ztimestamp,-2) - $$$OpenFiles("OldestUnmodified")))
		Do:(..Adapter.KeepaliveInterval<=0) ..completeUnfinishedBatches() ;complete overdue batches
	}
	Quit tSC
}

Method outputHeaders(pKey As %String, pOldParents As %String, pParents As %String) As %Status
{
	#def1arg Files(%k) $$$EnsStaticAppData(..%ConfigName,"Files",%k)
	#def1arg Count(%k) $$$EnsStaticAppData(..%ConfigName,"Count",%k)

	#; Output group header(s) - walk up the parents ladder
	Set tNumOld=$LL(pOldParents), tNum=$LL(pParents)
	
	#; Find first non-matching parent level
	If tNum {
		For i=1:1:tNum { Set tOldParentRef=$LG(pOldParents,tNumOld+1-i), tParentRef=$LI(pParents,tNum+1-i)  Quit:tOldParentRef'=tParentRef }
	} Else {
		Quit:'tNumOld $$$OK
		Set i=1, tParentRef="", tOldParentRef=$LG(pOldParents,tNumOld)
	}
	Set tOldId=$P(tOldParentRef,":"), tNewId=$P(tParentRef,":"), tNewSeg=$P(tParentRef,":",2)

	#; Output trailer(s) for previous group
	Set tSC=$$$OK, tParentRef=""
	For j=1:1:tNumOld+1-i { Set tChild=tParentRef, tParentRef=$LG(pOldParents,j)
		Set tId=$P(tParentRef,":"), tSeg=$P(tParentRef,":",2), tCount=$G($$$Count(pKey,tParentRef))
		Set:""'=tId tParent=##class(EnsLib.EDI.X12.Document).%OpenId(tId)
		Set tEndSeg=$S(""=tId||((tId=tNewId)&&+tNewSeg):tNewSeg-1, 1:tParent.SegCount) ; same level, different DocsRef segments
		For s=tSeg+1:1:tEndSeg {
			Set tSC=..outputSegment($$$Files(pKey),tParent.GetSegmentAt(s),$$$Files(pKey,"seps"),tCount)  Quit:$$$ISERR(tSC)
		}
		Kill:""'=tChild $$$Count(pKey,tChild) ; kill count now that we've written the terminal segment(s)
	}
	#; If needed, output framing prefix or suffix
	Set:'tNumOld||'tNum tTopParent=##class(EnsLib.EDI.X12.Document).%OpenId(pKey)
	If 'tNumOld { Set tSC=..outputDocument($$$Files(pKey),tTopParent,$$$Files(pKey,"seps"),-2)  Quit:$$$ISERR(tSC) tSC }
	If 'tNum { Set tSC=..outputDocument($$$Files(pKey),tTopParent,$$$Files(pKey,"seps"),2)  Quit:$$$ISERR(tSC) tSC }

	#; Output header(s) for new group
	Set tParentRef=$S(i<2:"",1:$LG(pParents,tNum+2-i))
	For j=tNum+1-i:-1:1 { Set tGrampa=tParentRef, tParentRef=$LI(pParents,j)
		#; record the count of intermediate parents too
		Set:""'=tGrampa $$$Count(pKey,tGrampa)=$G($$$Count(pKey,tGrampa))+1 ; increment count for this parent level at grandparent node
		Set tId=$P(tParentRef,":"), tSeg=$P(tParentRef,":",2)
		Continue:tId=tOldId ; we already did these in the trailers loop
		Set tParent=##class(EnsLib.EDI.X12.Document).%OpenId(tId)
		Set:'tSeg tSeg=tParent.SegCount
		For s=1:1:tSeg-1 {
			Set tSC=..outputSegment($$$Files(pKey),tParent.GetSegmentAt(s),$$$Files(pKey,"seps"),"")  Quit:$$$ISERR(tSC)
		}
	}
	Quit tSC
}

Method OnKeepalive(pAdapterStatus As %Status) As %Status
{
	#def1arg OpenFiles(%k) $$$EnsStaticAppData(..%ConfigName,"OpenFiles",%k)
	
	Try {
		Quit:'..AutoBatchCompletionTimeout ; Not using time to determine when to add trailers
		#; If the oldest incomplete file was modified less than AutoBatchCompletionTimeout seconds ago, we don't need to cycle through all the files 
		Quit:($zdatetime($ztimestamp,-2)-$G($$$OpenFiles("OldestUnmodified")) < ..AutoBatchCompletionTimeout)
		Do ..completeUnfinishedBatches()
	} Catch {
		Set pAdapterStatus = $$$EnsSystemError
	}
	Quit ##super(pAdapterStatus)
}

/// Add trailers to files that have been unchanged for AutoBatchCompleteionTimeout seconds
Method completeUnfinishedBatches()
{
	#def1arg Files(%k) $$$EnsStaticAppData(..%ConfigName,"Files",%k)
	#def1arg Count(%k) $$$EnsStaticAppData(..%ConfigName,"Count",%k)
	#def1arg Parents(%k) $$$EnsStaticAppData(..%ConfigName,"Parents",%k)
	#def1arg OpenFiles(%k) $$$EnsStaticAppData(..%ConfigName,"OpenFiles",%k)

	Set $$$OpenFiles("OldestUnmodified") = 0
	Set tFilename = ""
	For {
		Set tFilename = $O($$$OpenFiles(tFilename)) Quit:tFilename=""
		Continue:tFilename="OldestUnmodified"
		If '..fileExists(tFilename,.tSC)&&$$$ISOK(tSC) {
			$$$LOGWARNING($$$FormatText($$$Text("AutoBatchCompletionTimeout reached, but file '%1' no longer exists.  Continuing without modifying the file.","Ensemble"),tFilename))
			Set tOldParentIds = $$$OpenFiles(tFilename)
			Set tOldKey=$P($LI(tOldParentIds,-1),":")
			Kill $$$Files(tOldKey),$$$Parents(tOldKey),$$$Count(tOldKey),$$$OpenFiles(tFilename)
		} ElseIf $$$ISOK(tSC)&&$D($$$OpenFiles(tFilename,"LastModified"))&&(($zdatetime($ztimestamp,-2) - $$$OpenFiles(tFilename,"LastModified")) >= ..AutoBatchCompletionTimeout) {
			Set tParentIds = $$$OpenFiles(tFilename)
			Set tKey=$P($LI(tParentIds,-1),":")
			Set tSC=..outputHeaders(tKey,tParentIds,"")
			Kill $$$Files(tKey),$$$Parents(tKey),$$$Count(tKey),$$$OpenFiles(tFilename)
		} Else {
			Set:$D($$$OpenFiles(tFilename,"LastModified"))&&('$$$OpenFiles("OldestUnmodified")||($$$OpenFiles("OldestUnmodified") > $$$OpenFiles(tFilename,"LastModified"))) $$$OpenFiles("OldestUnmodified") = $$$OpenFiles(tFilename,"LastModified")
			If $$$ISERR(tSC) $$$LOGWARNING($$$FormatText($$$Text("Encountered error '%1' while searching for file '%2'.  Delaying completion of the batch.","Ensemble"),$system.Status.GetErrorText(tSC),tFilename)) 
		}
	}
	#; Make sure to check again once AutoBatchCompletionTimeout has passed since the oldest remaining open file was last modified. 
	Set ..Adapter.KeepaliveInterval = $Select($$$OpenFiles("OldestUnmodified"):..AutoBatchCompletionTimeout - ($zdatetime($ztimestamp,-2) - $$$OpenFiles("OldestUnmodified")),1:..AutoBatchCompletionTimeout)
	Set:(..Adapter.KeepaliveInterval<=0)&&(..AutoBatchCompletionTimeout>0) ..Adapter.KeepaliveInterval = 1 ;make sure we don't wait for next file to come through before completing overdue batches
	
	Kill:'$$$OpenFiles("OldestUnmodified") $$$OpenFiles("OldestUnmodified") ;clean up ^Ens.AppData a little bit
}

/// Implemented by subclasses
Method fileExists(pFilename As %String, pStatus As %Status = {$$$OK}) As %Boolean
{
	Quit 1
}

}

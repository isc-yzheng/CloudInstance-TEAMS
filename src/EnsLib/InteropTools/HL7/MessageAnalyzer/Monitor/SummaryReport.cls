/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Logging

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor.SummaryReport Extends %RegisteredObject
{

ClassMethod SessionReport(pSessionId As %Integer, pLogger As Logger)
{
	Set tRunId="" While 1 {
		Set tRunId=$Order($$$MXRUNREF(pSessionId,tRunId)) If tRunId="" {Quit}
		Do ..RunReport(pSessionId,tRunId,pLogger)
	}
}

ClassMethod RunReport(pSessionId As %Integer, pRunId As %Integer, pLogger As Logger)
{
	$$$LOGOUTPUT1(pLogger,"Session #"_pSessionId_" run #"_pRunId)
	Set tScanId="" While 1 {
		Set tScanId=$Order($$$MXSCANREF(pSessionId,pRunId,tScanId)) If tScanId="" {Quit}
		$$$LOGOUTPUT1(pLogger,"")
		$$$LOGOUTPUT1(pLogger,"Scan #"_tScanId)
		
		// tLoadMessages=COUNT
		// tLoadMessages(ORIGIN)=COUNT
		// tLoadMessages(ORIGIN,MESSAGETYPE)=COUNT
		Kill tLoadMessages
		
		// tNoMessageType=COUNT
		Kill tNoMessageType
		
		// tMatch=COUNT
		// tMatch(SCHEMANAME)=COUNT
		Kill tMatch
		
		// tMismatch=COUNT
		// tMismatch(SCHEMANAME)=COUNT
		Kill tMismatch
		
		Set tEventId="" While 1 {
			
			Set tEventId=$Order($$$MXSCANEVENTREF(pSessionId,pRunId,tScanId,tEventId),+1,tEventType) If tEventId="" {Quit}
			
			If tEventType="LoadMessage" {
				
				Set tOrigin=$Get($$$MXSCANEVENTSUBREF(pSessionId,pRunId,tScanId,tEventId,"MessageOrigin"))
				If tOrigin'="" {
					Set tOrigin=##class(%File).GetDirectory(tOrigin,0)
				}
				If tOrigin="" {
					Set tOrigin="Unknown origin"
				}
				
				Set tMessageType=$Get($$$MXSCANEVENTSUBREF(pSessionId,pRunId,tScanId,tEventId,"MessageType"))
				If tMessageType="" {
					Set tMessageType="Unknown message type"
				}
				
				If $I(tLoadMessages)
				If $I(tLoadMessages(tOrigin))
				If $I(tLoadMessages(tOrigin,tMessageType))				
			}
			
			ElseIf tEventType="NoMessageType" {
			
				If $I(tNoMessageType)
			}
			
			ElseIf tEventType="Match" {
			
				Set tSchemaName=$Get($$$MXSCANEVENTSUBREF(pSessionId,pRunId,tScanId,tEventId,"SchemaNames"))
				If tSchemaName="" {
					Set tSchemaName="Unknown schema name"
				}
				
				If $I(tMatch)
				If $I(tMatch(tSchemaName))
			}
			
			ElseIf tEventType="Mismatch" {
			
				Set tSchemaName=$Get($$$MXSCANEVENTSUBREF(pSessionId,pRunId,tScanId,tEventId,"SchemaName"))
				If tSchemaName="" {
					Set tSchemaName="Unknown schema name"
				}
				
				If $I(tMismatch)
				If $I(tMismatch(tSchemaName))
			}
		}
		
		$$$LOGOUTPUT1(pLogger,"")
		$$$LOGOUTPUT1(pLogger,"Loaded "_$Get(tLoadMessages,0)_" messages")
		If $Get(tLoadMessages) {
			$$$LOGOUTPUT1(pLogger,"")
			$$$LOGOUTPUT1(pLogger,"By message origin and message type:")
			$$$LOGOUTPUT1(pLogger,"")
			Set tOrigin="" While 1 {
				Set tOrigin=$Order(tLoadMessages(tOrigin),+1,tCount) If tOrigin="" {Quit}
				$$$LOGOUTPUT1(pLogger," "_tOrigin_" - "_tCount)
				Set tMessageType="" While 1 {
					Set tMessageType=$Order(tLoadMessages(tOrigin,tMessageType),+1,tCount) If tMessageType="" {Quit}
					$$$LOGOUTPUT1(pLogger,"  "_tMessageType_" - "_tCount)
				}
			}
		}
		
		If $Get(tNoMessageType) {
			$$$LOGOUTPUT1(pLogger,"")
			$$$LOGOUTPUT1(pLogger,"Skipped "_tNoMessageType_" messages with no message type")
		}
		
		$$$LOGOUTPUT1(pLogger,"")
		$$$LOGOUTPUT1(pLogger,"Matched "_$Get(tMatch,0)_" messages")
		If $Get(tMatch) {
			$$$LOGOUTPUT1(pLogger,"")
			$$$LOGOUTPUT1(pLogger,"By schema:")
			$$$LOGOUTPUT1(pLogger,"")
			Set tSchemaName="" While 1 {
				Set tSchemaName=$Order(tMatch(tSchemaName),+1,tCount) If tSchemaName="" {Quit}
				$$$LOGOUTPUT1(pLogger," "_tSchemaName_" - "_tCount)
			}
		}
		
		$$$LOGOUTPUT1(pLogger,"")
		$$$LOGOUTPUT1(pLogger,"Mismatched "_$Get(tMismatch,0)_" messages")
		If $Get(tMismatch) {
			$$$LOGOUTPUT1(pLogger,"")
			$$$LOGOUTPUT1(pLogger,"By schema:")
			$$$LOGOUTPUT1(pLogger,"")
			Set tSchemaName="" While 1 {
				Set tSchemaName=$Order(tMismatch(tSchemaName),+1,tCount) If tSchemaName="" {Quit}
				$$$LOGOUTPUT1(pLogger," "_tSchemaName_" - "_tCount)
			}
		}
	}
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.Common

/// Common SSC parsing code for DataGate and eGate
Class EnsLib.InteropTools.HL7.GateSSC.Parser [ Abstract ]
{

Property LoopVarRefs As %String(MAXLEN = "") [ MultiDimensional ];

/// pDirectoryFile - a directory name or filename to process
ClassMethod TableImport(pDirectoryFile = "", pTableGroupName = "", pExtension As %String = "txt")
{
	Set tFilename = ##class(%File).GetFilename(pDirectoryFile)
	If tFilename="" {
		Do ..Files(pDirectoryFile,"*."_pExtension,"TableImportFile",,pTableGroupName)
		Set tSC = $$$OK
	} Else {
		Set tSC = ..TableImportFile(pDirectoryFile,pTableGroupName)
	}
	Quit tSC
}

ClassMethod TableImportFile(pFilename = "", pTableGroupName = "") As %Status
{
	#define readLine(%file,%sc,%value,%stripWhere,%stripValue) Set %value = %file.ReadLine(30000000,.%sc) If %stripWhere]"" { Set %value=$zstrip(%value,%stripWhere,%stripValue) }
	try {
		Set tSC = $$$OK
		Set tTableName = pTableGroupName_$E(##class(%File).GetFilename(pFilename),1,*-4)
		Set tFile = ##class(%Stream.FileCharacter).%New()
		Set tSC = tFile.LinkToFile(pFilename) Quit:'tSC
		If 'tFile.Size {
			Write !,"File "_pFilename_" is empty"
			Quit
		}
		Write !,"Processing file: "_pFilename," with table name ",tTableName
		For  {
			Quit:tFile.AtEnd
			$$$readLine(tFile,tSC,tLine,"","")
			Quit:'tSC
			Continue:tLine=""
			Set tX = $Replace(tLine,"\,",$c(0))
			Set tFrom = $Replace($piece(tX,","),$C(0),",")
			Set tTo = $Replace($piece(tX,",",2),$C(0),",")
			If $E(tX,*)=$C(0) {
				/// ends in \ likely a new line - unhandled
				Write !,"Unhandled line ",tLine
				Continue
			} 
			If tFrom = "%default%"||(tFrom="") {
				Set $$$TableDefaults(tTableName)=tTo
			} Else {
				Set tSC = ##class(Ens.Util.LookupTable).%UpdateValue(tTableName, tFrom, tTo,$G(tCreate,1)) 
			}
		}		
		///
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Once the code is converted get message structure from DataGate and make it ours ie "MSH.MSH-10-message_control_ID" = "MSH.MessageControlID"
Method DereferenceVariables() As %Status
{
	try {
		Set tSC = $$$OK
		/// for the input / output ssc files get the structure
		Set tMissingStructure=0
		For var = "Input","Output" {
			Set tStructureFile = $G(..Code(var_"StructureFile"))
			Set tNode = $G(..Code("Structure",$zcvt(var,"l"),"Name")) 
			IF tStructureFile]"" {
				Do ..TreeWalk(tStructureFile,tStructureFile)
			}
		}

		Set tName("Source")=$G(..Code("Structure","input","Name"),$G(..Code("InputStructureFile")))
		Set tName("Target")=$G(..Code("Structure","output","Name"),$G(..Code("OutputStructureFile")))
		/// build a reverse map of segments to structure
		For tType = "Source","Target" {
			Set tVersion = ..Code(tType_"Version")
			Set tDocType = ..Code(tType_"DocType")
			If tDocType="" || (tVersion="") Continue
			If $D($$$GateInverseScheme(tVersion,tDocType)) Continue
			Set tNode ="" 
			For  {
				Set tNode = $O(^EnsHL7.Schema(tVersion,"MS",tDocType,"map",tNode)) Quit:tNode=""
				Set tSeg = $zstrip($p(tNode,".",$l(tNode,".")),">","()")
				Set tName = tName(tType)
				Set $$$GateInverseScheme(tVersion,tDocType,tSeg,tNode)=$i($$$GateInverseScheme(tVersion,tDocType,tSeg))
			}
		}
		/// for each of the variables found try to determine what the vdoc is for IRIS
		Set tVar = "",tLastValid=0,tRound=0
		For {
			Set tValid=0,tTotal=0,tRound=tRound+1
			For  {
				Set tVar = $O(..VariableReplacement(tVar),1,tUpdatedRef) Quit:tVar=""
				Set tTotal=tTotal+1
				/// not done the replacement
				If tUpdatedRef="" {
					Set tRef = $p($p($p(tVar,"[|||",2),"|||]"),".",2,*)  //source.{[|||ss_Cerner_HNAM_RDE.PID.PID-2-patient_ID_external.CX.ID_number|||]} ==> PID.PID-2-patient_ID_external.CX.ID_number
					Continue:tRef=""
					Set tParsedRef = tRef
					If $E(tVar,1,6)="source" {
						Set ..Code("Version")=..Code("SourceVersion")
						Set ..Code("DocType")=..Code("SourceDocType")
						Set tNode = $G(..Code("Structure","input","Name"),$G(..Code("InputStructureFile")))
						Set ..Code("Structure")=$P($zstrip($g(..Code("InputStructure")),"<>",$C(34)),".")_"."
					} Else {
						Set ..Code("Version")=..Code("TargetVersion")
						Set ..Code("DocType")=..Code("TargetDocType")
						Set tNode = $G(..Code("Structure","output","Name"),$G(..Code("OutputStructureFile")))
						Set ..Code("Structure")=$P($zstrip($g(..Code("OutputStructure")),"<>",$C(34)),".")_"."
					}
					Kill tAry
					For  {
						Quit:'$F(tRef,"[")
						Set tAry = $p($p(tRef,"[",2),"]")
						Set tPosition = $l($p(tRef,"["),".")
						Set tAry = $zstrip(tAry,"<>","<>")
						Set tAry(tPosition)="("_tAry_")"
						Set tRef=$P(tRef,"[")_$p(tRef,"]",2,*)
					}
					Do ..DereferenceStructure(tNode,tRef,.tUpdatedRef,.tAry,tRound,tParsedRef)
					If tUpdatedRef]"" { 
						Set tLastChar = $E(tUpdatedRef,*) /// don't want to substitute () from foreach so strip last char and put it back on
						Set tUpdatedUpdatedRef = $replace($E(tUpdatedRef,1,*-1),"()","(1)")_tLastChar  
						If tUpdatedUpdatedRef'=tUpdatedRef {
							Do ..NoteVariable(tUpdatedUpdatedRef,"Updated () to (1) for reference "_tVar_" was "_tUpdatedRef_" and changed to "_tUpdatedUpdatedRef,0)
						}
						Set ..VariableReplacement(tVar)=tUpdatedUpdatedRef
					}

					//Set ..VariableReplacement(tVar)=tUpdatedRef
				}
				Set:tUpdatedRef]"" tValid=tValid+1
			}
			Quit:tLastValid=tValid
			Set tLastValid=tValid
		}
		Do ..ReportItem("Variable Substitutions "_tValid_" of "_tTotal)
		Set tCode = ..Code("Code")
		For tIdx = 1:1:tCode.Items.Count() {
			Set tItem = tCode.Items.GetAt(tIdx)
			Set tMethod = "ReplaceVars"_tItem.%ClassName(0)
			try {
				Do $method($this,tMethod,tItem)
			} catch ex {break}
		}
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..ReportItem("Error "_$system.Status.GetErrorText(tSC))
		break:..Debug  /// error
	}
	Quit tSC
}

/// Convert structure from CBORD_ORM.patient.PID.PID-18-account_number.CK.patient_ID ==> PIDgrp.PID:PatientAccountNumber.IDNumber
Method DereferenceStructure(pNode, pReference, Output pUpdatedRef = "", ByRef pAry, pRound = 0, pFullReference = "")
{
	New %top
	If pReference="" {
		break:..Debug  
		Do ..ReportItem("Reference is empty")
		Set pUpdatedRef=""
		Quit
	}
	Set tStructureRef = $G($$$GateStructure(pNode,"Segs",pReference))
	If tStructureRef="" {
		Do ..ReportItem("Converted reference is empty for "_pNode_"."_pFullReference)
		break:..Debug
		Set pUpdatedRef=""
		Quit  /// don't do a conversion on it
	}
	Set tVersion = $this.Code("Version")
	Set tDocType = $this.Code("DocType")
	Set %top = tStructureRef
	/*
			Could be 	1. orders.rx.OBX
							Build potential choices orders.rx		cb("orders","ORCGrp()"),cb("orders")+1,cb("orders.rx")=+1,cb("orders.rx","ORCGRP()",
							Just return the new reference if we know it
						2. MSH.ControlID-10
						3. orders.order_detail.NTE.NTE-1-set_ID
							cb("orders.order_detail",
						PID.PID-11-patient_address.XAD.state_or_province
						order[<i>].OBR.OBR-32-Principal_Result_Interpreter.interp_name.CN.ID_num						
						
						key is that orders, "ORCGrp()" must be in all sub nodes (orders.rx) or orders.order_detail "could be" entries or it's not valid
	*/
	Set tLen = 0,tAry="",pUpdatedRef="",tReferenceLength = $l(pReference,".")
	For {
		Set tCouldBe=""
		If ..IsSegment(%top,tVersion,.tFoundVersion,tDocType,.tCouldBe) {
			Set tType = $G(@%top@(0,"name"))
			Do ..GetNamesForPositions(pNode,tType,tFoundVersion)
			If pFullReference[$G(%DataGateWatch,$c(0)) {
				Write pNode,".",pFullReference,! zw tCouldBe  break  /// likely want to skip when pRound=1
			}
			If tCouldBe>1 {
				Do ..CleanupPotentials(pNode,pReference,.tCouldBe,tLen,pRound)
			}
			If tCouldBe = 1 {
				Set pUpdatedRef = $O(tCouldBe(""))
				Do ..ProcessSegment(pNode,tType,tVersion,tStructureRef,pReference,.pUpdatedRef,.pAry,pFullReference,tLen)
			} ElseIf tCouldBe>1 {
				Set tNode="",tString=""
				For {
					Set tNode=$O(tCouldBe(tNode)) Quit:tNode=""  Set tString=tString_$c(13,10)_tNode
				}				
				Do ..NoteVariable($g(..Code("Structure"))_pFullReference,"Could not determine which reference for "_$g(..Code("Structure"))_pFullReference_" could be "_tString,0)
			}
			Quit
		} Else {
			Set tLen = tLen + 1
			Set %top = $p(tStructureRef,",",1,$l(tStructureRef,",")-tLen)_")"
			If %top=")" { /// haven't found the segment
				Set pUpdatedRef = ""
				Quit
			}
		}
	}
	Quit 1
}

Method ProcessSegment(pNode, pType, pVersion, pStructureRef, pReference, ByRef pUpdatedRef, ByRef pAry, pFullReference, pLen)
{
	/// We have the segment
	Set tPieces = $l(pReference,".") - pLen
	Set tLenDiff = $L(pUpdatedRef,".") - tPieces
	/// possible tRef="" pRefrence=PID.PID-1-set_ID pUpdatedRef = "PIDGrp.PID" so longer than original PID
	If 'tLenDiff {
		For tIdx=1:1:$l(pUpdatedRef,".") {
			Set tRef = $p(pReference,".",1,tIdx)
			Set ..SelectedTranslation(pNode,tRef)=$p(pUpdatedRef,".",1,tIdx)
		}
	}
	/// Are there [<>] references in the segment
	Set tSegmentRef = $p(pFullReference,".",1,tPieces)
	If $L(tSegmentRef,"[")'=$l(pUpdatedRef,"()") {
		Set ..NoteVariable(pUpdatedRef)="Review unbalanced paren substitution for original text "_tSegmentRef_" and new text "_pUpdatedRef  //break
	}
	If $F(tSegmentRef,"[") && (	($L(tSegmentRef,"[")=$l(pUpdatedRef,"()"))) {
		Set tPos=0
		For {
			Set tPos = $F(tSegmentRef,"[",tPos)
			Quit:'tPos
			Set tEndPos = $F(tSegmentRef,"]",tPos)-2
			Set tAryVal = $tr($E(tSegmentRef,tPos,tEndPos),"<>")
			If tAryVal?1N.N Set tAryVal = tAryVal+1
			Set tSegAry($i(tSegAry))=tAryVal
		}
		For tIdx=1:1 {
			Set tPos = $F(pUpdatedRef,"()",tPos)
			Quit:'tPos
			Set pUpdatedRef=$E(pUpdatedRef,1,tPos-2)_$G(tSegAry(tIdx))_$E(pUpdatedRef,tPos-1,*)
		}
	}
	If pUpdatedRef["()" {
		Set tStart = 1
		For {
			Set tPos = $F($zstrip(pUpdatedRef,">","()"),"()") Quit:'tPos
			Set tLoopRef = $E(pUpdatedRef,1,tPos-3)
			Set tLoopVar = $G(..Code("LoopVar",tLoopRef))
			If tLoopVar="" {
				Set tLoopVar = "LoopVar"_$I(..Code("LoopVar"))
				Do ..FixNote($c(9)_"// ** to fix ** "_tLoopVar_" needs to be defined" )
			}
			Set ..Code("LoopVar",tLoopRef) = tLoopVar
			Set $E(pUpdatedRef,1,tPos-1) = tLoopRef_"("_tLoopVar_")"
			Set tStart = tPos-1
		}
		Set ..LoopVarRefs(pUpdatedRef)=""
	}
	For tIdx = 1:1:pLen {
		Set %top = $p(pStructureRef,",",1,$l(pStructureRef,",")-(pLen-tIdx)) Set:$E(%top,*)'=")" %top=%top_")"
		If tIdx = 1 {
			If $G(@%top@(0,"name"))="segment_ID" {
				If pLen'=1 {
					Do ..ReportItem("Expected to end with just segment_ID "_pReference)
					Set pUpdatedRef=""  /// don't know what we are missing 
					Quit
				}
				Set pUpdatedRef=pUpdatedRef_".GetValueAt(0)"
			} Else {
				Set tOffSet = $S(pType="MSH":0,1:1)
				Set tPosition = $zstrip($P(pStructureRef,",",$l(pStructureRef,",")-(pLen-tIdx)),">",")")-tOffSet
				Set tName = $G($$$GateStructure(pNode,"Positions",pType,tPosition))
				If tName="" {
					break:..Debug
					Set pUpdatedRef=""
					Quit
				}
				Set tAry=$G(pAry(tIdx+tPieces))
				/// positional array values need to +1 - DataGate is zero based
				
				If ($zstrip(tAry,"<>","()"))?1N.N {
					Set tAry = "("_($zstrip(tAry,"<>","()")+1)_")"
				}
				Set pUpdatedRef=pUpdatedRef_$S(tIdx=1:":",1:".")_tName_tAry 

				Set tFoundVersion = pVersion
				If '$D(^EnsHL7.Schema(pVersion,"SS",pType)) {
					Set tFoundVersion = $G(^EnsHL7.Schema(pVersion,"base"))
					If '$D(^EnsHL7.Schema(tFoundVersion,"SS",pType)) { break:..Debug
						Set pUpdatedRef=""
						Quit
					}
				}
				Set tTypeInfo = $li(^EnsHL7.Schema(tFoundVersion,"SS",pType),tPosition) 
				Continue
			}
		} Else {
			If $G(@%top@(0,"p2"))="OS" {
				Continue
			}
			Set tDataType = $p($li(tTypeInfo),":",2)
			If tDataType="" { 
				break:..Debug
				Do ..ReportItem("DataType is empty for "_tFoundVersion_" "_pType_" position:"_tPosition_"  "_pReference)
				Set pUpdatedRef=""
				Quit
			}
			Set tDTVersion=$p($li(tTypeInfo),":")
			If $LL(^EnsHL7.Schema(tDTVersion,"DT",tDataType))=1 {
				Do ..ReportItem("DataType is unknown for "_tDTVersion_" "_tDataType_" but expecting postion:"_tPosition_" from "_pReference)
				break:..Debug
				Set pUpdatedRef=""
				Quit
			} Else {
				If '$D($$$GateStructure(pNode,"DT",tDataType)) {
					Set tNames=""
					For  {
						Set tNames=$O(^EnsHL7.Schema(tDTVersion,"DT",tDataType,"names",tNames),1,tSubPos) Quit:tNames=""
						Set $$$GateStructure(pNode,"DT",tDataType,tSubPos)=tNames
					}
				}
			}
			Set tPosition = $zstrip($P(pStructureRef,",",$l(pStructureRef,",")-(pLen-tIdx)),">",")")
			If tPosition="" {  break:..Debug
				Set pUpdatedRef=""
				Quit
			}
			If '$D($$$GateStructure(pNode,"DT",tDataType,tPosition)) {
				Do ..ReportItem("DataType not found for "_tFoundVersion_" "_pType_" position:"_tPosition_"  "_pReference)
				Set pUpdatedRef=""
				Quit
			}
			Set tName = $$$GateStructure(pNode,"DT",tDataType,tPosition)
			Set tAry=$G(pAry(tIdx+tPieces))
			break:tName["PIDgrpgrp"
			If $L(tAry)=3 && ($tr($e(tAry,2),"0123456789","")="") {
				Set tAry = "("_($E(tAry,2)+1)_")"
			}
			Set pUpdatedRef=pUpdatedRef_"."_tName_tAry 
			Set tTypeInfo=$li(^EnsHL7.Schema(tDTVersion,"DT",tDataType),tPosition)
		}

	}
}

Method CleanupPotentials(pNode, pReference, ByRef pCouldBe, pLen, pRound)
{
	// pLen is number of items stripped off before we found a segment
		/// do cleanup on tCouldBe to see if we can get it down to 1
		/*
			pReference = orders.RXR

			pCouldBe("ORCgrp().RXOgrp.RXR()")=1
			pCouldBe("ORCgrp().RXR()")=2
			
			SelectedTranslation("ss_Cerner_HNAM_RDE","MSH") = "MSH"
			SelectedTranslation("ss_Cerner_HNAM_RDE","orders") = "ORCgrp()"
			SelectedTranslation("ss_Cerner_HNAM_RDE","orders.ORC") = "ORCgrp().ORC"
			SelectedTranslation("ss_Cerner_HNAM_RDE","orders.RXC") = "ORCgrp().RXC()"
			SelectedTranslation("ss_Cerner_HNAM_RDE","orders.RXE") = "ORCgrp().RXE"
		
		*/
		Set tPieces = $l(pReference,".")-pLen
		/// if piece of pCouldBe is in SelectedTranslation get the most specific references and put in tNewCouldBe
		If $D(..SelectedTranslation) {
			Set tNode = ""
			For  {
				Set tNode=$o(pCouldBe(tNode)) Quit:tNode=""
				If $l(tNode,".")'=tPieces && (pRound=1) Continue
				For tIdxSegment = 1:1:tPieces {
					//break:(tPieces'=$l(pReference,".")&&(pReference'["NTE"))
					Set tSegment = $p(pReference,".",1,(tPieces-(tIdxSegment-1)))  /// orders
					Set tNodeRef = $P(tNode,".",1,(tPieces-(tIdxSegment-1)))  /// ORCGrp()
					Break:tSegment=""
					If $D(tNewCouldBe(tNodeRef)) Continue
					If $D(..SelectedTranslation(pNode,tSegment),tData) {
						If tData=tNodeRef {
							Set tNewCouldBe(tNode)=$i(tNewCouldBe)
							//Set tNewCouldBe($p(tNode,".",1,tPieces))=$i(tNewCouldBe)
							Quit  /// have most specific don't look further
						}
					}
				}
			}
		}

		If $G(tNewCouldBe) = 1 {
			Kill pCouldBe 
			Merge pCouldBe = tNewCouldBe
			Kill tNewCouldBe
		}

		If (pCouldBe>1) && (pRound>1) && $D(%hint) {
			/// Allow customer to define hints
			Set tVersionDocType = ..Code("Version")_":"_..Code("DocType")
			If $D(%hint("DocType",tVersionDocType)) {
				Set tNode = ""
				For  {
					Set tNode=$o(pCouldBe(tNode)) Quit:tNode=""
					Set tSeg = $p($p(tNode,".",$l(tNode,".")),"(")
					If tSeg]"" && ($D(%hint("DocType",tVersionDocType,tSeg),tKeep)) {
						If tKeep]"" && ($D(pCouldBe(tKeep))) {
							Kill pCouldBe
							Set pCouldBe=1
							Set pCouldBe(tKeep)=1
						}
					}
				}
			}
		}

		
			//	break:(pRound>1&&(pReference["NTE"))
		
		If $D(..SelectedTranslation) && $D(tNewCouldBe) {
			/// tNewCouldBe only defined if there is at least one node in the ..SelectedTranslation
			/// loop through and remove any nodes which don't have 
			/// pCouldBe(
			//
			Set tNode=""
			For {
				Set tNode=$O(pCouldBe(tNode)) Quit:tNode=""
				If '$D(tNewCouldBe(tNode)) {
					kill pCouldBe(tNode) Set pCouldBe=pCouldBe-1
				}
				/*
				For tIdx=1:1:$l(tNode,".") {
					Set tPiece = $p(tNode,".",1,tIdx)
					Set tData = $O(tNewCouldBe(tPiece))
					If (tData'[tPiece) || (tData[tPiece && ($p(tNode,".",1,$l(tData,"."))'=tData)) {
					}
				}
				*/
			}
		}
		If pRound>1 && (pCouldBe>1) {
			Set tNode=""
			For {
				Set tNode=$O(pCouldBe(tNode)) Quit:tNode=""
				If $l(tNode,".")'=tPieces Kill pCouldBe(tNode) Set pCouldBe=pCouldBe-1
			}
		}
}

Method IsSegment(%top, pVersion, Output pBase, pDocType = "", ByRef pCouldBe)
{
	Kill pCouldBe
	Set pBase=pVersion
	Set tSeg=$g(@%top@(0,"name"))
	Quit:$L(tSeg)'=3 0
	If '$D(^EnsHL7.Schema(pVersion,"SS",tSeg)) {
		Set tBase = $G(^EnsHL7.Schema(pVersion,"base")," ")
		If '$D(^EnsHL7.Schema(tBase,"SS",tSeg)) Quit 0
		Set pBase=tBase
	}
	If pDocType]"" {
		If $D($$$GateInverseScheme(pVersion,pDocType,tSeg),tCount) {  //break
			/// add to pCouldBe
			Merge pCouldBe = $$$GateInverseScheme(pVersion,pDocType,tSeg)
			Quit 1
		}
	}
	Quit 0
}

Method DereferenceSubStructure(pNode, pReference, Output pUpdatedRef = "", ByRef pAry, pPosition = 1, pParentType = "", pVersion, pStructureRef, pDataType)
{
	Set tPosition = $zstrip($p(pStructureRef,",",pPosition+4),">",")")
	If 'tPosition {
		break:$l(pStructureRef,",")>(pPosition+4)
		quit
	}

	Set tName = $$$GateStructure(pNode,"DT",pDataType,tPosition)
	Set pUpdatedRef=pUpdatedRef_"."_tName_$g(pAry(pPosition)) 
	If $length(pStructureRef,",")>(4+pPosition) { 
		Set tFoundVersion = pVersion
		If '$D(^EnsHL7.Schema(tFoundVersion,"DT",pDataType)) {
			Set tFoundVersion = $G(^EnsHL7.Schema(pVersion,"base")," ")
		}
		Set tDataTypeData = ^EnsHL7.Schema(tFoundVersion,"DT",pDataType)
		If $LL(tDataTypeData)=1 { break
		
		} else {
			Set tDataType = $p($li($LI(tDataTypeData,tPosition)),":",2)
			Set tNames=""
			For  {
				Set tNames=$O(^EnsHL7.Schema(tFoundVersion,"DT",tDataType,"names",tNames),1,tSubPos) Quit:tNames=""
				Set $$$GateStructure(pNode,"DT",tDataType,tSubPos)=tNames
			}
			// pPosition is +2 +1 for the datatype and to move to next position
			Do ..DereferenceSubStructure(pNode,pReference,.pUpdatedRef,.pAry,pPosition+2,pParentType,pVersion,pStructureRef,tDataType)
		
		}
	}
}

Method GetNamesForPositions(pNode, pType, pVersion)
{
	//^EnsHL7.Schema("2.7.1","SS","ACC","names","AccidentAddress")=11
	//Set tVer=$G($$$GateStructure(pNode,"Version"),..#DEFAULTVERSION)
	Quit:'$D(^EnsHL7.Schema(pVersion,"SS",pType))
	Quit:$D($$$GateStructure(pNode,"Positions",pType))
	Set tName=""
	For  {
		Set tName=$O(^EnsHL7.Schema(pVersion,"SS",pType,"names",tName),1,tPosition) Quit:tName=""
		Set $$$GateStructure(pNode,"Positions",pType,tPosition)=tName
	}
}

/// Using the ssc message definition build $$$GateStructure
Method BuildSegments(pName)
{
	Set tMsgName=$O($$$GateStructure(pName,"Name","@"))
	
	Set tSeg=0
	For  {
		Set tSeg=$O($$$GateStructure(pName,"Name",tMsgName,0,tSeg)) Quit:tSeg="" 
		Set tStructure=$$$LiteralGateStructure_"("_$C(34)_pName_$C(34)_",""Name"","_$C(34)_tMsgName_$C(34)_",0,"_tSeg_")"
		Do ..BuildSubSegments(tStructure,pName,@tStructure@(0,"name"))
	}
	break:..Debug&&('$D($$$GateStructure(pName,"Segs")))
	Quit $$$OK
}

Method BuildSubSegments(pStructure, pName, pSegName)
{
	Set tSeg=0
	For  {
		Set tSeg=$O(@pStructure@(tSeg)) Quit:tSeg="" 
		Set tStructure = $E(pStructure,1,*-1)_","_tSeg_")"
		Do ..BuildSubSegments(tStructure,pName,pSegName_"."_@tStructure@(0,"name"))
	}
	Set tName = @pStructure@(0,"name") 
	Set $$$GateStructure(pName,"Segs",pSegName)=pStructure
}

Method command(pNode As %XML.Node, Output pNodeStucture, pLevel = 0)
{
	Quit
	Set tName = pNode.LocalName
	For  {
		Do ..nameAndData(pNode,.tName,.tData)
		If tName="command" {
			Set tSaveNodeId = pNode.NodeId
			If 'pNode.MoveToFirstChild(1) Quit
			Do ..command(pNode,.pNodeStucture,pLevel+1)
			Set pNode.NodeId=tSaveNodeId
		} Else {
			Set $$$FormCode($I($$$FormCode))=$lb(tName,tData,pLevel)
			break:tData=$c(34)_"prod"_$c(34)
		}
		If 'pNode.MoveToNextSibling(1) Quit
	}
}

Method TreeWalkChildren(pNode As %XML.Node)
{
	#define Name(%value,%end) if %value]"" { Write "<",$S(%end:"/",1:""),%value,">"}
	#define Write(%value) Write $zcvt(%value,"O","XML")
	If 'pNode.MoveToFirstChild(1) Quit
	Set tSiblingCount=1
	Set tName = pNode.LocalName
	///$$$Name(tName,0)

	For  {
		///$$$Name(tName,1)
		If tName="encoding" {
			Do ..encoding(pNode)
		} elseIf tName="structure" {
			If 'pNode.MoveToFirstChild(1) break  Quit
			Set tNodeStructure="0"
			Do ..structure(pNode,.tNodeStructure,1)
		}
		If 'pNode.MoveToNextSibling(1) Quit
		Set tName = pNode.LocalName
	}
	
	Quit 1
}

/// five nodes for encoding
Method encoding(pNode)
{
	Set tDelimiters="" 
	If 'pNode.MoveToFirstChild(1) break  Quit
	For {
		Quit:'..nameAndData(pNode,.tName,.tData,1)
		Set tPos = $Case(tName,"one":1,"two":2,"three":3,"four":4,"five":5)
		Set $li(tDelimiters,tPos)=$zstrip(tData,"<>",$c(34))
		Quit:'pNode.MoveToNextSibling(1)
	}
	Do pNode.MoveToParent(0)
	Set ..Delimiters=tDelimiters
	Quit
}

Method nameAndData(pNode, Output pName, Output pData, pStrip34 = 0)
{
	Set tFound=0,pName="",pData=""
	If pNode.NodeType=$$$xmlELEMENTNODE {
		Set pName = pNode.LocalName
		If pNode.MoveToFirstChild(1) {
			If pNode.NodeType=$$$xmlTEXTNODE {
				Set pData = pNode.NodeData
				If pStrip34 && ($e(pData)=$c(34)) && ($e(pData,*)=$c(34)) Set pData = $E(pData,2,*-1)
				Set tFound=1
				For  {
					Quit:'pNode.MoveToNextSibling(1)
					Set tData=pNode.NodeData
					Set pData=pData_tData
				}
			}
			Do pNode.MoveToParent(0)
		}
	} ElseIf pNode.NodeType=$$$xmlTEXTNODE {
		break
	} Else {
		BREAK
	}
	Quit tFound
}

Method structure(pNode, pNodeStructure, pFirst = 0)
{
	New %x,%tData
	For  {
		If pNode.LocalName="structure" {
			Set tNodeName = $I(^||EnsLib.InteropTools.DG.StructTemp(pNodeStructure))
			If 'pNode.MoveToFirstChild(1) break  Quit
			For  {
				Do ..structure(pNode,pNodeStructure_"."_tNodeName)
				Quit:'pNode.MoveToNextSibling(1)
			}
			Do pNode.MoveToParent(0)
		} Else {
			Do ..nameAndData(pNode,.tName,.tData,1)
			If pFirst && (tName="name") {
				Set %name=tData
				If tData="" {
					If '$G(..Code("TreeWalk",..Code("TreeWalk")_" ","Reported")) {
						break  Write !,"Improper parsing of (ssc) structure "_..Code("TreeWalk")
						Set ..Code("TreeWalk",..Code("TreeWalk")_" ","Reported")=1
					}
				}
			}

			Set %tData(pNodeStructure,0,tName)=tData
		}
		
		If 'pNode.MoveToNextSibling(1) {
			break:..Debug&&(pNodeStructure="0.1")
			Quit
		}
	}
	Set %x=""
	for  {
		Set %x=$O(%tData(%x)) quit:%x=""
		/// a hack for ) endofrec ) at start of segments
		If $g(%tData(%x,0,"p9"))]"" && ($G(%tData(%x,0,"name"))="") {
			Set %tData(%x,0,"name")=%tData(%x,0,"p2")
			For tIdx=3:1:9 {
				Set %tData(%x,0,"p"_(tIdx-1))=%tData(%x,0,"p"_tIdx)
			}
			Kill %tData(%x,0,"p9")
		}
		Merge @("^||EnsLib.InteropTools.DG.StructTemp("""_%name_""","_$tr(%x,".",",")_")=%tData(%x)")    
	}
}

/// Walk .SSC file to generate internal structure
Method TreeWalk(pFileName, pNode = "", pDebug = 0)
{
	try {
		Set tSC = $$$OK
		Set:pNode="" pNode = $p(##class(%File).GetFilename(pFileName),".")
		
		If $G($$$GateStructure(pNode,"FileName"))'[pFileName {  /// contains because pFilename node ends up with pFileName.xml
			Kill $$$GateStructure(pNode)  // found different structures with the same name (ss_Cerner_HNAM_RDE)  20190111
		}
		If '##class(%File).Exists(pFileName) {
			Do ..ReportItem(pFileName_" is not found")
			break:..Debug
			Quit
		}
		If $$$Param(Reprocess) {
			Kill $$$GateStructure(pNode)
		}
		Quit:$D($$$GateStructure(pNode))
		Set $$$GateStructure(pNode,"FileName")=pFileName
		
		Kill ^||EnsLib.InteropTools.DG.StructTemp
		Set tFileName=pFileName
		If $p(pFileName,".",$L(pFileName,"."))'="xml" {
			Set tFN=pFileName,tFileName=tFN_".xml"
			Do ..ScriptToXML(tFN,tFileName,1,.tExists)
			If 'tExists {
				Do ..ReportItem("Problem parsing "_pFileName)
				Quit
			}
		}
	
		Set tFile=##class(%Stream.FileCharacter).%New()
		Do tFile.LinkToFile(tFileName)  
		Set tSC = ##class(Ens.Util.URLStream).GetURLStream("XData://EnsLib.InteropTools.HL7.GateSSC.Parser:SSC",.tXDataStream)
		If $$$ISERR(tSC) {
			Do ..ReportItem("failed to get transform "_$system.Status.GetErrorText(tSC),0) break:..Debug  Quit
		}
		
		Set tSC = ##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(tXDataStream,.tTransform)
		If $$$ISERR(tSC) {
			Do ..ReportItem("failed to get transformer "_$system.Status.GetErrorText(tSC),0) break:..Debug  Quit
		}
		Do tFile.Rewind()
		Set tSC=##class(%XML.XSLT.Transformer).TransformStreamWithCompiledXSL(tFile,tTransform,.tOut)
		
		If $$$ISERR(tSC) {
			Do ..ReportItem("failed to transform document:"_pFileName_" "_$system.Status.GetErrorText(tSC),0) break:..Debug  Quit
		}
		Do tOut.Rewind() 
		Set ..Code("TreeWalk")=pFileName
		Set tSC = ##class(%XML.Document).GetDocumentFromStream(tOut,.tDocument)
		If $$$ISERR(tSC) {
			Do ..ReportItem("failed to get transformed document:"_pFileName_" "_$system.Status.GetErrorText(tSC),0) break:..Debug  Quit
		}
		#dim tNode as %XML.Node=tDocument.GetDocumentElement()
		If tNode.HasChildNodes(1) {
			Set tSaveNodeId = tNode.NodeId
			Set tName = tNode.LocalName
			Do ..TreeWalkChildren(tNode)
		}
		Set tName = $p(##class(%File).GetFilename(pFileName),".")
		Merge $$$GateStructure(pNode,"Name")=^||EnsLib.InteropTools.DG.StructTemp
		Set $$$GateStructure(pNode,"FileName")=tFileName
		Do ..BuildSegments(pNode)
	} catch ex {
		Set tSC = ex.AsStatus()
		If $$$ISERR(tSC) {
			Do ..ReportItem("failed to transform document:"_pFileName_" "_$system.Status.GetErrorText(tSC),0) break:..Debug  Quit
		}
	}
	Quit tSC
}

Method GetNodeValue(pNode As %XML.Node, ByRef pForms, pLevel = "") As %Status
{
	Set tType=pNode.LocalName
	If 'pNode.MoveToFirstChild(1) break  quit
	Set tData = pNode.NodeData
	For  {
		Quit:'pNode.MoveToNextSibling()
		Set tData=tData_pNode.NodeData
	}
	Set pForms($i(pForms))=$zcvt(tData,"I","XML")
	Set pForms(pForms,0)=tType
	Set pForms(pForms,1)=pLevel
	Quit $$$OK
}

Method CodeWalkNode(pNode As %XML.Node, pLevel = 0, pSet = 1, pCommandLine = "", pDebug = 1, pFileName)
{
	//#define Name(%value,%end) if %value]"" { Write "<",$S(%end:"/",1:""),%value,">"}
	//#define Write(%value) Write $zcvt(%value,"O","XML")
	Set tSaveNodeId = pNode.NodeId
	If pNode.NodeType=$$$xmlELEMENTNODE && (pNode.LocalName="form") {
		Do ..CodeWalkForm(pNode,$I(pLevel),,,pDebug,.tForm)  //break:$G(tForm(tForm-1))="result"   //outer
		Merge $$$FormCode($i($$$FormCode))=tForm
		If $g(tForm(1))="define" {
		} ElseIf $g(tForm(1))="" {
			break
		}
		Kill tForm
		

	} elseIf pNode.NodeData="&lt;EOF" {
	} elseIf pNode.NodeData=">" {
	} else {
		Do ..ReportItem("unexpected node during CodeWalk"_pNode.NodeData)  Break
	}
	Set pNode.NodeId=tSaveNodeId
	Quit 1
}

/*
s tFile=##class(%Stream.FileCharacter).%New()
w tFile.LinkToFile("/WTemp/ascension/WIMIL_TRECode_2017-01-27/prodohw/tables/tableOHW.dgt_dgt/TheraSource_2_MS4.ssc.xml")  
s t=##class(HS.Util.XSLTTransformer).%New() w t.Transform(tFile,"XData://EnsLib.InterfaceGenerator.DataGate:SSC",.tOut) d tOut.Rewind() w !,tOut.Read(3000000000)

*/
XData SSC
{
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/">
<root>
<xsl:apply-templates select="file/form/list/forms/form/literal/symbol/simple_sym"/>
</root>
</xsl:template>

<xsl:template match="file/form/list/forms/form/literal/symbol/simple_sym">

<xsl:if test="text() = 'define'">
	<xsl:variable name="symbol" select="../../../../form[2]/literal/symbol/simple_sym"/>

	<xsl:if test="substring($symbol,string-length($symbol)-4,string-length($symbol)) = '-delm'">
		<xsl:apply-templates select="../../../../form[3]/reader_macro/quote"/>
	</xsl:if>
	<xsl:if test="substring($symbol,string-length($symbol)-6,string-length($symbol)) = '-struct'">
		<xsl:apply-templates select="../../../../form[3]/list/forms/form[2]/list/forms/form[2]" mode='structure'/>
	</xsl:if>
</xsl:if>
 </xsl:template>

<!-- get message encoding -->
<xsl:template match='reader_macro/quote'>
<encoding>
<one><xsl:value-of select="form/list/forms/form[1]/list/forms/form/literal/string/text()"/></one>
<two><xsl:value-of select="form/list/forms/form[2]/list/forms/form/literal/string/text()"/></two>
<three><xsl:value-of select="form/list/forms/form[3]/list/forms/form/literal/string/text()"/></three>
<four><xsl:value-of select="form/list/forms/form[4]/list/forms/form/literal/string/text()"/></four>
<five><xsl:value-of select="form/list/forms/form[5]/list/forms/form/literal/string/text()"/></five>
</encoding>
</xsl:template>

<xsl:template match='form' mode='structure'>
<structure>
<name><xsl:apply-templates select="list/forms/form[1]/literal" mode='structure-node'/></name>
<p2><xsl:apply-templates select="list/forms/form[2]/literal" mode='structure-node'/></p2>
<p3><xsl:apply-templates select="list/forms/form[3]/literal" mode='structure-node'/></p3>
<p4><xsl:apply-templates select="list/forms/form[4]/literal" mode='structure-node'/></p4>
<p5><xsl:apply-templates select="list/forms/form[5]/literal" mode='structure-node'/></p5>
<p6><xsl:apply-templates select="list/forms/form[6]/literal" mode='structure-node'/></p6>
<p7><xsl:apply-templates select="list/forms/form[7]/literal" mode='structure-node'/></p7>
<p8><xsl:apply-templates select="list/forms/form[8]/literal" mode='structure-node'/></p8>
<p9><xsl:apply-templates select="list/forms/form[9]/literal" mode='structure-node'/></p9>


<!--

<p2>at<xsl:apply-templates select="list/forms[2]/form/literal" mode='structure-node'/></p2>
<p2>p2<xsl:call-template name='literal'><xsl:with-param name="element" select="$here/forms[2]/form/literal"/></xsl:call-template></p2>
<name><xsl:call-template name='literal'><xsl:with-param name="element" select="$here/forms[1]/form/literal"/></xsl:call-template></name>
<p3><xsl:call-template name='literal'><xsl:with-param name="element" select="list/forms[3]/form/literal"/></xsl:call-template></p3>
<p4><xsl:call-template name='literal'><xsl:with-param name="element" select="list/forms[4]/form/literal"/></xsl:call-template></p4>
<p5><xsl:call-template name='literal'><xsl:with-param name="element" select="list/forms[5]/form/literal"/></xsl:call-template></p5>
<p6><xsl:call-template name='literal'><xsl:with-param name="element" select="list/forms[6]/form/literal"/></xsl:call-template></p6>
<p7><xsl:call-template name='literal'><xsl:with-param name="element" select="list/forms[7]/form/literal"/></xsl:call-template></p7>
<p8><xsl:call-template name='literal'><xsl:with-param name="element" select="list/forms[8]/form/literal"/></xsl:call-template></p8>
-->

<!--
<name><xsl:value-of select="list/forms/form[1]/literal/symbol/simple_sym/text()"/><xsl:value-of select="list/forms/form[1]/literal/symbol/ns_symbol/text()"/></name>
<p2><xsl:value-of select="list/forms/form[2]/literal/symbol/simple_sym/text()"/></p2>
<p3><xsl:value-of select="list/forms/form[3]/literal/number/text()"/></p3>
<p4><xsl:value-of select="list/forms/form[4]/literal/number/text()"/></p4>
<p5><xsl:value-of select="list/forms/form[5]/literal/string/text()"/><xsl:value-of select="list/forms/form[5]/literal/symbol/simple_sym/text()"/></p5>
<p6><xsl:value-of select="list/forms/form[6]/literal/string/text()"/></p6>
<p7><xsl:value-of select="list/forms/form[7]/literal/symbol/simple_sym/text()"/></p7>
<p8><xsl:value-of select="list/forms/form[8]/literal/number/text()"/></p8>
-->

		<xsl:for-each select="list/forms/form">
			<xsl:if test="position() > 8">
				<xsl:apply-templates select="." mode='structure'/>
			</xsl:if>
		</xsl:for-each>
</structure>
</xsl:template>

<xsl:template name='literal'>
 <xsl:param name="element" />
<xsl:value-of select="$element/symbol/simple_sym/text()"/>
<xsl:value-of select="$element/symbol/ns_symbol/text()"/>
<xsl:value-of select="$element/number/text()"/>
<xsl:value-of select="$element/string/text()"/>
</xsl:template>

<xsl:template name='literal1'>
 <xsl:param name="element" />
<xsl:if test="$element/symbol/simple_sym/text() !=''"><xsl:value-of select="$element/symbol/simple_sym/text()"/></xsl:if>
<xsl:if test="$element/symbol/ns_symbol/text() !=''"><xsl:value-of select="$element/symbol/ns_symbol/text()"/></xsl:if>
<xsl:if test="$element/number/text() !=''"><xsl:value-of select="$element/number/text()"/></xsl:if>
<xsl:if test="$element/string/text() !=''"><xsl:value-of select="$element/string/text()"/></xsl:if>
</xsl:template>

<xsl:template match='*' mode="structure-node">
<xsl:value-of select="symbol/simple_sym/text()"/>
<xsl:value-of select="symbol/ns_symbol/text()"/>
<xsl:value-of select="number/text()"/>
<xsl:value-of select="string/text()"/>
</xsl:template>

<xsl:template match='*' mode="structure-nodes">
In-Structure-Node
<xsl:if test="symbol/simple_sym"><xsl:value-of select="symbol/simple_sym/text()"/></xsl:if>
<xsl:if test="symbol/ns_symbol"><xsl:value-of select="symbol/ns_symbol/text()"/></xsl:if>
<xsl:if test="number"><xsl:value-of select="number/text()"/></xsl:if>
<xsl:if test="string"><xsl:value-of select="string/text()"/></xsl:if>
</xsl:template>

</xsl:stylesheet>
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.DiffCollection Extends EquivalenceClasses
{

Property Machine As Machine [ Private ];

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

/// Cases(DIFFKEY)(1..*)=Diff
Property Cases As BigKeyTable [ Private ];

Property CaseDiffCount As %Integer [ Private ];

Method %OnNew(pMachine As Machine, pConfig As Config, pLogger As Logger) As %Status
{
	Set ..Machine=pMachine
	Set ..Cases=##class(BigKeyTable).%New()
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..CaseDiffCount=0
	
	Quit $$$OK
}

ClassMethod MakeDiffCollection(pMachine As Machine, pConfig As Config, pLogger As Logger)
{
	Quit $Select(
		pConfig.IsFlagSet("OLDDIFFCOLLECTION"):##class(DiffCollection).%New(pMachine,pConfig,pLogger),
		1:##class(NewDiffCollection).%New(pMachine,pConfig,pLogger))
}

/// pDiffRecords(1..*)=Diff
/// <br> Returns the diff key
Method AddCase(ByRef pDiffRecords) As %String
{
	If '$Get(pDiffRecords) {$$$FATAL("DiffCollection:AddCase - no records passed")}
	
	//Write !,"Diff Records",!
	//For i=1:1:pDiffRecords {
	//	Write " ",i,": ",pDiffRecords(i).AsString(1),!
	//}
	//Write !
	
	Set tList=##class(%ListOfObjects).%New()
	For tI=1:1:pDiffRecords {
		Do tList.Insert(pDiffRecords(tI))
		Set ..CaseDiffCount=..CaseDiffCount + pDiffRecords(tI).Length()
	}
	
	Set tDiffKey=..DiffRecordsKey(tList)
	
	Do ..Cases.SetAt(tList,tDiffKey) // TODO track counts for diffkeys
	
	Do ..AddItem(..Cases.KeyToHash(tDiffKey))
	
	Quit tDiffKey
}

Method GetGroupsWrapper(Output pGroups)
{
	$$$SHOULDBEUNDEF(pGroups)
	
	Do ..GetGroups(.pGroups)
	
	If $$$DBFLAG {
		Write "Groups",!
		Set tGroupHash="" While 1 {
			Set tGroupHash=$Order(pGroups(tGroupHash)) If tGroupHash="" {Quit}
			Write " ",tGroupHash,!
			Set tItemHash="" While 1 {
				Set tItemHash=$Order(pGroups(tGroupHash,tItemHash)) If tItemHash="" {Quit}
				Write "  ",..Cases.HashToKey(tItemHash),!
			}
		}
	}
}

Method Count() As %Integer [ CodeMode = expression ]
{
..Cases.Count()
}

Method SizeMetric() As %Integer [ CodeMode = expression ]
{
..CaseDiffCount
}

Method CollectionKey() As %String
{
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=..Cases.Next(tKey) If tKey="" {Quit}
		Set tCase=..Cases.GetAt(tKey)
		Set tOut=tOut_$ListBuild(tCase.Count(),tKey)
	}
	
	Quit $ListToString(tOut)
}

Method CaseRepr(pDiffKey As %String) As %String
{
	Set tCase=..Cases.GetAt(pDiffKey)
	Set tOut=""
	For tI=1:1:tCase.Count() {
		Set tOut=tOut_$ListBuild(tCase.GetAt(tI).AsString())
	}
	
	Quit $ListToString(tOut," || ")
}

Method Equals(pDiffCollection As DiffCollection) As %Boolean
{
	Set tCasesA=..Cases
	Set tCasesB=pDiffCollection.Cases
	
	If tCasesA.Count()'=tCasesB.Count() {Quit 0} // TODO remove? this is O(N) on the number of entries
	
	Set (tKeyA,tKeyB)="" While 1 {
		Set tKeyA=tCasesA.Next(tKeyA)
		Set tKeyB=tCasesB.Next(tKeyB)
		If tKeyA="",tKeyB="" {
			Quit  // finished
		}
		If tKeyA'=tKeyB {
			Return 0 // mismatch
		}
	}
	
	Quit 1
}

Method DebugShow()
{
	If ..Cases.Count()=0 {
		Write "No diff cases",!
	}
	Else {
		Write "Diff cases:",!
		Set tShown=0
		Set tShowAll=..Config.IsFlagSet("LOGALLDIFFCASES")
		Set tDiffKey="" While 1 {
			Set tDiffKey=..Cases.Next(tDiffKey) If tDiffKey="" {Quit}
			If 'tShowAll,tShown=10 {
				Write "... more diff cases omitted here",!
				Quit
			}
			Write " #",tDiffKey,!
			If tShowAll {
				Set tDiff=..Cases.GetAt(tDiffKey)
				For tJ=1:1:tDiff.Count() {
					Write "  ",$ListToString(tDiff.GetAt(tJ).GetOriginalRecord()),!
				}
			}
			Set tShown=tShown+1
		}
	}
}

/// Returns pCSVRecordListTable(1..*,1..*)=RECORD (within GROUP)
/// <br> RECORD=$LB(MESSAGESEGMENTTYPE,..)
Method WithinGroupsAll(ByRef pGroups, Output pCSVRecordListTable)
{
	$$$SHOULDBEUNDEF(pCSVRecordListTable)
	
		
	// PATCHABLE
	//$$$DBON
	
	
	$$$DBOUT("Within-groups analysis (all)")
	
	// for each group ..
	Set tGroupHash="" While 1 {

		Set tGroupHash=$Order(pGroups(tGroupHash)) If tGroupHash="" {Quit}
		$$$DBOUT(" "_tGroupHash)
		
		// if at the start or if the current entry is filled ..
		If '$Get(pCSVRecordListTable) || $Get(pCSVRecordListTable(pCSVRecordListTable)) {
			Set tGroupNo=$I(pCSVRecordListTable) // move to the next entry
		}
		Else {
			Set tGroupNo=pCSVRecordListTable // use the current entry
		}
		
		// for each item in the group ..
		Set tItemHash="" While 1 {
		
			Set tCSVRecord=""
			
			Set tItemHash=$Order(pGroups(tGroupHash,tItemHash)) If tItemHash="" {Quit}

			$$$DBOUT("Original record(s): "_..OriginalRecordsForHash(tItemHash))

			Set tItemKey=..Cases.HashToKey(tItemHash)
			$$$DBOUT("  "_tItemKey)
			
			// for each case record ..
			Set tCase=..Cases.GetAt(tItemKey)
			For tI=1:1:tCase.Count() {
				
				Set tDiff=tCase.GetAt(tI)
				$$$DBOUT("   "_tI_": "_tDiff.Show())
				
				// for each extent in the case record ..
				If $$$DBFLAG {
				
					Kill tExtents
					Do tDiff.GetRegionExtents(.tExtents)
					
					Write "    Extents:",!
					For tJ=1:1:$Get(tExtents) {
						Write "     ",tJ,": ",..ShowExtent(.tExtents,tJ),!
					}
				}
				
				// add to abstract strings
				Set tField=tDiff.CSVRepr()
				
				If tField'="" {
					Set tCSVRecord=tCSVRecord_$ListFromString(tField)
				}
			}
			
			If tCSVRecord'="" {
				Set pCSVRecordListTable(tGroupNo,$I(pCSVRecordListTable(tGroupNo)))=##class(DiffMessageRecord).%New(tCSVRecord,tDiff.SchemaOffsets())
			}
		}
	}
}

/// Returns pCSVRecordListTable(1..*,1..*)=RECORD (within GROUP)
/// <br> RECORD=$LB(MESSAGESEGMENTTYPE,..)
/// <p> pAnyWithoutEarliest(GROUPINDEX)=0/1
Method WithinGroupsLimited(ByRef pGroups, Output pCSVRecordListTable, Output pAnyWithoutEarliest)
{
	$$$SHOULDBEUNDEF(pCSVRecordListTable)
	$$$SHOULDBEUNDEF(pAnyWithoutEarliest)
		
	// PATCHED
	Set tEarliestExtent=..EarliestExtent(.pGroups)
	If tEarliestExtent="" {Quit}
	
	$$$DBOUT("Within-groups analysis (limited)")
	
	// for each group ..
	Set tGroupHash="" While 1 {

		Set tGroupHash=$Order(pGroups(tGroupHash)) If tGroupHash="" {Quit}
		$$$DBOUT(" "_tGroupHash)
		
		// if at the start or if the current entry is filled ..
		If '$Get(pCSVRecordListTable) || $Get(pCSVRecordListTable(pCSVRecordListTable)) {
			Set tGroupNo=$I(pCSVRecordListTable) // move to the next entry
		}
		Else {
			Set tGroupNo=pCSVRecordListTable // use the current entry
		}
		
		Set tAnyWithoutEarliest=0
	
		// for each item in the group ..
		Set tItemHash="" While 1 {
					
			Set tItemHash=$Order(pGroups(tGroupHash,tItemHash)) If tItemHash="" {Quit}

			$$$DBOUT("Original record(s): "_..OriginalRecordsForHash(tItemHash))

			Set tItemKey=..Cases.HashToKey(tItemHash)
			$$$DBOUT("  "_tItemKey)
						
			// for each case record ..
			Set tCase=..Cases.GetAt(tItemKey)
			Set tCSVRecord=""
			Set tSchemaOffsets=""
			For tI=1:1:tCase.Count() {
				
				Set tDiff=tCase.GetAt(tI)
				$$$DBOUT("   "_tI_": "_tDiff.Show())
				
				// the determining extent				
				Set tRet=..GetProgressiveExtent(tDiff)
				If tRet="" {
					Set tAnyWithoutEarliest=1
				}
				Else {
					Set $ListBuild(tExtent,tMessageText)=tRet
					If tExtent=tEarliestExtent {
						If tMessageText="" {ZTrap}
						Set tCSVRecord=tCSVRecord_$ListFromString(tMessageText)
						Set tSchemaOffsets=tSchemaOffsets_$ListBuild(tExtent)
						
						// PATCHED FIX
						If $ListLength(tCSVRecord)>$ListLength(tSchemaOffsets) {
							Set tCSVRecord=$List(tCSVRecord,1,$ListLength(tSchemaOffsets))
						}
						ElseIf $ListLength(tCSVRecord)<$ListLength(tSchemaOffsets) {
							Set tSchemaOffsets=$List(tSchemaOffsets,1,$ListLength(tCSVRecord))
						}
					}
					Else {
						Set tAnyWithoutEarliest=1
					}
				}
			}
			
			If tCSVRecord'="" {
				Set pCSVRecordListTable(tGroupNo,$I(pCSVRecordListTable(tGroupNo)))=##class(DiffMessageRecord).%New(tCSVRecord,tSchemaOffsets)
			}
		}
		
		Set pAnyWithoutEarliest(tGroupNo)=tAnyWithoutEarliest
	}
}

Method EarliestExtent(ByRef pGroups) As %List [ Private ]
{
	Set tEarliestExtent=""
	
	// for each group ..
	Set tGroupHash="" While 1 {

		Set tGroupHash=$Order(pGroups(tGroupHash)) If tGroupHash="" {Quit}
		
		// for each item in the group ..
		Set tItemHash="" While 1 {
		
			Set tItemHash=$Order(pGroups(tGroupHash,tItemHash)) If tItemHash="" {Quit}
			Set tItemKey=..Cases.HashToKey(tItemHash)
			
			// for each case record ..
			Set tCase=..Cases.GetAt(tItemKey)
			For tI=1:1:tCase.Count() {
				
				Set tDiff=tCase.GetAt(tI)

				// the determining extent		
				Set tRet=..GetProgressiveExtent(tDiff)
				If tRet'="" {
					Set tExtent=$List(tRet)
					If tExtent'="" {
						If (tEarliestExtent="") || $$firstlessthan(tExtent,tEarliestExtent) {
							Set tEarliestExtent=tExtent
						}
					}
				}
			}												
		}
	}
	
	Quit tEarliestExtent
	
firstlessthan(a,b)
	Set $ListBuild(as,ae)=a
	Set $ListBuild(bs,be)=b
	If as<bs {Quit 1}
	If as=bs,ae<be {Quit 1}
	Quit 0
}

/// Returns $LB(SCHEMAOFFSET,MESSAGETEXT) - or "" if no message extent (i.e. schema element)
Method GetProgressiveExtent(pDiff As Diff) As %List [ Private ]
{
	// get case extents
	Kill tExtents
	Do pDiff.GetRegionExtents(.tExtents)
					
	// the first message extent				
	Set tMessageExtent=$Get(tExtents(1,0))
	If tMessageExtent="" {
		Quit "" // no message extent (i.e. schema element)
	}
		
	Set tMessageText=pDiff.MessageTextAt(tMessageExtent)
		
	// get schema offsets
	Set tSchemaOffsets=pDiff.SchemaOffsets()
	
	// the first schema offset
	Set tSchemaExtent=$List(tSchemaOffsets)
	
	Quit $ListBuild(tSchemaExtent,tMessageText)
}

Method AbstractStrings(ByRef pCSVRecordListTable) [ Private ]
{
	If '$Get(pCSVRecordListTable) {ZTrap}
	
	// all strings together
	Set tRec=""
	For tI=1:1:pCSVRecordListTable {
		For tJ=1:1:pCSVRecordListTable(tI) {
			Set tRec=tRec_$ListBuild($ListToString(pCSVRecordListTable(tI,tJ)))
		}
	}
	
	If tRec="" {
		$$$DBOUT("No strings found in records")
	}
	Else {
	
		Try {
			Set tAbstractStrings=##class(AbstractStrings).%New(tRec,1,..Config,..Logger)
		}
		Catch (e) {
			If e.Name="<ABSTRACTSTRINGS>" {
				$$$DBOUT(e.Data)
				Return
			}
			Throw e
		}
		
		Kill tColl
		Do tAbstractStrings.GetCollections(.tColl)
		For tI=1:1:$Get(tColl) {
			Set $ListBuild(tErrorCode,tPattern)=tColl(tI).DerivePattern("test"_tI)
			If tErrorCode="" {
				Write " AbstractStrings found pattern ",tI,": ",tPattern,!
			}
			Else {
				$$$DBOUT(" Error deriving pattern: "_tErrorCode)
			}
		}
	}
}

ClassMethod ShowExtent(ByRef pExtents, pIndex As %Integer) As %String [ Private ]
{
	Set tOut=""
	
	Set tMessageExtent=$Get(pExtents(pIndex,0))
	If tMessageExtent'="" {
		Set $ListBuild(tFirstMessageOffset,tLastMessageOffset)=tMessageExtent
		Set tOut=tOut_$ListBuild("Messages @"_tFirstMessageOffset_"..@"_tLastMessageOffset)
	}
	
	Set tSchemaElementNameCount=$Get(pExtents(pIndex))
	If tSchemaElementNameCount {
		Set tElementList=""
		For tI=1:1:tSchemaElementNameCount {
			Set tElementList=tElementList_$ListBuild(pExtents(pIndex,tI))
		}
		Set tOut=tOut_$ListBuild("Schemas "_$ListToString(tElementList))
	}
	
	Quit $ListToString(tOut,"    ")
}

ClassMethod FindMessageExtent(pMessageFirstExtent As %Integer, pMessageLastExtent As %Integer, ByRef pCombinedRegions) As %List [ Private ]
{
	Set tOut=""
	
	// for each existing combined region ..
	For tI=1:1:$Get(pCombinedRegions) {
	
		Set tMessageExtent=$Get(pCombinedRegions(tI,0))
		If tMessageExtent'="" {
		
			Set $ListBuild(tMessageFirstExtent,tMessageLastExtent)=tMessageExtent
			
			// if the new message starts inside the combined region's extent ..
			If pMessageFirstExtent>=(tMessageFirstExtent-1),pMessageFirstExtent<=(tMessageLastExtent+1) {
				Set tOut=tOut_$ListBuild(tI)
			}

			// .. if the new message ends inside the combined region's extent ..
			ElseIf pMessageLastExtent>=(tMessageFirstExtent-1),pMessageLastExtent<=(tMessageLastExtent+1) {
				Set tOut=tOut_$ListBuild(tI)
			}
		}
	}
	
	Quit tOut
}

ClassMethod FindSchemaExtent(ByRef pExtents, pExtentsIndex As %Integer, ByRef pCombinedRegions) As %List [ Private ]
{
	Set tOut=""
	
	For tI=1:1:$Get(pExtents(pExtentsIndex)) {
		Set tKey=pExtents(pExtentsIndex,tI)
		Set tExtentSchemas(tKey)=""
	}
	
	For tI=1:1:$Get(pCombinedRegions) {
	
		Set tFound=0
		For tJ=1:1:$Get(pCombinedRegions(tI)) {
			If $Data(tExtentSchemas(pCombinedRegions(tI,tJ))) {
				Set tFound=1
				Quit		
			}
		}
		
		If tFound {
			Set tOut=tOut_$ListBuild(tI)
		}
	}
	
	Quit tOut
}

/// pIndex("m",MESSAGESTARTOFFSET,MESSAGEENDOFFSET,CASEKEY,RECORDINDEX,EXTENTINDEX)=""
/// <br> pIndex("s",TLSK,ELEMENT,CASEKEY,RECORDINDEX,EXTENTINDEX)=""
/// <br> pIndex("sx",ELEMENT,CASEKEY)=""
Method MakeIndex(Output pIndex) [ Private ]
{
	$$$SHOULDBEUNDEF(pIndex)
	
	// for each case ..
	Set tDiffKey="" While 1 {
	
		Set tDiffKey=..Cases.Next(tDiffKey) If tDiffKey="" {Quit}
	
		Set tCase=..Cases.GetAt(tDiffKey)
		
		// for each record in this case ..
		For tJ=1:1:tCase.Count() {
		
			Set tDiffRecord=tCase.GetAt(tJ)
			
			Kill tExtents
			Do tDiffRecord.GetRegionExtents(.tExtents)
			
			For tK=1:1:tExtents {
			
				Set tMessageExtent=$Get(tExtents(tK,0))
				If tMessageExtent'="" {
					Set $ListBuild(tMessageFirstExtent,tMessageLastExtent)=tMessageExtent
					Set pIndex("m",tMessageFirstExtent,tMessageLastExtent,tDiffKey,tJ,tK)=""
				}
				
				For tL=1:1:$Get(tExtents(tK)) {
					Set tElementKey=tExtents(tK,tL)
					Set tTLEK=..TopLevelElementKey(tElementKey)
					Set pIndex("s",tTLEK,tElementKey,tDiffKey,tJ,tK)=""
					Set pIndex("sx",tElementKey,tDiffKey)=""
				}			
			}
		}
	}
}

ClassMethod DiffRecordsKey(pDiffRecordList As %ListOfObjects) As %String [ Private ]
{
	Set tOut=""
	
	For tI=1:1:pDiffRecordList.Count() {
		Set tOut=tOut_$ListBuild(pDiffRecordList.GetAt(tI).DiffKey())
	}
	
	Quit $ListToString(tOut,"///")
}

Method TopLevelElementKey(pElementKey As %String) As %String [ Private ]
{
	Set tProvenance=..Machine.GetAt(pElementKey).GetProvenance()
	
	// if it's a top-level element ..
	If $ListLength(tProvenance)<3 {
		Quit "."
	}
	
	// return the top-level structure
	Quit $List(tProvenance,2)
}

/// Implementation of super-class abstract method
Method Equivalent(pItem1 As %String, pItem2 As %String) As %Boolean
{
	Quit ..EquivalentCases(..Cases.GetAtHash(pItem1),..Cases.GetAtHash(pItem2))
}

Method EquivalentCases(pCase1 As %ListOfObjects, pCase2 As %ListOfObjects) As %Boolean [ Private ]
{
	For tI1=1:1:pCase1.Count() {
	
		Set tCase1Obj=pCase1.GetAt(tI1)
		Kill tExtents1
		Do tCase1Obj.GetRegionExtents(.tExtents1)
		
		For tI2=1:1:pCase2.Count() {

			Set tCase2Obj=pCase2.GetAt(tI2)
			Kill tExtents2
			Do tCase2Obj.GetRegionExtents(.tExtents2)

			If ..EquivalentDiffs(.tExtents1,.tExtents2) {
				Return 1
			}
		}
	}
	
	Return 0
}

Method EquivalentDiffs(ByRef pExtents1, ByRef pExtents2) As %Boolean [ Private ]
{
	Kill tIndex1
	Do ..IndexDiff(.pExtents1,.tIndex1)
	
	Kill tIndex2
	Do ..IndexDiff(.pExtents2,.tIndex2)
	
	If ..OverlappingMessageTypes(.tIndex1,.tIndex2) {
		Quit 1
	}
	
	If ..CommonElements(.tIndex1,.tIndex2) {
		Quit 1
	}
	
	If ..CommonTopLevelStructure(.tIndex1,.tIndex2) {
		Quit 1
	}
	
	Quit 0
	
showextents(extents)

	Set tOut=""
	For tK=1:1:extents {
	
		Set tMessageExtent=$Get(extents(tK,0))
		If tMessageExtent'="" {
			Set tOut=tOut_$ListBuild($ListToString(tMessageExtent,":"))
		}
		
		For tL=1:1:$Get(extents(tK)) {
			Set tElementKey=extents(tK,tL)
			Set tOut=tOut_$ListBuild(tElementKey)
		}			
	}
	
	Quit $ListToString(tOut," ")
}

ClassMethod OverlappingMessageTypes(ByRef pIndex1, ByRef pIndex2) As %Boolean [ Private ]
{
	Set tStart1="" While 1 {
		Set tStart1=$Order(pIndex1("m",tStart1)) If tStart1="" {Quit}
		If $Data(pIndex2("m",tStart1)) {Return 1}
	}
	
	Quit 0
}

ClassMethod CommonElements(ByRef pIndex1, ByRef pIndex2) As %Boolean [ Private ]
{
	
	Set tElementName="" While 1 {
		Set tElementName=$Order(pIndex1("sx",tElementName)) If tElementName="" {Quit}
		If $Data(pIndex2("sx",tElementName)) {Return 1}
	}
	
	Quit 0
}

ClassMethod CommonTopLevelStructure(ByRef pIndex1, ByRef pIndex2) As %Boolean [ Private ]
{
	
	Set tTLEK="" While 1 {
		Set tTLEK=$Order(pIndex1("s",tTLEK)) If tTLEK="" {Quit}
		If tTLEK'=".",$Data(pIndex2("s",tTLEK)) {Return 1}
	}
	
	Quit 0
}

/// Given a set of extents, return:
/// <p> pIndex("m",MESSAGEOFFSET) - set for each offset covered by skipped messages
/// <p> pIndex("s",TOPLEVELSTRUCTURE,ELEMENT)="" - TOPLEVELSTRUCTURE is "." for top-level elements
/// <p> pIndex("sx",ELEMENT)=""
Method IndexDiff(ByRef pExtents, Output pIndex) As %Boolean [ Private ]
{
	$$$SHOULDBEUNDEF(pIndex)
	
	For tK=1:1:pExtents {
	
		Set tMessageExtent=$Get(pExtents(tK,0))
		If tMessageExtent'="" {
			Set $ListBuild(tMessageFirstExtent,tMessageLastExtent)=tMessageExtent
			For tI=tMessageFirstExtent:1:tMessageLastExtent {
				Set pIndex("m",tI)=""
			}
		}
		
		For tL=1:1:$Get(pExtents(tK)) {
			Set tElementKey=pExtents(tK,tL)
			Set tTLEK=..TopLevelElementKey(tElementKey)
			Set pIndex("s",tTLEK,tElementKey)=""
			Set pIndex("sx",tElementKey)=""
		}			
	}
}

Method Misc() [ Private ]
{
	Kill tChoiceCases // tChoiceCases(CASEINDEX)=""
	Kill tCombinedRegions // tCombinedRegions(1..*)=$LB(FIRSTMESSAGEOFFSET,LASTMESSAGEOFFSET); tCombinedRegions(INDEX,SCHEMAELEMENT)=""
	
	// for each case ..
	Set tDiffKey="" While 1 {
	
		Set tDiffKey=..Cases.Next(tDiffKey) If tDiffKey="" {Quit}
	
		Set tCase=..Cases.GetAt(tDiffKey)
	
		// more than one record in this case ..
		If tCase.Count()>1 {
			Set tChoiceCases(tDiffKey)="" // save it for later
		}
		
		// .. just one record in this case ..
		Else {
		
			// the one record
			Set tDiff=tCase.GetAt(1)
			
			// get its extents
			Do tDiff.GetRegionExtents(.tExtents)
			
			Write tDiffKey,!
			ZWrite tExtents
			Write !
			
			// for each extent ..
			For tJ=1:1:$Get(tExtents) {
			
				
				Set tCombinedRegionMessageIndex=""
				Set tCombinedRegionSchemaIndex=""
				
				// if there is a message extent ..
				Set tMessageExtent=$Get(tExtents(tJ,0))
				If tMessageExtent'="" {
				
					Set $ListBuild(tMessageFirstExtent,tMessageLastExtent)=tMessageExtent
					Set tCombinedRegionMessageIndex=..FindMessageExtent(tMessageFirstExtent,tMessageLastExtent,.tCombinedRegions)
					
					Write " message ",tMessageFirstExtent,"-",tMessageLastExtent," -> CRMI=",$ListToString(tCombinedRegionMessageIndex),!
				}
				
				// if there is a schema extent ..
				If $Get(tExtents(tJ)) {
				
					Set tCombinedRegionSchemaIndex=..FindSchemaExtent(.tExtents,tJ,.tCombinedRegions)
					
					Set tSchemas="",tKey="" While 1 {Set tKey=$Order(tExtents(tJ,tKey)) If tKey="" {Quit} Set tSchemas=tSchemas_$ListBuild(tKey)}
					Write " schemas ",$ListToString(tSchemas)," -> CSMI=",$ListToString(tCombinedRegionSchemaIndex),!
				}

				// if a CRMI or CSMI was found ..
				If (tCombinedRegionMessageIndex'="") || (tCombinedRegionSchemaIndex'="") {
				
					// merge the new extent into the old region
					
					Write " tCombinedRegionMessageIndex=",$ListToString(tCombinedRegionMessageIndex),", tCombinedRegionSchemaIndex=",$ListToString(tCombinedRegionSchemaIndex),!
				}
				
				Else {
				
					// create a new combined region for the extent
					Set tIndex=$I(tCombinedRegions)
					Merge tCombinedRegions(tIndex)=tExtents(tJ)
				}
			}
		}
	}
	
	ZWrite tCombinedRegions
	
	If $Data(tChoiceCases)\10 {
		Set tI="" While 1 {
			Set tI=$Order(tChoiceCases(tI)) If tI="" {Quit}
			Write "STUB: process choice case #",tI," - ",..Cases.GetAt(tI),!
		}
	}
}

Method OriginalRecordsForHash(pItemHash As %String) As %String [ Private ]
{
	Set tCase=..Cases.GetAtHash(pItemHash)
	Set tOut=""
	For tI=1:1:tCase.Count() {
		Set tOut=tOut_$ListBuild($ListToString(tCase.GetAt(tI).GetOriginalRecord()))
	}
	Quit $ListToString(tOut," || ")
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Extensions, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive, EnsLib.InteropTools.HL7.MessageAnalyzer.API, EnsLib.InteropTools.HL7.MessageAnalyzer.Lines)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Strategies.ScanImpl.ScanBranch Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property SchemaSource As %String [ Private ];

/// MessageArray(1..MessageArray)=MESSAGESEGMENTLIST
Property MessageArray [ MultiDimensional, Private ];

Property DiffCollection As DiffCollection [ Private ];

Property DiffCountMetric As %Integer [ Private ];

Method %OnNew(pSchemaSource As %String, ByRef pMessageArray, pDiffCollection As DiffCollection, pConfig As Config, pLogger As Logger) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..SchemaSource=pSchemaSource
	Merge ..MessageArray=pMessageArray
	Set ..DiffCollection=pDiffCollection
	Set ..DiffCountMetric=-1 // not valid yet
	
	Quit $$$OK
}

Method SizeMetric() As %Integer [ CodeMode = expression ]
{
..DiffCountMetric + ..DiffCollection.SizeMetric()
}

Method BranchKey() As %String [ CodeMode = expression ]
{
##class(Common).Hash(..SchemaSource_"`"_$Select(..DiffCollection="":"",1:..DiffCollection.CollectionKey()))
}

/// If there was an exact match: returns the matching schema source
/// <p> If there was NO exact match: returns "" and a list of possible new schema sources in pSchemaSourceList
Method ExtendProgressivelyOne(pIgnoreTrailingZ As %Boolean, Output pSchemaSourceList) As %String
{
	$$$SHOULDBEUNDEF(pSchemaSourceList)
	
	Set pSchemaSourceList=""
	
	Set tRigSchemas=##class(RigSchemaCollection).%New()
	Set tSchema=##class(Common).MakeRigSchema(..SchemaSource,..Config,..Logger,1)
	Set tSchemaName=tSchema.GetSchemaName()
	Do tRigSchemas.Insert(tSchema)
	Set tMachineCollection=tRigSchemas.MakeMachineCollection()
	
	// copy the previous diff collection
	Set tPrevDiffCollection=..DiffCollection
	
	// construct a diff collection from the current schema
	Set ..DiffCollection=##class(DiffCollection).MakeDiffCollection(tMachineCollection.GetAt(tSchemaName),..Config,..Logger)	
	
	// try to find an extension
	Kill tMessageArray
	Merge tMessageArray=..MessageArray
	Kill tMessagesByDiff
	Kill tProgExtensions
	Set tMatched=..ExtendImpl(..Config,..Logger,pIgnoreTrailingZ,tSchemaName,..SchemaSource,.tMessageArray,tMachineCollection,tSchema,..DiffCollection,.tMessagesByDiff,.tProgExtensions)
	If tMatched {
		Quit ..SchemaSource
	}
	
	// if no extension was found ..
	If '$Get(tProgExtensions) {
		Quit ""
	}
	
	// if there was a previous diff collection ..
	If tPrevDiffCollection'="" {
		If '..CheckPrevDiffCollection(tPrevDiffCollection,..DiffCollection) {
			If ..Config.IsFlagSet("LOGSCANEXTENSION") {
				Write "NO PROGRESS",!
			}
			Quit ""
		}
	}
	
	Set ..DiffCountMetric=($Get(tMessagesByDiff(1)) + $Get(tMessagesByDiff(-1))) * 1000
	
	// for each returned extension ..
	For tP=1:1:tProgExtensions {
		
		// apply extension, giving new schema source
		Set tNewSchemaSource=tProgExtensions(tP).Apply(..SchemaSource)
		
		// check the messages-by-diff against the new schema
		// - previously matching messages should still match
		Set tIdentifyMessages=##class(IdentifyMessages).%New(..Config,..Logger)
		Do tIdentifyMessages.LoadSchemas(tNewSchemaSource)
		Set tRegressionCount=0
		For tI=1:1:$Get(tMessagesByDiff(0)) {
			Set tMessage=$List(tMessagesByDiff(0,tI))
			Set tMatchingSchemas=tIdentifyMessages.IdentifyMatchingSchemas(tMessage)
			If tMatchingSchemas="" {
					If ..Config.IsFlagSet("LOGSCANEXTENSION") {
						Write "REGRESSION: ",$ListToString(tMessage),!
						Write ##class(Common).SimplifyRawSchema(tNewSchemaSource),!!
					}
					Set tRegressionCount=tRegressionCount+1
				}
			}
		
		If 'tRegressionCount {
		
			// PATCHABLE
			//Write "OLD:",!,##class(Common).SimplifyRawSchema(..SchemaSource),!
			//Write "NEW:",!,##class(Common).SimplifyRawSchema(tNewSchemaSource),!
			
			// PATCHABLE
			If 0 {
				Read ">>>",in,!
				If in'="" {
					Set tNewSchemaSource=##class(Common).PutBackSquiggles(in)
				}
			}
			
			Set pSchemaSourceList=pSchemaSourceList_$ListBuild(tNewSchemaSource)
		}
	}
		
	Quit ""
}

Method GetDiffCollection() As DiffCollection [ CodeMode = expression ]
{
..DiffCollection
}

Method GetSchemaSource() As %String [ CodeMode = expression ]
{
..SchemaSource
}

/// Returns whether a match was found
/// <p> pMessagesByDiff(TYPE,1..pMessagesByDiff(TYPE))=$LB(MESSAGESEGMENTLIST,ADDEDKEY)
/// <p> TYPE is one of: 1=>added to diffs, 0=>matched, -1=>not added to diffs but not matching either 
ClassMethod ExtendImpl(pConfig As Config, pLogger As Logger, pIgnoreTrailingZ As %Boolean, pBestSchemaName As %String, pBestSchemaSource As %String, ByRef pMessageArray, pMachineCollection As MachineCollection, pRigSchema As RigSchema, pDiffCollection As DiffCollection, Output pMessagesByDiff, ByRef pExtensions As Extend) As %Boolean
{
	$$$SHOULDBEUNDEF(pMessagesByDiff)
	
	Set tIdentifyMessages=##class(IdentifyMessages).%New(pConfig,pLogger)
	Do tIdentifyMessages.LoadSchemas(pBestSchemaSource)
	
	// for each message ..
	For tI=1:1:pMessageArray {
	
		Set tMessage=pMessageArray(tI)
		
		// add a diff for the outcome to the diff collection (no backtracking)
		Set tAddedKey=..AddDiffForMessage(pIgnoreTrailingZ,pRigSchema,tMessage,pDiffCollection,pConfig,0)
		Set tWasAdded=(tAddedKey'="")

		If 'tWasAdded {

			// add a diff for the outcome to the diff collection (with backtracking)
			Set tAddedKey=..AddDiffForMessage(pIgnoreTrailingZ,pRigSchema,tMessage,pDiffCollection,pConfig,1)
			Set tWasAdded=(tAddedKey'="")
			If tWasAdded,pConfig.IsFlagSet("LOGSCANEXTENSION") {
				Write "Added with backtracking: ",$ListToString(tMessage),!
			}
		}
			
		If tWasAdded {
			Set tType=1 // 1 => added to diffs
		}
		Else {
		
			If tIdentifyMessages.IdentifyMatchingSchemas($ListToString(tMessage))="" {
				Set tType=-1 // -1 => not added to diffs but not matching either
			}
			Else {
				Set tType=0 // 0 => matching
			}
		}
		
		Set pMessagesByDiff(tType,$I(pMessagesByDiff(tType)))=$ListBuild(tMessage,tAddedKey)
	}
	
	If pConfig.IsFlagSet("LOGSCANEXTENSION") {
		Write !
		Write ##class(Common).SimplifyRawSchema(pBestSchemaSource),!
		Write pMessageArray," messages, ",pDiffCollection.Count()," diffs",!
		If '$Get(pMessagesByDiff(0)) {
			Write "No matching messages",!
		}
		Else {
			Write "*** Matching messages:",!
			For tI=1:1:pMessagesByDiff(0) {
				Write " ",$ListToString($List(pMessagesByDiff(0,tI))),!
			}
		}
		If '$Get(pMessagesByDiff(1)) {
			Write "No mismatching messages",!
		}
		Else {
			Write "Mismatching messages:",!
			For tI=1:1:pMessagesByDiff(1) {
				Set $ListBuild(tMessage,tDiffKey)=pMessagesByDiff(1,tI)
				Write " ",$ListToString(tMessage),!
				Write " - ",pDiffCollection.CaseRepr(tDiffKey),!
			}
		}
		If '$Get(pMessagesByDiff(-1)) {
			Write "No diffless mismatching messages",!
		}
		Else {
			Write "Diffless mismatching messages:",!
			For tI=1:1:pMessagesByDiff(-1) {
				Write " ",$ListToString($List(pMessagesByDiff(-1,tI))),!
			}
		}
	}
	
	// if there were no mismatches or diffless mismatches ..
	If '$Get(pMessagesByDiff(1)),'$Get(pMessagesByDiff(-1)) {
		Quit 1
	}
		
	// if we're doing any checking of derived patterns ..
	If pConfig.IsFlagSet("CHECKDERIVEDPATTERNS") || pConfig.IsFlagSet("CHECKDERIVEDPATTERNSDETAIL") {
	
		// dump the diff collection
		Do pDiffCollection.DebugShow()
	}
	
	// find the regions of the diffs
	Kill tCSVRecordListTable
	Kill tAnyWithoutEarliest
	Do ..FindRegions(pDiffCollection,.tCSVRecordListTable,.tAnyWithoutEarliest,pConfig)
	
	// if there are any records ..
	If $Get(tCSVRecordListTable) {
	
		If $$$DBFLAG {

			For tGroupNo=1:1:tCSVRecordListTable {					
				Write "CSV #",tGroupNo,":",!
				
				For tMessageNo=1:1:$Get(tCSVRecordListTable(tGroupNo)) { // TODO $GET NEEDED?
					Write " ",tCSVRecordListTable(tGroupNo,tMessageNo).Show(pBestSchemaSource),!
				}
			}
		}
	
		// turn the records into a $List
		Set tOriginalRecords=""
		For tI=1:1:tCSVRecordListTable {
			For tJ=1:1:$Get(tCSVRecordListTable(tI)) { // TODO $GET NEEDED?
				Set tOriginalRecords=tOriginalRecords_$ListBuild(tCSVRecordListTable(tI,tJ).GetMessageSegmentTypes())
			}
		}

		Set tPattern=..GetShortestPattern(pConfig,pLogger,tOriginalRecords,.tAnyWithoutEarliest)
		
		If tPattern'="" {
		
			If pConfig.IsFlagSet("LIMITDIFFCHANGES") {
			
				// PATCHABLE
				//Write "Any without earliest=",$Get(tAnyWithoutEarliest(1),"?"),!
				
				// find the schema position
				Set tDiffRecord=$Get(tCSVRecordListTable(1,1))
				If tDiffRecord="" {
				
					// PATCHABLE
					//Write "No record at 1,1",!
				}
				Else {
				
					Set tRawUpdateAtOffset=$List($List(tDiffRecord.GetSegmentOffsets())) // just take first segment offset
					
					Set tStandardPattern=##class(Common).PutBackSquiggles(tPattern)
					
					Do ..PatchSchema(pBestSchemaSource,tRawUpdateAtOffset,tStandardPattern,.pExtensions,pConfig)
				}
			}
		}
	}
	
	Quit 0
}

/// Returns pattern, or "" if none
ClassMethod GetShortestPattern(pConfig As Config, pLogger As Logger, pOriginalRecords As %List, ByRef pAnyWithoutEarliest) As %String [ Private ]
{
	Set tJudge=##class(ScanJudge).%New(pConfig,pLogger,pOriginalRecords,.pAnyWithoutEarliest)
	Kill tPattern
	Set tLinesSymbols=##class(Compress).MakeLinesSymbolsBest(pOriginalRecords,pLogger,'pConfig.IsFlagSet("LOGSCANEXTENSION"),,tJudge,.tPattern)
	Quit tPattern
}

/// Returns pattern, or "" if none
ClassMethod GetPattern(pConfig As Config, pLogger As Logger, pLinesSymbols As LinesSymbols, pOriginalRecords As %List, ByRef pAnyWithoutEarliest) As %String
{
	// get the lines with the new symbols present
	Set tOut=pLinesSymbols.GetLines()
	
	If pConfig.IsFlagSet("LOGSCANEXTENSION") {
		Do pLogger.OutputToLog("Unique compressed records:")
		Set tI=1
		Set tPtrI=0 While $ListNext(tOut,tPtrI,tElemI) {
			Do pLogger.OutputToLog(" "_tI_":"_$ListToString(tElemI))					
			Set tI=tI+1
		}
	}
	
	// if there are NO lines ..
	If tOut="" {
		Quit ""
	}
	
	// derive patterns from lines
	Kill tDerivePatterns
	Do ..Derive(tOut,pOriginalRecords,pLinesSymbols,.tDerivePatterns,pConfig,pLogger)
	If '$Data(tDerivePatterns) {
		Quit ""
	}
			
	// take the first pattern
	Set tFirstTermCount=$Order(tDerivePatterns("")) If tFirstTermCount="" {ZTrap}
	If '$Data(tDerivePatterns(tFirstTermCount,1)) {ZTrap}
	Set tFirstPattern=$List(tDerivePatterns(tFirstTermCount,1))
	If $Get(pAnyWithoutEarliest(1)) || 1 { // PATCHED - always optional - so that non-differing messages are preserved
		Set tUsePattern="["_tFirstPattern_"]"
	}
	Else {
		Set tUsePattern=tFirstPattern
	}
	
	Quit tUsePattern
}

ClassMethod Derive(pLines As %List, pOriginalRecords As %List, pLinesSymbols As LinesSymbols, Output pDerivePatterns, pConfig As Config, pLogger As Logger) [ Private ]
{
	// TODO is pLines always pLinesSymbols.GetLines()?
	
	$$$SHOULDBEUNDEF(pDerivePatterns)
	
	// create a pattern checker if one is needed
	If pConfig.IsFlagSet("CHECKDERIVEDPATTERNSDETAIL") {
		Set tPatternChecker=##class(PatternChecker).%New(pLines)
	}
	Else {
		Set tPatternChecker=""
	}
	
	// derive patterns from pLines+pLinesSymbols
	Set tTopLevel=##class(TopLevel).%New(pLines,pConfig,pLogger,$Select(pConfig.IsFlagSet("CHECKDERIVEDPATTERNSDETAIL"):tPatternChecker,1:""),pLinesSymbols) // TODO does this change pLinesSymbols?
	Do tTopLevel.Run()		
	
	// get the derived patterns, sorted by term count
	Kill pDerivePatterns
	Do tTopLevel.GetSortedResults(.pDerivePatterns)
	
	If pConfig.IsFlagSet("LOGSCANEXTENSION") {
		Do ##class(Common).ShowSortedDeriveResults(.pDerivePatterns,pLogger,,pConfig.IsFlagSet("SHOWALLDERIVERESULTS"))
	}
	
	// if we need to check the patterns at this stage ..
	If pConfig.IsFlagSet("CHECKDERIVEDPATTERNS") {
		Set tPatternCheckerOriginal=##class(PatternChecker).%New(pOriginalRecords)
		Do ..CheckDerivedPatterns(pOriginalRecords,tPatternCheckerOriginal,.pDerivePatterns,pLogger)
	}
}

/// Returns pCSVRecordListTable(1..*,1..*)=RECORD (within GROUP)
/// <br> RECORD=$LB(MESSAGESEGMENTTYPE,..)
ClassMethod FindRegions(pDiffCollection As DiffCollection, Output pCSVRecordListTable, Output pAnyWithoutEarliest, pConfig As Config) [ Private ]
{
	
	$$$SHOULDBEUNDEF(pCSVRecordListTable)
	
	If 'pConfig.IsFlagSet("OLDDIFFCOLLECTION") {
		Do pDiffCollection.GetCSVRecords(.pCSVRecordListTable)
	}
	
	Else {
		// tGroups(GROUPHASH,ITEMHASH)=""
		Kill tGroups
		Do pDiffCollection.GetGroupsWrapper(.tGroups)	
		
		If ($Data(tGroups)\10)=0 {
			$$$DBOUT("No groups")
			Quit
		}
					
		If pConfig.IsFlagSet("LIMITDIFFCHANGES") {
			Do pDiffCollection.WithinGroupsLimited(.tGroups,.pCSVRecordListTable,.pAnyWithoutEarliest)
		}
		Else {
			Do pDiffCollection.WithinGroupsAll(.tGroups,.pCSVRecordListTable)
		}
	}
}

/// If appropriate: add a Diff for the given message
/// <br> If a Diff was added it returns the key of the Diff in the collection, otherwise "" is returned
ClassMethod AddDiffForMessage(pIgnoreTrailingZ As %Boolean, pRigSchema As RigSchema, pMessageSegmentList As %List, pDiffCollection As DiffCollection, pConfig As Config, pBacktracking As %Boolean) As %String [ Private ]
{
	// unless this message is excluded by configuration ..
	If 'pIgnoreTrailingZ || ($Extract($List(pMessageSegmentList,*))'="Z") {
	
		// find the differences between this message and the schema
		Kill tShortestFinalDiffRecords		
		Kill tFailureOutcome
		Do ##class(Common).RunImplScan(pMessageSegmentList,pRigSchema,pConfig,pBacktracking,1,.tFailureOutcome,.tShortestFinalDiffRecords)
		
		// if it's a control failure ..
		If tFailureOutcome'="",tFailureOutcome.FailureOutcomeType()=$$$FOCONT {
			Quit "" // no diff was added
		}
		
		// only pass non-empty arrays with NO schema elements in the diffs ..
		If $Get(tShortestFinalDiffRecords),'..AnySchemaElements(.tShortestFinalDiffRecords) {
		
			// add this to the diff collection
			Quit pDiffCollection.AddCase(.tShortestFinalDiffRecords)
		}
	}	
	
	Quit ""
}

ClassMethod AnySchemaElements(ByRef pShortestFinalDiffRecords) As %Boolean [ Private ]
{
	For tI=1:1:pShortestFinalDiffRecords {
		If pShortestFinalDiffRecords(tI).AnySchemaElements() {
			Return 1
		}
	}
	
	Quit 0
}

ClassMethod UniqueRecords(pListList As %List) As %List [ Private ]
{
	Kill tSeen
	Set tPtrI=0 While $ListNext(pListList,tPtrI,tElemI) {
		Set tHash=##class(Common).Hash(tElemI)
		Set tSeen(tHash)=tElemI
	}
	
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=$Order(tSeen(tKey),+1,tData) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tData)
	}
	
	Quit tOut
}

ClassMethod CheckDerivedPatterns(pMessages As %List, pPatternChecker As PatternChecker, ByRef pDerivePatterns, pLogger As Logger) [ Private ]
{
	// if there are any derived patterns at all ..
	Set tFirstKey=$Order(pDerivePatterns(""))
	If tFirstKey'="" {
	
		Do pLogger.OutputToLog("Check best derived patterns")

		Set tFailed=0
		
		// for each derived pattern ..
		For tI=1:1:pDerivePatterns(tFirstKey) {
		
			Set tPattern=$List(pDerivePatterns(tFirstKey,tI))
			Do pLogger.OutputToLog("Pattern: "_tPattern)
			
			// if the pattern is valid ..
			If ##class(TreeTask).IsValidPattern(tPattern) {
			
				// if the pattern doesn't match some of the messages ..
				Set tErr=pPatternChecker.CheckPattern(tPattern)
				If tErr'="" {
				
					// log the problem
					Do pLogger.OutputToLog("*** "_$ListLength(tErr)_" messages did not match")
					Do pLogger.OutputToLog("- messages:")
					Set tPtr=0 While $ListNext(tErr,tPtr,tElem) {
						Do pLogger.OutputToLog(" "_$ListToString(tElem))
					}
					Set tFailed=1
				}
			}
			
			Else {
				Do pLogger.OutputToLog("- pattern can't be checked - contains empty choice components")
			}
		}
		
		// if there were any failures ..
		If tFailed {
		
			// show all the messages
			Do pLogger.OutputToLog("All messages:")
			Set tPtrI=0 While $ListNext(pMessages,tPtrI,tElemI) {
				Do pLogger.OutputToLog(" "_$ListToString(tElemI))
			}
			Do pLogger.OutputToLog("")			
		}
	}
}

ClassMethod PatchSchema(pSchemaSource As %String, pOriginalUpdateOffset As %Integer, pPattern As %String, ByRef pExtensions As Extend, pConfig As Config) [ Private ]
{
	Set tUpdateAtOffsetList=..PatchLocations(pSchemaSource,pOriginalUpdateOffset)

	Set tLenSchemaSource=$Length(pSchemaSource)
	Set tPtr=0 While $ListNext(tUpdateAtOffsetList,tPtr,tUpdateAtOffset) {
	
		If tUpdateAtOffset <= tLenSchemaSource {

			If pConfig.IsFlagSet("LOGSCANEXTENSION") {
				Write "Update schema at ",tUpdateAtOffset," ",$$snippet(pSchemaSource,tUpdateAtOffset)," (raw ",pOriginalUpdateOffset," ",$$snippet(pSchemaSource,pOriginalUpdateOffset),")",!
			}
			
			Set pExtensions($I(pExtensions))=##class(ExtendSequence).%New(pPattern,tUpdateAtOffset)
		}
	}
	
	Quit
	
snippet(schema,offset)
	Quit """"_$Extract(schema,offset,offset+10)_""""
}

/// Given a schema (standard unsimplified format) and an offset to a segment type
/// <p> Return a list of locations to try inserting a pattern
ClassMethod PatchLocations(pSchema As %String, pOffset As %Integer) As %List [ Private ]
{
	$$$ACASSERT(##class(Common).IsStandardSchema(pSchema),"PatchLocations: expected schema in standard unsimplified format")
	
	Set tOut=""
	
	// before the original segment type
	Set tOut=tOut_$ListBuild(pOffset)
	
	// steps back over "[" or "{"
	Set tOffs=pOffset
	While tOffs>=1,"[{"[$Extract(pSchema,tOffs-2) {
		Set tOffs=tOffs-2
		
		// backtracked offset
		Set tOut=tOut_$ListBuild(tOffs)
	}

	Set tLenSchema=$Length(pSchema)
	
	// after the original segment type
	Set tNextSquiggle=$$aftersegment(pOffset)
	If tNextSquiggle {
		
		Set tOffs=tNextSquiggle+1
		If tOffs<=(tLenSchema+1) {
			Set tOut=tOut_$ListBuild(tOffs) // after the original segment type
		}
		
		While tOffs<=tLenSchema,"]}"[$Extract(pSchema,tOffs+1) {
			
			Set tOffs=tOffs+2
			
			// forward tracked offset
			Set tOut=tOut_$ListBuild(tOffs)
		}
	}
		
	Quit tOut
	
aftersegment(offset)
	Quit ##class(Common).IndexOf(pSchema,"~",offset)
}

/// Returns 1 if the new collection has progressed since the previous collection - i.e. if it differs from it
ClassMethod CheckPrevDiffCollection(pPrevDiffCollection As DiffCollection, pDiffCollection As DiffCollection) As %Boolean [ CodeMode = expression, Private ]
{
'pPrevDiffCollection.Equals(pDiffCollection)
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Lexer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Node)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common [ Abstract ]
{

Parameter ZEROES = 000000000000000000000000000000000000;

ClassMethod LatestSchemaVersion() As %String
{
	Set tK="" While 1 {
		Set tK=$Order($$$vaSchemaGbl(tK),-1) If tK="" {Quit}
		If (tK?1.N1"."1.N) || (tK?1.N1"."1.N1"."1.N) {
			Return tK
		}
	}

	$$$FATAL("LatestSchemaVersion: no suitable (N.N or N.N.N) versions found in global")
}

ClassMethod SchemaVersion(OptionalVersion As %String = "") As %String [ CodeMode = expression ]
{
$Select(OptionalVersion="":..LatestSchemaVersion(),1:OptionalVersion)
}

ClassMethod SchemaSourceList(RawSource As %String, OptionalVersion As %String = "") As %List
{
	#Dim prefix,k
	#Dim out As %List
	
	Set tVersion=..SchemaVersion(OptionalVersion)
	
	If $Extract(RawSource,*)'="*" {Quit $ListBuild(RawSource)}
	
	Set prefix=$Extract(RawSource,1,*-1)
	Set out=""
	If prefix'="",$Data($$$vaSchemaGbl(tVersion,"MS",prefix)) {
		If $Extract(prefix,1,3)'="ACK" {
			Set out=out_$ListBuild(prefix)
		}
	}
	
	Set k=prefix
	While 1 {
		Set k=$Order($$$vaSchemaGbl(tVersion,"MS",k)) If (k="") || ($Extract(k,1,$Length(prefix))'=prefix) {Quit}
		If $Extract(k,1,3)'="ACK" {
			Set out=out_$ListBuild(k)
		}
	}
	
	Quit out
}

ClassMethod ProcessSchemaSelection(pIn As %String, pRigSchemas As RigSchemaCollection, pVersion As %String = "", pConfig As Config, pLogger As Logger, pQuiet As %Boolean)
{
	If pIn="" {$$$FATAL("Empty string passed to ProcessSchemaSelection")}
	
	Set parts=$ListFromString(pIn,"+")
	
	Set tVersion=..SchemaVersion(pVersion)
	
	Kill tSchemaNameList
	Do ..ExpandParts(parts,tVersion,.tSchemaNameList)
	
	Set tWroteAnyDots=0
	
	If '$Get(tSchemaNameList) {
		If 'pQuiet {
			Write "No schemas selected",!
		}
	}
	
	Else {
	
		For tI=1:1:tSchemaNameList {
			If 'pQuiet,tI#10=0 {
				Write "."
				Set tWroteAnyDots=1
			}
			Set tRigSchema=..ProcessSchemaSelectionImpl($$$TRIM(tSchemaNameList(tI)),tVersion,pConfig,pLogger,pQuiet)
			If $IsObject(tRigSchema) {
				Do pRigSchemas.Insert(tRigSchema)
			}
		}
	}
	
	// if we wrote any dots
	If tWroteAnyDots {
		Write !
	}
}

ClassMethod ProcessSchemaSelectionImpl(pRawSchema As %String, pVersion As %String, pConfig As Config, pLogger As Logger, pQuiet As %Boolean) As RigSchema [ Private ]
{
	
	Set schemadefinition=..ParseSchemaSpec(pRawSchema,pVersion)
	If schemadefinition="" {
		If 'pQuiet {
			Write "- there is no schema named '"_pRawSchema_"' in the database",!
		}
		Quit ""
	}

	Try {
		Set lexer=##class(Lexer).%New(schemadefinition)
		Set tTopNode=##class(Parser).ParseSchema(lexer)
	}
	Catch err {
		Write "- unable to parse schema '"_pRawSchema_"'",!
		Write "- error: ",err.DisplayString(),!
		Write "- schema source: ",schemadefinition,!
		Write !
		Return ""
	}
	
	Set schemaname=pConfig.SchemaName(pRawSchema)
	Set rigschema=##class(RigSchema).%New(schemaname,schemadefinition,tTopNode,pConfig,pLogger)
	
	If pConfig.IsFlagSet("ALLGRAPHS") {
		Do rigschema.GraphNode()
	}
	
	Do rigschema.GenerateNFA(1)
	
	Quit rigschema
}

ClassMethod ExpandParts(pParts As %List, pVersion As %String, Output pSchemaNameList) [ Private ]
{
	$$$SHOULDBEUNDEF(pSchemaNameList)
	
	Set tPtrI=0 While $ListNext(pParts,tPtrI,tElemI) {
		Set tSchemaSourceList=##class(Common).SchemaSourceList(tElemI,pVersion)
		Set tPtrJ=0 While $ListNext(tSchemaSourceList,tPtrJ,tElemJ) {
			Set pSchemaNameList($I(pSchemaNameList))=tElemJ
		}
	}
}

/// <p> Given a schema specification:
/// <ul>
/// <li> if the spec is a schema definition: return the original text
/// <li> if the spec identifies a schema in the database: return the schema raw text from the database
/// <li> if the spec contains a "_" but is not found in the database: return ""
/// <li> otherwise assume the spec is a simplified schema definition: return the converted text 
/// </ul>
ClassMethod ParseSchemaSpec(pSpec As %String, OptionalVersion As %String = "") As %String
{
	// contains "~" => raw schema format
	If pSpec["~" {
		Quit pSpec
	}

	// look it up as a schema name
	Set tResult=..SchemaStandardSource(pSpec,OptionalVersion)
	If tResult'="" {
		Quit tResult
	}
	
	// if it looks like a schema name ..
	If pSpec["_" {
		Quit ""
	}

	// raw schema format with "~"s stripped
	Quit ..PutBackSquiggles(pSpec)
}

/// Given a schema name return the standard schema source, or "" if not found in database
ClassMethod SchemaStandardSource(pSchema As %String, OptionalVersion As %String = "") As %String
{
	#Dim tVersion,tId
	#Dim tEx As %Exception.AbstractException
	
	If pSchema[":" {
		Set tVersion=$Piece(pSchema,":")
		Set tId=$Piece(pSchema,":",2)
	}
	Else {
		Set tVersion=..SchemaVersion(OptionalVersion)
		Set tId=pSchema
	}
	
	Try {
		Return $$$vaSchemaGbl(tVersion,"MS",tId)
	}
	Catch (tEx) {
		Return ""
	}
}

/// Input format differs from raw schema format in that all compound tokens with a "~" (e.g. "[~", "~]") have their "~"s removed and the sequence-separator "~"s are replaced by commas.
ClassMethod PutBackSquiggles(pSpec As %String) As %String
{
	#Dim tI,tC,tOut
	
	Set tOut=""
	For tI=1:1:$Length(pSpec) {
	
		Set tC=$Extract(pSpec,tI)
		
		// "," becomes "~"
		If tC="," {Set tOut=tOut_"~"}
		
		// openers get "~" appended
		ElseIf "[{<"[tC {Set tOut=tOut_tC_"~"}
		
		// closers get "~" prepended
		ElseIf "]}>"[tC {Set tOut=tOut_"~"_tC}
		
		// "|" gets "~"s around it
		ElseIf tC="|" {Set tOut=tOut_"~|~"}
		
		// anything else is passed through unchanged
		Else {Set tOut=tOut_tC}
	}
	
	Quit tOut
}

/// Convert raw schema format to simplified format (the reverse of PutBackSquiggles)
ClassMethod SimplifyRawSchema(pRawSpec As %String) As %String
{
	#Dim tOut
	
	Set tOut=pRawSpec
	
	Set tOut=$Replace(tOut,"[~","[")
	Set tOut=$Replace(tOut,"{~","{")
	Set tOut=$Replace(tOut,"<~","<")
	Set tOut=$Replace(tOut,"~]","]")
	Set tOut=$Replace(tOut,"~}","}")
	Set tOut=$Replace(tOut,"~>",">")
	Set tOut=$Replace(tOut,"~|~","|")
	Set tOut=$Replace(tOut,"~",",")
	
	Quit tOut
}

/// Return the given spec to simplified format if needed - otherwise leave as-is
ClassMethod AsSSF(pSpec As %String) As %String [ CodeMode = expression ]
{
$Select(..IsStandardSchema(pSpec):..SimplifyRawSchema(pSpec),1:pSpec)
}

/// Return the given spec to standard (unsimplified) format if needed - otherwise leave as-is
ClassMethod AsCSF(pSpec As %String) As %String [ CodeMode = expression ]
{
$Select(..IsStandardSchema(pSpec):pSpec,1:..PutBackSquiggles(pSpec))
}

/// Returns 1 for the HL7 schema format, 0 for the simplified format
ClassMethod IsStandardSchema(pSchema As %String) As %String [ CodeMode = expression ]
{
pSchema["~"
}

ClassMethod WithoutVersionPrefixes(pSchemaSource As %String, pVersion As %String) As %String [ CodeMode = expression ]
{
$Replace(pSchemaSource,pVersion_":","")
}

/// Given a list of SSF pattern-components: return an SSF pattern which is either the only element of a singleton list or a choice of all the elements of a larger list 
ClassMethod ListToPattern(pList As %List) As %String
{
	If pList="" {
		$$$FATAL("ListToPattern: list is empty")
	}
	
	If $ListLength(pList)=1 {
		Quit $List(pList)
	}
	Else {
		Quit "<"_$ListToString(pList,"|")_">"
	}
}

/// Returns $LB(anysucc,furthestreport,$LB(summary1,summary2,..),message->schema xref)
/// <br>- anysucc is whether there were any full matches
/// <br>- furthestreport is the report for the longest partial match
/// <br>- each summary is the description of a branch outcome
/// <br>- message->schema xref
ClassMethod RunImplMatch(MessageSegmentTypes As %List, RigSchema As RigSchema, Config As Config, Quiet As %Boolean = 0, Output FailureOutcome As FailureOutcome) As %List
{
	$$$SHOULDBEUNDEF(FailureOutcome)
	
	Set control=RigSchema.MakeControl("EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control.MatchingControl",1)
	Set tMSR=##class(MessageSegmentReader).%New(MessageSegmentTypes)
	If 'Quiet {
		Write "Remaining text: ",tMSR.RemainingText(),!
	}
	Do control.RunControl(,tMSR,.result,.FailureOutcome) // default to start element of NFA
	Set summary=$List(result,3)

	If 'Quiet {

		Write $ListToString(summary),!

		For r=1:1:control.GetReportCount() {
			Set reports=control.GetReports(r)
			Set i=1
			Set tPtrI=0 While $ListNext(reports,tPtrI,tElemI) {
				Write !,"Branch #",i,!
				Set i=i+1
				Set onereport=tElemI
				Set tPtrJ=0 While $ListNext(onereport,tPtrJ,tElemJ) {				
					Write " ",tElemJ,!
				}
			}
		}
	}
	
	Quit result
}

/// Returns pShortestFinalDiffRecords(1..*)=Diff 
ClassMethod RunImplScan(MessageSegmentTypes As %List, RigSchema As RigSchema, Config As Config, pBacktracking As %Boolean, Quiet As %Boolean = 0, Output FailureOutcome As FailureOutcome, Output pShortestFinalDiffRecords)
{
	#Dim control As ControlBase
	#Dim tMSR As MessageSegmentReader
	#Dim anysucc As %Boolean
	
	$$$SHOULDBEUNDEF(FailureOutcome)
	$$$SHOULDBEUNDEF(pShortestFinalDiffRecords)
	
	Set control=RigSchema.MakeControl("EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control.ScanningControl",pBacktracking)
	Set tMSR=##class(MessageSegmentReader).%New(MessageSegmentTypes)
	If 'Quiet {
		Write "Remaining text: ",tMSR.RemainingText(),!
	}
	Do control.RunControl(,tMSR,.result,.FailureOutcome) // default to start element of NFA
	Set $ListBuild(anysucc,furthestreport,summary)=result
	
	Do control.GetFinalDiffRecords(.tFinalDiffRecords)
	If '$Get(tFinalDiffRecords) {
		If 'Quiet {
			Write "No diff records",!
		}
		Quit  // no diff records
	}
	
	Kill pShortestFinalDiffRecords
	Do ##class(Diff).GetShortest(.tFinalDiffRecords,.pShortestFinalDiffRecords)
	If 'Quiet {
		If '$Get(pShortestFinalDiffRecords) {
			Write "No diff records found",!
		}
		Else {
			Write "Shortest diff records:",!
			For tI=1:1:pShortestFinalDiffRecords {
				Write !," ",pShortestFinalDiffRecords(tI).Show(),!
			}
		}
	}
}

ClassMethod Status(pSC As %Status) As %String
{
	Do decomposeStatus^%occSystem(pSC,.tErrorList)
	Quit $Get(tErrorList(1),"Unknown status - "_##class(%XSQL.Format).ListFormat(pSC))
}

ClassMethod WriteFile(pFilePath As %String, pFileLines As %List)
{
	#Dim tI
	#Dim tFile As %File
	#Dim tSC As %Status
	
	Set tFile=##class(%File).%New(pFilePath)
	$$$THROWONERROR(tSC,tFile.Open("WN"))
	Set tPtrI=0 While $ListNext(pFileLines,tPtrI,tElemI) {
		$$$THROWONERROR(tSC,tFile.WriteLine(tElemI))
	}
}

ClassMethod FileContents(Path As %String) As %String
{
	#Dim text
	#Dim file As %File
	#Dim tSC As %Status
	
	Set file=##class(%File).%New(Path)
	$$$THROWONERROR(tSC,file.Open("R"))
	Set text=""
	While 'file.AtEnd {
		Set text=text_file.ReadLine(,.tSC)_$Char(10) If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
	}	
	
	Quit text
}

ClassMethod ShowDigraph(pDigraph As %CPT.Tree.SimpleDigraph, pFileName As %String, pConfig As Config, pLogGraphWrittenTo As %Boolean = 0)
{
	#Dim tPath,tCommand
	#Dim tSC As %Status
	
	Set tPath=..DotFilePath(pFileName)
	If tPath="" {
		Throw ##class(%Exception.General).%New("Dot file path is not configured correctly: "_$$$GLOBALSETTINGSNAME_"(""DOTPATH"") needs to be set")
	}
	
	$$$THROWONERROR(tSC,pDigraph.Render(tPath))
	
	If ($Get($$$GLOBALSETTING("SHOWGRAPHS"),1)) {
		Set tCommand="dotsvgshow "_tPath // dotsvgshow runs Graphviz 'dot' with arguments '-Tsvg -O $1' and then launches the resulting .svg file ('open $1.svg' on Mac)
	}
	Else {
		Set tCommand="dotsvg "_tPath // dotsvg runs Graphviz 'dot' with arguments '-Tsvg -O $1'
	}
	
	If $ZF(-1,tCommand)
	
	If pLogGraphWrittenTo {
		Write "Graph written to ",tPath,!
	}
}

ClassMethod ShowExistingDigraph(pFileName As %String, pConfig As Config)
{
	#Dim tPath,tCommand
	#Dim tSC As %Status
	
	Set tPath=..SvgFilePath(pFileName)
	If tPath="" {
		Throw ##class(%Exception.General).%New("Dot file path is not configured correctly: "_$$$GLOBALSETTINGSNAME_"(""DOTPATH"") needs to be set")
	}
	
	If $ZF(-1,"svgshow "_tPath) // svgshow launches the given .svg file ('open $1.svg' on Mac)
}

ClassMethod DotFilePath(pFileName As %String) As %String [ CodeMode = expression ]
{
$Select(
	$Data($$$GLOBALSETTING("DOTPATH"),tPath)#10:##class(%File).NormalizeFilename(pFileName_".dot",tPath),
	1:##class(%File).TempFilename("dot"))
}

ClassMethod SvgFilePath(pFileName As %String) As %String
{
	If $Data($$$GLOBALSETTING("DOTPATH"),tPath)#10 {
		Quit ##class(%File).NormalizeFilename(pFileName_".dot.svg",tPath)
	}
	
	Throw ##class(%Exception.General).%New("The default dot path needs to be set in global "_$$$GLOBALSETTINGSNAME_"(""DOTPATH"")")
}

ClassMethod MakeRigSchema(pPattern As %String, pConfig As Config, pLogger As Logger, pQuiet As %Boolean, pNewSchemaName As %String = "") As RigSchema
{
	#Dim tSchema
	#Dim tLexer As Lexer
	#Dim tTopNode As Base
	
	Set tSchema=..ParseSchemaSpec(pPattern)
	If tSchema="" {$$$THROW("Common.MakeRigSchema: pattern does not parse as a schema - "_pPattern)}
	Set tSchemaName=$Select(pNewSchemaName="":pConfig.SchemaName(pPattern),1:pNewSchemaName)
	
	Set tLexer=##class(Lexer).%New(tSchema)
	Set tTopNode=##class(Parser).ParseSchema(tLexer)
	
	Set tRigSchema=##class(RigSchema).%New(tSchemaName,tSchema,tTopNode,pConfig,pLogger)
	Do tRigSchema.GenerateNFA(pQuiet)
	
	Quit tRigSchema
}

ClassMethod CompileSchema(pPattern As %String) As Base
{
	Set tLexer=##class(Lexer).%New(..AsCSF(pPattern))
	Return ##class(Parser).ParseSchema(tLexer)
}

/// Return number with enough leading zeroes to make the result fill the given width
ClassMethod LZ(pN As %Integer, pWidth As %Integer) As %String [ CodeMode = expression ]
{
$Select($Length(pN)<pWidth:$Extract(..#ZEROES,1,pWidth-$Length(pN))_pN,1:pN)
}

/// Return a raw hash corresponding to the input string
ClassMethod RawHash(pStr As %String) As %String [ CodeMode = expression ]
{
$System.Encryption.HMACMD5(pStr,"")
}

/// Return a hex string hash corresponding to the input string
ClassMethod Hash(pStr As %String) As %String [ CodeMode = expression ]
{
..ToHexString(..RawHash(pStr))
}

/// Given a string of bytes: return a string of 2-character hex numbers corresponding to the bytes
ClassMethod ToHexString(pChars As %String) As %String
{
	Set tResult=""
	For tI=1:1:$Length(pChars) {
		Set tResult=tResult_$ZHex($Ascii(pChars,tI))
	}
	
	Quit tResult
}

ClassMethod Throw(pMessage As %String)
{
	Throw ##class(%Exception.General).%New(pMessage)
}

ClassMethod ShowSortedDeriveResults(ByRef pDerivePatterns, pLogger As Logger, pWithHistory As %Boolean = 0, pShowRemainingResults As %Boolean = 0)
{
	If '$Data(pDerivePatterns) {
		Do pLogger.OutputToLog("No results from Derive")
	}
	Else {
	
		Do pLogger.OutputToLog("Best Derive Results:")
		Set tFirstKey=$Order(pDerivePatterns(""))
		For tI=1:1:pDerivePatterns(tFirstKey) {
			Set $ListBuild(tPattern,tHistory)=pDerivePatterns(tFirstKey,tI)
			Do pLogger.OutputToLog(" "_tPattern_" ["_$ListToString(..PatternScore(tPattern))_"]") // ignore history for now
			If pWithHistory {
				Set tPtrI=0 While $ListNext(tHistory,tPtrI,tElemI) {
					Do pLogger.OutputToLog("  : "_$ListToString(tElemI,": "))
				}
			}
		}				
		
		If pShowRemainingResults,$Order(pDerivePatterns(tFirstKey))'="" {
			Do pLogger.OutputToLog("Remaining Derive Results:")
			Set tKey=tFirstKey While 1 {
				Set tKey=$Order(pDerivePatterns(tKey)) If tKey="" {Quit}
				Do pLogger.OutputToLog(" "_tKey)
				For tI=1:1:pDerivePatterns(tKey) {
					Set $ListBuild(tPattern,tHistory)=pDerivePatterns(tKey,tI)
					Do pLogger.OutputToLog("  "_tPattern)
					If pWithHistory {
						Set tPtrI=0 While $ListNext(tHistory,tPtrI,tElemI) {
							Do pLogger.OutputToLog("  : "_$ListToString(tElemI,": "))
						}
					}
				}
			}
		}
	}
}

/// If pLookFor occurs in pStr: returns the offset in pStr of the start of the first occurrence of pLookFor which is at or after pStartFrom
/// <p> Otherwise: returns 0
ClassMethod IndexOf(pStr As %String, pLookFor As %String, pStartFrom As %Integer = 1) As %Integer
{
	Set tRawIndex=$Find(pStr,pLookFor,pStartFrom)
	Quit $Select(tRawIndex=0:0,1:tRawIndex-$Length(pLookFor))
}

ClassMethod PatternScore(pPattern As %String) As %List [ CodeMode = expression ]
{
$ListBuild(..TermCount(pPattern),..StructureCount(pPattern))
}

/// Given a pattern, return the number of message codes in it
/// <p> In the $Translate call: the list of commas must be the same length as the string which precedes it
ClassMethod TermCount(pPattern As %String) As %Integer [ CodeMode = expression ]
{
$ListLength(..SchemaTerms(pPattern))
}

/// Given a pattern, return a list of the message codes in it (in their original order)
/// <p> In the $Translate call: the list of commas must be the same length as the string which precedes it
ClassMethod SchemaTerms(pPattern As %String) As %List [ CodeMode = expression ]
{
$ListFromString($ZStrip($Translate(pPattern,"<|>{}[]",",,,,,,,"),"<=>P"))
}

ClassMethod StructureCount(pPattern As %String) As %Integer [ CodeMode = expression ]
{
$Length($ZStrip(pPattern,"*'P",",<>}]"))
}

ClassMethod AppConfiguration(pMessageSkipCount As %Integer) As %String
{
	Set tOut=""
	
	If pMessageSkipCount {
		Set tOut=tOut_$ListBuild("MESSAGESKIPCOUNT="_pMessageSkipCount)
	}
	
	If $$$ACDEBUGGING {
		Set tOut=tOut_$ListBuild("ACDEBUGGING=1")
	}

	If $$$BYPASSLOGGER {
		Set tOut=tOut_$ListBuild("BYPASSLOGGER=1")
	}
	
	Quit $ListToString(tOut)
}

/// Given a path, returns a stream reading the file at the path
/// <p> - throws an exception if the file does not exist
ClassMethod ReadFileStream(Path As %String) As %Stream.Object
{
	If '##class(%File).Exists(Path) || ##class(%File).DirectoryExists(Path) {$$$THROW("ReadFileStream: file does not exist (or is a directory) - "_Path)}
	
	Set stream=##class(%Stream.FileCharacter).%New()
	Set stream.Filename=Path
	
	Set probe=stream.Read(30000,.tSC) // assumes lines aren't longer than 30K
	If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
	Set lineterminator=$Select(probe[$Char(13,10):$Char(13,10),probe[$Char(13):$Char(13),1:$Char(10))
	$$$THROWONERROR(tSC,stream.Rewind())
	Set stream.LineTerminator=lineterminator
	
	Quit stream
}

ClassMethod WriteFileStream(Path As %String, LineTerminator As %String = "") As %Stream.Object
{
	Set stream=##class(%Stream.FileCharacter).%New("WSN") If '$IsObject(stream) {$$$ThrowStatus(%objlasterror)}
	
	Set %objlasterror=$$$OK
	Set stream.Filename=Path
	If $$$ISERR($Get(%objlasterror,$$$OK)) {
		$$$ThrowStatus(%objlasterror)
	}
	
	If LineTerminator'="" {
		Set stream.LineTerminator=LineTerminator
	}
	
	Quit stream
}

ClassMethod LastFolderSegment(pFolder As %String) As %String [ CodeMode = expression ]
{
##class(%File).GetDirectoryPiece(pFolder,##class(%File).GetDirectoryLength(pFolder))
}

ClassMethod StatusToErrorList(pSC As %Status, Output pErrorList)
{
	$$$SHOULDBEUNDEF(pErrorList)
	
	Set qstruct("displayerror")=0
	$$$THROWONERROR(tSC,$$DecomposeStatus^%occSystem(pSC,.pErrorList,.qstruct))
}

}

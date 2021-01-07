/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Workflow)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Input Extends %RegisteredObject
{

/// Given a prompt and an optional default
/// <p> Read a line of input from the user - defaulting to the default value if any - and return it 
ClassMethod Input(pPrompt As %String, pDefault As %String = "") As %String
{
	Write:$X !
	Write pPrompt
	
	If pDefault="" {
		Read ":",tInput,!
	}
	Else {
		Write " <",pDefault,"> "
		Read ":",tInput,!
		If tInput="" {
			Set tInput=pDefault
		}
	}
	
	Quit tInput
}

/// Returns one of "Y", "N" or "^"
ClassMethod InputYN(pPrompt As %String) As %String
{
	Write:$X !

	While 1 {
		Write pPrompt," (Y/N)"
		Read ":",tIn,!
		Set tUpperIn=$$$TOUP(tIn)
		If $Length(tUpperIn)=1,"YN^"[tUpperIn {Return tUpperIn}
		Write " - please enter Y, N or ^",!
	}
}

/// Input a logger destination from the user and return either a logger or "" - "" means caller should exit
ClassMethod MakeLogger() As Logger
{
	Set tPrompt="Log to folder (* => log to terminal)"
	Set tHistoryKey="LOGFOLDER"
	
	While 1 {
	
		Set tLogFolder=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tLogFolder="^" {
			Return ""
		}
		
		If tLogFolder'="" {
		
			If tLogFolder="*" {
				Set $$$WFHISTORYITEMREF(tHistoryKey)=tLogFolder
				Return ##class(Logger).%New()
			}
			
			If ##class(%File).DirectoryExists(tLogFolder) {
				Set tI=3
				Do {
					Set tLogFileName="HL7MALOG-"_$$timestamp_".log"
					Set tLogFilePath=##class(%File).NormalizeFilename(tLogFileName,tLogFolder)
					Set tI=tI-1 If 'tI {$$$THROW("Workspace: log timestamp failure")}
				} While ##class(%File).Exists(tLogFilePath)
				Write "- logging to ",tLogFilePath,!
				Set tLogStream=##class(Common).WriteFileStream(tLogFilePath,$Char(10))
				Set $$$WFHISTORYITEMREF(tHistoryKey)=tLogFolder
				Return ##class(Logger).%New(tLogStream,1)
			}
			
			Write " - please enter an existing folder",!
		}
		
		Else {
			Write "Enter ^ to exit",!!
		}
	}
	
timestamp()
	Set now=$H
	Quit $ZDate(now,8)_"-"_$ZStrip($ZTIME($P(now,",",2)),"*",":")
}

/// Input and validate workspace folder
/// <p> Return either $LB(WORKSPACEFOLDER,EXISTS) or "" if cancelled
ClassMethod WorkspaceFolder(pHistoryKey As %String) As %String
{
	Set tPrompt="Workspace folder"
	
	While 1 {
	
		Set tWorkspaceFolder=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(pHistoryKey)))
		If tWorkspaceFolder="^" {
			Return ""
		}
		
		If tWorkspaceFolder'="" {
		
			Set tRet=##class(Workspace).WorkspaceExists(tWorkspaceFolder)
			
			// does not exist ..
			If tRet="" {
			
				// only set the history if it's Workflow/1 (for compatibility)
				If pHistoryKey="WORKSPACE" {
					Set $$$WFHISTORYITEMREF(pHistoryKey)=tWorkspaceFolder
				}
				Return $ListBuild(tWorkspaceFolder,0)
			}
			
			// exists as a valid workspace ..
			If $Length(tRet) = 1 {			
				Set $$$WFHISTORYITEMREF(pHistoryKey)=tWorkspaceFolder
				Return $ListBuild(tWorkspaceFolder,1)			
			}
			
			// error message ..
			Write tRet,!
		}
		
		Else {
			Write "Enter ^ to exit",!!
		}
	}
}

/// Input and validate source path
/// <p> Return either source path or "" if cancelled
ClassMethod SourcePath() As %String
{
	Set tPrompt="Source file or folder"
	Set tHistoryKey="SOURCEPATH"
	
	While 1 {
	
		Set tSourcePath=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tSourcePath="^" {
			Return ""
		}
		
		If tSourcePath'="" {
			If ##class(%File).Exists(tSourcePath) {
				Set $$$WFHISTORYITEMREF(tHistoryKey)=tSourcePath
				Return tSourcePath
			}
			
			Write " - please enter an existing file or folder",!
		}
		
		Else {
			Write "Enter ^ to exit",!!
		}		
	}
}

/// Input and validate the name of a non-library schema, with an optional version prefix
/// <p> Return either schema name or "" if cancelled
/// <p> If a schema with a version is entered then pAcceptableVersions is not changed, otherwise pAcceptableVersions(VERSION) exists for each version which has a schema of the entered name
ClassMethod SchemaName(pGlobalInfo As GlobalInfo, Output pAcceptableVersions) As %String
{
	$$$SHOULDBEUNDEF(pAcceptableVersions)
	
	Set tPrompt="Existing document structure name (optionally with a schema prefix)"
	Set tHistoryKey="SCHEMANAME"
	
	While 1 {
	
		Set tSchemaSpec=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tSchemaSpec="^" {
			Return ""
		}
		
		If tSchemaSpec'="" {
		
			If tSchemaSpec[":" {

				Set tVersion=$Piece(tSchemaSpec,":"),tSchemaName=$Piece(tSchemaSpec,":",2)
				If tVersion'="",tSchemaName'="" {
					If $Data($$$vaSchemaGbl(tVersion,"MS",tSchemaName)) {
					
						If '##class(SchemaAccess).CanWriteToSchema(pGlobalInfo,tVersion) {
							Write "This document structure is in a system library database and cannot be written to.",!
							// fall through
						}
						Else {						
							Set $$$WFHISTORYITEMREF(tHistoryKey)=tSchemaSpec
							Return tSchemaSpec
						}
					}
				}
				
				// fall through
			}
			
			Else {
			
				Kill tLibraryVersions
				Set tVersion="" While 1 {
					Set tVersion=$Order($$$vaSchemaGbl(tVersion)) If tVersion="" {Quit}
					If $Data($$$vaSchemaGbl(tVersion,"MS",tSchemaSpec)) {
						If '##class(SchemaAccess).CanWriteToSchema(pGlobalInfo,tVersion) {
							Set tLibraryVersions(tVersion)=""
						}
						Else {
							Set pAcceptableVersions(tVersion)=""
						}
					}
				}
				
				// if we found any acceptable versions ..
				If $Data(pAcceptableVersions)\10 {
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tSchemaSpec
					Return tSchemaSpec
				}
				
				// if we found any library versions ..
				If $Data(tLibraryVersions) {
					Write "This document structure only occurs in library schemas, which cannot be changed.",!
				}
				
				// fall through
			}
			
			Write " - please enter the name of a non-library document structure which is in the database",!
		}
						
		Else {
			Write "Enter ^ to exit",!!
		}
	}
}

/// Input and validate the name of a non-library schema which must be present in pVersion
/// <p> Return either schema name or "" if cancelled
ClassMethod SchemaName2(pVersion As %String) As %String
{
	Set tPrompt="Existing document structure name, or a new one to be copied from another schema"
	Set tHistoryKey="SCHEMANAME2"
	
	Write "Enter the start of a document structure name followed by a '?' to list matching document structures",!
	
	While 1 {
	
		Write !
		Set tSchemaSpec=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tSchemaSpec="^" {
			Return ""
		}
		
		If tSchemaSpec'="" {
		
			If $Extract(tSchemaSpec,*)="?" {
				Do ..ListSchemasStartingWith(pVersion,$$$TRIM($Extract(tSchemaSpec,1,*-1)))
			}
			
			Else {
		
				If $Data($$$vaSchemaGbl(pVersion,"MS",tSchemaSpec)) {
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tSchemaSpec
					Return tSchemaSpec
				}
				
				Write "Schema ",pVersion," does not have document structure ",tSchemaSpec,!
						
				Set tBaseVersion=##class(PathUpdater).BaseVersion(pVersion) // may be returned as "", in which case there's no default offered below
				
				If tBaseVersion'="",'$Data($$$vaSchemaGbl(tBaseVersion,"MS",tSchemaSpec)) {
					Write "Document structure ",tSchemaSpec," does not exist in the base schema of ",pVersion," (",tBaseVersion,")",!
					Set tBaseVersion="" // no default offered below
				}
				
				While 1 {
					Set tCopyFromVersion=..Input(" Enter a schema to copy document structure "_tSchemaSpec_" from",tBaseVersion)
					If tCopyFromVersion="^" {Quit}
					If tCopyFromVersion'="",$Data($$$vaSchemaGbl(tCopyFromVersion,"MS",tSchemaSpec)) {Quit}
					Write " - enter a schema in which document structure ",tSchemaSpec," exists, or ^ to cancel",!
				}
				
				If tCopyFromVersion'="^" {
					Do ##class(PathUpdater).CopyFrom(tCopyFromVersion,pVersion,"MS",tSchemaSpec,0)
					Write " - copied document structure ",tCopyFromVersion,":",tSchemaSpec," to ",pVersion,!
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tSchemaSpec
					Return tSchemaSpec				
				}
			}
		}
						
		Else {
			Write "Enter ^ to exit",!!
		}
	}
}

/// Input and validate version
/// <p> Return either version or "" if cancelled
/// <p> If pSchemaName is passed and non-empty it is used to limit the list of existing HL7 versions to those in pAcceptableVersions 
ClassMethod Version(pGlobalInfo As GlobalInfo, pSchemaName As %String = "", ByRef pAcceptableVersions) As %String
{
	$$$ACASSERT((pSchemaName="") || ($Data(pAcceptableVersions)\10),"Input.Version: document structure name not empty but no acceptable schemas passed")
	
	Set tPrompt="Schema"
	Set tHistoryKey="HL7VERSION"
	
	// -
	
	Set tHistoryDefault=$Get($$$WFHISTORYITEMREF(tHistoryKey))
	Set tSeenHistoryDefault=0
	
	If pSchemaName="" {
	
		Write "Existing non-library schemas:"
		Set tAny=0
		Set tHL7Version="" While 1 {
			Set tHL7Version=$Order($$$vaSchemaGbl(tHL7Version)) If tHL7Version="" {Quit}
			If $Data($$$vaSchemaGbl(tHL7Version,"MS"))\10, ##class(SchemaAccess).CanWriteToSchema(pGlobalInfo,tHL7Version) {
				Write " ",tHL7Version
				Set tAny=1
				If tHL7Version=tHistoryDefault {
					Set tSeenHistoryDefault=1
				}
			}
		}
		
		If 'tAny {
			Write "NONE!"
		}
	}
	
	Else {

		Write "Existing non-library schemas which have document structure "_pSchemaName_":"
		Set tHL7Version="" While 1 {
			Set tHL7Version=$Order(pAcceptableVersions(tHL7Version)) If tHL7Version="" {Quit}
			Write " ",tHL7Version
			If tHL7Version=tHistoryDefault {
				Set tSeenHistoryDefault=1
			}
		}
	}

	Write !
	
	// clear the history default if it's currently set and was not found in the listed versions
	If tHistoryDefault'="",'tSeenHistoryDefault {
		Set $$$WFHISTORYITEMREF(tHistoryKey)=""
	}
	
	// -
	
	While 1 {
	
		Set tVersion=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tVersion="^" {
			Return ""
		}
		
		If tVersion'="" {
		
			If '##class(SchemaAccess).CanWriteToSchema(pGlobalInfo,tVersion) {
				Write "This schema is in a system library database and cannot be written to.",!
			}
			
			ElseIf pSchemaName="" {
			
				If $Data($$$vaSchemaGbl(tVersion)) {
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tVersion
					Return tVersion
				}				
			
				Write " - please enter a non-library schema which is in the database",!
			}
			
			Else {
			
				If $Data(pAcceptableVersions(tVersion)) {
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tVersion
					Return tVersion
				}				

				Write " - please enter a non-library schema which has document structure ",pSchemaName,!
			}
		}
						
		Else {
			Write "Enter ^ to exit",!!
		}
	}
}

/// Input and validate version
/// <p> Return either version or "" if cancelled
ClassMethod Version2(pGlobalInfo As GlobalInfo, pMustHaveSchemas As %Boolean) As %String
{
	Set tPrompt="Schema"
	Set tHistoryKey="HL7VERSION"
	
	// -
	
	Set tHistoryDefault=$Get($$$WFHISTORYITEMREF(tHistoryKey))
	Set tSeenHistoryDefault=0
	
	Write "Existing non-library schemas:"
	Set tAny=0
	Set tHL7Version="" While 1 {
		Set tHL7Version=$Order($$$vaSchemaGbl(tHL7Version)) If tHL7Version="" {Quit}
		If $Data($$$vaSchemaGbl(tHL7Version,"MS"))\10, ##class(SchemaAccess).CanWriteToSchema(pGlobalInfo,tHL7Version) {
			Write " ",tHL7Version
			Set tAny=1
			If tHL7Version=tHistoryDefault {
				Set tSeenHistoryDefault=1
			}
		}
	}
	
	If 'tAny {
		Write "(none)"
	}

	Write !
	
	// clear the history default if it's currently set and was not found in the listed versions
	If tHistoryDefault'="",'tSeenHistoryDefault {
		Set $$$WFHISTORYITEMREF(tHistoryKey)=""
	}
	
	// -

	If tAny {
		Write "Enter one of the above schemas or a new one to create it",!
	}
	Else {
		Write "Enter the name of a new custom schema to create it",!
	}
	
	While 1 {
	
		Write !
		
		Set tVersion=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tVersion="^" {
			Return ""
		}
		
		// if they entered a version ..
		If tVersion'="" {
		
			// if it's a library version ..
			If '##class(SchemaAccess).CanWriteToSchema(pGlobalInfo,tVersion) {
			
				Write "Schema ",tVersion," is a library schema",!
				Write "You can create a custom schema based on it",!
				
				Set tCustomVersion=..Version2MakeCustomFromLibrary(tVersion)
				If tCustomVersion'="" {
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tCustomVersion
					Return tCustomVersion
				}
				
				//  .. go around the While loop again ..
			}
			
			// .. not a library version ..
			Else {
			
				// if it must have document structures, and it doesn't ..
				If pMustHaveSchemas, ($Data($$$vaSchemaGbl(tVersion,"MS"))\10)=0 {
					Write "This schema has no document structures defined",!
					
					//  .. go around the While loop again ..
				}
				
				// .. if it exists ..
				ElseIf $Data($$$vaSchemaGbl(tVersion)) {
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tVersion
					Return tVersion
				}
						
				// - version does not already exist -
				
				Write "Schema ",tVersion," does not currently exist in the database",!
				Write "You can create it as a custom schema",!
				
				Set tCustomVersion=..Version2MakeCustom(tVersion)
				If tCustomVersion'="" {
					Set $$$WFHISTORYITEMREF(tHistoryKey)=tCustomVersion
					Return tCustomVersion
				}
				
				//  .. go around the While loop again ..
			}
		}
					
		// .. didn't enter a version ..	
		Else {
			Write "Enter ^ to exit",!!
		}
	}
}

/// Input and validate groupby
/// <p> Return either groupby or "" if cancelled
ClassMethod GroupBy() As %String
{
	Set tPrompt="Group messages by"
	Set tHistoryKey="GROUPBY"
	
	While 1 {
	
		Set tGroupBy=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tGroupBy="^" {
			Return ""
		}
		
		If tGroupBy'="" {
		
			If ##class(KeySpec).IsValidShortNameList(tGroupBy) {
				Set $$$WFHISTORYITEMREF(tHistoryKey)=tGroupBy
				Return tGroupBy
			}
			
			Write " - please enter ",##class(KeySpec).ShortNames(),", or a list of them",!
		}
						
		Else {
			Write "Enter ^ to exit",!!
		}
	}
}

ClassMethod ExportFile() As %String
{
	Set tPrompt="Export to file"
	Set tHistoryKey="EXPORTFILE"
	
	While 1 {
		
		Set tExportFile=..Input(tPrompt,$Get($$$WFHISTORYITEMREF(tHistoryKey)))
		If tExportFile="^" {
			Return ""
		}
		
		If $$validate(tExportFile) {
			Set $$$WFHISTORYITEMREF(tHistoryKey)=tExportFile
			Return tExportFile
		}
	}
	
	ZTrap  // the loop should never exit except by returning
	
validate(in)

	If in'="" {
	
		Set filename=##class(%File).GetFilename(tExportFile)
		If (filename'[".") || ($Piece(filename,".",*)?1.N) {
			Set tExportFile=tExportFile_".HL7"
		}
		
		Quit 1
	}
		
	Else {
		Write "Enter ^ to exit",!!
		Quit 0
	}
}

/// Input and validate a date
/// <p> Return either the date in $H days form - or "" if cancelled
ClassMethod Date(pPrefix As %String) As %String
{
	Set $ListBuild(tDateHelp,tDateDelimiter,tDatePieceNo)=..DateFormatInfo()
	
	Set tPrompt="Enter a "_pPrefix_" date"_tDateHelp_", or T for Today"
	
	While 1 {
	
		Set tRawDate=..Input(tPrompt)
		If tRawDate="^" {
			Return ""
		}
		
		If tRawDate'="" {
		
			// T -> today
			If $$$TOUP(tRawDate)="T" {			
				Return $Piece($Horolog,",")
			}
			
			// convert a 2-digit year to a 4-digit year
			If tDateDelimiter'="",$Length($Piece(tRawDate,tDateDelimiter,tDatePieceNo))=2 {
				Set tCenturyDigits=$Extract($ZDate($H,8),1,2)
				Set $Piece(tRawDate,tDateDelimiter,tDatePieceNo)=tCenturyDigits_$Piece(tRawDate,tDateDelimiter,tDatePieceNo)
			}
			
			Set tHorologDays=$ZDateH(tRawDate,,,,,,,,"")
			If tHorologDays'="" {
				Return tHorologDays
			}
			
			Write " - please enter a date",!
		}
		
		Else {
			Write "Enter ^ to exit",!!
		}		
	}
}

/// Returns 0 if cancelled
ClassMethod SchemaNewNames(ByRef pByFacility, pVersion As %String, Output pNewNames) As %Boolean
{
	$$$SHOULDBEUNDEF(pNewNames)
	
	Do {
	
		Write !,"Name document structures for export, enter ^ to cancel the export",!
		Set tParentFolder="" While 1 {
			Set tParentFolder=$Order(pByFacility(tParentFolder)) If tParentFolder="" {Quit}			
			Set tKey="" While 1 {
				Set tKey=$Order(pByFacility(tParentFolder,tKey)) If tKey="" {Quit}
				Set tIn=..InputSchemaName(tParentFolder,tKey,$Get(pNewNames(tKey)),pVersion)
				If tIn="" {Return 0}
				Set pNewNames(tKey)=tIn
			}
		}
		
		Do showassignments
		
		If $$anydupes {
			Write !,"Each new name can only be used once, please correct these assignments",!
			Set tOK=0
		}
		Else {		
			Set tIn=..InputYN("Are you happy with these assignments?")
			If tIn="^" {Return 0}
			Set tOK=(tIn="Y")
		}
	} While 'tOK
	
	$$$ACASSERT($$samecount,"SchemaNewNames: not all assigned")
	
	Quit 1
	
showassignments()
	Write !,"Current assignments of document structure names",!
	Set name="" While 1 {
		Set name=$Order(pNewNames(name),+1,newname) If name="" {Quit}
		Write " ",name," --> ",newname,!
	}
	Quit
	
anydupes()
	Kill names
	Set n="" While 1 {
		Set n=$Order(pNewNames(n),+1,newname) If n="" {Quit}
		If $Data(names(newname)) {Return 1}
		Set names(newname)=""
	}
	Quit 0
	
samecount()
	
	Set oldcount=0
	Set parentfolder="" While 1 {
		Set parentfolder=$Order(pByFacility(parentfolder)) If parentfolder="" {Quit}			
		Set key="" While 1 {
			Set key=$Order(pByFacility(parentfolder,key)) If key="" {Quit}
			Set oldcount=oldcount+1
		}
	}	
	
	Set newcount=0
	Set name="" While 1 {
		Set name=$Order(pNewNames(name)) If name="" {Quit}
		Set newcount=newcount+1
	}
	
	Quit oldcount=newcount
}

/// Given a library schema
/// <p> Prompt for custom schema, create custom schema (based on library schema) and return it
/// <p> - return "" if user enters "^"
ClassMethod Version2MakeCustomFromLibrary(pLibrarySchemaVersion As %String) [ Private ]
{
	Write !," Enter the name of a new custom schema to be based on ",pLibrarySchemaVersion,!
	
	While 1 {
		Write !
		Set tCustomVersion=..Input(" New custom schema","")
		If tCustomVersion="^" {Return ""}
		If tCustomVersion'="" {
			If '$Data($$$vaSchemaGbl(tCustomVersion)) {Quit}
			Write " Schema ",tCustomVersion," already exists",!
		}
		Write " - enter a new schema name, or ^ to cancel",!
	}
	
	Do ##class(PathUpdater).MakeCustomVersion(tCustomVersion,pLibrarySchemaVersion)
	Write " - created custom schema ",tCustomVersion," based on ",pLibrarySchemaVersion,!
	Quit tCustomVersion
}

/// Given a new custom schema name
/// <p> Prompt for library schema, create custom schema (based on library schema) and return it
/// <p> - return "" if user enters "^"
ClassMethod Version2MakeCustom(pCustomSchemaVersion As %String) [ Private ]
{
	Write !," Enter the name of a schema to base ",pCustomSchemaVersion," on",!
	
	While 1 {
		Write !
		Set tBaseVersion=..Input(" Existing schema","")
		If tBaseVersion="^" {Return ""}
		If tBaseVersion'="" {
			If $Data($$$vaSchemaGbl(tBaseVersion)) {Quit}
			Write " Schema ",tBaseVersion," does not exist in the database",!
		}
		Write " - enter an existing schema, or ^ to cancel",!
	}
	
	Do ##class(PathUpdater).MakeCustomVersion(pCustomSchemaVersion,tBaseVersion)
	Write " - created custom schema ",pCustomSchemaVersion," based on ",tBaseVersion,!
	Quit pCustomSchemaVersion
}

ClassMethod InputSchemaName(pParentFolder As %String, pGeneratedSchemaName As %String, pDefaultNewName As %String, pVersion As %String) As %String [ Private ]
{
	Write !,"Enter new name for document structure '"_pGeneratedSchemaName_"' ("_##class(Common).LastFolderSegment(pParentFolder)_")",!
	
	Set tPrompt="New name"
	
	While 1 {
		
		Set tNewName=..Input(tPrompt,pDefaultNewName)
		If tNewName="^" {
			Return ""
		}
		
		If $$validate(tNewName) {
		
			If $Data($$$vaSchemaGbl(pVersion,"MS",tNewName)) {
				Write "WARNING: this will overwrite an existing document structure named '",tNewName,"'",!!
			}
			Return tNewName
		}
	}
	
	ZTrap  // the loop should never exit except by returning
	
validate(in)
	
	If in'="" {
		
		If ##class(FolderType).IsGeneratedSchemaName(in) {
			Write " - that name matches the generated document structure name format, please choose another",!
			Write "   (",##class(FolderType).GeneratedSchemaNameRules(),")",!
			Quit 0
		}
		
		Quit 1
	}
		
	Else {
		Write "Enter ^ to exit",!!
		Quit 0
	}
}

ClassMethod DateFormatInfo() As %String [ Private ]
{
	// American format
	If $ZDateH("1/31/2019",,,,,,,,"")'="" {
		Quit $ListBuild(" in MM/DD/YY format","/",3)
	}

	// European format
	If $ZDateH("31/1/2019",,,,,,,,"")'="" {
		Quit $ListBuild(" in DD/MM/YY format","/",3)
	}

	// European format (Russia, Ukraine, Czech)
	If $ZDateH("31.1.2019",,,,,,,,"")'="" {
		Quit $ListBuild(" in DD.MM.YY format",".",3)
	}

	// ???
	Quit $ListBuild(" in your local short-date format, using 2-digits for day, month and year","","")
}

ClassMethod ListSchemasStartingWith(pVersion As %String, pSchemaNamePrefix As %String) [ Private ]
{
	Set tLSchemaNamePrefix=$Length(pSchemaNamePrefix)
	
	Set tOut=""
	If pSchemaNamePrefix="" {
		Set tKey=""
		While 1 {
			Set tKey=$Order($$$vaSchemaGbl(pVersion,"MS",tKey)) If tKey="" {Quit}
			Set tOut=tOut_$ListBuild(tKey)
		}
	}
	Else {
		Set tKey=$Order($$$vaSchemaGbl(pVersion,"MS",pSchemaNamePrefix),-1)
		While 1 {
			Set tKey=$Order($$$vaSchemaGbl(pVersion,"MS",tKey)) If tKey="" {Quit}
			If $Extract(tKey,1,tLSchemaNamePrefix)'=pSchemaNamePrefix {Quit}
			Set tOut=tOut_$ListBuild(tKey)
		}
	}
	
	If tOut="" {
		Write "There are no document structures whose name begins with '",pSchemaNamePrefix,"' in schema '",pVersion,"'",!
	}
	Else {
		Write "Document structures whose name begins with '",pSchemaNamePrefix,"' in schema '",pVersion,"':",!
		Write " ",$ListToString(tOut," "),!
	}
}

}

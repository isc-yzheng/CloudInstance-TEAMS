ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.Workflow [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils


#; Workflow root: ^("WORKFLOW")
#define WFROOT $$$MAGLOBAL("WORKFLOW"
#define WFROOTREF $$$WFROOT)

#; Workflow settings and arguments history
#define WFHISTORY $$$WFROOT,"HISTORY"
#define WFHISTORYREF $$$WFHISTORY)

#; Specific workflow history entries
#define WFHISTORYITEM(%item) $$$WFHISTORY,%item
#define WFHISTORYITEMREF(%item) $$$WFHISTORYITEM(%item))

#; Workflow debugging options
#define WFOPTIONS $$$WFROOT,"OPTIONS"
#define WFOPTIONSREF $$$WFOPTIONS)

#; Specific workflow debugging options
#define WFOPTIONSITEM(%item) $$$WFOPTIONS,%item
#define WFOPTIONSITEMREF(%item) $$$WFOPTIONSITEM(%item))

#; Workflow previous validation stats (vstats)
#define WFPREVVSTATSREF $$$WFROOT,"PREVVSTATS")


#; Menu presentation style: 0 or missing => [] menus, 1 => original style menus
#define WFOLDMENUS $Get($$$WFROOT,"OLDMENUS"))


#; Workflow/2 top-level menu
#define MIWF2TOPSCHEMADERIVATION(%tag) $ListBuild(%tag,"Derive new document structures","DS")
#define MIWF2TOPVALIDATION(%tag) $ListBuild(%tag,"Validate messages, optionally fixing the configuration","VM") 
#define MIWF2TOPHISTORY(%tag) $ListBuild(%tag,"View history of fixes to the configuration (validation fixes only)","HF") 
#define MIWF2TOPSETUPWS(%tag) $ListBuild(%tag,"Setup Workspace","SW") 
#define MENUWF2TOP(%tag1,%tag2,%tag3,%tag4) ##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.StaticMenu).%New($ListBuild("Workflow/2 Main Menu"),$ListBuild($$$MIWF2TOPSCHEMADERIVATION(%tag1),$$$MIWF2TOPVALIDATION(%tag2),$$$MIWF2TOPHISTORY(%tag3),$$$MIWF2TOPSETUPWS(%tag4)))
#; - for some reason we need StaticMenu to be fully qualified here

#; Workflow/2 history top-level menu
#define MIWF2HISTORYTOPALL(%tag) $ListBuild(%tag,"List all changes","LA")
#define MIWF2HISTORYTOPTODAY(%tag) $ListBuild(%tag,"List changes made today","LT")
#define MIWF2HISTORYTOPRANGE(%tag) $ListBuild(%tag,"List changes for a range of dates","LR")
#define MENUWF2HISTORYTOP(%tag1,%tag2,%tag3) ##class(StaticMenu).%New($ListBuild("Workflow/2 History of Configuration Changes"),$ListBuild($$$MIWF2HISTORYTOPALL(%tag1),$$$MIWF2HISTORYTOPTODAY(%tag2),$$$MIWF2HISTORYTOPRANGE(%tag3)))
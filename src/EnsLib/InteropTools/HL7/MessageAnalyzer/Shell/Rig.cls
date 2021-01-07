/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.Rig Extends %RegisteredObject
{

ClassMethod Run(Startup As %List = "")
{
	#Dim tI,line,in
	#Dim rig As Rig
	
	Write !,"HL7 Schema Rig",!!
	
	$$$SETMAXSTORE
	
	// remove sessions more than two days old
	Do ##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor.Session).Cleanup()
	
	Set rig=##class(RigImpl).%New()	
	
	Write "Enter .? at the 'schema>' prompt for help on shell commands",!
	
	// startup script
	If Startup'="" {
		Write "Running startup script",!!
		Set next=Startup
		While next'="" {
			Set this=next,next=""
			Set tPtrI=0 While $ListNext(this,tPtrI,tElemI) {
				Write "> ",tElemI,!
				Set next=next_rig.ProcessInput(tElemI)
			}
		}
	}
	
	Do rig.ShowSettings()
	
	// app config
	Set tAppConfig=##class(Common).AppConfiguration(+rig.GetConfigOption("MESSAGESKIPCOUNT"))
	If tAppConfig'="" {
		Write !,"App Configuration: ",tAppConfig,!
	}
	
	// for control failure reporting
	Set %MARESCOUNT=0
	
	// create and report on a new session
	Set $$$MAS=##class(Session).%New()
	Write !,"Session id is #",$$$MAS.SessionId,!
	
	// main loop
	While 1 {
		
		Write !
		Do ..PrePrompt(rig)
		Read "schema> ",in,!
		Set uin=$$$TOUP(in)
		If (uin="^") || (uin="EXIT") || (uin="QUIT") || (uin="Q") {Quit}		
		Set hadsemi=(in[";")
		While in'="" {
			Set part=$Piece(in,";"),in=$Piece(in,";",2,*)
			If $$$TRIM(part)'="" {
				If hadsemi {
					Write "> ",part,!
				}
				Set inputs=rig.ProcessInput(part)
				If inputs'="" {
					Set in=$ListToString(inputs,";")_";"_in
					Set hadsemi=1
				}
			}
		}
	}
}

ClassMethod PrePrompt(rig) As %String [ Private ]
{
	Set msc=+rig.GetConfigOption("MESSAGESKIPCOUNT")
	If msc {
		Write "MESSAGESKIPCOUNT=",msc,!
	}
}

}

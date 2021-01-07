/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.ValidationMenu Extends MenuBase
{

Property Instance As SegmentValidationBase [ Private ];

Property HL7Configuration As HL7Configuration [ Private ];

Method %OnNew(pInstance As SegmentValidationBase, pHL7Configuration As HL7Configuration) As %Status
{
	Set ..Instance=pInstance
	Set ..HL7Configuration=pHL7Configuration
	Quit $$$OK
}

Method Title() As %List [ CodeMode = expression ]
{
$ListBuild(..Instance.FixPrompt(..HL7Configuration))
}

Method MenuOptions() As %List
{
	Quit $ListBuild(
		$ListBuild("CONFIRM","Confirm this fix","Y"),
		$ListBuild("SKIP","Skip this fix","N")
		)
}

}

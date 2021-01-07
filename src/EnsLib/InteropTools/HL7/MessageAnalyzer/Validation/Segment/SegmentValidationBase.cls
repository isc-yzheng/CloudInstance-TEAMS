/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.HL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.SegmentValidationBase Extends %RegisteredObject [ Abstract ]
{

Property ChangeKey As %List [ Private ];

Property CleanedStatusMessage As %String [ Private ];

/// HL7MessagesSeen(MESSAGEINDEX)=""
Property HL7MessagesSeen As %String [ MultiDimensional, Private ];

/// Used differently by different subclasses - an example is the maximum field length seen across all relevant messages
Property MessageSummary As %String [ Private ];

Method AddMessage(pArgs As %List, pHL7Message As Message, pMessageIndex As %Integer) [ Final ]
{
	Set ..HL7MessagesSeen(pMessageIndex)="" // despite appearances the key is just a string
	Do ..AddMessageImpl(pArgs,pHL7Message)
}

Method HL7MessageCount() As %Integer [ Final ]
{
	Set tCount=0
	Set tKey="" While 1 {
		Set tKey=$Order(..HL7MessagesSeen(tKey)) If tKey="" {Quit}
		Set tCount=tCount+1
	}
	
	Quit tCount
}

/// Add an HL7 message with a validation problem to this object
Method AddMessageImpl(pArgs As %List, pHL7Message As Message) [ Abstract ]
{
}

/// Return a $List of text lines to be presented to the user before prompting them for action
Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List [ Abstract ]
{
}

/// Return a prompt describing the proposed fix
Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ Abstract ]
{
}

/// Return $ListBuild(CATEGORY,SUBCATEGORY) where CATEGORY is "CT"/"DT"/"SS" and SUBCATEGORY is the codetable etc.
Method GetFixTarget() As %List [ Abstract ]
{
}

/// Fix the HL7 configuration (custom)
Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String) As %String [ Abstract ]
{
}

/// Fix the HL7 configuration (library + custom)
Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger) [ Abstract ]
{
}

Method DecoratedCleanedStatusMessage() [ CodeMode = expression ]
{
"Status message: """_..CleanedStatusMessage_""""
}

}

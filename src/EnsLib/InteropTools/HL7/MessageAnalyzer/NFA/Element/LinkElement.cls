/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.LinkElement Extends ElementBase
{

/// virtual default
Method CanRemove(pMachine As Machine) As %Boolean [ CodeMode = expression ]
{
1
}

/// Does NOT advance the lexer - just returns the success link
Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	Quit $ListBuild(1,..SuccNext)
}

Method DigraphColor() As %String [ CodeMode = expression ]
{
"black"
}

}

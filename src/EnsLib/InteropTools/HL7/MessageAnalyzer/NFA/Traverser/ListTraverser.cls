/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser.ListTraverser Extends BaseTraverser
{

Method Seen(pElement As ElementBase)
{
	Write " ",pElement.ElementName," succ:",##class(%XSQL.Format).ListFormat(pElement.GetSucc())," fail:",##class(%XSQL.Format).ListFormat(pElement.GetFail()),!
}

Method Unseen(pUnseenNames As %List)
{
	Write "Not reachable from start element: ",##class(%XSQL.Format).ListFormat(pUnseenNames),!
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lines.BaseJudge Extends %RegisteredObject
{

/// Returns one of:
/// <ul>
///  <li> "" => failed to derive a pattern
///  <li> not "" => pattern rating - earliest collation is best - pattern length is a reasonable choice for rating
Method RateLinesSymbols(pCandidate As LinesSymbols, Output pPattern As %String) As %CacheString [ Abstract ]
{
}

}

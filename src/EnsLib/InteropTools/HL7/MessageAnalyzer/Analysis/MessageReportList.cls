/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.MessageReportList Extends %RegisteredObject
{

Property MessageReports As list Of MessageReport [ Private ];

Method AddMessageReport(pMessageReport As MessageReport)
{
	Do ..MessageReports.Insert(pMessageReport)
}

Method Count() [ CodeMode = expression ]
{
..MessageReports.Count()
}

Method GetAt(pIndex As %Integer) [ CodeMode = expression ]
{
..MessageReports.GetAt(pIndex)
}

}

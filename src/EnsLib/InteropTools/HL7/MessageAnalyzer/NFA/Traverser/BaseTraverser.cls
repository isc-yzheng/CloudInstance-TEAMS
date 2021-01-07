/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser.BaseTraverser Extends %RegisteredObject
{

Property Machine As Machine [ Private ];

Method %OnNew(pMachine As Machine) As %Status
{
	Set ..Machine=pMachine
	Quit $$$OK
}

Method Seen(pElement As ElementBase) [ Abstract ]
{
}

Method Unseen(pUnseenNames As %List) [ Abstract ]
{
}

/// virtual default
Method Finalize()
{
	//
}

}

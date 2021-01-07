/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser.ClosureTraverser Extends BaseTraverser
{

Property ClosureMachine As Machine [ InitialExpression = {##class(Machine).%New()}, Private ];

Method Seen(pElement As ElementBase)
{
	Do ..ClosureMachine.SetAt(pElement,pElement.ElementName)
}

Method Unseen(pUnseenNames As %List)
{
	// not of interest
}

Method GetElements(Output pMachine As Machine)
{
	Set pMachine=..ClosureMachine
}

}

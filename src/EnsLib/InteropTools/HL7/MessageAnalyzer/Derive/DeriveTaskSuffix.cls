/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.DeriveTaskSuffix [ Abstract ]
{

ClassMethod StepImpl(pIndex As %Integer, pTree As Tree, pType As %String, pAnySpecial As %Boolean, ByRef pItems, pConfig As Config, pLogger As Logger) As Tree [ CodeMode = expression ]
{
##class(DeriveTaskFix).StepImpl(..%ClassName(0),pIndex,pTree,pType,pAnySpecial,.pItems,pConfig,pLogger)
}

}

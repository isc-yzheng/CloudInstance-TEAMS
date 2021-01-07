/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.CodeBuilder

Class EnsLib.InteropTools.HL7.eGate Extends (EnsLib.InteropTools.HL7.eGate.Parser, EnsLib.InteropTools.HL7.Common)
{

/// When set to 0 CopyStrip becomes Copy
Parameter COPYSTRIP = 1;

Parameter FUNCTIONSET = "##class(EnsLib.InteropTools.HL7.eGate.Functions).";

Parameter CLASSNAMEPREFIXTSC = "User.Test.Transform.";

Parameter CLASSNAMEPREFIXISC = "User.Test.Rules.";

Property Delimiters As %String;

Parameter SCRIPTTOXMLCD = "cd /InterSystems/Migration/Monk/";

Parameter SCRIPTTOXML = "MonkToXML";

}

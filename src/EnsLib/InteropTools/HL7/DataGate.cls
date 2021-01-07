/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.CodeBuilder

Class EnsLib.InteropTools.HL7.DataGate Extends EnsLib.InteropTools.HL7.DataGate.Parser
{

/// When set to 0 CopyStrip becomes Copy 
Parameter COPYSTRIP = 1;

Parameter FUNCTIONSET = "##class(EnsLib.InteropTools.HL7.DataGate.Functions).";

Parameter CLASSNAMEPREFIXTSC;

Parameter CLASSNAMEPREFIXISC;

Property InDefine As %Boolean;

Property Delimiters As %String;

Property Structure As %String [ MultiDimensional ];

Method BuildClass(pFileName)
{
	If $E($zcvt(pFileName,"U"),*-3,*)=".TSC" Quit $classMethod(..#CODEBUILDER,"Build",pFileName)
	Quit $$$OK
}

/// if the ClassName is not defined in CodeWalk generate one from the file name
ClassMethod GetClassName(pFileName, pClassName)
{

	Set tClassName = $S(pClassName="":..DTLClassname(pFileName),1:pClassName)
	If $E($zcvt(pFileName,"l"),*-3,*)=".isc" {
		Set tClassName=..#CLASSNAMEPREFIXISC_tClassName
	} Else {
		Set tClassName = ..#CLASSNAMEPREFIXTSC_tClassName
	}
	Quit tClassName
}

}

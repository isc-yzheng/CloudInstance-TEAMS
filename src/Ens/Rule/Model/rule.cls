/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class Ens.Rule.Model.rule Extends Ens.Rule.Model.action [ System = 3 ]
{

Property name As %String(MAXLEN = "", XMLPROJECTION = "ATTRIBUTE");

Property constraints As list Of Ens.Rule.Model.constraint(XMLNAME = "constraint", XMLPROJECTION = "ELEMENT");

Property whens As list Of Ens.Rule.Model.when(XMLNAME = "when", XMLPROJECTION = "ELEMENT");

Property otherwise As Ens.Rule.Model.otherwise;

Property disabled As %Boolean(XMLPROJECTION = "ATTRIBUTE");

Property constraint As %String(XMLPROJECTION = "NONE");

}

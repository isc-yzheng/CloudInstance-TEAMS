/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsLib.HL7.MsgRouter.RuleAssist Extends EnsLib.EDI.MsgRouter.SegmentedRuleAssist [ Abstract, System = 4 ]
{

ClassMethod GetMetaData() As %String
{
	quit "source:"_$$$Text("Source","Ensemble")_":#configname,docCategory:"_$$$Text("Schema Category","Ensemble")_":#query,docName:"_$$$Text("Document Name","Ensemble")_":commalist#query"
}

ClassMethod GetDescription() As %String
{
	quit $$$Text("HL7 Message Routing Rule","Ensemble")
}

ClassMethod GetContextClass() As %String
{
	quit "EnsLib.HL7.MsgRouter.RoutingEngine"
}

ClassMethod GetQueryData(ByRef pArray, pParam) As %String
{
	If pParam="docName" {
		Set tVal=""
		Set tCat=$G(pArray("docCategory")) If tCat="" Set tCat="_"
		Set type="" For { Set type=$O($$$vaSchemaGbl(tCat,"MT",type))  Quit:""=type
			Set tVal=tVal_","_type
		}
		Quit $E(tVal,2,*)
	} ElseIf pParam="docTypeName" {
		Set tVal=""
		Set tCat=$G(pArray("docCategory")) If tCat="" Set tCat="_"
		Set type="" For { Set type=$O($$$vaSchemaGbl(tCat,"MS",type))  Quit:""=type
			Set tVal=tVal_","_type
		}
		Quit $E(tVal,2,*)
	} Else {
		set pArray("msgClass")="EnsLib.HL7.Message"
		Quit ##super(.pArray,.pParam)
	}
}

ClassMethod GetPropertyList(ByRef pArray, pText) As %String
{
	set pArray("msgClass")="EnsLib.HL7.Message"
	set pArray("%additionalVDocProperties")="HL7"
	set pArray("%classPropertyTypeOverride","EnsLib.HL7.MsgRouter.RoutingEngine","Document")=$g(pArray("msgClass"))
	quit ##super(.pArray,pText)
}

ClassMethod RuntimeConstraintCheck(ByRef pArray, pContext, Output pPassed) As %Status
{
	set pArray("msgClass")="EnsLib.HL7.Message"
	quit ##super(.pArray,pContext,.pPassed)
}

}

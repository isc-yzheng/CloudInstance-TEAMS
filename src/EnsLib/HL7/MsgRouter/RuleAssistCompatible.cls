/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsLib.HL7.MsgRouter.RuleAssistCompatible Extends EnsLib.MsgRouter.VDocRuleAssistCompatible [ Abstract, System = 4 ]
{

ClassMethod GetMetaData() As %String
{
	quit "source:"_$$$Text("Source","Ensemble")_":#configname,msgClass:"_$$$Text("Message Class","Ensemble")_":#class#vdocclass,docCategory:"_$$$Text("Schema Category","Ensemble")_":#query,docName:"_$$$Text("Document Name","Ensemble")_":commalist#query,docType:"_$$$Text("Schema DocType","Ensemble")_":commalist#query"
}

ClassMethod GetDescription() As %String
{
	quit $$$Text("HL7 Message Routing Rule (compatible mode)","Ensemble")
}

ClassMethod IsHidden() As %String
{
	quit 1
}

ClassMethod GetContextClass() As %String
{
	quit "EnsLib.HL7.MsgRouter.RoutingEngine"
}

ClassMethod GetQueryData(ByRef pArray, pParam) As %String
{
	If pParam="docName" {
		If pArray("msgClass")="EnsLib.HL7.Message" {
			Quit:$G(pArray("docCategory"))="" ""
			Set tRS = ##class(%ResultSet).%New("EnsLib.HL7.Schema:MessageTypes")
			Set tSC = tRS.Execute($G(pArray("docCategory")),1) Quit:$$$ISERR(tSC)
			Set tVal = ""
			While (tRS.Next()) {
				Set struct=tRS.GetData(1)
				Set tVal=tVal_","_$p(struct,":",2)
			}
			Do tRS.Close()
			Quit $E(tVal,2,*)
		} Else {
			Quit ""
		}
	} Else {
		Quit ##super(.pArray,.pParam)
	}
}

ClassMethod GetPropertyList(ByRef pArray, pText) As %String
{
	set pArray("%additionalVDocProperties")="HL7"
	quit ##super(.pArray,pText)
}

}

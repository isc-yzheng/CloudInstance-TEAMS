/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class EnsLib.EDI.MsgRouter.SegmentedRuleAssist Extends EnsLib.MsgRouter.VDocRuleAssist [ Abstract, System = 4 ]
{

ClassMethod GetDescription() As %String
{
	quit $$$Text("Segmented Virtual Document Message Routing Rule","Ensemble")
}

/// Returns if the rule input is a segmented document
ClassMethod GetIsSegmentedDoc() As %String
{
	quit 1
}

ClassMethod GetContextClass() As %String
{
	quit "EnsLib.EDI.MsgRouter.SegmentedRoutingEngine"
}

ClassMethod GetQueryData(ByRef pArray, pParam) As %String
{
	Set tVal=""
	Try {
		If pParam="msgClass" {
			Set tRS = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
			Do tRS.Execute("EnsLib.EDI.Segmented")
			While (tRS.Next()) { 
				Set class=$G(tRS.Data("Name"))
				set classobj=##class(%Dictionary.CompiledClass).%OpenId(class)
				if '$isObject(classobj) continue
				if classobj.ClassType="persistent" Set tVal=tVal_","_class
			}
			Do tRS.Close()
			Set tVal=$E(tVal,2,*)
		} Else {
			Set tVal = ##super(.pArray,pParam)
		}
	} Catch {
	}
	Quit tVal
}

ClassMethod GetPropertyList(ByRef pArray, pText) As %String
{
	set pArray("segClass")=$Case($g(pArray("msgClass")),
		"EnsLib.HL7.Message":"EnsLib.HL7.Segment",
		"EnsLib.EDI.X12.Document":"EnsLib.EDI.X12.Segment",
		"EnsLib.EDI.EDIFACT.Document":"EnsLib.EDI.EDIFACT.Segment",
		"EnsLib.EDI.ASTM.Document":"EnsLib.EDI.ASTM.Segment",
		:"")
	set pArray("%additionalVDocProperties")=$Select($D(pArray("%additionalVDocProperties"),tProps)#2:tProps_",",1:"")_"Segment"
	set pArray("%classPropertyTypeOverride",..GetContextClass(),"Segment")=$g(pArray("segClass"))
	quit ##super(.pArray,pText)
}

}

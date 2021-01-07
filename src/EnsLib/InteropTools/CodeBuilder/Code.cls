/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.Code Extends %Persistent
{

Parameter CODEDISABLED As %Boolean = 0;

Property Name As %String(MAXLEN = "");

Property Items As list Of CodeItem(STORAGEDEFAULT = "array");

/// Generated ClassName
Property ClassName As %String(MAXLEN = "");

Property SourceDocType As %String;

Property TargetDocType As %String;

Index NameIndex On Name [ Unique ];

ClassMethod GetIDForName(pName) As %String
{
	&sql(select ID into :tID from Code where Name=:pName)
	If SQLCODE {
		Set tName = "%"_pName_"%"
		&sql(select ID into :tID from Code where Name like :tName)
	}
	Quit $S(SQLCODE:"",1:tID)
}

ClassMethod Build(pName = "", pID = "", pCompile = 1) As %Status
{

	try {
		IF 'pID {
			Set pID=..GetIDForName(pName)
		}
		Set tObject=..%OpenId(pID,1,.tSC)
		Quit:$$$ISERR(tSC)
		Set tScript = tObject.ClassName
		/// temporary
		If ##Class(%Dictionary.ClassDefinition).%ExistsId(tScript) {
			Set tTransformClass = ##Class(%Dictionary.ClassDefinition).%OpenId(tScript)
		} Else {
			Set tTransformClass = ##class(%Dictionary.ClassDefinition).%New(tScript)
			Do tTransformClass.Parameters.Insert(..CreateClassParameter("IGNOREMISSINGSOURCE",1))
			Do tTransformClass.Parameters.Insert(..CreateClassParameter("REPORTERRORS",1))
			Do tTransformClass.Parameters.Insert(..CreateClassParameter("TREATEMPTYREPEATINGFIELDASNULL",0))
		}
		Set tTransformClass.Super = "Ens.DataTransformDTL"
		Set tTransformClass.DependsOn = "EnsLib.HL7.Message"
	
	
				/// Create and insert updated RuleDefinition XData
		Set tTransform = ##class(Ens.DTL.Transform).%New()
		Set tTransform.SourceDocType = tObject.SourceDocType
		Set tTransform.TargetDocType = tObject.TargetDocType
		Set tTransform.SourceClass = "EnsLib.HL7.Message"
		Set tTransform.TargetClass = "EnsLib.HL7.Message"
		Set tTransform.Create = "new"
		Set tTransform.Language = "objectscript"
		Set tTransform.Actions = ##class(Ens.DTL.ActionList).%New()
	
		Do ..AddActions(tObject.Items,tTransform.Actions)
	
		Set tSC = ..GenerateXDataStream(tTransformClass,tTransform,pCompile)
	} catch ex {
		Set tSC = ex.AsStatus()
		break
	} 
	Quit tSC
}

ClassMethod GenerateXDataStream(pTransformClass, pTransform, pCompile = 1) As %Status
{
	try {
		Set tSC = $$$OK
		Set tStream = ##class(%Stream.TmpCharacter).%New()
		Set tSC = pTransform.GenerateXML(.tStream)
		Quit:$$$ISERR(tSC) 
		Set tXData = ##class(%Dictionary.XDataDefinition).%New()
		Set tXData.Name = "DTL"
		Set tXData.XMLNamespace = "http://www.intersystems.com/dtl"
		Set tXData.Data = tStream
		For tIdx = 1:1:pTransformClass.XDatas.Count() {
			If pTransformClass.XDatas.GetAt(tIdx).Name="DTL" {
				Do pTransformClass.XDatas.RemoveAt(tIdx)
			}
		}
		Do pTransformClass.XDatas.Insert(tXData)
		Set tSC = pTransformClass.%Save() 
		If 'tSC {
			Write !,"Error Saving: ",pTransformClass.Name,!
			Do $system.Status.DisplayError(tSC)
		}
		Quit:$$$ISERR(tSC)
		If pCompile {
			Set tSC = $system.OBJ.Compile(pTransformClass.Name,"fk-d") 
			If 'tSC {
				Write !,"Error Compiling: ",pTransformClass.Name,!
				Do $system.Status.DisplayError(tSC)
				
			}
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddActions(pItems, Output pActions) As %Status
{
	For tIdx = 1:1:pItems.Count() {
		Set tItem = pItems.GetAt(tIdx)
		Continue:tItem.Discard=1
		If tItem.%IsA("EnsLib.InteropTools.CodeBuilder.CodeIf") {
			Set tContainer = pActions
			Set tAction = ##class(Ens.DTL.If).%New()
			Set tAction.Disabled = $S(tItem.Disabled:1,1:..#CODEDISABLED) 
			Set tAction.Annotation = tItem.Annotation
			Do tContainer.Insert(tAction)
			Set tAction.Condition = tItem.Condition
			If tItem.True.Count() {
				Set tContainer = tAction.True
				Do ..AddActions(tItem.True,tContainer)
			}
			If tItem.False.Count() {
				Set tContainer = tAction.False
				Do ..AddActions(tItem.False,tContainer)
			}
		} ElseIf tItem.%IsA("EnsLib.InteropTools.CodeBuilder.CodeGroup") {
			Set tAction=##class(Ens.DTL.Group).%New()
			Set tAction.Disabled = $S(tItem.Disabled:1,1:..#CODEDISABLED) 
			Do pActions.Insert(tAction)
			Set tAction.Annotation = tItem.Annotation
			Do ..AddActions(tItem.Items,tAction.Actions)
		} ElseIf tItem.%IsA("EnsLib.InteropTools.CodeBuilder.CodeSwitch") {
			Set tAction = ##class(Ens.DTL.Switch).%New()
			Set tAction.Disabled = $S(tItem.Disabled:1,1:..#CODEDISABLED) 
			Set tAction.Annotation = tItem.Annotation
			Do pActions.Insert(tAction)
			For tIdxSwitch = 1:1:tItem.Cases.Count() {
				Set tItemCase = tItem.Cases.GetAt(tIdxSwitch)
				
				If tItemCase.%IsA("EnsLib.InteropTools.CodeBuilder.CodeCase") {
					Set tCase = ##class(Ens.DTL.Case).%New()
					Set tCase.Condition = tItemCase.Condition
				} Else {
					Set tCase = ##class(Ens.DTL.Default).%New()
				}
				Do tAction.Cases.Insert(tCase)
				Do ..AddActions(tItemCase.Statements,tCase.Actions)
			}
		} ElseIf tItem.%IsA("EnsLib.InteropTools.CodeBuilder.CodeSet") {
			Set tAction = ##class(Ens.DTL.Assign).%New()
			Set tAction.Disabled = $S(tItem.Disabled:1,1:..#CODEDISABLED) 
			Set tAction.Annotation = tItem.Annotation
			If tItem.Action]"" {
				Set tAction.Action = tItem.Action
			}
			Do pActions.Insert(tAction)
			Set tAction.Property = tItem.Variable
			Set tAction.Value = tItem.Value
		} ElseIf tItem.%IsA("EnsLib.InteropTools.CodeBuilder.CodeForEach") {
			Set tContainer = pActions
			Set tAction = ##class(Ens.DTL.ForEach).%New()
			Set tAction.Disabled = $S(tItem.Disabled:1,1:..#CODEDISABLED) 
			Set tAction.Annotation = tItem.Annotation
			Do tContainer.Insert(tAction)
			Set tAction.Property = tItem.Property
			Set tAction.Key = tItem.Variable
			Do ..AddActions(tItem.Lines,tAction.Actions)
		} ElseIf tItem.%IsA("EnsLib.InteropTools.CodeBuilder.CodeCOS") {
			Set tAction = ##class(Ens.DTL.Code).%New()
			Set tAction.Disabled = $S(tItem.Disabled:1,1:..#CODEDISABLED) 
			Do pActions.Insert(tAction)
			For tIdxLines = 1:1:tItem.Lines.Count() {
				Set tLine = tItem.Lines.GetAt(tIdxLines)
				Do tAction.Code.Write(tLine_$c(13,10))
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError,"Unhandled type: "_tItem.%ClassName(1))
			break
			Quit
		}
		
	}
}

/// Create %Dictionary.ParameterDefinition object for name and default
ClassMethod CreateClassParameter(pName, pDefault) As %Dictionary.ParameterDefinition
{
	Set tParameter = ##class(%Dictionary.ParameterDefinition).%New()
	Set tParameter.Name=pName
	Set tParameter.Default = pDefault
	Quit tParameter
}

ClassMethod EnableCode(pClassname As %String = "") As %Status
{
	try {
		Set tSC = $$$OK
		Set tTransformClass = ##Class(%Dictionary.ClassDefinition).%OpenId(pClassname,1,tSC)
		If $$$ISERR(tSC) || '$IsObject(tTransformClass) Quit
		Set tDTL=""
		For tIdx = 1:1:tTransformClass.XDatas.Count() {
			If tTransformClass.XDatas.GetAt(tIdx).Name="DTL" {
				Set tDTL=tTransformClass.XDatas.GetAt(tIdx)
				Quit
			}
		}
		break:'$IsObject(tDTL)
		Set tSC = ##class(Ens.DTL.Compiler).ParseStream(.tTransform, tDTL.Data)
		For tIdx = 1:1:tTransform.Actions.Count() {
			Set x= $$MarkActive(tTransform.Actions.GetAt(tIdx))
		}
		Set tSC = ..GenerateXDataStream(tTransformClass,tTransform)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
MarkActive(pAction)	///
	New %tIdx2
	Set pAction.Disabled=0
	If pAction.%IsA("Ens.DTL.If") {
		For %tIdx2=1:1:pAction.True.Count() {
			Set x=$$MarkActive(pAction.True.GetAt(%tIdx2))
		}	
		For %tIdx2=1:1:pAction.False.Count() {
			Set x=$$MarkActive(pAction.False.GetAt(%tIdx2))
		}	
	} ElseIf pAction.%IsA("Ens.DTL.ForEach") {
		For %tIdx2=1:1:pAction.Actions.Count() {
			Set x=$$MarkActive(pAction.Actions.GetAt(%tIdx2))
		}
	}
	Quit ""
}

ClassMethod LineCount()
{
	s x="" 
	f  {
		s x=$o(^Ens.InteropTools.HL7.DG.Done("F",x)) quit:x=""  
		s id=##class(EnsLib.InteropTools.CodeBuilder.Code).GetIDForName(x) 
		Set obj=##class(EnsLib.InteropTools.CodeBuilder.Code).%OpenId(id)
		Set tLines=0
		For tIdx=1:1:obj.Items.Count() {
			Set tItem=obj.Items.GetAt(tIdx)
			Set %Nest=0
			Set tLines = ..Count(tItem,tLines)
		}
		Write !,x, ?132,tLines
	}
	Quit
}

ClassMethod Count(Item, tLines)
{
	Set %Nest=%Nest+1  break:%Nest>100
	Set tClass = Item.%ClassName(0)
	If "CodeCOS"[tClass {
	} ElseIf tClass="CodeIf" {
		Set tLines=tLines+1
		For tIdxt=1:1:Item.True.Count() { Set tItem = Item.True.GetAt(tIdxt) Set tLines = tLines+..Count(tItem,tLines)}
		For tIdxt=1:1:Item.False.Count() { Set tItem = Item.False.GetAt(tIdxt) Set tLines = tLines+..Count(tItem,tLines)}
	} ElseIf tClass="CodeForEach" {
		Set tLines=tLines+1
		For tIdxt=1:1:Item.Lines.Count() { Set tItem = Item.Lines.GetAt(tIdxt) Set tLines = tLines+..Count(tItem,tLines)}
	} ElseIf tClass="CodeSet" {
		Set tLines=tLines+1
	} Else {
		Break
	}
	Quit tLines
}

Storage Default
{
<Data name="CodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>SourceDocType</Value>
</Value>
<Value name="4">
<Value>TargetDocType</Value>
</Value>
<Value name="5">
<Value>ClassName</Value>
</Value>
</Data>
<Data name="Items">
<Attribute>Items</Attribute>
<Structure>subnode</Structure>
<Subscript>"Items"</Subscript>
</Data>
<DataLocation>^EnsLib.InteropTools.C2573.CodeD</DataLocation>
<DefaultData>CodeDefaultData</DefaultData>
<IdLocation>^EnsLib.InteropTools.C2573.CodeD</IdLocation>
<IndexLocation>^EnsLib.InteropTools.C2573.CodeI</IndexLocation>
<StreamLocation>^EnsLib.InteropTools.C2573.CodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

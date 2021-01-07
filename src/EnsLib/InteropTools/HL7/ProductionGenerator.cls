/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A class designed to load production data from a CSV file<br>
/// Example: Set tSC = ##class(EnsLib.InteropTools.HL7.ProductionGenerator).Load("/wtemp/configuration.csv","/wtemp/items.csv",.tInformation)
Class EnsLib.InteropTools.HL7.ProductionGenerator Extends %RegisteredObject
{

/// Rules should be disabled and only enabled after review
Parameter RULEDISABLED = 0;

Parameter DEFAULTPOOLSIZE = 0;

/// a map of {service/operation},{type - file tcp} to class
Property TypeMap [ MultiDimensional ];

Property Errors [ MultiDimensional ];

Property RowCount [ InitialExpression = 0 ];

Property BaseValues [ MultiDimensional ];

Property Structure [ MultiDimensional ];

Property ConfigJSON As %DynamicAbstractObject;

Property ItemsJSON As %DynamicAbstractObject;

Parameter HOSTADAPTERDELIMITER = ":";

/// Map of Service / Operation type text to class ie file -> EnsLib.HL7.Service.FileService
Method BuildMap()
{
	Set ..TypeMap("Service","file")="EnsLib.HL7.Service.FileService"
	Set ..TypeMap("Service","ftp") = "EnsLib.HL7.Service.FTPService"
	Set ..TypeMap("Service","http") = "EnsLib.HL7.Service.HTTPService"
	Set ..TypeMap("Service","soap") = "EnsLib.HL7.Service.SOAPService"
	Set ..TypeMap("Service","tcp") = "EnsLib.HL7.Service.TCPService"

	Set ..TypeMap("Operation","file")="EnsLib.HL7.Operation.FileOperation"
	Set ..TypeMap("Operation","ftp")="EnsLib.HL7.Operation.FTPOperation"
	Set ..TypeMap("Operation","http") = "EnsLib.HL7.Operation.HTTPOperation"
	Set ..TypeMap("Operation","soap") = "EnsLib.HL7.Operation.SOAPOperation"
	Set ..TypeMap("Operation","tcp") = "EnsLib.HL7.Operation.TCPOperation"
}

/// Method to load csv configuration file and items file<br>
/// pConfigurationPathAndFile - fully qualified file name for configuration CSV file<br>
/// pItemsPathAndFile - fully qualified file name for configuration items CSV file<br>
/// byRef pInformation - returned array of issues from loading file<br>
/// Returns Status
ClassMethod Load(pConfigurationPathAndFile As %String = "", pItemsPathAndFile As %String = "", ByRef pInformation) As %Status
{
	Set tThis = ..%New()
	Quit tThis.imLoad(pConfigurationPathAndFile,pItemsPathAndFile,.pInformation)
}

/// instance method processing Load
/// pConfigurationPathAndFile - fully qualified file name for configuration CSV file<br>
/// pItemsPathAndFile - fully qualified file name for configuration items CSV file<br>
/// byRef pInformation - returned array of issues from loading file<br>
/// Returns Status
Method imLoad(pConfigurationPathAndFile As %String = "", pItemsPathAndFile As %String = "", ByRef pInformation, pDelimiter) As %Status
{
	try {
		Set tSC = ..GetStream(pConfigurationPathAndFile,.tStreamC)
		Quit:$$$ISERR(tSC)
		If tStreamC.Size=0 {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Empty Configuration file","Ensemble"))
			Quit
		}

		Set tSC = ..GetStream(pItemsPathAndFile,.tStreamI)
		Quit:$$$ISERR(tSC)
		If tStreamI.Size=0 {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Empty Items file","Ensemble"))
			Quit
		}
		/// in Europe the default delimiter is ";" not "," so if it's not provided try to determine
		If $G(pDelimiter)="" {
			For tDelimiter = ",",";" {
				Set tSC = ..ParseCSV(tStreamC,,.tRecordSet,tDelimiter)
				Continue:$$$ISERR(tSC)
				Quit:tRecordSet.%ResultColumnCount=3
			}
			If $IsObject($g(tRecordSet))  && (tRecordSet.%ResultColumnCount=3) {
				Set pDelimiter=tDelimiter
			} Else {
				Return $$$ERROR($$$GeneralError,$$$Text("Configuration file does not have expected columns of Key,Value,Description","Ensemble"))
			}
		}
		If $G(pDelimiter)="" {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Unable to determine csv delimiter.  Expecting 3 columns in the configuration file.","Ensemble")) 
			Quit
		}
		Set tSC = ..imLoadConfigurationFromStream(tStreamC,pDelimiter)
		Quit:$$$ISERR(tSC)

		Set tSC = ..imLoadItemsFromStream(tStreamI,pDelimiter)
		Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Kill pInformation
	Merge pInformation = ..Errors
	If $$$ISOK(tSC) && $G(pInformation)>0 {
		Set tSC = $$$ERROR($$$GeneralError,$$$Text("Issues reported in third argument of the Load() method","Ensemble"))
	}
	Quit tSC
}

/// Return errors as an object
Method ReturnErrors() As %ListOfDataTypes
{
	Set tReturn = ##class(%ListOfDataTypes).%New()
	For tIdx=1:1:$G(..Errors) {
		Do tReturn.Insert(..Errors(tIdx))
	}
	Quit tReturn
}

/// Given a fully qualified filename return a FileCharacter stream
ClassMethod GetStream(pPathAndFile As %String, pStream As %Stream.FileCharacter) As %Status
{
	Set pStream = ##class(%Stream.FileCharacter).%New()
	Set tSC = pStream.LinkToFile(pPathAndFile)
	Quit tSC
}

/// pStream - File character stream of csv file<br>
/// Load Production Name, code package names for Transform, Rules, Custom functions<br>
/// Non fatal issues are logged in ..Errors
Method imLoadConfigurationFromStream(pStream As %Stream.FileCharacter = "", pDelimiter = ",") As %Status
{
	try {
		If pStream.Size=0 {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Empty Configuration Stream","Ensemble"))
		}
		Set tSC = ..ConvertCSVStreamToJSON(pStream,.tJSONStream,"Keys",.tGroup,pDelimiter)
		Quit:$$$ISERR(tSC)
		Set tSC = ..imLoadConfigurationFromJSONStream(tJSONStream,.tGroup)
		Quit
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..LogError($system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// pStream - File character stream json<br>
/// Load Production Name, code package names for Transform, Rules, Custom functions<br>
/// Non fatal issues are logged in ..Errors
Method imLoadConfigurationFromJSONStream(pStream As %Stream.FileCharacter = "", pGroup As %DynamicAbstractObject = "") As %Status
{
	try {
		Set tSC = $$$OK
		If pStream.Size=0 {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Empty Configuration Stream","Ensemble"))
		}
		If '$IsObject(pGroup) {
			Do pStream.Rewind()
			Set pGroup = {}.%FromJSON(pStream.Read(30000000))
		}
		Set ..ConfigJSON = pGroup
		Set tKeys = pGroup.Keys
		Set tIterator = tKeys.%GetIterator()
		Set tCount=0,tSC=$$$OK
		While tIterator.%GetNext(.tKey,.tItem) {
			Continue:tItem.Key=""
			Set ..BaseValues(tItem.Key)=tItem.Value
		}
		If $D(..BaseValues) {
			Set ..BaseValues("Namespace")=$namespace
		}
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..LogError($system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// pStream - File character stream of csv file<br>
/// Convert csv files to JSON stream and Load production items using imLoadItemsfromJSONStream(tStream)
Method imLoadItemsFromStream(pStream As %Stream.FileCharacter = "", pDelimiter = ",") As %Status
{
	try {
		If pStream.Size=0 {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Empty Stream","Ensemble"))
			Quit
		}
		If '$D(..BaseValues) {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Configuration not loaded","Ensemble"))
			Quit
		}
		Set ..RowCount=1  // Account for Header row in CSV (all for error reporting row number)
		/// Convert csv to JSON stream also returning the already parsed Group
		Set tSC = ..ConvertCSVStreamToJSON(pStream,.tJSONStream,"Items",.tGroup,pDelimiter)
		Quit:$$$ISERR(tSC)
		/// Pass parsed group into Load
		Set tSC = ..imLoadItemsFromJSONStream(,.tGroup)
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..LogError($system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Convert CSV file into JSON Stream<br>
/// pFilename name of csv file<br>
/// pGroupName is the root node
ClassMethod ConvertCSVFileToJSONStream(pFilename As %String = "", ByRef pJSONStream, pGroupName = "Items") As %Status
{
	Set tStream = ##class(%Stream.FileCharacter).%New()
	Set tSC = tStream.LinkToFile(pFilename)
	Quit ..ConvertCSVStreamToJSON(tStream,.pJSONStream,pGroupName)
}

/// pStream - a file character stream of the CSV file<br>
/// pJSONStream - The newly created JSON file character stream<br>
/// pGroupName - the root node of the JSON stream (Items for production items and keys for configuration)<br>
/// pGroup - a by ref variable containing the JSON object (to avoid having to re-parse the json) 
ClassMethod ConvertCSVStreamToJSON(pStream As %Stream.FileCharacter = "", ByRef pJSONStream, pGroupName = "Items", ByRef pGroup, pDelimiter = ",") As %Status
{
	try {
		Set tSC = $$$OK
		Set tSC = ..ParseCSV(pStream,.tStructure,.tRecordSet,pDelimiter)
		If $$$ISERR(tSC) {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Failed to parse the items","Ensemble"))
			Quit
		}
		If tRecordSet.%Next()  /// remove header
		Set pGroup = {}
		Set $property(pGroup,pGroupName)=[]
		Set tGroupProperty = $property(pGroup,pGroupName)
		While tRecordSet.%Next() {
			/// skip blank rows
			Set tNonNull=0
			For tIdx = 1:1:tRecordSet.%ResultColumnCount {
				If $zstrip(tRecordSet.%GetData(tIdx),"<>WC")'="" Set tNonNull=1
			}
			Continue:tNonNull=0
			Set tItem=##class(%DynamicObject).%New()
			Set tColumn = "" 
			For  {
				Set tColumn=$Order(tStructure(tColumn)) Quit:tColumn=""
				Set tValue = $property(tRecordSet,tColumn)
				Continue:tValue=""
				Set $property(tItem,tColumn)=tValue
			}
			Do tGroupProperty.%Push(tItem)
		}
		Set pJSONStream = ##class(%Stream.FileCharacter).%New()
		Do pGroup.%ToJSON(pJSONStream)
	}catch ex{
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// pStream - a file character stream containing the JSON definition<br>
/// pGroup - the already parsed JSON object if known
Method imLoadItemsFromJSONStream(pStream As %Stream.FileCharacter = "", pGroup As %DynamicAbstractObject = "") As %Status
{

	try {
		Kill ..Errors
		Set ..Errors=0
		Kill ^||EnsLib.PG.Settings
		Do ..BuildMap() 
		/// Fetch / Create production if not already created
		Set tSC = ..GetProduction(.tProdRef)
		Quit:$$$ISERR(tSC)
		If '$IsObject(tProdRef) {
			Do ..LogError($$$FormatText($$$Text("Unable to locate production using name:%1","Ensemble"),$G(..BaseValues("ProductionClassName"),$$$Text("<Undefined>","Ensemble"))))
			Quit
		}
		If '$IsObject(pGroup) {
			Do pStream.Rewind()
			Set pGroup = ##class(%DynamicAbstractObject).%FromJSON(pStream.Read(3000000))
		}
		Set ..ItemsJSON = pGroup
		Do ..GetStructureFromItems()
		Set tSC = ..ValidateConfiguration()
		Quit:$$$ISERR(tSC)
		If $G(..BaseValues("AddActivityOperation"),1) {
			Set tSC = ..AddActivityOperation(.tProdRef)
			Quit:$$$ISERR(tSC)
		}
		Set tIterator = pGroup.Items.%GetIterator()

		#define CheckAdd(%sc,%name) If $$$ISERR(%sc) Do ..LogError($$$FormatText($$$Text("Error adding %1 for row %2 with error: %3","Ensemble"),%name,..RowCount,$system.Status.GetErrorText(tSC))) Continue
		While tIterator.%GetNext(.tKey,.tItem) { 
			Set ..RowCount=..RowCount+1
			Kill tValues
			Set tSC = ..getValues(tItem,.tValues)
			Quit:$$$ISERR(tSC)
			$$$CheckAdd(tSC,"values")
			If $g(tValues("ServiceName"))="" {
				$$$CheckAdd($$$ERROR($$$GeneralError,$$$Text("Service name evaluates to null","Ensemble")),"Service")
			}
			If $g(tValues("RouterName"))="" {
				$$$CheckAdd($$$ERROR($$$GeneralError,$$$Text("Router name evaluates to null","Ensemble")),"Router")
			}

			If $g(tValues("OperationName"))="" {
				$$$CheckAdd($$$ERROR($$$GeneralError,$$$Text("Operation name evaluates to null","Ensemble")),"Operation")
			}

			Set tSC = ..AddOperation(.tValues,tItem,.tProdRef)
			$$$CheckAdd(tSC,"Operation")

			Set tSC = ..CreateRouterProcess(.tValues,tItem,.tProdRef)
			$$$CheckAdd(tSC,"Router")
			
			Set tSC = ..AddService(.tValues,tItem,.tProdRef)
			$$$CheckAdd(tSC,"Service")
		}
		Set tSC1 = tProdRef.%Save()


		If $$$ISERR(tSC1) {
			Do ..LogError($$$FormatText($$$Text("Error saving production %1","Ensemble"),$system.Status.GetErrorText(tSC)))
		}
		Set tSC = $$$ADDSC(tSC,tSC1)
		If $$$ISOK(tSC) {
			Do tProdRef.SaveToClass("")
			Set tSC1= $system.OBJ.Compile(tProdRef.Name,"fk-dv")
			Set tSC = $$$ADDSC(tSC,tSC1)
		}
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..LogError($system.Status.GetErrorText(tSC))
	}
	Kill ^||EnsLib.PG.Settings
	Quit tSC
}

/// Build Structure array from all JSON items
Method GetStructureFromItems()
{
	Set tIterator = ..ItemsJSON.Items.%GetIterator()
	While tIterator.%GetNext(.tKey,.tItem) { 
		Set tItemIterator = tItem.%GetIterator()
		While tItemIterator.%GetNext(.tKey,.tValue) {
			Set ..Structure(tKey)=""
		}
	}
}

Method ValidateConfiguration()
{
	Set tKey = "",tSC=$$$OK
	For  {
		Set tKey=$O(..BaseValues(tKey),1,tValue) Quit:tKey=""
		Set tPos = 0
		For  {
			Set tPos = $F(tValue,"{",tPos)
			Quit:'tPos
			Set tEnd = $F(tValue,"}",tPos)
			Set tExpression = $E(tValue,tPos,tEnd-2)
			If tExpression]"" &&  '$D(..BaseValues(tExpression)) && '$D(..Structure(tExpression)) {
				Set tText = $$$FormatText($$$Text("Configuration entry %1 contains unknown column %2","Ensemble"),tKey,tExpression)
				Do ..LogError(tText)
				Set tSC = $$$ERROR($$$GeneralError,tText)
			}
			Set tPos = tEnd-1
		}
	}
	Quit tSC
}

/// for a given (pRecordSet) row define pValues(nodes)
Method getValues(pRecordSet, Output pValues) As %Status
{
	Set tSC = $$$OK
	try {
		Set tNode=""
		For {
			Set tNode=$O(..BaseValues(tNode)) Quit:tNode=""
			Set tValue = ..evaluateExpression(tNode,pRecordSet,.tSC) 
			Quit:$$$ISERR(tSC)
			Set pValues(tNode)=tValue
		}
	}catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Locate / Generate production specified by Configuration key ProductionClassName
Method GetProduction(Output pProdRef As Ens.Production) As %Status
{
	Set tSC = $$$OK
	try {
		Set tProductionClass = $G(..BaseValues("ProductionClassName"))
		If tProductionClass = "" {
			Set tProductionClass = $G(^Ens.Configuration("csp","LastProduction"))
		}
		If tProductionClass = "" {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Configuration entry not set for ProductionClassName","Ensemble"))
			Quit
		}
	 	Set tProductionClass = ..evaluateExpression("ProductionClassName",,.tSC)
		Quit:'tSC
		If '##class(Ens.Config.Production).%ExistsId(tProductionClass) {
			Set tClass=##class(%Dictionary.ClassDefinition).%New(tProductionClass)
			Set tClass.Super="Ens.Production"
			Set tXData = ##class(%Dictionary.XDataDefinition).%New()
			Set tXData.Name="ProductionDefinition"
			Do tXData.Data.Write("<Production Name="""_tProductionClass_""" LogGeneralTraceEvents=""false""></Production>")	
			Do tClass.XDatas.Insert(tXData)
			Set tSC = tClass.%Save()
			Quit:$$$ISERR(tSC)
			Set tSC= $system.OBJ.Compile(tProductionClass,"fck-dv")
			Quit:$$$ISERR(tSC)
			Set ^Ens.Configuration("csp","LastProduction")=tProductionClass
		}
		Set pProdRef=##class(Ens.Config.Production).%OpenId(tProductionClass,1,.tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Given the host, add or update the setting with name / value, with pTarget as Host or Adapter<br>
/// pHostItem - Ens.Host
/// pName - pHostItem.Name
ClassMethod AddSetting(pHostItem, pName, pValue, pTarget) As %Status [ Internal ]
{
	try {
		Set tSC =$$$OK
		Set tExisting="",tSetting=""
		For tIdx = 1:1:pHostItem.Settings.Count() {
			Set tExisting=pHostItem.Settings.GetAt(tIdx)
			Continue:(tExisting.Target '= pTarget)
			If tExisting.Name = pName {
				Set tSetting=tExisting
				Quit
			}
		}
		If '$IsObject(tSetting) && (pValue]"") {
			Set tSetting = ##class(Ens.Config.Setting).%New()
			Set tSetting.Name=pName
			Do pHostItem.Settings.Insert(tSetting)
		}
		If $IsObject(tSetting) {
			Set tSetting.Value=pValue 
			Set tSetting.Target=pTarget
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// If an existing match based on name and class (pMatch = 1).  If name matches but a different class, this is an error
ClassMethod FindExistingMatch(pItem As Ens.Config.Item, ByRef pProduction As Ens.Production, Output pMatch As Ens.Config.Item) As %Status [ Internal ]
{
	Set tSC = $$$OK
	try {
		Set pMatch=""
		For tIdx = 1:1:pProduction.Items.Count() {
			Set tItem = pProduction.Items.GetAt(tIdx) 
			Continue:(pItem.Name '= tItem.Name)
			If pItem.ClassName = tItem.ClassName {
				Set pMatch=tItem
				Quit
			}
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("An item exists with this name %1, but has a different class","Ensemble"),pItem.Name)
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method ValidateItemStructure()
{
	Set tItemNode=""
	For {
		Set tItemNode=$O(..Structure(tItemNode)) Quit:tItemNode=""
		If $f(tItemNode,":") {
			Set tHost=$p(tItemNode,":")
			If (",S,R,O,P,T,"'[(","_tHost_",")) { 
				Do ..LogError($$$FormatText($$$Text("Host unknown %1 from value %2","Ensemble"),tHost,tItemNode))
			}
		}
	}
	Quit $$$OK
}

/// update string replacing curly brace values with actual values strip repeating and trailing underscore characters 
Method evaluateExpression(pNode, pRecordSet As %SQL.CSVResultSet, Output pSC) As %String
{
	try {
		Set pSC=$$$OK
		Set tNewString=""
		If '$Data(..BaseValues(pNode)) {
			Set pSC = $$$ERROR($$$GeneralError,$$$FormatText($$$Text("Base value not defined for '%1'","Ensemble"),pNode))
			Quit
		}
		If $D(..Structure(pNode_"Override")) {
			Set tNewString = $property(pRecordSet,pNode_"Override")
			Quit:tNewString]""
		}
		Set tString = ..BaseValues(pNode)
		Set tNewString = ""
		Set tPos=0
		For  {
			Set tStart = $f(tString,"{")
			Quit:'tStart
			Set tEnd = $F(tString,"}",tStart)
			Quit:'tEnd
			Set tNewString = tNewString _ $E(tString,1,tStart-2)
			Set tEvalProperty = $E(tString,tStart,tEnd-2)
			Set tString = $E(tString,tEnd,*)
			try {
				If $d(..Structure(tEvalProperty)) {
					Set tValue = $property(pRecordSet,tEvalProperty)
				} ElseIf $D(..BaseValues(tEvalProperty)) && (tEvalProperty '=pNode) {
					Set tValue=..BaseValues(tEvalProperty)
				} Else {
					Set tValue = ""
				}
			} catch { Set tValue = "[["_tEvalProperty_"]]"}
			Quit:$$$ISERR(pSC)
			Set tNewString = tNewString_tValue
		}
		Set tNewString = tNewString_tString
	} catch ex {
		Set pSC = ex.AsStatus()
	}
	/// strip any trailing _'s
	Set tNewString = $zstrip(tNewString,">","_")
	/// strip any repeating _'s, use loop versus $replace to catch triple underscore items
	For  {
		Set tPos=$F(tNewString,"__")
		Quit:'tPos
		Set tNewString=$E(tNewString,1,tPos-2)_$E(tNewString,tPos,*)
	}
	Quit $zstrip(tNewString,"<>W")
}

/// create Service based on settings provided with a host name of {ServiceName}
Method AddService(pValues, pRecordSet, ByRef pProduction) As %Status [ Internal ]
{
	Set tSC = $$$OK
	try {
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = pValues("ServiceName")
	
		Set tServiceType = $zcvt($property(pRecordSet,"ServiceType"),"l") 
		If tServiceType="" {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Service type is empty","Ensemble"))
			Quit
		}
		Set tClassName = $G(..TypeMap("Service",tServiceType),tServiceType)
		If '##class(%ClassDefinition).%ExistsId(tClassName) {
			Set tSC = $$$ERROR($$$GeneralError,$$$FormatText($$$Text("Class %1, does not exist","Ensemble"),tClassName))
			Quit
		}
		Set tItem.ClassName = tClassName
		Set tSC = ..FindExistingMatch(tItem,pProduction,.tMatch)
		If $$$ISERR(tSC) {
			Quit
		}
		If $IsObject(tMatch) {
			Set tItem = tMatch
		} Else {
			Do pProduction.Items.Insert(tItem)
		}
		Do ..AddSetting(tItem,"TargetConfigNames",pValues("RouterName"),"Host")
		Set tSC = ..UpdateSettings("Service",tItem,pRecordSet,.pValues)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// pHostType - Service / Router / Operation <br>
/// pItem - host item created <br>
/// pRecordSet - CSV recordSet<br>
/// pValues - values collected from configuration load<br>
Method UpdateSettings(pHostType, pItem, pRecordSet, ByRef pValues) As %Status
{
	try {
		Set tSC = $$$OK
		Set tIsHost = pItem.%IsA("Ens.Config.Item")  /// not rule or transform
		If tIsHost {
			Set tLastRow = $O(^||EnsLib.PG.Settings(pItem.Name,"R",""),-1)
			Set ^||EnsLib.PG.Settings(pItem.Name,"R",..RowCount)=""
		}
		For tTarget = "","H","A" {
			Set tSettings = $E(pHostType)_..#HOSTADAPTERDELIMITER_tTarget_$S(tTarget]"":..#HOSTADAPTERDELIMITER,1:"")
			Set tSetLen = $l(tSettings)
			Set tSetting=tSettings
			For  {
				Set tSetting = $O(..Structure(tSetting))
				Quit:(tSetting="" || ($E(tSetting,1,tSetLen)'=tSettings))
				If tTarget="" && ($l(tSetting,":")'=2) Continue
				//Continue:$l(tSetting,":")'=$l(tSettings,":")  /// Host: versus Host:Adapter:
				Set tValue = $property(pRecordSet,tSetting)
				Continue:tValue=""
				If tValue = $C(34,34) {
					Set tValue=""
				}
				If tTarget="" {
					Set tSettingName = $p(tSetting,..#HOSTADAPTERDELIMITER,2)
					try {
						Set $property(pItem,tSettingName)=tValue
					} Catch ex {
						Do ..LogError($$$FormatText($$$Text("Failure while attempting to set property %1 on %2","Ensemble"),tSettingName,pHostType))
					}
				} ElseIf tIsHost {
					Set tSettingName = $p(tSetting,..#HOSTADAPTERDELIMITER,3)
					Set tTargetName=$Case(tTarget,"H":"Host","A":"Adapter",:"")
					Do ..AddSetting(pItem,tSettingName,tValue,tTargetName)
				} Else {
					/// this would be a rule or a transform, shouldn't have "H" or "A"
					Do ..LogError($$$FormatText($$$Text("Unexpected named item %1:%2:%3","Ensemble"),pHostType,tTarget,tSettingName))
				}
				If tIsHost && ($G(^||EnsLib.PG.Settings(pItem.Name,"V",tSettingName),tValue)'=tValue) {
					Do ..LogError($$$FormatText($$$Text("%1 %2 already exists and has %3 defined for %4 at row #%5, current row #%6 overwrote the value with %7","Ensemble"),pHostType,pItem.Name,$G(^||EnsLib.PG.Settings(pItem.Name,"V",tSettingName),tValue),tSetting,tLastRow,..RowCount,tValue))

				}
				Set:tIsHost ^||EnsLib.PG.Settings(pItem.Name,"V",tSettingName)=tValue
			}

			Set (tSettings,tSetting)="Override_"_tSettings
			Set tSetLen=$l(tSetting)
			For  {
				Set tSetting = $O(..BaseValues(tSetting))
				Quit:(tSetting="" || ($E(tSetting,1,tSetLen)'=tSettings))
				If tTarget="" && ($l(tSetting,":")'=2) Continue
				Set tValue = ..evaluateExpression(tSetting,pRecordSet,.tSC) Quit:$$$ISERR(tSC)
				Continue:tValue=""
				If tValue = $C(34,34) {
					Set tValue=""
				}
				If tTarget="" {
					Set tSettingName = $p(tSetting,..#HOSTADAPTERDELIMITER,2)
					try {
						Set $property(pItem,tSettingName)=tValue
					} Catch ex {
						Do ..LogError($$$FormatText($$$Text("Failure while attempting to set property %1 on %2","Ensemble"),tSettingName,pHostType))
					}
				} ElseIf tIsHost {
					Set tSettingName = $p(tSetting,..#HOSTADAPTERDELIMITER,3)
					Set tTargetName=$Case(tTarget,"H":"Host","A":"Adapter",:"")
					Do ..AddSetting(pItem,tSettingName,tValue,tTargetName)
				} Else {
					/// this would be a rule or a transform, shouldn't have "H" or "A"
					Do ..LogError($$$FormatText($$$Text("Unexpected named item %1:%2:%3","Ensemble"),pHostType,tTarget,tSettingName))
				}
				If tIsHost && ($G(^||EnsLib.PG.Settings(pItem.Name,"V",tSettingName),tValue)'=tValue) {
					Do ..LogError($$$FormatText($$$Text("%1 %2 already exists and has %3 defined for %4 at row #%5, current row #%6 overwrote the value with %7","Ensemble"),pHostType,pItem.Name,$G(^||EnsLib.PG.Settings(pItem.Name,"V",tSettingName),tValue),tSetting,tLastRow,..RowCount,tValue))
				}
				Set:tIsHost ^||EnsLib.PG.Settings(pItem.Name,"V",tSettingName)=tValue
			}
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method LogError(pString)
{
	Set ..Errors($I(..Errors))=pString
}

/// Add the Ens.Activity.Operation.Local operation unless configuration item AddActivityOperation specifically set to 0
Method AddActivityOperation(ByRef pProduction) As %Status
{
	Set tSC = $$$OK	
	try {
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "Ens.Activity.Operation.Local"
		Set tItem.ClassName = tItem.Name
		Set tSC = ..FindExistingMatch(tItem,pProduction,.tMatch)
		If $$$ISERR(tSC) {
			Quit
		}
		If '$isObject(tMatch) {
			Do pProduction.Items.Insert(tItem)
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// create Operation based on settings provided with a host name of {OperationName}
Method AddOperation(pValues, pRecordSet As %SQL.CSVResultSet, ByRef pProduction) As %Status
{
	Set tSC = $$$OK	
	try {
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = pValues("OperationName")

		Set tOperationType = $zcvt($property(pRecordSet,"OperationType"),"l")
		If tOperationType="" {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Operation type is empty","Ensemble"))
			Quit
		}
		Set tClassName = $G(..TypeMap("Operation",tOperationType))
		If '##class(%ClassDefinition).%ExistsId(tClassName) {
			Set tSC = $$$ERROR($$$GeneralError,$$$FormatText($$$Text("Class %1 does not exist","Ensemble"),tClassName))
			Quit
		}
		Set tItem.ClassName = tClassName
		Set tSC = ..FindExistingMatch(tItem,pProduction,.tMatch)
		If $$$ISERR(tSC) {
			Quit
		}
		If $isObject(tMatch) {
			Set tItem = tMatch
		} Else {
			Do pProduction.Items.Insert(tItem)
		}
		Do ..UpdateSettings("Operation",tItem,pRecordSet,.pValues)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Create business process {package}.{ServiceName}
Method CreateRouterProcess(pValues, pRecordSet As %SQL.CSVResultSet, ByRef pProduction) As %Status
{
	Set tSC = $$$OK
	try {
		If ..GetRecordSetProperty(pRecordSet,"NoTransformation",0) {
			Set tTransformationName = ""
		} Else {
			Set tTransformationName = pValues("TransformationName")

			Set tTransformation = (tTransformationName '= "")
			If tTransformation {
				Set tSC = ..CreateTransformation(.pValues,pRecordSet,.tTransformationName) 
				If $$$ISERR(tSC) Do ..LogError($$$Text("Error adding creating transformation ","Ensemble")) Quit
			} Else {
				Set tTransformationName=""
			}
		}

		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = pValues("RouterName")
		Set tItem.ClassName = ..GetRecordSetProperty(pRecordSet,"RouterType","EnsLib.HL7.MsgRouter.RoutingEngine")
		If '##class(%ClassDefinition).%ExistsId(tItem.ClassName) {
			Set tSC = $$$ERROR($$$GeneralError,$$$FormatText($$$Text("Class does not exist %1","Ensemble"),tItem.ClassName))
			Quit
		}
		Set tSC = ..FindExistingMatch(tItem,pProduction,.tMatch)
		Quit:$$$ISERR(tSC)
		If $Isobject(tMatch) {
			Set tItem = tMatch
		} Else {
			Do pProduction.Items.Insert(tItem)
		}
		Set tRuleName = ..StringAsClassName(pValues("RuleName"))
		If tRuleName = "" {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("Rule name is empty","Ensemble"))
			Quit
		}
		Set tSC = ..AddSetting(tItem,"BusinessRuleName",tRuleName,"Host") Quit:$$$ISERR(tSC)
		Set tSC = ..CreateUpdateBusinessRule(.pValues,pRecordSet,tRuleName,tTransformationName) Quit:$$$ISERR(tSC)
		Set tSC = ..UpdateSettings("Process",tItem,pRecordSet,.pValues)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Retrieve pField from pRecordSet (if defined), otherwise return default
Method GetRecordSetProperty(pRecordSet, pField = "", pDefault = "") As %String
{
	try {
		If $D(..BaseValues(pField)) {
			Set tString = ..evaluateExpression(pField,pRecordSet,.tSC)
		} Else {
			If pRecordSet.%IsA("%DynamicObject") {
				If pRecordSet.%IsDefined(pField) {
					Set tString = $property(pRecordSet,pField)
				} Else {
					Set tString = pDefault
				}
			} Else {
				Set tString = $property(pRecordSet,pField)
			}
		}
	} catch {
		Set tString = pDefault
	}
	Quit tString
}

/// Create/Update a RouterRule based on service / operation names
/// 
Method CreateUpdateBusinessRule(ByRef pValues, pRecordSet As %SQL.CSVResultSet, pRuleName, pTransformationName As %String) As %Status
{
	Set tSC = $$$OK
	try {
		/// Get existing / create new Rule class and definition
		Set tRuleDefinition = ""
		If ##class(%Dictionary.ClassDefinition).%ExistsId(pRuleName) {
			Set tRuleClass = ##class(%Dictionary.ClassDefinition).%OpenId(pRuleName,1,.tSC)
			Quit:$$$ISERR(tSC)
			Set tSC = ##class(Ens.Rule.Generator).correlateByName(pRuleName,.tRuleDefinition)
		} Else {
			Set tRuleClass = ##class(%Dictionary.ClassDefinition).%New(pRuleName)
			Set tRuleClass.Super = "Ens.Rule.Definition"
			Do tRuleClass.Parameters.Insert(..CreateClassParameter("RuleAssistClass","EnsLib.HL7.MsgRouter.RuleAssist"))
		} 
		If '$IsObject(tRuleDefinition) {
			Set tRuleDefinition = ##class(Ens.Rule.Model.ruleDefinition).%New()
		}
		Set tRuleDefinition.production=pValues("ProductionClassName")
		Set tRuleDefinition.context="EnsLib.HL7.MsgRouter.RoutingEngine"
		/// Remove existing XData
		For tIdx = 1:1:tRuleClass.XDatas.Count() {
			If tRuleClass.XDatas.GetAt(tIdx).Name="RuleDefinition" {
				Do tRuleClass.XDatas.RemoveAt(tIdx) 
				Quit
			}
		}

		/// Get existing / create rule set
		Set tRuleSet = tRuleDefinition.ruleSets.GetAt(1)
		If '$IsObject(tRuleSet) {
			Set tRuleSet = ##class(Ens.Rule.Model.ruleSet).%New()
			Do tRuleDefinition.ruleSets.Insert(tRuleSet)
		}
	
		/// Find existing/create rule for a Operation name
		Set tExisting=""
		For tIdx = 1:1:tRuleSet.actions.Count() {
			Set tRule = tRuleSet.actions.GetAt(tIdx)
			/// Ignore rule comments
			If 'tRule.%IsA("Ens.Rule.Model.rule") Continue
			If tRule.name = pValues("OperationName") {
				Set tExisting = tRule
				Quit
			}
		}
		If '$IsObject(tExisting) {
			Set tExisting = ##class(Ens.Rule.Model.rule).%New()
			Set tExisting.disabled=..GetRecordSetProperty(pRecordSet,"RuleDisabled",..#RULEDISABLED)
			Do tRuleSet.actions.Insert(tExisting)
			Set tExisting.name = pValues("OperationName")

			/// create and insert when condition
			Set tWhen = ##class(Ens.Rule.Model.when).%New()
			Do tExisting.whens.Insert(tWhen)
			Do tWhen.conditionSet(1)
			Set tSend = ##class(Ens.Rule.Model.send).%New()
			Set tSend.target=pValues("OperationName")
			Set tSend.transform=pTransformationName
			Do tWhen.actions.Insert(tSend)

			If $G(..BaseValues("ConstrainRule"),1) {
				// By default assign rule to source, override behaviour with configuration item ConstrainRule=0
				Set tConstraint = ##class(Ens.Rule.Model.constraint).%New()
				Set tConstraint.name="source"
				Set tConstraint.value = pValues("ServiceName")
				Do tExisting.constraints.Insert(tConstraint) 
			}
			Do ..UpdateSettings("R",tExisting,pRecordSet,.pValues)
		}

		/// Create and insert updated RuleDefinition XData
		Set tXData = ##class(%Dictionary.XDataDefinition).%New()
		Set tXData.Name = "RuleDefinition"
		
		Set tSC = tRuleDefinition.XMLExportToStream(.tStream)
		Set tXData.Data = tStream
		Set tSC = tRuleClass.XDatas.Insert(tXData)
		Quit:$$$ISERR(tSC)
		Set tSC = tRuleClass.%Save()
		Do $system.OBJ.Compile(tRuleClass.Name,"fk-d")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// User could have provided a service name with _, remove those (and other invalid characters) from the classname
ClassMethod StringAsClassName(pString) As %String [ CodeMode = expression ]
{
$tr(pString,"-_!@#$%^&*():")
}

/// Create Transformation Class which extends Ens.DataTransformDTL, this code is only called if SourceDocType and TargetDocType are set
Method CreateTransformation(ByRef pValues, pRecordSet As %SQL.CSVResultSet, Output pTransformationName) As %Status
{
	#define sub(%string,%item,%value) For { Quit:'$f(%string,%item)  Set %string = $p(%string,%item,1)_%value_$p(%string,%item,2)}
	Set tSC = $$$OK
	try {
		Set tTransName = ..StringAsClassName(pValues("TransformationName"))
		If ##class(%Dictionary.ClassDefinition).%ExistsId(tTransName) {
			Set tTransformClass = ##class(%Dictionary.ClassDefinition).%OpenId(tTransName)
		} Else {
			Set tTransformClass = ##class(%Dictionary.ClassDefinition).%New(tTransName)
			Set tTransformClass.Super = "Ens.DataTransformDTL"
			Set tTransformClass.DependsOn = "EnsLib.HL7.Message"

			Do tTransformClass.Parameters.Insert(..CreateClassParameter("IGNOREMISSINGSOURCE",1))
			Do tTransformClass.Parameters.Insert(..CreateClassParameter("REPORTERRORS",1))
			Do tTransformClass.Parameters.Insert(..CreateClassParameter("TREATEMPTYREPEATINGFIELDASNULL",0))

			/// Create and insert updated RuleDefinition XData
			Set tXData = ##class(%Dictionary.XDataDefinition).%New()
			Set tXData.Name = "DTL"
			Set tXData.XMLNamespace = "http://www.intersystems.com/dtl"
			Set tStream = ##class(%Stream.TmpCharacter).%New()
			Set tTransform = ##class(Ens.DTL.Transform).%New()
			Set tSourceType = ..GetRecordSetProperty(pRecordSet,"SourceType","")
			Set tTargetType = ..GetRecordSetProperty(pRecordSet,"TargetType","")
			Set tTransform.SourceDocType = ..GetRecordSetProperty(pRecordSet,"SourceSchema","")_$S(tSourceType]"":":",1:"")_tSourceType
			Set tTransform.TargetDocType = ..GetRecordSetProperty(pRecordSet,"TargetSchema","")_$S(tTargetType]"":":",1:"")_tTargetType
			Set tTransform.SourceClass = "EnsLib.HL7.Message"
			Set tTransform.TargetClass = "EnsLib.HL7.Message"
			Set tTransform.Create = "copy"
			Set tTransform.Language = "objectscript"
			Set tTransform.Actions = ##class(Ens.DTL.ActionList).%New()
			Do ..UpdateSettings("Transformation",tTransform,pRecordSet,.pValues)
			/// user updates in UpdateDTL
			Set tSC =  ..UpdateDTL(tTransform)
			Quit:$$$ISERR(tSC)
			Set tSC = tTransform.GenerateXML(.tStream)
			Quit:$$$ISERR(tSC)
			Set tXData.Data = tStream
			For tIdx = 1:1:tTransformClass.XDatas.Count() {
				If tTransformClass.XDatas.GetAt(tIdx).Name="DTL" {
					Do tTransformClass.XDatas.RemoveAt(tIdx)
				}
			}
			Do tTransformClass.XDatas.Insert(tXData)
			Set tSC = tTransformClass.%Save()
			Quit:$$$ISERR(tSC)
			Set tSC = $system.OBJ.Compile(tTransformClass.Name,"fk-d")
		}
		Set pTransformationName = tTransName
	}catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Create %Dictionary.ParameterDefinition object for name and default
ClassMethod CreateClassParameter(pName, pDefault) As %Dictionary.ParameterDefinition
{
	Set tParameter = ##class(%Dictionary.ParameterDefinition).%New()
	Set tParameter.Name=pName
	Set tParameter.Default = pDefault
	Quit tParameter
}

/// Given a fully qualified filename and an expected structure return a pRecordSet from a CSV file
/// pStructure is the expected header (ServiceName [VARCHAR 200], OperationsName, PortIn) structure but the code will adapt to a different order
/// pRecordSet is the returned resultset
ClassMethod ParseCSV(pStream As %Stream.FileCharacter, Output pStructure As %String = "", Output pRecordSet As %SQL.CSVResultSet, pDelimiter = ",") As %Status
{
	New %sqlcontext
	#dim %sqlcontext as %Library.ProcedureContext = ##class(%Library.ProcedureContext).%New()

	Set pQuote= """"
	try {
		Set tSC = $$$OK
		/// get file header and fix terminators if required
		Do pStream.Rewind()
		If pStream.Size=0 {
			Set tSC = $$$ERROR($$$GeneralError,$$$Text("File is empty","Ensemble"))
			Quit
		}
		Set tFileHeader = pStream.ReadLine()
		Do pStream.Rewind()
		If $f(tFileHeader,$c(13)) {
			Set tFileHeader=$zstrip(tFileHeader,">",$c(13))
			/// Sometimes we see $c(13,10) on unix, so if we see a $c(13) in the header change LineTerminators
			Set pStream.LineTerminator = $c(13,10)
		}
		/// Need to build a header for the parser, fix case issues and get column order correct
		Set tStructure=""
		For tIdx = 1:1:$l(tFileHeader,pDelimiter) {
			Set tColumn = $zstrip($p(tFileHeader,pDelimiter,tIdx),"<>W",$c(34))
			Set tUpperColumn = $zcvt(tColumn,"U")
			If $D(tStruct(tUpperColumn,"Key"),tKey) {
				Set tStructure = tStructure_pDelimiter_tKey_" "_tStruct(tUpperColumn,"Type")
			} Else {
				Set tStructure = tStructure _ ","_tColumn_" VARCHAR(1024)"
			}
			Set tStructFound(tUpperColumn)=""
			Set pStructure(tColumn)=tIdx
		}

		Set tStructure = $E(tStructure,2,*)  // strip leading delimiter
		Set tStream=pStream
		set tPreparedStatement = ##class(%SQL.DynamicStatement).Prepare($system.Util.CreateGUID(),tStructure,,,,,,"CSV")
		if $Isobject(tPreparedStatement) {
			set tResult = tPreparedStatement.%New(tPreparedStatement,,tStream,pDelimiter,pQuote)
			do %sqlcontext.AddResultSet(tResult)
		}
	} catch tException {
		set %sqlcontext.%SQLCODE = tException.AsSQLCODE()
		set %sqlcontext.%Message = tException.AsSQLMessage()
	}


	If %sqlcontext.%SQLCODE<0 {
		#dim tEx As %Exception.SQL
		Set tEx = ##class(%Exception.SQL).CreateFromSQLCODE(%sqlcontext.%SQLCODE, %sqlcontext.%Message)
		Quit tEx.AsStatus()
	}
	
	set pRecordSet = %sqlcontext.NextResult()
	
	Quit tSC
}

/// Convert Configuration JSON stream to csv stream
ClassMethod GetConfigurationCSVStreamFromJSON(pJSONStream, Output pCSVStream As %Stream.FileCharacter = "", pGroup) As %Status
{
	#define WriteKeyValue(%stream,%key,%value,%description) Do %stream.WriteLine($c(34)_%key_$c(34)_","_$c(34)_%value_$c(34)_","_$c(34)_%description_$c(34))
	If '$IsObject(pCSVStream) {
		Set pCSVStream = ##class(%Stream.FileCharacter).%New()
	} ElseIf 'pCSVStream.%IsA("%Stream.FileCharacter") {
		Quit $$$ERROR($$$GeneralError,$$$Text("Only %Stream.FileCharacter is supported","Ensemble"))
	}
	Set pGroup = {}.%FromJSON(pJSONStream)
	Set tKeys = pGroup.Keys
	Set tIterator = tKeys.%GetIterator()
	While tIterator.%GetNext(.tKey,.tValue) {
		$$$WriteKeyValue(pCSVStream,tValue.Key,tValue.Value,tValue.Description)
	}
	Do pCSVStream.Rewind()
	Quit $$$OK
}

/// Convert Items JSON stream to csv stream<br>
/// Although streams are used to make it easier to pass from a file or other mechanism, the maximum length of the document is that of a long string 
ClassMethod GetItemsCSVStreamFromJSON(pJSONStream, Output pCSVStream As %Stream.FileCharacter = "", pGroup, pIncludesHeader = 1) As %Status
{
	If '$IsObject(pCSVStream) {
		Set pCSVStream = ##class(%Stream.FileCharacter).%New()
	} ElseIf 'pCSVStream.%IsA("%Stream.FileCharacter") {
		Quit $$$ERROR($$$GeneralError,$$$Text("Only %Stream.FileCharacter is supported","Ensemble"))
	}
	Set pGroup = {}.%FromJSON(pJSONStream)
	Set tItems = pGroup.Items
	Set tIterator = tItems.%GetIterator()
	If 'tIterator.%GetNext(.tKey,.tItem) {
		Quit $$$ERROR($$$GeneralError,$$$Text("No items found","Ensemble"))
	}
	If 'pIncludesHeader {
		// when there is no header, read through the records building the header row into tHeader(idx)=Name
		Set tIterator = tItems.%GetIterator()
		While tIterator.%GetNext(.tKey,.tRow) {
			Set tRowIterator = tRow.%GetIterator()
			While tRowIterator.%GetNext(.tRowKey,.tRowValue) {
				If '$D(tHeaderValues(tRowKey)) {
					Set tHeader($i(tHeader))=tRowKey
					Set tHeaderValues(tRowKey)=tHeader
				}
			}
		}
	} Else {
		// use the header row to build tHeader(idx)=Name
		Set tHeaderRow = tItem
		Set tHeaderIterator = tHeaderRow.%GetIterator()
		While tHeaderIterator.%GetNext(.tHeaderKey,.tValue) {
			Set tHeader($i(tHeader))=tHeaderKey
		}
	}
	Set tIterator = tItems.%GetIterator()
	If pIncludesHeader { Do tIterator.%GetNext(.tKey,.tValue) }  // already built header
	/// output header
	Set tString = ""
	For tIdx = 1:1:tHeader {
		Set tString=tString_","_$c(34)_tHeader(tIdx)_$c(34)
	}
	Do pCSVStream.WriteLine($E(tString,2,*))
	
	While tIterator.%GetNext(.tKey,.tValue) {
		Set tString=""
		For tIdx = 1:1:tHeader {
			Set tString=tString_","_$c(34)_$property(tValue,tHeader(tIdx))_$c(34)
		}
		Set tString=$e(tString,2,*)
		Do pCSVStream.WriteLine(tString)
	}
	Do pCSVStream.Rewind()
	Quit $$$OK
}

/// User Override: 
/// Using the given transform it's possible to customize the generated transform<br>
/// Example (change code mode):<br>
/// 	try {<br>
/// 		Set tSC = $$$OK
/// 		Set tGroup = ##class(Ens.DTL.Group).%New()<br>
/// 		Set tAction = ##class(Ens.DTL.Code).%New()<br>
/// 		Do tAction.Code.Write(" /*"_$c(13,10)_"DATE: YYYY-MM-DD"_$C(13,10)_"TASK: TASK000000"_$c(13,10)_"NAME: DeveloperName"_$C(13,10)_"NOTE: Initial Development"_$c(13,10)_" */")<br>
/// 		Do tGroup.Actions.Insert(tAction)<br>
/// 		Do pTransform.Actions.InsertAt(tGroup,1)<br>
/// 	} catch ex {<br>
/// 			Set tSC = ex.AsStatus()<br>
/// 	}<br>
ClassMethod UpdateDTL(pTransform As Ens.DTL.Transform) As %Status [ CodeMode = expression ]
{
$$$OK
}

}

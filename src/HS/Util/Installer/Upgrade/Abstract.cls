Include (HS.Upgrade, HS.HC)

///  ^HS.Upgrade("Product",product,"CurrentVersion")=tVersion  $$$ProductCurrentVersion(product,namespace)
///  ^HS.Upgrade("Product",product,"UpgradeVersionSteps",tVersion,tStep)=tSC  $$$ProductVersionStep(product,namespace,tVersion,tStep) or tStep="*" for all (in a kill)
/// new install needs to set the version to the current version and not run an upgrade
/// 
/// <example>
/// 	///Upgrade is a generic upgrade step for HealthShare Information Exchange/Unified Care Record namespaces that are shared across multiple gateways.  
/// 		///Use UpgradeStep1,UpgradeStep2, executed in order 1...N
/// 		///UpgradeSteps in HSLIB are only applied to Information Exchange/Unified Care Record namespaces. 
/// ClassMethod UpgradeStep1(ByRef pLogFile As %File) as %Status {
/// 	///Do some work
/// 	Quit $$$OK
/// }
/// ClassMethod UpgradeStep2(ByRef pLogFile As %File) as %Status {
/// 	///Do some additional work
/// 	Quit $$$OK
/// }
/// ///Core is for security or system level tasks for any HealthShare Application using HSLIB, such as Patient Index, Health Insight, etc.
/// ClassMethod CoreStep1(ByRef pLogFile As %File) as %Status {
/// 	///Do some work
/// 	Quit $$$OK
/// }
/// ClassMethod CoreStep2(ByRef pLogFile As %File) as %Status {
/// 	///Do some additional work
/// 	Quit $$$OK
/// }
/// ///Upgrade Hub in as many steps as required executed in order 1...N
/// ClassMethod HubStep1(ByRef pLogFile As %File) as %Status {
/// 	///Do some work
/// 	Quit $$$OK
/// }
/// ///Upgrade Access Gateway in as many steps as required executed in order 1...N
/// ClassMethod AccessGatewayStep1(ByRef pLogFile As %File) as %Status {
/// 	///Do some work
/// 	Quit $$$OK
/// }
/// ///Upgrade Edge Gateway in as many steps as required executed in order 1...N
/// ClassMethod EdgeGatewayStep1(ByRef pLogFile As %File) as %Status {
/// 	///Do some work
/// 	Quit $$$OK
/// }
/// ///Upgrade Flash Gateway in as many steps as required executed in order 1...N
/// ClassMethod FlashGatewayStep1(ByRef pLogFile As %File) as %Status {
/// 	///Do some work
/// 	Quit $$$OK
/// }
/// ///Upgrade Bus in as many steps as required executed in order 1...N
/// ClassMethod BusStep1(ByRef pLogFile As %File) as %Status {
/// 	///Do some work
/// 	Quit $$$OK
/// }
/// 
/// 	/// To have code execute after the production startup
/// 	/// Set ^HS.Upgrade("OnStart",$i(^HS.Upgrade("OnStart")))=$lb(class,method)
/// 	Set ^HS.Upgrade("OnStart",$i(^HS.Upgrade("OnStart")))=$lb("HS.Util.Installer.Upgrade.V7","ConvertPushDocuments")
/// 	///	Where the method must have a status return value
/// </example>
Class HS.Util.Installer.Upgrade.Abstract Extends %RegisteredObject [ Abstract ]
{

/// Set up an array of methods defined for the upgrade
///  pAry(type,seq)=name
///  where type= "Hub", "EdgeGateway", "AccessGateway", "FlashGateway", "Core"
ClassMethod UpgradeMethods(pProduct = "", pType, pAry As %String, pKeep = 0) As %Status [ CodeMode = generator, ProcedureBlock = 1 ]
{
	// CoreSteps run for all types across all applications.
	// UpgradeSteps are used for generic HSLIB steps (ie: steps shared across all gateway types), when pType'="Foundation".
	// UpgradeSteps are also used as the steps for other applications that have pType="Foundation".
	// HSLIB UpgradeSteps should not by applied to any other applications.
	
	// Conditions for applying steps:
	// If pType=tType - Run tTypeStep
	// If pProduct=HSLIB and pType'=Foundation - Run CoreStep and/or UpgradeStep
	// If pProduct'=HSLIB and pType=Foundation - Run UpgradeStep
	// If pProduct=HSLIB and pType=Foundation - Run CoreStep
	
	If %classname="HS.Util.Installer.Upgrade.Abstract" quit $$$OK
	Set %code=0
	$$$GENERATE("	Kill:'pKeep pAry")
	Set tDef=##class(%Dictionary.ClassDefinition).%OpenId(%class)
	Set tVersion=$e($p(%classname,".",$l(%classname,".")),2,*)
	For tIdx=1:1:tDef.Methods.Count() {
		Set tName=tDef.Methods.GetAt(tIdx).Name
		If $E(tName,1,2)="On" Continue
		If tName'?1.e1"Step"1.n Continue
		Set tType=$p(tName,"Step",1),seq=$p(tName,"Step",2)
		If ",Hub,EdgeGateway,AccessGateway,Bus,Layout,Core,Upgrade,FlashGateway,"'[(","_tType_",") Continue
		// Setup local array to sort steps in numeric order
		If tType="Core" Set tType=" "_tType
		Set tArray(tType,seq)=tName
	}
	
	// Now build generated code for each step using local array to maintain numeric order
	Set tTypeIdx="",tType="",tSeq="",tName=""
	For  {
		Set tTypeIdx=$o(tArray(tTypeIdx)) q:tTypeIdx=""
		For  { 
			Set tSeq=$o(tArray(tTypeIdx,tSeq)) q:tSeq=""
			Set tName=tArray(tTypeIdx,tSeq)
			Set tType=$tr(tTypeIdx," ","")
			$$$GENERATE("	Set tStepName="""_tName_"""")
			// tRunStatus - Has this step been run before?
			$$$GENERATE("	Set tRunStatus=$G($$$ProductVersionStep(pProduct,$namespace,"_tVersion_",tStepName))")
			$$$GENERATE("	Set tRunCheck=((pType=""Core"") || ($namespace'=""HSSYS""))")
			$$$GENERATE("	Set tCoreStep="_(tType="Core"))				// Is this a CoreStep?
			$$$GENERATE("	Set tUpgradeStep="_(tType="Upgrade"))		// Is this an UpgradeStep?
			$$$GENERATE("	Set tFoundation=(pType=""Foundation"")")	// Is this a Foundation Type Config?
			$$$GENERATE("	Set tHSLIB=(pProduct=""HSLIB"")")			// Is this Product HSLIB or another library DB?
			$$$GENERATE("	Set tRunHSPIHub=(pProduct=""HSPILIB""&&(pType=""Hub""))")	// Is this a Standalone HSPI integrated into the Registry?
			
			$$$GENERATE("	Set tRunType=(pType="""_tType_""")")		
			$$$GENERATE("	Set tRunCore=(pProduct=""HSLIB""&&(pType=""Foundation"")&&(tCoreStep))")
			$$$GENERATE("	Set tRunUpg=(pProduct'=""HSLIB""&&(pType=""Foundation"")&&(tUpgradeStep))")
			$$$GENERATE("	Set tRunCU=(pProduct=""HSLIB""&&(pType'=""Foundation"")&&(tCoreStep||tUpgradeStep))")
			
			$$$GENERATE("	If tRunStatus'=1,tRunCheck {")
			$$$GENERATE("		If (tRunType || tRunCore || tRunUpg || tRunCU || tRunHSPIHub) {")
			$$$GENERATE("			Set pAry($i(pAry))=$lb(..%ClassName(1),tStepName,"""_tType_""","_tSeq_","_tVersion_",pProduct,tRunStatus)")
			$$$GENERATE("		}")
			$$$GENERATE("	}")
		}
	}
	$$$GENERATE("	Quit $$$OK")
	Quit $$$OK
}

ClassMethod LayoutUpgrade(ByRef pLogFile As %File) As %Status
{
	#Dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK, tType = "Layout"
	#; tVersion is info following V of class HS.Util.Installer.Upgrade.V1 returned as V1 so 1
	Set tVersion=$e(..%ClassName(0),2,*)
	Do ..UpgradeMethods("HSLIB",tType,.tAry)
	For tIdx=1:1:$g(tAry) { 
		Set tItem=$li(tAry(tIdx),2)
		If $$$ISOK($g($$$LayoutVersionStep(tVersion,tItem))) Continue  /// already processed
		Try {
			Do ##class(HS.HC.Util.Installer).Log(.pLogFile,..%ClassName(1),"LayoutUpgrade",$namespace_":Upgrade:"_tItem_" started")
			Set tSC=$zobjclassMethod(..%ClassName(1),tItem,.pLogFile)
		} Catch eException {
			Set tSC = eException.AsStatus()
		}
		Do ##class(HS.HC.Util.Installer).Log(.pLogFile,..%ClassName(1),"LayoutUpgrade",$namespace_":Upgrade:"_tItem_$S($$$ISOK(tSC):" OK",1:" failed "_$system.Status.GetErrorText(tSC)))
		Set $$$LayoutVersionStep(tVersion,tItem)=tSC
		If $$$ISERR(tSC) Quit 
	}
	If $$$ISOK(tSC) && ($g($$$LayoutVersion($namespace))<tVersion) {
		Set $$$LayoutVersion($namespace)=tVersion
	}
	Quit tSC
}

/// For initial upgrade - fix up production base class
ClassMethod FixBaseClass() As %Status
{
	Set tSC=$$$OK
	Do {
		//Note - this will be one of the first things done - the class
		//will get recompiled by a later step
		Do ##class(Ens.Director).ParseConfigItemName("",.tProdClass)
		IF tProdClass="" {Set tSC=$$$HSErrorNoLog($$$HSErrCantFindCurrentProduction) QUIT}
		Set tProdCref=##Class(%Dictionary.ClassDefinition).%OpenId(tProdClass)
		If tProdCref="" Set tSC=$$$HSErrorNoLog($$$HSErrCantOpenProduction,tProdCref)
		//fix superclass
		If tProdCref.Super="Ens.Config.Production"!(tProdCref.Super="Ens.Production") {
			Set tProdCref.Super="HS.Util.AbstractProduction"
		}
		//get rid of OnStart methods so that the superclass method will run
		Set tKey=""
		For {
			s tMethod=tProdCref.Methods.GetNext(.tKey) Quit:tKey=""
			IF tMethod.Name="OnStart" {
				Do tProdCref.Methods.RemoveAt(tKey)
				Quit
			}
		}
		Set tSC=tProdCref.%Save()
	} While 0
	Quit tSC
}

/// Call this to open the current production in order to modify it
ClassMethod OpenCurrentProduction(Output pProdRef As Ens.Config.Production) As %Status
{
	Do ##class(Ens.Director).ParseConfigItemName("",.tProdClass)
	IF tProdClass="" Quit $$$HSErrorNoLog($$$HSErrCantFindCurrentProduction)
	Set pProdRef = ##class(Ens.Config.Production).%OpenId(tProdClass)
	IF pProdRef="" Quit $$$HSErrorNoLog($$$HSErrCantOpenProduction,tProdClass)
	Quit $$$OK
}

/// Call this to open a sample production in order to copy config items and settings from it
ClassMethod OpenProduction(pProdClass As %String, Output pProdRef As Ens.Config.Production) As %Status
{
	Quit ##Class(Ens.Util.XML.Reader).ObjectFromXData(.pProdRef,pProdClass,"ProductionDefinition","Ens.Config.Production")
}

/// Call this to copy config item pItemClassName from sample production pFromProd
/// to exisitng production pToProd
/// This does not save pToProd
/// pItemConfigName is optional, to support using the same class name in more than one config item.
ClassMethod AddConfigItem(pFromProd As Ens.Config.Production, pItemClassName, pToProd As Ens.Config.Production, pItemConfigName As %String = "") As %Status
{
	#dim tItem As Ens.Config.Item
	#dim tFromItem As Ens.Config.Item
	Set tFromItem=""
	For tI=1:1:pFromProd.Items.Count() {
		Set tItem=pFromProd.Items.GetAt(tI)
		If pItemConfigName'="",tItem.Name'=pItemConfigName CONTINUE
		If tItem.ClassName=pItemClassName {Set tFromItem=tItem Quit}
	}
	If tFromItem="" Quit $$$HSErrorNoLog($$$HSErrCantFindConfigItem,pItemClassName,pFromProd.Name)
	Set tFound=0
	For tI=1:1:pToProd.Items.Count() {
		Set tItem=pToProd.Items.GetAt(tI)
		If pItemConfigName'="",tItem.Name'=pItemConfigName CONTINUE
		If tItem.ClassName=pItemClassName {Set tFound=1 Quit}
	}
	If tFound Quit $$$OK  //already there, no need to add it
	Set tSC=pToProd.Items.Insert(tFromItem)
	Quit tSC
}

/// Add configuration items from one production into an existing production, and save the new production
ClassMethod MergeConfigItems(pNamespace As %String, pFromName As %String, pToName As %String) As %Status
{
	new $namespace
	Try {
 		Set $namespace=pNamespace
 		Set tSC=..OpenProduction(pFromName,.tFromProd) Throw:$$$ISERR(tSC)
		Set tToProd=##class(Ens.Config.Production).%OpenId(pToName,,.tSC) Throw:$$$ISERR(tSC)
		For tI=1:1:tFromProd.Items.Count() {
			Set tItem=tFromProd.Items.GetAt(tI)
			Set tSC=..AddConfigItem(tFromProd,tItem.ClassName,tToProd) 
			Quit:$$$ISERR(tSC)
		}
	} 
	Catch {
		Set:$$$ISOK(tSC) tSC=$$$ERROR($$$ObjectScriptError,$ZE)
	}
	
	Set:$$$ISOK(tSC) tSC=..SaveProduction(tToProd)
	Kill tToProd,tFromProd,tItem
	
	Quit tSC
}

/// Check to see if a config item with the specified class name exists in the production.
ClassMethod ConfigItemExists(pProd As Ens.Config.Production, pItemClassName As %String) As %Boolean
{
	#dim tItem As Ens.Config.Item
	Set tFound=0
	For tI=1:1:pProd.Items.Count() {
		Set tItem=pProd.Items.GetAt(tI)
		If tItem.ClassName=pItemClassName Set tFound = 1 Quit
	}
	Quit tFound
}

/// Find the value of setting pSetting on item pItemClassName in production oref pProd
ClassMethod GetItemSetting(pProd As Ens.Config.Production, pItemClassName As %String, pSettingName As %String, Output pSettingValue As %String) As %Status
{
	#dim tSetting As Ens.Config.Setting
	#dim tItem As Ens.Config.Item
	Set tFound=0
	DO {
		For tI=1:1:pProd.Items.Count() {
			Set tItem=pProd.Items.GetAt(tI)
			If tItem.ClassName'=pItemClassName Continue
			For tJ=1:1:tItem.Settings.Count()
			{
				Set tSetting=tItem.Settings.GetAt(tJ)
				If tSetting.Name'=pSettingName Continue
				Set tFound=1,tSC=$$$OK
				Set pSettingValue=tSetting.Value
				Quit
			}
			Quit:tFound
		}
		If 'tFound Set tSC=$$$HSErrorNoLog($$$HSErrCantFindConfigItem,pItemClassName,pProd.Name)

	} While 0
	Quit tSC
}

/// Update the value of setting pSetting on item pItemClassName in production oref pProd
ClassMethod SetItemSetting(pProd As Ens.Config.Production, pItemClassName As %String, pSettingName As %String, pSettingValue As %String) As %Status
{
	#dim tSetting As Ens.Config.Setting
	#dim tItem As Ens.Config.Item
	Set tFound=0
	DO {
		For tI=1:1:pProd.Items.Count() {
			Set tItem=pProd.Items.GetAt(tI)
			If tItem.ClassName'=pItemClassName Continue
			For tJ=1:1:tItem.Settings.Count()
			{
				Set tSetting=tItem.Settings.GetAt(tJ)
				If tSetting.Name'=pSettingName Continue
				Set tSetting.Value=pSettingValue
				Set tFound=1,tSC=tItem.Settings.SetAt(tSetting,tJ)
				Quit
			}
			Quit:tFound
		}
		If 'tFound Set tSC=$$$HSErrorNoLog($$$HSErrCantFindConfigItem,pItemClassName,pProd.Name)

	} While 0
	Quit tSC
}

/// Add setting pSetting on item pItemClassName in production oref pProd, with target pTarget and 
ClassMethod AddItemSetting(pProd As Ens.Config.Production, pItemClassName As %String, pSettingName As %String, pSettingValue As %String, pTarget As %String) As %Status
{
	#dim tSetting As Ens.Config.Setting
	#dim tItem As Ens.Config.Item
	Set tFound=0, tFoundItem=0, tSC=$$$OK
	DO {
		For tI=1:1:pProd.Items.Count() {
			Set tItem=pProd.Items.GetAt(tI)
			If tItem.ClassName'=pItemClassName Continue
			Set tFoundItem=1
			For tJ=1:1:tItem.Settings.Count() {
				IF tItem.Settings.GetAt(tJ).Name'=pSettingName Continue
				Set tFound=1
				Quit
			}
			Quit:tFound  //if setting is already present, leave it alone
			Set tSetting=##Class(Ens.Config.Setting).%New()
			Set tSetting.Name=pSettingName, tSetting.Target=pTarget, tSetting.Value=pSettingValue
			Do pProd.Items.GetAt(tI).Settings.Insert(tSetting)
		}
		If 'tFoundItem Set tSC=$$$HSErrorNoLog($$$HSErrCantFindConfigItem,pItemClassName,pProd.Name)

	} While 0
	Quit tSC
}

/// Add setting pSetting on item pItemName in production oref pProd, with target pTarget and 
ClassMethod AddItemSettingByName(pProd As Ens.Config.Production, pItemName As %String, pSettingName As %String, pSettingValue As %String, pTarget As %String) As %Status
{
	#dim tSetting As Ens.Config.Setting
	#dim tItem As Ens.Config.Item
	Set tFound=0, tFoundItem=0, tSC=$$$OK
	DO {
		For tI=1:1:pProd.Items.Count() {
			Set tItem=pProd.Items.GetAt(tI)
			If tItem.Name'=pItemName Continue
			Set tFoundItem=1
			For tJ=1:1:tItem.Settings.Count() {
				IF tItem.Settings.GetAt(tJ).Name'=pSettingName Continue
				Set tFound=1
				Quit
			}
			Quit:tFound  //if setting is already present, leave it alone
			Set tSetting=##Class(Ens.Config.Setting).%New()
			Set tSetting.Name=pSettingName, tSetting.Target=pTarget, tSetting.Value=pSettingValue
			Do pProd.Items.GetAt(tI).Settings.Insert(tSetting)
		}
		If 'tFoundItem Set tSC=$$$HSErrorNoLog($$$HSErrCantFindConfigItem,pItemName,pProd.Name)

	} While 0
	Quit tSC
}

/// Add a setting to pProd (oref)
ClassMethod AddProductionSetting(pProd As Ens.Config.Production, pSettingName As %String, pSettingValue As %String) As %Status
{
	#dim tSetting As Ens.Config.Setting
	DO {
		Set tFound=0
		For tI=1:1:pProd.Settings.Count() {
			Set tSetting=pProd.Settings.GetAt(tI)
			If tSetting.Name=pSettingName {
				Set pProd.Settings.GetAt(tI).Value=pSettingValue,tFound=1
				Quit
			}
		}
		If tFound {Set tSC=$$$OK Quit}
		Set tSetting=##Class(Ens.Config.Setting).%New()
		Set tSetting.Target="Production"
		Set tSetting.Name=pSettingName
		Set tSetting.Value=pSettingValue
		Set tSC=pProd.Settings.Insert(tSetting)
	} While 0
	Quit tSC
}

/// Call this to copy config item pItemClassName from sample production pFromProd
/// to exisitng production pToProd
/// This does not save pToProd
ClassMethod RemoveConfigItem(pFromProd As Ens.Config.Production, pItemClassName) As %Status
{
	#dim tItem As Ens.Config.Item
	#dim tFromItem As Ens.Config.Item
	Set tSC=$$$OK
	For tI=pFromProd.Items.Count():-1:1 {
		Set tItem=pFromProd.Items.GetAt(tI)
		If tItem.ClassName=pItemClassName {do pFromProd.Items.RemoveAt(tI)}
	}
	Quit tSC
}

/// Set ConfigItem property to a specified value
/// pProd: Prod ref
/// pItemName: Config item name
/// pName: Property name
/// pValue: Property value
ClassMethod SetItemProperty(pProd As Ens.Config.Production, pItemName As %String, pName As %String, pValue As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		#Dim tItem As Ens.Config.Item
		Set i=""
		For { 
			Set tItem=pProd.Items.GetNext(.i) Quit:i=""
			If tItem.Name=pItemName {
				Set $property(tItem,pName)=pValue
				Quit
			}
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}	
	Quit tSC
}

/// Save pProd (oRef)
ClassMethod SaveProduction(pProd As Ens.Config.Production) As %Status
{
	Do {
		Set tSC=pProd.%Save() Quit:$$$ISERR(tSC)
		Set tSC=pProd.SaveToClass() Quit:$$$ISERR(tSC)
		Set tProdClass=pProd.Name
		Set tSC = $System.OBJ.Compile(tProdClass,"-d") Quit:$$$ISERR(tSC)
		// Only reload on IRIS versions starting with 2020.1
		// Needed to reswizzle
		If ($System.Version.GetMajor() >= 2020) {
			Set tSC = pProd.%Reload() Quit:$$$ISERR(tSC)
		}
	} While 0
	Quit tSC
}

/// Put an entry in the AsyncOpQ in ^HS.Upgrade.
/// HS.Util.MaintenanceService will run at intervals set by the production (default = 60 secs)
///  and will submit up to 200 of these requests for processing
/// ^HS.Upgrade("AsyncOpQ",n)=dispatchname,messageclass,messageid
ClassMethod InvokeAsyncOperation(pOpDispatchName, pRequest As Ens.Request, Output pQnum) As %Status
{
	Set tSC=$$$OK
	Do {
		Set tSC=pRequest.%Save() Quit:$$$ISERR(tSC)
		Set pQnum=$I(^HS.Upgrade("AsyncOpQ")),^HS.Upgrade("AsyncOpQ",pQnum)=$LB(pOpDispatchName,pRequest.%ClassName(1),pRequest.%Id())
	} While 0
	Quit tSC
}

/// Get the next AsyncOpQ entry (if any), and return its dispatchname and opened message
///  with its sequence number in pQnum
ClassMethod GetAsyncOperation(Output pOpDispatchName, Output pRequest As Ens.Request, Output pQnum) As %Status
{
	Set tSC=$$$OK
	Do {
		Set pQnum=$O(^HS.Upgrade("AsyncOpQ","")) Quit:'pQnum
		Set tStuff=^HS.Upgrade("AsyncOpQ",pQnum)
		Set pOpDispatchName=$LI(tStuff),tClass=$LI(tStuff,2),tID=$LI(tStuff,3)
		Set pRequest=$ZobjClassMethod(tClass,"%OpenId",tID)
	} While 0
	Quit tSC
}

/// Close a successfully processed AsyncOpQ entry
ClassMethod AsyncOperationComplete(pQnum)
{
	//don't delete the request -- ens.purge will do that
	//Set tStuff=$G(^HS.Upgrade("AsyncOpQ",pQnum)) Quit:tStuff=""
	//Set tClass=$LI(tStuff,2),tID=$LI(tStuff,3)
	//Do $ZobjClassMethod(tClass,"%DeleteId",tID)
	Kill ^HS.Upgrade("AsyncOpQ",pQnum)
}

/// For each patient (that has not yet been converted), convert the patient for
///  each version that needs it and has an OnPatient() method
ClassMethod ConvertPatients(ByRef %OnStartLogFile As %File) As %Status
{
 // ^HS.Upgrade("OnStart","OnPatient")="V1,V2,..."					versions to call OnPatient()
 // ^HS.Upgrade("OnStart","OnPatient","Last")=pPatId				last-processed patient id (initially 0)
 // ^HS.Upgrade("OnStart","OnPatient","End")=pPatId					last patient id that needs to be processed (later are new)
 // ^HS.Upgrade("OnStart","OnPatient","Converted",pPatId)=""		individually-processed patient id
 // ^HS.Upgrade("OnStart","OnPatient","Error",pPatId)=status		conversion (or lock) failed
 set tSC=$$$OK
 set tEnd=^HS.Upgrade("OnStart","OnPatient","End")
 set tLast=^HS.Upgrade("OnStart","OnPatient","Last")  // restartable
 //tGlobal - for versions up thru 9, before the streamlet ECR, use ^PAPER.  For V10 and above,
 //use the streamlet index.  This code is written for V9 and will require testing in future versions ***to do SDA3
 Set tGlobal="^PAPER"
 IF (^HS.Upgrade("OnStart","OnPatient")_",")'["V9," Set tGlobal="^HS.SDAStreamletMRN(""Key"")"
 do ##class(HS.HC.Util.Installer).Log(.%OnStartLogFile,"HS.Util.Installer.Upgrade.Abstract","ConvertPatients","Patient Conversion started")

 // First retry any errors, they may have been resolved now
 set tPatId="",tMark=1,tCount=0
 for {
	set tPatId=$o(^HS.Upgrade("OnStart","OnPatient","Error",tPatId)) quit:tPatId=""
	do ##class(HS.HC.Util.Installer).Log(.%OnStartLogFile,"HS.Util.Installer.Upgrade.Abstract","ConvertPatients","Retrying Patient "_tPatId)
	if '$d(@tGlobal@(tPatId))  kill ^HS.Upgrade("OnStart","OnPatient","Error",pPatId) continue  // patient has been deleted or reset
	set tOK=..ConvertPatient(tPatId,tMark,.%OnStartLogFile)
	if $$$ISERR(tOK) {
		set text="Conversion failed for "_tPatId_" : "_$system.Status.GetErrorText(tOK)
		do ##class(HS.HC.Util.Installer).Log(.%OnStartLogFile,"HS.Util.Installer.Upgrade.Abstract","ConvertPatients",text)
		set tSC=tOK,^HS.Upgrade("OnStart","OnPatient","Error",tPatId)=tOK // continue on error
	}
	else {set tCount=tCount+1}
 } 

 // Then the main loop over all patients not yet converted
 set tPatId=$o(@tGlobal@(tLast)),tMark=0
 if tPatId'=""&&(tPatId'>tEnd) {
	 set text="Patient Conversion started for Ids "_tPatId_" to "_tEnd
	 do ##class(HS.HC.Util.Installer).Log(.%OnStartLogFile,"HS.Util.Installer.Upgrade.Abstract","ConvertPatients",text)
	 set tPatId=tLast
	 for {
		set tPatId=$o(@tGlobal@(tPatId)) quit:tPatId=""  quit:tPatId>tEnd
		set tOK=..ConvertPatient(tPatId,tMark,.%OnStartLogFile)
		if $$$ISERR(tOK) {
			set text="Conversion failed for "_tPatId_" : "_$system.Status.GetErrorText(tOK)
			do ##class(HS.HC.Util.Installer).Log(.%OnStartLogFile,"HS.Util.Installer.Upgrade.Abstract","ConvertPatients",text)
			set tSC=tOK,^HS.Upgrade("OnStart","OnPatient","Error",tPatId)=tOK // continue on error
		}
		set ^HS.Upgrade("OnStart","OnPatient","Last")=tPatId
		// log every 10,000 records
		set tCount=tCount+1
		if '(tCount#10000) do ##class(HS.HC.Util.Installer).Log(.%OnStartLogFile,"HS.Util.Installer.Upgrade.Abstract","ConvertPatients",tCount_" patients processed")
		set ^HS.Upgrade("OnStart","OnPatient","Last")=tPatId
	 }
 }

 set text="Patient Conversion ended, "_tCount_" patients processed."
 // if no errors, delete all the Upgrade info which will stop further Patient conversions
 if tSC {
	kill ^HS.Upgrade("OnStart","OnPatient")
	set text=text_" No errors."}
 else {
	set text=text_" Errors found, see ^HS.Upgrade(""OnStart"",""OnPatient"",""Error"",pPatId)"
 }
 do ##class(HS.HC.Util.Installer).Log(.%OnStartLogFile,"HS.Util.Installer.Upgrade.Abstract","ConvertPatients",text)
 quit tSC
}

/// Called for patient actions during the update.  pPrior is the prior MRNs for merges, moves, etc. - it might be null
ClassMethod CheckMRNs(pPriorMRN, pCurrentMRN) As %Status
{
 	Set tPrior=""
 	IF ^HS.Upgrade("OnStart","OnPatient")_","["V9," {
	 	set tSC = $$$ERROR($$$GeneralError, "Upgrades from this version of HealthShare are no longer supported. Please contact ISC Support.")
	 	quit tSC
 	} Else {
	 	If pPriorMRN'="" {Set tPrior=$G(^HS.SDAStreamletMRN("MRN",pPriorMRN))}
	 	Set tCurrent=$G(^HS.SDAStreamletMRN("MRN",pCurrentMRN))
 	}
	If tPrior'="" Set tSC=..ConvertPatient(tPrior) Quit:$$$ISERR(tSC) tSC
	If tCurrent'="" Set tSC=..ConvertPatient(tCurrent) Quit:$$$ISERR(tSC) tSC
	Quit $$$OK
}

/// Perform all the version conversions for one patient
/// It should be called any time a patient is to be processed, and a Patient conversion is
///  in progress.
/// pPatID is the aggregation ID in the streamlet ECR, and for converting old systems, the patient ID in the HSDB
ClassMethod ConvertPatient(pPatId As %Integer, pMark As %Integer = 1, ByRef %OnStartLogFile As %File = "") As %Status
{
 set tSC=$$$OK,$zt="Trap"
 // If the patient was already (sucessfully) converted, nothing to do
 if '$d(^HS.Upgrade("OnStart","OnPatient","Error",pPatId))&&(pPatId'>^HS.Upgrade("OnStart","OnPatient","Last")) Quit $$$OK
 // If the patient is new, created while conversion is running, nothing to do
 if pPatId>^HS.Upgrade("OnStart","OnPatient","End") Quit $$$OK
 // If the patient was already converted (because user accessed it), nothing to do
 if $d(^HS.Upgrade("OnStart","OnPatient","Converted",pPatId)) Quit $$$OK
 // Semaphore lock, to prevent conflict with any other process 
 lock +^HS.SDA3.StreamletDB(pPatId):20 else  set tSC=$$$HSErrorNoLog($$$HSErrCantLock,"^HS.SDA3.StreamletDB("_pPatId_")") Quit tSC
 TStart
 // for each version in the list, call the OnPatient() method
 set versions=^HS.Upgrade("OnStart","OnPatient")  // e.g. V2,V4,V5
 for i=1:1:$l(versions,",") {
	set v=$p(versions,",",i)
	set tSC=$zobjclassmethod("HS.Util.Installer.Upgrade."_v,"OnPatient",pPatId,.%OnStartLogFile)
	if $$$ISERR(tSC) quit  // stop on error, patient is invalid, others will be converted	 
 }
 if $$$ISERR(tSC) TRollback 1 goto Unlock
 // mark patient as converted (if requested)
 if pMark set ^HS.Upgrade("OnStart","OnPatient","Converted",pPatId)=""
 kill ^HS.Upgrade("OnStart","OnPatient","Error",pPatId)
 TCommit
Unlock if $g(pPatId)'="" lock -^HS.SDA3.StreamletDB(pPatId)
 quit tSC
Trap Set $zt="",tSC=$$$EnsSystemError
  TRollback 1 goto Unlock
}

}

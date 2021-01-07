Include HS.Upgrade

Class HS.Util.Installer.Upgrade.Loader Extends %RegisteredObject
{

/// Version of code base
/// Pass in pIncludeMinor if you want major plus minor
ClassMethod GetCurrentVersion(pProduct = "HSLIB", pIncludeMinor As %Boolean = 0, pConfigItem As HS.Util.Installer.ConfigItem = "")
{
	Set tVersion=""
	If $$$ISOK(##class(%ZHSLIB.HealthShareMgr).ComponentVersion(pProduct,.tVersion,pConfigItem))
	If pIncludeMinor {Set tVersion=+tVersion} //This excludes the build number
	Else {Set tVersion=tVersion\1}
	Quit tVersion
}

/// Version of data (last version installed)
ClassMethod GetVersion(pProduct = "HSLIB", pNS = {$namespace})
{
	Set tCurrentVersion = $G($$$ProductCurrentVersion(pProduct,pNS))
	If (tCurrentVersion="" && (pProduct="HSLIB")) {
		Set tCurrentVersion=$G(^[pNS]HS.Upgrade("CurrentVersion")) // old style HSLIB
		Set $$$ProductCurrentVersion(pProduct,pNS)=tCurrentVersion
		Merge ^HS.Upgrade("Product","HSLIB","UpgradeVersionSteps")=^HS.Upgrade("UpgradeVersionSteps")
		Kill ^[pNS]HS.Upgrade("CurrentVersion")
		Kill ^[pNS]HS.Upgrade("UpgradeVersionSteps")
	}
	Quit tCurrentVersion
}

/// for a particular namespace is it up to date (all methods run successfully)
/// pMethods contains a list of methods which have not run
/// pUpToDate = 1 if no methods are returned
/// pOnlyCurrent - only return the methods from the current version
/// pProducts - a list of products and their version for this namespace (used for SetNSCurrent - where no methods exist)
ClassMethod GetUpgradeMethods(pNS As %String = {$namespace}, ByRef pMethods As %String, Output pUpToDate As %Boolean = 1, pOnlyCurrentVersion As %Boolean = 0, Output pProducts) As %Status
{
	New $namespace
	Set $namespace=pNS
	Set tSC = $$$OK

	Set tComponent = ""
	If pNS="HSSYS" {
		Set tType="Core"
		Set tProducts = ##class(%ListOfDataTypes).%New()
		Do tProducts.Insert("HSLIB")
	} Else {
		Set tComponent = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNS,,.tSC)
		If $$$ISERR(tSC) {
			Quit tSC
		}
		Set tProducts = tComponent.Products
		Set tType = tComponent.Type
	}
	// Add HSLIB as a product if not present to check for potential CoreSteps that may need to be applied.
	Set tHSLIB=0,tHSPIHUB=0
	For tIdx = 1:1:tProducts.Count() {
		Set tProduct=tProducts.GetAt(tIdx)
		Set:tProduct="HSLIB" tHSLIB=1
		If (tProduct="HSPILIB" && (tType="Hub")) Set tHSPIHUB=1
	}
	If tHSPIHUB=1 {
		Set tCurrentVersion = ..GetVersion("HSLIB",pNS)\1
		If tCurrentVersion<=15 {
			// Cleanup HSRegistry Product List
			Set tSC = ..FixRegistryProductList()
			If $$$ISERR(tSC) {
				Quit
			}
			// Re-open tComponent and get Products
			Kill tComponent
			Kill tProducts
			Set tComponent = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNS,,.tSC)
			If $$$ISERR(tSC) {
				Quit tSC
			}
			Set tProducts = tComponent.Products
		}
	}
	If tHSLIB'=1 {
		Do tProducts.Insert("HSLIB")
	}
	// Get upgrade class prefixes and sort them to ensure that upgrade steps defined in HSLIB installer take place before product specific upgrade steps 
	Set tOrderedProducts = ##class(%ListOfDataTypes).%New()
	For tIdx = 1:1:tProducts.Count() {
		Set tProduct=tProducts.GetAt(tIdx)
		If tProduct = "HSLIB" {
			Do tOrderedProducts.InsertAt(tProduct, 1)
		} Else {
			Do tOrderedProducts.Insert(tProduct)
		}
	}
	// Get upgrade methods
	For tIdx = 1:1:tOrderedProducts.Count() {
		Set tProduct=tOrderedProducts.GetAt(tIdx)
		// The only time tComponent should not be an object is for HSSYS, so we use the base ConfigItem call in that case
		Set tUpgradeClassPrefix = $select(
			$isobject(tComponent):	tComponent.GetUpgradeClassPrefix(tProduct),
			1:						##class(HS.Util.Installer.ConfigItem).GetUpgradeClassPrefix(tProduct)
		)
		Set tCurrentVersion = ..GetVersion(tProduct,pNS)\1
		Set tInstalled = ..GetCurrentVersion(tProduct,,tComponent)
		If pOnlyCurrentVersion && (tCurrentVersion="") Set tCurrentVersion=tInstalled
		Set pProducts(tProduct)=tInstalled
		For tIdxVersion = tCurrentVersion:1:tInstalled {
			Set tUpgradeClass = tUpgradeClassPrefix _ tIdxVersion
			// Ensure that we handle the case where a version doesn't have an upgrade class
			If ##class(%Dictionary.CompiledClass).%ExistsId(tUpgradeClass) {
				Set tSC = $$$ADDSC(tSC,$classmethod(tUpgradeClass,"UpgradeMethods",tProduct,tType,.pMethods,1))
			}
		}
	}
	Set pUpToDate='$D(pMethods)
	Quit tSC
}

/// Remove HSPILIB from HSREGISTRY Configuration's Products list when HSPI not installed, or configured as a remote setup
ClassMethod FixRegistryProductList() As %Status
{
	Set tSC = $$$OK
	// If Patient Index is not integrated into HSREGISTRY, remove it from the Products list
	// Check if integrated
	Set tReturn=0
	try {
		Do ##class(Ens.Director).ParseConfigItemName("",.tProductionClass)
		If tProductionClass="" Quit
		Set tProdRef=##class(Ens.Config.Production).%OpenId(tProductionClass)
		Quit:'$IsObject(tProdRef)
		For tIdx=1:1:tProdRef.Items.Count() {
			Set tItem=tProdRef.Items.GetAt(tIdx)
			If tItem.ClassName'="HS.MPI.HSPI.Operations" Continue
			Set tReturn=1 
			Set tIdx2=""
			// Found HS.MPI.HSPI.Operations, now see if it's configured to use a Service to talk to a remote system.
			For {
				Set tSetting = tItem.Settings.GetNext(.tIdx2) Quit:tIdx2=""
				If tSetting.Name = "ServiceName" {
					Set:tSetting.Value'="" tReturn=0 Quit
				}
			}
			Quit
		}	
	} catch ex {
	}
	// tReturn is true if Patient Index integrated into HSREGISTRY.  Quit if True. 
	// tReturn is also true if no Production can be opened, and no changes can be made.
	Set:tProductionClass="" tReturn=1
	If tReturn=1 Quit tSC
	
	// Remove product if False.
	Set tComponent = ##class(HS.Util.Installer.ConfigItem).%OpenId($namespace)
	Set tProducts = tComponent.Products
	For tIdx = 1:1:tProducts.Count() {
		Set tProduct=tProducts.GetAt(tIdx)
		If tProduct="HSPILIB" {
			Do tProducts.RemoveAt(tIdx)
			Do tComponent.%Save()
			Quit
		}
	}
	Quit tSC
}

/// for a particular namespace is it up to date (all methods run successfully)
ClassMethod IsUpToDate(pNS As %String = {$namespace}) As %Boolean
{
	Set tSC = ..GetUpgradeMethods(pNS,,.tUpToDate)
	Quit tUpToDate
}

/// Used to set the current version in a newly created namespace so that we don't try to upgrade 
/// new namespaces 
ClassMethod SetNSCurrent(pNS As %String = {$namespace}) As %Status
{
	Set tComponent = ""
	Set tSC = ..GetUpgradeMethods(pNS,.tMethods,,1,.tProducts)
	If $$$ISERR(tSC) {
		Quit tSC
	}
	Set tIdx=""
	For  {
		Set tIdx=$O(tMethods(tIdx),1,tMethod) Quit:tIdx=""
		Set tProduct = $li(tMethod,6)
		Set tVersion=$li(tMethod,5)
		Set tName=$li(tMethod,2)
		Set $$$ProductVersionStep(tProduct,pNS,tVersion,tName)=1
		If '$D(tProduct(tProduct)) {
			// HSSYS is whitelisted since it is no longer an instance of HS.Util.Installer.ConfigItem as of HS2020.2
			If '$isobject(tComponent) & (pNS '= "HSSYS"){
				Set tComponent = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNS,,.tSC)
				If $$$ISERR(tSC) {
					Quit
				}
			}
			Set tProduct(tProduct)=..GetCurrentVersion(tProduct,,tComponent)
			Set $$$ProductCurrentVersion(tProduct,pNS)=tProduct(tProduct)
		}
	}
	If $$$ISERR(tSC) {
		Quit tSC
	}
	#; if the product doesn't have any version steps nothing will be returned in methods so update the version based on tProducts
	Set tProduct=""
	For  {
		Set tProduct=$O(tProducts(tProduct)) Quit:tProduct=""
		If '$D(tProduct(tProduct)) Set $$$ProductCurrentVersion(tProduct,pNS)=tProducts(tProduct)
	}
	Quit $$$OK
}

/// Upgrade specified namespace on this machine
/// This will first run any steps from the current(old) version that have not been run successfully
/// Then it will run any steps in the intermediate versions and finally any steps in the new
///  (target) version that have not been run successfully.  Note that it is possible that old=target.
/// To get the status of all namespaces run GetUpgradeStatus 
ClassMethod Upgrade(pNS As %String = {$namespace}, ByRef pLogFile As %File) As %Status
{
	New $namespace
	try {
		If pNS'="HSSYS" Do ..Upgrade("HSSYS",.pLogFile)
		Set $Namespace=pNS
		Set tSC = ..GetUpgradeMethods(pNS,.tAry,.tIsUpToDate,,.tProducts) Quit:$$$ISERR(tSC)
		For tIdx=1:1:$g(tAry) { 
			Set tClass=$li(tAry(tIdx),1)
			Set tMethod=$li(tAry(tIdx),2)
			Set tVersion=$li(tAry(tIdx),5)
			Set tProduct=$li(tAry(tIdx),6)
			do ##class(HS.HC.Util.Installer).Log(.pLogFile,tClass,"Upgrade",$namespace_":"_tMethod_" started")
			try {
				Set tSC=$zobjclassMethod(tClass,tMethod,.pLogFile)
			} catch eException {
				Set tSC = eException.AsStatus()
				do ##class(HS.HC.Util.Installer).Log(.pLogFile,tClass,tMethod,"Error executing step:"_tClass_":"_tMethod_" - "_$system.Status.GetErrorText(tSC))
			}
			do ##class(HS.HC.Util.Installer).Log(.pLogFile,tClass,"Upgrade",$namespace_":"_tMethod_$S($$$ISOK(tSC):" OK",1:" failed "_$system.Status.GetErrorText(tSC)))
			Set $$$ProductVersionStep(tProduct,$namespace,tVersion,tMethod)=tSC
			Quit:$$$ISERR(tSC)
			#; completed at least one step in this version
			If $g($$$ProductCurrentVersion(tProduct,pNS))<tVersion {
					Set $$$ProductCurrentVersion(tProduct,pNS)=tVersion
			}
		}
		Quit:$$$ISERR(tSC)	// Quit if any upgrade steps failed
		// Additional check to set $$$ProductCurrentVersion for products with no upgrade steps
		// Any completed upgrade steps should have marked the version during that process, so this will exit without making changes
		Set tProduct=""
		For  {
			Set tProduct=$O(tProducts(tProduct)) Quit:tProduct=""
			Set tVersion=tProducts(tProduct)
			If $$$ProductCurrentVersion(tProduct,pNS)'=tVersion Set $$$ProductCurrentVersion(tProduct,pNS)=tVersion
		}
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Upgrade data from HSDBLayout for the specified namespace on this machine
/// This will first run any steps from the current(old) version that have not been run successfully
/// Then it will run any steps in the intermediate versions and finally any steps in the new
///  (target) version that have not been run successfully.   
ClassMethod LayoutUpgrade(pNS As %String = {$namespace}, ByRef pLogFile As %File) As %Status
{
	new $namespace
	Set tSC=$$$OK,tNS=$namespace
	Set tLayoutVersion=$Get($$$LayoutVersion(pNS)) 
	#; LayoutVersion was introduced in V7.
	If +tLayoutVersion=0 Set tLayoutVersion=7
	#; Fix an issue with layouts that originated in V15.
	#; The "CurrentVersion" and "LayoutVersionSteps" had the version as 16, not 15.
	If (tLayoutVersion=16)&&('$D($$$LayoutVersionStep(15,*))) {
		Merge $$$LayoutVersionStep(15,*) = $$$LayoutVersionStep(16,*)
		Kill $$$LayoutVersionStep(16,*)
		Set $$$LayoutVersion(pNS) = 15
	}
	set $namespace=pNS
	If $namespace'=pNS set $namespace=tNS Quit $$$ERROR($$$MGBLCannotOperateNamespace,pNS)
	For tIdx = tLayoutVersion:1:..GetCurrentVersion("VIEWERLIB") {
		If '##Class(%Dictionary.ClassDefinition).%ExistsId("HS.Util.Installer.Upgrade.V"_tIdx) Continue  /// just in case we skip ranges
		Do ##class(HS.HC.Util.Installer).Log(.pLogFile,"HS.Util.Installer.Upgrade.Loader","LayoutUpgrade",$namespace_":"_tIdx_" Checking layout")
		Set tSC=$ClassMethod("HS.Util.Installer.Upgrade.V"_tIdx,"LayoutUpgrade",.pLogFile)
		If tSC {
			Set $$$LayoutVersion(pNS)=tIdx 
		}
		If $$$ISERR(tSC) Quit
	}
	Quit tSC
}

}

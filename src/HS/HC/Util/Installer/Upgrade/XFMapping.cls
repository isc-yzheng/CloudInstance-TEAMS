Class HS.HC.Util.Installer.Upgrade.XFMapping Extends %RegisteredObject
{

ClassMethod UpgradeHSXF(pAppNamespace As %String) As %Status
{
	#ifndef REPORT
	#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
	#endif
	
	#ifndef CurrentClass
	#define CurrentClass         $classname()
	#endif
	
	#ifndef CurrentMethod
	#define CurrentMethod        ##safeexpression(""""_$get(%methodname)_"""")
	#endif
	
	New $Namespace
	
	Set $Namespace = pAppNamespace
	
	Set pVerbose = 1
	
	Try {
		Set tMappingGlobalName = "HS.XF.*"
		Set tMappingSourceNamespace = "HSLIB"
		
		Set pAppNamespace = $ZConvert(pAppNamespace, "U")
		
		If ($Extract(pAppNamespace,*-2,*)="LIB")||(pAppNamespace="HSSYS") {
			Set tSC = $$$ERROR($$$GeneralError, pAppNamespace_" is not valid for loading ^HS.XF globals")
			Quit
		}
		
		// Find an existing mapping fgrom tMappingSourceNamespace, remove it,
		// and remove the globals sourced from that namespace.
		Set tSC = ..RemoveGlobalAndMapping(0, tMappingGlobalName, tMappingSourceNamespace, 0)
		If $$$ISERR(tSC) {
			If $system.Status.GetErrorText(tSC)["No global mappings found for " {
				$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Information: "_$ZStrip($Piece($System.Status.GetErrorText(tSC),":",2,*),"<>W")_" - proceeding to re-load of globals")
				Set tSC = $$$OK
			} Else {
				$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Error upgrading "_$Get(tMappingGlobalName)_" global"_$Select($Extract($Get(tMappingGlobalName),"*")="*":"s",$Get(tMappingGlobalName)="":" (not specified)",1:"")_" and mappings: "_$System.Status.GetErrorText(tSC))
				Quit
			}
		}
		
		If '$Data(^HS.XF.LookupTable) {
			Set tSC = ..ImportFHIRGlobals(pAppNamespace)
			If $$$ISOK(tSC) Set tSC = ..ImportLookupJSON(pAppNamespace)
		} Else {
			$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Information: ^HS.XF.LookupTable is already present in "_pAppNamespace_" - no need to re-load globals")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Error upgrading "_$Get(tMappingGlobalName)_" global"_$Select($Extract($Get(tMappingGlobalName),"*")="*":"s",$Get(tMappingGlobalName)="":" (not specified)",1:"")_" and mappings: "_$System.Status.GetErrorText(tSC))
	} Else {
		$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Completed successfully")
	}
	
	Quit tSC
}

/// Look for a global mapping of the specified global spec from the specified
/// mapping source namespace. If the mapping is found, delete the mapping from
/// all target namepaces, and delete from the source namespace all globals
/// there that fall under the mapping spec.
ClassMethod RemoveGlobalAndMapping(pVerbose As %Boolean = 0, pMappingGlobalName As %String, pNamespace As %String, pGlobalsRequired As %Boolean = 0) As %Status
{
	#ifndef REPORT
	#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
	#endif
	
	#ifndef CurrentClass
	#define CurrentClass         $classname()
	#endif
	
	#ifndef CurrentMethod
	#define CurrentMethod        ##safeexpression(""""_$get(%methodname)_"""")
	#endif
	
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		Set pNamespace = $ZConvert(pNamespace, "U")
		
		Set pMappingGlobalName = $Get(pMappingGlobalName)
		If $Extract(pMappingGlobalName)="^" Set pMappingGlobalName = $Extract(pMappingGlobalName, 2, *)
		
		Set tErrorText = ""
		
		If $Get(pMappingGlobalName)="" {
			Set tErrorText = "Global mapping spec not specified"
		} ElseIf (pMappingGlobalName="*")||($Extract(pMappingGlobalName, *)=".") {
			Set tErrorText = "Invalid global mapping spec '"_pMappingGlobalName_"' specified"
		} ElseIf '##class(%SYS.Namespace).Exists(pNamespace) {
			Set tErrorText = "Invalid namespace '"_pNamespace_"' specified"
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
		Set $Namespace = "HSLIB"
		
		// Gather namespaces to check. Stored query in ConfigItem class gets error, use this instead.
		Set tSQLStatement = ##class(%SQL.Statement).%New()
		Set tSQL = "SELECT %ID,Name,Type,Activated,Disabled FROM HS_Util_Installer.ConfigItem"
		Set tSC = tSQLStatement.%Prepare(tSQL)
		If $$$ISERR(tSC) {
			Set tSC = $$$ERROR($$$GeneralError, "Query on HS.Util.Installer.ConfigItem failed - "_$system.Status.GetOneErrorText(tSC))
			Quit
		}
		Set tResultSet = tSQLStatement.%Execute()
		While tResultSet.%Next() {
			If tResultSet.%Get("Activated") {
				Set tNamespaces(tResultSet.%Get("Name")) = tResultSet.%Get("Type")
			}
		}
		
		Set tNamespaces(pNamespace) = ""
		
		// Setup an array to record the current mappings of the specified global spec.
		// tNamespaceMappings("ByToNamespace", targetNamespace, sourceNamespace) = ""
		// tNamespaceMappings("ByFromNamespace", sourceNamespace, targetNamespace) = ""
		Set tMappedFromOtherNamespace = 0
		Set tNamespace = ""
		For {
			Set tNamespace = $Order(tNamespaces(tNamespace))
			If tNamespace="" Quit
			Set $Namespace = "%SYS"
			Set tHasMapping = ##Class(Config.MapGlobals).Exists(tNamespace, pMappingGlobalName, .tMappingObj)
			Set $Namespace = "HSLIB"
			If tHasMapping {
				Set tNamespaceMappings("ByToNamespace", tNamespace, tMappingObj.Database) = ""
				Set tNamespaceMappings("ByFromNamespace", tMappingObj.Database, tNamespace) = ""
			}
			Kill tMappingObj
		}
		
		// If no mappings from pNamespace found, quit with error.
		If '$Data(tNamespaceMappings("ByFromNamespace", pNamespace)) {
			Set tSC = $$$ERROR($$$GeneralError, "No global mappings found for "_pMappingGlobalName_" from "_pNamespace)
			Quit
		}
		
		// Gather all global names, from the source namespace.
		Set $Namespace = pNamespace
		If $Extract(pMappingGlobalName, *) = "*" {
			Set tGlobalName = "^"_$Extract(pMappingGlobalName, 1, *-1)
			Set tGlobalNameOrig = tGlobalName
			Set tGlobalNameOrigLen = $Length(tGlobalName)
			If $Extract(tGlobalName, *) = "." Set tGlobalName = $Extract(tGlobalName, 1, *-1)
			For {
				Set tGlobalName = $Order(^$Global(tGlobalName))
				If tGlobalName="" Quit
				If $Extract(tGlobalName,1,tGlobalNameOrigLen)=tGlobalNameOrig {
					Set tGlobalNames($Extract(tGlobalName,2,*)) = ""
				} Else {
					Quit
				}
			}
		} Else {
			If $Data(@("^"_pMappingGlobalName)) Set tGlobalNames(pMappingGlobalName) = ""
		}
		
		If '$Data(tGlobalNames) {
			If pGlobalsRequired {
				Set tSC = $$$ERROR($$$GeneralError, "No globals matching spec "_pMappingGlobalName_" found in "_pNamespace)
				Quit
			} Else {
				$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Information: No globals matching spec "_pMappingGlobalName_" found in "_pNamespace)
			}
		}
		
		// Remove existing global mappings for the global spec.
		Set tNamespace = ""
		For {
			Set tNamespace = $Order(tNamespaceMappings("ByFromNamespace", pNamespace, tNamespace))
			If tNamespace="" Quit
			Set $Namespace = "%SYS"
			Set tSC = ##Class(Config.MapGlobals).Delete(tNamespace, pMappingGlobalName)
			Set $Namespace = "HSLIB"
			// It is okay if the mapping did not exist.
			If $system.Status.GetErrorCodes(tSC)="421" Set tSC = $$$OK
			If $$$ISERR(tSC) Quit
		}
		$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Removed existing mappings for global spec "_pMappingGlobalName)
		
		Set $Namespace = pNamespace
		
		Set tGlobalName = ""
		For {
			Set tGlobalName = $Order(tGlobalNames(tGlobalName))
			If tGlobalName="" Quit
			Kill @("^"_tGlobalName)
			$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Killed ^"_tGlobalName_" from "_pNamespace)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		$$$REPORT(0,$$$CurrentClass_":"_$$$CurrentMethod_" Error removing "_$Get(pMappingGlobalName)_" global"_$Select($Extract($Get(pMappingGlobalName),"*")="*":"s",$Get(pMappingGlobalName)="":" (not specified)",1:"")_" and removing mappings: "_$System.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

ClassMethod ImportFHIRGlobals(pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		If pNamespace="" Set pNamespace = $Namespace
		
		Set $Namespace = pNamespace
		
		Set tDirName = $system.Util.InstallDirectory() _ "dev/fhir/gbl/"
		If '##class(%Library.File).DirectoryExists(tDirName) {
			Set tSC = $$$ERROR($$$GeneralError, tDirName _ " not found")
			Quit
		}
		
		Set tProject = ""
		For {
			Set tProject = $Order(^HS.XF.Config("Delivery", tProject))
			If tProject="" Quit
			If $Data(^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL")) {
				Set tCustomPackage(tProject) = ^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL")
			}
		}
		
		Set tSC = $system.OBJ.ImportDir(tDirName)
		
		Set tProject = ""
		For {
			Set tProject = $Order(tCustomPackage(tProject))
			If tProject="" Quit
			Set ^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL") = tCustomPackage(tProject)
		}
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ImportLookupJSON(pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		If pNamespace="" Set pNamespace = $Namespace
		
		Set $Namespace = pNamespace
		
		// Do not overlay or overwrite an existing ^HS.XF.LookupTable.
		// Once established by an install, it can be updated only via
		// the customization procedure.
		If $Data(^HS.XF.LookupTable) Quit
		
		Set tDirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/"
		If '##class(%Library.File).DirectoryExists(tDirName) {
			Set tSC = $$$ERROR($$$GeneralError, tDirName _ " not found")
			Quit
		}
		Set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", tDirName)
		If '##class(%Library.File).Exists(tFileName) {
			Set tSC = $$$ERROR($$$GeneralError, tFileName _ " not found")
			Quit
		}
		
		Set tSC = ##class(HS.FHIR.DTL.Util.API.LookupTable).ImportLookupJSONToGlobal()
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

}

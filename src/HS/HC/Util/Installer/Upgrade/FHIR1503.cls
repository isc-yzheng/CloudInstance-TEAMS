Include Ensemble

Class HS.HC.Util.Installer.Upgrade.FHIR1503 Extends HS.Util.Installer.Kit.Base
{

ClassMethod RunAll()
{
	Write !!,"Executing ##class("_$ClassName()_").Delete1503SearchTables()"
	Hang 1
	Set tSC = ..Delete1503SearchTables()
	If $$$ISERR(tSC) Quit
	Write !
	
	Write !!,"Executing ##class("_$ClassName()_").ConvertDSTU2RepoData()"
	Hang 1
	Set tSC = ..ConvertDSTU2RepoData()
	If $$$ISERR(tSC) Quit
	Write !
	
	Write !!,"Executing ##class("_$ClassName()_").GenerateDSTU2SearchTables(""InterSystemsFHIRServer"")"
	Hang 1
	Set tSC = ..GenerateDSTU2SearchTables("InterSystemsFHIRServer")
	If $$$ISERR(tSC) Quit
	Write !
	
	Write !!,"Executing ##class("_$ClassName()_").ReSaveDSTU2Resources()"
	Hang 1
	Set tSC = ..ReSaveDSTU2Resources()
	If $$$ISERR(tSC) Quit
	Write !
	
	Write !!,"Executing ##class("_$ClassName()_").ConvertFHIRProductionItems()"
	Hang 1
	Set tSC = ..ConvertFHIRProductionItems()
	If $$$ISERR(tSC) Quit
	Write !
	
	Quit
}

/// Delete1503SearchTables deletes the data stored in the 15.03 FHIR search tables
/// and the search table classes themselves. Search and hard kill of globals is
/// done both for speed and because after upgrade the classes themselves are not
/// usable, as they reference a class that does not exist post-15.03.
ClassMethod Delete1503SearchTables() As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$ThrowOnError(..StartConversionMethod())
		
		Set tSearchTableGlobalRoot = "HS.FHIR.Search."
		
		Do ..GetGlobalList(tSearchTableGlobalRoot, .tGlobalList)
		
		Write !,"Killing 15.03 FHIR search table globals ...",!
		
		If $Data(tGlobalList) {
			Set tName = ""
			For {
				Set tName = $Order(tGlobalList(tName))
				If tName="" Quit
				Write !,"Killing ^"_tName
				Kill @("^"_tName)
			}
		} Else {
			Write !,"No 15.03 FHIR search table globals found."
		}
		Write !
		
		Set tSearchTablePackage = "HS.Local.FHIR.Repository.Search"
		
		Set tQuery = "SELECT ID FROM %Dictionary.ClassDefinition where ID %StartsWith ?"
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tSC = tStatement.%Prepare(tQuery)
		If $$$ISERR(tSC) {
			Set tText = "ERROR: Delete1503SearchTables %Prepare failed for SQL query for search table delete: "_$System.Status.GetErrorText(tSC)
			Set tSC = $$$ERROR($$$GeneralError, tText)
			Quit
		}
		Set tResultSet = tStatement.%Execute(tSearchTablePackage)
		
		Write !,"Deleting 15.03 FHIR search table classes ...",!
		Set tFound = 0
		While tResultSet.%Next() {
			Set tFound = 1
			Set tClassName = tResultSet.ID
			Write !,"Deleting class "_tClassName
			Set tSC = ##class(%Dictionary.ClassDefinition).%DeleteId(tClassName)
			If $$$ISOK(tSC) {
				Write " - success"
			} Else {
				Set tText = " - ERROR: delete failed ("_$System.Status.GetErrorText(tSC)_")"
				Write tText
				Set tSC = $$$ERROR($$$GeneralError, tClassName_tText)
				Quit
			}
		}
		If 'tFound Write !,"No 15.03 search table classes found."
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISOK(tSC) {
		Write !,"Delete1503SearchTables completed successfully"
	} Else {
		Set tText = "Delete1503SearchTables failed: "_$System.Status.GetErrorText(tSC)
		Write !,tText
	}
	
	Quit tSC
}

ClassMethod GetGlobalList(pGlobalNameRoot As %String, Output pGlobalList) [ Internal ]
{
	Set tResultSet = ""
	Set tQuery = "%SYS.GlobalQuery:NameSpaceList"
	Set tResultSet = ##class(%ResultSet).%New(tQuery)
	Do tResultSet.Execute($namespace)
	While tResultSet.%Next() {
		If $Extract(tResultSet.Name, 1, $Length(pGlobalNameRoot))=pGlobalNameRoot {
			Set pGlobalList(tResultSet.Name) = ""
		}
	}
	Quit
}

/// GenerateDSTU2SearchTables generates the DSTU2 search tables, which post-15.03
/// are re-located to the local namespace and re-named to NSLocal.*.
ClassMethod GenerateDSTU2SearchTables(pConformanceResourceId As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$ThrowOnError(..StartConversionMethod())
		
		Write !,"Generating DSTU2 search table classes ...",!
		
		Set tVerbose = 0
		Set tSC = ##class(HS.FHIR.vDSTU2.SearchTableBuilder).GenSearchTables(pConformanceResourceId, , tVerbose)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISOK(tSC) {
		Write !,"GenerateDSTU2SearchTables("""_pConformanceResourceId_""") completed successfully"
	} Else {
		Write !,"GenerateDSTU2SearchTables("""_pConformanceResourceId_""") failed: "_$System.Status.GetErrorText(tSC)
	}
	
	Quit tSC
}

/// Convert the existing FHIR DSTU2 repository stored resources and their
/// indices, to change the repository storage %%CLASSNAME in each item,
/// and to add default values for new properties ResourceStream and
/// ResourceSchema. Updates are via direct sets to $List positions in the
/// existing persisted data and direct global Sets.
ClassMethod ConvertDSTU2RepoData() As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$ThrowOnError(..StartConversionMethod())
		
		Set t1503StorageClassRoot = "HS.FHIR.Repository.Resource."
		Set t1503StorageClassRootL = $Length(t1503StorageClassRoot)
		
		Set tNEWStorageClassRoot = "HS.FHIR.vDSTU2.Repository.Resource."
		Set tNEWStorageClassRootL = $Length(tNEWStorageClassRoot)
		
		Set tNEWResourceSchema = "HS.FHIR.vDSTU2.Model.Resource"
		
		Set tRepoDataGlobal = "^HS.FHIR.RepositorF719.AbstractD"
		Set tRepoIndexGlobal = "^HS.FHIR.RepositorF719.AbstractI"
		Set tRepoVersionIdx = "^HS.FHIR.RepositorF719.AbstractI(""VersionIdx"""
		
		// Assume that the top node of the repository data global is an accurate
		// reflection of the total number of streamlet objects stored.
		Set tStreamletsTotal = +$Get(@tRepoDataGlobal)
		Set tStreamletsProcessed = 0
		
		Write !,"Converting FHIR DSTU2 repository data ("_tStreamletsTotal_" resources) ...",!
		
		// Loop through all of the index global using $Query.
		
		Set tIndexQuery = tRepoIndexGlobal
		
		For {
			Set tIndexQuery = $Query(@tIndexQuery)
			If tIndexQuery="" Quit
			
			Set tIndexData = @tIndexQuery
			
			If tIndexQuery[tRepoVersionIdx If $i(tStreamletsProcessed)
			
			// StreamletId is always the last subscript.
			Set tStreamletId = $QSubscript(tIndexQuery, $QLength(tIndexQuery))
			
			// Some indices (e.g., VersionIdx) have $List data, and other
			// indices (e.g., CompartmentIdx) have string data.
			If $ListValid(tIndexData) {
				Set tClassNameData = $ListGet(tIndexData, 1)
				If (($Extract(tClassNameData)="~")&&($Extract(tClassNameData,*)="~")) {
					If $Extract(tClassNameData, 2, t1503StorageClassRootL+1)=t1503StorageClassRoot {
						Set tResourceType = $Extract(tClassNameData, t1503StorageClassRootL+2, *-1)
						Set tNewClassNameData = "~"_tNEWStorageClassRoot_tResourceType_"~"
						Set $List(tIndexData, 1) = tNewClassNameData
						// This is a direct global SET.
						Set @tIndexQuery = tIndexData
					} ElseIf $Extract(tClassNameData, 2, tNEWStorageClassRootL+1)'=tNEWStorageClassRoot {
						// It is in neither the old storage class package nor the new one.
						Write !,tIndexQuery_" existing data appears corrupt: "_$ListToString(tIndexData)
						Continue
					}
				} Else {
					// Class name data does not start and end with tilde.
					Write !,tIndexQuery_" existing data appears corrupt: "_$ListToString(tIndexData)
					Continue
				}
			} Else { // String data
				Set tClassNameData = tIndexData
				If (($Extract(tClassNameData)="~")&&($Extract(tClassNameData,*)="~")) {
					If $Extract(tClassNameData, 2, t1503StorageClassRootL+1)=t1503StorageClassRoot {
						Set tResourceType = $Extract(tClassNameData, t1503StorageClassRootL+2, *-1)
						Set tNewClassNameData = "~"_tNEWStorageClassRoot_tResourceType_"~"
						// This is a direct global SET.
						Set @tIndexQuery = tNewClassNameData
					} ElseIf $Extract(tClassNameData, 2, tNEWStorageClassRootL+1)'=tNEWStorageClassRoot {
						// It is in neither the old storage class package nor the new one.
						Write !,tIndexQuery_" existing data appears corrupt: "_tIndexData
						Continue
					}
				} Else {
					// Class name data does not start and end with tilde.
					Write !,tIndexQuery_" existing data appears corrupt: "_tIndexData
					Continue
				}
			}
			
			// Update the pointed-to streamlet only if we are currently
			// parsing the VersionIdx sub-tree of the repo index global.
			If tIndexQuery'[tRepoVersionIdx Continue
			
			// Update the streamlet that this index points to, if not done already.
			// - Update the class name data to reflect the new class package.
			// - Ensure $List position 11 for the new ResourceStream property.
			//   Either preserve the existing non-blank value there, or if no
			//   value found, explicitly set that position to blank string.
			// - Ensure $List position 12 for the new ResourceSchema property.
			//   Either preserve the existing non-blank value there, or if
			//   no value found, explicitly set that position to tNEWResourceSchema.
			Set tStreamletData = @tRepoDataGlobal@(tStreamletId)
			Set tClassNameData = $ListGet(tStreamletData, 1)
			Set tResourceStreamData = $ListGet(tStreamletData, 11)
			Set tResourceSchemaData = $ListGet(tStreamletData, 12)
			If (($Extract(tClassNameData)="~")&&($Extract(tClassNameData,*)="~")) {
				If $Extract(tClassNameData, 2, t1503StorageClassRootL+1)=t1503StorageClassRoot {
					Set tResourceType = $Extract(tClassNameData, t1503StorageClassRootL+2, *-1)
					Set tNewClassNameData = "~"_tNEWStorageClassRoot_tResourceType_"~"
					Set $List(tStreamletData, 1) = tNewClassNameData
				} ElseIf $Extract(tClassNameData, 2, tNEWStorageClassRootL+1)'=tNEWStorageClassRoot {
					// It is in neither the old storage class package nor the new one.
					Write !,tRepoDataGlobal_"("_tStreamletId_") existing data appears corrupt: "_$ListToString(tStreamletData)
					Continue
				}
			} Else {
				// Class name data does not start and end with tilde.
				Write !,tRepoDataGlobal_"("_tStreamletId_") existing data appears corrupt: "_$ListToString(tStreamletData)
				Continue
			}
			Set $List(tStreamletData, 11) = tResourceStreamData
			If tResourceSchemaData="" {
				Set $List(tStreamletData, 12) = tNEWResourceSchema
			}
			// This is a direct global SET.
			Set @tRepoDataGlobal@(tStreamletId) = tStreamletData
			// Show some progress, in case the repo is huge.
			Set tDone = ((tStreamletsProcessed/tStreamletsTotal)*10)\1
			If (tDone) && ('$Data(tReported(tDone))) {
				Write !,tDone_"0% done"
				Set tReported(tDone)=""
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISOK(tSC) {
		Write !,"ConvertDSTU2RepoData completed successfully"
	} Else {
		Write !,"ConvertDSTU2RepoData failed: "_$System.Status.GetErrorText(tSC)
	}
	
	Quit tSC
}

/// Re-save the DSTU2 repository resources, to re-build the indexing.
ClassMethod ReSaveDSTU2Resources() As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$ThrowOnError(..StartConversionMethod())
		
		Set tErrors = 0
		
		Set tNEWStorageClassRoot = "HS.FHIR.vDSTU2.Repository.Resource."
		Set tNEWStorageClassRootL = $Length(tNEWStorageClassRoot)
		
		Set tRepoDataGlobal = "^HS.FHIR.RepositorF719.AbstractD"
		Set tRepoIndexGlobal = "^HS.FHIR.RepositorF719.AbstractI"
		
		// Assume that the top node of the repository data global is an accurate
		// reflection of the total number of streamlet objects stored.
		Set tStreamletsTotal = +$Get(@tRepoDataGlobal)
		Set tStreamletsProcessed = 0
		
		Write !,"Re-saving repository data to re-build index values ("_tStreamletsTotal_" resources) ...",!
		
		Set tStreamletId = ""
		For {
			Set tStreamletId = $Order(@tRepoDataGlobal@(tStreamletId), 1, tStreamletData)
			If tStreamletId="" Quit
			If $i(tStreamletsProcessed)
			Set tClassNameData = $ListGet(tStreamletData, 1)
			Set tResourceType = $ListGet(tStreamletData, 2)
			Set tResourceId = $ListGet(tStreamletData, 3)
			Set tResourceVId = $ListGet(tStreamletData, 4)
			Set tResourceSchemaData = $ListGet(tStreamletData, 12)
			Set tStreamletIdCurVer = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).CurrentVersion("", tResourceType, tResourceId)
			If tResourceVId'=tStreamletIdCurVer {
				// Re-save only the latest version of a given resource type + resource id.
				Continue
			}
			If (($Extract(tClassNameData)="~")&&($Extract(tClassNameData,*)="~")) {
				If $Extract(tClassNameData, 2, tNEWStorageClassRootL+1)'=tNEWStorageClassRoot {
					Write !,tRepoDataGlobal_"("_tStreamletId_") not converted, appears orphaned: "_$ListToString(tStreamletData)
					Continue
				} ElseIf tResourceSchemaData="" {
					Write !,tRepoDataGlobal_"("_tStreamletId_") not converted, appears orphaned: "_$ListToString(tStreamletData)
					Continue
				}
			} Else {
				// Class name data does not start and end with tilde.
				Write !,tRepoDataGlobal_"("_tStreamletId_") existing data appears corrupt: "_$ListToString(tStreamletData)
				Continue
			}
			Set tStreamletClass = $Extract(tClassNameData, 2, *-1)
			Set tStreamletObj = $ClassMethod(tStreamletClass, "%OpenId", tStreamletId)
			Kill tResourceStream
			Kill tResourceObj
			Set tResourceStream = ##class(%Stream.TmpCharacter).%New()
			Do tResourceStream.Write(tStreamletObj.ResourceString)
			Do tResourceStream.Rewind()
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(tStreamletObj.Format, tResourceStream, .tResourceObj)
			If $$$ISERR(tSC) {
				Set tText = "ERROR: CreateResourceObject for streamlet id "_tStreamletId_" failed: "_$System.Status.GetErrorText(tSC)
				Write !,tText
				Set tSC = $$$ERROR($$$GeneralError, tText)
				If $i(tErrors)
				Continue
			}
			
			Set tStreamletObj.ResourceObject = tResourceObj
			
			Set tSC = tStreamletObj.%Save()
			If $$$ISERR(tSC) {
				Set tText = "ERROR: %Save for streamlet id "_tStreamletId_" failed: "_$System.Status.GetErrorText(tSC)
				Write !,tText
				Set tSC = $$$ERROR($$$GeneralError, tText)
				If $i(tErrors)
				Continue
			}
			Set tSC = tStreamletObj.IndexValues()
			If $$$ISERR(tSC) {
				Set tText = "ERROR: IndexValues for streamlet id "_tStreamletId_" failed: "_$System.Status.GetErrorText(tSC)
				Write !,tText
				Set tSC = $$$ERROR($$$GeneralError, tText)
				If $i(tErrors)
				Continue
			}
			// Show some progress, in case the repo is huge.
			Set tDone = ((tStreamletsProcessed/tStreamletsTotal)*10)\1
			If (tDone) && ('$Data(tReported(tDone))) {
				Write !,tDone_"0% done"
				Set tReported(tDone)=""
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISOK(tSC) {
		Write !,"ReSaveDSTU2Resources completed successfully"
	} Else {
		Write !,"ReSaveDSTU2Resources failed: "_$System.Status.GetErrorText(tSC)
	}
	
	Quit tSC
}

/// Make some adjustments to the DSTU2 items in a 15.03-originated FHIR production.
/// This conversion is not comprehensive. It covers only items that can be detected
/// if they had been installed using our installer and not subsequently re-named.
/// Items converted:
/// - Change the class name - not the config item name - for all items that are using
///   the 15.03 verison of the class to use the "vDSTU2" version of the class.
/// - Change the class name on any item using HS.IHE.XDSb.Consumer.Operations to use
///   HS.HC.IHE.XDSb.Consumer.Operations instead.
/// - Remove config item using class name HS.FHIR.Operations.Process.
/// - Remove config item using class name HS.Hub.HSWS.RemoteOperations.
/// - If the production already had PIXm then add HS.FHIR.vDSTU2.PIXm.Manager.
/// - If the production already had PDQm then add HS.FHIR.vDSTU2.PDQm.Supplier.
/// - On HS.FHIR.Server.Process, update settings ResourceSchemaRoot and TargetConfigName.
ClassMethod ConvertFHIRProductionItems() As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$ThrowOnError(..StartConversionMethod())
		
		Write !,"Converting DSTU2 FHIR production items ...",!
		
		Set tProdClass = ##class(HS.Util.Installer.ConfigItem).ProductionGetStored($namespace)
		Set tProdObj = ##class(Ens.Config.Production).%OpenId(tProdClass)
		
		For tClassName = "HS.FHIR.Operation.Process", "HS.Hub.HSWS.RemoteOperations" {
			Set ttSC = ##class(HS.Util.Installer.Upgrade.Abstract).RemoveConfigItem(tProdObj, tClassName)
			If $$$ISERR(ttSC) Write !,"Failed to remove "_tClassName_" from production, continuing"
		}
		
		Set tHasPIXm = 0
		Set tHasManagerPIXm = 0
		Set tPIXMPI = ""
		Set tHasPDQm = 0
		Set tHasManagerPDQm = 0
		Set tHasMHD = 0
		Set tHSTestServiceObj = ""
		Set tPDQMPI = ""
		Set tRepoBOName = ""
		
		#dim tProdItem As Ens.Config.Item
		#dim tSetting As Ens.Config.Setting
		
		// Get the repository business operation config item name.
		For tItemIndex = 1:1:tProdObj.Items.Count() {
			Set tProdItem = tProdObj.Items.GetAt(tItemIndex)
			Set tClassName = tProdItem.ClassName
			If tClassName="HS.FHIR.Repository.Operations" {
				Set tRepoBOName = tProdItem.Name
			}
		}
		
		// Update class names and some setting values. Do not update the item names.
		For tItemIndex = 1:1:tProdObj.Items.Count() {
			Set tProdItem = tProdObj.Items.GetAt(tItemIndex)
			Set tClassName = tProdItem.ClassName
			If tClassName="HS.IHE.XDSb.Consumer.Operations" {
				Set tProdItem.ClassName = "HS.HC.IHE.XDSb.Consumer.Operations"
			} ElseIf $Extract(tClassName,1,13)="HS.FHIR.PIXm." {
				Set $Extract(tClassName,1,13) = "HS.FHIR.vDSTU2.PIXm."
				Set tProdItem.ClassName = tClassName
				Set tHasPIXm = 1
			} ElseIf tClassName["PIX.Manager.Process" {
				// Get the MPIOperations setting for the old PIX process
				// so that we can apply it to the new DSTU2 PIXm process.
				For tSettingIndex = 1:1:tProdItem.Settings.Count() {
					Set tSetting = tProdItem.Settings.GetAt(tSettingIndex)
					If tSetting.Name="MPIOperations" {
						Set tPIXMPI = tSetting.Value
						Quit
					}
				}
			} ElseIf $Extract(tClassName,1,13)="HS.FHIR.PDQm." {
				Set $Extract(tClassName,1,13) = "HS.FHIR.vDSTU2.PDQm."
				Set tProdItem.ClassName = tClassName
				Set tHasPDQm = 1
			} ElseIf tClassName["PDQ.Supplier.Process" {
				// Get the MPIOperations setting for the old PDQ process
				// so that we can apply it to the new DSTU2 PDQm process.
				For tSettingIndex = 1:1:tProdItem.Settings.Count() {
					Set tSetting = tProdItem.Settings.GetAt(tSettingIndex)
					If tSetting.Name="MPIOperations" {
						Set tPDQMPI = tSetting.Value
						Quit
					}
				}
			} ElseIf $Extract(tClassName,1,12)="HS.FHIR.MHD." {
				Set $Extract(tClassName,1,12) = "HS.FHIR.vDSTU2.MHD."
				Set tProdItem.ClassName = tClassName
				Set tHasMHD = 1
			} ElseIf tClassName="HS.Hub.MPI.Manager" {
				Set tProdItem.ClassName = "HS.HC.MPI.Manager"
			} ElseIf tClassName="HS.FHIR.Server.Process" {
				Set ttSC = ..SetItemSetting(tProdItem, "ResourceSchemaRoot", "HS.FHIR.vDSTU2.Model.Resource", "Host")
				If $$$ISERR(ttSC) {
					Write !,$System.Status.GetErrorText(ttSC)_", continuing",!
				}
				Set ttSC = ..SetItemSetting(tProdItem, "TargetConfigName", tRepoBOName, "Host")
				If $$$ISERR(ttSC) {
					Write !,$System.Status.GetErrorText(ttSC)_", continuing",!
				}
			} ElseIf tClassName="HS.FHIR.vDSTU2.PIXm.Manager.Process" {
				Set tHasManagerPIXm = 1
			} ElseIf tClassName="HS.FHIR.vDSTU2.PDQm.Manager.Process" {
				Set tHasManagerPDQm = 1
			} ElseIf tClassName="HS.Test.Service" {
				Set tHSTestServiceObj = tProdItem
			}
		}
		If $$$ISERR(tSC) Quit
		
		// If HS.Test.Service is included in the production, update the
		// target host name settings for the FHIR DSTU2 items if needed.
		If $IsObject($Get(tHSTestServiceObj)) {
			If tHasPIXm {
				Set ttSC = ..SetItemSetting(tHSTestServiceObj, "PIXmConsumerOperationsDSTU2", "HS.FHIR.PIXm.Consumer.Operations", "Host")
				If $$$ISERR(ttSC) {
					Write !,$System.Status.GetErrorText(ttSC)_", continuing",!
				}
			}
			If tHasPDQm {
				Set ttSC = ..SetItemSetting(tHSTestServiceObj, "PDQmConsumerOperationsDSTU2", "HS.FHIR.PDQm.Consumer.Operations", "Host")
				If $$$ISERR(ttSC) {
					Write !,$System.Status.GetErrorText(ttSC)_", continuing",!
				}
			}
			If tHasMHD {
				Set ttSC = ..SetItemSetting(tHSTestServiceObj, "MHDConsumerOperationsDSTU2", "HS.FHIR.MHD.Consumer.Operations", "Host")
				If $$$ISERR(ttSC) {
					Write !,$System.Status.GetErrorText(ttSC)_", continuing",!
				}
				Set ttSC = ..SetItemSetting(tHSTestServiceObj, "MHDSourceOperationsDSTU2", "HS.FHIR.MHD.DocumentSource.Operations", "Host")
				If $$$ISERR(ttSC) {
					Write !,$System.Status.GetErrorText(ttSC)_", continuing",!
				}
			}
		}
		
		// If the production has the old PIXm components, but not the
		// new PIXm Manager business process, then add the new BP and
		// change the TargetConfigName setting for the PIXm BS.
		If (tHasPIXm)&&('tHasManagerPIXm) {
			Set tBPName = "HS.FHIR.vDSTU2.PIXm.Manager.Process"
			Set tBSName = ".PIXm.Manager.Service"
			Do ..AddPIXPDQBP(tProdObj, tBPName, tBSName, tPIXMPI)
		}
		
		// If the production has the old PDQm components, but not the
		// new PDQm Supplier business process, then add the new BP and
		// change the TargetConfigName setting for the PDQm BS.
		If (tHasPDQm)&&('tHasManagerPDQm) {
			Set tBPName = "HS.FHIR.vDSTU2.PDQm.Supplier.Process"
			Set tBSName = ".PDQm.Supplier.Service"
			Do ..AddPIXPDQBP(tProdObj, tBPName, tBSName, tPDQMPI)
		}
		
		Set tSC = ##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProdObj)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISOK(tSC) {
		Write !,"ConvertFHIRProductionItems completed successfully"
	} Else {
		Write !,"ConvertFHIRProductionItems failed: "_$System.Status.GetErrorText(tSC)
	}
	
	Quit tSC
}

/// Verify that the conversion is being run on IRIS, that the local
/// namespace is a Foundation namespace, and that the local production
/// is stopped.
ClassMethod StartConversionMethod() As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	If $ZV["Cache" {
		Set tText = "ERROR: This method must be run only after upgrade to IRIS for Health"
		Write !,tText
		Quit $$$ERROR($$$GeneralError, tText)
	}
	
	Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId($Namespace)
	If '$IsObject($Get(tConfigItem)) {
		Set tText = "ERROR: This method must be run in a Health Connect or HealthShare namespace"
		Write !,tText
		Quit $$$ERROR($$$GeneralError, tText)
	}
	Kill tConfigItem
	
	Set tSC = ..StopProduction()
	If $$$ISERR(tSC) Quit tSC
	
	Write !
	
	Quit tSC
}

/// Add the newer DSTU2 PIXm or PDQm business process, and adjust the business
/// service TargetConfigName setting to point to the newly added business process.
/// This is done via custom code rather than via XData and AddProductonItems
/// because we cannot be certain of the config item name of the business service,
/// plus there is some complex logic involved with some of the setting values.
ClassMethod AddPIXPDQBP(pProdObj As Ens.Config.Production, pBPName As %String, pBSName As %String, pMPIVal As %String) [ Internal ]
{
	Set tNewProdItem = ##class(Ens.Config.Item).%New()
	Set tNewProdItem.ClassName = pBPName
	Set tNewProdItem.Name = pBPName
	Set tNewProdItem.Enabled = 1
	Set tNewSetting = ##class(Ens.Config.Setting).%New()
	Set tNewSetting.Name = "MPIOperations"
	Set tNewSetting.Value = pMPIVal
	Set tNewSetting.Target = "Host"
	Set ttSC = tNewProdItem.Settings.Insert(tNewSetting)
	If $$$ISERR(ttSC) {
		Write !,"Failed to add "_pBPName_" setting "_tNewSetting.Name_", continuing"
	}
	Do pProdObj.Items.Insert(tNewProdItem)
	For tItemIndex = pProdObj.Items.Count():-1:1 {
		Set tProdItem = pProdObj.Items.GetAt(tItemIndex)
		Set tClassName = tProdItem.ClassName
		Set tItemName = tProdItem.Name
		// Class name of existing PIXm / PDQm business services is HS.FHIR.Service.
		// Look for config item name that contains the specified BS name text.
		If tItemName[pBSName {
			Set ttSC = ..SetItemSetting(tProdItem, "TargetConfigName", pBPName, "Host")
			If $$$ISERR(ttSC) {
				Write !,$System.Status.GetErrorText(ttSC)_", continuing",!
			}
			Quit
		}
	}
	
	Quit
}

ClassMethod SetItemSetting(pConfigItemObj As Ens.Config.Item, pSettingName As %String, pSettingValue As %String, pTarget As %String)
{
	Set tSC = $$$OK
	
	Set tFoundSetting = 0
	
	For tSettingIndex = 1:1:pConfigItemObj.Settings.Count() {
		Set tSetting = pConfigItemObj.Settings.GetAt(tSettingIndex)
		If tSetting.Name=pSettingName {
			Set tSetting.Value = pSettingValue
			Set tFoundSetting = 1
		}
	}
	
	If 'tFoundSetting {
		Set tNewSetting = ##class(Ens.Config.Setting).%New()
		Set tNewSetting.Name = pSettingName
		Set tNewSetting.Value = pSettingValue
		Set tNewSetting.Target = pTarget
		Set tSC = pConfigItemObj.Settings.Insert(tNewSetting)
		If $$$ISERR(tSC) {
			Set tSC = $$$ERROR($$$GeneralError, "Failed to add "_pConfigItemObj.Name_" setting "_tNewSetting.Name_" - "_$System.Status.GetErrorText(tSC))
		}
	}
	
	Quit tSC
}

ClassMethod StopProduction() As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Set tSC = ##class(Ens.Director).GetProductionStatus(.tProdName, .tProdStatus)
	If $$$ISERR(tSC) Quit tSC
	
	If tProdStatus=$$$eProductionStateRunning {
		Write !
		Set tSC = ##class(Ens.Director).StopProduction()
		Write !
	} ElseIf tProdStatus=$$$eProductionStateSuspended {
		Set tSC = $$$ERROR($$$GeneralError, "Production is currently suspended")
	} ElseIf tProdStatus=$$$eProductionStateTroubled {
		Set tSC = $$$ERROR($$$GeneralError, "Production is currently troubled")
	}
	
	Quit tSC
}

}

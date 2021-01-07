Include HS.FHIRServer

Class HS.FHIRServer.ServiceUpgrade [ Abstract ]
{

Parameter ConfigVersion As %Integer = 3;

Parameter CVGLOBAL = "^HS.FHIRServer(""admin"", ""ConfigVersion"")";

Parameter INSTGLOBAL = "^HS.FHIRServer(""admin"", ""instance"")";

ClassMethod InitializeNamespaceConfig()
{
	// No trace of FHIR setup in this namespace, mark it with the config version
	// Note: The FHIR Config UI uses the presence of the ^HS.FHIRServer global as a flag
	// that it should be displayed in the SMP
	if '$D(^HS.FHIRServer) {
		Set @..#CVGLOBAL = ..#ConfigVersion
	}
}

ClassMethod UpgradeNamespace(ByRef pLogFile As %File) As %Status
{
	/// First check if we've every installed FHIR in this namespace
	
	Set tSC = $$$OK
	try {
		Set transaction = ##class(HS.Util.Scoped.Transaction).Start()
		
		do ##class(HS.FHIRServer.ServiceAdmin).requireWritePermission()
		Set configVersion = $Get(@..#CVGLOBAL,1)
		if configVersion = 1 {
			// This namespace has the version 1 configuration data. 
			// Upgrade to version 2
			Do ..UpgradeV1ToV3(.pLogFile)
		}
		elseif configVersion = 2 {
			// This namespace has the version 2 configuration data.
			// Upgrade to version 3
			Do ..UpgradeV2ToV3(.pLogFile)
		}
		Set @..#CVGLOBAL = ..#ConfigVersion
		kill ^HS.FHIRServer("ConfigVersion")
		
		do transaction.Commit()
		
	} catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Upgrade from V1 (pre-2020.1)
ClassMethod UpgradeV1ToV3(ByRef pLogFile As %File) [ Private ]
{
	
	Set url = ""
	for {
		Set url = $Order(^HS.FHIRServer("endpoint",url))
		Quit:url=""
		
		Set mds = ^HS.FHIRServer("endpoint",url,"metadataSetKey")
		Set scls = ^HS.FHIRServer("endpoint",url,"strategyClass")

		Set skey = ##class(HS.FHIRServer.ServiceAdmin).GetStrategyKeyFromClass(scls)
		Set configRoot = $Name(^HS.FHIRServer("strategy", skey, mds, "config"))

		Set repo = ##class(HS.FHIRServer.API.RepoManager).CreateRepo(skey)
		Set repo.globalRoot=@configRoot@("globalRoot")
		Set repo.globalTempRoot=@configRoot@("globalTempRoot")
		Set repo.resourceClassesPackage=@configRoot@("resourceClassesPackage")
		Set repo.versionClassesPackage=@configRoot@("resourceClassesPackage")
		Set repo.searchClassesPackage=@configRoot@("searchClassesPackage")
		$$$ThrowOnError( repo.%Save() )

		#dim repoManager as HS.FHIRServer.API.RepoManager
		Set repoManager =  ##class(HS.FHIRServer.API.RepoManager).getInstance(repo)

		#dim instance as HS.FHIRServer.ServiceInstance
		Set instance = repoManager.AddService(..MDSKeyToPackageList(.pLogFile, mds))
		Set configData = @configRoot@("serviceConfigData")
		Set instance.serviceConfigData = configData
		Set instance.cspUrl = url
	
		$$$ThrowOnError( instance.%Save() )
		
		/// TO BE FIXED
		Do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceIdForEndpoint(url, instance.serviceId)
		Do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceEnabled(instance.serviceId, $Get(^HS.FHIRServer("endpoint", "enabled"),1))

		Do ..CompleteV3Upgrade(.pLogFile, repoManager, instance, mds)
		
	}
	// TODO: Delete the old data
	kill ^HS.FHIRServer("endpoint")
	kill ^HS.FHIRServer("strategy")
	kill ^HS.FHIRServer.FHIRMetadataSetD
	kill ^HS.FHIRServer.ServiceInstanceD
}

/// Upgrade from V2 (2020.1)
ClassMethod UpgradeV2ToV3(ByRef pLogFile As %File) [ Private ]
{
	// Moving Config data to persistent classes, obsoleting the 
	// ^HS.FHIRServer global (except for the version #)
	set url = ""
	for {
		Set url = $Order(^HS.FHIRServer("admin", "rest", url), 1, svcId)
		Quit:url=""
		
		Set UrlById(svcId) = url
	}
	
	Set oldServiceInstanceLocation = $Name(^HS.FHIRServer.ServiceInstanceD)
	set id = ""
	for {
		Set id = $Order(@oldServiceInstanceLocation@(id), 1, %s1)
		Quit:id=""
		
		// Deserialize the old ServiceInstance data.  Migrating
		// to Repo and RepoInstance objects
		Set metadataSetKey=$lg(%s1,2)
		Set strategyClass=$lg(%s1,3)
		Set globalRoot=$lg(%s1,4)
		Set globalTempRoot=$lg(%s1,5)
		Set resourceClassesPackage=$lg(%s1,6)
		Set searchClassesPackage=$lg(%s1,7)
		Set IsDecommissioned=$lg(%s1,8)
		
		Set strategyKey = ##class(HS.FHIRServer.ServiceAdmin).GetStrategyKeyFromClass(strategyClass)

		Set repo = ##class(HS.FHIRServer.API.RepoManager).CreateRepo(strategyKey)
		Set repo.globalRoot=globalRoot
		Set repo.globalTempRoot=globalTempRoot
		Set repo.resourceClassesPackage=resourceClassesPackage
		Set repo.versionClassesPackage=resourceClassesPackage
		Set repo.searchClassesPackage=searchClassesPackage
		$$$ThrowOnError( repo.%Save() )
		
		#dim repoManager as HS.FHIRServer.API.RepoManager
		Set repoManager =  ##class(HS.FHIRServer.API.RepoManager).getInstance(repo)
		
		#dim inst as HS.FHIRServer.ServiceInstance = repoManager.AddService(..MDSKeyToPackageList(.pLogFile, metadataSetKey))
		Set inst.IsDecommissioned=IsDecommissioned
		Set url = $Get(UrlById(id))
		if url'="" {
			Set inst.cspUrl = url
			kill UrlById(id)
		}
		Set inst.serviceConfigData = $G(@..#INSTGLOBAL@(id, "serviceConfigData"))
		Set inst.isEnabled = $G(@..#INSTGLOBAL@(id, "enabled"))
		$$$ThrowOnError( inst.%Save() )
		Set logmsg = "Saved repo: " _ repo.%Id() _ ", and inst: " _  inst.serviceId
		do ##class(HS.HC.Util.Installer).Log(.pLogFile, $$$CurrentClass, $$$CurrentMethod, logmsg)

		Do ..CompleteV3Upgrade(.pLogFile, repoManager, inst, metadataSetKey)
			
	}
	set svcId = ""
	for {
		Set svcId = $Order(UrlById(svcId),1,url)
		Quit:svcId=""
		
		Set logmsg = "Warning: Url had no associated service (" _ svcId _ "): " _ url
		do ##class(HS.HC.Util.Installer).Log(.pLogFile, $$$CurrentClass, $$$CurrentMethod, logmsg)
	}
	kill ^HS.FHIRServer("admin", "instance")
	kill ^HS.FHIRServer("admin", "rest")
	kill ^HS.FHIRServer.FHIRMetadataSetD
	kill ^HS.FHIRServer.ServiceInstanceD
}

ClassMethod MDSKeyToPackageList(ByRef pLogFile As %File, mdsKey As %String) As %List
{
	// Load the base FHIR metadata sets
	do ##class(HS.FHIRMeta.API).bootstrapMetadataSets()
	
	Set packageList = ""
	/// Deserialize a FHIRMetadataSet
	Set oldMetadataSetLocation = $Name(^HS.FHIRServer.FHIRMetadataSetD)
	set key = ""
	for {
		Set key = $Order(@oldMetadataSetLocation@(key),1,data)
		Quit:((key="") || (key = mdsKey))
		
		
	}
	if key '= "" {
		Set FHIRVersion = $lg(data,2)
		Set ExtendsKey  = $lg(data,3)
		// Preserve the other fields' mappings, not needed as of now
		//Set Description = $lg(data,4)
		//Set FileData    = $lg(data,5)
		if ExtendsKey = "" {
			Set mkey = $Select($E(FHIRVersion)=3:"HL7v30", 1:"HL7v40")
			#dim metaAPI as HS.FHIRMeta.API = ##class(HS.FHIRMeta.API).getInstance(mkey)
			return metaAPI.PackageList
		} else {
			return ..MDSKeyToFHIRVersion(ExtendsKey)
		}
	}	
	return packageList
}

ClassMethod CompleteV3Upgrade(ByRef pLogFile As %File, repoMgr As HS.FHIRServer.API.RepoManager, instance As HS.FHIRServer.ServiceInstance, mdsKey As %String)
{
	
	Set oldsp = $Name(^HS.FHIRServer.Meta(mdsKey, "sp"))
	do ##class(HS.FHIRMeta.API).bootstrapMetadataSets()
	#dim metaAPI as HS.FHIRMeta.API = ##class(HS.FHIRMeta.API).getInstance(mdsKey)
	#dim strategy as HS.FHIRServer.API.InteractionsStrategy = instance.CreateStrategy()
	
	// Move the Capability Statement for Json-base Strategies
	Set globalRoot = repoMgr.repo.globalRoot
	if $D(@globalRoot@("capability")) {
		merge @globalRoot@(instance.serviceId, "capability") = @globalRoot@("capability")
		kill @globalRoot@("capability")
	}	
	
	// Create the SearchColumns for this service
	kill ADDED	
	set rcount = 0
	set pcount = 0
	set rsrcType = ""
	for {
		Set rsrcType = $Order(@oldsp@(rsrcType))
		Quit:rsrcType=""
		set rcount = rcount + 1
		
		Set code = ""
		for {
			Set code = $Order(@oldsp@(rsrcType, code), 1, serial)
			Quit:code=""
			
			Set type = $LG(serial, 3)
			Continue:type="composite"
			
			#dim newParam As HS.FHIRMeta.SearchParam = metaAPI.FindSearchParam(rsrcType, code)
			if '$IsObject(newParam) {
				//w "Param Not Found in New: ", rsrcType,".",code,!
				Continue
			}
			set pcount = pcount + 1
			
			#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn
			Set searchColumn = ##class(HS.FHIRServer.Storage.Json.SearchColumn).CreateColumn(repoMgr, instance.serviceId, newParam, 0)
			// Capture the cardinality of the existing column
			Set searchClassName = strategy.GetSearchClass($Select(rsrcType="Resource":"", 1:rsrcType))
			set searchClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(searchClassName)
			if '$isobject(searchClassDef) {
				//w "No class for resourceType: ",rsrcType,": ",searchClassName,!
				continue 
			}
			
			if '..FindPropDef(searchClassDef, "MDVersion") {
				// Add an MDVersion column to each search table
				Set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
				//set tPropDef.
				set tPropDef.Name = "MDVersion"
				set tPropDef.Type = "HS.FHIRServer.Storage.StringPrimitive"
				Set tPropDef.Required = 0
				do tPropDef.Parameters.SetAt("EXACT","COLLATION")
				do searchClassDef.Properties.Insert(tPropDef)
				
				set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
				set tIndexDef.Name = "MDVersionIdx"
				set tIndexDef.Properties = "MDVersion"
				do searchClassDef.Indices.Insert(tIndexDef)
				$$$ThrowOnError( searchClassDef.%Save() )
			}			
			
			#dim propDef as %Dictionary.PropertyDefinition = ..FindPropDef(searchClassDef, searchColumn.ColumnName)
			if (searchColumn.DataType = "Quantity") || (searchColumn.DataType = "Range") {
				// If the field exists, then it is a scalar, otherwise it is a collection represented by a child table
				Set searchColumn.isMultiValue = '$IsObject(propDef)
				if searchColumn.isMultiValue {
					Set qClassName = searchClassName _ "." _ searchColumn.ColumnName
					// See if the Quantity Child Table exists
					set qClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(qClassName)
					if '$IsObject(qClassDef) {
						Set logmsg = "Warning: Quantity Class, " _ qClassName _ ", Not Found; Rebuild Required"
						do ##class(HS.HC.Util.Installer).Log(.pLogFile, $$$CurrentClass, $$$CurrentMethod, logmsg)
						Continue
					}
					set qProp = ..FindPropDef(qClassDef, "valueHigh")
					if '$IsObject(qProp) {
						// Create the property + (no index) for value (numeric high end of a range)
						set tNumPropDef = ##class(%Dictionary.PropertyDefinition).%New()
						set tNumPropDef.Name = "valueHigh"
						set tNumPropDef.Type = "%Numeric"
						do tNumPropDef.Parameters.SetAt(..#NUMERICSCALE,"SCALE")
						do qClassDef.Properties.Insert(tNumPropDef)
						
						$$$ThrowOnError( qClassDef.%Save() )
					}
					if searchColumn.DataType = "Range" {
						// Must re-populate any parameters that include 'Range' data
						Set $List(ADDED(searchColumn.TableName), *+1) = searchColumn.ColumnName
						Set searchColumn.Added = 1
					}
				}
			} else {
				if searchColumn.DataType = "Period" {
					Set propDef = ..FindPropDef(searchClassDef, searchColumn.ColumnName _ "Start")
				}
				if propDef = "" {
					//w "Not Found: ", searchClassDef.Name," :: ",searchColumn.ColumnName," as ",type,!
					Continue
				}			
			
				Set searchColumn.isMultiValue = (propDef.Collection = "list")
				Set fhirPath = newParam.fhirPath
				if $FIND(fhirPath, ".where(") || $FIND(fhirPath,".exists()") || $FIND(fhirPath, ".is(") {
					Set $List(ADDED(searchColumn.TableName), *+1) = searchColumn.ColumnName
					Set searchColumn.Added = 1
				}
			}	
			if searchColumn.isMultiValue '= $LG(serial,8) {
				//w "Cardinality Mismatch for ",	searchColumn.ColumnName, " as ", searchColumn.DataType,!
			}
			$$$ThrowOnError(searchColumn.%Save())
		}
	}
	Set logmsg = "Compiling Tables for FHIR " _ strategy.schema.FHIRVersion
	do ##class(HS.HC.Util.Installer).Log(.pLogFile, $$$CurrentClass, $$$CurrentMethod, logmsg)
	
	$$$ThrowOnError( $system.OBJ.CompilePackage(strategy.GetSearchClassesPackage(),"-d") )
	
	Set logmsg = rcount _ " resource tables converted"
	do ##class(HS.HC.Util.Installer).Log(.pLogFile, $$$CurrentClass, $$$CurrentMethod, logmsg)
	Set logmsg = pcount _ " search columns found"
	do ##class(HS.HC.Util.Installer).Log(.pLogFile, $$$CurrentClass, $$$CurrentMethod, logmsg)
	// Now Update the SearchTableVersion table to mark the tables that require re-population
	Set tcount = 0
	Set tableName = ""
	for {
		Set tableName = $Order(ADDED(tableName), 1, fieldList)
		Quit:tableName=""
	
		Do ##class(HS.FHIRServer.Storage.Json.SearchTableVersion).incrementVersion(repoMgr.repo.%Id(), tableName, fieldList)	
		do $I(tcount)
	}
	Set logmsg = tcount _ " tables marked to be re-populated"
	do ##class(HS.HC.Util.Installer).Log(.pLogFile, $$$CurrentClass, $$$CurrentMethod, logmsg)
}

ClassMethod FindPropDef(classDef As %Dictionary.ClassDefinition, fieldName As %String)
{
	for ord=1:1:classDef.Properties.Count() {
		#dim propDef as %Dictionary.PropertyDefinition = classDef.Properties.GetAt(ord)
		//w ord,": ",classDef.Name," :: ",propDef.Name,!
		if propDef.Name = fieldName {
			return propDef
		}
	}
	return ""
}

}

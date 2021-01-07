Include HS.FHIRServer

Class HS.FHIRServer.Storage.SearchTableBuilder Extends (%RegisteredObject, HS.FHIRServer.Util.FHIRQueryUtils)
{

Parameter NUMERICSCALE = 8;

Property repoInstance As HS.FHIRServer.RepoInstance;

Property strategy As HS.FHIRServer.API.InteractionsStrategy;

Property newTable As %Boolean;

Property nameCounter As %CacheString [ MultiDimensional ];

Parameter maxLen As %Integer = 30;

Method %OnNew(pStrategy As HS.FHIRServer.Storage.Json.InteractionsStrategy) As %Status
{
	Set ..repoInstance = pStrategy.RepoInstance
	set ..strategy = pStrategy
	Quit $$$OK
}

Method GenResourceTables(pVerbose As %Boolean = 1, deletePackage As %Boolean = 0)
{
 
	
	// Generate the Resource Class
	Set tRsrcPackageName = ..repoInstance.resourceClassesPackage
	Set verPackageName = ..repoInstance.versionClassesPackage
	Set tRsrcClassName = tRsrcPackageName _ ".Rsrc"
	Set tRsrcVersionClassName = verPackageName _ ".RsrcVer"
	if 'deletePackage {
		set resTableDef = ##class(%Dictionary.ClassDefinition).%OpenId(tRsrcClassName)
		if $isobject(resTableDef) {
			quit //do not regenerate existing tables
		}

	}
	
	w "Generating Tables",!

	// Clear all tables in the Index package
	// flag "e" = Delete Extent
	set tFlags = "e"
	// We are deleting the search classes as well as all data
	set tSC = $system.OBJ.DeletePackage(tRsrcPackageName, tFlags)
	$$$ThrowOnError(tSC)
	
	// Create the Class Definition
	set tableDef = ##class(%Dictionary.ClassDefinition).%New(tRsrcClassName)
	set tableDef.Super = ..strategy.#ResourceSuperclass
	set tableDef.GeneratedBy = $CLASSNAME()_".CLS"
	do tableDef.ProcedureBlockReset()
	
	// Create the Key Index and add it to the class
	#dim tIndexDef as %Dictionary.IndexDefinition
	set tIndexDefId = tRsrcClassName_"||KeyIdx"
	set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
	set tIndexDef.Name = "KeyIdx"
	set tIndexDef.Properties = "Key"
	set tIndexDef.Unique = 1
	set tIndexDef.PrimaryKey = 1
	set tIndexDef.Data = "Deleted"
	do tableDef.Indices.Insert(tIndexDef)
	
	// Create the Compartment Index and add it to the class
	set tIndexDefId = tRsrcClassName_"||CompartmentsIdx"
	set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
	set tIndexDef.Name = "CompartmentsIdx"
	set tIndexDef.Properties = "Compartments(ELEMENTS)"
	do tableDef.Indices.Insert(tIndexDef)
	
	w !,"Saving: " ,tableDef.Name
	set tSC = tableDef.%Save()
	$$$ThrowOnError(tSC)


	// Create the Version Class Definition
	set tableDef = ##class(%Dictionary.ClassDefinition).%New(tRsrcVersionClassName)
	set tableDef.Super = ..strategy.#ResourceVersionSuperclass
	set tableDef.GeneratedBy = $CLASSNAME()_".CLS"
	do tableDef.ProcedureBlockReset()
	
	// Create the Key Index and add it to the class
	set tIndexDefId = tRsrcVersionClassName_"||TypeIdVerIdx"
	set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
	set tIndexDef.Name = "TypeIdVerIdx"
	set tIndexDef.Properties = "ResourceType,ResourceId,VersionId"
	set tIndexDef.Unique = 1
	set tIndexDef.PrimaryKey = 1
	do tableDef.Indices.Insert(tIndexDef)
	

	w !,"Saving: " ,tableDef.Name
	set tSC = tableDef.%Save()
	$$$ThrowOnError(tSC)
	
	write !, "Compiling "_tRsrcPackageName_".*... "
	set tFlags = "e"
	if ('pVerbose) { set tFlags = tFlags_"-d" }
	set tSC = $system.OBJ.CompilePackage(tRsrcPackageName,tFlags)
	$$$ThrowOnError(tSC)
	set tSC = $system.OBJ.CompilePackage(verPackageName,tFlags)
	$$$ThrowOnError(tSC)
}

Method initNameCounter()
{
 set package=..repoInstance.searchClassesPackage_"."
 kill ..nameCounter
 set statement=##class(%SQL.Statement).%New()
 set sc=statement.%PrepareClassQuery("%Dictionary.ClassDefinition","Summary")
 $$$ThrowOnError(sc)
 set resultset=statement.%Execute()
 while resultset.%Next() {
	 set name = resultset.%Get("Name")
	 if $e(name,1,$l(package))'=package {
		 continue
	 }
	set truncatedName=$e(name,1,..#maxLen-2)
	i $increment(..nameCounter(truncatedName))
 }
}

Method GenSearchTablesFromSchema(pType As %String = "", pVerbose As %Boolean = 0, deletePackage As %Boolean = 1)
{
	// Call SearchParameters to ensure the latest 
	do {
		
		set tSearchTablePackage = ..repoInstance.searchClassesPackage
		
		// flag "e" = Delete Extent
		// flag "d" = Display
		set tFlags = "e"
		if ('pVerbose) { set tFlags = tFlags_"-d" }
		if deletePackage {
			write !, "Deleting "_tSearchTablePackage_".*... "
			set tSC = $system.OBJ.DeletePackage(tSearchTablePackage,tFlags)
			write "Done."
		}
		
		do ..initNameCounter()
		
		


		write !, "Generating "_tSearchTablePackage_".*... " 
		
		
		// Find the "base" resource, or create one if it does not exist. The "base" resource
		// contains search params common to all resource types. Then add to it the searchParams 
		// belonging to the "rest" (de-duplicating on name) as these are also common to all
		// resource types.
		
		Set commonParamNames = ""
		Set paramName = ""
		Set tablesForRepo = ##class(HS.FHIRServer.Storage.Json.SearchColumn).getTableListForRepoId(..repoInstance.repo.%Id())
		Set tix = 0
		while $ListNext(tablesForRepo, tix, tableName) {
			if tableName = "Resource" {
				// Set the table name to "" so that the strategy methods will return the
				// proper table/class name for the common fields
				Set tableName = ""
			}
			set tSearchTableName = ..strategy.GetSearchTable(tableName)
			set tSearchClassName = ..strategy.GetSearchClass(tableName)
			set tSearchTableDef = ##class(%Dictionary.ClassDefinition).%OpenId(tSearchClassName)
			set ..newTable = 0
			if '$isobject(tSearchTableDef) {
				set ..newTable = 1
				set tSearchTableDef = ##class(%Dictionary.ClassDefinition).%New(tSearchClassName)
				set tSearchTableDef.Super = "%Library.Persistent"
				set tSearchTableDef.GeneratedBy = $CLASSNAME()_".CLS"
				do tSearchTableDef.ProcedureBlockReset()
				if $l(tSearchClassName)>..#maxLen {
						set truncatedName=$e(tSearchClassName,1,..#maxLen-2)
						set prefix = "^"_truncatedName_$increment(..nameCounter(truncatedName))

						#dim storage As %Dictionary.StorageDefinition
						Set storage = ##class(%Dictionary.StorageDefinition).%New(tSearchClassName_"||Default")
						Set storage.Name = "Default"
						//Set storage.ExtentSize = 10000000
						Set storage.DataLocation = prefix_"D"
						
						Set storage.StreamLocation = prefix_"S"
						set storage.IndexLocation = prefix_"I"
						Do tSearchTableDef.Storages.Insert(storage)

			}
			}
			
			Set idListForRepoTable = ##class(HS.FHIRServer.Storage.Json.SearchColumn).getColumnIdsForRepoTable(..repoInstance.repo.%Id(), tableName)
			set rix = 0
			set proplist = ""
			while $ListNext(idListForRepoTable, rix, id) {
				set obj = ##class(HS.FHIRServer.Storage.Json.SearchColumn).getById(id)
				if obj.DataType = "Period" {
					// Param type is Period, we need 2 columns
					do ..AddProperty(obj,tSearchClassName,tSearchTableDef,..#PERIODSTARTSUFFIX,pVerbose,.proplist)
					do ..AddProperty(obj,tSearchClassName,tSearchTableDef,..#PERIODENDSUFFIX,pVerbose,.proplist)
				} else {
					do ..AddProperty(obj,tSearchClassName,tSearchTableDef,"",pVerbose,.proplist)
				}
			}
			if ..newTable {
				set tParamName = "MDVersion"
				set tPropDefId = tSearchTableName_"||"_tParamName
				Set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
				//set tPropDef.
				set tPropDef.Name = tParamName
				set tPropDef.Type = "HS.FHIRServer.Storage.StringPrimitive"
				Set tPropDef.Required = 0
				do tPropDef.Parameters.SetAt("EXACT","COLLATION")
				do tSearchTableDef.Properties.Insert(tPropDef)
				
				set tIndexDefId = tSearchTableName_"||"_tParamName_"Idx"
				set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
				set tIndexDef.Name = tParamName_"Idx"
				set tIndexDef.Properties = tParamName
				// set tIndexDef.IdKey = 1
				do tSearchTableDef.Indices.Insert(tIndexDef)

				
				set tParamName = "Key"
				set tPropDefId = tSearchTableName_"||"_tParamName
				Set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
				set tPropDef.Name = tParamName
				set tPropDef.Type = "HS.FHIRServer.Storage.StringPrimitive"
				Set tPropDef.Required = 1
				do tPropDef.Parameters.SetAt("EXACT","COLLATION")
				do tSearchTableDef.Properties.Insert(tPropDef)
				
				set tIndexDefId = tSearchTableName_"||"_tParamName_"Idx"
				set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
				set tIndexDef.Name = tParamName_"Idx"
				set tIndexDef.Properties = tParamName
				set tIndexDef.Unique = 1
				set tIndexDef.PrimaryKey = 1
				// set tIndexDef.IdKey = 1
				do tSearchTableDef.Indices.Insert(tIndexDef)
				
				// And add a 'VersionId' column to each search table
				set tParamName = "VersionId"
				set tPropDefId = tSearchTableName_"||"_tParamName
				Set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
				set tPropDef.Name = tParamName
				set tPropDef.Type = "HS.FHIRServer.Storage.StringPrimitive"
				Set tPropDef.Required = 0
				do tPropDef.Parameters.SetAt("EXACT","COLLATION")
				do tSearchTableDef.Properties.Insert(tPropDef)
			}

			// set xk = ""  for { set xx = tSearchTableDef.Properties.GetNext(.xk)  quit:xk=""  w xk,":",xx.Name,! }
			w !,"Saving: " ,tSearchTableDef.Name
			set tSC = tSearchTableDef.%Save()
			$$$ThrowOnError(tSC)
			//if any properties were added, bump the version
			if $ll(proplist) > 0 {
				do ##class(HS.FHIRServer.Storage.Json.SearchTableVersion).incrementVersion(..repoInstance.parentRepo.%Id(),tableName, proplist)
			}
		}
		write "Done."
		set tFlags = ""
		if ('pVerbose) { set tFlags = tFlags_"-d" }
		
		write !, "Compiling "_tSearchTablePackage_".*... "
		set tSC = $system.OBJ.CompilePackage(tSearchTablePackage,tFlags)
		$$$ThrowOnError(tSC)
		
		write !,"Done."
	} while 0  // End of once through block
	k ..nameCounter
}

/// Add/update properties and indices for a class definition
Method AddProperty(row As HS.FHIRServer.Storage.Json.SearchColumn, pSearchClassName As %String, ByRef pSearchTableDef As %Dictionary.ClassDefinition, suffix As %String = "", pVerbose As %Boolean = 0, ByRef propList As %List)
{
	write:pVerbose !,"search param: ",row.TableName,"::",row.ParamName_suffix , " as " , row.DataType
	//Reset addd if a new table
	if ..newTable {
		set row.Added = 0
		set sc = row.%Save()
		$$$ThrowOnError(sc)
	}
	if (row.Type = "quantity") && row.isMultiValue {
		set tQuantityClassName = pSearchClassName _ "." _ row.ColumnName_suffix
		//Skip if class already exists
		if ##class(%Dictionary.ClassDefinition).%ExistsId(tQuantityClassName) {
			quit
		}
		s propList = propList_$lb(row.ColumnName_suffix)

		// Create a new table that references the current table as a foreign key
		set tQuantityTableDef = ##class(%Dictionary.ClassDefinition).%New(tQuantityClassName)
		set tQuantityTableDef.Super = "%Persistent"
		set tQuantityTableDef.GeneratedBy = $CLASSNAME()_".CLS"
		if $l(tQuantityTableDef.Name)>..#maxLen {
						set truncatedName=$e(tQuantityTableDef.Name,1,..#maxLen-2)
						set prefix = "^"_truncatedName_$increment(..nameCounter(truncatedName))

						#dim storage As %Dictionary.StorageDefinition
						Set storage = ##class(%Dictionary.StorageDefinition).%New(tQuantityTableDef_"||Default")
						Set storage.Name = "Default"
						//Set storage.ExtentSize = 10000000
						Set storage.DataLocation = prefix_"D"
						
						Set storage.StreamLocation = prefix_"S"
						set storage.IndexLocation = prefix_"I"
						Do tQuantityTableDef.Storages.Insert(storage)

		}
		
		// Create the property constrained by the foreign key
		set tFKeyPropDef = ##class(%Dictionary.PropertyDefinition).%New()
		set tFKeyPropDef.Name = "Key"
		set tFKeyPropDef.Type = "HS.FHIRServer.Storage.StringPrimitive"
		do tQuantityTableDef.Properties.Insert(tFKeyPropDef)
		
		// Create the foreign key
		set tForeignKeyDef = ##class(%Dictionary.ForeignKeyDefinition).%New()
		set tForeignKeyDef.Name = "KeyIdFKey"
		set tForeignKeyDef.Properties = "Key"
		set tForeignKeyDef.ReferencedClass = pSearchClassName 
		set tForeignKeyDef.ReferencedKey = "KeyIdx"
		set tForeignKeyDef.OnDelete = "cascade"
		do tQuantityTableDef.ForeignKeys.Insert(tForeignKeyDef)
		
		// Create the property + index for value (numeric part of the quantity)
		set tNumPropDef = ##class(%Dictionary.PropertyDefinition).%New()
		set tNumPropDef.Name = "value"
		set tNumPropDef.Type = "%Numeric"
		do tNumPropDef.Parameters.SetAt(..#NUMERICSCALE,"SCALE")
		do tQuantityTableDef.Properties.Insert(tNumPropDef)
		set tNumPropIndexDef = ##class(%Dictionary.IndexDefinition).%New()
		set tNumPropIndexDef.Name = "valueIdx"
		set tNumPropIndexDef.Properties = "value"
		do tQuantityTableDef.Indices.Insert(tNumPropIndexDef)
		
		// Create the property + index for value (numeric high end of a range)
		set tNumPropDef = ##class(%Dictionary.PropertyDefinition).%New()
		set tNumPropDef.Name = "valueHigh"
		set tNumPropDef.Type = "%Numeric"
		do tNumPropDef.Parameters.SetAt(..#NUMERICSCALE,"SCALE")
		do tQuantityTableDef.Properties.Insert(tNumPropDef)
		set tNumPropIndexDef = ##class(%Dictionary.IndexDefinition).%New()
		set tNumPropIndexDef.Name = "valueHighIdx"
		set tNumPropIndexDef.Properties = "valueHigh"
		do tQuantityTableDef.Indices.Insert(tNumPropIndexDef)
		
		// Create the property + index for units
		set tUnitPropDef = ##class(%Dictionary.PropertyDefinition).%New()
		set tUnitPropDef.Name = "unit"
		set tUnitPropDef.Collection = "list"
		set tUnitPropDef.Type = "%String"
		do tUnitPropDef.Parameters.SetAt("", "MAXLEN")
		do tQuantityTableDef.Properties.Insert(tUnitPropDef)
		set tUnitPropIndexDef = ##class(%Dictionary.IndexDefinition).%New()
		set tUnitPropIndexDef.Name = "unitIdx"
		set tUnitPropIndexDef.Properties = "unit(ELEMENTS)"
		set tUnitPropIndexDef.Type = "bitmap"
		do tQuantityTableDef.Indices.Insert(tUnitPropIndexDef)
		
		set tParamName = "Key"
		set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
		set tIndexDef.Name = tParamName_"Idx"
		set tIndexDef.Properties = tParamName
		do tQuantityTableDef.Indices.Insert(tIndexDef)
		w !,"Saving: " ,tQuantityTableDef.Name
		$$$ThrowOnError( tQuantityTableDef.%Save() )
		quit
	}
	//check whether property with this name exists, if it does there is no need to do anything
	s found = 0
	for i=1:1:pSearchTableDef.Properties.Count() {
		set property = pSearchTableDef.Properties.GetAt(i)
		if property.Name = (row.ColumnName_suffix) {
			set found = 1
			quit
		}
	}
	if found {
		quit
	}
	
	set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
	set tPropDef.Name = row.ColumnName_suffix
	s propList = propList_$lb(row.ColumnName_suffix)

	do pSearchTableDef.Properties.Insert(tPropDef)
	if (row.DataType="number") { 
		set tPropDef.Type = "%Numeric"
		do tPropDef.Parameters.SetAt(..#NUMERICSCALE,"SCALE")
	} 
	elseif (row.Type = "quantity"){
		set tPropDef.Type = "HS.FHIRServer.Storage.QuantitySerial"
	}
	else {
		// Use the FHIR string type instead of %String to get around MAXLEN issues
		set tPropDef.Type = "HS.FHIRServer.Storage.StringPrimitive"
	}
	if (row.DataType="uri") || (row.DataType = "reference") || (row.DataType = "canonical"){
		// Search on URIs and Reference uses exact matching. See http://hl7.org/fhir/search.html#uri
		do tPropDef.Parameters.SetAt("EXACT","COLLATION")
	}
	
	// This has been recoded to ensure that the index cardinality is in sync with
	// the field definition, and that neither can be downgraded to scalar
	if row.isMultiValue {
		set tPropDef.Collection = "list"
	}

	set indexType = row.IndexType
	// we only create indexes during building, removal is handled separately
	if indexType '= ##class(HS.FHIRServer.Storage.Json.SearchColumn).#NoIndex {
		set tIndexDef = ""			
		for i=1:1:pSearchTableDef.Indices.Count() {
						set index = pSearchTableDef.Indices.GetAt(i)
						if index.Name = (row.ColumnName_suffix_ "Idx") {
							set tIndexDef = index
							quit
						}
		}
		if '$isobject(tIndexDef) {
			set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
			set tIndexDef.Name = row.ColumnName_suffix_"Idx"
			do pSearchTableDef.Indices.Insert(tIndexDef)
		}
	
					
		if tPropDef.Collection = "list" {
			set tIndexDef.Properties = row.ColumnName_suffix_"(ELEMENTS)"
		} elseif tIndexDef.Properties="" {			
			set tIndexDef.Properties = row.ColumnName_suffix
		}
		if indexType = ##class(HS.FHIRServer.Storage.Json.SearchColumn).#BitmapIndex {
			set tIndexDef.Type ="bitmap"
		}
	}
	
	/*if ..strategy.isBitmap(row.ParamName) {
		set tIndexDef.Type ="bitmap"
	}*/
}

Method Reset() As %Status
{
	try {
		set tSC = $$$OK
		// flag "e" = Delete Extent
		set tFlags = "e"
		set tSC = $system.OBJ.DeletePackage(..strategy.GetSearchClassesPackage(), tFlags) quit:$$$ISERR(tSC)
	}
	catch (ex) { set tSC = ex.AsStatus() }
	if ($$$ISERR(tSC)) { write !, $system.Status.GetOneErrorText(tSC) }
	quit tSC
}

}

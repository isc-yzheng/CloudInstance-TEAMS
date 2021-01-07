Class HS.FHIR.vSTU3.SearchTableBuilder Extends HS.FHIR.vCommon.SearchTableBuilder
{

/// The abstract class used for resource storage. The name of the package that
/// all the search tables will be generated into comes from the SEARCHTABLEPACKAGE
/// parameter of this class.
Parameter ABSTRACTCLASS = "HS.FHIR.vSTU3.Repository.Resource.Abstract";

Parameter MODELPACKAGE = "HS.FHIR.vSTU3.Model";

Parameter NUMERICSCALE = 8;

/// Generate the tables used for FHIR search, based on the given CapabilityStatement resource.
/// This method will generate one table for each resource defined in the CapabilityStatement, and each
/// table will have a column and an index for each search parameter defined for that resource.
/// Additionally, each table will have columns for the search parameters common to all types
/// (_lastUpdate, _profile, etc.), and there will be a table called "Resource" that will contain
/// columns for only the common search parameters, and will store these values for every resource
/// in the repository. This is to enable type-less search.<br>
/// pCSId is the ID of a CapabilityStatement resource in the current namespace that will be used
/// to generate the search tables.<br>
/// pType is optional and may be used to (re)generate only a single table, for example if a single
/// resource has been modified in the CapabilityStatement Only the table for the named type will be
/// (re)generated.<br>
/// <b>IMPORTANT:</b> If called without a pType parameter, this method will delete all data and 
/// classes in the search table package before regenerating them. If called with a pType parameter,
/// only the class and data for the named type and any sub-tables (ex: Observation.valueQuantity)
/// will be deleted. This method will not populate the new search tables. That has to be done via
/// HS.FHIR.vSTU3.Repository.Resource.Abstract:RebuildSearchIndices().
ClassMethod GenSearchTables(pCSId As %String, pType As %String = "", pVerbose As %Boolean = 0) As %Status
{
	#dim tCSObj			As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement
	#dim tCSRest		As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Rest
	#dim tCSResource	As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Resource
	#dim tCSSearchParam	As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.SearchParam
	
	try {
		set tSC = $$$OK
		if (pCSId = "") { set tSC = $$$ERROR($$$GeneralError, "No CapabilityStatement ID given") quit }
		set tCSStorageClass = $CLASSMETHOD(..#ABSTRACTCLASS, "GetStorageClass", "CapabilityStatement", .tSC) quit:$$$ISERR(tSC)
		if ('$CLASSMETHOD(..#ABSTRACTCLASS, "ResourceExists", "", "CapabilityStatement", pCSId)) { set tSC = $$$ERROR($$$GeneralError, "CapabilityStatement ID='"_pCSId_"' not found") quit }
		set tCSLogicalId = $CLASSMETHOD(..#ABSTRACTCLASS, "ResourceToLogicalId", "", "CapabilityStatement", pCSId)
		if (tCSLogicalId = "") { set tSC = $$$ERROR($$$GeneralError, "CapabilityStatement logical ID not found") quit }
		set tCSStorageObj = $CLASSMETHOD(tCSStorageClass, "%OpenId", tCSLogicalId,,.sc)
		if ($$$ISERR(sc)) { set tSC = $$$ERROR($$$GeneralError, "Error opening capability statement: "_$system.Status.GetOneErrorText(sc)) quit }
		
		set tSC = ..GenSearchTablesFromStorageObj(tCSStorageObj, pType, pVerbose)
	}
	catch (ex) { set tSC = ex.AsStatus() }
	if ($$$ISERR(tSC)) { write !, $system.Status.GetOneErrorText(tSC) }
	quit tSC
}

ClassMethod GenSearchTablesFromArray(ByRef pArray As %Library.RawString, pVerbose As %Boolean = 0) As %Status
{
	quit ..GenSearchTablesFromArrayInternal(.pArray, ..#ABSTRACTCLASS, ..#NUMERICSCALE, ..#MODELPACKAGE, pVerbose)
}

ClassMethod GenSearchTablesFromStorageObj(pStorageObj As HS.FHIR.vDSTU2.Repository.Resource.Abstract, pType As %String = "", pVerbose As %Boolean = 0) As %Status
{
	
	#dim tCSObj			As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement
	#dim tCSRest		As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Rest
	#dim tCSResource	As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Resource
	#dim tCSSearchParam	As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.SearchParam
	
	try {
		set tSC = $$$OK
		set tSC = pStorageObj.LoadResource() quit:$$$ISERR(tSC)
		set tCSObj = pStorageObj.Resource
		
		if ('$IsObject(tCSObj.rest))||(tCSObj.rest.Count()=0) { write !, "CapabilityStatement has no 'rest' defined. No search tables will be generated." quit }
		// Why would a CapabilityStatement have >1 rest?
		if (tCSObj.rest.Count() > 1) { write !, "WARNING: CapabilityStatement contains more than 1 'rest'. Only the first will be used." }
		set tCSRest = tCSObj.rest.GetAt(1)
		
		if ('$IsObject(tCSRest.resource))||(tCSRest.resource.Count()=0) { write !, "CapabilityStatement rest has no resources defined. No search tables will be generated." quit }
		
		set tSearchTablePackage = $PARAMETER(..#ABSTRACTCLASS, "SEARCHTABLEPACKAGE")
		
		// flag "e" = Delete Extent
		// flag "d" = Display
		set tFlags = "e"
		if ('pVerbose) { set tFlags = tFlags_"-d" }
		if (pType'="") { 
			write !, "Deleting "_tSearchTablePackage_"."_pType_" and any tables in that package... "
			set tSC = $system.OBJ.Delete(tSearchTablePackage_"."_pType,tFlags) quit:$$$ISERR(tSC)
			set tSC = $system.OBJ.DeletePackage(tSearchTablePackage_"."_pType,tFlags)
		}
		else { 
			write !, "Deleting "_tSearchTablePackage_".*... "
			set tSC = $system.OBJ.DeletePackage(tSearchTablePackage,tFlags)
		}
		quit:$$$ISERR(tSC)
		write "Done."
		if (pType'="") { write !, "Generating "_tSearchTablePackage_"."_pType_"... " }
		else { write !, "Generating "_tSearchTablePackage_".*... " }
		
		// Find the "base" resource, or create one if it does not exist. The "base" resource
		// contains search params common to all resource types. Then add to it the searchParams 
		// belonging to the "rest" (de-duplicating on name) as these are also common to all
		// resource types.
		set tBaseResourceObj = ""
		set tBaseResourceType = $PARAMETER(..#ABSTRACTCLASS, "BASERESOURCE")
		for tI=1:1:tCSRest.resource.Count() {
			set tCSResource = tCSRest.resource.GetAt(tI)
			if (tCSResource.type.value = tBaseResourceType) {
				set tBaseResourceObj = tCSResource
				quit
			}
		}
		// If no "base" resource was found, create one and insert it into the "rest"
		if (tBaseResourceObj = "") {
			set tBaseResourceObj = ##class(HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Resource).%New()
			set tSC = tBaseResourceObj.SetType(tBaseResourceType) quit:$$$ISERR(tSC)
			set tSC = tCSRest.resource.Insert(tBaseResourceObj) quit:$$$ISERR(tSC)
		}
		// Now go through the search params belonging to the "rest", and add them to the
		// the "base" resource if not already present.
		for tI=1:1:tCSRest.searchParam.Count() {
			set tRestSearchParam = tCSRest.searchParam.GetAt(tI)
			set tFound = 0
			for tJ=1:1:tBaseResourceObj.searchParam.Count() {
				if (tBaseResourceObj.searchParam.GetAt(tJ).name.value = tRestSearchParam.name.value) { set tFound=1 }
			}
			if ('tFound) { do tBaseResourceObj.searchParam.Insert(tRestSearchParam) }
		}
		set tBaseResourceHasParams = ($IsObject(tBaseResourceObj.searchParam)&&(tBaseResourceObj.searchParam.Count()>0))
		
		
		for tI=1:1:tCSRest.resource.Count() {
			set tCSResource = tCSRest.resource.GetAt(tI)
			set tResourceType = tCSResource.type.value
			if (pType'="")&&(tResourceType'=pType) { continue }
			set tCSResourceHasParams = ($IsObject(tCSResource.searchParam)&&(tCSResource.searchParam.Count()>0))
			if ('tCSResourceHasParams)&&('tBaseResourceHasParams) {
				write !, "No search params found for resource type '"_tResourceType_"'. Search table will not be generated."
				continue
			}
			
			write:pVerbose !, "Resource type: "_tResourceType
			
			// Create the class definition for the search table for this type
			set tSearchTableName = tSearchTablePackage_"."_tResourceType
			set tSearchTableDef = ##class(%Dictionary.ClassDefinition).%New(tSearchTableName)
			set tSearchTableDef.Super = "%Library.Persistent"
			set tSearchTableDef.GeneratedBy = $CLASSNAME()_".CLS"
			do tSearchTableDef.ProcedureBlockReset()
			
			// Copy the base resource params into the params for this resource, unless this is the
			// base resource
			if (tBaseResourceHasParams)&&(tResourceType'=tBaseResourceType) {
				for tJ=1:1:tBaseResourceObj.searchParam.Count() { 
					set tSC = tCSResource.searchParam.Insert(tBaseResourceObj.searchParam.GetAt(tJ)) quit:$$$ISERR(tSC)
				}
				quit:$$$ISERR(tSC)
			}
			
			for tJ=1:1:tCSResource.searchParam.Count() {
				set tCSSearchParam = tCSResource.searchParam.GetAt(tJ)
				write:pVerbose !, "search param: "_tCSSearchParam.name.value
				
				set tOrigParamName = tCSSearchParam.name.value
				set tParamName = $classmethod(..#ABSTRACTCLASS, "NormalizeParamName", tOrigParamName)
				set tParamType = tCSSearchParam.type.value
				
				// Quantities are handled differently from other param types.
				if (tParamType = "quantity") {
					set tQuantityTableName = tSearchTableName_"."_tParamName
					// Create a new table that references the current table as a foreign key
					set tQuantityTableDef = ##class(%Dictionary.ClassDefinition).%New(tQuantityTableName)
					set tQuantityTableDef.Super = "%Persistent"
					set tQuantityTableDef.GeneratedBy = $CLASSNAME()_".CLS"
					// Create the property constrained by the foreign key
					set tFKeyPropDef = ##class(%Dictionary.PropertyDefinition).%New()
					set tFKeyPropDef.Name = "ResourceLogicalId"
					set tFKeyPropDef.Type = "%Integer"
					do tQuantityTableDef.Properties.Insert(tFKeyPropDef)
					// Create the foreign key
					set tForeignKeyDef = ##class(%Dictionary.ForeignKeyDefinition).%New()
					set tForeignKeyDef.Name = "ResourceLogicalIdFKey"
					set tForeignKeyDef.Properties = "ResourceLogicalId"
					set tForeignKeyDef.ReferencedClass = tSearchTableName
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
					
					set tParamName = "ResourceLogicalId"
					set tIndexDefId = tQuantityTableName_"||"_tParamName_"Idx"
					set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
					set tIndexDef.Name = tParamName_"Idx"
					set tIndexDef.Properties = tParamName
					do tQuantityTableDef.Indices.Insert(tIndexDef)
					
					set tSC = tQuantityTableDef.%Save() quit:$$$ISERR(tSC)
				}
				else {
					// If this search param searches a period property, we want to
					// make *two* properties and indices, one for the start time and
					// one for the end time.
					if ($CLASSMETHOD(..#ABSTRACTCLASS, "ParamSearchesPeriod", tResourceType, tOrigParamName)) {
						set tParamList = tParamName_$PARAMETER(..#ABSTRACTCLASS, "PERIODSTARTSUFFIX")_"^"_tParamName_$PARAMETER(..#ABSTRACTCLASS, "PERIODENDSUFFIX")
					}
					else { set tParamList = tParamName }
					for tK=1:1:$L(tParamList,"^") {
						set tOneParamName = $P(tParamList,"^",tK)
						set tPropDefId = tSearchTableName_"||"_tOneParamName
						set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
						set tPropDef.Name = tOneParamName
						do tSearchTableDef.Properties.Insert(tPropDef)
						if (tParamType="number") { 
							set tPropDef.Type = "%Numeric"
							do tPropDef.Parameters.SetAt(..#NUMERICSCALE,"SCALE")
						}
						// Use the FHIR string type instead of %String to get around MAXLEN issues
						else { set tPropDef.Type = ..#MODELPACKAGE_".Datatype.StringPrimitive" }
						// Search on URIs uses exact matching. See http://hl7.org/fhir/search.html#uri
						if (tParamType="uri") {
							do tPropDef.Parameters.SetAt("EXACT","COLLATION")
						}
						set tPropDef.Collection = "list"
						
						set tIndexDefId = tSearchTableName_"||"_tOneParamName_"Idx"
						set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
						set tIndexDef.Name = tOneParamName_"Idx"
						do tSearchTableDef.Indices.Insert(tIndexDef)			
						set tIndexDef.Properties = tOneParamName_"(ELEMENTS)"
						if ..IndexIsBitmap(tResourceType, tOrigParamName) { set tIndexDef.Type = "bitmap" }
					}
				}
			}
			
			// Additionally, make a property referencing the original resource and index on it
			set tParamName = "ResourceLogicalId"
			set tPropDefId = tSearchTableName_"||"_tParamName
			set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
			set tPropDef.Name = tParamName
			set tPropDef.Type = ..#ABSTRACTCLASS
			do tSearchTableDef.Properties.Insert(tPropDef)
			
			set tIndexDefId = tSearchTableName_"||"_tParamName_"Idx"
			set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
			set tIndexDef.Name = tParamName_"Idx"
			set tIndexDef.Properties = tParamName
			set tIndexDef.IdKey = 1
			do tSearchTableDef.Indices.Insert(tIndexDef)
			
			set tSC = tSearchTableDef.%Save() quit:$$$ISERR(tSC)
		}
		quit:$$$ISERR(tSC)
		write "Done."
		set tFlags = ""
		if ('pVerbose) { set tFlags = tFlags_"-d" }
		if (pType'="") {
			write !, "Compiling "_tSearchTablePackage_"."_pType_" and any tables in that package... "
			set tSC = $system.OBJ.Compile(tSearchTablePackage_"."_pType,tFlags) quit:$$$ISERR(tSC)
			set tSC = $system.OBJ.CompilePackage(tSearchTablePackage_"."_pType,tFlags)
		}
		else { 
			write !, "Compiling "_tSearchTablePackage_".*... "
			set tSC = $system.OBJ.CompilePackage(tSearchTablePackage,tFlags)
		}
		quit:$$$ISERR(tSC)
		write "Done."
	}
	catch (ex) { set tSC = ex.AsStatus() }
	if ($$$ISERR(tSC)) { write !, $system.Status.GetOneErrorText(tSC) }
	quit tSC
}

ClassMethod Reset() As %Status
{
	try {
		set tSC = $$$OK
		// flag "e" = Delete Extent
		set tFlags = "e"
		set tSC = $system.OBJ.DeletePackage($PARAMETER(..#ABSTRACTCLASS, "SEARCHTABLEPACKAGE"),tFlags) quit:$$$ISERR(tSC)
	}
	catch (ex) { set tSC = ex.AsStatus() }
	if ($$$ISERR(tSC)) { write !, $system.Status.GetOneErrorText(tSC) }
	quit tSC
}

}

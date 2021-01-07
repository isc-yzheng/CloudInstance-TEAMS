Include HS.FHIRMeta

Class HS.FHIRMeta.Load.SearchParams Extends (%RegisteredObject, HS.FHIRMeta.MetaUtils)
{

Property fpAPI As HS.FHIRPath.API;

Property searchParams [ MultiDimensional ];

Property spTypeMap [ MultiDimensional ];

Method %OnNew(metaAPI As HS.FHIRMeta.API) As %Status
{
	Set ..fpAPI = metaAPI.FHIRPathAPI
	// Build constant mappings for this execution.
	Do ..GetTypesForCodeMap(.spTypeMap)
	Merge ..spTypeMap = spTypeMap
	return $$$OK
}

/// Display the parse tree for each Search Parameter expression
Method processSearchParams(loader As NpmLoader, builder As Builder, includeExperimental As %Boolean = 0)
{
	#dim parser as HS.FHIRPath.Parser = ##class(HS.FHIRPath.Parser).%New()
	
	Do ..gatherUrlBaseData(loader, includeExperimental, .urlList)
	
	// Loop through the search parameters
	Set count=0
	Set url = ""
	for {
		// Get the next parameter and its list of applicable resourceTypes		
		Set url = $Order(urlList(url), 1, baseTypeList)
		Quit:url=""
		
		Set jsp = loader.getRsrcByUrl(url)
		Continue:jsp.type="composite"
		Continue:jsp.type="special"
		
		Do ..createParamsForCode(jsp, baseTypeList, .PARAMS)
		Set count = count + PARAMS
		Merge ..searchParams = PARAMS
	}
	set ..searchParams = count
}

Method createParamsForCode(jsp As %DynamicObject, baseTypeList As %List, Output PARAMS)
{
	KILL PARAMS
	Set PARAMS = 0
	//w !,jsp.id,"[",jsp.code,"]: ",jsp.expression, !
	Set exprSet = jsp.expression
	if exprSet="" {
		return
	}
	
	kill allDatatypes
	
	// Create a list of OR'd path specs
	Set count = $Length(exprSet,"|")
	for ord=1:1:count {
		Set expr = ..trim($Piece(exprSet,"|",ord))
		// Strip surrounding Parens
		while ($E(expr,1)="(") && ($E(expr,*)=")") {
			Set expr = ..trim($E(expr, 2, *-1))
		}
		Set resourceType = $Select( $LL(baseTypeList) = 1:$LG(baseTypeList), 1:$Piece(expr,".",1))
		
		Set tree = ..fpAPI.parse(expr)
		//w resourceType,"|",jsp.code,"|",expr, " -> "
		Do ..fpAPI.getPathAndType(resourceType, tree, .pathList, .fhirType)
		if fhirType = "" {
			w "Unable to process FHIRPath expression: ",expr,!
			Continue
		}
		if fhirType="Resource" {
			// We don't handle embedded resources yet
			Continue
		}
		if $Find(fhirType,".") {
			// We don't handle Backbone Element objects (specials)
			// (Backbone element types are synthesized based on their path, so any typename
			// that contains a '.' derives from BackboneElement)
			Continue
		}
		
		Set isMultiValue = fhirType("mv")
		Set resolveType = ""
		Set resolveInfo = $S($D(fhirType("r"),resolveType):" to "_resolveType, 1:"")
		Set variantInfo = $S($D(fhirType("vt"),typeList):" ("_$LTS(typeList)_")", 1:"")
		// w fhirType, resolveInfo, variantInfo,  " at ",$LTS(pathList),!
		
		// We have the resourceType, datatype and pathList for this expression.
		// Build the SearchParam objects and save by (rsrcType, code)
		#dim paramObj as HS.FHIRMeta.SearchParam
		if $D(PARAMS(resourceType, jsp.code), paramSerial)#2 {
			Set paramObj = ##class(HS.FHIRMeta.SearchParam).fromSerial(paramSerial)
			// This is an additional expression for this resource type, by definition there
			// could be more than one value for this parameter
			Set paramObj.isMultiValue = 1
			if '$D(allDatatypes(resourceType, fhirType)) {
				Set allDatatypes(resourceType, fhirType) = ""
				Set paramObj.datatypes = paramObj.datatypes _ $LB(fhirType)
			}
			Set paramObj.expression = paramObj.expression _ $LB(pathList)
			Set paramObj.fhirPath = paramObj.fhirPath _ "|" _ expr
		
		} else {
			// This is the first occurrence of this resource type for this code
			Set paramObj = ##class(HS.FHIRMeta.SearchParam).%New()
			Set PARAMS(resourceType, jsp.code) = paramObj
			// Count unique parameters with specified resourceType and code
			Do $I(PARAMS)
			
			Set paramObj.resourceType = resourceType
			Set paramObj.type = jsp.type
			Set paramObj.name = jsp.name
			Set paramObj.code = jsp.code
			Set paramObj.expression = $LB(pathList)
			Set paramObj.datatypes = $LB(fhirType)
			Set allDatatypes(resourceType, fhirType) = ""
			Set paramObj.fhirPath = expr
			if isMultiValue {
				Set paramObj.isMultiValue = 1
			}
			
			// If the path resolves to a variant, include only the subset of allowed variantTypes
			// that are compatable with the searchParam type.
			if fhirType = "variant" {
				Set allowedTypes = ""
				Set vtix=0
				while $ListNext($Get(fhirType("vt")), vtix, vtype) {
					if $D(..spTypeMap(jsp.type, vtype)) {
						Set $List(allowedTypes,*+1) = vtype	
					}
				}
				Set paramObj.variantTypes = allowedTypes
			}
			
			if jsp.target '= "" {
				if paramObj.type '= "reference" {
					// Validating an assumption here.
					w "Target for non-reference: "_resourceType_", name: "_jsp.name," -> ",jsp.target.%ToJSON(),!
				}
				if (jsp.code = "patient") && ( (jsp.version = "") || ($E(jsp.version) = "3" ) ) {
					// NOTE:  This is a hack to handle patient search parameters in v3.0.1 where the expression does not limit
					// the targets for the 'patient' search parameter.
					set paramObj.target = $LB("Patient")
				} elseif resolveType '= "" {
					// If the expression included a 'Resolve()' where clause, use that type
					set paramObj.target = $LB(resolveType)
				} else {
					// Allow targets as specified by the SearchParameter metadata
					Set schemaTargets = $Get(fhirType("tl"), $LB("Resource"))
					Set paramTargets = ..arrayToList(jsp.target)
					if $LG(schemaTargets)="Resource" {
						if $LL(paramTargets) > 20 {
							Set targetList = schemaTargets
						} else {
							set targetList = $S(paramTargets'="":paramTargets, 1:schemaTargets)
						}
					} else {
						Set targetList = ""
						set tlix=0
						while $ListNext(schemaTargets, tlix, target) {
							if $ListFind(paramTargets, target) {
								Set $List(targetList,*+1) = target
							}
						}
					}
					//w jsp.code,": ***",$LTS(schemaTargets), " *** ",$LTS(paramTargets)," -> ",$LTS(targetList),!
					set paramObj.target = targetList
				}
			}
		}
		Set PARAMS(resourceType, paramObj.code) = paramObj.toSerial()
	}
}

ClassMethod trim(str As %String) As %String
{
	Set first = 1
	Set last = $L(str)
 	for f=first:1:last {
		Quit:($E(str,f) '= " ")
	}
	
	for l=last:-1:first {
		Quit:($E(str,l) '= " ")
	}
	return $E(str,f,l)
}

/// Display the parse tree for each Search Parameter expression
ClassMethod GetTypesForCodeMap(Output map)
{
	do setmap("token", $LB("boolean", "code", "id", "string", "CodeableConcept", "Coding", "ContactPoint", "Identifier"))
	do setmap("string", $LB("string", "Address", "HumanName","markdown"))
	do setmap("uri", $LB("canonical", "uri", "url", "oid", "uuid"))
	do setmap("quantity", $LB("Age", "Duration", "Money", "Quantity", "Range"))
	do setmap("reference", $LB("uri", "Reference", "canonical"))
	do setmap("date", $LB("date", "dateTime", "instant", "Period", "Timing"))
	do setmap("number", $LB("decimal", "integer", "positiveInt", "unsignedInt"))
	Quit
	
setmap(key, l) 
	set lix = 0
	while $ListNext(l, lix, value) {
		Set map(key, value) = ""
	}	
	Quit
}

Method dumpSP()
{
	merge sp = ..searchParams
	set rsrcType=""
	for {
		Set rsrcType = $Order(sp(rsrcType))
		Quit:rsrcType=""
		
		Set code =""
		for {
			Set code = $Order(sp(rsrcType, code), 1, spSer)
			Quit:code=""
			
			#dim o as HS.FHIRMeta.SearchParam = ##class(HS.FHIRMeta.SearchParam).fromSerial(spSer)
			
			if o.type="composite" {
				set o = ll.GetAt(ord) w o.resourceType,"?",o.name," composite of (", $lts(o.target), ")",!
			} else {
				if o.otherParams = "" {
					Set set = 1
					Set set(1) = o
				} else {
					// reorder by property name
					do o.getParamSet(.set)
				}
				for iparam=1:1:set {
					set o=set(iparam)
					w:(iparam=1) o.resourceType,"?",o.name,$Select(set>1:" is multi-sourced ...",1:"")
					w:(set>1) !,"      "
					
					w "[",o.type,"] (",$lts(o.expression),$Select(o.isMultiValue:") => ", 1:") -> "),$lts(o.datatypes)
					if $LG(o.datatypes)="variant" {
						w " (",$LTS(..sortList(o.variantTypes)),")"
					}
					if o.type="reference" {
						w " to (",$lts(..sortList(o.target)),")"
					} 
					for dtix=1:1:$LL(o.datatypes) {
						Set dataTypeMap($LG(o.datatypes,dtix)) = 1	
					}
					set typeMap(o.type) = 1
				}
			}
			w !
		}
		
	}
	w sp, " total search parameters"
}

ClassMethod sortList(list As %List)
{
	set ix=0
	Set out = ""
	while $ListNext(list, ix, value) {
		if value = "" {
			Set $List(out,*+1) = value
		} else {
			Set v(value) = ""
		}
	}
	Set value = ""
	for {
		Set value = $Order(v(value))
		Quit:value=""
		
		Set $List(out,*+1) = value
	}
	return out
}

ClassMethod getMultiFlag(builder As HS.FHIRMeta.Load.Builder, pathList As %String)
{
	#dim fieldObj as HS.FHIRMeta.Load.Field
	Set type = $LG(pathList,1)
	Set fieldIndex = 0
	Set isArray = 0
	Set inArray = 0
	for ord=2:1:$LL(pathList) {
		if isArray {
			Set inArray = 2
		}
		Set propName = $LG(pathList, ord)
		Set fieldObj = builder.GetExtensionField(type, propName, fieldIndex)
		if fieldObj = "" {
			Set fieldObj = builder.findField( type, propName )
		} 
		Set isArray = fieldObj.isArray
		set type = fieldObj.fhirType
	}
	return inArray + isArray
}

ClassMethod arrayToList(array As %DynamicArray) As %List
{
	Set list = ""
	
	if $IsObject(array) {
		Set iter = array.%GetIterator()
		while iter.%GetNext(.ss, .val) {
			Set $List(list, *+1) = val
		}
	}
	Return list
}

ClassMethod gatherUrlBaseData(loader As HS.FHIRMeta.Load.NpmLoader, includeExperimental As %Boolean, Output urlList)
{
	Set iterator = loader.getRsrcIterator("SearchParameter")
	while iterator.Next(.jsp) {
		set url = jsp.url
		Continue:(jsp.base="")
		Continue:(jsp.expression="")
		Continue:('includeExperimental && jsp.experimental)
		Set btIter = jsp.base.%GetIterator()
		while btIter.%GetNext(.btix, .base) {
			if jsp.derivedFrom = "" {
				Set param(base, jsp.code, url) = ""
			} else {
				// For now, ignore any derived SearchParameters.  Their changes are not
				// pertinent to our processing
				// Set derives($I(derives)) = $LB(base, jsp.code, jsp.derivedFrom, url)
			}
		}
	}
	Set dix = ""
	for {
		Set dix = $Order(derives(dix), 1, list)
		Quit:dix=""
		kill param($LG(list,1), $LG(list, 2), $LG(list,3))
	}
	kill derives
	// Now organize by SearchParam, then base
	Set base = ""
	for {
		Set base = $Order(param(base))
		Quit:base=""
		
		Set code = ""
		for {
			Set code = $Order(param(base, code))
			Quit:code=""
			Set url = ""
			for {
				Set url = $Order(param(base, code, url))
				Quit:url=""
				
				Set $List(urlList(url), *+1) = base
			}
		}
	}
	kill param
}

}

Class HS.FHIRMeta.Load.ValueSets Extends %RegisteredObject
{

Property valueSets [ MultiDimensional ];

Property codeSystems [ MultiDimensional ];

Method %OnNew(loader As NpmLoader) As %Status
{
	Set iterator = loader.getRsrcIterator("ValueSet")
	while iterator.Next(.valueSet) {
		Do ..addValueSet(valueSet)
	}
	Set iterator = loader.getRsrcIterator("CodeSystem")
	while iterator.Next(.codeSystem) {
		Do ..addCodeSystem(codeSystem.url, codeSystem)
	}
	
	return $$$OK
}

Method addValueSet(jrsrc As %DynamicObject)
{
	Set key = jrsrc.url
	//w "ValueSet ",key,": ",jrsrc.id, !
	Set codeSystemList = ""
	Set codeList = ""
	Set valueSetList = ""
	if jrsrc.compose '= "" {
		Set iter = jrsrc.compose.include.%GetIterator()
		while iter.%GetNext(.subsc, .include) {
			// Include is a list of objects which are handled based on available fields:
			// has "system+concept", Use list of concept values (subset of code system)
			// has "system+filter", Apply filter to code system values (not supported now)
			// has "system" only, Use all values from code system
			// has "valueSet", treat as "redirect" 
			if include.system '= "" {
				if include.concept '= "" {
					Set citer = include.concept.%GetIterator()
					while citer.%GetNext(.csub, .concept) {
						set $List(codeList,*+1) = concept.code
					}
					
				} elseif include.filter '= "" {
					// Not yet supported
				} else {
					// Include the entire code system
					set $List(codeSystemList,*+1) = include.system
				}
			}
			if include.valueSet '= "" {
				Set vsIter = include.valueSet.%GetIterator()
				while vsIter.%GetNext(.vsub, .vset ) {
					set $List(valueSetList,*+1) = vset
				}
			}
		}
		//w key,": ",((codeSystemList'="")+(codeList'="")+(valueSetList'="")),!
		Set:(codeSystemList'="") ..valueSets(key,"cs") = codeSystemList
		Set:(codeList'="") ..valueSets(key,"codes") = codeList
		Set:(valueSetList'="") ..valueSets(key,"vs") = valueSetList
	}
}

Method addCodeSystem(fullUrl As %String, jrsrc As %DynamicObject)
{
	Set key = jrsrc.url
	if jrsrc.content '= "complete" {
		return
	}
	//w "CodeSystem ",key,": ",jrsrc.id,!
	Set valueList = ""
	if jrsrc.concept '= "" {
		do ..addCodeSystemConcept(.valueList, jrsrc.concept)
	} else {
		w "No Concepts found for code system: ",key,!
	}

	Set ..codeSystems(key) = valueList
	if fullUrl '= key {
		Set ..codeSystems(fullUrl) = valueList
	}
}

Method addCodeSystemConcept(ByRef valueList As %String, conceptList As %DynamicArray)
{
	Set iter = conceptList.%GetIterator()
	while iter.%GetNext(.subsc, .concept) {
		set $List(valueList,*+1) = concept.code
		// recurse if necessary
		if concept.concept '= "" {
			Do ..addCodeSystemConcept(.valueList, concept.concept)
		}
	}
}

Method getValueSetCodes(valueSetUrl As %String, Output vsCodes)
{
	if $D(..valueSets(valueSetUrl, "cs"), codeSysList) {
		//w "cs | ",typeName,".",propName,"=",$lts(codeSysList),!
		for ord=1:1:$LL(codeSysList) {
			Set codeSysUrl = $LG(codeSysList,ord)
			Set codeList = $Get(..codeSystems(codeSysUrl))
			if codeList = "" {
				//w "Unknown CodeSystem: ",codeSysUrl,!
			} else {
				do ..addCodeEnums(codeList, .vsCodes)
			}
		}		
	}
	if $D(..valueSets(valueSetUrl, "codes"), codeList) {
		do ..addCodeEnums(codeList, .vsCodes)
	}
	if $D(..valueSets(valueSetUrl, "vs"), valueSetList) {
		for ival=1:1:$LL(valueSetList) {
			//w "vs | ",typeName,".",propName,"=",$lts(valueSetList),!
			Do ..getValueSetCodes(valueSetList(ival), .vsCodes)
		}
	}
}

Method addCodeEnums(codeList As %String, Output vsCodes)
{
	//w "codes | ",typeName,".",propName,"=",$lts(codeList),!
	for ival=1:1:$LL(codeList) {
		Set vsCodes($LG(codeList,ival)) = 1
	}
}

}

Class HS.FHIRMeta.Impl.SearchInfo Extends Base
{

Property nonSearchParams [ MultiDimensional ];

Property paramCache [ MultiDimensional ];

Property isNewParams As %Boolean [ Calculated ];

Method useNewParams(isNew As %Boolean)
{
}

Method isNewParamsGet() As %Boolean [ CodeMode = expression ]
{
1
}

Method FindSearchParam(resourceType As %String, pParamName As %String) As HS.FHIRMeta.SearchParam
{
	Set useType = $Select(resourceType="":"DomainResource", 1:resourceType)

	Set searchParam = ""
	for {
		if $D(..paramCache(useType, pParamName), searchParam) {
			Quit
		}
		if $D(@..SpGbl@(useType, pParamName), ser) {
			Set searchParam = ##class(HS.FHIRMeta.SearchParam).fromSerial(ser)
			Set ..paramCache(useType, pParamName) = searchParam
			Quit
		}
		if useType = "Resource" {
			Quit
		} elseif useType = "DomainResource" {
			Set useType = "Resource"
		} else {
			Set useType = "DomainResource"
		}
	}
	return searchParam
}

Method NextSearchParamResourceType(prevType As %String) As %String [ CodeMode = expression ]
{
$Order(@..SpGbl@(prevType))
}

Method NextSearchParamName(resourceType As %String, prevName As %String) As %String [ CodeMode = expression ]
{
$Order(@..SpGbl@(resourceType, prevName))
}

Method NextSearchParamForResourceType(resourceType As %String, prevParam As HS.FHIRMeta.SearchParam) As HS.FHIRMeta.SearchParam
{
	Set prevName = $S(prevParam="":"", 1:prevParam.code)
	Set name = $Order(@..SpGbl@(resourceType, prevName))
	if name '= "" {
		return ..FindSearchParam(resourceType, name)
	}
	return ""
}

Method IsNonSearchParam(paramName As %String) As %Boolean [ CodeMode = expression ]
{
$Get(..nonSearchParams(paramName), 0)
}

Method ExportAllSearchParams() As %ListOfObjects
{
	
	#dim list as %ListOfObjects = ##class(%ListOfObjects).%New()
	Set rn=""
	for {
		Set rn = ..NextSearchParamResourceType(rn)
		Quit:rn=""
		Set param=""
		for {
			Set param = ..NextSearchParamForResourceType(rn, param)
			Quit:param=""
			Do list.Insert(param)
		}
		
	}
	Return list
}

Method DumpSearchParams()
{

	#dim ll as %ListOfObjects = ..ExportAllSearchParams()
	for ord=1:1:ll.Count() { 
		#dim o as HS.FHIRMeta.SearchParam = ll.GetAt(ord)
		if o.type="composite" {
			set o = ll.GetAt(ord) w o.resourceType,"?",o.name," composite of (", $lts(o.target), ")",!
		} else {
			if o.otherParams = "" {
				Set set = 1
				Set set(1) = o
				//w o.resourceType,"?",o.name,"[",o.type,"] (",$lts(o.expression),$Select(o.isMultiValue:") => ", 1:") -> "),$lts(o.datatypes)
			} else {
				do o.getParamSet(.set)
			}
			for iparam=1:1:set {
				set o=set(iparam)
				w:(iparam=1) o.resourceType,"?",o.name,$Select(set>1:" is multi-sourced ...",1:"")
				w:(set>1) !,"      "
				
				w "[",o.type,"] (",o.fhirPath,$Select(o.isMultiValue:") => ", 1:") -> "),$lts(o.datatypes)
				if o.type="reference" {
					w " to (",$lts(..sortList(o.target)),")"
				}
				for dtix=1:1:$LL(o.datatypes) {
					Set dataTypeMap($LG(o.datatypes,dtix)) = 1	
				}
				set typeMap(o.type) = 1
			}
			w !

		}
	}
	w "All Indexable Value Types", !
	set typename=""
	for { 
		set typename = $Order(dataTypeMap(typename))
		quit:typename=""
		w "  ",typename,!
	}
	w "All Search Parameter Types", !
	set typename=""
	for { 
		set typename = $Order(typeMap(typename))
		quit:typename=""
		w "  ",typename,!
	}
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

Method initSearch() [ Internal ]
{
	// Build a map of valid query parameters that are NOT search parameters
	for paramName="_sort","_count","_since","_at","_include","_revinclude","_summary","_elements","_contained","_containedType","_format","debug","_pretty","page","queryId","max","access_token" {
		Set ..nonSearchParams(paramName) = 1
	}
}

}

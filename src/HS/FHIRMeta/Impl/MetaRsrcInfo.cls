Class HS.FHIRMeta.Impl.MetaRsrcInfo Extends Base
{

/// Returns a <code>RsrcIterator</code> object that will iterate through all
/// resources of the specified type.
Method GetRsrcIterator(resourceType As %String) As HS.FHIRMeta.RsrcIterator
{
	return ##class(HS.FHIRMeta.RsrcIterator).%New(..PackageList, resourceType)
}

Method GetMetadataResource(url As %String) As %DynamicObject [ CodeMode = expression ]
{
..GetMetadataResourceImpl(url, ..PackageList)
}

ClassMethod GetMetadataResourceImpl(url As %String, packageList As %List) As %DynamicObject
{
	if $length(url,"|") > 1 {
		// The version is explicitly provided, use it.
		Set version = $Piece(url, "|", *)
		Set url = $Piece(url, "|", 1, *-1)
		Set rsrc = ##class(HS.FHIRMeta.Storage.Rsrc).UrlIndexOpen(url, version)
		if $IsObject(rsrc) {
			return ##class(%DynamicObject).%FromJSON(rsrc.json)
		}
	} else {
		// Return the version associated with the specified package list.
		return ##class(HS.FHIRMeta.Storage.Rsrc).GetRsrcByUrl(packageList, url)
	}
	return ""
}

Method ExpandValueSet(urlOrValueSet As %String, Output codes)
{
	do ..ExpandValueSetImpl(urlOrValueSet, ..PackageList, .context)
	kill codes
	merge codes = context("v")
}

Method ExpandValueSetAsList(urlOrValueSet As %String) As %List
{
	Set codesystemList = ""
	do ..ExpandValueSetImpl(urlOrValueSet, ..PackageList, .context)
	Set codesystem = ""
	for {
		Set codeList = ""
		Set codesystem = $O(context("v", codesystem))
		Quit:codesystem=""

		kill order
		Set code = ""
		for {
			Set code = $O(context("v", codesystem, code), 1, desc)
			Quit:code=""
			
			Set order(context("v", codesystem, code, "ord")) = $LB(code, desc)
		}
		set ord=""
		for {
			Set ord = $Order(order(ord), 1, value)
			Quit:ord=""
			
			set $List(codeList,*+1) = value
		}
		set $List(codesystemList,*+1) = $LB(codesystem, codeList)
	}
	return codesystemList
}

ClassMethod ExpandValueSetImpl(urlOrValueSet As %String, packageList As %List, ByRef context) [ Internal ]
{
	Set jvs = urlOrValueSet
	if '$IsObject(jvs) {
		Set jvs = ..GetMetadataResourceImpl(urlOrValueSet, packageList)
		if jvs = "" {
			w "Could not load: ",urlOrValueSet,!
			Quit	
		}
	}	
	if jvs.compose '= "" {
		set elementType = "I"
		for elementType = "I","X" {
			set components = $S(elementType="I":jvs.compose.include, 1:jvs.compose.exclude)
			if components '= "" {
				Set iter = components.%GetIterator()
				while iter.%GetNext(.xx, .component) {
					Set system = component.system
					if system '= "" {
						// Can have concepts or filters or none, but not both
						if component.concept '= "" {
							Set citer = component.concept.%GetIterator()
							while citer.%GetNext(.xx, .concept) {
								// Add or remove this value in our context
								if elementType = "I" {
									Set context("v", concept.code) = concept.display
									Set context("v", concept.code, "ord") = $I(context("ord"))
								} else {
									kill context("v", concept.code)
								}
							}
						} else {
							// we have to expand the CodeSystem resource
							if component.filter '= "" {
								Set fiter = component.filter.%GetIterator()
								while fiter.%GetNext(.xx, .filter) {
									set context("f", $I(context("f"))) = filter
									//w "  Filter: ", filter.property, "|",filter.op,"|", filter.value,!
								}
								
							} 
							// System-only, include all values from the CodeSystem
							Set jcs = ..GetMetadataResourceImpl(system, packageList)
							if (jcs '= "") && (jcs.concept '= "") {
								Do ..expandCodeSystem(jcs.url, jcs.concept, elementType, .context)	
							}
							kill context("f")
						}
					}
					if component.valueSet '= "" {
						Set uiter = component.valueSet.%GetIterator()
						while uiter.%GetNext(.xx, .vsUrl) {
							Set vscontext("ord") = context("ord")
							Do ..ExpandValueSetImpl(vsUrl, packageList, .vscontext)
							Set context("ord") = vscontext("ord")
							if xx=0 {
								// Save the values from the first value set in the list
								merge tcontext = vscontext
							} else {
								// Remove any values from the output list that is not in all lists
								set key = ""
								for {
									Set key = $O(tcontext(key))
									Quit:key=""
									if '$D(vscontext(key)) {
										kill tcontext(key)
									}
								}
							}
							kill vscontext
						}
						merge context = tcontext
						kill tcontext
					}
				}
			}
		}
	}
}

ClassMethod expandCodeSystem(csUrl As %String, conceptList As %DynamicObject, elementType As %String, ByRef context) [ Private ]
{
	
	Set iter = conceptList.%GetIterator()
	while iter.%GetNext(.subsc, .concept) {
		Set context("isa",concept.code) = ""
		//w "Expanding ...",!
		//zw context("isa")
		set fix = ""
		Set doAdd = 1
		for {
			// Apply Filters
			Set fix = $O(context("f", fix), 1, filter)
			Quit:fix=""
			
			set op = filter.op
			if op = "is-a" {
				if '$D(context("isa", filter.value)) {
					Set doAdd = 0
					Quit
				}
			} elseif op = "descendent-of" {
				if '$D(context("isa", filter.value)) || (concept.code = filter.value) {
					Set doAdd = 0
					Quit
				}
			} elseif op = "is-not-a" {
				if $D(context("isa", filter.value)) {
					Set doAdd = 0
					Quit
				}
			} elseif op = "regex" {
				Set matcher = ##class(%Regex.Matcher).%New(filter.value)
				// Check the value against a regular expression	
				if 'matcher.Match(tData) {
					Set doAdd = 0
					Quit
				}
			}
		}
		if doAdd {
			// No filter, accept all values
			if elementType = "I" {
				Set context("v", csUrl, concept.code) = concept.display
				Set context("v", csUrl, concept.code, "ord") = $I(context("ord"))
			} else {
				kill context("v", csUrl, concept.code)
			}
		}
		// recurse if necessary
		if concept.concept '= "" {
			// Update the context with the parent concept's code in scope
			Do ..expandCodeSystem(csUrl, concept.concept, elementType, .context)
		}
		kill context("isa",concept.code)
	}
}

}

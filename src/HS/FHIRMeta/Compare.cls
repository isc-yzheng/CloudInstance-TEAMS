Include HS.FHIRMeta

Class HS.FHIRMeta.Compare [ Abstract ]
{

ClassMethod compare(type As %String = "")
{
	Set us = $S(type="":"^ti", 1:$Name(^ti(type)))
	Set them = $S(type="":"^sti", 1:$Name(^sti(type)))
	// Compare the globals ignoring list order differences
	Do ..compareGlobals(us, them, 1)
}

ClassMethod compareTo(meta1 As HS.FHIRMeta.API, meta2 As HS.FHIRMeta.API)
{
	// First Compare Compartment Data
	w "Comparing Compartment Metadata",!
	kill @mgn
	kill @sgn
	merge @mgn = ..compartments
	merge @sgn = schema.compartmentDefs
	
	Do ..compareGlobals($$$FSMetaCompartmentGlobal(meta1), $$$FSMetaCompartmentGlobal(meta2))

	w "Compared Compartment Metadata",!
	
	// Next Compare SearchParameters
	w "Comparing SearchParameters Metadata",!
	Do ..compareSearchParams(schema, mgn, sgn)
	Do ..compareSearchParams($$$FSMetaSearchParamGlobal(meta1), $$$FSMetaSearchParamGlobal(meta2))

	w "Compared SearchParameters Metadata",!	
	
	
	kill nameMap  // typeInfoName -> schemaName
	
	kill @mgn
	kill @sgn
	set mgn = $$$FSMetaTypeInfoGlobal(meta1)
	set sgn = $$$FSMetaTypeInfoGlobal(meta2)
	
	Set rsrcType = ""
	for {
		Set rsrcType = $Order( @mgn@(rsrcType))
		Quit:(rsrcType = "")
		Set baseclass = $Get(..typeInfo(rsrcType, "*dt"))
		Continue:(baseclass = "")
		Continue:((baseclass '= "DomainResource") && (baseclass '= "Resource") && (baseclass '= "Element"))
		// This is a resource, Loop through 
		Do ..adjustTypeName(rsrcType, mgn, sgn)
	}
	// Clean up sgn a bit
	Set typeName=""
	for {
		Set typeName = $Order(@sgn@(typeName))
		Quit:(typeName="")
		
		Set propName = ""
		for {
			Set propName = $Order(@sgn@(typeName, propName))
			Quit:(propName="")
			// A non-object property
			// Kill the schema's regex info
			kill @sgn@(typeName, propName, "rx")
			if $Get(@sgn@(typeName, propName, "dt")) = "string-primitive" {
				set @sgn@(typeName, propName, "dt") = "string"
			}
			// Rename ResourceContainer to Resource
			if $Get(@sgn@(typeName, propName, "dt")) = "ResourceContainer" {
				set @sgn@(typeName, propName, "dt") = "Resource"
			}

		}
	}
	
	Do ..compareGlobals(mgn, sgn)
}

ClassMethod adjustTypeName(typeName As %String, mgn As %String, sgn As %String)
{
	Set propName = ""
	//w "Type ",typeName,!
	for {
		Set propName = $Order(@mgn@(typeName, propName))
		Quit:(propName="")
		Continue:($E(propName)="*")
		
		// Kill the class-level scalar
		zkill @mgn@(typeName)
		
		if @mgn@(typeName, propName, "jt")  ="o" {
				//w "Prop ",typeName,".",propName,!

			// This is an object, lets correlate the classname
			Set mClassname = @mgn@(typeName, propName, "dt")
			Set sClassname = $Get(@sgn@(typeName, propName, "dt"))
				//w "types ",mClassname," | ",sClassname,!
			if (sClassname '= mClassname) && (sClassname '= "") {
				// We have an ansociated schema class with a different name
				
				// Change to datatype value for the schema property
				Set @sgn@(typeName, propName, "dt") = mClassname
					//w "Set ",typeName,".",propName, " to ",mClassname,!
				if $D(@sgn@(mClassname))=0 {
						//w "Move ",sClassname, " to ",mClassname,!
					// We havent renamed yet in the schema, do it now
					merge @sgn@(mClassname) = @sgn@(sClassname)
					kill @sgn@(sClassname)
					do ..adjustTypeName(mClassname, mgn, sgn)
				}
			}
		}	
	}
}

ClassMethod compareGlobals(g1 As %String, g2 As %String, ignoreListOrder As %Boolean = 0)
{
	
	Set name = ""
	for {
		Set name = $Order( @g2@(name) )
		Quit:(name = "")
		set names(name) = 2
	}
	
	Set name = ""
	for {
		Set name = $Order( @g1@(name) )
		Quit:(name = "")
		if $I(names(name)) {}
	}
	
	Set name = ""
	for {
		Set name = $Order( names(name), 1, flag)
		Quit:(name = "")
		
		Set node1 = $Name(@g1@(name))
		Set node2 = $Name(@g2@(name))
		
		set flag = names(name)
		if flag '= 3 {
			w "[" _ $case(flag, 1:g1, 2:g2) _ " only has node ",$case(flag, 1:node1, 2:node2),"]",!
			Continue
		}
		// Both have a node of this name, compare the nodes
		Set scalar1 = $D(@node1)#2
		Set scalar2 = $D(@node2)#2
		if scalar1 = scalar2 {
			if scalar1 '= 0 {
				// Compare values
				Set v1 = @node1
				Set v2 = @node2
				if v1 '= v2 {
					// $LV(v1),"|",$LV(v2),"|",$Select($LV(v1)=1:$LTS(v1), 1:v1), "'=",$Select($LV(v2)=1:$LTS(v2), 1:v2),!
					if $ListValid(v1) && $ListValid(v2) {
						do ..compareLists(v1, v2, ignoreListOrder, .errors)
						if errors {
							w "[" , node1 , " differs from ",node2,"]",!
							for ie=1:1:errors {
								w "  ",errors(ie),!
							}
						}

					} else {
						w "[" , node1 , " differs from ",node2,"]",!
						zw v1
						zw v2
					}
				}
			}
		} else {
			Set goodNode = $select(scalar1'= 0:node1, 1:node2)
			w "[" _ goodNode _ " only has scalar] ",name, "=",@goodNode,!
		}
		
		Set array1 = $D(@node1)>9
		Set array2 = $D(@node2)>9
		if array1 = array2 {
			if array1 {
				// Recurse and compare the children
				Do ..compareGlobals(node1, node2,ignoreListOrder)
			}
		} else {
			Set goodNode = $select(array1'= 0:g1, 1:g2)
			w "[" _ goodNode _ " only has child nodes]",!
		}
		
	}
}

ClassMethod compareLists(a As %String, b As %String, ignoreListOrder As %Boolean, Output errors)
{
#define FMT(%s) $Select($ListValid(%s):"("_$LTS(%s)_")",1:%s)

	Set errors = 0
	Set lenA = $ll(a)
	Set lenB = $ll(b)
	Set orderDiffers = 0
	Set contentsDiffer = 0
	if lenA = lenB {
		for ord=1:1:lenA {
			Set vala = $LG(a, ord)
			Set valb = $LG(b, ord)
			if vala '= valb {
				Set orderDiffers = 1
			}
			if (vala'="") {
				Set has(vala) = $Get(has(vala),0) + 100
			}
			if (valb'="") {
				Set has(valb) = $Get(has(valb),0) + 1
			}
		}
		for ord=1:1:lenA {
			Set vala = $LG(a, ord)
			if vala'="" && ((has(vala) # 101) '= 0) {
				Set contentsDiffer = 1
			}
		}		
	}
	if 'contentsDiffer && orderDiffers {
		if 'ignoreListOrder {
			
			Set errors($I(errors)) = "ignoreListOrder: " _ ignoreListOrder
			Set errors($I(errors)) = "Contents are the same but order is different"
		}	
		return
	}
	for ord=1:1:lenA {
		Quit:ord>lenB
		Set vala = $LG(a, ord)
		Set valb = $LG(b, ord)
		if vala '= valb {
			Set errors($I(errors)) = "[" _ ord _ "] a="_  $$$FMT(vala) _ " _  b=" _ $$$FMT(valb)
		}
	}
	
	if $LL(a) '= $LL(b) {
		Set errors($I(errors)) = "Lengths Differ; a=" _ lenA _ ", b=" _ lenB
		/*
		for ord=1:1:$ListLength(a) {
			Set val = $E($LG(a, ord),1,510)
			Set:(val="") val = "<NULL>"
			set content(val) = 1	
		}	
		for ord=1:1:$ListLength(b) {
			Set val = $E($LG(b, ord),1,510)
			Set:(val="") val = "<NULL>"
			set content(val) = $Get(content(val), 0) + 2	
		}
		Set aOnly = "", bOnly = ""
		set v = ""
		for  {
			Set v = $Order(content(v), 1, flag)
			Quit:v=""
			
			Set:(flag = 1) $List(aOnly, *+1) = v
			Set:(flag = 2) $List(bOnly, *+1) = v
		}
		if aOnly '= "" {
			w "First has only: "_$LTS(aOnly),!
		}
		if bOnly '= "" {
			w "Second has only: "_$LTS(bOnly),!
		}
		*/
	}
}

ClassMethod testCompareGlobals()
{
	kill ^global1
	kill ^global2
	
	Set ^global1(3)="Mass"
	Set ^global1(4,1)="Brattleboro"
	Set ^global1(4,1,1)="Yankee Ingenuity"
	Set ^global1(4,1,2)="Vermonster Systems"
	Set ^global1(5)="Scalar Only"
	
	Merge ^global2 = ^global1
	// Add a scalar nodes
	Set ^global2(2) = "only mine"
	Set ^global2(4) = "my scalar"
	// Kill a scalar 
	kill ^global2(4,1,1)
		
	Set ^global2(5)="Scalar and Child"

	
	
	Do ..compareGlobals("^global1", "^global2")
	kill ^global2

	
	kill ^global1
	kill ^global2
}

}

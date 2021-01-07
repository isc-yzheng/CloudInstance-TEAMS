Include HS.FHIRMeta

Class HS.FHIRMeta.Impl.Base Extends (HS.FHIRMeta.API, HS.FHIRMeta.MetaUtils)
{

/// The MetadataSet Key for this metadata collection
Property FHIRMetadataSetKey As %String [ Calculated, Deprecated ];

/// The MetadataSet Key for this metadata collection
Property PackageList As %List [ Calculated ];

/// The FHIR Version supported by this metadata collection
Property FHIRVersion As %String [ Calculated ];

/// $Name of the root node for TypeInfo Globals
Property TiGbl As %String [ Internal ];

/// $Name of the root node for Compartment Globals
Property CpGbl As %String [ Internal ];

/// $Name of the root node for SearchParam Globals
Property SpGbl As %String [ Internal ];

Property %PackageList As %List [ Private ];

Property GlobalRoot As %String;

Parameter DefaultGlobalRoot As %String = "^HS.FHIRServer.Meta";

Method %OnNew(packageList As %String, globalRoot As %String = "") As %Status [ Private ]
{
	Set ..GlobalRoot = $Select(globalRoot="":..#DefaultGlobalRoot,1:globalRoot)
	Set ..%PackageList = packageList
	Set ..TiGbl = $Name(@..GlobalRoot@(..%PackageList,"ti"))
	Set ..CpGbl = $Name(@..GlobalRoot@(..%PackageList,"cp"))
	Set ..SpGbl = $Name(@..GlobalRoot@(..%PackageList,"sp"))
	if $D(@..GlobalRoot@(packageList)) < 10 {
		Do ..Load()
	}
	Quit $$$OK
}

/// Getter for the FHIRVersion property 
Method FHIRVersionGet() As %String [ CodeMode = expression ]
{
@..GlobalRoot@(..%PackageList,"v")
}

/// Deprecated: renamed to PackageList.  
/// <br>Getter for %List of FHIR Packages in this metadata collection
Method FHIRMetadataSetKeyGet() As %String [ CodeMode = expression ]
{
..%PackageList
}

/// Getter for %List of FHIR Packages in this metadata collection
Method PackageListGet() As %String [ CodeMode = expression ]
{
..%PackageList
}

Method IsFHIRType(fhirType As %String) As %Boolean [ CodeMode = expression ]
{
$$$IsDatatypeDefined($this, fhirType)
}

Method GetSuperType(fhirType As %String) As %String [ CodeMode = expression ]
{
$Get($$$GetSuperclass($this, fhirType))
}

Method GetPropertyNames(fhirType As %String) As %List [ CodeMode = expression ]
{
$Get($$$GetPropertyNameList($this, fhirType))
}

Method HasPropertyName(fhirType As %String, propName As %String) As %String [ CodeMode = expression ]
{
$$$IsPropertyDefined($this, fhirType, propName)
}

Method IsPropertyRequired(fhirType As %String, propName As %String) As %Boolean [ CodeMode = expression ]
{
$$$IsPropertyRequired($this, fhirType, propName)
}

/// API
/// <br> Returns true if the specified property is represented as an Array in JSON.
Method IsPropertyArray(fhirType As %String, propName As %String) As %Boolean [ CodeMode = expression ]
{
$$$IsPropertyArray($this, fhirType, propName)
}

Method GetRequiredProperties(fhirType As %String) As %List
{
	Set list = ""
	set name = ""
	for {
		set name = $$$NextRequiredProperty($this,fhirType,name)
		Quit:name=""
		Set $list(list,*+1) = name
	}
	return list
}

Method GetPropertyFHIRType(fhirType As %String, propName As %String) As %String [ CodeMode = expression ]
{
$$$GetPropertyFHIRType($this, fhirType, propName)
}

Method GetPropertyOrdinal(fhirType As %String, propName As %String) As %Integer [ CodeMode = expression ]
{
$Get($$$GetPropertyIndex($this, fhirType, propName))
}

Method GetPropertyValueSetURL(fhirType As %String, propName As %String) As %String [ CodeMode = expression ]
{
$$$GetPropertyValueSetURL($this, fhirType, propName)
}

Method GetPropertyValueSetStrength(fhirType As %String, propName As %String) As %String [ CodeMode = expression ]
{
$$$GetPropertyValueSetStrength($this, fhirType, propName)
}

Method GetPropertyValueList(fhirType As %String, propName As %String) As %List
{
	Set list = ""
	set value = ""
	for {
		set value = $$$NextValueInPropertyValueSet($this,fhirType,propName,value)
		Quit:value=""
		Set $list(list,*+1) = value
	}
	return list
}

Method GetPropertyJSONType(fhirType As %String, propName As %String) As %String [ CodeMode = expression ]
{
$$$GetPropertyJsonType($this, fhirType, propName)
}

Method GetVariantTypes(fhirType As %String, propName As %String) As %List [ CodeMode = expression ]
{
$Get($$$GetPropertyFHIRTypeList($this, fhirType, propName))
}

ClassMethod IsLoaded(packageList As %String) As %Boolean [ CodeMode = expression ]
{
..getInstance(packageList).IsGlobalLoaded()
}

Method IsGlobalLoaded() As %Boolean [ CodeMode = expression, Private ]
{
$D(@..GlobalRoot@(..%PackageList)) > 9
}

Method Unload() As %Boolean
{
	Set result = ..IsGlobalLoaded()
	kill @..GlobalRoot@(..%PackageList)
	Quit result
}

Method Load()
{
	#dim metaAPI As HS.FHIRMeta.API = $this
	// If there is no MetadataSet object for this key, attempt to bootstrap the built-in sets
	if '##class(HS.FHIRMeta.Load.NpmLoader).IsPackageLoaded($LG(..%PackageList,1) ) {
		do ..bootstrap()	
	}

	#dim loader as HS.FHIRMeta.Load.NpmLoader
	set loader = ##class(HS.FHIRMeta.Load.NpmLoader).Load(..%PackageList)
	#dim builder as HS.FHIRMeta.Load.Builder = ##class(HS.FHIRMeta.Load.Builder).%New(loader)
	Do builder.buildTypeInfo()
	Set valueSets = ##class(HS.FHIRMeta.Load.ValueSets).%New(loader)

	// Take the FHIR version number from the Loader
	Set fhirVersion = loader.coreVersion


	#dim transaction as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()
	Do metaAPI.Unload()
	
	Set @$$$FSMetaVersion(metaAPI) = fhirVersion
	Do ##class(HS.FHIRMeta.Load.TypeInfo).populatePrimitivesGlobal(builder, metaAPI)
	Do ##class(HS.FHIRMeta.Load.TypeInfo).populateTypeInfoGlobal(builder, valueSets, metaAPI)
	Set sp = ##class(HS.FHIRMeta.Load.SearchParams).%New(metaAPI)
	do sp.processSearchParams(loader, builder)
	merge @$$$FSMetaSearchParamGlobal(metaAPI) = sp.searchParams
	Do ##class(HS.FHIRMeta.Load.TypeInfo).populateCompartmentGlobal(loader, metaAPI)
	
	do transaction.Commit()
	
	Quit sp
}

ClassMethod bootstrap(force As %Boolean = 0)
{
	// Create all Metadata Sets in a transaction
	#dim transaction as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()

	Set dir = ##class(%File).NormalizeDirectory($system.Util.InstallDirectory()_"dev/fhir/fhir-metadata/packages")
	Set packageList = ##class(HS.FHIRMeta.Load.NpmLoader).findPackages(dir)
	Do ##class(HS.FHIRMeta.Load.NpmLoader).importPackages(packageList, force)
	
	do transaction.Commit()
}

}

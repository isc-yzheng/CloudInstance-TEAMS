/// This class describes an npm-like package of FHIR Metadata.  THe form of the
/// Package is <a target="_blank" href="https://confluence.hl7.org/display/FHIR/NPM+Package+Specification">described here</a>
Class HS.FHIRMeta.Storage.Package Extends (%Persistent, %JSON.Adaptor)
{

Property id As %String(COLLATION = "EXACT", MAXLEN = 128);

Property name As %String(COLLATION = "EXACT", MAXLEN = 64);

Property version As %String(COLLATION = "EXACT", MAXLEN = 64);

Property type As %String(COLLATION = "EXACT", MAXLEN = 64);

Property coreVersion As %String(%JSONFIELDNAME = "core_version", COLLATION = "EXACT", MAXLEN = 64);

Property dependencies As list Of %String(COLLATION = "EXACT");

Property canonical As %String(COLLATION = "EXACT", MAXLEN = 256);

Property title As %String(COLLATION = "EXACT", MAXLEN = 256);

Property description As %String(COLLATION = "EXACT", MAXLEN = "");

Property loadedFrom As %String(%JSONFIELDNAME = "loaded_from", COLLATION = "EXACT", MAXLEN = "");

Index KeyIndex On id [ IdKey, Unique ];

ClassMethod reset() [ Internal ]
{
	Set transaction = ##class(HS.Util.Scoped.Transaction).Start()
	$$$ThrowOnError(..%DeleteExtent())
	$$$ThrowOnError(##class(HS.FHIRMeta.Storage.Rsrc).%DeleteExtent())
	do transaction.Commit()
}

ClassMethod FindById(id As %String) As Package
{
	if '..%ExistsId(id) {
		return ""
	}
	return ..GetById(id)
}

ClassMethod GetById(id As %String) As Package
{
	Set pkg = ..%OpenId(id,,.sc)
	$$$ThrowOnError(sc)
	return pkg
}

/// Converts the legacy "popular" name for a base FHIR MetadataSetKey to the equivalent package list
ClassMethod MapPopularName(packageId As %String) As %List [ Internal ]
{
	if packageId = "HL7v40" { return $LB("hl7.fhir.r4.core@4.0.1") }
	elseif packageId = "HL7v30" { return $LB("hl7.fhir.r3.core@3.0.2") }
	return packageId
}

ClassMethod GetAllPackages() As %ListOfObjects
{
	
	Set SQL = "SELECT ID FROM HS_FHIRMeta_Storage.Package order by coreVersion desc, type asc, id asc"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	return ..buildResultList( statement.%Execute() )
}

ClassMethod GetCorePackages() As %ListOfObjects
{
	
	Set SQL = "SELECT ID FROM HS_FHIRMeta_Storage.Package where type = 'fhir.core'"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	return ..buildResultList( statement.%Execute() )
}

ClassMethod GetCustomPackages(packageOrId) As %ListOfObjects
{
	if $IsObject(packageOrId) {
		Set corePackage = packageOrId
	} else {
		Set corePackage = ..%OpenId(packageOrId)
		if '$Isobject(corePackage) {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"No Package with id = "_ packageOrId))	
		}
	}
	if corePackage.type '= "fhir.core" {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"Input package must be of type 'fhir.core'"))	
	}
	Set SQL = "SELECT ID FROM HS_FHIRMeta_Storage.Package where coreVersion = ? and ((type <>'fhir.core') or (type is null))"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	return ..buildResultList( statement.%Execute(corePackage.coreVersion) )
}

ClassMethod GetCorePackagesJSON() As %DynamicArray [ CodeMode = expression ]
{
..buildJsonArray( ..GetCorePackages() )
}

ClassMethod GetAllPackagesJSON() As %DynamicArray [ CodeMode = expression ]
{
..buildJsonArray( ..GetAllPackages() )
}

ClassMethod GetCustomPackagesJSON(packageOrId) As %DynamicArray [ CodeMode = expression ]
{
..buildJsonArray( ..GetCustomPackages(packageOrId) )
}

ClassMethod ResolvePackageList(idList As %List) As %List
{
	set resolvedList = ""
	set packageList = ..MapPopularName(idList)
	set coreVersion = ""
	
	set lix=0
	while $ListNext(packageList, lix, packageId) {
		do ..buildTree(packageId, .used)
	}
	Set coreVersion = used("o", 1).coreVersion
	for ord=1:1:used {
		Set pkg = used("o",ord)
		if coreVersion '= pkg.coreVersion {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "All packages must use the same core version"))	
		}
		Set resolvedList = resolvedList _ $LB( pkg.id )
	}
	return resolvedList
}

ClassMethod buildTree(packageId As %String, ByRef used) [ Private ]
{
	if $D(used("p",packageId)) Quit
	#dim package As HS.FHIRMeta.Storage.Package
	set package = ##class(HS.FHIRMeta.Storage.Package).GetById(packageId)
	for ord=1:1:package.dependencies.Count() {
		Do ..buildTree(package.dependencies.GetAt(ord), .used)	
	}
	Set used("p", packageId) = package
	Set used("o", $I(used)) = package
}

ClassMethod Delete(packageId As %String) [ Internal ]
{
	// Delete transactionally
	Set transaction = ##class(HS.Util.Scoped.Transaction).Start()
	
	// Delete the Rsrc Objects	
	Set statement = ##class(%SQL.Statement).%New()
	Set SQL = "Delete HS_FHIRMeta_Storage.Rsrc where packageId = ?"
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute(packageId)
	if (resultSet.%SQLCODE < 0) {
		$$$ThrowStatus( $$$ERROR($$$SQLError, resultSet.%SQLCODE, resultSet.%Message) )
	}
	
	// Delete the Package object
	Set statement = ##class(%SQL.Statement).%New()
	Set SQL = "Delete HS_FHIRMeta_Storage.Package where id = ?"
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute(packageId)
	if (resultSet.%SQLCODE < 0) {
		$$$ThrowStatus( $$$ERROR($$$SQLError, resultSet.%SQLCODE, resultSet.%Message) )
	}
	do transaction.Commit()
}

Method AsJSON() As %DynamicObject [ Private ]
{
	$$$ThrowOnError(..%JSONExportToString(.json) )
	return ##class(%DynamicAbstractObject).%FromJSON(json)
}

Method AsJSONString() As %String [ Private ]
{
	$$$ThrowOnError( ..%JSONExportToString(.json) )
	return json
}

ClassMethod buildJsonArray(objList As %ListOfObjects) As %DynamicArray [ Private ]
{
	Set result = []
	for ord=1:1:objList.Count() {
		do result.%Push(objList.GetAt(ord).AsJSON())	
	}
	return result
}

ClassMethod buildResultList(resultSet As %SQL.StatementResult) [ Private ]
{
	#dim result as %ListOfObjects = ##class(%ListOfObjects).%New()
	While resultSet.%Next() {
		Set id = resultSet.%GetData(1)
		Do result.Insert(..%OpenId(id))
	}
	return result
}

ClassMethod dump()
{
	Set SQL = "SELECT ID FROM HS_FHIRMeta_Storage.Package"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute()
	While resultSet.%Next() {
		Set id = resultSet.%GetData(1)
		Set package = ..%OpenId(id)
		zw package
	}
}

Storage Default
{
<Data name="PackageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>version</Value>
</Value>
<Value name="4">
<Value>type</Value>
</Value>
<Value name="5">
<Value>coreVersion</Value>
</Value>
<Value name="6">
<Value>dependencies</Value>
</Value>
<Value name="7">
<Value>canonical</Value>
</Value>
<Value name="8">
<Value>title</Value>
</Value>
<Value name="9">
<Value>description</Value>
</Value>
<Value name="10">
<Value>loadedFrom</Value>
</Value>
</Data>
<DataLocation>^HS.FHIRMeta.Storage.PackageD</DataLocation>
<DefaultData>PackageDefaultData</DefaultData>
<IdLocation>^HS.FHIRMeta.Storage.PackageD</IdLocation>
<IndexLocation>^HS.FHIRMeta.Storage.PackageI</IndexLocation>
<StreamLocation>^HS.FHIRMeta.Storage.PackageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

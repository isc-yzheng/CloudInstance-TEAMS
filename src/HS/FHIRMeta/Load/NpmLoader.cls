/// The NpmLoader is used to import and access FHIR metadata resources.  The <code>importPackages</code> method is used to register one or more 'npm-like' packages containing FHIR Metadata.
/// <p>Each package has a unique Key that is used to identify its collection of Metadata resources.  The Key is formed from a unique 'name' property and a semantic 'version' property
/// concatenated separated by an '@' character.  For example, The current FHIR R4 release has the name 'hl7.fhir.r4.core' and version '4.0.1', yielding an ID of 'hl7.fhir.r4.core@4.0.1'
/// <p>Each package is contained in a single directory with the following structure:
/// <ul>
/// <li> A JSON file named 'package.json' which contains identifying information.  The required properties are enumerated below.
/// <li> A set of JSON files each containing a single FHIR resource.
/// </ul>
/// Note that a properly formed "Implementation Guide" or core FHIR release are packaged in this form.  For hand-build customization, the two JSON files must be provided
/// with the required fields present at a minimum.
/// <p><b>package.json properties</b>
/// <br> The following string fields are required for proper metadata ingestion:
/// <ul>
/// <li> <b>name</b> A unique identifier of the package exclusive of version.  It is possible to have multiple versions of a single package
/// each in its own directory with its own 'package.json'.  (Example: for FHIR-R4, the value is 'hl7.fhir.r4.core')
/// <li> <b>version</b> A semantic version number identifying the version for this package. (Example: for FHIR-R4, the value is '4.0.1').
/// <li> <b>type</b> A code describing the type of package.  Two values are defined;  'fhir.core' for base FHIR metadata packages supplied by HL7, and 'fhir.ig' for 
/// custom or profile packages.
/// <li> <b>dependencies</b> (Required for non-core packages) An object whose property name(s) identify the name of a package that this package requires.  The property value(s) identify the version of the 
/// required package. For example, to depend on the core FHIR R4 package the property would be:
/// <code><pre>
///   "dependencies": {
///      "hl7.fhir.r4.core": "4.0.1"
///    },
/// </pre></code>
/// Every package must either BE a core package, or ultimately resolve to having a single core package as a dependency.
/// <li> <b>canonical</b> A unique URL associated with the package. (This value is required by the HL7 package specification)
/// <li> <b>title</b> (Optional) A brief human-readable description of the package
/// <li> <b>description</b> (Optional) A full description of the package
/// </ul>
/// <ul>
/// <li> <b>filename</b> The simple name of a file, in the package directory (no path information)
/// <li> <b>version</b> The version number for the resource in the file.
/// <li> <b>resourceType</b> The resource type.  
/// <li> <b>canonical</b> A unique URL associated with the package. (This value is required by the HL7 package specification)
/// <li> <b>title</b> (Optional) A brief human-readable description of the package
/// <li> <b>description</b> (Optional) A full description of the package
/// </ul>
/// <p><b>Accessing FHIR Metadata Resources</b>
/// Use the <code>Load</code> method to create a NpmLoader instance that provides access to the metadata contained in a related set of packages.  The NpmLoader
/// can then be used to access a resource using the <code>getRsrcByUrl</code> or <code>getRsrcById</code> method.  To iterate through a collection of resources,
/// you can create a <code>RsrcIterator</code> object.
/// 
Class HS.FHIRMeta.Load.NpmLoader Extends %RegisteredObject
{

Property packageList As list Of HS.FHIRMeta.Storage.Package;

Property packageIdList As %List;

Property coreVersion As %String;

ClassMethod Test(mdsKey As %String = "HL7v40", verbose = 1)
{
	Do ##class(HS.FHIRMeta.Storage.Package).reset()
	Do ..importPackages("C:\Users\aepstein\dev\fhir-npm\node_modules\hl7.fhir.r4.core\package.json")
	#dim nl as NpmLoader = ..Load(mdsKey)
	#dim ll as HS.FHIRMeta.Load.NpmLoader = ##class(HS.FHIRMeta.Load.NpmLoader).Load(mdsKey)
	
	set rt = ""
	for {
		Set rt = $Order(ll.rsrc(rt))
		Quit:rt=""
		
		Set iter = nl.getRsrcIterator(rt)
		Set urlCount = 0
		set url = ""
		kill matches
		Set matches("new") = 0
		Set matches("same") = 0

		for {
			Set url = $Order(ll.rsrc(rt,url))
			Quit:url=""
			Set urlCount = urlCount + 1
			Set matches("old",url) = ""
			Do $I(matches("old"))
		}
		for ix=1:1:iter.urlArray {
			set url = iter.urlArray(ix)
			if $D(matches("old",url)) {
				do $I(matches("same"))
				do $I(matches("old"),-1)
				kill matches("old",url)
			} else {
				Set matches("new",url) = ""
				Do $I(matches("new"))
			}
		}
		w rt,": same=",matches("same"), ", loader only=",matches("old"),", npmloader only=", matches("new"),!
		zw matches("old")
		if verbose {
			zw matches("new")
		}
		
		
	}
}

ClassMethod Load(mdsKeyList As %List) As NpmLoader
{
	return ..%New(mdsKeyList)
}

Method %OnNew(mdsKeyList As %List) As %Status
{
	set packageList = ##class(HS.FHIRMeta.Storage.Package).MapPopularName(mdsKeyList)
	set ..packageIdList = ##class(HS.FHIRMeta.Storage.Package).ResolvePackageList(packageList)
	set corePkg = ##class(HS.FHIRMeta.Storage.Package).GetById($LG(..packageIdList))
	set ..coreVersion = ..coreVersion(corePkg)
	return $$$OK
}

/// Returns a <code>RsrcIterator</code> object that will iterate through all
/// resources of the specified type.
Method getRsrcIterator(resourceType As %String) As HS.FHIRMeta.RsrcIterator
{
	return ##class(HS.FHIRMeta.RsrcIterator).%New(..packageIdList, resourceType)
}

/// Returns a resource given the specified resourceType and id.
Method getRsrcById(resourceType As %String, id As %String) As %DynamicObject
{
	return ##class(HS.FHIRMeta.Storage.Rsrc).GetRsrcById(..packageIdList, resourceType, id)
}

/// Returns a resource given the specified 'url' property value.  Note that the resourceType
/// need not be specified because it is implicit in the URL.
Method getRsrcByUrl(url As %String) As %DynamicObject
{
	return ##class(HS.FHIRMeta.Storage.Rsrc).GetRsrcByUrl(..packageIdList, url)
}

ClassMethod IsPackageLoaded(packageId As %String) As %Boolean
{
	return ##class(HS.FHIRMeta.Storage.Package).KeyIndexExists(packageId)
}

/// Imports one or more 'npm-like' packages of FHIR Metadata into the system, creating a 
/// HS.FHIRMeta.Storage.Package object to describe each imported package and a HS.FHIRMeta.Storage.Rsrc
/// object for each metadata Resource.  A package cannot be successfully imported unless all dependent packages
/// are either already imported, or included in 'packagePathList'
/// <br>@Input packagePathList  A %List of directory paths each containing a FHIR Metadata package.
/// <br>@Input force  (default=false) If true, remove any previous import of the package before importing.  If false,
/// previously imported packages will be skipped.
/// <br>@Returns A %List of all package Id's that were updated
ClassMethod importPackages(packageDirList As %List, force As %Boolean = 0) As %List
{
	#dim pkg as HS.FHIRMeta.Storage.Package
	
	Set updatedPackages = ""
	Set pathList = packageDirList
	if '$listValid(pathList) {
		Set pathList = $LB(packageDirList)	
	}
	Set transaction = ##class(HS.Util.Scoped.Transaction).Start()
	set PACKAGES = 0
	set lix=0
	while $ListNext(pathList, lix, packageDir) {
		set pkg = ..addPackage(packageDir, force, .wasCreated)
		Set ID2LOAD(pkg.id) = wasCreated
		set PACKAGES($I(PACKAGES)) = pkg
	}
	// Now update the package objects with the core FHIR version
	for ord=1:1:PACKAGES {
		set pkg = PACKAGES(ord)
		if pkg.coreVersion = "" {
			set pkg.coreVersion = ..coreVersion(pkg)
			$$$ThrowOnError(pkg.%Save())
		}	
	}

	// All package dependencies are present, now we can load the files
	for ord=1:1:PACKAGES {
		Set pkg = PACKAGES(ord)
		if force || ID2LOAD(pkg.id) {
			w "Load Resources: ",pkg.id,!
			Do ..addPackageResources(pkg, force)
			Set $List(updatedPackages, *+1) = pkg.id
		}
	}
	do transaction.Commit()
	return updatedPackages
}

ClassMethod coreVersion(package As HS.FHIRMeta.Storage.Package) As %String
{
	if (package.type = "fhir.core") {
		return package.coreVersion
	}
	#dim pkg As HS.FHIRMeta.Storage.Package = package
	#dim corePkg As HS.FHIRMeta.Storage.Package = ""
	Set coreVersion = ""
	
	for ord=1:1:package.dependencies.Count() {
		set pkg = ##class(HS.FHIRMeta.Storage.Package).GetById(package.dependencies.GetAt(ord))
		Set cv = ..coreVersion(pkg)
		if coreVersion = "" {
			Set coreVersion = cv
			Set corePkg = pkg
			Continue
		}
		// There were multiple dependencies.  Ensure they all have the same core version
		if coreVersion '= cv {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Dependencies of package '" _ package.id _ "' have different core versions. '" _ corePkg.id _ "' is " _ corePkg.coreVersion _ " and " _ pkg.id _ "' is " _ pkg.coreVersion))
		}	
	}
	if coreVersion = "" {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Package '" _ package.id _ " has no dependencies that identify a core package"))
	}
	return coreVersion
}

ClassMethod addPackage(packageDir As %String, force As %Boolean, Output wasCreated) As HS.FHIRMeta.Storage.Package [ Private ]
{
	#dim pkg as HS.FHIRMeta.Storage.Package
	
	Set packagePath = ##class(%File).NormalizeFilename("package.json", packageDir)
	if '##class(%File).Exists(packagePath) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "The specified directory does not contain 'package.json': " _ packageDir))
	}
	
	Set jpackage = ##class(%DynamicObject).%FromJSON(packagePath)
	set packageId = jpackage.name _ "@" _ jpackage.version
	Set pkg = ##class(HS.FHIRMeta.Storage.Package).FindById(packageId)
	if $IsObject(pkg) {
		Set wasCreated = 0
	} else {
		Set pkg = ##class(HS.FHIRMeta.Storage.Package).%New()
		set pkg.id = packageId
		Set wasCreated = 1
	}
	
	if wasCreated || force {
		set pkg.name = jpackage.name
		set pkg.version = jpackage.version
		set pkg.type = jpackage.type
		if pkg.type = "fhir.core" {
			Set pkg.coreVersion = jpackage.version
		}
		set pkg.canonical = jpackage.canonical
		set pkg.title = jpackage.title
		set pkg.description = jpackage.description
		Set pkg.loadedFrom = packageDir
		if jpackage.dependencies {
			Set iter = jpackage.dependencies.%GetIterator()
			while iter.%GetNext(.key, .version) {
				do pkg.dependencies.Insert(key _ "@" _ version)	
			}	
		}
		w "Saving ",packageId,!
		$$$ThrowOnError(pkg.%Save())
	}
	return pkg
}

ClassMethod addPackageResources(pkg As HS.FHIRMeta.Storage.Package, force As %Boolean) As %Boolean [ Private ]
{
	Set changed = 0
	Set packageDir = pkg.loadedFrom

	Set path = ""
	Set typesToImport("StructureDefinition") = ""
	Set typesToImport("CompartmentDefinition") = ""
	Set typesToImport("SearchParameter") = ""
	Set typesToImport("CodeSystem") = ""
	Set typesToImport("ValueSet") = ""
	Set typesToImport("OperationDefinition") = ""
	for {
		if path ="" {
			set path = $zsearch(##class(%File).NormalizeFilename("*.json", packageDir))
		} else {
			set path = $zsearch("")
		}
		Quit:(path="")
		
		// Skip directories
		Quit:##class(%File).DirectoryExists(path)

		// Calculate the filename (for error reporting)
		set filename = ##class(%File).GetFilename(path)
		
		try {
			Set json = ##class(%DynamicObject).%FromJSON(path)
		} catch ex {
			w "Skipping Non JSON file ",filename,!
			Continue
		}
		if json.resourceType="" {
			// w "Skipping Non Resource: ",filename,!
			Continue
		}
		if '$D(typesToImport(json.resourceType)) {
			Continue
		}
		
		if json.url="" {
			//w "Skipping Resource with no 'url' property ",filename,!
			Continue
		}
		if json.id="" {
			//w "Skipping Resource with no 'id' property ",filename,!
			Continue
		}
		if $Find(json.id,"example") {
			//w "Skipping Example Resource: ",filename,!
			Continue
		}
		
		#dim rsrc as HS.FHIRMeta.Storage.Rsrc = ""
		
		Set rsrcVersion = $Select(json.version '= "":json.version, 1:pkg.version)
		
		Set doPopulate = force
		if ##class(HS.FHIRMeta.Storage.Rsrc).UrlIndexExists(json.url, rsrcVersion, .rid) {
			// We already have such a resource
			set rsrc = ##class(HS.FHIRMeta.Storage.Rsrc).%OpenId(rid)
			if rsrc.packageId '= pkg.id {
				// Add another package that references this resource
				w "Resource Used in Multiple Packages: ", json.url,"|", rsrcVersion, "(",rsrc.packageId,",",pkg.id,")",!
				Continue
			}
		} else {
			// Adding a new resource
			Set rsrc  = ##class(HS.FHIRMeta.Storage.Rsrc).%New()
			Set rsrc.packageId = pkg.id
			set doPopulate = 1
		}
		
		if doPopulate {
			// Repopulate all fields (except packageIdList)
			set rsrc.coreVersion = pkg.coreVersion
			set rsrc.id = json.id
			set rsrc.url = json.url
			set rsrc.resourceType = json.resourceType
			set rsrc.version = rsrcVersion
			set rsrc.kind = json.kind
			set rsrc.type = json.type
			set rsrc.json = json.%ToJSON()
		}
		
		$$$ThrowOnError(rsrc.%Save())
	}
	
	return changed
}

/// @API
/// This method uninstalls a custom metadata set in a FHIR-enabled namespace
/// It performs the following operations:
/// <ol>
/// <li> Throws if the metadata set is still in use by an endpoint
/// <li> Removes the configuration
/// <li> Deletes the metadata globals
/// </ol>
/// @Input key  Unique key for the metadata set.
ClassMethod UninstallPackage(packageId As %String)
{
	#dim package as HS.FHIRMeta.Storage.Package
	Set package = ##class(HS.FHIRMeta.Storage.Package).FindById(packageId)
	if package="" {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "The package with id '" _ packageId _ " is not installed"))
	}
	do ##class(HS.FHIRMeta.Storage.Package).Delete(packageId)
}

/// Utility method that returns a list of pathnames to FHIR package
/// directories within a specified directory. 
/// <br>@Input inDir A path to a directory that is either a FHIR package directory
/// or contains one or more FHIR package directories.
/// <br>@Returns A %List of normalized pathnames to the package directories.
ClassMethod findPackages(inDir As %String) As %List
{
	Set nDir = ##class(%File).NormalizeDirectory(inDir)
	Set list = ""
	Do ..findInOneDir(nDir, .list)
	return list
}

ClassMethod findInOneDir(nDir As %String, ByRef list) [ Private ]
{
	Set tRS = ##Class(%ResultSet).%New()
	Set tRS.ClassName = "%Library.File"
	Set tRS.QueryName = "FileSet"
	$$$ThrowOnError(tRS.Execute(nDir, "package.json",,1))
	while tRS.Next() {
		set type = tRS.%Get("Type")
		set path = tRS.%Get("Name")
		if type = "F" {
			Set $List(list, *+1) = ##class(%File).GetDirectory(##class(%File).NormalizeFilename(path, nDir))
		} else {
			do ..findInOneDir(path, .list)
		}
			
	}
}

}

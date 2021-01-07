Class HS.FHIR.DTL.Util.API.ExecDefinition [ Abstract ]
{

/// API Method
/// This method sets the name of the custom DTL package to be used in this namespace. This is the
/// root package under which you will place any customized DTL classes for transforming FHIR STU3
/// to SDA3, or SDA3 to FHIR STU3. You can clear this package name by providing an empty string as
/// the packageName.
/// <p>
/// When packageName is empty, transformation code ignores all custom DTLs and always uses the standard DTLs.
/// <p>
/// Otherwise, at runtime, before executing any DTL class, the transformation code looks to see if a
/// class by that name exists in the custom DTL package. If so, it executes the custom DTL class. If
/// not, the transformation code executes the corresponding standard DTL class. 
/// <p>
/// Essentially, the custom package name is intended to replace the standard package name when
/// looking for a customized version of a given DTL class. For example, if the standard package name
/// is "HS.FHIR.DTL", and the custom package name is "HS.Local.FHIR.DTL", then at run-time if the
/// specified standard class is <b>HS.FHIR.DTL</b>.SDA3.vSTU3.Patient.Patient, the framework will
/// first look for <b>HS.Local.FHIR.DTL</b>.SDA3.vSTU3.Patient.Patient.
/// <p>
/// The packageName value may not be the same as the standard DTL package name for the product, may
/// not be a sub-package of the standard package, and may not occupy a reserved product package -
/// the exception being HS.Local which is within HS.
ClassMethod SetCustomDTLPackage(packageName As %String = "") As %Status
{
	set tSC = $$$OK
	try {
		set project = $get(^HS.XF.Config("Project"), "")
		if project = "" {
			set tSC = $$$ERROR($$$GeneralError, "Project not configured")
			quit
		}
		set packageDefault = ..GetStandardDTLPackage()
		if packageDefault = "" {
			set tSC = $$$ERROR($$$GeneralError, "Standard package name not configured")
			quit
		}
		set packageType = "DTL"
		if (packageName = "") {
			set ^HS.XF.Config("Delivery", project, "CustomPackage", packageType) = packageName
			quit
		}
		set origPackageName = packageName
		if ($extract(packageDefault, *) '= ".") set packageDefault = packageDefault _ "."
		if ($extract(packageName, *) '= ".") set packageName = packageName _ "."
		if '$system.OBJ.IsValidClassname(packageName_"Test") {
			set tSC = $$$ERROR($$$GeneralError, "The custom " _ origPackageName _ " package name is not a valid package name")
		} elseif (packageName = packageDefault) {
			set tSC = $$$ERROR($$$GeneralError, "The custom " _ $extract(packageName,1,*-1) _ " package name cannot equal the standard " _ $extract(packageName,1,*-1) _ " package name")
		} elseif ($length(packageName)>$length(packageDefault))&&($extract(packageName,1,$length(packageDefault))=packageDefault) {
			set tSC = $$$ERROR($$$GeneralError, "The custom " _ $extract(packageName,1,*-1) _ " package name cannot be a sub-package the standard " _ $extract(packageDefault,1,*-1) _ " package")
		} elseif ($extract(packageName,1,14)="HS.Local.SDA3.") {
			set tSC = $$$ERROR($$$GeneralError, "The custom " _ $extract(packageName,1,*-1) _ " package name cannot occupy reserved package " _ $extract(packageName,1,*-1))
		} elseif ($extract(packageName,1,3)="HS.")&&($extract(packageName,1,9)'="HS.Local.") {
			set tSC = $$$ERROR($$$GeneralError, "The custom " _ $extract(packageName,1,*-1) _ " package name cannot occupy reserved package HS unless within HS.Local")
		} else {
			if ($extract(packageName,1,9)'="HS.Local.") {
				set reservedPackages = ",CSPX,Demo,Ens,EnsLib,EnsPortal,HS,HC,HSMOD,Installer,NSLocal,qd,Sample,SchemaMap,UnitTest,"
				set packageNameP1 = $piece(packageName,".",1)
				if (reservedPackages[(","_packageNameP1_",")) {
					set tSC = $$$ERROR($$$GeneralError, "The custom " _ $extract(packageName,1,*-1) _ " package name cannot occupy reserved product package "_packageNameP1)
				}
			}
		}
		if $$$ISERR(tSC) quit
		set ^HS.XF.Config("Delivery", project, "CustomPackage", packageType) = $extract(packageName,1,*-1)
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// API Method
/// Returns a configuration value that has been set via the Public API method
/// HS.FHIR.DTL.Util.API.ExecDefinition::SetCustomDTLPackage. This is the root
/// package under which you will place any customized DTL classes for transforming
/// FHIR STU3 to SDA3, or SDA3 to FHIR STU3.
ClassMethod GetCustomDTLPackage() As %String
{
	set configName = ""
	set project = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredProjectName()
	if (project '= "") {
		set packageType = "DTL"
		set configName = $get(^HS.XF.Config("Delivery", project, "CustomPackage", packageType))				
	}
	quit configName
}

/// API Method
/// Returns the configured standard product DTL package name for this namespace.
ClassMethod GetStandardDTLPackage() As %String
{
	Quit ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageName("HS.FHIR.DTL")
}

/// API Method
/// Returns the configured standard product DTL package name for this namespace.
ClassMethod GetStandardLibDTLPackage() As %String
{
	Quit ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageName("HS.FHIR.DTL.SubXFrm")
}

/// API Method
/// This method checks className to see if it arrives prefixed with the
/// configured standard DTL package name or with the configured custom
/// DTL package name.
/// <p>
/// No other package names are acceptable at the start of the className.
/// <p>
/// Regardless of which name prefix enters the method in the className,
/// this method first looks in the custom DTL package (if there is one
/// configured) and if the corresponding DTL class is not found in the
/// custom package, the method looks in the standard package. 
/// <p>
/// The method returns the full package and class name of the first class
/// it finds. If neither DTL class is found, or if the name prefix is
/// unacceptable, it returns an empty string.
ClassMethod GetDTLPackageAndClass(className As %String) As %String
{
	set defaultDTLPkg = ..GetStandardDTLPackage()
	if $extract(defaultDTLPkg, *)'="." set defaultDTLPkg = defaultDTLPkg _ "."
	set defaultLibDTLPkg = ..GetStandardLibDTLPackage()
	if $extract(defaultLibDTLPkg, *)'="." set defaultLibDTLPkg = defaultLibDTLPkg _ "."
	set customDTLPkg = ..GetCustomDTLPackage()
	if (customDTLPkg '= "") && ($extract(customDTLPkg, *)'=".") set customDTLPkg = customDTLPkg _ "."
	if (customDTLPkg = ".") set customDTLPkg = ""

	set defaultDTLPkgLen = $length(defaultDTLPkg)
	set defaultLibDTLPkgLen = $length(defaultLibDTLPkg)
	set customDTLPkgLen = $length(customDTLPkg)
	
	// If no custom package defined and class does not start with standard package, then bad class name.
	if (customDTLPkg = "") && ($extract(className, 1, defaultDTLPkgLen) '= defaultDTLPkg) && ($extract(className, 1, defaultLibDTLPkgLen) '= defaultLibDTLPkg) {
		quit ""
	}
	
	// If custom package defined and class starts with neither standard nor custom package, then bad class name.
	if ($extract(className, 1, defaultDTLPkgLen)'=defaultDTLPkg) && ($extract(className, 1, defaultLibDTLPkgLen)'=defaultLibDTLPkg) && ((customDTLPkg '= "")&&($extract(className, 1, customDTLPkgLen) '= customDTLPkg)) {
		quit ""
	}
	
	if customDTLPkg = "" {
		quit className
	}
	
	set customDTLClassName = customDTLPkg _ $extract(className, defaultDTLPkgLen+1, *)
	
	if (##class(%Dictionary.ClassDefinition).%ExistsId(customDTLClassName)) {
		quit customDTLClassName
	}
	
	if (##class(%Dictionary.ClassDefinition).%ExistsId(className)) {
		quit className
	}
	
	quit ""
}

/// API Method
/// Similar to GetDTLPackageAndClass(), but intended for manual use, to
/// "preview" the custom class name for a specified standard class name.
/// If no custom DTL package is defined in the current namespace then an
/// error message is returned. If the specified standard class is invalid
/// or does not exist, then empty string is returned.
ClassMethod PreviewDTLCustomClass(className As %String) As %String
{
	if $get(className)="" {
		quit "Class name not specified"
	}
	
	if ('##class(%Dictionary.ClassDefinition).%ExistsId(className)) {
		quit "Specified class does not exist"
	}
	
	set defaultDTLPkg = ..GetStandardDTLPackage()
	if $extract(defaultDTLPkg, *)'="." set defaultDTLPkg = defaultDTLPkg _ "."
	set customDTLPkg = ..GetCustomDTLPackage()
	if (customDTLPkg '= "") && ($extract(customDTLPkg, *)'=".") set customDTLPkg = customDTLPkg _ "."
	if (customDTLPkg = ".") set customDTLPkg = ""
	
	if customDTLPkg = "" {
		quit "Custom DTL package not defined"
	}
	
	set defaultDTLPkgLen = $length(defaultDTLPkg)
	set customDTLPkgLen = $length(customDTLPkg)
	
	// If specified class does not start with standard package, then bad class name.
	if ($extract(className, 1, defaultDTLPkgLen) '= defaultDTLPkg) {
		quit "Invalid class name specified - must start with standard class package root "_defaultDTLPkg
	}
	
	set customDTLClassName = customDTLPkg _ $extract(className, defaultDTLPkgLen+1, *)
	
	quit customDTLClassName
}

}

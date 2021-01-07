/// This class provides utility code that a delivery instance needs, in order to
/// run code that was generated and delivered to it from the Schema Mapper tool.
/// By design, every method in this class is safe to run on a delivery instance
/// but also works correctly on a developer instance.
/// <p>
/// NOTE: To be safe to run on a delivery instance, 
/// code in Lib and Gen packages must not use: SchemaMap.inc, 
/// class packages other than SchemaMap.Lib and SchemaMap.Gen,
/// $$$Map macros, or globals other than those delivered via 
/// product installation (the dev_healthshare/XF folder).
Class HS.FHIR.DTL.Util.Package
{

/// Supported values are "Development" or "Delivery", default is "Development".
ClassMethod SetBuildMode(mode As %String = "Development")
{
	set ^HS.XF.Config("BuildMode") = mode
}

ClassMethod GetBuildMode() As %String
{
	quit $get(^HS.XF.Config("BuildMode"), "Development")
}

/// Find out the delivery schema name from a development schema name
ClassMethod GetConfiguredSchemaName(schema As %String = "") As %String
{
	quit $select($data(^HS.XF.Config("Delivery", ^HS.XF.Config("Project"), "ConfiguredName", schema)):
						^HS.XF.Config("Delivery", ^HS.XF.Config("Project"), "ConfiguredName", schema),
				1:schema)
}

/// Find out development mode schema name from a configured schema name
ClassMethod GetMapperSchemaName(schema As %String = "") As %String
{
	quit $select($data(^HS.XF.Config("Delivery", ^HS.XF.Config("Project"), "MapperName", schema)):
						^HS.XF.Config("Delivery", ^HS.XF.Config("Project"), "MapperName", schema),
				1:schema)
}

/// Find out the delivery schema name from a generated object model full class name
ClassMethod GetConfiguredSchemaFromClassname(className As %String = "") As %String
{
	set field = ""
	for n=$length(className, "."):-1:1 {
		set field = $piece(className, ".", n)
		if $data(^HS.XF.Config("Delivery", ^HS.XF.Config("Project"), "ConfiguredName", field)) ||
			$data(^HS.XF.Config("Delivery", ^HS.XF.Config("Project"), "MapperName", field)) {
			quit
		}
	}
	quit field
}

/// Find out the development schema name from a generated object model full class name
ClassMethod GetMapperSchemaFromClassname(className As %String = "") As %String
{
	quit ..GetMapperSchemaName(..GetConfiguredSchemaFromClassname(className))
}

ClassMethod GetConfiguredProjectName() As %String
{
	quit $get(^HS.XF.Config("Project"), "")
}

ClassMethod GetConfiguredPackageName(package As %String = "") As %String
{
	set tSC = $$$OK
	set configName = ""
	try {
		quit:(package = "")
		
		if (..GetBuildMode() = "Delivery") {
			// delivery instance or delivery mode
			set project = ..GetConfiguredProjectName()
			if (project '= "") {
				set configName = $get(^HS.XF.Config("Delivery", project, package), "")				
			}
			// TO DO: replace this workaround (the Config global should be present and should work)
			if (configName = "") { 
				set configName = $case(package,
					  "Common":"HS.FHIR.DTL", 									// do not refactor
					  "^SchemaMap":"^HS.XF", 									// do not refactor
					  "SchemaMap.Gen.DTL":"HS.FHIR.DTL", 						// do not refactor
					  "SchemaMap.Gen.Model.vDSTU2":"HS.FHIR.DTL.vDSTU2.Model", 	// do not refactor
					  "SchemaMap.Gen.Model.vSTU3":"HS.FHIR.DTL.vSTU3.Model", 	// do not refactor
					  "SchemaMap.Gen.Model.vR4":"HS.FHIR.DTL.vR4.Model", 		// do not refactor
					  "HS.SDA3":"HS.SDA3", 										// do not refactor
					  "SchemaMap.Lib.DTL":"HS.FHIR.DTL.SubXFrm", 				// do not refactor
					  "SchemaMap.Lib.Util":"HS.FHIR.DTL.Util", 					// do not refactor
					  "SchemaMap.Lib.JSON":"HS.FHIR.DTL.Util.JSON", 			// do not refactor
					  "SchemaMap.Lib.XML":"HS.FHIR.DTL.Util.XML",	 			// do not refactor
					  "SchemaMap.Lib.API":"HS.FHIR.DTL.Util.API", 				// do not refactor
					  :""
					  )
				if (configName = "") {
					if ('$find(package, "SchemaMap")) {							// do not refactor
						// it is the expected default case: the supplied package name is fine
						set configName = package
					}
				}
			}
		}
		else {
			// developer instance
			set configName = package
		}
	} 
	catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit configName
}

ClassMethod GetConfiguredPackageModelName(schema As %String = "") As %String
{
	set tSC = $$$OK
	set configName = ""
	try {
		quit:(schema = "")
		if (schema [ "FHIR") {
			set configSchema = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(schema)
			set configName = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageName("SchemaMap.Gen.Model." _ configSchema)
		}
		elseif (schema = "SDA3") {
			set configName = "HS.SDA3"
		}
		else {
			set configName = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageName("SchemaMap.Gen.Model." _ schema)
		}
	} 
	catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit configName
}

}

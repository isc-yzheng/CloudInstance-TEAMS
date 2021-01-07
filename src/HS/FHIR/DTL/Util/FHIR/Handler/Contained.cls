Class HS.FHIR.DTL.Util.FHIR.Handler.Contained
{

/// Get the DTL class to use when transforming contained resources between STU3 and DSTU2.
/// source - the source object to be transformed.
/// target - the target object to be created.
ClassMethod GetClass(source As %RegisteredObject, target As %RegisteredObject) As %String
{
	set sourceSchema = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaFromClassname(source.%ClassName(1))
	set targetSchema = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaFromClassname(target.%ClassName(1))
	set packageDTL = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageName("SchemaMap.Gen.DTL")
	set resourceType = source.resourceType
	
	if ((packageDTL = "") || (sourceSchema = "") || (targetSchema = "") || (resourceType = "")) quit ""
	set package = packageDTL _ "." _ sourceSchema _ "." _ targetSchema _ "." _ resourceType
	
	set sql = "SELECT id FROM %Dictionary.ClassDefinition WHERE id %STARTSWITH '" _ package _".'"
	set statement = ##class(%SQL.Statement).%New()
	set tSC = statement.%Prepare(sql) quit:$$$ISERR(tSC)
	set result = statement.%Execute()
	if (result.%SQLCODE < 0) {
		set tSC = $$$ERROR($$$SQLError, result.%SQLCODE, result.%Message)
		quit tSC
	}
	do result.%Next()
	set class = $property(result, "id")
	
	quit class
}

/// Transform a contained resource between STU3 and DSTU2.
ClassMethod Transform(class As %String, source As %RegisteredObject) As %RegisteredObject
{
	if class = "" quit ""
	
	set target = $classmethod($classmethod(class, "GetTargetType"), "%New")
	set tSC = ##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL(class, source, .target)
	quit target
}

/// Returns a reference to a contained resource, saving the number of contained resources already created so that the next contained
/// resource can determine what its id should be.
/// resource - The contained resource object
/// containedResourceCount - The number of currently existing contained resources. Used to determine the contained resource's id.
/// returnReference - Whether or not to return a reference to the resource.
/// reference - The created reference to the contained resource.
ClassMethod Reference(Output resource As %RegisteredObject, containedResourceCount As %Integer, returnReference As %Boolean = 0, Output reference As %RegisteredObject) As %Status
{
	set tSC = $$$OK
	try {
		if returnReference {
			set packageModel = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageModelName("FHIR3")
			if (packageModel = "") quit		
			set reference = $classmethod(packageModel _ ".Base.Reference", "%New")
			set id = containedResourceCount + 1
			set resource.id = id
			set reference.reference = "#" _ id
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}

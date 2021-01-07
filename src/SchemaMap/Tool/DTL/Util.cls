Include SchemaMap

/// TODO: Add class description
Class SchemaMap.Tool.DTL.Util
{

ClassMethod Assign(from As %String, to As %String, fromElement As %String, toElement As %String, fromPath As %String, toPath As %String, sourceValue As %String, transformationSource As %String, annotation As %String, classmethod As %String, defaultValue As %String, subtransform As %String, extension As %String, append As %Boolean, dependsOn As %String, Output text As %String) As %Status
{
}

ClassMethod AddAnnotation(annotation As %String, Output text As %String) As %Status
{
}

ClassMethod ClassMethod(from As %String, to As %String, fromPath As %String, toPath As %String, fromElement As %String, toElement As %String, transformationSource As %String, classmethod As %String, defaultValue As %String, extension As %String, append As %String, dependsOn As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod SubTransform(from As %String, to As %String, fromPath As %String, toPath As %String, fromElement As %String, toElement As %String, subtransform As %String, extension As %String, append As %Boolean, dependsOn As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod SourceValue(from As %String, to As %String, sourceValue As %String, toPath As %String, toElement As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod GenericAssign(fromElement As %String, toElement As %String, defaultValue As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod Boolean(fromElement As %String, toElement As %String, from As %String, to As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod ListToList(fromElement As %String, toElement As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod ListToSingle(fromElement As %String, toElement As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod SingleToList(fromElement As %String, toElement As %String, annotation As %String, Output text As %String) As %Status
{
}

ClassMethod CorrectDependsOn(dependsOn As %String) As %String
{
}

ClassMethod GetSubTransformClasses(from As %String, to As %String, fromPath As %String, toPath As %String, Output libDTLClass As %String, Output genDTLClass As %String, force As %Boolean = 0) As %Status
{
}

}

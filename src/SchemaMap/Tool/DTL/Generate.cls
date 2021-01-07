Include SchemaMap

/// This class will evolve, but was started based on the server side code in 
/// %MPRL.UI.NewWizard, %MPRL.Model.linkageDefinition, and %MPRL.UI.AuditLogDebug, 
/// and DTL classes in the package HS.FHIR.DTL.ToSDA.
Class SchemaMap.Tool.DTL.Generate Extends SchemaMap.Tool.Base.Generate [ Abstract ]
{

/// Create a new transformation class. 
ClassMethod CreateDTLClass(package As %String, from As %String, to As %String, source As %String, target As %String, Output className As %String) As %Status
{
}

ClassMethod CreateXDataBlock(classDefinition As %Dictionary.ClassDefinition, blockName As %String, timestamp As %String, from As %String, to As %String, source As %String, target As %String, sourceClass As %String, targetClass As %String) As %Status
{
}

ClassMethod WriteXDataBlock(timestamp As %String, xData As %Dictionary.XDataDefinition, from As %String, to As %String, source As %String, target As %String, sourceClass As %String, targetClass As %String) As %Status
{
}

ClassMethod AddTransform(xData, fromElement, toElement, from, to, fromPath, sourceValue, transformationSource, toPath, toNotes, classmethod, defaultValue, subtransform, extension, dependsOn, excludeList, append) As %Status
{
}

ClassMethod IsNewLoop(fromElement As %String, %currLoopLevel As %Integer) As %Boolean
{
}

ClassMethod ExitLoop(xData As %Dictionary.XDataDefinition, arg As %String, key As %Integer, toList As %Boolean = 1) As %Status
{
}

ClassMethod EnterLoop(xData As %Dictionary.XDataDefinition, arg As %String, key As %Integer) As %Status
{
}

/// <var>replaceMappingsWithTransforms</var> will search the mappings for <var>source</var>, and for each object in
/// <var>source</var> see if there are entries in the mapping table with a type that matches the object's type.
/// If there are, it will generate that transform first then update the object's mapping in <var>source</var> to use that subtransform,
/// then generate <var>source</var> as usual. <var>updateReferences</var> will, after <var>source</var> is generated, 
/// go through the mapping table and see if there are any instances where the newly created transform could
/// replace existing mappings, and will update those entries.
/// 
/// <var>level</var> is used in cases where transform A depends on transform B which depends on transform A, so we don't get caught in an
/// infinite loop. Should always be 0 when called from the outside world.
ClassMethod GenerateTransforms(package As %String = "", from As %String, to As %String, source As %String, target As %String = "", replaceMappingsWithTransforms As %Boolean = 0, updateReferences As %Boolean = 0, level = 0) As %Status
{
}

ClassMethod GenerateDependencies(package As %String, from As %String, to As %String, source As %String, target As %String) As %Status
{
}

/// <var>replaceMappingsWithTransforms</var> will search the mappings for the current resource, and for each object see if there are
/// entries in the mapping table for that object. If there are, it will generate that object first, then generate the current
/// object as usual. updateReferences is not a provided parameter here because it is a slower operation and, more importantly, it will
/// be done intrensically assuming <var>replaceMappingsWithTransforms</var> is set to true.
ClassMethod GenerateAll(from As %String, to As %String, package As %String = "", replaceMappingsWithTransforms As %Boolean = 0) As %Status
{
}

/// How many resources would we be transforming if we ran GenerateAll right now?
/// Form a reply message that explains what will be happening in terms of resource count.
ClassMethod GetGenerateResourceCount(from As %String, to As %String, Output message As %String = "") As %Status
{
}

}

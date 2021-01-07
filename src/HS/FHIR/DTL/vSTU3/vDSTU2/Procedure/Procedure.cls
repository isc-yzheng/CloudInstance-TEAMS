/// Transforms vSTU3 Procedure to vDSTU2 Procedure
Class HS.FHIR.DTL.vSTU3.vDSTU2.Procedure.Procedure Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Procedure, HS.FHIR.DTL.vDSTU2.Model.Resource.Procedure), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Procedure' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Procedure' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Procedure (vSTU3) to Procedure (vDSTU2) ]]>
  </annotation>
<if condition='(source.performedPeriod &apos;= "") &amp;&amp; (source.performedPeriod.end = "") &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","event-status","procedure-status",source.status) = "")'> 
<true>
<assign value='"in-progress"' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | aborted | completed | entered-in-error
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   ]]>
</annotation>
</assign>
</true>
</if>
<if condition='(((source.performedPeriod &apos;= "") &amp;&amp; (source.performedPeriod.end &apos;= "")) || (source.performedDateTime &apos;= "") || ((source.performedPeriod = "") &amp;&amp; (source.performedDateTime = ""))) &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","event-status","procedure-status",source.status) = "")'> 
<true>
<assign value='"completed"' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | aborted | completed | entered-in-error
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   ]]>
</annotation>
</assign>
</true>
</if>
<if condition='source.basedOn&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:request", source.basedOn)'> 
<true>
<if condition='source.basedOn.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.basedOn.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.request' action='set'  >
<annotation>
<![CDATA[ A request for this procedure
 --- FHIR STU3 Procedure:basedOn is a *List*, and FHIR DSTU2 Procedure:request is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.bodySite&apos;=""'> 
<true>
<foreach property='source.bodySite()' key='st' >
<assign value='target.bodySite.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.bodySite.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.bodySite' action='set' key='index'  >
<annotation>
<![CDATA[ Target body sites
 --- Note: The FHIR value set being used is (* body-site) which means any FHIR2 code may be used; body-site shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.category&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.category' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.category' action='set'  >
<annotation>
<![CDATA[ Classification of the procedure
 --- Note: The FHIR value set being used is (* procedure-category) which means any FHIR2 code may be used; procedure-category shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.code' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.code' action='set'  >
<annotation>
<![CDATA[ Identification of the procedure
 --- Note: The FHIR value set being used is (* procedure-code) which means any FHIR2 code may be used; procedure-code shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.complication&apos;=""'> 
<true>
<foreach property='source.complication()' key='st' >
<assign value='target.complication.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.complication.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.complication' action='set' key='index'  >
<annotation>
<![CDATA[ Complication following the procedure
 --- Note: The FHIR value set being used is (* condition-code) which means any FHIR2 code may be used; condition-code shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.contained&apos;=""'> 
<true>
<foreach property='source.contained()' key='st' >
<assign value='target.contained.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Resource).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Resource.Resource' targetObj='tmp' sourceObj='source.contained.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contained' action='set' key='index'  >
<annotation>
<![CDATA[ Contained, inline Resources ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:encounter", source.context)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.encounter' action='set'  >
<annotation>
<![CDATA[ The encounter associated with the procedure
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.extension&apos;=""'> 
<true>
<foreach property='source.extension()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.focalDevice&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.focalDevice()' key='k1' >
<if condition='source.focalDevice.(k1).action&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.focalDevice.(k1).action' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.focalDevice.(j1).action' action='set'  >
<annotation>
<![CDATA[ Kind of change to device ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.focalDevice.(k1).manipulated&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:focalDevice[n].manipulated", source.focalDevice.(k1).manipulated)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.focalDevice.(k1).manipulated' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.focalDevice.(j1).manipulated' action='set'  >
<annotation>
<![CDATA[ Device that was changed
 --- Device   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='target.focalDevice.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.followUp&apos;=""'> 
<true>
<foreach property='source.followUp()' key='st' >
<assign value='target.followUp.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.followUp.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.followUp' action='set' key='index'  >
<annotation>
<![CDATA[ Instructions for follow up
 --- Note: The FHIR value set being used is (* procedure-followup) which means any FHIR2 code may be used; procedure-followup shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ Logical id of this artifact ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.identifier&apos;=""'> 
<true>
<foreach property='source.identifier()' key='st' >
<assign value='target.identifier.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.identifier.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ External Identifiers for this procedure ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.implicitRules&apos;=""'> 
<true> 
<assign value='source.implicitRules' property='target.implicitRules' action='set' >
<annotation>
<![CDATA[ A set of rules under which this content was created ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.language&apos;=""'> 
<true> 
<assign value='source.language' property='target.language' action='set' >
<annotation>
<![CDATA[ Language of the resource content ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.location&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:location", source.location)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.location' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.location' action='set'  >
<annotation>
<![CDATA[ Where the procedure happened
 --- Location   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.meta&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Meta).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Meta.Meta' targetObj='tmp' sourceObj='source.meta' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.meta' action='set'  >
<annotation>
<![CDATA[ Metadata about the resource ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.modifierExtension&apos;=""'> 
<true>
<foreach property='source.modifierExtension()' key='st' >
<assign value='target.modifierExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.notDone&apos;=""'> 
<true> 
<assign value='source.notDone' property='target.notPerformed' action='set' >
<annotation>
<![CDATA[ True if procedure was not performed as scheduled ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.notDoneReason&apos;=""'> 
<true>
<assign value='target.reasonNotPerformed.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.notDoneReason' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reasonNotPerformed' action='set' key='index'  >
<annotation>
<![CDATA[ Reason procedure was not performed
 --- Note: The FHIR value set being used is (* procedure-not-performed-reason) which means any FHIR2 code may be used; procedure-not-performed-reason shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.note&apos;=""'> 
<true>
<foreach property='source.note()' key='st' >
<assign value='target.notes.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation' targetObj='tmp' sourceObj='source.note.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.notes' action='set' key='index'  >
<annotation>
<![CDATA[ Additional information about the procedure ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.outcome&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.outcome' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.outcome' action='set'  >
<annotation>
<![CDATA[ The result of procedure
 --- Note: The FHIR value set being used is (* procedure-outcome) which means any FHIR2 code may be used; procedure-outcome shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.performedDateTime&apos;=""'> 
<true> 
<assign value='source.performedDateTime' property='target.performedDateTime' action='set' >
<annotation>
<![CDATA[ Date/Period the procedure was performed ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.performedPeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.performedPeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.performedPeriod' action='set'  >
<annotation>
<![CDATA[ Date/Period the procedure was performed ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.performer&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.performer()' key='k1' >
<if condition='source.performer.(k1).actor&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:performer[n].actor", source.performer.(k1).actor)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.performer.(k1).actor' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.performer.(j1).actor' action='set'  >
<annotation>
<![CDATA[ The reference to the practitioner
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.performer.(k1).role&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.performer.(k1).role' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.performer.(j1).role' action='set'  >
<annotation>
<![CDATA[ The role the actor was in ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='target.performer.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.primitiveExtension()' key='st' >
<assign value='target.primitiveExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.reasonReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:reasonReference", source.reasonReference)'> 
<true>
<if condition='source.reasonReference.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.reasonReference.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reasonReference' action='set'  >
<annotation>
<![CDATA[ Reason procedure performed
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.
 --- FHIR STU3 Procedure:reasonReference is a *List*, and FHIR DSTU2 Procedure:reasonReference is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.report&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:report", source.report)'> 
<true>
<foreach property='source.report()' key='st' >
<assign value='target.report.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.report.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.report' action='set' key='index'  >
<annotation>
<![CDATA[ Any report resulting from the procedure
 --- DiagnosticReport   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","event-status","procedure-status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | aborted | completed | entered-in-error
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Procedure:status uses value set (event-status) and FHIR DSTU2 Procedure:status uses value set (procedure-status). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- The target FHIR DSTU2 Procedure:status is a required field with a required value set, but FHIR STU3 Procedure:status and  FHIR DSTU2 Procedure:status use different value sets. The target FHIR DSTU2 Procedure:status uses value set (procedure-status) and FHIR STU3 Procedure:status uses value set (event-status). *No Default Value* is supplied in case of invalid source data. This can be a serious gap.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:subject", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.subject' action='set'  >
<annotation>
<![CDATA[ Who the procedure was performed on
 --- Patient | Group   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.text&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Narrative).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Narrative.Narrative' targetObj='tmp' sourceObj='source.text' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.text' action='set'  >
<annotation>
<![CDATA[ Text summary of the resource, for human interpretation ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.usedReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Procedure:used", source.usedReference)'> 
<true>
<foreach property='source.usedReference()' key='st' >
<assign value='target.used.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.usedReference.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.used' action='set' key='index'  >
<annotation>
<![CDATA[ Items used during procedure
 --- Device | Medication | Substance   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
</transform>
}

}

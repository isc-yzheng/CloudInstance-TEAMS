/// Transforms vSTU3 Observation to vDSTU2 Observation
Class HS.FHIR.DTL.vSTU3.vDSTU2.Observation.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Observation, HS.FHIR.DTL.vDSTU2.Model.Resource.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Observation' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Observation (vSTU3) to Observation (vDSTU2) ]]>
  </annotation>
<if condition='source.bodySite&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.bodySite' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.bodySite' action='set'  >
<annotation>
<![CDATA[ Observed body part
 --- Note: The FHIR value set being used is (* body-site) which means any FHIR2 code may be used; body-site shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.category&apos;=""'> 
<true>
<if condition='source.category.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.category.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.category' action='set'  >
<annotation>
<![CDATA[ Classification of  type of observation
 --- FHIR STU3 Observation:category is a *List*, and FHIR DSTU2 Observation:category is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
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
<![CDATA[ Type of observation (code / type)
 --- Note: The FHIR value set being used is (* observation-codes) which means any FHIR2 code may be used; observation-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.comment&apos;=""'> 
<true> 
<assign value='source.comment' property='target.comments' action='set' >
<annotation>
<![CDATA[ Comments about result ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.component&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.component()' key='k1' >
<if condition='source.component.(k1).code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.component.(k1).code' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).code' action='set'  >
<annotation>
<![CDATA[ Type of component observation (code / type)
 --- Note: The FHIR value set being used is (* observation-codes) which means any FHIR2 code may be used; observation-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).dataAbsentReason&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.component.(k1).dataAbsentReason' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).dataAbsentReason' action='set'  >
<annotation>
<![CDATA[ Why the component result is missing
 --- Note: The FHIR value set being used is (observation-valueabsentreason +) which means observation-valueabsentreason is the *Required* FHIR2 ValueSet for codes, but if you need to express meanings not found in observation-valueabsentreason, you may formally *Extend* observation-valueabsentreason to add codes to it.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).referenceRange&apos;=""'> 
<true>
<foreach property='source.component.(k1).referenceRange()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.component&apos;="") &amp;&amp; (target.component.Count() &gt; 0)'> 
<true> 
<if condition='target.component.(j1)&apos;=""'> 
<true> 
<assign value='target.component.(j1).referenceRange.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Element.Observation.referenceRange).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Observation.referenceRange.Observation.referenceRange' targetObj='tmp' sourceObj='source.component.(k1).referenceRange.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).referenceRange' action='set' key='index'  >
<annotation>
<![CDATA[ Provides guide for interpretation of component result ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.component.(k1).valueAttachment&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Attachment.Attachment' targetObj='tmp' sourceObj='source.component.(k1).valueAttachment' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).valueAttachment' action='set'  >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).valueCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.component.(k1).valueCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).valueCodeableConcept' action='set'  >
<annotation>
<![CDATA[ Actual component result
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).valueDateTime&apos;=""'> 
<true>
<if condition='source.component.(k1).valueDateTime&apos;=""'> 
<true> 
<assign value='source.component.(k1).valueDateTime' property='target.component.(j1).valueDateTime' action='set' >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.component.(k1).valuePeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.component.(k1).valuePeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).valuePeriod' action='set'  >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).valueQuantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Quantity.Quantity' targetObj='tmp' sourceObj='source.component.(k1).valueQuantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).valueQuantity' action='set'  >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).valueRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.component.(k1).valueRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).valueRange' action='set'  >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).valueRatio&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Ratio.Ratio' targetObj='tmp' sourceObj='source.component.(k1).valueRatio' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).valueRatio' action='set'  >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).valueSampledData&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SampledData.SampledData' targetObj='tmp' sourceObj='source.component.(k1).valueSampledData' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).valueSampledData' action='set'  >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.component.(k1).valueString&apos;=""'> 
<true>
<if condition='source.component.(k1).valueString&apos;=""'> 
<true> 
<assign value='source.component.(k1).valueString' property='target.component.(j1).valueString' action='set' >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.component.(k1).valueTime&apos;=""'> 
<true>
<if condition='source.component.(k1).valueTime&apos;=""'> 
<true> 
<assign value='source.component.(k1).valueTime' property='target.component.(j1).valueTime' action='set' >
<annotation>
<![CDATA[ Actual component result ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.component.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
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
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Observation:encounter", source.context)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.encounter' action='set'  >
<annotation>
<![CDATA[ Healthcare event during which this observation is made
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.dataAbsentReason&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.dataAbsentReason' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dataAbsentReason' action='set'  >
<annotation>
<![CDATA[ Why the result is missing
 --- Note: The FHIR value set being used is (observation-valueabsentreason +) which means observation-valueabsentreason is the *Required* FHIR2 ValueSet for codes, but if you need to express meanings not found in observation-valueabsentreason, you may formally *Extend* observation-valueabsentreason to add codes to it.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.device&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Observation:device", source.device)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.device' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.device' action='set'  >
<annotation>
<![CDATA[ (Measurement) Device
 --- Device | DeviceMetric   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.effectiveDateTime&apos;=""'> 
<true> 
<assign value='source.effectiveDateTime' property='target.effectiveDateTime' action='set' >
<annotation>
<![CDATA[ Clinically relevant time/time-period for observation ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.effectivePeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.effectivePeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.effectivePeriod' action='set'  >
<annotation>
<![CDATA[ Clinically relevant time/time-period for observation ]]>
</annotation>
</assign></true> 
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
<![CDATA[ Unique Id for this particular observation ]]>
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

<if condition='source.interpretation&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.interpretation' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.interpretation' action='set'  >
<annotation>
<![CDATA[ High, low, normal, etc.
 --- Note: The FHIR value set being used is (observation-interpretation +) which means observation-interpretation is the *Required* FHIR2 ValueSet for codes, but if you need to express meanings not found in observation-interpretation, you may formally *Extend* observation-interpretation to add codes to it.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.issued&apos;=""'> 
<true> 
<assign value='source.issued' property='target.issued' action='set' >
<annotation>
<![CDATA[ Date/Time this was made available ]]>
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
<if condition='source.method&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.method' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.method' action='set'  >
<annotation>
<![CDATA[ How it was done
 --- Note: The FHIR value set being used is (* observation-methods) which means any FHIR2 code may be used; observation-methods shows Example codes, but you may use codes from any ValueSet.    ]]>
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
<if condition='source.performer&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Observation:performer", source.performer)'> 
<true>
<foreach property='source.performer()' key='st' >
<assign value='target.performer.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.performer.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.performer' action='set' key='index'  >
<annotation>
<![CDATA[ Who is responsible for the observation
 --- Practitioner | Organization | Patient | RelatedPerson   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
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
<if condition='source.referenceRange&apos;=""'> 
<true>
<foreach property='source.referenceRange()' key='st' >
<assign value='target.referenceRange.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Element.Observation.referenceRange).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Observation.referenceRange.Observation.referenceRange' targetObj='tmp' sourceObj='source.referenceRange.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.referenceRange' action='set' key='index'  >
<annotation>
<![CDATA[ Provides guide for interpretation ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.referenceRange&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.referenceRange()' key='k1' >
<if condition='source.referenceRange.(k1).appliesTo&apos;=""'> 
<true>
<if condition='source.referenceRange.(k1).appliesTo.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.referenceRange.(k1).appliesTo.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component.(j1).referenceRange.(1).meaning' action='set'  >
<annotation>
<![CDATA[ Indicates the meaning/use of this range of this range
 --- FHIR STU3 Observation:referenceRange[n].appliesTo is a *List*, and FHIR DSTU2 Observation:component[n].referenceRange[n].meaning is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='target.component.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.related&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.related()' key='k1' >
<if condition='source.related.(k1).target&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Observation:related[n].target", source.related.(k1).target)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.related.(k1).target' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.related.(j1).target' action='set'  >
<annotation>
<![CDATA[ Resource that is related to this one
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.related.(k1).type&apos;=""'> 
<true>
<if condition='source.related.(k1).type&apos;=""'> 
<true> 
<assign value='source.related.(k1).type' property='target.related.(j1).type' action='set' >
<annotation>
<![CDATA[ has-member | derived-from | sequel-to | replaces | qualified-by | interfered-by
 --- Note: The FHIR value set being used is (observation-relationshiptypes) which means observation-relationshiptypes is the *Required* FHIR2 ValueSet for codes; you may NOT extend observation-relationshiptypes and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.related.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.specimen&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Observation:specimen", source.specimen)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.specimen' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.specimen' action='set'  >
<annotation>
<![CDATA[ Specimen used for this observation
 --- Specimen   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","observation-status","observation-status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ registered | preliminary | final | amended +
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (observation-status) which means observation-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend observation-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"unknown"' property='target.status' action='set' />
</false> 
</if> 
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Observation:subject", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.subject' action='set'  >
<annotation>
<![CDATA[ Who and/or what this is about
 --- Patient | Group | Device | Location   ]]>
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
<if condition='source.valueAttachment&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Attachment.Attachment' targetObj='tmp' sourceObj='source.valueAttachment' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueAttachment' action='set'  >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.valueCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueCodeableConcept' action='set'  >
<annotation>
<![CDATA[ Actual result
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueDateTime&apos;=""'> 
<true> 
<assign value='source.valueDateTime' property='target.valueDateTime' action='set' >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valuePeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.valuePeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valuePeriod' action='set'  >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueQuantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Quantity.Quantity' targetObj='tmp' sourceObj='source.valueQuantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueQuantity' action='set'  >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.valueRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueRange' action='set'  >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueRatio&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Ratio.Ratio' targetObj='tmp' sourceObj='source.valueRatio' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueRatio' action='set'  >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueSampledData&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SampledData.SampledData' targetObj='tmp' sourceObj='source.valueSampledData' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueSampledData' action='set'  >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueString&apos;=""'> 
<true> 
<assign value='source.valueString' property='target.valueString' action='set' >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueTime&apos;=""'> 
<true> 
<assign value='source.valueTime' property='target.valueTime' action='set' >
<annotation>
<![CDATA[ Actual result ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

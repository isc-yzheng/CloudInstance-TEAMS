/// Transforms vSTU3 Composition to vDSTU2 Composition
Class HS.FHIR.DTL.vSTU3.vDSTU2.Composition.Composition Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Composition, HS.FHIR.DTL.vDSTU2.Model.Resource.Composition), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Composition' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Composition' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Composition (vSTU3) to Composition (vDSTU2) ]]>
  </annotation>
<if condition='source.attester&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.attester()' key='k1' >
<if condition='source.attester.(k1).extension&apos;=""'> 
<true>
<foreach property='source.attester.(k1).extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.attester&apos;="") &amp;&amp; (target.attester.Count() &gt; 0)'> 
<true> 
<if condition='target.attester.(j1)&apos;=""'> 
<true> 
<assign value='target.attester.(j1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.attester.(k1).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.attester.(j1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.attester.(k1).id&apos;=""'> 
<true>
<if condition='source.attester.(k1).id&apos;=""'> 
<true> 
<assign value='source.attester.(k1).id' property='target.attester.(j1).id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.attester.(k1).mode&apos;=""'> 
<true>
<foreach property='source.attester.(k1).mode()' key='ll1' >
<assign value='source.attester.(k1).mode.(ll1)' property='target.attester.(j1).mode' action='set' key='ll1' >
<annotation>
<![CDATA[ personal | professional | legal | official
 --- Note: The FHIR value set being used is (composition-attestation-mode) which means composition-attestation-mode is the *Required* FHIR2 ValueSet for codes; you may NOT extend composition-attestation-mode and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></foreach>
</true>
</if>
<if condition='source.attester.(k1).modifierExtension&apos;=""'> 
<true>
<foreach property='source.attester.(k1).modifierExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.attester&apos;="") &amp;&amp; (target.attester.Count() &gt; 0)'> 
<true> 
<if condition='target.attester.(j1)&apos;=""'> 
<true> 
<assign value='target.attester.(j1).modifierExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.attester.(k1).modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.attester.(j1).modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.attester.(k1).party&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.attester.(k1).party' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.attester.(j1).party' action='set'  >
<annotation>
<![CDATA[ Who attested the composition
 --- Patient | Practitioner | Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.attester.(k1).primitiveExtension&apos;=""'> 
<true>
<foreach property='source.attester.(k1).primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.attester&apos;="") &amp;&amp; (target.attester.Count() &gt; 0)'> 
<true> 
<if condition='target.attester.(j1)&apos;=""'> 
<true> 
<assign value='target.attester.(j1).primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.attester.(k1).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.attester.(j1).primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.attester.(k1).time&apos;=""'> 
<true>
<if condition='source.attester.(k1).time&apos;=""'> 
<true> 
<assign value='source.attester.(k1).time' property='target.attester.(j1).time' action='set' >
<annotation>
<![CDATA[ When composition attested ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.attester.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.author&apos;=""'> 
<true>
<foreach property='source.author()' key='st' >
<assign value='target.author.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.author.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.author' action='set' key='index'  >
<annotation>
<![CDATA[ Who and/or what authored the composition
 --- Practitioner | Device | Patient | RelatedPerson   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.class&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.class' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.class' action='set'  >
<annotation>
<![CDATA[ Categorization of Composition
 --- Note: The FHIR value set being used is (* doc-classcodes) which means any FHIR2 code may be used; doc-classcodes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","v3-ConfidentialityClassification","v3-Confidentiality",source.confidentiality)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.confidentiality' action='set' >
<annotation>
<![CDATA[ As defined by affinity domain
Note: All codes in the source value set are in the target value set.
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Composition:confidentiality uses value set (v3-ConfidentialityClassification) and FHIR DSTU2 Composition:confidentiality uses value set (v3-Confidentiality). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field.    ]]>
</annotation>
</assign></true> 
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
<if condition='source.custodian&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.custodian' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.custodian' action='set'  >
<annotation>
<![CDATA[ Organization which maintains the composition
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.date&apos;=""'> 
<true> 
<assign value='source.date' property='target.date' action='set' >
<annotation>
<![CDATA[ Composition editing time ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.encounter&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.encounter' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.encounter' action='set'  >
<annotation>
<![CDATA[ Context of the Composition
 --- Encounter   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.event&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.event()' key='k1' >
<if condition='source.event.(k1).code&apos;=""'> 
<true>
<foreach property='source.event.(k1).code()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.event&apos;="") &amp;&amp; (target.event.Count() &gt; 0)'> 
<true> 
<if condition='target.event.(j1)&apos;=""'> 
<true> 
<assign value='target.event.(j1).code.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.event.(k1).code.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.event.(j1).code' action='set' key='index'  >
<annotation>
<![CDATA[ Code(s) that apply to the event being documented
 --- Note: The FHIR value set being used is (* v3-ActCode) which means any FHIR2 code may be used; v3-ActCode shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.event.(k1).detail&apos;=""'> 
<true>
<foreach property='source.event.(k1).detail()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.event&apos;="") &amp;&amp; (target.event.Count() &gt; 0)'> 
<true> 
<if condition='target.event.(j1)&apos;=""'> 
<true> 
<assign value='target.event.(j1).detail.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.event.(k1).detail.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.event.(j1).detail' action='set' key='index'  >
<annotation>
<![CDATA[ The event(s) being documented
 --- Any FHIR3 Resource may be indicated by this Reference   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.event.(k1).extension&apos;=""'> 
<true>
<foreach property='source.event.(k1).extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.event&apos;="") &amp;&amp; (target.event.Count() &gt; 0)'> 
<true> 
<if condition='target.event.(j1)&apos;=""'> 
<true> 
<assign value='target.event.(j1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.event.(k1).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.event.(j1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.event.(k1).id&apos;=""'> 
<true>
<if condition='source.event.(k1).id&apos;=""'> 
<true> 
<assign value='source.event.(k1).id' property='target.event.(j1).id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.event.(k1).modifierExtension&apos;=""'> 
<true>
<foreach property='source.event.(k1).modifierExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.event&apos;="") &amp;&amp; (target.event.Count() &gt; 0)'> 
<true> 
<if condition='target.event.(j1)&apos;=""'> 
<true> 
<assign value='target.event.(j1).modifierExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.event.(k1).modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.event.(j1).modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.event.(k1).period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.event.(k1).period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.event.(j1).period' action='set'  >
<annotation>
<![CDATA[ The period covered by the documentation ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.event.(k1).primitiveExtension&apos;=""'> 
<true>
<foreach property='source.event.(k1).primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.event&apos;="") &amp;&amp; (target.event.Count() &gt; 0)'> 
<true> 
<if condition='target.event.(j1)&apos;=""'> 
<true> 
<assign value='target.event.(j1).primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.event.(k1).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.event.(j1).primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='target.event.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
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
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.identifier' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.identifier' action='set'  >
<annotation>
<![CDATA[ Logical identifier of composition (version-independent) ]]>
</annotation>
</assign></true> 
</if>

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
<if condition='source.section&apos;=""'> 
<true>
<foreach property='source.section()' key='st' >
<assign value='target.section.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Element.Composition.section).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Composition.section.Composition.section' targetObj='tmp' sourceObj='source.section.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.section' action='set' key='index'  >
<annotation>
<![CDATA[ Composition is broken into sections ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.section&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.section()' key='k1' >
<if condition='source.section.(k1).text&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Narrative).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Narrative.Narrative' targetObj='tmp' sourceObj='source.section.(k1).text' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.section.(j1).text' action='set'  >
<annotation>
<![CDATA[ Text summary of the section, for human interpretation ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.section.(k1).title&apos;=""'> 
<true>
<if condition='source.section.(k1).title&apos;=""'> 
<true> 
<assign value='source.section.(k1).title' property='target.section.(j1).title' action='set' >
<annotation>
<![CDATA[ Label for section (e.g. for ToC) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.section.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.status' action='set' >
<annotation>
<![CDATA[ preliminary | final | amended | entered-in-error
 --- Note: The FHIR value set being used is (composition-status) which means composition-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend composition-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.subject&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.subject' action='set'  >
<annotation>
<![CDATA[ Who and/or what the composition is about
 --- Any FHIR3 Resource may be indicated by this Reference   ]]>
</annotation>
</assign></true> 
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
<if condition='source.title&apos;=""'> 
<true> 
<assign value='source.title' property='target.title' action='set' >
<annotation>
<![CDATA[ Human Readable name/title ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.type' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ Kind of composition (LOINC if possible)
 --- Note: The FHIR value set being used is (doc-typecodes *) which means doc-typecodes is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in doc-typecodes, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</transform>
}

}

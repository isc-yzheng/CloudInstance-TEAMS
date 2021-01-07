/// Transforms vSTU3 DocumentReference to vDSTU2 DocumentReference
Class HS.FHIR.DTL.vSTU3.vDSTU2.DocumentReference.DocumentReference Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.DocumentReference, HS.FHIR.DTL.vDSTU2.Model.Resource.DocumentReference), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.DocumentReference' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.DocumentReference' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms DocumentReference (vSTU3) to DocumentReference (vDSTU2) ]]>
  </annotation>
<if condition='source.authenticator&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:authenticator", source.authenticator)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.authenticator' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.authenticator' action='set'  >
<annotation>
<![CDATA[ Who/what authenticated the document
 --- Practitioner | Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.author&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:author", source.author)'> 
<true>
<foreach property='source.author()' key='st' >
<assign value='target.author.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.author.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.author' action='set' key='index'  >
<annotation>
<![CDATA[ Who and/or what authored the document
 --- Practitioner | Organization | Device | Patient | RelatedPerson   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
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
<![CDATA[ Categorization of document
 --- Note: The FHIR value set being used is (* c80-doc-classcodes) which means any FHIR2 code may be used; c80-doc-classcodes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

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
<if condition='source.content&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.content()' key='k1' >
<if condition='source.content.(k1).attachment&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Attachment.Attachment' targetObj='tmp' sourceObj='source.content.(k1).attachment' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.content.(j1).attachment' action='set'  >
<annotation>
<![CDATA[ Where to access the document ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.content.(k1).format&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.content&apos;="") &amp;&amp; (target.content.Count() &gt; 0)'> 
<true> 
<if condition='target.content.(j1)&apos;=""'> 
<true> 
<assign value='target.content.(j1).format.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding' targetObj='tmp' sourceObj='source.content.(k1).format' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.content.(j1).format' action='set' key='index'  >
<annotation>
<![CDATA[ Format/content rules for the document
 --- Note: The FHIR value set being used is (formatcodes *) which means formatcodes is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in formatcodes, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='target.content.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.encounter&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:context.encounter", source.context.encounter)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context.encounter' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.encounter' action='set'  >
<annotation>
<![CDATA[ Context of the document  content
 --- Encounter   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.event&apos;=""'> 
<true>
<foreach property='source.context.event()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.context&apos;=""'> 
<true> 
<assign value='target.context.event.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.context.event.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.event' action='set' key='index'  >
<annotation>
<![CDATA[ Main Clinical Acts Documented
 --- Note: The FHIR value set being used is (* v3-ActCode) which means any FHIR2 code may be used; v3-ActCode shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.facilityType&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.context.facilityType' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.facilityType' action='set'  >
<annotation>
<![CDATA[ Kind of facility where patient was seen
 --- Note: The FHIR value set being used is (* c80-facilitycodes) which means any FHIR2 code may be used; c80-facilitycodes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.context.period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.period' action='set'  >
<annotation>
<![CDATA[ Time of service that is being documented ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.practiceSetting&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.context.practiceSetting' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.practiceSetting' action='set'  >
<annotation>
<![CDATA[ Additional details about where the content was created (e.g. clinical specialty)
 --- Note: The FHIR value set being used is (* c80-practice-codes) which means any FHIR2 code may be used; c80-practice-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.context.related&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.context.related()' key='k1' >
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.related.(k1).identifier&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.context.related.(k1).identifier' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.related.(j1).identifier' action='set'  >
<annotation>
<![CDATA[ Identifier of related objects or events ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.related.(k1).ref&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:context.related[n].ref", source.context.related.(k1).ref)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context.related.(k1).ref' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.related.(j1).ref' action='set'  >
<annotation>
<![CDATA[ Related Resource
 --- Any FHIR3 Resource may be indicated by this Reference   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='target.context.related.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.sourcePatientInfo&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:context.sourcePatientInfo", source.context.sourcePatientInfo)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context.sourcePatientInfo' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context.sourcePatientInfo' action='set'  >
<annotation>
<![CDATA[ Patient demographics from source
 --- Patient   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.created&apos;=""'> 
<true> 
<assign value='source.created' property='target.created' action='set' >
<annotation>
<![CDATA[ Document creation time ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.custodian&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:custodian", source.custodian)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.custodian' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.custodian' action='set'  >
<annotation>
<![CDATA[ Organization which maintains the document
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.description&apos;=""'> 
<true> 
<assign value='source.description' property='target.description' action='set' >
<annotation>
<![CDATA[ Human-readable description (title) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.docStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","composition-status","composition-status",source.docStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.docStatus.coding.(1).code' action='set' >
<annotation>
<![CDATA[ preliminary | final | appended | amended | entered-in-error
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- Note: The FHIR value set being used is (composition-status) which means composition-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend composition-status and you may NOT use codes from other ValueSets.    ]]>
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
<![CDATA[ Other identifiers for the document ]]>
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

<if condition='source.indexed&apos;=""'> 
<true> 
<assign value='source.indexed' property='target.indexed' action='set' >
<annotation>
<![CDATA[ When this document reference created ]]>
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

<if condition='source.masterIdentifier&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.masterIdentifier' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.masterIdentifier' action='set'  >
<annotation>
<![CDATA[ Master Version Specific Identifier ]]>
</annotation>
</assign></true> 
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
<if condition='source.relatesTo&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.relatesTo()' key='k1' >
<if condition='source.relatesTo.(k1).code&apos;=""'> 
<true>
<if condition='source.relatesTo.(k1).code&apos;=""'> 
<true> 
<assign value='source.relatesTo.(k1).code' property='target.relatesTo.(j1).code' action='set' >
<annotation>
<![CDATA[ replaces | transforms | signs | appends
 --- Note: The FHIR value set being used is (document-relationship-type) which means document-relationship-type is the *Required* FHIR2 ValueSet for codes; you may NOT extend document-relationship-type and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.relatesTo.(k1).target&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:relatesTo[n].target", source.relatesTo.(k1).target)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.relatesTo.(k1).target' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.relatesTo.(j1).target' action='set'  >
<annotation>
<![CDATA[ Target of the relationship
 --- DocumentReference   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='target.relatesTo.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.securityLabel&apos;=""'> 
<true>
<foreach property='source.securityLabel()' key='st' >
<assign value='target.securityLabel.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.securityLabel.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.securityLabel' action='set' key='index'  >
<annotation>
<![CDATA[ Document security-tags
 --- Note: The FHIR value set being used is (security-labels +) which means security-labels is the *Required* FHIR2 ValueSet for codes, but if you need to express meanings not found in security-labels, you may formally *Extend* security-labels to add codes to it.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.status' action='set' >
<annotation>
<![CDATA[ current | superseded | entered-in-error
 --- Note: The FHIR value set being used is (document-reference-status) which means document-reference-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend document-reference-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "DocumentReference:subject", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.subject' action='set'  >
<annotation>
<![CDATA[ Who/what is the subject of the document
 --- Patient | Practitioner | Group | Device   ]]>
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
<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.type' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ Kind of document (LOINC if possible)
 --- Note: The FHIR value set being used is (c80-doc-typecodes *) which means c80-doc-typecodes is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in c80-doc-typecodes, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</transform>
}

}

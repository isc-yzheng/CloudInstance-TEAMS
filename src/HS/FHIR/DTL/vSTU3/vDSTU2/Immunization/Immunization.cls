/// Transforms vSTU3 Immunization to vDSTU2 Immunization
Class HS.FHIR.DTL.vSTU3.vDSTU2.Immunization.Immunization Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Immunization, HS.FHIR.DTL.vDSTU2.Model.Resource.Immunization), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Immunization' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Immunization' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Immunization (vSTU3) to Immunization (vDSTU2) ]]>
  </annotation>
<assign value='"0"' property='target.reported' action='set' >
<annotation>
<![CDATA[ Indicates a self-reported record ]]>
</annotation>
</assign>
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
<if condition='source.date&apos;=""'> 
<true> 
<assign value='source.date' property='target.date' action='set' >
<annotation>
<![CDATA[ Vaccination administration date ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.doseQuantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.doseQuantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.doseQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of vaccine administered ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.encounter&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Immunization:encounter", source.encounter)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.encounter' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.encounter' action='set'  >
<annotation>
<![CDATA[ Encounter administered as part of
 --- Encounter   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.expirationDate&apos;=""'> 
<true> 
<assign value='source.expirationDate' property='target.expirationDate' action='set' >
<annotation>
<![CDATA[ Vaccine expiration date ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.explanation&apos;=""'> 
<true>
<if condition='source.explanation.reason&apos;=""'> 
<true>
<foreach property='source.explanation.reason()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.explanation&apos;=""'> 
<true> 
<assign value='target.explanation.reason.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.explanation.reason.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.explanation.reason' action='set' key='index'  >
<annotation>
<![CDATA[ Why immunization occurred
 --- Note: The FHIR value set being used is (* immunization-reason) which means any FHIR2 code may be used; immunization-reason shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.explanation&apos;=""'> 
<true>
<if condition='source.explanation.reasonNotGiven&apos;=""'> 
<true>
<foreach property='source.explanation.reasonNotGiven()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.explanation&apos;=""'> 
<true> 
<assign value='target.explanation.reasonNotGiven.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.explanation.reasonNotGiven.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.explanation.reasonNotGiven' action='set' key='index'  >
<annotation>
<![CDATA[ Why immunization did not occur
 --- Note: The FHIR value set being used is (* no-immunization-reason) which means any FHIR2 code may be used; no-immunization-reason shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
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
<![CDATA[ Business identifier ]]>
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
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Immunization:location", source.location)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.location' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.location' action='set'  >
<annotation>
<![CDATA[ Where vaccination occurred
 --- Location   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.lotNumber&apos;=""'> 
<true> 
<assign value='source.lotNumber' property='target.lotNumber' action='set' >
<annotation>
<![CDATA[ Vaccine lot number ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.manufacturer&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Immunization:manufacturer", source.manufacturer)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.manufacturer' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.manufacturer' action='set'  >
<annotation>
<![CDATA[ Vaccine manufacturer
 --- Organization   ]]>
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
<if condition='source.note&apos;=""'> 
<true>
<foreach property='source.note()' key='st' >
<assign value='target.note.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation' targetObj='tmp' sourceObj='source.note.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.note' action='set' key='index'  >
<annotation>
<![CDATA[ Vaccination notes ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.notGiven&apos;=""'> 
<true> 
<assign value='source.notGiven' property='target.wasNotGiven' action='set' >
<annotation>
<![CDATA[ Flag for whether immunization was given ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.patient&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Immunization:patient", source.patient)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.patient' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ Who was immunized
 --- Patient   ]]>
</annotation>
</assign></true> 
</if>

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
<if condition='source.reaction&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.reaction()' key='k1' >
<if condition='source.reaction.(k1).date&apos;=""'> 
<true>
<if condition='source.reaction.(k1).date&apos;=""'> 
<true> 
<assign value='source.reaction.(k1).date' property='target.reaction.(j1).date' action='set' >
<annotation>
<![CDATA[ When reaction started ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.reaction.(k1).detail&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Immunization:reaction[n].detail", source.reaction.(k1).detail)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.reaction.(k1).detail' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reaction.(j1).detail' action='set'  >
<annotation>
<![CDATA[ Additional information on reaction
 --- Observation   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.reaction.(k1).reported&apos;=""'> 
<true>
<if condition='source.reaction.(k1).reported&apos;=""'> 
<true> 
<assign value='source.reaction.(k1).reported' property='target.reaction.(j1).reported' action='set' >
<annotation>
<![CDATA[ Indicates self-reported reaction ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.reaction.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.route&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.route' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.route' action='set'  >
<annotation>
<![CDATA[ How vaccine entered body
 --- Note: The FHIR value set being used is (* immunization-route) which means any FHIR2 code may be used; immunization-route shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.site&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.site' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.site' action='set'  >
<annotation>
<![CDATA[ Body site vaccine  was administered
 --- Note: The FHIR value set being used is (* immunization-site) which means any FHIR2 code may be used; immunization-site shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","immunization-status","medication-admin-status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | on-hold | completed | entered-in-error | stopped
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Immunization:status uses value set (immunization-status) and FHIR DSTU2 Immunization:status uses value set (medication-admin-status). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- The target FHIR DSTU2 Immunization:status is a required field with a required value set, but FHIR STU3 Immunization:status and  FHIR DSTU2 Immunization:status use different value sets. The target FHIR DSTU2 Immunization:status uses value set (medication-admin-status) and FHIR STU3 Immunization:status uses value set (immunization-status). *No Default Value* is supplied in case of invalid source data. This can be a serious gap.    ]]>
</annotation>
</assign></true> 
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
<if condition='source.vaccinationProtocol&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.vaccinationProtocol()' key='k1' >
<if condition='source.vaccinationProtocol.(k1).authority&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Immunization:vaccinationProtocol[n].authority", source.vaccinationProtocol.(k1).authority)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.vaccinationProtocol.(k1).authority' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.vaccinationProtocol.(j1).authority' action='set'  >
<annotation>
<![CDATA[ Who is responsible for protocol
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.vaccinationProtocol.(k1).description&apos;=""'> 
<true>
<if condition='source.vaccinationProtocol.(k1).description&apos;=""'> 
<true> 
<assign value='source.vaccinationProtocol.(k1).description' property='target.vaccinationProtocol.(j1).description' action='set' >
<annotation>
<![CDATA[ Details of vaccine protocol ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.vaccinationProtocol.(k1).doseSequence&apos;=""'> 
<true>
<if condition='source.vaccinationProtocol.(k1).doseSequence&apos;=""'> 
<true> 
<assign value='source.vaccinationProtocol.(k1).doseSequence' property='target.vaccinationProtocol.(j1).doseSequence' action='set' >
<annotation>
<![CDATA[ Dose number within series ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.vaccinationProtocol.(k1).doseStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.vaccinationProtocol.(k1).doseStatus' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.vaccinationProtocol.(j1).doseStatus' action='set'  >
<annotation>
<![CDATA[ Indicates if dose counts towards immunity
 --- Note: The FHIR value set being used is (* vaccination-protocol-dose-status) which means any FHIR2 code may be used; vaccination-protocol-dose-status shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.vaccinationProtocol.(k1).doseStatusReason&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.vaccinationProtocol.(k1).doseStatusReason' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.vaccinationProtocol.(j1).doseStatusReason' action='set'  >
<annotation>
<![CDATA[ Why dose does (not) count
 --- Note: The FHIR value set being used is (* vaccination-protocol-dose-status-reason) which means any FHIR2 code may be used; vaccination-protocol-dose-status-reason shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.vaccinationProtocol.(k1).series&apos;=""'> 
<true>
<if condition='source.vaccinationProtocol.(k1).series&apos;=""'> 
<true> 
<assign value='source.vaccinationProtocol.(k1).series' property='target.vaccinationProtocol.(j1).series' action='set' >
<annotation>
<![CDATA[ Name of vaccine series ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.vaccinationProtocol.(k1).seriesDoses&apos;=""'> 
<true>
<if condition='source.vaccinationProtocol.(k1).seriesDoses&apos;=""'> 
<true> 
<assign value='source.vaccinationProtocol.(k1).seriesDoses' property='target.vaccinationProtocol.(j1).seriesDoses' action='set' >
<annotation>
<![CDATA[ Recommended number of doses for immunity ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.vaccinationProtocol.(k1).targetDisease&apos;=""'> 
<true>
<foreach property='source.vaccinationProtocol.(k1).targetDisease()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.vaccinationProtocol&apos;="") &amp;&amp; (target.vaccinationProtocol.Count() &gt; 0)'> 
<true> 
<if condition='target.vaccinationProtocol.(j1)&apos;=""'> 
<true> 
<assign value='target.vaccinationProtocol.(j1).targetDisease.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.vaccinationProtocol.(k1).targetDisease.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.vaccinationProtocol.(j1).targetDisease' action='set' key='index'  >
<annotation>
<![CDATA[ Disease immunized against
 --- Note: The FHIR value set being used is (* vaccination-protocol-dose-target) which means any FHIR2 code may be used; vaccination-protocol-dose-target shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='target.vaccinationProtocol.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.vaccineCode&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.vaccineCode' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.vaccineCode' action='set'  >
<annotation>
<![CDATA[ Vaccine product administered
 --- Note: The FHIR value set being used is (* vaccine-code) which means any FHIR2 code may be used; vaccine-code shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</transform>
}

}

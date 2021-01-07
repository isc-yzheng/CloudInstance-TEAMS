/// Transforms vSTU3 Patient to vDSTU2 Patient
Class HS.FHIR.DTL.vSTU3.vDSTU2.Patient.Patient Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Patient, HS.FHIR.DTL.vDSTU2.Model.Resource.Patient), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Patient' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Patient' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Patient (vSTU3) to Patient (vDSTU2) ]]>
  </annotation>
<if condition='source.active&apos;=""'> 
<true> 
<assign value='source.active' property='target.active' action='set' >
<annotation>
<![CDATA[ Whether this patient's record is in active use ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.address&apos;=""'> 
<true>
<foreach property='source.address()' key='st' >
<assign value='target.address.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Address).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Address.Address' targetObj='tmp' sourceObj='source.address.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.address' action='set' key='index'  >
<annotation>
<![CDATA[ Addresses for the individual ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.animal&apos;=""'> 
<true>
<if condition='source.animal.breed&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.animal.breed' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.animal.breed' action='set'  >
<annotation>
<![CDATA[ E.g. Poodle, Angus
 --- Note: The FHIR value set being used is (* animal-breeds) which means any FHIR2 code may be used; animal-breeds shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.animal&apos;=""'> 
<true>
<if condition='source.animal.genderStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.animal.genderStatus' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.animal.genderStatus' action='set'  >
<annotation>
<![CDATA[ E.g. Neutered, Intact
 --- Note: The FHIR value set being used is (* animal-genderstatus) which means any FHIR2 code may be used; animal-genderstatus shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.animal&apos;=""'> 
<true>
<if condition='source.animal.species&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.animal.species' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.animal.species' action='set'  >
<annotation>
<![CDATA[ E.g. Dog, Cow
 --- Note: The FHIR value set being used is (* animal-species) which means any FHIR2 code may be used; animal-species shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.birthDate&apos;=""'> 
<true> 
<assign value='source.birthDate' property='target.birthDate' action='set' >
<annotation>
<![CDATA[ The date of birth for the individual ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.communication&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.communication()' key='k1' >
<if condition='source.communication.(k1).language&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.communication.(k1).language' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.communication.(j1).language' action='set'  >
<annotation>
<![CDATA[ The language which can be used to communicate with the patient about his or her health
 --- The target FHIR DSTU2 Patient:communication[n].language is a required field with a required value set, but FHIR STU3 Patient:communication[n].language and  FHIR DSTU2 Patient:communication[n].language use different value sets. The target FHIR DSTU2 Patient:communication[n].language uses value set (Language RFC 5646) and FHIR STU3 Patient:communication[n].language uses value set (languages +). *No Default Value* is supplied in case of invalid source data. This can be a serious gap.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.communication.(k1).preferred&apos;=""'> 
<true>
<if condition='source.communication.(k1).preferred&apos;=""'> 
<true> 
<assign value='source.communication.(k1).preferred' property='target.communication.(j1).preferred' action='set' >
<annotation>
<![CDATA[ Language preference indicator ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.communication.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.contact&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.contact()' key='k1' >
<if condition='source.contact.(k1).address&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Address).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Address.Address' targetObj='tmp' sourceObj='source.contact.(k1).address' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contact.(j1).address' action='set'  >
<annotation>
<![CDATA[ Address for the contact person ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.contact.(k1).gender&apos;=""'> 
<true>
<if condition='source.contact.(k1).gender&apos;=""'> 
<true> 
<assign value='source.contact.(k1).gender' property='target.contact.(j1).gender' action='set' >
<annotation>
<![CDATA[ male | female | other | unknown
 --- Note: The FHIR value set being used is (administrative-gender) which means administrative-gender is the *Required* FHIR2 ValueSet for codes; you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.contact.(k1).name&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.HumanName.HumanName' targetObj='tmp' sourceObj='source.contact.(k1).name' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contact.(j1).name' action='set'  >
<annotation>
<![CDATA[ A name associated with the contact person ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.contact.(k1).organization&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Patient:contact[n].organization", source.contact.(k1).organization)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.contact.(k1).organization' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contact.(j1).organization' action='set'  >
<annotation>
<![CDATA[ Organization that is associated with the contact
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.contact.(k1).period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.contact.(k1).period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contact.(j1).period' action='set'  >
<annotation>
<![CDATA[ The period during which this contact person or organization is valid to be contacted relating to this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.contact.(k1).relationship&apos;=""'> 
<true>
<foreach property='source.contact.(k1).relationship()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.contact&apos;="") &amp;&amp; (target.contact.Count() &gt; 0)'> 
<true> 
<if condition='target.contact.(j1)&apos;=""'> 
<true> 
<assign value='target.contact.(j1).relationship.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.contact.(k1).relationship.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contact.(j1).relationship' action='set' key='index'  >
<annotation>
<![CDATA[ The kind of relationship
 --- The source and target use different value sets. FHIR STU3 Patient:contact[n].relationship uses value set (v2-0131 +) and FHIR DSTU2 Patient:contact[n].relationship uses value set (patient-contact-relationship +). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- FHIR DSTU2 specifies that patient-contact-relationship is *Extensible* for FHIR DSTU2 Patient:contact[n].relationship. This could help with the issue.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.contact.(k1).telecom&apos;=""'> 
<true>
<foreach property='source.contact.(k1).telecom()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.contact&apos;="") &amp;&amp; (target.contact.Count() &gt; 0)'> 
<true> 
<if condition='target.contact.(j1)&apos;=""'> 
<true> 
<assign value='target.contact.(j1).telecom.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.ContactPoint.ContactPoint' targetObj='tmp' sourceObj='source.contact.(k1).telecom.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contact.(j1).telecom' action='set' key='index'  >
<annotation>
<![CDATA[ A contact detail for the person ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='target.contact.(j1) &apos;= ""'>
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
<if condition='source.deceasedBoolean&apos;=""'> 
<true> 
<assign value='source.deceasedBoolean' property='target.deceasedBoolean' action='set' >
<annotation>
<![CDATA[ Indicates if the individual is deceased or not ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.deceasedDateTime&apos;=""'> 
<true> 
<assign value='source.deceasedDateTime' property='target.deceasedDateTime' action='set' >
<annotation>
<![CDATA[ Indicates if the individual is deceased or not ]]>
</annotation>
</assign></true> 
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
<if condition='source.gender&apos;=""'> 
<true> 
<assign value='source.gender' property='target.gender' action='set' >
<annotation>
<![CDATA[ male | female | other | unknown
 --- Note: The FHIR value set being used is (administrative-gender) which means administrative-gender is the *Required* FHIR2 ValueSet for codes; you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.generalPractitioner&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Patient:careProvider", source.generalPractitioner)'> 
<true>
<foreach property='source.generalPractitioner()' key='st' >
<assign value='target.careProvider.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.generalPractitioner.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.careProvider' action='set' key='index'  >
<annotation>
<![CDATA[ Patient's nominated primary care provider
 --- Organization | Practitioner   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
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
<![CDATA[ An identifier for this patient ]]>
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

<if condition='source.link&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.link()' key='k1' >
<if condition='source.link.(k1).other&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Patient:link[n].other", source.link.(k1).other)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.link.(k1).other' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.link.(j1).other' action='set'  >
<annotation>
<![CDATA[ The other patient resource that the link refers to
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.link.(k1).type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","link-type","link-type",source.link.(k1).type)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.link.(j1).type' action='set' >
<annotation>
<![CDATA[ replace | refer | seealso - type of link
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (link-type) which means link-type is the *Required* FHIR2 ValueSet for codes; you may NOT extend link-type and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='target.link.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.managingOrganization&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Patient:managingOrganization", source.managingOrganization)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.managingOrganization' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.managingOrganization' action='set'  >
<annotation>
<![CDATA[ Organization that is the custodian of the patient record
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.maritalStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.maritalStatus' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.maritalStatus' action='set'  >
<annotation>
<![CDATA[ Marital (civil) status of a patient ]]>
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
<if condition='source.multipleBirthBoolean&apos;=""'> 
<true> 
<assign value='source.multipleBirthBoolean' property='target.multipleBirthBoolean' action='set' >
<annotation>
<![CDATA[ Whether patient is part of a multiple birth ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.multipleBirthInteger&apos;=""'> 
<true> 
<assign value='source.multipleBirthInteger' property='target.multipleBirthInteger' action='set' >
<annotation>
<![CDATA[ Whether patient is part of a multiple birth ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.name&apos;=""'> 
<true>
<foreach property='source.name()' key='st' >
<assign value='target.name.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.HumanName.HumanName' targetObj='tmp' sourceObj='source.name.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.name' action='set' key='index'  >
<annotation>
<![CDATA[ A name associated with the patient ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.photo&apos;=""'> 
<true>
<foreach property='source.photo()' key='st' >
<assign value='target.photo.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Attachment.Attachment' targetObj='tmp' sourceObj='source.photo.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.photo' action='set' key='index'  >
<annotation>
<![CDATA[ Image of the patient ]]>
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
<if condition='source.telecom&apos;=""'> 
<true>
<foreach property='source.telecom()' key='st' >
<assign value='target.telecom.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.ContactPoint.ContactPoint' targetObj='tmp' sourceObj='source.telecom.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.telecom' action='set' key='index'  >
<annotation>
<![CDATA[ A contact detail for the individual ]]>
</annotation>
</assign></true> 
</if>
</foreach>
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
</transform>
}

}

/// Transforms vR4 Patient to SDA3 HS.SDA3.Patient
Class HS.FHIR.DTL.vR4.SDA3.Patient.Patient Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Patient, HS.SDA3.Patient), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Patient' targetClass='HS.SDA3.Patient' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Patient (vR4) to HS.SDA3.Patient (SDA3) ]]>
  </annotation>
<if condition='source.multipleBirthBoolean = 0'> 
<true>
<assign value='"0"' property='target.BirthOrder' action='set' >
<annotation>
<![CDATA[     
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   ]]>
</annotation>
</assign>
</true>
</if>
<if condition='source.address&apos;=""'> 
<true>
<foreach property='source.address()' key='st' >
<assign value='target.Addresses.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Address).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.address.(st), "HS.FHIR.DTL.vR4.SDA3.Address.Address")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.address.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Addresses' action='set' key='index'  >
<annotation>
<![CDATA[      ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.birthDate)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.BirthTime' action='set' >
<annotation>
<![CDATA[         ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.communication&apos;=""'> 
<true>
<foreach property='source.communication()' key='st' >
<if condition='source.communication.(st).preferred &apos;= 1'> 
<true>
<assign value='target.OtherLanguages.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.PatientLanguage).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.communication.(st), "HS.FHIR.DTL.vR4.SDA3.Patient.communication.PatientLanguage")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.communication.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.OtherLanguages' action='set' key='index'  >
<annotation>
<![CDATA[    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</foreach>
</true>
</if>
<if condition='source.communication&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.communication()' key='k1' >
<if condition='source.communication.(k1).language&apos;=""'> 
<true>
<if condition='source.communication.(k1).preferred = 1'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Language).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.communication.(k1).language, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.communication.(k1).language, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.PrimaryLanguage' action='set'  >
<annotation>
<![CDATA[     
 --- In this case, languages is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in languages, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.contact&apos;=""'> 
<true>
<foreach property='source.contact()' key='st' >
<assign value='target.SupportContacts.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.SupportContact).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.contact.(st), "HS.FHIR.DTL.vR4.SDA3.Patient.contact.SupportContact")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.contact.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.SupportContacts' action='set' key='index'  >
<annotation>
<![CDATA[    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
</true>
</if>
<assign value='$select(source.deceasedBoolean="true":1,source.deceasedBoolean="false":0, 1:source.deceasedBoolean)' property='target.IsDead' action='set' >
<annotation>
<![CDATA[ 0 (false) or 1 (true) ]]>
</annotation>
</assign>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.deceasedDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.DeathTime' action='set' >
<annotation>
<![CDATA[      ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.extension&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.extension()' key='k1' >
<if condition='source.extension&apos;=""'> 
<true>
<if condition='source.extension.(k1).url = "http://hl7.org/fhir/StructureDefinition/patient-religion"'> 
<true>
<if condition='source.extension.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.Religion).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.extension.(k1), "HS.FHIR.DTL.vR4.SDA3.Extension.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.extension.(k1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Religion' action='set'  >
<annotation>
<![CDATA[     
 --- FHIR4 Patient:extension is a *List*, and SDA3 HS.SDA3.Patient:Religion is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.extension&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.extension()' key='k1' >
<if condition='source.extension&apos;=""'> 
<true>
<if condition='source.extension.(k1).url = "http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName"'> 
<true>
<if condition='source.extension.Count()>0'> 
<true> 
<assign value='target.MothersMaidenName' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.extension.(k1), "HS.FHIR.DTL.SubXFrm.vR4.SDA3.Extension.String")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.extension.(k1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.MothersMaidenName' action='set'  >
<annotation>
<![CDATA[     
 --- SDA3 HS.SDA3.Patient:MothersMaidenName is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- FHIR4 Patient:extension is a *List*, and SDA3 HS.SDA3.Patient:MothersMaidenName is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.extension&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.extension()' key='k1' >
<if condition='source.extension&apos;=""'> 
<true>
<if condition='source.extension.(k1).url = "http://hl7.org/fhir/StructureDefinition/patient-citizenship"'> 
<true>
<if condition='source.extension.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.Citizenship).%New()' property='value' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Patient).Citizenship(source.extension.GetAt(k1), .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Citizenship' action='set' >
<annotation>
<![CDATA[     
 --- FHIR4 Patient:extension is a *List*, and SDA3 HS.SDA3.Patient:Citizenship is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.gender&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","administrative-gender|4.0.1","HS.SDA3.CodeTableDetail.Gender",source.gender)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Gender.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.gender&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","administrative-gender|4.0.1","HS.SDA3.CodeTableDetail.Gender",source.gender) = ""'> 
<true>
<if condition='source.gender&apos;=""'> 
<true> 
<assign value='source.gender' property='target.Gender.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.generalPractitioner&apos;=""'> 
<true>
<if condition='source.generalPractitioner.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.FamilyDoctor).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.generalPractitioner.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FamilyDoctor' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR4 Patient:generalPractitioner is a *List*, and SDA3 HS.SDA3.Patient:FamilyDoctor is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.identifier&apos;=""'> 
<true>
<foreach property='source.identifier()' key='st' >
<assign value='target.PatientNumbers.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.PatientNumber).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.identifier.(st), "HS.FHIR.DTL.vR4.SDA3.Identifier.PatientNumber")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.identifier.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.PatientNumbers' action='set' key='index'  /></true> 
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.managingOrganization&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Organization).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.managingOrganization, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredAt' action='set' >
<annotation>
<![CDATA[ Source System name ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.maritalStatus&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","marital-status","HS.SDA3.CodeTableDetail.MaritalStatus",source.maritalStatus) = ""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.MaritalStatus).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.maritalStatus, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.maritalStatus, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.MaritalStatus' action='set'  >
<annotation>
<![CDATA[  
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields. 
 --- In this case, marital-status is the *Required* FHIR4 ValueSet for codes, but if you need to express meanings not found in marital-status, you may formally *Extend* marital-status to add codes to it. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='source.maritalStatus&apos;=""'> 
<true>
<if condition='source.maritalStatus.coding.Count()>0'> 
<true>
<if condition='source.maritalStatus.coding.(1).code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","marital-status","HS.SDA3.CodeTableDetail.MaritalStatus",source.maritalStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.MaritalStatus.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.multipleBirthInteger&apos;=""'> 
<true> 
<assign value='source.multipleBirthInteger' property='target.BirthOrder' action='set' >
<annotation>
<![CDATA[      ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.name&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.name()' key='k1' >
<if condition='source.name&apos;=""'> 
<true>
<if condition='(source.name.Count() = 1) || (source.name.(k1).use = "official")'> 
<true>
<if condition='source.name.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.Name).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.name.(k1), "HS.FHIR.DTL.vR4.SDA3.HumanName.Name")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.name.(k1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Name' action='set'  >
<annotation>
<![CDATA[  
 --- FHIR4 Patient:name is a *List*, and SDA3 HS.SDA3.Patient:Name is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.name&apos;=""'> 
<true>
<foreach property='source.name()' key='st' >
<if condition='(source.name.Count() > 1) &amp;&amp; (source.name.(st).use &apos;= "official")'> 
<true>
<assign value='target.Aliases.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Name).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.name.(st), "HS.FHIR.DTL.vR4.SDA3.HumanName.Name")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.name.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Aliases' action='set' key='index'  >
<annotation>
<![CDATA[   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</foreach>
</true>
</if>
<if condition='source.telecom&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.ContactInfo).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.telecom, "HS.FHIR.DTL.SubXFrm.vR4.SDA3.ContactPoint.ContactInfo")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.telecom, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ContactInfo' action='set'  >
<annotation>
<![CDATA[   
 --- FHIR4 Patient:telecom is a *List*, and SDA3 HS.SDA3.Patient:ContactInfo is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}

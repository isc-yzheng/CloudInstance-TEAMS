/// Transforms vSTU3 Patient:contact to SDA3 HS.SDA3.SupportContact
Class HS.FHIR.DTL.vSTU3.SDA3.Patient.contact.SupportContact Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Element.Patient.contact, HS.SDA3.SupportContact), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Element.Patient.contact' targetClass='HS.SDA3.SupportContact' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Patient:contact (vSTU3) to HS.SDA3.SupportContact (SDA3) ]]>
  </annotation>
<if condition='source.address&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.Address).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.address, "HS.FHIR.DTL.vSTU3.SDA3.Address.Address")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.address, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Address' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.gender&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","administrative-gender","HS.SDA3.CodeTableDetail.Gender",source.gender)' property='value' action='set' />
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
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","administrative-gender","HS.SDA3.CodeTableDetail.Gender",source.gender) = ""'> 
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
<if condition='source.name&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.Name).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.name, "HS.FHIR.DTL.vSTU3.SDA3.HumanName.Name")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.name, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Name' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.period&apos;=""'> 
<true>
<if condition='source.period.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.period.end)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.period&apos;=""'> 
<true>
<if condition='source.period.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.period.start)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.relationship&apos;=""'> 
<true>
<if condition='source.relationship.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","v2-0131","HS.SDA3.CodeTableDetail.ContactType",source.relationship.GetAt(1))' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ContactType.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- FHIR STU3 Patient:contact[n].relationship is a *List*, and SDA3 HS.SDA3.SupportContact:ContactType.Code is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.relationship&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","v2-0131","HS.SDA3.CodeTableDetail.ContactType",source.relationship) = ""'> 
<true>
<if condition='source.relationship.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.ContactType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.relationship.(1), "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.relationship.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ContactType' action='set'  >
<annotation>
<![CDATA[ specific relationship role (e.g. employer, emergency contact)
 --- FHIR STU3 Patient:contact[n].relationship is a *List*, and SDA3 HS.SDA3.SupportContact:ContactType is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields. 
 --- In this case, v2-0131 is the *Required* FHIR3 ValueSet for codes, but if you need to express meanings not found in v2-0131, you may formally *Extend* v2-0131 to add codes to it. 
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
</true>
</if>
<if condition='source.telecom&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.ContactInfo).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.telecom, "HS.FHIR.DTL.SubXFrm.vSTU3.SDA3.ContactPoint.ContactInfo")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.telecom, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ContactInfo' action='set'  >
<annotation>
<![CDATA[  
 --- FHIR STU3 Patient:contact[n].telecom is a *List*, and SDA3 HS.SDA3.SupportContact:ContactInfo is *Single*. 
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

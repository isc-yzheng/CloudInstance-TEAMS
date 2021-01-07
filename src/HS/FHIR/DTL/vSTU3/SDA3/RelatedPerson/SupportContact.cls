/// Transforms vSTU3 RelatedPerson to SDA3 HS.SDA3.SupportContact
Class HS.FHIR.DTL.vSTU3.SDA3.RelatedPerson.SupportContact Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.RelatedPerson, HS.SDA3.SupportContact), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.RelatedPerson' targetClass='HS.SDA3.SupportContact' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms RelatedPerson (vSTU3) to HS.SDA3.SupportContact (SDA3) ]]>
  </annotation>
<if condition='source.address&apos;=""'> 
<true>
<if condition='source.address.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.Address).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.address.(1), "HS.FHIR.DTL.vSTU3.SDA3.Address.Address")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.address.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Address' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 RelatedPerson:address is a *List*, and SDA3 HS.SDA3.SupportContact:Address is *Single*. 
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
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.birthDate)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.BirthTime' action='set' /></true> 
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
<if condition='source.name.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.Name).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.name.(1), "HS.FHIR.DTL.vSTU3.SDA3.HumanName.Name")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.name.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Name' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 RelatedPerson:name is a *List*, and SDA3 HS.SDA3.SupportContact:Name is *Single*. 
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
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","v2-0131","HS.SDA3.CodeTableDetail.ContactType",source.relationship)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ContactType.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.relationship&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","v2-0131","HS.SDA3.CodeTableDetail.ContactType",source.relationship) = ""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.ContactType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.relationship, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.relationship, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ContactType' action='set'  >
<annotation>
<![CDATA[ specific relationship role (e.g. employer, emergency contact)
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields. 
 --- In this case, relatedperson-relationshiptype is the Preferred FHIR3 ValueSet for codes, but if you need to express meanings not found in relatedperson-relationshiptype, you may use codes from any ValueSet. 
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
 --- FHIR STU3 RelatedPerson:telecom is a *List*, and SDA3 HS.SDA3.SupportContact:ContactInfo is *Single*. 
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

/// Transforms vR4 RelatedPerson to SDA3 HS.SDA3.Guarantor
Class HS.FHIR.DTL.vR4.SDA3.RelatedPerson.Guarantor Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.RelatedPerson, HS.SDA3.Guarantor), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.RelatedPerson' targetClass='HS.SDA3.Guarantor' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms RelatedPerson (vR4) to HS.SDA3.Guarantor (SDA3) ]]>
  </annotation>
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
<if condition='source.relationship&apos;=""'> 
<true>
<if condition='source.relationship.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","v2-0131","HS.SDA3.CodeTableDetail.ContactType",source.relationship.GetAt(1))' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.GuarantorType' action='set' >
<annotation>
<![CDATA[ Employer, Self, Family, Friend, etc.
Note: The lookup method gets the code from inside the relationship object. If it finds a matching SDA code it stores it in the target string field.
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- FHIR4 RelatedPerson:relationship is a *List*, and SDA3 HS.SDA3.Guarantor:GuarantorType is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.relationship&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","v2-0131","HS.SDA3.CodeTableDetail.ContactType",source.relationship) = ""'> 
<true>
<if condition='source.relationship.Count()>0'> 
<true> 
<assign value='##class(%String).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.relationship.(1), "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.relationship.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.GuarantorType' action='set'  >
<annotation>
<![CDATA[ Employer, Self, Family, Friend, etc.
Note: The lookup method gets the code from inside the relationship object. If it finds a matching SDA code it stores it in the target string field.
 --- FHIR4 RelatedPerson:relationship is a *List*, and SDA3 HS.SDA3.Guarantor:GuarantorType is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
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
</transform>
}

}

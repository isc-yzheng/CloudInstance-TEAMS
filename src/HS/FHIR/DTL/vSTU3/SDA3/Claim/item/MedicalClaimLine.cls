/// Transforms vSTU3 Claim:item to SDA3 HS.SDA3.MedicalClaimLine
Class HS.FHIR.DTL.vSTU3.SDA3.Claim.item.MedicalClaimLine Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Element.Claim.item, HS.SDA3.MedicalClaimLine), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Element.Claim.item' targetClass='HS.SDA3.MedicalClaimLine' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Claim:item (vSTU3) to HS.SDA3.MedicalClaimLine (SDA3) ]]>
  </annotation>
<if condition='source.category&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.ClaimLineType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.category, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.category, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ClaimLineType' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; benefit-subcategory shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.encounter&apos;=""'> 
<true>
<if condition='source.encounter.Count()>0'> 
<true> 
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.encounter.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.MedicalClaimLine:EncounterNumber is type %String with a maximum string length of *220*. 
 --- FHIR STU3 Claim:item[n].encounter is a *List*, and SDA3 HS.SDA3.MedicalClaimLine:EncounterNumber is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.net&apos;=""'> 
<true>
<if condition='source.net.value&apos;=""'> 
<true>
<if condition='source.net.value&apos;=""'> 
<true> 
<assign value='source.net.value' property='target.ChargedAmount' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
</transform>
}

}

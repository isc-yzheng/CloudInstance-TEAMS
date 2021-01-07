/// Transforms vR4 MedicationAdministration to SDA3 HS.SDA3.Administration
Class HS.FHIR.DTL.vR4.SDA3.MedicationAdministration.Administration Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.MedicationAdministration, HS.SDA3.Administration), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.MedicationAdministration' targetClass='HS.SDA3.Administration' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms MedicationAdministration (vR4) to HS.SDA3.Administration (SDA3) ]]>
  </annotation>
<if condition='source.dosage&apos;=""'> 
<true>
<if condition='source.dosage.site&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.AdministrationSite).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.dosage.site, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.dosage.site, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.AdministrationSite' action='set'  >
<annotation>
<![CDATA[ Location a vaccine was administered (e.g. Left Arm)
 --- In this case, any FHIR4 code may be used; approach-site-codes shows Example codes, but you may use codes from any ValueSet. 
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
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectiveDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectiveDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.effectivePeriod&apos;=""'> 
<true>
<if condition='source.effectivePeriod.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectivePeriod.end)' property='value' action='set' />
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
<if condition='source.effectivePeriod&apos;=""'> 
<true>
<if condition='source.effectivePeriod.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectivePeriod.start)' property='value' action='set' />
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
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.AdministrationNotes' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.performer&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.performer()' key='k1' >
<if condition='source.performer.(k1).actor&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.performer.(k1).actor, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.AdministeringProvider' action='set' >
<annotation>
<![CDATA[ Care provider who did the administration ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.status&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","medication-admin-status|4.0.1","HS.SDA3.CodeTableDetail.AdministrationStatus",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.AdministrationStatus.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.status&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","medication-admin-status|4.0.1","HS.SDA3.CodeTableDetail.AdministrationStatus",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.AdministrationStatus.Code' action='set' >
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
</transform>
}

}

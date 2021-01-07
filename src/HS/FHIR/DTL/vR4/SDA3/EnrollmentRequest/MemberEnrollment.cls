/// Transforms vR4 EnrollmentRequest to SDA3 HS.SDA3.MemberEnrollment
Class HS.FHIR.DTL.vR4.SDA3.EnrollmentRequest.MemberEnrollment Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.EnrollmentRequest, HS.SDA3.MemberEnrollment), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.EnrollmentRequest' targetClass='HS.SDA3.MemberEnrollment' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms EnrollmentRequest (vR4) to HS.SDA3.MemberEnrollment (SDA3) ]]>
  </annotation>
<if condition='source.coverage&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.HealthFund).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.coverage, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.HealthFund' action='set' /></true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.created)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.provider&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.provider, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.PrimaryCareProvider' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.provider&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.HealthCareFacility).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.provider, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.PrimaryCareFacility' action='set' /></true> 
</if> 
</true>
</if>
</transform>
}

}

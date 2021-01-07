/// Transforms vR4 Procedure to SDA3 HS.SDA3.Procedure
Class HS.FHIR.DTL.vR4.SDA3.Procedure.Procedure Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Procedure, HS.SDA3.Procedure), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Procedure' targetClass='HS.SDA3.Procedure' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Procedure (vR4) to HS.SDA3.Procedure (SDA3) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Procedure).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Procedure' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; procedure-code shows Example codes, but you may use codes from any ValueSet. 
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
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.encounter, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.Procedure:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.performedDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ProcedureTime' action='set' /></true> 
</if> 
<if condition='source.performedPeriod&apos;=""'> 
<true>
<if condition='source.performedPeriod.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.performedPeriod.end)' property='value' action='set' />
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
<if condition='source.performedPeriod&apos;=""'> 
<true>
<if condition='source.performedPeriod.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.performedPeriod.start)' property='value' action='set' />
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
<assign value='value' property='target.Clinician' action='set' /></true> 
</if> 
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.usedReference&apos;=""'> 
<true>
<foreach property='source.usedReference()' key='st' >
<assign value='##class(HS.SDA3.Device).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.usedReference.GetAt(st), .value, .aux)' property='value' action='set' />
<assign value='target.Devices.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Devices' action='set' key='index'  /></true> 
</if> </foreach>
</true>
</if>
</transform>
}

}

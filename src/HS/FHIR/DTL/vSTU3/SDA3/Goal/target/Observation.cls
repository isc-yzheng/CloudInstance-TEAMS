/// Transforms vSTU3 Goal:target to SDA3 HS.SDA3.Observation
Class HS.FHIR.DTL.vSTU3.SDA3.Goal.target.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Element.Goal.target, HS.SDA3.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Element.Goal.target' targetClass='HS.SDA3.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Goal:target (vSTU3) to HS.SDA3.Observation (SDA3) ]]>
  </annotation>
<if condition='source.detailCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.ObservationValueCode).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.detailCodeableConcept, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.detailCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationCodedValue' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.detailQuantity&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.UoM).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.detailQuantity, "HS.FHIR.DTL.vSTU3.SDA3.Quantity.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.detailQuantity, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationCode.ObservationValueUnits' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.detailQuantity&apos;=""'> 
<true>
<if condition='source.detailQuantity.value&apos;=""'> 
<true>
<if condition='source.detailQuantity.value&apos;=""'> 
<true> 
<assign value='source.detailQuantity.value' property='target.ObservationValue' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR STU3 Goal:target.detailQuantity.value is type decimal; this is not a good match for SDA3 HS.SDA3.Observation:ObservationValue, which is type %String. 
 --- SDA3 HS.SDA3.Observation:ObservationValue is type %String with a maximum string length of *999*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.measure&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Observation).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.measure, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.measure, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationCode' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 Goal:target.measure is optional, and SDA3 HS.SDA3.Observation:ObservationCode is required. No source value is mapped unconditionally to the target and *No Default Value* is supplied in case of no data received. This can be a serious gap. 
 --- This case might be fine, if there exists another mapping to the same target with a non-empty Condition to Set This Field. For example, two mappings could be defined to the same target, each with a Condition to Set This Field, in order to specify mutually exclusive cases.    ]]>
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

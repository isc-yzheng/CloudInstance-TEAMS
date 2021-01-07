/// Transforms SDA3 HS.SDA3.CodeTableDetail.Observation to vR4 Extension
Class HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Observation.Extension Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableDetail.Observation, HS.FHIR.DTL.vR4.Model.Base.Extension), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableDetail.Observation' targetClass='HS.FHIR.DTL.vR4.Model.Base.Extension' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.CodeTableDetail.Observation (SDA3) to Extension (vR4) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Observation.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueCodeableConcept' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.Observation.Extension")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.Observation.Extension") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.Observation.Extension).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.Observation.Extension") ]]></code>
</true>
</if>
</transform>
}

}

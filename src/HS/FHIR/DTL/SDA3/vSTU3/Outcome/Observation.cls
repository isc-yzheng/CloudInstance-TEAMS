/// Transforms SDA3 HS.SDA3.Outcome to vSTU3 Observation
Class HS.FHIR.DTL.SDA3.vSTU3.Outcome.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Outcome, HS.FHIR.DTL.vSTU3.Model.Resource.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Outcome' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Outcome (SDA3) to Observation (vSTU3) ]]>
  </annotation>
<if condition='source.Description&apos;=""'> 
<true> 
<assign value='source.Description' property='target.comment' action='set' >
<annotation>
<![CDATA[ Comments about result ]]>
</annotation>
</assign></true> 
</if> 

<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Observation")'> 
<true>
<assign value='target' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Observation, "HS.FHIR.DTL.SDA3.vSTU3.Observation.Observation")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Observation, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ Measurements and simple assertions made about a patient, device or other subject. ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Outcome.Observation")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Outcome.Observation") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Outcome.Observation).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Outcome.Observation") ]]></code>
</true>
</if>
</transform>
}

}

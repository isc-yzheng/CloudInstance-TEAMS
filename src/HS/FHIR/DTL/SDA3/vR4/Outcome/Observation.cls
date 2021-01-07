/// Transforms SDA3 HS.SDA3.Outcome to vR4 Observation
Class HS.FHIR.DTL.SDA3.vR4.Outcome.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Outcome, HS.FHIR.DTL.vR4.Model.Resource.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Outcome' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Outcome (SDA3) to Observation (vR4) ]]>
  </annotation>
<if condition='source.Description&apos;=""'> 
<true>
<assign value='target.note.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Description, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Annotation")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Description, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.note' action='set' key='index'  >
<annotation>
<![CDATA[ Comments about the observation ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Observation")'> 
<true>
<assign value='target' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Observation, "HS.FHIR.DTL.SDA3.vR4.Observation.Observation")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Observation, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ Measurements and simple assertions ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Outcome.Observation")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Outcome.Observation") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Outcome.Observation).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Outcome.Observation") ]]></code>
</true>
</if>
</transform>
}

}

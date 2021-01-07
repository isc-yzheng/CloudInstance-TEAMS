/// Transforms SDA3 HS.SDA3.ObservationGroup to vR4 Observation
Class HS.FHIR.DTL.SDA3.vR4.ObservationGroup.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.ObservationGroup, HS.FHIR.DTL.vR4.Model.Resource.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.ObservationGroup' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.ObservationGroup (SDA3) to Observation (vR4) ]]>
  </annotation>
<assign value='"unknown"' property='target.status' action='set' >
<annotation>
<![CDATA[ registered | preliminary | final | amended + ]]>
</annotation>
</assign>
<assign value='"vital-signs"' property='target.category.(1).coding.(1).code' action='set' >
<annotation>
<![CDATA[ Classification of  type of observation
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='"Vital Signs"' property='target.category.(1).coding.(1).display' action='set' >
<annotation>
<![CDATA[ Representation defined by the system
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='"Vital Signs"' property='target.category.(1).text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='"http://terminology.hl7.org/CodeSystem/observation-category"' property='target.category.(1).coding.(1).system' action='set' >
<annotation>
<![CDATA[ Identity of the terminology system
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='aux("transformer").GetPatientReference()' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.subject' action='set' >
<annotation>
<![CDATA[ Who and/or what the observation is about ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ExternalId).Identifier(source.ExternalId)' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ Business Identifier for observation ]]>
</annotation>
</assign></true> 
</if> 
<assign value='aux("transformer").GetReference("Encounter",source.EncounterNumber)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.encounter' action='set' >
<annotation>
<![CDATA[ Healthcare event during which this observation is made ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "ObservationGroupCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ObservationGroupCode, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Observation.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ObservationGroupCode, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.code' action='set'  >
<annotation>
<![CDATA[ Type of observation (code / type) ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<foreach property='source.Observations()' key='st' >
<assign value='target.component.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Element.Observation.component).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Observations.(st), "HS.FHIR.DTL.SDA3.vR4.Observation.Observation.component")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Observations.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.component' action='set' key='index'  >
<annotation>
<![CDATA[ Component results ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
<if condition='source.Observations&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.Observations()' key='k1' >
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Observations.(k1), "Clinician")'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Observations.(k1), "Clinician")'> 
<true>
<assign value='target.performer.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Resource.Practitioner).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Observations.(k1).Clinician, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.CareProvider.Practitioner")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Observations.(k1).Clinician, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.Observations.(k1).Clinician, tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.performer' action='set' key='index'  >
<annotation>
<![CDATA[ Who is responsible for the observation ]]>
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
</foreach>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ObservationTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.effectiveDateTime' action='set' >
<annotation>
<![CDATA[ Clinically relevant time/time-period for observation ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ObservationGroup.Observation")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ObservationGroup.Observation") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ObservationGroup.Observation).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ObservationGroup.Observation") ]]></code>
</true>
</if>
</transform>
}

}

/// Transforms vSTU3 Condition to SDA3 HS.SDA3.HealthConcern
Class HS.FHIR.DTL.vSTU3.SDA3.Condition.HealthConcern Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Condition, HS.SDA3.HealthConcern), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Condition' targetClass='HS.SDA3.HealthConcern' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Condition (vSTU3) to HS.SDA3.HealthConcern (SDA3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.abatementDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.asserter&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.DocumentProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.asserter, .value, .aux)' property='value' action='set' />
<assign value='target.Authors.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Authors' action='set' key='index'  >
<annotation>
<![CDATA[ Who is expressing this concern. May be Patient, Practitioner, Related Person or Organization. ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.clinicalStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","condition-clinical","HS.SDA3.CodeTableDetail.HealthConcernStatus",source.clinicalStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.clinicalStatus&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","condition-clinical","HS.SDA3.CodeTableDetail.HealthConcernStatus",source.clinicalStatus) = ""'> 
<true>
<if condition='source.clinicalStatus&apos;=""'> 
<true> 
<assign value='source.clinicalStatus' property='target.Status.Code' action='set' >
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
<if condition='source.code&apos;=""'> 
<true>
<if condition='source.code.text&apos;=""'> 
<true>
<if condition='source.code.text&apos;=""'> 
<true> 
<assign value='source.code.text' property='target.Description' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.context, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.HealthConcern:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<assign value='aux("transformer").GetIdentifier("Condition", source.id)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ExternalId' action='set' >
<annotation>
<![CDATA[ Identifier used by systems outside HealthShare.
 --- SDA3 HS.SDA3.HealthConcern:ExternalId is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.Description' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.onsetDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
</transform>
}

}

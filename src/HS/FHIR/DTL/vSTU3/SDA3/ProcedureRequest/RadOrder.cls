/// Transforms vSTU3 ProcedureRequest to SDA3 HS.SDA3.RadOrder
Class HS.FHIR.DTL.vSTU3.SDA3.ProcedureRequest.RadOrder Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.ProcedureRequest, HS.SDA3.RadOrder), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.ProcedureRequest' targetClass='HS.SDA3.RadOrder' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms ProcedureRequest (vSTU3) to HS.SDA3.RadOrder (SDA3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.authoredOn)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Order).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.OrderItem' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; procedure-code shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
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
 --- SDA3 HS.SDA3.RadOrder:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.identifier&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.identifier()' key='k1' >
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "FILL")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.FillerId' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "PLAC")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.PlacerId' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.RadOrder:PlacerId is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.TextInstruction' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.priority&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","request-priority","HS.SDA3.CodeTableDetail.Priority",source.priority)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Priority.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.priority&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","request-priority","HS.SDA3.CodeTableDetail.Priority",source.priority) = ""'> 
<true>
<if condition='source.priority&apos;=""'> 
<true> 
<assign value='source.priority' property='target.Priority.Code' action='set' >
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
<if condition='source.requester&apos;=""'> 
<true>
<if condition='source.requester.agent&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.requester.agent, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.OrderedBy' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.requester&apos;=""'> 
<true>
<if condition='source.requester.onBehalfOf&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.HealthCareFacility).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.requester.onBehalfOf, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteringOrganization' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.specimen&apos;=""'> 
<true>
<foreach property='source.specimen()' key='st' >
<assign value='##class(HS.SDA3.Specimen).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.specimen.GetAt(st), .value, .aux)' property='value' action='set' />
<assign value='target.Specimens.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Specimens' action='set' key='index'  /></true> 
</if> </foreach>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","request-status","HS.SDA3.RadOrder:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","request-status","HS.SDA3.RadOrder:Status",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</transform>
}

}

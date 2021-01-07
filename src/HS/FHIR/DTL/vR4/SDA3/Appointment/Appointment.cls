/// Transforms vR4 Appointment to SDA3 HS.SDA3.Appointment
Class HS.FHIR.DTL.vR4.SDA3.Appointment.Appointment Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Appointment, HS.SDA3.Appointment), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Appointment' targetClass='HS.SDA3.Appointment' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Appointment (vR4) to HS.SDA3.Appointment (SDA3) ]]>
  </annotation>
<if condition='source.status = "noshow"'> 
<true>
<assign value='"1"' property='target.NoShow' action='set' />
</true>
</if>
<if condition='source.appointmentType&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.AppointmentType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.appointmentType, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.appointmentType, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Type' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, v2-0276 is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in v2-0276, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.comment&apos;=""'> 
<true> 
<assign value='source.comment' property='target.Notes' action='set' /></true> 
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
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.end)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.identifier&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.identifier()' key='k1' >
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "PLAC")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.PlacerApptId' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Appointment:PlacerApptId is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "FILL")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.FillerApptId' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Appointment:FillerApptId is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
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
<if condition='source.participant&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.participant()' key='k1' >
<if condition='source.participant.(k1).actor&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.participant.(k1).actor, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.CareProvider' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.participant.(k1).actor&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.HealthCareFacility).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.participant.(k1).actor, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Location' action='set' /></true> 
</if> 
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.serviceType&apos;=""'> 
<true>
<if condition='source.serviceType.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.Order).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.serviceType.(1), "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.serviceType.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.OrderItem' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR4 Appointment:serviceType is a *List*, and SDA3 HS.SDA3.Appointment:OrderItem is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- In this case, any FHIR4 code may be used; service-type shows Example codes, but you may use codes from any ValueSet. 
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
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.start)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","appointmentstatus|4.0.1","HS.SDA3.Appointment:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.Appointment:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","appointmentstatus|4.0.1","HS.SDA3.Appointment:Status",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Appointment:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</transform>
}

}

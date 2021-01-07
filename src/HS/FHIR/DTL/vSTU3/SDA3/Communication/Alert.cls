/// Transforms vSTU3 Communication to SDA3 HS.SDA3.Alert
Class HS.FHIR.DTL.vSTU3.SDA3.Communication.Alert Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Communication, HS.SDA3.Alert), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Communication' targetClass='HS.SDA3.Alert' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Communication (vSTU3) to HS.SDA3.Alert (SDA3) ]]>
  </annotation>
<if condition='source.category&apos;=""'> 
<true>
<if condition='source.category.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.AlertType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.category.(1), "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.category.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.AlertType' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 Communication:category is a *List*, and SDA3 HS.SDA3.Alert:AlertType is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- In this case, any FHIR3 code may be used; communication-category shows Example codes, but you may use codes from any ValueSet. 
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
<if condition='source.context&apos;=""'> 
<true>
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.context, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.Alert:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.Comments' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.payload.Count()>0'> 
<true>
<if condition='source.payload.(1).contentAttachment&apos;=""'> 
<true>
<if condition='source.payload.(1).contentAttachment.data&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).Base64Decode(source.payload.(1).contentAttachment.data)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Alert.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.payload.Count()>0'> 
<true>
<if condition='source.payload.(1).contentString&apos;=""'> 
<true>
<if condition='source.payload.(1).contentString&apos;=""'> 
<true> 
<assign value='source.payload.(1).contentString' property='target.Alert.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","event-status","HS.SDA3.Alert:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ Alert status. Possible values are "A" for "Active", "I" for "Inactive", and "C" for "To Be Confirmed".
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.Alert:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","event-status","HS.SDA3.Alert:Status",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.Status' action='set' >
<annotation>
<![CDATA[ Alert status. Possible values are "A" for "Active", "I" for "Inactive", and "C" for "To Be Confirmed".
 --- SDA3 HS.SDA3.Alert:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</transform>
}

}

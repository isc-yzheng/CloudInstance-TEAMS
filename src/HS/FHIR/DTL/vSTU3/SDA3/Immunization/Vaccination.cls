/// Transforms vSTU3 Immunization to SDA3 HS.SDA3.Vaccination
Class HS.FHIR.DTL.vSTU3.SDA3.Immunization.Vaccination Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Immunization, HS.SDA3.Vaccination), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Immunization' targetClass='HS.SDA3.Vaccination' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Immunization (vSTU3) to HS.SDA3.Vaccination (SDA3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.date)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.doseQuantity&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.UoM).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.doseQuantity, "HS.FHIR.DTL.vSTU3.SDA3.Quantity.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.doseQuantity, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.DoseUoM' action='set'  >
<annotation>
<![CDATA[ Units for DoseQuantity (e.g. the mg in 20mg) ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.doseQuantity&apos;=""'> 
<true>
<if condition='source.doseQuantity.value&apos;=""'> 
<true>
<if condition='source.doseQuantity.value&apos;=""'> 
<true> 
<assign value='source.doseQuantity.value' property='target.DoseQuantity' action='set' >
<annotation>
<![CDATA[ Size of dose (e.g. the 20 in 20mg). ]]>
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
 --- SDA3 HS.SDA3.Vaccination:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.explanation&apos;=""'> 
<true>
<if condition='source.explanation.reasonNotGiven&apos;=""'> 
<true>
<if condition='source.explanation.reasonNotGiven.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.RefusalReason).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.explanation.reasonNotGiven.(1), "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.explanation.reasonNotGiven.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Administrations.(1).RefusalReason' action='set'  >
<annotation>
<![CDATA[ Substance/Treatment Refusal Reason
 --- FHIR STU3 Immunization:explanation.reasonNotGiven is a *List*, and SDA3 HS.SDA3.Vaccination:Administrations[n].RefusalReason is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- In this case, any FHIR3 code may be used; no-immunization-reason shows Example codes, but you may use codes from any ValueSet. 
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
</true>
</if>
<if condition='source.explanation&apos;=""'> 
<true>
<if condition='source.explanation.reason.Count()>0'> 
<true>
<if condition='source.explanation.reason.(1).text&apos;=""'> 
<true>
<if condition='source.explanation.reason.(1).text&apos;=""'> 
<true> 
<assign value='source.explanation.reason.(1).text' property='target.Indication' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Vaccination:Indication is type %String with a maximum string length of *512*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</true>
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
<assign value='source.identifier.(k1).value' property='target.PlacerId' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Vaccination:PlacerId is type %String with a maximum string length of *220*.    ]]>
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
<assign value='source.identifier.(k1).value' property='target.FillerId' action='set' /></true> 
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
<assign value='source.note.(1).text' property='target.Comments' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.practitioner&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.practitioner()' key='k1' >
<if condition='source.practitioner.(k1).actor&apos;=""'> 
<true>
<if condition='(source.practitioner.(k1).role &apos;= "") &amp;&amp; (source.practitioner.(k1).role.coding.Count() > 0) &amp;&amp; (source.practitioner.(k1).role.coding.GetAt(1).code = "OP")'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.practitioner.(k1).actor, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.OrderedBy' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.practitioner.(k1).actor&apos;=""'> 
<true>
<if condition='(source.practitioner.(k1).role &apos;= "") &amp;&amp; (source.practitioner.(k1).role.coding.Count() > 0) &amp;&amp; (source.practitioner.(k1).role.coding.GetAt(1).code = "AP")'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.practitioner.(k1).actor, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Administrations.(j1).AdministeringProvider' action='set' >
<annotation>
<![CDATA[ Care provider who did the administration ]]>
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
<if condition='source.route&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Route).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.route, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.route, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Route' action='set'  >
<annotation>
<![CDATA[ Instructions for administering drug (e.g. Oral)
 --- In this case, any FHIR3 code may be used; immunization-route shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","immunization-status","HS.SDA3.Vaccination:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","immunization-status","HS.SDA3.Vaccination:Status",source.status) = ""'> 
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
<if condition='source.vaccineCode&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Order).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.vaccineCode, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.vaccineCode, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.OrderItem' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; vaccine-code shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
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

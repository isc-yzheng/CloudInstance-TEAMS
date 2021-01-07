/// Transforms vR4 MedicationStatement to SDA3 HS.SDA3.Medication
Class HS.FHIR.DTL.vR4.SDA3.MedicationStatement.Medication Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.MedicationStatement, HS.SDA3.Medication), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.MedicationStatement' targetClass='HS.SDA3.Medication' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms MedicationStatement (vR4) to HS.SDA3.Medication (SDA3) ]]>
  </annotation>
<if condition='source.context&apos;=""'> 
<true>
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.context, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.Medication:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.dosage&apos;=""'> 
<true>
<foreach property='source.dosage()' key='st' >
<assign value='target.DosageSteps.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.DosageStep).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.dosage.(st), "HS.FHIR.DTL.vR4.SDA3.Dosage.DosageStep")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.dosage.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.DosageSteps' action='set' key='index'  /></true> 
</if>
</true>
</if>
</foreach>
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
 --- SDA3 HS.SDA3.Medication:PlacerId is type %String with a maximum string length of *220*.    ]]>
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
<if condition='source.medicationReference&apos;=""'> 
<true>
<assign value='target' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.medicationReference, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target' action='set' /></true> 
</if> 
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
<if condition='source.partOf&apos;=""'> 
<true>
<foreach property='source.partOf()' key='st' >
<assign value='##class(HS.SDA3.Administration).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.partOf.GetAt(st), .value, .aux)' property='value' action='set' />
<assign value='target.Administrations.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Administrations' action='set' key='index'  /></true> 
</if> </foreach>
</true>
</if>
<if condition='source.reasonCode.Count()>0'> 
<true>
<if condition='source.reasonCode.(1).text&apos;=""'> 
<true>
<if condition='source.reasonCode.(1).text&apos;=""'> 
<true> 
<assign value='source.reasonCode.(1).text' property='target.Indication' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Medication:Indication is type %String with a maximum string length of *512*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","medication-statement-status|4.0.1","HS.SDA3.Medication:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","medication-statement-status|4.0.1","HS.SDA3.Medication:Status",source.status) = ""'> 
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

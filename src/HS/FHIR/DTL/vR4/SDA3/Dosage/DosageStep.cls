/// Transforms vR4 Dosage to SDA3 HS.SDA3.DosageStep
Class HS.FHIR.DTL.vR4.SDA3.Dosage.DosageStep Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Element.Dosage, HS.SDA3.DosageStep), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Element.Dosage' targetClass='HS.SDA3.DosageStep' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Dosage (vR4) to HS.SDA3.DosageStep (SDA3) ]]>
  </annotation>
<if condition='source.doseAndRate.Count()>0'> 
<true>
<if condition='source.doseAndRate.(1).doseQuantity&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.UoM).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.doseAndRate.(1).doseQuantity, "HS.FHIR.DTL.vR4.SDA3.Quantity.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.doseAndRate.(1).doseQuantity, .tmp, .aux)' property='status' action='set' />
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
</true>
</if>
<if condition='source.doseAndRate.Count()>0'> 
<true>
<if condition='source.doseAndRate.(1).doseQuantity&apos;=""'> 
<true>
<if condition='source.doseAndRate.(1).doseQuantity.value&apos;=""'> 
<true>
<if condition='source.doseAndRate.(1).doseQuantity.value&apos;=""'> 
<true> 
<assign value='source.doseAndRate.(1).doseQuantity.value' property='target.DoseQuantity' action='set' >
<annotation>
<![CDATA[ Size of dose (e.g. the 20 in 20mg) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.patientInstruction&apos;=""'> 
<true> 
<assign value='source.patientInstruction' property='target.TextInstruction' action='set' >
<annotation>
<![CDATA[ Text instructions/directions ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.text&apos;=""'> 
<true> 
<assign value='source.text' property='target.TextInstruction' action='set' >
<annotation>
<![CDATA[ Text instructions/directions ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.timing&apos;=""'> 
<true>
<if condition='source.timing.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Frequency).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.timing.code, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.timing.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Frequency' action='set'  >
<annotation>
<![CDATA[ How often (e.g. Code=QID, Desc=QID, Factor=4) QID is Latin, meaning 4x a day. BID means 2x day, etc. ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
</transform>
}

}

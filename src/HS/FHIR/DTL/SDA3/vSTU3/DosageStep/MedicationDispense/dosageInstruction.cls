/// Transforms SDA3 HS.SDA3.DosageStep to vSTU3 MedicationDispense:dosageInstruction
Class HS.FHIR.DTL.SDA3.vSTU3.DosageStep.MedicationDispense.dosageInstruction Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.DosageStep, HS.FHIR.DTL.vSTU3.Model.Element.Dosage), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.DosageStep' targetClass='HS.FHIR.DTL.vSTU3.Model.Element.Dosage' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.DosageStep (SDA3) to MedicationDispense:dosageInstruction (vSTU3) ]]>
  </annotation>
<if condition='&apos;##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Frequency") || (source.Frequency.Code &apos;= "PRN")'> 
<true>
<assign value='"0"' property='target.asNeededBoolean' action='set' >
<annotation>
<![CDATA[ Take "as needed" (true or false, or for the reason given). ]]>
</annotation>
</assign>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Frequency") &amp;&amp; (source.Frequency.Code = "PRN")'> 
<true>
<assign value='"1"' property='target.asNeededBoolean' action='set' >
<annotation>
<![CDATA[ Take "as needed" (true or false, or for the reason given). ]]>
</annotation>
</assign>
</true>
</if>
<if condition='source.DoseQuantity&apos;=""'> 
<true>
<if condition='source.DoseQuantity&apos;=""'> 
<true> 
<assign value='source.DoseQuantity' property='target.doseQuantity.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.DoseUoM.Code&apos;=""'> 
<true>
<if condition='source.DoseUoM.Code&apos;=""'> 
<true> 
<assign value='source.DoseUoM.Code' property='target.doseQuantity.code' action='set' >
<annotation>
<![CDATA[ Coded form of the unit ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.DoseUoM.SDACodingStandard) = ""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForValueSet("vSTU3", "http://unitsofmeasure.org", source.DoseUoM.Code)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.doseQuantity.system' action='set' >
<annotation>
<![CDATA[ System that defines coded unit form ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"http://www.intersystems.com/fhir/system"' property='target.doseQuantity.system' action='set' />
</false> 
</if> 
</true>
</if>
<if condition='source.DoseUoM.Description&apos;=""'> 
<true>
<if condition='source.DoseUoM.Description&apos;=""'> 
<true> 
<assign value='source.DoseUoM.Description' property='target.doseQuantity.unit' action='set' >
<annotation>
<![CDATA[ Unit representation ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.DoseUoM.SDACodingStandard&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.DoseUoM.SDACodingStandard)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.doseQuantity.system' action='set' >
<annotation>
<![CDATA[ System that defines coded unit form ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.DoseUoM.SDACodingStandard&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.DoseUoM.SDACodingStandard) = ""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.doseQuantity&apos;=""'> 
<true> 
<assign value='target.doseQuantity.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DoseUoM.SDACodingStandard, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.StrippedString.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DoseUoM.SDACodingStandard, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/dosage-step-dose-uo-m-s-d-a-coding-standard"' property='tmp.url' action='set' />
<assign value='tmp' property='target.doseQuantity.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Frequency")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.Dosage).Frequency(source.Frequency)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.timing' action='set' >
<annotation>
<![CDATA[ When medication should be administered ]]>
</annotation>
</assign></true> 
</if> </true> 
</if>
<if condition='source.TextInstruction&apos;=""'> 
<true> 
<assign value='source.TextInstruction' property='target.text' action='set' >
<annotation>
<![CDATA[ Free text dosage instructions e.g. SIG ]]>
</annotation>
</assign></true> 
</if> 

<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DosageStep.MedicationDispense.dosageInstruction")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DosageStep.MedicationDispense.dosageInstruction") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DosageStep.MedicationDispense.dosageInstruction).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DosageStep.MedicationDispense.dosageInstruction") ]]></code>
</true>
</if>
</transform>
}

}

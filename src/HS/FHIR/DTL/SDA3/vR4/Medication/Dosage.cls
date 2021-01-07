/// Transforms SDA3 HS.SDA3.Medication to vR4 Dosage
Class HS.FHIR.DTL.SDA3.vR4.Medication.Dosage Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Medication, HS.FHIR.DTL.vR4.Model.Element.Dosage), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Medication' targetClass='HS.FHIR.DTL.vR4.Model.Element.Dosage' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Medication (SDA3) to Dosage (vR4) ]]>
  </annotation>
<if condition='&apos;##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Frequency") || (source.Frequency.Code &apos;= "PRN")'> 
<true>
<assign value='"0"' property='target.asNeededBoolean' action='set' >
<annotation>
<![CDATA[ Take \"as needed\" (for x) ]]>
</annotation>
</assign>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Frequency") &amp;&amp; (source.Frequency.Code = "PRN")'> 
<true>
<assign value='"1"' property='target.asNeededBoolean' action='set' >
<annotation>
<![CDATA[ Take \"as needed\" (for x) ]]>
</annotation>
</assign>
</true>
</if>
<if condition='source.DoseQuantity&apos;=""'> 
<true>
<if condition='source.DoseQuantity&apos;=""'> 
<true> 
<assign value='source.DoseQuantity' property='target.doseAndRate.(1).doseQuantity.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.DoseQuantity = ""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DoseUoM")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.Quantity).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DoseUoM, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.Quantity")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DoseUoM, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.doseAndRate.(1).doseQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication per dose ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='source.DoseQuantity &apos;= ""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DoseUoM")'> 
<true>
<assign value='target.doseAndRate.(1).doseQuantity' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DoseUoM, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.Quantity")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DoseUoM, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.doseAndRate.(1).doseQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication per dose ]]>
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
<if condition='source.RateAmount&apos;=""'> 
<true>
<if condition='source.RateAmount&apos;=""'> 
<true> 
<assign value='source.RateAmount' property='target.doseAndRate.(1).rateQuantity.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.RateTimeUnit&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.doseAndRate&apos;="") &amp;&amp; (target.doseAndRate.Count() &gt; 0)'> 
<true> 
<if condition='target.doseAndRate.(1).rateQuantity&apos;=""'> 
<true> 
<assign value='target.doseAndRate.(1).rateQuantity.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.RateTimeUnit, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.RateTimeUnit, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/medication-rate-time-unit"' property='tmp.url' action='set' />
<assign value='tmp' property='target.doseAndRate.(1).rateQuantity.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='(source.RateAmount = "") &amp;&amp; (source.RateTimeUnit = "")'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "RateUnits")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.Quantity).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.RateUnits, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.Quantity")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.RateUnits, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.doseAndRate.(1).rateQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication per unit of time ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='(source.RateAmount &apos;= "") || (source.RateTimeUnit &apos;= "")'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "RateUnits")'> 
<true>
<assign value='target.doseAndRate.(1).rateQuantity' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.RateUnits, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.Quantity")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.RateUnits, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.doseAndRate.(1).rateQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication per unit of time ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='source.TextInstruction&apos;=""'> 
<true> 
<assign value='source.TextInstruction' property='target.text' action='set' >
<annotation>
<![CDATA[ Free text dosage instructions e.g. SIG ]]>
</annotation>
</assign></true> 
</if> 

<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Dosage")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Dosage") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Dosage).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Dosage") ]]></code>
</true>
</if>
</transform>
}

}

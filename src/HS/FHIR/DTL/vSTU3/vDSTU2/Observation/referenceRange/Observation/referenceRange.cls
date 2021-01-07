/// Transforms vSTU3 Observation:referenceRange to vDSTU2 Observation:referenceRange
Class HS.FHIR.DTL.vSTU3.vDSTU2.Observation.referenceRange.Observation.referenceRange Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Element.Observation.referenceRange, HS.FHIR.DTL.vDSTU2.Model.Element.Observation.referenceRange), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Element.Observation.referenceRange' targetClass='HS.FHIR.DTL.vDSTU2.Model.Element.Observation.referenceRange' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Observation:referenceRange (vSTU3) to Observation:referenceRange (vDSTU2) ]]>
  </annotation>
<if condition='source.age&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.age' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.age' action='set'  >
<annotation>
<![CDATA[ Applicable age range, if relevant ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.high&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.high' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.high' action='set'  >
<annotation>
<![CDATA[ High Range, if relevant ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.low&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.low' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.low' action='set'  >
<annotation>
<![CDATA[ Low Range, if relevant ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.text&apos;=""'> 
<true> 
<assign value='source.text' property='target.text' action='set' >
<annotation>
<![CDATA[ Text based reference range in an observation ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

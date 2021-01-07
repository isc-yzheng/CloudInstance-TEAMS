/// Transforms vR4 CarePlan to SDA3 HS.SDA3.Intervention
Class HS.FHIR.DTL.vR4.SDA3.CarePlan.Intervention Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.CarePlan, HS.SDA3.Intervention), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.CarePlan' targetClass='HS.SDA3.Intervention' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CarePlan (vR4) to HS.SDA3.Intervention (SDA3) ]]>
  </annotation>
<if condition='source.activity.Count()>0'> 
<true>
<if condition='source.activity.(1).detail&apos;=""'> 
<true>
<if condition='source.activity.(1).detail.description&apos;=""'> 
<true>
<if condition='source.activity.(1).detail.description&apos;=""'> 
<true> 
<assign value='source.activity.(1).detail.description' property='target.Description' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Intervention:Description is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
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

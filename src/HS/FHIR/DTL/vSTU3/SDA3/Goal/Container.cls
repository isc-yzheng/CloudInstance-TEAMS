/// Transforms vSTU3 Goal to SDA3 HS.SDA3.Container
Class HS.FHIR.DTL.vSTU3.SDA3.Goal.Container Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Goal, HS.SDA3.Container), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Goal' targetClass='HS.SDA3.Container' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Goal (vSTU3) to HS.SDA3.Container (SDA3) ]]>
  </annotation>
<if condition='&apos;aux("isContained")'> 
<true>
<assign value='$get(aux("sourceResource"))' property='prevSourceResource' action='set' />
<assign value='source' property='aux("sourceResource")' action='set' />
</true>
</if>
<if condition='source.addresses&apos;=""'> 
<true>
<foreach property='source.addresses()' key='st' >
<assign value='##class(HS.SDA3.HealthConcern).%New()' property='value' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Reference).Transform(source.addresses.GetAt(st), aux("sourceResource"), "HS.SDA3.HealthConcern", .value, .aux)' property='value' action='set' />
<assign value='target.HealthConcerns.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.HealthConcerns' action='set' key='index'  >
<annotation>
<![CDATA[ List of health concerns for this patient ]]>
</annotation>
</assign></true> 
</if> </foreach>
</true>
</if>
<if condition='&apos;aux("isContained")'> 
<true>
<assign value='prevSourceResource' property='aux("sourceResource")' action='set' />
</true> 
</if>
</transform>
}

}

/// Transforms vSTU3 CareTeam to SDA3 HS.SDA3.CarePlan
Class HS.FHIR.DTL.vSTU3.SDA3.CareTeam.CarePlan Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.CareTeam, HS.SDA3.CarePlan), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.CareTeam' targetClass='HS.SDA3.CarePlan' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CareTeam (vSTU3) to HS.SDA3.CarePlan (SDA3) ]]>
  </annotation>
<if condition='source.participant&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.participant()' key='k1' >
<if condition='source.participant.(k1).member&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.DocumentProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.participant.(k1).member, .value, .aux)' property='value' action='set' />
<assign value='target.Providers.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Providers' action='set' key='index'  /></true> 
</if> 
</true>
</if>
<if condition='source.participant.(k1).member&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.DocumentOrganization).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.participant.(k1).member, .value, .aux)' property='value' action='set' />
<assign value='target.Organizations.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Organizations' action='set' key='index'  /></true> 
</if> 
</true>
</if>
<if condition='source.participant.(k1).member&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.SupportContact).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.participant.(k1).member, .value, .aux)' property='value' action='set' />
<assign value='target.SupportContacts.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.SupportContacts' action='set' key='index'  /></true> 
</if> 
</true>
</if>
</foreach>
</true>
</if>
</transform>
}

}

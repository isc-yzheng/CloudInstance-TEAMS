/// Transforms SDA3 HS.SDA3.CarePlan to vSTU3 CareTeam
Class HS.FHIR.DTL.SDA3.vSTU3.CarePlan.CareTeam Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CarePlan, HS.FHIR.DTL.vSTU3.Model.Resource.CareTeam), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CarePlan' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.CareTeam' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.CarePlan (SDA3) to CareTeam (vSTU3) ]]>
  </annotation>
<assign value='aux("transformer").GetPatientReference()' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.subject' action='set' >
<annotation>
<![CDATA[ Who care team is for ]]>
</annotation>
</assign></true> 
</if> 
<foreach property='source.Organizations()' key='st' >
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CareTeam).Participant(source.Organizations.GetAt(st), .target, .aux)' property='value' action='set' />
<assign value='target.participant.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.participant' action='set' key='index'  >
<annotation>
<![CDATA[ Members of the team ]]>
</annotation>
</assign></true> 
</if> </foreach>
<foreach property='source.Providers()' key='st' >
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CareTeam).Participant(source.Providers.GetAt(st), .target, .aux)' property='value' action='set' />
<assign value='target.participant.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.participant' action='set' key='index'  >
<annotation>
<![CDATA[ Members of the team ]]>
</annotation>
</assign></true> 
</if> </foreach>
<foreach property='source.SupportContacts()' key='st' >
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CareTeam).Participant(source.SupportContacts.GetAt(st), .target, .aux)' property='value' action='set' />
<assign value='target.participant.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.participant' action='set' key='index'  >
<annotation>
<![CDATA[ Members of the team ]]>
</annotation>
</assign></true> 
</if> </foreach>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CarePlan.CareTeam")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CarePlan.CareTeam") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CarePlan.CareTeam).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CarePlan.CareTeam") ]]></code>
</true>
</if>
</transform>
}

}

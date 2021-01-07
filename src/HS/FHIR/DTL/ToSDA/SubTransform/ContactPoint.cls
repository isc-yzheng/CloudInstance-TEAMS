Class HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Base.ContactPoint, HS.SDA3.ContactInfo) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Base.ContactPoint' targetClass='HS.SDA3.ContactInfo' create='existing' language='objectscript' >
<if condition='((source.system.value = "phone") || (source.system.value = "")) &amp;&amp; ((source.use.value = "home") || (source.use.value = ""))' >
<true>
<assign value='source.value.value' property='target.HomePhoneNumber' action='set' />
</true>
<false>
<if condition='((source.system.value = "phone") || (source.system.value = "")) &amp;&amp; (source.use.value = "work")' >
<true>
<assign value='source.value.value' property='target.WorkPhoneNumber' action='set' />
</true>
<false>
<if condition='((source.system.value = "phone") || (source.system.value = "")) &amp;&amp; (source.use.value = "mobile") ' >
<true>
<assign value='source.value.value' property='target.MobilePhoneNumber' action='set' />
</true>
<false>
<if condition='(source.system.value = "email")' >
<true>
<assign value='source.value.value' property='target.EmailAddress' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</transform>
}

}

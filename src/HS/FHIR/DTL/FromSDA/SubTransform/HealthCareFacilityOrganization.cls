Class HS.FHIR.DTL.FromSDA.SubTransform.HealthCareFacilityOrganization Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableDetail.HealthCareFacility, HS.FHIR.vDSTU2.Model.Resource.Organization) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableDetail.HealthCareFacility' targetClass='HS.FHIR.vDSTU2.Model.Resource.Organization' create='new' language='objectscript' >
<assign value='source.Organization.InternalReference' property='target.id.value' action='set' />
<assign value='source.LocationType' property='target.type.text.value' action='set' />
<assign value='1' property='target.active.value' action='set' />
<if condition='(source.Description &apos;= "") &amp;&amp; (source.Code &apos;= "")' >
<true>
<assign value='source.Code' property='target.name.id' action='set' />
<assign value='"official"' property='target.identifier.(1).use.value' action='set' />
<assign value='source.Code' property='target.identifier.(1).value.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURLForCode(source.SDACodingStandard)' property='target.identifier.(1).system.value' action='set' />
</true>
</if>
<assign value='source.Description' property='target.name.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Address' targetObj='target.address.(1)' sourceObj='source.Organization.Address' />
<if condition='source.Organization.MedicalDirector &apos;= ""' >
<true>
<assign value='"Medical Director"' property='target.contact.(1).purpose.text.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Address' targetObj='target.contact.(1).address' sourceObj='source.Organization.MedicalDirector.Address' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Name' targetObj='target.contact.(1).name' sourceObj='source.Organization.MedicalDirector.Name' />
<code>
<![CDATA[ set iTelecomMedical = 1]]></code>
<if condition='source.Organization.MedicalDirector.ContactInfo.HomePhoneNumber  &apos;= ""' >
<true>
<assign value='source.Organization.MedicalDirector.ContactInfo.HomePhoneNumber' property='target.contact.(1).telecom.(iTelecomMedical).value.value' action='set' />
<assign value='"phone"' property='target.contact.(1).telecom.(iTelecomMedical).system.value' action='set' />
<assign value='"home"' property='target.contact.(1).telecom.(iTelecomMedical).use.value' action='set' />
<code>
<![CDATA[ set iTelecomMedical = iTelecomMedical + 1]]></code>
</true>
</if>
<if condition='source.Organization.MedicalDirector.ContactInfo.WorkPhoneNumber &apos;= ""' >
<true>
<assign value='source.Organization.MedicalDirector.ContactInfo.WorkPhoneNumber' property='target.contact.(1).telecom.(iTelecomMedical).value.value' action='set' />
<assign value='"phone"' property='target.contact.(1).telecom.(iTelecomMedical).system.value' action='set' />
<assign value='"work"' property='target.contact.(1).telecom.(iTelecomMedical).use.value' action='set' />
<code>
<![CDATA[ set iTelecomMedical = iTelecomMedical + 1]]></code>
</true>
</if>
<if condition='source.Organization.MedicalDirector.ContactInfo.MobilePhoneNumber &apos;= ""' >
<true>
<assign value='source.Organization.MedicalDirector.ContactInfo.MobilePhoneNumber' property='target.contact.(1).telecom.(iTelecomMedical).value.value' action='set' />
<assign value='"phone"' property='target.contact.(1).telecom.(iTelecomMedical).system.value' action='set' />
<assign value='"mobile"' property='target.contact.(1).telecom.(iTelecomMedical).use.value' action='set' />
<code>
<![CDATA[ set iTelecomMedical = iTelecomMedical + 1]]></code>
</true>
</if>
<if condition='source.Organization.MedicalDirector.ContactInfo.EmailAddress &apos;= ""' >
<true>
<assign value='source.Organization.MedicalDirector.ContactInfo.EmailAddress' property='target.contact.(1).telecom.(iTelecomMedical).value.value' action='set' />
<assign value='"email"' property='target.contact.(1).telecom.(iTelecomMedical).system.value' action='set' />
<code>
<![CDATA[ set iTelecomMedical = iTelecomMedical + 1]]></code>
</true>
</if>
</true>
</if>
<code>
<![CDATA[ set iTelecom = 1]]></code>
<if condition='source.Organization.ContactInfo.HomePhoneNumber  &apos;= ""' >
<true>
<assign value='source.Organization.ContactInfo.HomePhoneNumber' property='target.contact.(1).telecom.(iTelecom).value.value' action='set' />
<assign value='"phone"' property='target.contact.(1).telecom.(iTelecom).system.value' action='set' />
<assign value='"home"' property='target.contact.(1).telecom.(iTelecom).use.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.Organization.ContactInfo.WorkPhoneNumber &apos;= ""' >
<true>
<assign value='source.Organization.ContactInfo.WorkPhoneNumber' property='target.contact.(1).telecom.(iTelecom).value.value' action='set' />
<assign value='"phone"' property='target.contact.(1).telecom.(iTelecom).system.value' action='set' />
<assign value='"work"' property='target.contact.(1).telecom.(iTelecom).use.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.Organization.ContactInfo.MobilePhoneNumber &apos;= ""' >
<true>
<assign value='source.Organization.ContactInfo.MobilePhoneNumber' property='target.contact.(1).telecom.(iTelecom).value.value' action='set' />
<assign value='"phone"' property='target.contact.(1).telecom.(iTelecom).system.value' action='set' />
<assign value='"mobile"' property='target.contact.(1).telecom.(iTelecom).use.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.Organization.ContactInfo.EmailAddress &apos;= ""' >
<true>
<assign value='source.Organization.ContactInfo.EmailAddress' property='target.contact.(1).telecom.(iTelecom).value.value' action='set' />
<assign value='"email"' property='target.contact.(1).telecom.(iTelecom).system.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
</transform>
}

}

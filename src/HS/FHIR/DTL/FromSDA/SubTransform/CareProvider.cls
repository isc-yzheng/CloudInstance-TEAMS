Class HS.FHIR.DTL.FromSDA.SubTransform.CareProvider Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableDetail.CareProvider, HS.FHIR.vDSTU2.Model.Resource.Practitioner) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableDetail.CareProvider' targetClass='HS.FHIR.vDSTU2.Model.Resource.Practitioner' create='new' language='objectscript' >
<assign value='source.InternalReference' property='target.id.value' action='set' />
<assign value='"official"' property='target.identifier.(1).use.value' action='set' />
<assign value='source.Code' property='target.identifier.(1).value.value' action='set' />
<assign value='source.IdentifierTypeCode' property='target.identifier.(1).type.text.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURLForCode(source.SDACodingStandard)' property='target.identifier.(1).system.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Name' targetObj='target.name' sourceObj='source.Name' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Address' targetObj='target.address.(1)' sourceObj='source.Address' />
<if condition='source.CareProviderType.Description &apos;= ""' >
<true>
<assign value='source.CareProviderType.Description' property='target.practitionerRole.(1).specialty.(1).coding.(1).display.value' action='set' />
<assign value='source.CareProviderType.Description' property='target.practitionerRole.(1).specialty.(1).text.value' action='set' />
</true>
</if>
<if condition='source.CareProviderType.Code &apos;= ""' >
<true>
<assign value='source.CareProviderType.Code' property='target.practitionerRole.(1).specialty.(1).coding.(1).code.value' action='set' />
<assign value='source.CareProviderType.CodeSystemVersionId' property='target.practitionerRole.(1).specialty.(1).coding.(1).version.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURLForCode(source.CareProviderType.SDACodingStandard)' property='target.practitionerRole.(1).specialty.(1).coding.(1).system.value' action='set' />
</true>
</if>
<assign value='source.Name.DOB' property='target.birthDate.value' action='set' />
<code>
<![CDATA[ set iTelecom = 1]]></code>
<if condition='source.ContactInfo.HomePhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.telecom.(iTelecom).system.value' action='set' />
<assign value='"home"' property='target.telecom.(iTelecom).use.value' action='set' />
<assign value='source.ContactInfo.HomePhoneNumber' property='target.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.ContactInfo.WorkPhoneNumber &apos;= ""' >
<true>
<assign value='"work"' property='target.telecom.(iTelecom).use.value' action='set' />
<assign value='source.ContactInfo.WorkPhoneNumber' property='target.telecom.(iTelecom).value.value' action='set' />
<assign value='"phone"' property='target.telecom.(iTelecom).system.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.ContactInfo.MobilePhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.telecom.(iTelecom).system.value' action='set' />
<assign value='source.ContactInfo.MobilePhoneNumber' property='target.telecom.(iTelecom).value.value' action='set' />
<assign value='"mobile"' property='target.telecom.(iTelecom).use.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.ContactInfo.EmailAddress &apos;= ""' >
<true>
<assign value='"email"' property='target.telecom.(iTelecom).system.value' action='set' />
<assign value='source.ContactInfo.EmailAddress' property='target.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
</transform>
}

}

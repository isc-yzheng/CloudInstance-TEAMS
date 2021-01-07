Class HS.FHIR.DTL.ToSDA.Patient Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Patient, HS.SDA3.Patient) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Patient' targetClass='HS.SDA3.Patient' create='new' language='objectscript' >
<code>
<![CDATA[ set patientNumber = 1]]></code>
<foreach property='source.identifier()' key='k7' >
<if condition='source.identifier.(k7).value.value&apos;=""' >
<true>
<assign value='source.identifier.(k7).value.value' property='target.PatientNumbers.(patientNumber).Number' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.identifier.(k7).assigner.display.value)' property='target.PatientNumbers.(patientNumber).Organization.Code' action='set' />
<if condition='$IsObject(source.identifier.(k7).type) &amp;&amp; (source.identifier.(k7).type.coding.Count() &gt; 0)' >
<true>
<if condition='source.identifier.(k7).type.coding.(1).code.value="MR"' >
<true>
<assign value='"MRN"' property='target.PatientNumbers.(patientNumber).NumberType' action='set' />
</true>
<false>
<if condition='source.identifier.(k7).type.coding.(1).code.value&apos;=""' >
<true>
<assign value='source.identifier.(k7).type.coding.(1).code.value' property='target.PatientNumbers.(patientNumber).NumberType' action='set' />
</true>
<false>
<if condition='source.identifier.(k7).type.text.value="MR"' >
<true>
<assign value='"MRN"' property='target.PatientNumbers.(patientNumber).NumberType' action='set' />
</true>
<false>
<assign value='source.identifier.(k7).type.text.value' property='target.PatientNumbers.(patientNumber).NumberType' action='set' />
</false>
</if>
</false>
</if>
</false>
</if>
</true>
<false>
<assign value='source.identifier.(k7).type.text.value' property='target.PatientNumbers.(patientNumber).NumberType' action='set' />
</false>
</if>
<code>
<![CDATA[ set patientNumber = patientNumber + 1]]></code>
</true>
</if>
</foreach>
<code>
<![CDATA[ set i=1]]></code>
<code>
<![CDATA[ set namefound=0]]></code>
<foreach property='source.name()' key='k1' >
<if condition='(source.name.(k1).given.Count() &gt; 0) || (source.name.(k1).family.Count() &gt; 0)' >
<true>
<if condition='(source.name.(k1).use.value = "anonymous")' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Name' targetObj='target.Aliases.(i)' sourceObj='source.name.(k1)' />
<code>
<![CDATA[ set i = i+1]]></code>
</true>
<false>
<if condition='namefound = 0' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Name' targetObj='target.Name' sourceObj='source.name.(k1)' />
<code>
<![CDATA[ set namefound=1]]></code>
</true>
</if>
</false>
</if>
</true>
</if>
</foreach>
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.deceasedDateTime.value)' property='target.DeathTime' action='set' />
<assign value='source.multipleBirthInteger.value' property='target.BirthOrder' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.birthDate.value)' property='target.Name.DOB' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.birthDate.value)' property='target.BirthTime' action='set' />
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Gender' targetObj='target.Gender' sourceObj='source.gender' />
<assign value='source.deceasedBoolean.value' property='target.IsDead' action='set' />
<foreach property='source.address()' key='k2' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Address' targetObj='target.Addresses.(k2)' sourceObj='source.address.(k2)' />
</foreach>
<foreach property='source.contact()' key='k3' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Name' targetObj='target.SupportContacts.(k3).Name' sourceObj='source.contact.(k3).name' />
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Address' targetObj='target.SupportContacts.(k3).Address' sourceObj='source.contact.(k3).address' />
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Gender' targetObj='target.SupportContacts.(k3).Gender' sourceObj='source.contact.(k3).gender' />
<if condition='source.contact.(k3).relationship.Count()&gt;0' >
<true>
<assign value='source.contact.(k3).relationship.(1).text.value' property='target.SupportContacts.(k3).Relationship.OriginalText' action='set' />
<if condition='source.contact.(k3).relationship.(1).coding.Count()&gt;0' >
<true>
<assign value='source.contact.(k3).relationship.(1).coding.(1).display.value' property='target.SupportContacts.(k3).Relationship.Description' action='set' />
<assign value='source.contact.(k3).relationship.(1).coding.(1).code.value' property='target.SupportContacts.(k3).Relationship.Code' action='set' />
<assign value='source.contact.(k3).relationship.(1).coding.(1).version.value' property='target.SupportContacts.(k3).Relationship.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.contact.(k3).relationship.(1).coding.(1).system.value)' property='target.SupportContacts.(k3).Relationship.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<assign value='source.contact.(k3).period.start.value' property='target.SupportContacts.(k3).FromTime' action='set' />
<assign value='source.contact.(k3).period.end.value' property='target.SupportContacts.(k3).ToTime' action='set' />
<foreach property='source.contact.(k3).telecom()' key='k8' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint' targetObj='target.SupportContacts.(k3).ContactInfo' sourceObj='source.contact.(k3).telecom.(k8)' />
</foreach>
</foreach>
<code>
<![CDATA[ set i=1]]></code>
<foreach property='source.communication()' key='k4' >
<if condition='source.communication.(k4).preferred.value = "1"' >
<true>
<assign value='source.communication.(k4).language.text.value' property='target.PrimaryLanguage.OriginalText' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.communication.(k4).language.coding.(1).system.value)' property='target.PrimaryLanguage.SDACodingStandard' action='set' />
<assign value='source.communication.(k4).language.coding.(1).version.value' property='target.PrimaryLanguage.CodeSystemVersionId' action='set' />
<assign value='source.communication.(k4).language.coding.(1).code.value' property='target.PrimaryLanguage.Code' action='set' />
<assign value='source.communication.(k4).language.coding.(1).display.value' property='target.PrimaryLanguage.Description' action='set' />
</true>
<false>
<assign value='source.communication.(k4).language.text.value' property='target.OtherLanguages.(i).PreferredLanguage.OriginalText' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.communication.(k4).language.coding.(1).system.value)' property='target.OtherLanguages.(i).PreferredLanguage.SDACodingStandard' action='set' />
<assign value='source.communication.(k4).language.coding.(1).version.value' property='target.OtherLanguages.(i).PreferredLanguage.CodeSystemVersionId' action='set' />
<assign value='source.communication.(k4).language.coding.(1).code.value' property='target.OtherLanguages.(i).PreferredLanguage.Code' action='set' />
<assign value='source.communication.(k4).language.coding.(1).display.value' property='target.OtherLanguages.(i).PreferredLanguage.Description' action='set' />
<code>
<![CDATA[ set i = i+1]]></code>
</false>
</if>
</foreach>
<if condition='$IsObject(source.maritalStatus)' >
<true>
<assign value='source.maritalStatus.text.value' property='target.MaritalStatus.OriginalText' action='set' />
<if condition='$IsObject(source.maritalStatus.coding) &amp;&amp; (source.maritalStatus.coding.Count()&gt;0)' >
<true>
<assign value='source.maritalStatus.coding.(1).display.value' property='target.MaritalStatus.Description' action='set' />
<assign value='source.maritalStatus.coding.(1).code.value' property='target.MaritalStatus.Code' action='set' />
<assign value='source.maritalStatus.coding.(1).version.value' property='target.MaritalStatus.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.maritalStatus.coding.(1).system.value)' property='target.MaritalStatus.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<foreach property='source.telecom()' key='k5' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint' targetObj='target.ContactInfo' sourceObj='source.telecom.(k5)' />
</foreach>
<code>
<![CDATA[ set iRace = 1]]></code>
<code>
<![CDATA[ set iEthnic = 1]]></code>
<foreach property='source.extension()' key='k6' >
<if condition='source.extension.(k6).url = "http://hl7.org/fhir/StructureDefinition/us-core-religion"' >
<true>
<assign value='source.extension.(k6).valueCodeableConcept.text.value' property='target.Religion.OriginalText' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).display.value' property='target.Religion.Description' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).code.value' property='target.Religion.Code' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).version.value' property='target.Religion.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.extension.(k6).valueCodeableConcept.coding.(1).system.value)' property='target.Religion.SDACodingStandard' action='set' />
</true>
</if>
<if condition='source.extension.(k6).url = "http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName"' >
<true>
<assign value='source.extension.(k6).valueString.value' property='target.MothersMaidenName' action='set' />
</true>
</if>
<if condition='source.extension.(k6).url = "http://hl7.org/fhir/StructureDefinition/us-core-race"' >
<true>
<if condition='iRace=1' >
<true>
<assign value='source.extension.(k6).valueCodeableConcept.text.value' property='target.Race.OriginalText' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.extension.(k6).valueCodeableConcept.coding.(1).system.value)' property='target.Race.SDACodingStandard' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).version.value' property='target.Race.CodeSystemVersionId' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).code.value' property='target.Race.Code' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).display.value' property='target.Race.Description' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).code.value' property='target.Races.(iRace).Code' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).display.value' property='target.Races.(iRace).Description' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).version.value' property='target.Races.(iRace).CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.extension.(k6).valueCodeableConcept.coding.(1).system.value)' property='target.Races.(iRace).SDACodingStandard' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.text.value' property='target.Races.(iRace).OriginalText' action='set' />
<code>
<![CDATA[ set iRace=2]]></code>
</true>
<false>
<assign value='source.extension.(k6).valueCodeableConcept.text.value' property='target.Races.(iRace).OriginalText' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).display.value' property='target.Races.(iRace).Description' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).code.value' property='target.Races.(iRace).Code' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).version.value' property='target.Races.(iRace).CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.extension.(k6).valueCodeableConcept.coding.(1).system.value)' property='target.Races.(iRace).SDACodingStandard' action='set' />
<code>
<![CDATA[ set iRace=iRace+1]]></code>
</false>
</if>
</true>
</if>
<if condition='(source.extension.(k6).url = "http://hl7.org/fhir/StructureDefinition/us-core-ethnicity") &amp;&amp; (iEthnic = 1)' >
<true>
<assign value='source.extension.(k6).valueCodeableConcept.text.value' property='target.EthnicGroup.OriginalText' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.extension.(k6).valueCodeableConcept.coding.(1).system.value)' property='target.EthnicGroup.SDACodingStandard' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).version.value' property='target.EthnicGroup.CodeSystemVersionId' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).code.value' property='target.EthnicGroup.Code' action='set' />
<assign value='source.extension.(k6).valueCodeableConcept.coding.(1).display.value' property='target.EthnicGroup.Description' action='set' />
<code>
<![CDATA[ set iEthnic = 2]]></code>
</true>
</if>
</foreach>
<code>
<![CDATA[ set iProvider=1]]></code>
<foreach property='source.careProvider()' key='k10' >
<foreach property='source.contained()' key='k9' >
<if condition='(iProvider=1) &amp;&amp; ("#"_source.contained.(k9).Practitioner.id.value = source.careProvider.(k10).reference.value)' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.PractitionerFamilyDoctor' targetObj='target.FamilyDoctor' sourceObj='source.contained.(k9).Practitioner' />
<code>
<![CDATA[ set iProvider=0]]></code>
</true>
</if>
</foreach>
</foreach>
</transform>
}

}

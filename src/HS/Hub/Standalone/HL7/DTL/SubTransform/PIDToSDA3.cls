Class HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToSDA3 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Segment, HS.SDA3.Container) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='HS.SDA3.Container' sourceDocType='2.5:PID' create='new' language='objectscript' >
<assign value='""' property='tAlias' action='set' />
<assign value='1' property='tAliasIndex' action='set' />
<assign value='1' property='tPatientNumberIndex' action='set' />
<assign value='source.{PatientID.IDNumber}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Number' action='set' />
<assign value='"MRN"' property='target.Patient.PatientNumbers.(tPatientNumberIndex).NumberType' action='set' />
<assign value='aux' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Organization.Code' action='set' />
<assign value='source.{PatientID.AssigningAuthority.NamespaceID}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).ISOAssigningAuthority' action='set' />
<assign value='tPatientNumberIndex + 1' property='tPatientNumberIndex' action='set' />
<foreach property='source.{PatientIdentifierList()}' key='k1' >
<if condition='source.{PatientIdentifierList(k1).IDNumber} &apos;= ""' >
<true>
<assign value='source.{PatientIdentifierList(k1).IDNumber}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Number' action='set' />
<assign value='source.{PatientIdentifierList(k1).AssigningAuthority.NamespaceID}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Organization.Code' action='set' />
<assign value='source.{PatientIdentifierList(k1).AssigningAuthority.NamespaceID}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).ISOAssigningAuthority' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).idtype(source.{PatientIdentifierList(k1).IdentifierTypeCode})' property='target.Patient.PatientNumbers.(tPatientNumberIndex).NumberType' action='set' />
<assign value='tPatientNumberIndex + 1' property='tPatientNumberIndex' action='set' />
</true>
</if>
</foreach>
<foreach property='source.{AlternatePatientIDPID()}' key='k1' >
<if condition='source.{AlternatePatientIDPID(k1).IDNumber} = """"""' >
<true>
<assign value='aux' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Organization.Code' action='set' />
<assign value='""""""' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Number' action='set' />
<assign value='tPatientNumberIndex+1' property='tPatientNumberIndex' action='set' />
</true>
<false>
<if condition='source.{AlternatePatientIDPID(k1).IdentifierTypeCode} &apos;= ""' >
<true>
<assign value='source.{AlternatePatientIDPID(k1).IDNumber}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Number' action='set' />
<assign value='source.{AlternatePatientIDPID(k1).AssigningAuthority.NamespaceID}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Organization.Code' action='set' />
<assign value='source.{AlternatePatientIDPID(k1).AssigningAuthority.NamespaceID}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).ISOAssigningAuthority' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).idtype(source.{AlternatePatientIDPID(k1).IdentifierTypeCode})' property='target.Patient.PatientNumbers.(tPatientNumberIndex).NumberType' action='set' />
<assign value='tPatientNumberIndex + 1' property='tPatientNumberIndex' action='set' />
</true>
</if>
</false>
</if>
</foreach>
<if condition='source.{SSNNumberPatient} = ""' >
<false>
<assign value='"SSN"' property='target.Patient.PatientNumbers.(tPatientNumberIndex).NumberType' action='set' />
<assign value='source.{SSNNumberPatient}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Number' action='set' />
<assign value='tPatientNumberIndex + 1' property='tPatientNumberIndex' action='set' />
</false>
</if>
<if condition='source.{DriversLicenseNumberPatient} = ""' >
<false>
<assign value='"DL"' property='target.Patient.PatientNumbers.(tPatientNumberIndex).NumberType' action='set' />
<assign value='source.{DriversLicenseNumberPatient.LicenseNumber}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Number' action='set' />
<assign value='source.{DriversLicenseNumberPatient.IssuingStateProvinceCountry}' property='target.Patient.PatientNumbers.(tPatientNumberIndex).Organization.Code' action='set' />
<assign value='tPatientNumberIndex + 1' property='tPatientNumberIndex' action='set' />
</false>
</if>
<if condition='source.{PatientName().NameTypeCode} &apos;= "A"' >
<true>
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToNameSDA3' targetObj='target.Patient.Name' sourceObj='source' aux='"PatientName"' />
</true>
<false>
<if condition='source.{PatientName().NameTypeCode} &apos;= "U"' >
<true>
<assign value='"U"' property='target.Patient.BlankNameReason' action='set' />
</true>
<false>
<if condition='source.{PatientName().NameTypeCode} &apos;= "S"' >
<true>
<assign value='"S"' property='target.Patient.BlankNameReason' action='set' />
</true>
<false>
<if condition='source.{PatientName().NameTypeCode} = "A"' >
<true>
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToNameSDA3' targetObj='tAlias' sourceObj='source' />
<assign value='tAlias' property='target.Patient.Aliases.(tAliasIndex)' action='set' />
<assign value='tAliasIndex + 1' property='tAliasIndex' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToNameSDA3' targetObj='target.Patient.MothersFullName' sourceObj='source' aux='"MothersMaidenName"' />
<assign value='target.Patient.MothersFullName.FamilyName' property='target.Patient.MothersMaidenName' action='set' />
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToNameSDA3' targetObj='tAlias' sourceObj='source' aux='"PatientAlias"' />
<if condition='tAlias.FamilyName &apos;= ""' >
<true>
<assign value='tAlias' property='target.Patient.Aliases.(tAliasIndex)' action='set' />
<assign value='tAliasIndex + 1' property='tAliasIndex' action='set' />
</true>
</if>
<foreach property='source.{Race()}' key='k1' >
<if condition='source.{Race(k1).Identifier} &apos;= ""' >
<true>
<assign value='source.{Race(k1).NameofCodingSystem}' property='target.Patient.Races.(k1).SDACodingStandard' action='set' />
<assign value='source.{Race(k1).Identifier}' property='target.Patient.Races.(k1).Code' action='set' />
<assign value='source.{Race(k1).Text}' property='target.Patient.Races.(k1).Description' action='set' />
<assign value='""' property='target.Patient.Races.(k1).CodeSystemVersionId' action='set' />
</true>
</if>
</foreach>
<if condition='target.Patient.Races.Count() &apos;= 0' >
<true>
<assign value='target.Patient.Races.(1).SDACodingStandard' property='target.Patient.Race.SDACodingStandard' action='set' />
<assign value='target.Patient.Races.(1).Code' property='target.Patient.Race.Code' action='set' />
<assign value='target.Patient.Races.(1).Description' property='target.Patient.Race.Description' action='set' />
<assign value='""' property='target.Patient.Race.CodeSystemVersionId' action='set' />
</true>
</if>
<assign value='source.{AdministrativeSex}' property='target.Patient.Gender.Code' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{DateTimeofBirth.Time})' property='target.Patient.BirthTime' action='set' />
<foreach property='source.{PatientAddress()}' key='k1' >
<assign value='source.{PatientAddress(k1).StreetAddress.StreetorMailingAddress}' property='target.Patient.Addresses.(k1).Street' action='set' />
<assign value='source.{PatientAddress(k1).City}' property='target.Patient.Addresses.(k1).City.Code' action='set' />
<assign value='source.{PatientAddress(k1).StateorProvince}' property='target.Patient.Addresses.(k1).State.Code' action='set' />
<assign value='source.{PatientAddress(k1).ZiporPostalCode}' property='target.Patient.Addresses.(k1).Zip.Code' action='set' />
<assign value='source.{PatientAddress(k1).Country}' property='target.Patient.Addresses.(k1).Country.Code' action='set' />
<assign value='source.{PatientAddress(k1).CountyParishCode}' property='target.Patient.Addresses.(k1).County.Code' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{PatientAddress(k1).EffectiveDate.Time})' property='target.Patient.Addresses.(k1).FromTime' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{PatientAddress(k1).ExpirationDate.Time})' property='target.Patient.Addresses.(k1).ToTime' action='set' />
</foreach>
<assign value='source.{PhoneNumberHome().TelephoneNumber}' property='target.Patient.ContactInfo.HomePhoneNumber' action='set' />
<assign value='source.{PhoneNumberBusiness().TelephoneNumber}' property='target.Patient.ContactInfo.WorkPhoneNumber' action='set' />
<if condition='source.{PhoneNumberHome().EmailAddress} &apos;= ""' >
<true>
<assign value='source.{PhoneNumberHome().EmailAddress}' property='target.Patient.ContactInfo.EmailAddress' action='set' />
</true>
<false>
<assign value='source.{PhoneNumberBusiness().EmailAddress}' property='target.Patient.ContactInfo.EmailAddress' action='set' />
</false>
</if>
<assign value='source.{PrimaryLanguage.NameofCodingSystem}' property='target.Patient.PrimaryLanguage.SDACodingStandard' action='set' />
<assign value='source.{PrimaryLanguage.Identifier}' property='target.Patient.PrimaryLanguage.Code' action='set' />
<assign value='source.{PrimaryLanguage.Text}' property='target.Patient.PrimaryLanguage.Description' action='set' />
<assign value='source.{MaritalStatus.NameofCodingSystem}' property='target.Patient.MaritalStatus.SDACodingStandard' action='set' />
<assign value='source.{MaritalStatus.Identifier}' property='target.Patient.MaritalStatus.Code' action='set' />
<assign value='source.{MaritalStatus.Text}' property='target.Patient.MaritalStatus.Description' action='set' />
<assign value='source.{Religion.NameofCodingSystem}' property='target.Patient.Religion.SDACodingStandard' action='set' />
<assign value='source.{Religion.Identifier}' property='target.Patient.Religion.Code' action='set' />
<assign value='source.{Religion.Text}' property='target.Patient.Religion.Description' action='set' />
<assign value='source.{EthnicGroup().NameofCodingSystem}' property='target.Patient.EthnicGroup.SDACodingStandard' action='set' />
<assign value='source.{EthnicGroup().Identifier}' property='target.Patient.EthnicGroup.Code' action='set' />
<assign value='source.{EthnicGroup().Text}' property='target.Patient.EthnicGroup.Description' action='set' />
<assign value='""' property='target.Patient.EthnicGroup.CodeSystemVersionId' action='set' />
<if condition='$ZCVT($E(source.{MultipleBirthIndicator},1),"U")="N"' >
<true>
<assign value='"0"' property='target.Patient.BirthOrder' action='set' />
</true>
<false>
<assign value='source.{BirthOrder}' property='target.Patient.BirthOrder' action='set' />
</false>
</if>
<assign value='source.{Citizenship().NameofCodingSystem}' property='target.Patient.Citizenship.SDACodingStandard' action='set' />
<assign value='source.{Citizenship().Identifier}' property='target.Patient.Citizenship.Code' action='set' />
<assign value='source.{Citizenship().Text}' property='target.Patient.Citizenship.Description' action='set' />
<if condition='source.{Citizenship().Identifier} = ""' >
<true>
<assign value='source.{Nationality.NameofCodingSystem}' property='target.Patient.Citizenship.SDACodingStandard' action='set' />
<assign value='source.{Nationality.Identifier}' property='target.Patient.Citizenship.Code' action='set' />
<assign value='source.{Nationality.Text}' property='target.Patient.Citizenship.Description' action='set' />
</true>
</if>
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{PatientDeathDateandTime.Time})' property='target.Patient.DeathTime' action='set' />
<assign value='$CASE(source.{PatientDeathIndicator}, "Y":1, "N":0, $C(34,34):$C(34,34), :"")' property='tIsDead' action='set' />
<if condition='tIsDead &apos;= ""' >
<true>
<assign value='tIsDead' property='target.Patient.IsDead' action='set' />
</true>
</if>
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{LastUpdateDateTime.Time})' property='target.Patient.EnteredOn' action='set' />
<if condition='source.{LastUpdateFacility.NamespaceID} &apos;= ""' >
<true>
<assign value='source.{LastUpdateFacility.NamespaceID}' property='target.Patient.EnteredAt.Code' action='set' />
</true>
<false>
<assign value='aux' property='target.Patient.EnteredAt.Code' action='set' />
</false>
</if>
</transform>
}

}

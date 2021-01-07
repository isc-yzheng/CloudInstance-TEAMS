Class HS.Hub.Standalone.HL7.DTL.SubTransform.PD1ToSDA3 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Segment, HS.SDA3.Container) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='HS.SDA3.Container' sourceDocType='2.5:PD1' create='existing' language='objectscript' >
<assign value='source.{PatientPrimaryCareProviderNa().AssigningAuthority.NamespaceID}' property='target.Patient.FamilyDoctor.SDACodingStandard' action='set' />
<assign value='source.{PatientPrimaryCareProviderNa().IDNumber}' property='target.Patient.FamilyDoctor.Code' action='set' />
<assign value='source.{PatientPrimaryCareProviderNa().FamilyName.Surname}' property='tLast' action='set' />
<assign value='source.{PatientPrimaryCareProviderNa().GivenName}' property='tFirst' action='set' />
<assign value='source.{PatientPrimaryCareProviderNa().SecondandFurtherGivenNamesor}' property='tMiddle' action='set' />
<assign value='source.{PatientPrimaryCareProviderNa().Prefix}' property='tPrefix' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).formatname(tLast,tFirst,tMiddle,tPrefix)' property='tName' action='set' />
<assign value='tName' property='target.Patient.FamilyDoctor.Description' action='set' />
<assign value='tLast' property='target.Patient.FamilyDoctor.Name.FamilyName' action='set' />
<assign value='tFirst' property='target.Patient.FamilyDoctor.Name.GivenName' action='set' />
<assign value='tMiddle' property='target.Patient.FamilyDoctor.Name.MiddleName' action='set' />
<assign value='tPrefix' property='target.Patient.FamilyDoctor.Name.NamePrefix' action='set' />
<assign value='source.{PatientPrimaryCareProviderNa().Degree}' property='target.Patient.FamilyDoctor.Name.NameSuffix' action='set' />
<assign value='source.{PublicityCode.NameofCodingSystem}' property='target.Patient.PublicityCode.SDACodingStandard' action='set' />
<assign value='source.{PublicityCode.Identifier}' property='target.Patient.PublicityCode.Code' action='set' />
<assign value='source.{PublicityCode.Text}' property='target.Patient.PublicityCode.Description' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{PublicityCodeEffectiveDate})' property='target.Patient.PublicityEffectiveDate' action='set' />
<assign value='source.{ImmunizationRegistryStatus}' property='target.Patient.ImmunizationRegistryStatus' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{ImmunizationRegistryStatusEf})' property='target.Patient.ImmunizationRegistryStatusEffectiveDate' action='set' />
<assign value='source.{ProtectionIndicator}' property='tIsProtected' action='set' />
<assign value='$CASE(tIsProtected, "Y":1, "N":0, $C(34,34):$C(34,34), :"")' property='target.Patient.IsProtected' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).timestamp(source.{ProtectionIndicatorEffective})' property='target.Patient.ProtectedEffectiveDate' action='set' />
</transform>
}

}

Class HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToNameSDA3 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Segment, HS.SDA3.Name) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='HS.SDA3.Name' sourceDocType='2.5:PID' create='new' language='objectscript' >
<assign value='source.GetValueAt(aux_".Prefix")' property='target.NamePrefix' action='set' />
<assign value='source.GetValueAt(aux_".GivenName")' property='target.GivenName' action='set' />
<assign value='source.GetValueAt(aux_".FamilyName.Surname")' property='target.FamilyName' action='set' />
<assign value='source.GetValueAt(aux_".SecondandFurtherGivenNamesor")' property='target.MiddleName' action='set' />
<assign value='source.GetValueAt(aux_".FamilyName.SurnamePrefixFromPartnerSpou")' property='target.FamilyNamePrefix' action='set' />
<assign value='source.GetValueAt(aux_".Suffix")' property='target.NameSuffix' action='set' />
<assign value='source.GetValueAt(aux_".ProfessionalSuffix")' property='target.ProfessionalSuffix' action='set' />
</transform>
}

}

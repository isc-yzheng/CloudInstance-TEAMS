Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.VaccinationToRXA Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Vaccination, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Vaccination' targetDocType='2.5:RXA' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 1 2 3
 #;
]]></code>
<assign value='"0"' property='target.{1}' action='set' />
<assign value='"1"' property='target.{2}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDate(source.{/Vaccination/Administrations/[1]/FromTime})' property='target.{3.1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 5
 #;
]]></code>
<assign value='source.{/Vaccination/DrugProduct/Code}' property='target.{5.1}' action='set' />
<assign value='source.{/Vaccination/DrugProduct/Description}' property='target.{5.2}' action='set' />
<assign value='source.{/Vaccination/DrugProduct/SDACodingStandard}' property='target.{5.3}' action='set' />
<assign value='source.{/Vaccination/Administrations/[1]/AdministeredAmount}' property='target.{6}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 7
 #;
]]></code>
<if condition='+$Length(source.{/Vaccination/Administrations/[1]/AdministeredUnits})' >
<true>
<assign value='..Lookup("UCUMDescriptionToCode",source.{/Vaccination/Administrations/[1]/AdministeredUnits})' property='target.{7.1}' action='set' />
<assign value='source.{/Vaccination/Administrations/[1]/AdministeredUnits}' property='target.{7.2}' action='set' />
<assign value='"UCUM"' property='target.{7.3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 9
 #;
]]></code>
<if condition='+$Length(source.{/Vaccination/Administrations/[1]/AdministrationNotes})' >
<true>
<assign value='..Lookup("AdministrationNotesToIdentifier",source.{/Vaccination/Administrations/[1]/AdministrationNotes})' property='target.{9(1).1}' action='set' />
<assign value='source.{/Vaccination/Administrations/[1]/AdministrationNotes}' property='target.{9(1).2}' action='set' />
<assign value='"NIP001"' property='target.{9(1).3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 10
 #;<assign value='$ZStrip(source.{/Vaccination/Administrations/[1]/AdministeringProvider/Name/FamilyNamePrefix},"*P")' property='target.{10(1).2.2}' action='set' />
]]></code>
<assign value='source.{/Vaccination/Administrations/[1]/AdministeringProvider/Code}' property='target.{10(1).1}' action='set' />
<if condition='$Length($ZStrip(source.{/Vaccination/Administrations/[1]/AdministeringProvider/Name/FamilyName},"*P"))' >
<true>
<assign value='$ZStrip(source.{/Vaccination/Administrations/[1]/AdministeringProvider/Name/FamilyName},"*P")' property='target.{10(1).2.1}' action='set' />
<assign value='$ZStrip(source.{/Vaccination/Administrations/[1]/AdministeringProvider/Name/GivenName},"*P")' property='target.{10(1).3}' action='set' />
<assign value='$ZStrip(source.{/Vaccination/Administrations/[1]/AdministeringProvider/Name/MiddleName},"*P")' property='target.{10(1).4}' action='set' />
<assign value='$ZStrip(source.{/Vaccination/Administrations/[1]/AdministeringProvider/Name/NameSuffix},"*P")' property='target.{10(1).5}' action='set' />
<assign value='$ZStrip(source.{/Vaccination/Administrations/[1]/AdministeringProvider/Name/NamePrefix},"*P")' property='target.{10(1).6}' action='set' />
<assign value='source.{/Vaccination/Administrations/[1]/AdministeringProvider/SDACodingStandard}' property='target.{10(1).9.1}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/Vaccination/Administrations/[1]/AdministeredAtLocation/Code})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Vaccination/Administrations/[1]/AdministeredAtLocation/Code}' property='target.{11.4.1}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 15 16
 #;
]]></code>
<assign value='source.{/Vaccination/Administrations/[1]/LotNumber}' property='target.{15(1)}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDate(source.{/Vaccination/Administrations/[1]/ExpiryDate})' property='target.{16(1).1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 17
 #;
]]></code>
<if condition='$Length(source.{/Vaccination/Administrations/[1]/ManufacturerName})' >
<true>
<assign value='..Lookup("ManufacturerNameToCode",source.{/Vaccination/Administrations/[1]/ManufacturerName})' property='target.{17(1).1}' action='set' />
<assign value='source.{/Vaccination/Administrations/[1]/ManufacturerName}' property='target.{17(1).2}' action='set' />
<assign value='"MVX"' property='target.{17(1).3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 18 - Refusal Reason
 #;
]]></code>
<if condition='+$Length(source.{/Vaccination/Administrations/[1]/RefusalReason/Code})||+$Length(source.{/Vaccination/Administrations/[1]/RefusalReason/Description})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Vaccination/Administrations/[1]/RefusalReason/Code}' property='target.{18(1).1}' action='set' />
<assign value='source.{/Vaccination/Administrations/[1]/RefusalReason/SDACodingStandard}' property='target.{18(1).3}' action='set' />
<assign value='source.{/Vaccination/Administrations/[1]/RefusalReason/Description}' property='target.{18(1).2}' action='set' />
</true>
</if>

<code>
<![CDATA[ 
 #;
 #; 20 21 - Assign based assigned 9(1).1 or 18(1).1 or 5(1).1
 #;
 #; TODO Messy, find better way
]]></code>
<if condition='target.{9(1).1}="00"' >
<true>
<assign value='"CP"' property='target.{20}' action='set' />
<assign value='"A"' property='target.{21}' action='set' />
</true>
<false>
<if condition='target.{18(1).1}="00"'>
<true>
<assign value='"RE"' property='target.{20}' action='set' />
</true>
<false>
<if condition='target.{5(1).1}="998"'>
<true>
<assign value='"NA"' property='target.{20}' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}

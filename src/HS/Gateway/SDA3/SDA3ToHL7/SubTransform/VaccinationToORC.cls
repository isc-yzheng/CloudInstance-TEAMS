Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.VaccinationToORC Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Vaccination, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Vaccination' targetDocType='2.5:ORC' create='new' language='objectscript' >
<code>
<![CDATA[ 
 /*
 Revision History:
   2013-04-16 Paul Hula: Created
 Documentation: 

 */
]]></code>
<code>
<![CDATA[ 
 #;
 #; 1 3
 #;
]]></code>
<assign value='"RE"' property='target.{1}' action='set' />
<assign value='source.{/Vaccination/FillerId}' property='target.{3.1}' action='set' />
<if condition='target.{3.1}="9999"'>
<true>
<assign value='"CDC"' property='target.{3.2}' action='set' />
</true>
<false>
<assign value='"NDA"' property='target.{3.2}' action='set' />
</false>
</if>
<code>
<![CDATA[ 
 #;
 #; 10
 #;
]]></code>
<assign value='source.{/Vaccination/EnteredBy/Code}' property='target.{10(1).1}' action='set' />
<if condition='$Length(source.{/Vaccination/EnteredBy/Description})'>
<true>
<if condition='$Length($Piece(source.{/Vaccination/EnteredBy/Description},","))'>
<true>
<assign value='$Piece(source.{/Vaccination/EnteredBy/Description},",")' property='target.{10(1).2.1}' action='set' />
</true>
</if>
<if condition='$Length($ZStrip($Piece(source.{/Vaccination/EnteredBy/Description},",",2),$Char(60,62)_"W"))'>
<true>
<assign value='$ZStrip($Piece(source.{/Vaccination/EnteredBy/Description},",",2),$Char(60,62)_"W")' property='target.{10(1).3}' action='set' />
</true>
</if>
<assign value='"A"' property='target.{10(1).4}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/Vaccination/EnteredBy/SDACodingStandard})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Vaccination/EnteredBy/SDACodingStandard}' property='target.{10(1).9.1}' action='set' />
</true>
</if>

<code>
<![CDATA[ 
 #;
 #; 12
 #;
]]></code>
<if condition='+$Length(source.{/Vaccination/OrderedBy/Code})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Vaccination/OrderedBy/Code}' property='target.{12(1).1}' action='set' />
<if condition='$Length(source.{/Vaccination/OrderedBy/Name/FamilyNamePrefix})'>
<true>
<assign value='source.{/Vaccination/OrderedBy/Name/FamilyName}' property='target.{12(1).2.1}' action='set' />
<assign value='source.{/Vaccination/OrderedBy/Name/FamilyNamePrefix}' property='target.{12(1).2.2}' action='set' />
</true>
<false>
<assign value='source.{/Vaccination/OrderedBy/Name/FamilyName}' property='target.{12(1).2}' action='set' />
</false>
</if>
<assign value='source.{/Vaccination/OrderedBy/Name/GivenName}' property='target.{12(1).3}' action='set' />
<assign value='source.{/Vaccination/OrderedBy/Name/MiddleName}' property='target.{12(1).4}' action='set' />
<assign value='source.{/Vaccination/OrderedBy/Name/NameSuffix}' property='target.{12(1).5}' action='set' />
<assign value='source.{/Vaccination/OrderedBy/Name/NamePrefix}' property='target.{12(1).6}' action='set' />
<assign value='source.{/Vaccination/OrderedBy/SDACodingStandard}' property='target.{12(1).9.1}' action='set' />
<if condition='$Length(source.{/Vaccination/OrderedBy/Name/GivenName})'>
<true>
<assign value='"L"' property='target.{12(1).10}' action='set' />
</true>
</if>
</true>
</if>

</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}

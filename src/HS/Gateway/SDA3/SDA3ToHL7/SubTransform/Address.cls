/// / Name Item Transform to XPN
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Address Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Address' targetDocType='2.5.1:XAD' create='new' language='objectscript' >
<if condition='+$Length(..ReplaceStr($ZStrip(source.{/Address/Street},"*W"),";;",""))||(+source.{/Address/Zip/Code})' >
<true>
<assign value='$Piece(source.{/Address/Street},";")' property='target.{0.1}' action='set' />
<assign value='$ZStrip($Piece(source.{/Address/Street},";",2),"&lt;&gt;W")' property='target.{0.2}' action='set' />
<assign value='source.{/Address/City/Code}' property='target.{0.3}' action='set' />
<assign value='source.{/Address/State/Code}' property='target.{0.4}' action='set' />
<assign value='source.{/Address/Zip/Code}' property='target.{0.5}' action='set' />
<if condition='+$Length(source.{/Address/Country/Code})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Address/Country/Code}' property='target.{0.6}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/Address/County/Code})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Address/County/Code}' property='target.{0.9}' action='set' />
</true>
</if>

</true>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}

/// / Name Item Transform to XPN
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:HomePhoneNumber' create='new' language='objectscript' >
<if condition='(($Length(source.{/Phone}))&amp;&amp;(source.{/Phone}&apos;="x;"))' >
<true>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).PhonePart("Country",source.{/Phone})' property='target.{0.5}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).PhonePart("Area",source.{/Phone})' property='target.{0.6}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).PhonePart("Local",source.{/Phone})' property='target.{0.7}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).PhonePart("Extension",source.{/Phone})' property='tExtension' action='set' />
<if condition='+$Length($Piece(tExtension,";",2))' >
<true>
<assign value='$Piece(tExtension,";",2)' property='target.{0.9}' action='set' />
</true>
</if>
<if condition='+$Length($Piece(tExtension,";",1))' >
<true>
<assign value='$Piece(tExtension,";",1)' property='target.{0.8}' action='set' />
</true>
</if>
</true>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}

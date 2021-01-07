/// Transforms SDA3 HS.SDA3.ContactInfo to vR4 Extension
Class HS.FHIR.DTL.SDA3.vR4.ContactInfo.Extension Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.ContactInfo, HS.FHIR.DTL.vR4.Model.Base.Extension), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.ContactInfo' targetClass='HS.FHIR.DTL.vR4.Model.Base.Extension' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.ContactInfo (SDA3) to Extension (vR4) ]]>
  </annotation>
<assign value='"phone"' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.system' action='set' >
<annotation>
<![CDATA[ phone | fax | email | pager | url | sms | other ]]>
</annotation>
</assign>
<assign value='"work"' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.use' action='set' >
<annotation>
<![CDATA[ home | work | temp | old | mobile - purpose of this contact point ]]>
</annotation>
</assign>
<assign value='"mobile"' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.use' action='set' >
<annotation>
<![CDATA[ home | work | temp | old | mobile - purpose of this contact point ]]>
</annotation>
</assign>
<assign value='"phone"' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.system' action='set' >
<annotation>
<![CDATA[ phone | fax | email | pager | url | sms | other ]]>
</annotation>
</assign>
<assign value='"phone"' property='target.valueContactPoint.extension.(1).valueContactPoint.system' action='set' >
<annotation>
<![CDATA[ phone | fax | email | pager | url | sms | other ]]>
</annotation>
</assign>
<assign value='"home"' property='target.valueContactPoint.extension.(1).valueContactPoint.use' action='set' >
<annotation>
<![CDATA[ home | work | temp | old | mobile - purpose of this contact point ]]>
</annotation>
</assign>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/contact-info-home-phone-number"' property='target.valueContactPoint.extension.(1).url' action='set' >
<annotation>
<![CDATA[ identifies the meaning of the extension ]]>
</annotation>
</assign>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/contact-info-email-address"' property='target.url' action='set' >
<annotation>
<![CDATA[ identifies the meaning of the extension ]]>
</annotation>
</assign>
<assign value='"email"' property='target.valueContactPoint.system' action='set' >
<annotation>
<![CDATA[ phone | fax | email | pager | url | sms | other ]]>
</annotation>
</assign>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/contact-info-work-phone-number"' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.extension.(1).url' action='set' >
<annotation>
<![CDATA[ identifies the meaning of the extension ]]>
</annotation>
</assign>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/contact-info-mobile-phone-number"' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).url' action='set' >
<annotation>
<![CDATA[ identifies the meaning of the extension ]]>
</annotation>
</assign>
<if condition='source.EmailAddress&apos;=""'> 
<true>
<if condition='source.EmailAddress&apos;=""'> 
<true> 
<assign value='source.EmailAddress' property='target.valueContactPoint.value' action='set' >
<annotation>
<![CDATA[ The actual contact point details ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.HomePhoneNumber&apos;=""'> 
<true>
<if condition='source.HomePhoneNumber&apos;=""'> 
<true> 
<assign value='source.HomePhoneNumber' property='target.valueContactPoint.extension.(1).valueContactPoint.value' action='set' >
<annotation>
<![CDATA[ The actual contact point details ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.MobilePhoneNumber&apos;=""'> 
<true>
<if condition='source.MobilePhoneNumber&apos;=""'> 
<true> 
<assign value='source.MobilePhoneNumber' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.value' action='set' >
<annotation>
<![CDATA[ The actual contact point details ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.WorkPhoneNumber&apos;=""'> 
<true>
<if condition='source.WorkPhoneNumber&apos;=""'> 
<true> 
<assign value='source.WorkPhoneNumber' property='target.valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.extension.(1).valueContactPoint.value' action='set' >
<annotation>
<![CDATA[ The actual contact point details ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ContactInfo.Extension")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ContactInfo.Extension") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ContactInfo.Extension).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.ContactInfo.Extension") ]]></code>
</true>
</if>
</transform>
}

}

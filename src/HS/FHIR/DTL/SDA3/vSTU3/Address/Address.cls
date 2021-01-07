/// Transforms SDA3 HS.SDA3.Address to vSTU3 Address
Class HS.FHIR.DTL.SDA3.vSTU3.Address.Address Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Address, HS.FHIR.DTL.vSTU3.Model.Datatype.Address), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Address' targetClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Address' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Address (SDA3) to Address (vSTU3) ]]>
  </annotation>
<if condition='source.City.Code&apos;=""'> 
<true>
<if condition='source.City.Code&apos;=""'> 
<true> 
<assign value='source.City.Code' property='target.city' action='set' >
<annotation>
<![CDATA[ Name of city, town etc. ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.City.Description&apos;=""'> 
<true>
<if condition='source.City.Code = ""'> 
<true>
<if condition='source.City.Description&apos;=""'> 
<true> 
<assign value='source.City.Description' property='target.city' action='set' >
<annotation>
<![CDATA[ Name of city, town etc. ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.Country.Code&apos;=""'> 
<true>
<if condition='source.Country.Code&apos;=""'> 
<true> 
<assign value='source.Country.Code' property='target.country' action='set' >
<annotation>
<![CDATA[ Country (e.g. can be ISO 3166 2 or 3 letter code) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.Country.Description&apos;=""'> 
<true>
<if condition='source.Country.Code = ""'> 
<true>
<if condition='source.Country.Description&apos;=""'> 
<true> 
<assign value='source.Country.Description' property='target.country' action='set' >
<annotation>
<![CDATA[ Country (e.g. can be ISO 3166 2 or 3 letter code) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.County.Code&apos;=""'> 
<true>
<if condition='source.County.Code&apos;=""'> 
<true> 
<assign value='source.County.Code' property='target.district' action='set' >
<annotation>
<![CDATA[ District name (aka county) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.County.Description&apos;=""'> 
<true>
<if condition='source.County.Code = ""'> 
<true>
<if condition='source.County.Description&apos;=""'> 
<true> 
<assign value='source.County.Description' property='target.district' action='set' >
<annotation>
<![CDATA[ District name (aka county) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.FromTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.FromTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.period.start' action='set' >
<annotation>
<![CDATA[ Starting time with inclusive boundary ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.State.Code&apos;=""'> 
<true>
<if condition='source.State.Code&apos;=""'> 
<true> 
<assign value='source.State.Code' property='target.state' action='set' >
<annotation>
<![CDATA[ Sub-unit of country (abbreviations ok) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.State.Description&apos;=""'> 
<true>
<if condition='source.State.Code = ""'> 
<true>
<if condition='source.State.Description&apos;=""'> 
<true> 
<assign value='source.State.Description' property='target.state' action='set' >
<annotation>
<![CDATA[ Sub-unit of country (abbreviations ok) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.Street &apos;= ""' >
<true>
<assign value='source.Street' property='target.line' action='set' key='target.line.Count()+1' >
<annotation>
<![CDATA[ Street name, number, direction & P.O. Box etc. ]]>
</annotation>
</assign></true>
</if>
<if condition='source.ToTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ToTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.period.end' action='set' >
<annotation>
<![CDATA[ End time with inclusive boundary, if not ongoing ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.Zip.Code&apos;=""'> 
<true>
<if condition='source.Zip.Code&apos;=""'> 
<true> 
<assign value='source.Zip.Code' property='target.postalCode' action='set' >
<annotation>
<![CDATA[ Postal code for area ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.Zip.Description&apos;=""'> 
<true>
<if condition='source.Zip.Code = ""'> 
<true>
<if condition='source.Zip.Description&apos;=""'> 
<true> 
<assign value='source.Zip.Description' property='target.postalCode' action='set' >
<annotation>
<![CDATA[ Postal code for area ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Address.Address")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Address.Address") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Address.Address).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Address.Address") ]]></code>
</true>
</if>
</transform>
}

}

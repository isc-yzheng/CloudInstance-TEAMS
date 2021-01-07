/// Transforms vSTU3 Address to vDSTU2 Address
Class HS.FHIR.DTL.vSTU3.vDSTU2.Address.Address Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Address, HS.FHIR.DTL.vDSTU2.Model.Datatype.Address), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Address' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Address' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Address (vSTU3) to Address (vDSTU2) ]]>
  </annotation>
<if condition='source.city&apos;=""'> 
<true> 
<assign value='source.city' property='target.city' action='set' >
<annotation>
<![CDATA[ Name of city, town etc. ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.country&apos;=""'> 
<true> 
<assign value='source.country' property='target.country' action='set' >
<annotation>
<![CDATA[ Country (e.g. can be ISO 3166 2 or 3 letter code) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.district&apos;=""'> 
<true> 
<assign value='source.district' property='target.district' action='set' >
<annotation>
<![CDATA[ District name (aka county) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.extension&apos;=""'> 
<true>
<foreach property='source.extension()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

<foreach property='source.line()' key='ll1' >
<assign value='source.line.(ll1)' property='target.line' action='set' key='ll1' >
<annotation>
<![CDATA[ Street name, number, direction & P.O. Box etc. ]]>
</annotation>
</assign></foreach>
<if condition='source.period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.period' action='set'  >
<annotation>
<![CDATA[ Time period when address was/is in use ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.postalCode&apos;=""'> 
<true> 
<assign value='source.postalCode' property='target.postalCode' action='set' >
<annotation>
<![CDATA[ Postal code for area ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.primitiveExtension()' key='st' >
<assign value='target.primitiveExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.state&apos;=""'> 
<true> 
<assign value='source.state' property='target.state' action='set' >
<annotation>
<![CDATA[ Sub-unit of country (abbreviations ok) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.text&apos;=""'> 
<true> 
<assign value='source.text' property='target.text' action='set' >
<annotation>
<![CDATA[ Text representation of the address ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.type&apos;=""'> 
<true> 
<assign value='source.type' property='target.type' action='set' >
<annotation>
<![CDATA[ postal | physical | both
 --- Note: The FHIR value set being used is (address-type) which means address-type is the *Required* FHIR2 ValueSet for codes; you may NOT extend address-type and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.use&apos;=""'> 
<true> 
<assign value='source.use' property='target.use' action='set' >
<annotation>
<![CDATA[ home | work | temp | old - purpose of this address
 --- Note: The FHIR value set being used is (address-use) which means address-use is the *Required* FHIR2 ValueSet for codes; you may NOT extend address-use and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

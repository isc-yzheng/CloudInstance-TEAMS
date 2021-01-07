/// Transforms vSTU3 HumanName to vDSTU2 HumanName
Class HS.FHIR.DTL.vSTU3.vDSTU2.HumanName.HumanName Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName, HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HumanName (vSTU3) to HumanName (vDSTU2) ]]>
  </annotation>
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
<if condition='source.family &apos;= ""' >
<true>
<assign value='source.family' property='target.family' action='set' key='target.family.Count()+1' >
<annotation>
<![CDATA[ Family name (often called 'Surname') ]]>
</annotation>
</assign></true>
</if>
<foreach property='source.given()' key='ll1' >
<assign value='source.given.(ll1)' property='target.given' action='set' key='ll1' >
<annotation>
<![CDATA[ Given names (not always 'first'). Includes middle names ]]>
</annotation>
</assign></foreach>
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.period' action='set'  >
<annotation>
<![CDATA[ Time period when name was/is in use ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<foreach property='source.prefix()' key='ll1' >
<assign value='source.prefix.(ll1)' property='target.prefix' action='set' key='ll1' >
<annotation>
<![CDATA[ Parts that come before the name ]]>
</annotation>
</assign></foreach>
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
<foreach property='source.suffix()' key='ll1' >
<assign value='source.suffix.(ll1)' property='target.suffix' action='set' key='ll1' >
<annotation>
<![CDATA[ Parts that come after the name ]]>
</annotation>
</assign></foreach>
<if condition='source.text&apos;=""'> 
<true> 
<assign value='source.text' property='target.text' action='set' >
<annotation>
<![CDATA[ Text representation of the full name ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.use&apos;=""'> 
<true> 
<assign value='source.use' property='target.use' action='set' >
<annotation>
<![CDATA[ usual | official | temp | nickname | anonymous | old | maiden
 --- Note: The FHIR value set being used is (name-use) which means name-use is the *Required* FHIR2 ValueSet for codes; you may NOT extend name-use and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

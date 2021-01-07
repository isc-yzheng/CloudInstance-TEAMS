/// Transforms vR4 HumanName to SDA3 HS.SDA3.Name
Class HS.FHIR.DTL.vR4.SDA3.HumanName.Name Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Datatype.HumanName, HS.SDA3.Name), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Datatype.HumanName' targetClass='HS.SDA3.Name' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HumanName (vR4) to HS.SDA3.Name (SDA3) ]]>
  </annotation>
<if condition='source.family&apos;=""'> 
<true> 
<assign value='source.family' property='target.FamilyName' action='set' >
<annotation>
<![CDATA[ The main part of the FamilyName, for sorting, etc.
 --- SDA3 HS.SDA3.Name:FamilyName is type %String with a maximum string length of *80*.    ]]>
</annotation>
</assign></true> 
</if> 

<foreach property='source.given()' key='ls1' >
<if condition='ls1=1' >
<true>
<assign value='source.given.(ls1)' property='target.GivenName' action='set' >
<annotation>
<![CDATA[ The (first) given name
 --- SDA3 HS.SDA3.Name:GivenName is type %String with a maximum string length of *60*. 
 --- FHIR4 HumanName:given is a *List*, and SDA3 HS.SDA3.Name:GivenName is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true>
<false>
<assign value='target.GivenName _ "; " _ source.given.(ls1)' property='target.GivenName' action='set' />
</false>
</if>
</foreach>
<foreach property='source.prefix()' key='ls1' >
<if condition='ls1=1' >
<true>
<assign value='source.prefix.(ls1)' property='target.NamePrefix' action='set' >
<annotation>
<![CDATA[ The prefix for the name, e.g. "Dr."
 --- SDA3 HS.SDA3.Name:NamePrefix is type %String with a maximum string length of *220*. 
 --- FHIR4 HumanName:prefix is a *List*, and SDA3 HS.SDA3.Name:NamePrefix is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true>
<false>
<assign value='target.NamePrefix _ "; " _ source.prefix.(ls1)' property='target.NamePrefix' action='set' />
</false>
</if>
</foreach>
<foreach property='source.suffix()' key='ls1' >
<if condition='ls1=1' >
<true>
<assign value='source.suffix.(ls1)' property='target.NameSuffix' action='set' >
<annotation>
<![CDATA[ The suffix for the name, e.g. "Jr", "III"
 --- SDA3 HS.SDA3.Name:NameSuffix is type %String with a maximum string length of *220*. 
 --- FHIR4 HumanName:suffix is a *List*, and SDA3 HS.SDA3.Name:NameSuffix is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true>
<false>
<assign value='target.NameSuffix _ "; " _ source.suffix.(ls1)' property='target.NameSuffix' action='set' />
</false>
</if>
</foreach>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","name-use|4.0.1","HS.SDA3.Name:Type",source.use)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Type' action='set' >
<annotation>
<![CDATA[ ,Alias,Adopted,Birth,Display,Legal,License,Maiden,Nickname,Previous,Tribal,Unknown
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.Name:Type is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","name-use|4.0.1","HS.SDA3.Name:Type",source.use) = ""'> 
<true>
<if condition='source.use&apos;=""'> 
<true> 
<assign value='source.use' property='target.Type' action='set' >
<annotation>
<![CDATA[ ,Alias,Adopted,Birth,Display,Legal,License,Maiden,Nickname,Previous,Tribal,Unknown
 --- SDA3 HS.SDA3.Name:Type is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</transform>
}

}

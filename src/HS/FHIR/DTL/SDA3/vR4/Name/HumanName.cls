/// Transforms SDA3 HS.SDA3.Name to vR4 HumanName
Class HS.FHIR.DTL.SDA3.vR4.Name.HumanName Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Name, HS.FHIR.DTL.vR4.Model.Datatype.HumanName), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Name' targetClass='HS.FHIR.DTL.vR4.Model.Datatype.HumanName' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Name (SDA3) to HumanName (vR4) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.Name).Text(source.FamilyName, source.NamePrefix, source.NameSuffix, source.GivenName, source.MiddleName, source.ProfessionalSuffix, source.FamilyNamePrefix)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.text' action='set' >
<annotation>
<![CDATA[ Text representation of the full name ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.Name).FamilyName(source.FamilyName, source.FamilyNamePrefix)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.family' action='set' >
<annotation>
<![CDATA[ Family name (often called 'Surname') ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.GivenName &apos;= ""' >
<true>
<assign value='source.GivenName' property='target.given' action='set' key='target.given.Count()+1' >
<annotation>
<![CDATA[ Given names (not always 'first'). Includes middle names ]]>
</annotation>
</assign></true>
</if>
<if condition='source.MiddleName &apos;= ""' >
<true>
<assign value='source.MiddleName' property='target.given' action='set' key='target.given.Count()+1' >
<annotation>
<![CDATA[ Given names (not always 'first'). Includes middle names ]]>
</annotation>
</assign></true>
</if>
<if condition='source.NamePrefix &apos;= ""' >
<true>
<assign value='source.NamePrefix' property='target.prefix' action='set' key='target.prefix.Count()+1' >
<annotation>
<![CDATA[ Parts that come before the name ]]>
</annotation>
</assign></true>
</if>
<if condition='source.NameSuffix &apos;= ""' >
<true>
<assign value='source.NameSuffix' property='target.suffix' action='set' key='target.suffix.Count()+1' >
<annotation>
<![CDATA[ Parts that come after the name ]]>
</annotation>
</assign></true>
</if>
<if condition='source.ProfessionalSuffix &apos;= ""' >
<true>
<assign value='source.ProfessionalSuffix' property='target.suffix' action='set' key='target.suffix.Count()+1' >
<annotation>
<![CDATA[ Parts that come after the name ]]>
</annotation>
</assign></true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Name:Type","name-use|4.0.1",source.Type)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.use' action='set' >
<annotation>
<![CDATA[ usual | official | temp | nickname | anonymous | old | maiden
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.Type&apos;=""'> 
<true>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Name:Type","name-use|4.0.1",source.Type) = "")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Type, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Type, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/name-type"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations
 --- This mapping supports a related mapping that does a table lookup to match the incoming source value with a value to place in the target field. This mapping has the same Condition to Set this Field as the table lookup. If the lookup successfully finds a value for target field, this mapping stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Name.HumanName")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Name.HumanName") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Name.HumanName).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Name.HumanName") ]]></code>
</true>
</if>
</transform>
}

}

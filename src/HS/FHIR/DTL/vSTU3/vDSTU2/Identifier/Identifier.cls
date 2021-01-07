/// Transforms vSTU3 Identifier to vDSTU2 Identifier
Class HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier, HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Identifier (vSTU3) to Identifier (vDSTU2) ]]>
  </annotation>
<if condition='source.assigner&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Identifier:assigner", source.assigner)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.assigner' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.assigner' action='set'  >
<annotation>
<![CDATA[ Organization that issued id (may be just text)
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
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

<if condition='source.period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.period' action='set'  >
<annotation>
<![CDATA[ Time period when id is/was valid for use ]]>
</annotation>
</assign></true> 
</if>

</true>
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
<if condition='source.system&apos;=""'> 
<true> 
<assign value='source.system' property='target.system' action='set' >
<annotation>
<![CDATA[ The namespace for the identifier value ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.type' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ Description of identifier
 --- Note: The FHIR value set being used is (identifier-type +) which means identifier-type is the *Required* FHIR2 ValueSet for codes, but if you need to express meanings not found in identifier-type, you may formally *Extend* identifier-type to add codes to it.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.use&apos;=""'> 
<true> 
<assign value='source.use' property='target.use' action='set' >
<annotation>
<![CDATA[ usual | official | temp | secondary (If known)
 --- Note: The FHIR value set being used is (identifier-use) which means identifier-use is the *Required* FHIR2 ValueSet for codes; you may NOT extend identifier-use and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.value&apos;=""'> 
<true> 
<assign value='source.value' property='target.value' action='set' >
<annotation>
<![CDATA[ The value that is unique ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

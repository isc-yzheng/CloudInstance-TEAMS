/// Transforms vSTU3 ContactPoint to vDSTU2 ContactPoint
Class HS.FHIR.DTL.vSTU3.vDSTU2.ContactPoint.ContactPoint Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint, HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms ContactPoint (vSTU3) to ContactPoint (vDSTU2) ]]>
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
<![CDATA[ Time period when the contact point was/is in use ]]>
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
<if condition='source.rank&apos;=""'> 
<true> 
<assign value='source.rank' property='target.rank' action='set' >
<annotation>
<![CDATA[ Specify preferred order of use (1 = highest) ]]>
</annotation>
</assign></true> 
</if> 

<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","contact-point-system","contact-point-system",source.system)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.system' action='set' >
<annotation>
<![CDATA[ phone | fax | email | pager | other
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (contact-point-system) which means contact-point-system is the *Required* FHIR2 ValueSet for codes; you may NOT extend contact-point-system and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.use&apos;=""'> 
<true> 
<assign value='source.use' property='target.use' action='set' >
<annotation>
<![CDATA[ home | work | temp | old | mobile - purpose of this contact point
 --- Note: The FHIR value set being used is (contact-point-use) which means contact-point-use is the *Required* FHIR2 ValueSet for codes; you may NOT extend contact-point-use and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.value&apos;=""'> 
<true> 
<assign value='source.value' property='target.value' action='set' >
<annotation>
<![CDATA[ The actual contact point details ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

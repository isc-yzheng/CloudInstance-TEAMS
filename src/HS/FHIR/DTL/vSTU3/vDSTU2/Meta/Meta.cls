/// Transforms vSTU3 Meta to vDSTU2 Meta
Class HS.FHIR.DTL.vSTU3.vDSTU2.Meta.Meta Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Base.Meta, HS.FHIR.DTL.vDSTU2.Model.Base.Meta), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Base.Meta' targetClass='HS.FHIR.DTL.vDSTU2.Model.Base.Meta' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Meta (vSTU3) to Meta (vDSTU2) ]]>
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

<if condition='source.lastUpdated&apos;=""'> 
<true> 
<assign value='source.lastUpdated' property='target.lastUpdated' action='set' >
<annotation>
<![CDATA[ When the resource version last changed ]]>
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
<foreach property='source.profile()' key='ll1' >
<assign value='source.profile.(ll1)' property='target.profile' action='set' key='ll1' >
<annotation>
<![CDATA[ Profiles this resource claims to conform to ]]>
</annotation>
</assign></foreach>
<if condition='source.security&apos;=""'> 
<true>
<foreach property='source.security()' key='st' >
<assign value='target.security.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding' targetObj='tmp' sourceObj='source.security.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.security' action='set' key='index'  >
<annotation>
<![CDATA[ Security Labels applied to this resource
 --- Note: The FHIR value set being used is (security-labels +) which means security-labels is the *Required* FHIR2 ValueSet for codes, but if you need to express meanings not found in security-labels, you may formally *Extend* security-labels to add codes to it.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.tag&apos;=""'> 
<true>
<foreach property='source.tag()' key='st' >
<assign value='target.tag.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding' targetObj='tmp' sourceObj='source.tag.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.tag' action='set' key='index'  >
<annotation>
<![CDATA[ Tags applied to this resource ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.versionId&apos;=""'> 
<true> 
<assign value='source.versionId' property='target.versionId' action='set' >
<annotation>
<![CDATA[ Version specific identifier ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

/// Transforms vSTU3 Coding to vDSTU2 Coding
Class HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Coding, HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Coding' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Coding (vSTU3) to Coding (vDSTU2) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true> 
<assign value='source.code' property='target.code' action='set' >
<annotation>
<![CDATA[ Symbol in syntax defined by the system
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.display&apos;=""'> 
<true> 
<assign value='source.display' property='target.display' action='set' >
<annotation>
<![CDATA[ Representation defined by the system ]]>
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
<![CDATA[ Identity of the terminology system ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.userSelected&apos;=""'> 
<true> 
<assign value='source.userSelected' property='target.userSelected' action='set' >
<annotation>
<![CDATA[ If this coding was chosen directly by the user ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.version&apos;=""'> 
<true> 
<assign value='source.version' property='target.version' action='set' >
<annotation>
<![CDATA[ Version of the system - if relevant ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

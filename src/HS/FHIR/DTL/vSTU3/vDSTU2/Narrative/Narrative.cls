/// Transforms vSTU3 Narrative to vDSTU2 Narrative
Class HS.FHIR.DTL.vSTU3.vDSTU2.Narrative.Narrative Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Base.Narrative, HS.FHIR.DTL.vDSTU2.Model.Base.Narrative), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Base.Narrative' targetClass='HS.FHIR.DTL.vDSTU2.Model.Base.Narrative' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Narrative (vSTU3) to Narrative (vDSTU2) ]]>
  </annotation>
<if condition='source.div&apos;=""'> 
<true> 
<assign value='source.div' property='target.div' action='set' >
<annotation>
<![CDATA[ Limited xhtml content. The narrative SHALL have some non-whitespace content (text or an image). The narrative SHALL contain only the basic html formatting elements and attributes described in chapters 7-11 (except section 4 of chapter 9) and 15 of the HTML 4.0 standard, <a> elements (either name or href), images and internally contained style attributes. The inner portion of the div content is often used for the innerHTML property in a browser. In order to simplify this kind of processing, when the narrative is represented in JSON, it SHALL be encoded so that the characters between the first '>' and the last '<' delimiters is the content of the <div> element; e.g. "div": "<div>text</div>" is legal, but this is not: "div": "<?xml ...><div>text</div>" Note that the XHTML is contained in general XML so there is no support for HTML entities like &nbsp; or &copy; etc. Unicode characters SHALL be used instead. Unicode &#160; substitutes for &nbsp;. ]]>
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
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.status' action='set' >
<annotation>
<![CDATA[ generated | extensions | additional | empty
 --- Note: The FHIR value set being used is (narrative-status) which means narrative-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend narrative-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

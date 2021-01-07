/// Transforms vR4 Specimen to SDA3 HS.SDA3.Specimen
Class HS.FHIR.DTL.vR4.SDA3.Specimen.Specimen Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Specimen, HS.SDA3.Specimen), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Specimen' targetClass='HS.SDA3.Specimen' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Specimen (vR4) to HS.SDA3.Specimen (SDA3) ]]>
  </annotation>
<if condition='source.collection&apos;=""'> 
<true>
<if condition='source.collection.bodySite&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.SpecimenSourceSite).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.collection.bodySite, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.collection.bodySite, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.SpecimenSourceSite' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; body-site shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='source.collection&apos;=""'> 
<true>
<if condition='source.collection.collectedDateTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.collection.collectedDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.collection&apos;=""'> 
<true>
<if condition='source.collection.collectedDateTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.collection.collectedDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.collection&apos;=""'> 
<true>
<if condition='source.collection.collectedPeriod&apos;=""'> 
<true>
<if condition='source.collection.collectedPeriod.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.collection.collectedPeriod.end)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.collection&apos;=""'> 
<true>
<if condition='source.collection.collectedPeriod&apos;=""'> 
<true>
<if condition='source.collection.collectedPeriod.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.collection.collectedPeriod.start)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.collection&apos;=""'> 
<true>
<if condition='source.collection.method&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CollectionMethod).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.collection.method, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.collection.method, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.CollectionMethod' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; specimen-collection-method shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='source.collection&apos;=""'> 
<true>
<if condition='source.collection.quantity&apos;=""'> 
<true>
<if condition='source.collection.quantity.value&apos;=""'> 
<true>
<if condition='source.collection.quantity.value&apos;=""'> 
<true> 
<assign value='source.collection.quantity.value' property='target.CollectionAmount' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR4 Specimen:collection.quantity.value is type decimal; this is not a good match for SDA3 HS.SDA3.Specimen:CollectionAmount, which is type %String. 
 --- SDA3 HS.SDA3.Specimen:CollectionAmount is type %String with a maximum string length of *999*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.processing&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.processing()' key='k1' >
<if condition='source.processing.(k1).additive&apos;=""'> 
<true>
<foreach property='source.processing.(k1).additive()' key='st' >
<assign value='##class(HS.SDA3.CodeTableDetail.SpecimenAdditive).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.processing.(k1).additive.GetAt(st), .value, .aux)' property='value' action='set' />
<assign value='target.SpecimenAdditives.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.SpecimenAdditives' action='set' key='index'  /></true> 
</if> </foreach>
</true>
</if>
</foreach>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.receivedTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.SpecimenType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.type, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.type, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.SpecimenType' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; v2-0487 shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}

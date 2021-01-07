/// Transforms vSTU3 Claim to vDSTU2 Claim
Class HS.FHIR.DTL.vSTU3.vDSTU2.Claim.Claim Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Claim, HS.FHIR.DTL.vDSTU2.Model.Resource.Claim), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Claim' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Claim' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Claim (vSTU3) to Claim (vDSTU2) ]]>
  </annotation>
<if condition='source.accident&apos;=""'> 
<true>
<if condition='source.accident.date&apos;=""'> 
<true>
<if condition='source.accident.date&apos;=""'> 
<true> 
<assign value='source.accident.date' property='target.accident' action='set' >
<annotation>
<![CDATA[ Accident Date ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.contained&apos;=""'> 
<true>
<foreach property='source.contained()' key='st' >
<assign value='target.contained.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Resource).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Resource.Resource' targetObj='tmp' sourceObj='source.contained.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contained' action='set' key='index'  >
<annotation>
<![CDATA[ Contained, inline Resources ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.created&apos;=""'> 
<true> 
<assign value='source.created' property='target.created' action='set' >
<annotation>
<![CDATA[ Creation date ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.diagnosis&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.diagnosis()' key='k1' >
<if condition='source.diagnosis.(k1).diagnosisCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.diagnosis.(k1).diagnosisCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.diagnosis.(j1).diagnosis' action='set'  >
<annotation>
<![CDATA[ Patient's list of diagnosis
 --- Note: The FHIR value set being used is (* icd-10) which means any FHIR2 code may be used; icd-10 shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.diagnosis.(k1).extension&apos;=""'> 
<true>
<foreach property='source.diagnosis.(k1).extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.diagnosis&apos;="") &amp;&amp; (target.diagnosis.Count() &gt; 0)'> 
<true> 
<if condition='target.diagnosis.(j1)&apos;=""'> 
<true> 
<assign value='target.diagnosis.(j1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.diagnosis.(k1).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.diagnosis.(j1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.diagnosis.(k1).id&apos;=""'> 
<true>
<if condition='source.diagnosis.(k1).id&apos;=""'> 
<true> 
<assign value='source.diagnosis.(k1).id' property='target.diagnosis.(j1).id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.diagnosis.(k1).modifierExtension&apos;=""'> 
<true>
<foreach property='source.diagnosis.(k1).modifierExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.diagnosis&apos;="") &amp;&amp; (target.diagnosis.Count() &gt; 0)'> 
<true> 
<if condition='target.diagnosis.(j1)&apos;=""'> 
<true> 
<assign value='target.diagnosis.(j1).modifierExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.diagnosis.(k1).modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.diagnosis.(j1).modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.diagnosis.(k1).primitiveExtension&apos;=""'> 
<true>
<foreach property='source.diagnosis.(k1).primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.diagnosis&apos;="") &amp;&amp; (target.diagnosis.Count() &gt; 0)'> 
<true> 
<if condition='target.diagnosis.(j1)&apos;=""'> 
<true> 
<assign value='target.diagnosis.(j1).primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.diagnosis.(k1).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.diagnosis.(j1).primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.diagnosis.(k1).sequence&apos;=""'> 
<true>
<if condition='source.diagnosis.(k1).sequence&apos;=""'> 
<true> 
<assign value='source.diagnosis.(k1).sequence' property='target.diagnosis.(j1).sequence' action='set' >
<annotation>
<![CDATA[ Sequence of diagnosis ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.diagnosis.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.enterer&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:enterer", source.enterer)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.enterer' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.enterer' action='set'  >
<annotation>
<![CDATA[ Author
 --- Practitioner   ]]>
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
<if condition='source.facility&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:facility", source.facility)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.facility' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.facility' action='set'  >
<annotation>
<![CDATA[ Servicing Facility
 --- Location   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.fundsReserve&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.fundsReserve' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.fundsReserve' action='set'  >
<annotation>
<![CDATA[ Funds requested to be reserved
 --- Note: The FHIR value set being used is (* fundsreserve) which means any FHIR2 code may be used; fundsreserve shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ Logical id of this artifact ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.identifier&apos;=""'> 
<true>
<foreach property='source.identifier()' key='st' >
<assign value='target.identifier.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.identifier.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ Claim number ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.implicitRules&apos;=""'> 
<true> 
<assign value='source.implicitRules' property='target.implicitRules' action='set' >
<annotation>
<![CDATA[ A set of rules under which this content was created ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.item&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.item()' key='k1' >
<if condition='source.item.(k1).bodySite&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.item.(k1).bodySite' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).bodySite' action='set'  >
<annotation>
<![CDATA[ Service Location
 --- Note: The FHIR value set being used is (* tooth) which means any FHIR2 code may be used; tooth shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).category&apos;=""'> 
<true>
<if condition='source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode"'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.item.(k1).category' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).type' action='set'  >
<annotation>
<![CDATA[ Group or type of product or service
 --- The source and target use different value sets. FHIR STU3 Claim:item[n].category uses value set (* benefit-subcategory) and FHIR DSTU2 Claim:item[n].type uses value set (v3-ActInvoiceGroupCode). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- The target FHIR DSTU2 Claim:item[n].type is a required field with a required value set, but FHIR STU3 Claim:item[n].category and  FHIR DSTU2 Claim:item[n].type use different value sets. The target FHIR DSTU2 Claim:item[n].type uses value set (v3-ActInvoiceGroupCode) and FHIR STU3 Claim:item[n].category uses value set (* benefit-subcategory). *No Default Value* is supplied in case of invalid source data. This can be a serious gap.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail&apos;=""'>
<true>
<assign value='1' property='j2' action='set' />
<foreach property='source.item.(k1).detail()' key='k2' >
<if condition='source.item.(k1).detail.(k2).extension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).detail.(k2).extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1).detail.(j2)&apos;=""'> 
<true> 
<assign value='target.item.(j1).detail.(j2).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).factor&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).factor&apos;=""'> 
<true> 
<assign value='source.item.(k1).detail.(k2).factor' property='target.item.(j1).detail.(j2).factor' action='set' >
<annotation>
<![CDATA[ Price scaling factor ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).id&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).id&apos;=""'> 
<true> 
<assign value='source.item.(k1).detail.(k2).id' property='target.item.(j1).detail.(j2).id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).modifierExtension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).detail.(k2).modifierExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1).detail.(j2)&apos;=""'> 
<true> 
<assign value='target.item.(j1).detail.(j2).modifierExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).net&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Money).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Money.Money' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).net' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).net' action='set'  >
<annotation>
<![CDATA[ Total additional item cost ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).primitiveExtension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).detail.(k2).primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1).detail.(j2)&apos;=""'> 
<true> 
<assign value='target.item.(j1).detail.(j2).primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).quantity&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).quantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).quantity' action='set'  >
<annotation>
<![CDATA[ Count of Products or Services ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).sequence&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).sequence&apos;=""'> 
<true> 
<assign value='source.item.(k1).detail.(k2).sequence' property='target.item.(j1).detail.(j2).sequence' action='set' >
<annotation>
<![CDATA[ Service instance ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).service&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).service' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).service' action='set'  >
<annotation>
<![CDATA[ Additional item codes
 --- Note: The FHIR value set being used is (* service-uscls) which means any FHIR2 code may be used; service-uscls shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail&apos;=""'>
<true>
<assign value='1' property='j3' action='set' />
<foreach property='source.item.(k1).detail.(k2).subDetail()' key='k3' >
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).extension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).detail.(k2).subDetail.(k3).extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1).detail.(j2).subDetail.(j3)&apos;=""'> 
<true> 
<assign value='target.item.(j1).detail.(j2).subDetail.(j3).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).factor&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).factor&apos;=""'> 
<true> 
<assign value='source.item.(k1).detail.(k2).subDetail.(k3).factor' property='target.item.(j1).detail.(j2).subDetail.(j3).factor' action='set' >
<annotation>
<![CDATA[ Price scaling factor ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).id&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).id&apos;=""'> 
<true> 
<assign value='source.item.(k1).detail.(k2).subDetail.(k3).id' property='target.item.(j1).detail.(j2).subDetail.(j3).id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).modifierExtension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).detail.(k2).subDetail.(k3).modifierExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1).detail.(j2).subDetail.(j3)&apos;=""'> 
<true> 
<assign value='target.item.(j1).detail.(j2).subDetail.(j3).modifierExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).net&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Money).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Money.Money' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).net' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).net' action='set'  >
<annotation>
<![CDATA[ Net additional item cost ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).primitiveExtension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).detail.(k2).subDetail.(k3).primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1).detail.(j2).subDetail.(j3)&apos;=""'> 
<true> 
<assign value='target.item.(j1).detail.(j2).subDetail.(j3).primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).quantity&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).quantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).quantity' action='set'  >
<annotation>
<![CDATA[ Count of Products or Services ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).sequence&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).sequence&apos;=""'> 
<true> 
<assign value='source.item.(k1).detail.(k2).subDetail.(k3).sequence' property='target.item.(j1).detail.(j2).subDetail.(j3).sequence' action='set' >
<annotation>
<![CDATA[ Service instance ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).service&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).service' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).service' action='set'  >
<annotation>
<![CDATA[ Additional item codes
 --- Note: The FHIR value set being used is (* service-uscls) which means any FHIR2 code may be used; service-uscls shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).udi&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).udi.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Reference.Coding' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).udi.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).udi' action='set'  >
<annotation>
<![CDATA[ Unique Device Identifier
 --- FHIR STU3 Claim:item[n].detail[n].subDetail[n].udi is a *List*, and FHIR DSTU2 Claim:item[n].detail[n].subDetail[n].udi is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.
 --- FHIR STU3 Claim:item[n].detail[n].subDetail[n].udi is type Reference (Device). This is not a good match for FHIR DSTU2 Claim:item[n].detail[n].subDetail[n].udi, which is FHIR code type Coding. 
 --- Note: FHIR DSTU2 Claim:item[n].detail[n].subDetail[n].udi uses FHIR value set (* udi) which means any FHIR2 code may be used; udi shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).subDetail.(k3).unitPrice&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Money).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Money.Money' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).subDetail.(k3).unitPrice' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).subDetail.(j3).unitPrice' action='set'  >
<annotation>
<![CDATA[ Fee, charge or cost per point ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='target.item.(j1).detail.(j2).subDetail.(j3) &apos;= ""'>
<true>
<assign value='j3+1' property='j3' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).udi&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).detail.(k2).udi.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Reference.Coding' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).udi.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).udi' action='set'  >
<annotation>
<![CDATA[ Unique Device Identifier
 --- FHIR STU3 Claim:item[n].detail[n].udi is a *List*, and FHIR DSTU2 Claim:item[n].detail[n].udi is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.
 --- FHIR STU3 Claim:item[n].detail[n].udi is type Reference (Device). This is not a good match for FHIR DSTU2 Claim:item[n].detail[n].udi, which is FHIR code type Coding. 
 --- Note: FHIR DSTU2 Claim:item[n].detail[n].udi uses FHIR value set (* udi) which means any FHIR2 code may be used; udi shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).detail.(k2).unitPrice&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Money).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Money.Money' targetObj='tmp' sourceObj='source.item.(k1).detail.(k2).unitPrice' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).detail.(j2).unitPrice' action='set'  >
<annotation>
<![CDATA[ Fee, charge or cost per point ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='target.item.(j1).detail.(j2) &apos;= ""'>
<true>
<assign value='j2+1' property='j2' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.item.(k1).diagnosisLinkId&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).diagnosisLinkId()' key='ll1' >
<assign value='source.item.(k1).diagnosisLinkId.(ll1)' property='target.item.(j1).diagnosisLinkId' action='set' key='ll1' >
<annotation>
<![CDATA[ Diagnosis Link ]]>
</annotation>
</assign></foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).extension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1)&apos;=""'> 
<true> 
<assign value='target.item.(j1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).factor&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).factor&apos;=""'> 
<true> 
<assign value='source.item.(k1).factor' property='target.item.(j1).factor' action='set' >
<annotation>
<![CDATA[ Price scaling factor ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).id&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).id&apos;=""'> 
<true> 
<assign value='source.item.(k1).id' property='target.item.(j1).id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).modifier&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).modifier()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1)&apos;=""'> 
<true> 
<assign value='target.item.(j1).modifier.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.item.(k1).modifier.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).modifier' action='set' key='index'  >
<annotation>
<![CDATA[ Service/Product billing modifiers
 --- Note: The FHIR value set being used is (* claim-modifiers) which means any FHIR2 code may be used; claim-modifiers shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).modifierExtension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).modifierExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1)&apos;=""'> 
<true> 
<assign value='target.item.(j1).modifierExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).net&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Money).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Money.Money' targetObj='tmp' sourceObj='source.item.(k1).net' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).net' action='set'  >
<annotation>
<![CDATA[ Total item cost ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).primitiveExtension&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1)&apos;=""'> 
<true> 
<assign value='target.item.(j1).primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.item.(k1).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).quantity&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.item.(k1).quantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).quantity' action='set'  >
<annotation>
<![CDATA[ Count of Products or Services ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).sequence&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).sequence&apos;=""'> 
<true> 
<assign value='source.item.(k1).sequence' property='target.item.(j1).sequence' action='set' >
<annotation>
<![CDATA[ Service instance ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).service&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.item.(k1).service' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).service' action='set'  >
<annotation>
<![CDATA[ Item Code
 --- Note: The FHIR value set being used is (* service-uscls) which means any FHIR2 code may be used; service-uscls shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.item.(k1).subSite&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<foreach property='source.item.(k1).subSite()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.item&apos;="") &amp;&amp; (target.item.Count() &gt; 0)'> 
<true> 
<if condition='target.item.(j1)&apos;=""'> 
<true> 
<assign value='target.item.(j1).subSite.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.item.(k1).subSite.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).subSite' action='set' key='index'  >
<annotation>
<![CDATA[ Service Sub-location
 --- Note: The FHIR value set being used is (* surface) which means any FHIR2 code may be used; surface shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).udi&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<if condition='source.item.(k1).udi.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Reference.Coding' targetObj='tmp' sourceObj='source.item.(k1).udi.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).udi' action='set'  >
<annotation>
<![CDATA[ Unique Device Identifier
 --- FHIR STU3 Claim:item[n].udi is a *List*, and FHIR DSTU2 Claim:item[n].udi is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.
 --- FHIR STU3 Claim:item[n].udi is type Reference (Device). This is not a good match for FHIR DSTU2 Claim:item[n].udi, which is FHIR code type Coding. 
 --- Note: FHIR DSTU2 Claim:item[n].udi uses FHIR value set (* udi) which means any FHIR2 code may be used; udi shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.item.(k1).unitPrice&apos;=""'> 
<true>
<if condition='(source.item.(k1).service &apos;= "") &amp;&amp; (source.item.(k1).category &apos;= "") &amp;&amp; (source.item.(k1).category.coding.(1).system = "http://hl7.org/fhir/v3/ActCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Money).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Money.Money' targetObj='tmp' sourceObj='source.item.(k1).unitPrice' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.item.(j1).unitPrice' action='set'  >
<annotation>
<![CDATA[ Fee, charge or cost per point ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='target.item.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.language&apos;=""'> 
<true> 
<assign value='source.language' property='target.language' action='set' >
<annotation>
<![CDATA[ Language of the resource content ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.meta&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Meta).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Meta.Meta' targetObj='tmp' sourceObj='source.meta' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.meta' action='set'  >
<annotation>
<![CDATA[ Metadata about the resource ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.modifierExtension&apos;=""'> 
<true>
<foreach property='source.modifierExtension()' key='st' >
<assign value='target.modifierExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.organization&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:organization", source.organization)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.organization' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.organization' action='set'  >
<annotation>
<![CDATA[ Responsible organization
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.originalPrescription&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:originalPrescription", source.originalPrescription)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.originalPrescription' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.originalPrescription' action='set'  >
<annotation>
<![CDATA[ Original Prescription
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.patient&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:patient", source.patient)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.patient' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ The subject of the Products and Services
 --- Patient   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.payee&apos;=""'> 
<true>
<if condition='source.payee.extension&apos;=""'> 
<true>
<foreach property='source.payee.extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.payee&apos;=""'> 
<true> 
<assign value='target.payee.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.payee.extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.payee.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.payee&apos;=""'> 
<true>
<if condition='source.payee.id&apos;=""'> 
<true>
<if condition='source.payee.id&apos;=""'> 
<true> 
<assign value='source.payee.id' property='target.payee.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.payee&apos;=""'> 
<true>
<if condition='source.payee.modifierExtension&apos;=""'> 
<true>
<foreach property='source.payee.modifierExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.payee&apos;=""'> 
<true> 
<assign value='target.payee.modifierExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.payee.modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.payee.modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.payee&apos;=""'> 
<true>
<if condition='source.payee.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.payee.primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.payee&apos;=""'> 
<true> 
<assign value='target.payee.primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.payee.primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.payee.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.payee&apos;=""'> 
<true>
<if condition='source.payee.type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.payee.type' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.payee.type' action='set'  >
<annotation>
<![CDATA[ Party to be paid any benefits payable
 --- Note: The FHIR value set being used is (* payeetype) which means any FHIR2 code may be used; payeetype shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.prescription&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:prescription", source.prescription)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.prescription' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.prescription' action='set'  >
<annotation>
<![CDATA[ Prescription
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
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
<if condition='source.priority&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding' targetObj='tmp' sourceObj='source.priority' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.priority' action='set'  >
<annotation>
<![CDATA[ Desired processing priority
 --- Note: The FHIR value set being used is (* process-priority) which means any FHIR2 code may be used; process-priority shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.provider&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:provider", source.provider)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.provider' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.provider' action='set'  >
<annotation>
<![CDATA[ Responsible provider
 --- Practitioner   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.referral&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Claim:referral", source.referral)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.referral' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.referral' action='set'  >
<annotation>
<![CDATA[ Treatment Referral
 --- ReferralRequest   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.text&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Narrative).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Narrative.Narrative' targetObj='tmp' sourceObj='source.text' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.text' action='set'  >
<annotation>
<![CDATA[ Text summary of the resource, for human interpretation ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","claim-type","claim-type-link",source.type)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.type' action='set' >
<annotation>
<![CDATA[ institutional | oral | pharmacy | professional | vision
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Claim:type uses value set (claim-type) and FHIR DSTU2 Claim:type uses value set (claim-type-link). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field.    ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"institutional"' property='target.type' action='set' />
</false> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","claim-use","claim-use-link",source.use)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.use' action='set' >
<annotation>
<![CDATA[ complete | proposed | exploratory | other
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Claim:use uses value set (claim-use) and FHIR DSTU2 Claim:use uses value set (claim-use-link). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field.    ]]>
</annotation>
</assign></true> 
</if> 
</transform>
}

}

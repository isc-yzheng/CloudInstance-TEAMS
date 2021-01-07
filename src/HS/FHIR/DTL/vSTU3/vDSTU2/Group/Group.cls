/// Transforms vSTU3 Group to vDSTU2 Group
Class HS.FHIR.DTL.vSTU3.vDSTU2.Group.Group Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Group, HS.FHIR.DTL.vDSTU2.Model.Resource.Group), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Group' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Group' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Group (vSTU3) to Group (vDSTU2) ]]>
  </annotation>
<if condition='source.actual&apos;=""'> 
<true> 
<assign value='source.actual' property='target.actual' action='set' >
<annotation>
<![CDATA[ Descriptive or actual ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.characteristic&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.characteristic()' key='k1' >
<if condition='source.characteristic.(k1).code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.characteristic.(k1).code' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.characteristic.(j1).code' action='set'  >
<annotation>
<![CDATA[ Kind of characteristic
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.characteristic.(k1).exclude&apos;=""'> 
<true>
<if condition='source.characteristic.(k1).exclude&apos;=""'> 
<true> 
<assign value='source.characteristic.(k1).exclude' property='target.characteristic.(j1).exclude' action='set' >
<annotation>
<![CDATA[ Group includes or excludes ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.characteristic.(k1).period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.characteristic.(k1).period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.characteristic.(j1).period' action='set'  >
<annotation>
<![CDATA[ Period over which characteristic is tested ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.characteristic.(k1).valueBoolean&apos;=""'> 
<true>
<if condition='source.characteristic.(k1).valueBoolean&apos;=""'> 
<true> 
<assign value='source.characteristic.(k1).valueBoolean' property='target.characteristic.(j1).valueBoolean' action='set' >
<annotation>
<![CDATA[ Value held by characteristic ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.characteristic.(k1).valueCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.characteristic.(k1).valueCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.characteristic.(j1).valueCodeableConcept' action='set'  >
<annotation>
<![CDATA[ Value held by characteristic
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.characteristic.(k1).valueQuantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Quantity.Quantity' targetObj='tmp' sourceObj='source.characteristic.(k1).valueQuantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.characteristic.(j1).valueQuantity' action='set'  >
<annotation>
<![CDATA[ Value held by characteristic ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.characteristic.(k1).valueRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.characteristic.(k1).valueRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.characteristic.(j1).valueRange' action='set'  >
<annotation>
<![CDATA[ Value held by characteristic ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='target.characteristic.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.code' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.code' action='set'  >
<annotation>
<![CDATA[ Kind of Group members
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
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
<![CDATA[ Unique id ]]>
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

<if condition='source.language&apos;=""'> 
<true> 
<assign value='source.language' property='target.language' action='set' >
<annotation>
<![CDATA[ Language of the resource content ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.member&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.member()' key='k1' >
<if condition='source.member.(k1).entity&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Group:member[n].entity", source.member.(k1).entity)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.member.(k1).entity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.member.(j1).entity' action='set'  >
<annotation>
<![CDATA[ Reference to the group member
 --- Patient | Practitioner | Device | Medication | Substance   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.member.(k1).inactive&apos;=""'> 
<true>
<if condition='source.member.(k1).inactive&apos;=""'> 
<true> 
<assign value='source.member.(k1).inactive' property='target.member.(j1).inactive' action='set' >
<annotation>
<![CDATA[ If member is no longer in group ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.member.(k1).period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.member.(k1).period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.member.(j1).period' action='set'  >
<annotation>
<![CDATA[ Period member belonged to the group ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='target.member.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
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
<if condition='source.name&apos;=""'> 
<true> 
<assign value='source.name' property='target.name' action='set' >
<annotation>
<![CDATA[ Label for Group ]]>
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
<if condition='source.quantity&apos;=""'> 
<true> 
<assign value='source.quantity' property='target.quantity' action='set' >
<annotation>
<![CDATA[ Number of members ]]>
</annotation>
</assign></true> 
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
<if condition='source.type&apos;=""'> 
<true> 
<assign value='source.type' property='target.type' action='set' >
<annotation>
<![CDATA[ person | animal | practitioner | device | medication | substance
 --- Note: The FHIR value set being used is (group-type) which means group-type is the *Required* FHIR2 ValueSet for codes; you may NOT extend group-type and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}

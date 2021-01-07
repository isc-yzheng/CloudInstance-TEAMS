/// Transforms vSTU3 Timing to vDSTU2 Timing
Class HS.FHIR.DTL.vSTU3.vDSTU2.Timing.Timing Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Timing, HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Timing' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Timing (vSTU3) to Timing (vDSTU2) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.code' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.code' action='set'  >
<annotation>
<![CDATA[ QD | QOD | Q4H | Q6H | BID | TID | QID | AM | PM +
 --- Note: The FHIR value set being used is (timing-abbreviation *) which means timing-abbreviation is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in timing-abbreviation, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<foreach property='source.event()' key='ll1' >
<assign value='source.event.(ll1)' property='target.event' action='set' key='ll1' >
<annotation>
<![CDATA[ When the event occurs ]]>
</annotation>
</assign></foreach>
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
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.boundsDuration&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Duration).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Duration.Duration' targetObj='tmp' sourceObj='source.repeat.boundsDuration' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.repeat.boundsQuantity' action='set'  >
<annotation>
<![CDATA[ Length/Range of lengths, or (Start and/or end) limits. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.boundsPeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.repeat.boundsPeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.repeat.boundsPeriod' action='set'  >
<annotation>
<![CDATA[ Length/Range of lengths, or (Start and/or end) limits. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.boundsRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.repeat.boundsRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.repeat.boundsRange' action='set'  >
<annotation>
<![CDATA[ Length/Range of lengths, or (Start and/or end) limits. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.count&apos;=""'> 
<true>
<if condition='source.repeat.count&apos;=""'> 
<true> 
<assign value='source.repeat.count' property='target.repeat.count' action='set' >
<annotation>
<![CDATA[ Number of times to repeat ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.duration&apos;=""'> 
<true>
<if condition='source.repeat.duration&apos;=""'> 
<true> 
<assign value='source.repeat.duration' property='target.repeat.duration' action='set' >
<annotation>
<![CDATA[ How long when it happens ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.durationMax&apos;=""'> 
<true>
<if condition='source.repeat.durationMax&apos;=""'> 
<true> 
<assign value='source.repeat.durationMax' property='target.repeat.durationMax' action='set' >
<annotation>
<![CDATA[ How long when it happens (Max) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.durationUnit&apos;=""'> 
<true>
<if condition='source.repeat.durationUnit&apos;=""'> 
<true> 
<assign value='source.repeat.durationUnit' property='target.repeat.durationUnits' action='set' >
<annotation>
<![CDATA[ s | min | h | d | wk | mo | a - unit of time (UCUM)
 --- Note: The FHIR value set being used is (units-of-time) which means units-of-time is the *Required* FHIR2 ValueSet for codes; you may NOT extend units-of-time and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.frequency&apos;=""'> 
<true>
<if condition='source.repeat.frequency&apos;=""'> 
<true> 
<assign value='source.repeat.frequency' property='target.repeat.frequency' action='set' >
<annotation>
<![CDATA[ Event occurs frequency times per period ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.frequencyMax&apos;=""'> 
<true>
<if condition='source.repeat.frequencyMax&apos;=""'> 
<true> 
<assign value='source.repeat.frequencyMax' property='target.repeat.frequencyMax' action='set' >
<annotation>
<![CDATA[ Event occurs up to frequencyMax times per period ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.period&apos;=""'> 
<true>
<if condition='source.repeat.period&apos;=""'> 
<true> 
<assign value='source.repeat.period' property='target.repeat.period' action='set' >
<annotation>
<![CDATA[ Event occurs frequency times per period ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.periodMax&apos;=""'> 
<true>
<if condition='source.repeat.periodMax&apos;=""'> 
<true> 
<assign value='source.repeat.periodMax' property='target.repeat.periodMax' action='set' >
<annotation>
<![CDATA[ Upper limit of period (3-4 hours) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.periodUnit&apos;=""'> 
<true>
<if condition='source.repeat.periodUnit&apos;=""'> 
<true> 
<assign value='source.repeat.periodUnit' property='target.repeat.periodUnits' action='set' >
<annotation>
<![CDATA[ s | min | h | d | wk | mo | a - unit of time (UCUM)
 --- Note: The FHIR value set being used is (units-of-time) which means units-of-time is the *Required* FHIR2 ValueSet for codes; you may NOT extend units-of-time and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.repeat&apos;=""'> 
<true>
<if condition='source.repeat.when&apos;=""'> 
<true>
<if condition='source.repeat.when.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","event-timing","event-timing",source.repeat.when.GetAt(1))' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.repeat.when' action='set' >
<annotation>
<![CDATA[ Regular life events the event is tied to
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- FHIR STU3 Timing:repeat.when is a *List*, and FHIR DSTU2 Timing:repeat.when is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (event-timing) which means event-timing is the *Required* FHIR2 ValueSet for codes; you may NOT extend event-timing and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
</true>
</if>
</transform>
}

}

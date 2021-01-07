/// Transforms vSTU3 Bundle to SDA3 HS.SDA3.Container
Class HS.FHIR.DTL.vSTU3.SDA3.Bundle.Container Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, HS.SDA3.Container), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Bundle' targetClass='HS.SDA3.Container' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Bundle (vSTU3) to HS.SDA3.Container (SDA3) ]]>
  </annotation>
<if condition='&apos;aux("isContained")'> 
<true>
<assign value='$get(aux("sourceResource"))' property='prevSourceResource' action='set' />
<assign value='source' property='aux("sourceResource")' action='set' />
</true>
</if>
<if condition='source&apos;=""'> 
<true>
<assign value='$method(aux("callbackObject"), "GetSendingFacility", source, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.SendingFacility' action='set' >
<annotation>
<![CDATA[ The Organization which sent the message. Strictly speaking it may not be the originator of the data, as the SendingFacility may just be a 'relay'. But this distinction is not always followed.
 --- SDA3 HS.SDA3.Container:SendingFacility is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.entry&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.entry()' key='k1' >
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='source.entry.(k1).resource.resourceType = "Patient"'> 
<true>
<assign value='##class(HS.SDA3.Patient).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Patient.Patient",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Patient' action='set'  >
<annotation>
<![CDATA[ One patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Encounter") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Encounters.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Encounter).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Encounter.Encounter",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Encounters' action='set' key='index'  >
<annotation>
<![CDATA[ List of encounters for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Observation") &amp;&amp; ((source.entry.(k1).resource.category.Count() = 0) || (source.entry.(k1).resource.category.GetAt(1).coding.Count() = 0) || ((source.entry.(k1).resource.category.GetAt(1).coding.GetAt(1).code &apos;= "exam") &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.GetAt(1).code &apos;= "social-history"))) &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Observations.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Observation).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Observation.Observation",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Observations' action='set' key='index'  >
<annotation>
<![CDATA[ List of observations for this patient
Note: An Observation will always create an Observation streamlet unless it has a 'category' element with a 'code' value of "social-history" or "exam", or if it is referenced from a DiagnosticReport. Then it will create a LabResultItem. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "DiagnosticReport") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux)) &amp;&amp; ((source.entry.(k1).resource.category = "") || (source.entry.(k1).resource.category.coding.Count() = 0) || ((source.entry.(k1).resource.category.coding.GetAt(1).code &apos;= "RAD") &amp;&amp; (source.entry.(k1).resource.category.coding.GetAt(1).code &apos;= "OTH")))'> 
<true>
<assign value='target.LabOrders.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.LabOrder).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.DiagnosticReport.LabOrder",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.LabOrders' action='set' key='index'  >
<annotation>
<![CDATA[ List of lab orders for this patient
Note: A DiagnosticReport will always create a LabOrder streamlet unless it has a 'category' element with a 'code' value of "RAD" or "OTH". ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Appointment") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Appointments.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Appointment).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Appointment.Appointment",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Appointments' action='set' key='index'  >
<annotation>
<![CDATA[ List of appointments for patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "AllergyIntolerance") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Allergies.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Allergy).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.AllergyIntolerance.Allergy",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Allergies' action='set' key='index'  >
<annotation>
<![CDATA[ List of allergies that patient has ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Medication") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Medications.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Medication).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Medication.Medication",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Medications' action='set' key='index'  >
<annotation>
<![CDATA[ List of medications for this patient
Note: A Medication resource that isn't referenced from a MedicationRequest, MedicationDispense, or MedicationAdministration will create a new Medication streamlet. If it is referenced from one or more of those resources, all linked resources will be aggregated into a single Medication streamlet. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "MedicationRequest") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Medications.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Medication).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.MedicationRequest.Medication",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Medications' action='set' key='index'  >
<annotation>
<![CDATA[ List of medications for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "MedicationDispense") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='##class(HS.SDA3.Medication).%New()' property='value' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Medication).Transform(source.entry.(k1).resource, .target, .aux)' property='value' action='set' />
<assign value='target.Medications.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Medications' action='set' key='index'  >
<annotation>
<![CDATA[ List of medications for this patient ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "MedicationAdministration") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='##class(HS.SDA3.Medication).%New()' property='value' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Medication).Transform(source.entry.(k1).resource, .target, .aux)' property='value' action='set' />
<assign value='target.Medications.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Medications' action='set' key='index'  >
<annotation>
<![CDATA[ List of medications for this patient ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "ProcedureRequest") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.LabOrders.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.LabOrder).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.ProcedureRequest.LabOrder",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.LabOrders' action='set' key='index'  >
<annotation>
<![CDATA[ List of lab orders for this patient
Note: A ProcedureRequest that isn't referenced from a DiagnosticReport will always create a LabOrder streamlet. If the ProcedureRequest is referenced from a DiagnosticReport, the type of the streamlet created will depend on the DiagnosticReport. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "FamilyMemberHistory") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.FamilyHistories.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.FamilyHistory).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.FamilyMemberHistory.FamilyHistory",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.FamilyHistories' action='set' key='index'  >
<annotation>
<![CDATA[ List of family history entries for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='((source.entry.(k1).resource.resourceType = "Condition") &amp;&amp; &apos;((source.entry.(k1).resource.category.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.GetAt(1).code = "problem-list-item"))) &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Diagnoses.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Diagnosis).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Condition.Diagnosis",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Diagnoses' action='set' key='index'  >
<annotation>
<![CDATA[ List of diagnoses for this patient
Note: A Condition will always create a Diagnosis streamlet unless it has a 'category' element with a 'code' value of "problem-list-item", or if it is referenced from a CarePlan resource. Then it will create a HealthConcern. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='((source.entry.(k1).resource.resourceType = "Condition") &amp;&amp; ((source.entry.(k1).resource.category.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.GetAt(1).code = "problem-list-item"))) &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Problems.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Problem).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Condition.Problem",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Problems' action='set' key='index'  >
<annotation>
<![CDATA[ List of problems for this patient
Note: A Condition will create a Problem streamlet if it has a 'category' element with a 'code' value of "problem-list-item", unless it is referenced from a CarePlan resource. Then it will create a HealthConcern. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "DiagnosticReport") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux)) &amp;&amp; (source.entry.(k1).resource.category &apos;= "") &amp;&amp; (source.entry.(k1).resource.category.coding.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.coding.GetAt(1).code = "RAD")'> 
<true>
<assign value='target.RadOrders.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.RadOrder).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.DiagnosticReport.RadOrder",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.RadOrders' action='set' key='index'  >
<annotation>
<![CDATA[ List of radiology orders for this patient
Note: A DiagnosticReport will create a RadOrder streamlet if it has a 'category' element with a 'code' value of "RAD". ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "DiagnosticReport") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux)) &amp;&amp; (source.entry.(k1).resource.category &apos;= "") &amp;&amp; (source.entry.(k1).resource.category.coding.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.coding.GetAt(1).code = "OTH")'> 
<true>
<assign value='target.OtherOrders.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.OtherOrder).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.DiagnosticReport.OtherOrder",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.OtherOrders' action='set' key='index'  >
<annotation>
<![CDATA[ List of other orders for this patient
Note: A DiagnosticReport will create a OtherOrder streamlet if it has a 'category' element with a 'code' value of "OTH". ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Immunization") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Vaccinations.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Vaccination).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Immunization.Vaccination",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Vaccinations' action='set' key='index'  >
<annotation>
<![CDATA[ List of vaccinations for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Procedure") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Procedures.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Procedure).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Procedure.Procedure",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Procedures' action='set' key='index'  >
<annotation>
<![CDATA[ List of procedures for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Observation") &amp;&amp; (source.entry.(k1).resource.category.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.GetAt(1).code = "exam") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.PhysicalExams.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.PhysicalExam).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Observation.PhysicalExam",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.PhysicalExams' action='set' key='index'  >
<annotation>
<![CDATA[ List of physical exams conducted for this patient
Note: An Observation will create a PhysicalExam streamlet if it has a 'category' element with a 'code' value of "exam", unless it is referenced from a DiagnosticReport. Then it will create a LabResultItem. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Observation") &amp;&amp; (source.entry.(k1).resource.category.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.Count() > 0) &amp;&amp; (source.entry.(k1).resource.category.GetAt(1).coding.GetAt(1).code = "social-history") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.SocialHistories.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.SocialHistory).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Observation.SocialHistory",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.SocialHistories' action='set' key='index'  >
<annotation>
<![CDATA[ List of social history entries for this patient
Note: An Observation will create a SocialHistory streamlet if it has a 'category' element with a 'code' value of "social-history", unless it is referenced from a DiagnosticReport. Then it will create a LabResultItem. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "CarePlan") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.CarePlans.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.CarePlan).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.CarePlan.CarePlan",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.CarePlans' action='set' key='index'  >
<annotation>
<![CDATA[ List of care plans for patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "CarePlan") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.CarePlan.Container",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ To be used as an XML container to hold and manipulate other SDA3 objects.
Note: This mapping allows the Condition resources and the Goal resources referenced from the CarePlan resource to create new HealthConcern and Goal streamlets. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Goal") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Goals.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Goal).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Goal.Goal",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Goals' action='set' key='index'  >
<annotation>
<![CDATA[ List of goals for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Goal") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Goal.Container",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ To be used as an XML container to hold and manipulate other SDA3 objects.
Note: This mapping allows the Condition resources referenced from the Goal resource to create new HealthConcern streamlets. ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "ReferralRequest") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Referrals.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Referral).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.ReferralRequest.Referral",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Referrals' action='set' key='index'  >
<annotation>
<![CDATA[ List of referrals for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "DocumentReference") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Documents.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Document).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.DocumentReference.Document",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Documents' action='set' key='index'  >
<annotation>
<![CDATA[ List of documents for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Communication") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.Alerts.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Alert).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Communication.Alert",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Alerts' action='set' key='index'  >
<annotation>
<![CDATA[ List of alerts for patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Claim") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.MedicalClaims.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.MedicalClaim).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Claim.MedicalClaim",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.MedicalClaims' action='set' key='index'  >
<annotation>
<![CDATA[ List of medical claims for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "EnrollmentRequest") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.MemberEnrollments.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.MemberEnrollment).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.EnrollmentRequest.MemberEnrollment",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.MemberEnrollments' action='set' key='index'  >
<annotation>
<![CDATA[ List of member enrollments for this patient ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.entry.(k1).resource&apos;=""'> 
<true>
<if condition='(source.entry.(k1).resource.resourceType = "Composition") &amp;&amp; (source.entry.(k1).resource.type.coding.Count() > 0) &amp;&amp; (source.entry.(k1).resource.type.coding.GetAt(1).code = "10164-2") &amp;&amp; &apos;(##class(HS.FHIR.DTL.Util.HC.Transform).ShouldSkip(source.entry.(k1).resource, .aux))'> 
<true>
<assign value='target.IllnessHistories.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.IllnessHistory).%New()' property='tmp' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Composition.IllnessHistory",source.entry.(k1).resource,.tmp,.aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.IllnessHistories' action='set' key='index'  >
<annotation>
<![CDATA[ List of past history entries for this patient
Note: A Composition will create an IllnessHistory streamlet if it has a 'type' element with a 'code' value of "10164-2". ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='&apos;aux("isContained")'> 
<true>
<assign value='prevSourceResource' property='aux("sourceResource")' action='set' />
</true> 
</if>
</transform>
}

}

Class HS.FHIR.vCommon.SearchTableBuilder
{

/// Given a resource type and a search parameter code, returns true if the
/// index for that search param should be a bitmap, and false otherwise.
ClassMethod IndexIsBitmap(pBase As %String, pCode As %String, pForceRebuild As %Boolean = 0) As %Boolean
{
	if ('$D(%BitmapIndices))||(pForceRebuild) {
		set %BitmapIndices("Account.status") = ""
		set %BitmapIndices("Account.type") = ""
		set %BitmapIndices("AllergyIntolerance.category") = ""
		set %BitmapIndices("AllergyIntolerance.criticality") = ""
		set %BitmapIndices("AllergyIntolerance.severity") = ""
		set %BitmapIndices("AllergyIntolerance.status") = ""
		set %BitmapIndices("AllergyIntolerance.type") = ""
		set %BitmapIndices("Appointment.part-status") = ""
		set %BitmapIndices("Appointment.status") = ""
		set %BitmapIndices("AppointmentResponse.part-status") = ""
		set %BitmapIndices("AuditEvent.action") = ""
		set %BitmapIndices("AuditEvent.object-type") = ""
		set %BitmapIndices("AuditEvent.subtype") = ""
		set %BitmapIndices("AuditEvent.type") = ""
		set %BitmapIndices("Binary.contenttype") = ""
		set %BitmapIndices("Bundle.type") = ""
		set %BitmapIndices("CarePlan.relatedcode") = ""
		set %BitmapIndices("Claim.priority") = ""
		set %BitmapIndices("Claim.use") = ""
		set %BitmapIndices("ClinicalImpression.status") = ""
		set %BitmapIndices("Communication.category") = ""
		set %BitmapIndices("Communication.medium") = ""
		set %BitmapIndices("Communication.status") = ""
		set %BitmapIndices("CommunicationRequest.category") = ""
		set %BitmapIndices("CommunicationRequest.medium") = ""
		set %BitmapIndices("CommunicationRequest.priority") = ""
		set %BitmapIndices("CommunicationRequest.status") = ""
		set %BitmapIndices("Composition.confidentiality") = ""
		set %BitmapIndices("Composition.status") = ""
		set %BitmapIndices("ConceptMap.status") = ""
		set %BitmapIndices("Condition.category") = ""
		set %BitmapIndices("Condition.clinicalstatus") = ""
		set %BitmapIndices("Condition.severity") = ""
		set %BitmapIndices("Conformance.event") = ""
		set %BitmapIndices("Conformance.format") = ""
		set %BitmapIndices("Conformance.mode") = ""
		set %BitmapIndices("Conformance.resource") = ""
		set %BitmapIndices("Conformance.security") = ""
		set %BitmapIndices("Conformance.status") = ""
		set %BitmapIndices("Coverage.type") = ""
		set %BitmapIndices("DataElement.status") = ""
		set %BitmapIndices("DataElement.stringency") = ""
		set %BitmapIndices("DetectedIssue.category") = ""
		set %BitmapIndices("DeviceMetric.category") = ""
		set %BitmapIndices("DiagnosticOrder.event-status") = ""
		set %BitmapIndices("DiagnosticOrder.item-past-status") = ""
		set %BitmapIndices("DiagnosticOrder.item-status") = ""
		set %BitmapIndices("DiagnosticOrder.status") = ""
		set %BitmapIndices("DiagnosticReport.category") = ""
		set %BitmapIndices("DiagnosticReport.status") = ""
		set %BitmapIndices("DocumentManifest.status") = ""
		set %BitmapIndices("DocumentReference.facility") = ""
		set %BitmapIndices("DocumentReference.format") = ""
		set %BitmapIndices("DocumentReference.language") = ""
		set %BitmapIndices("DocumentReference.relation") = ""
		set %BitmapIndices("DocumentReference.status") = ""
		set %BitmapIndices("Encounter.participant-type") = ""
		set %BitmapIndices("Encounter.special-arrangement") = ""
		set %BitmapIndices("Encounter.status") = ""
		set %BitmapIndices("Encounter.type") = ""
		set %BitmapIndices("EpisodeOfCare.status") = ""
		set %BitmapIndices("EpisodeOfCare.type") = ""
		set %BitmapIndices("FamilyMemberHistory.gender") = ""
		set %BitmapIndices("FamilyMemberHistory.relationship") = ""
		set %BitmapIndices("Goal.category") = ""
		set %BitmapIndices("Goal.status") = ""
		set %BitmapIndices("Group.actual") = ""
		set %BitmapIndices("Group.exclude") = ""
		set %BitmapIndices("Group.type") = ""
		set %BitmapIndices("HealthcareService.servicecategory") = ""
		set %BitmapIndices("HealthcareService.servicetype") = ""
		set %BitmapIndices("ImagingObjectSelection.title") = ""
		set %BitmapIndices("ImagingStudy.modality") = ""
		set %BitmapIndices("Immunization.notgiven") = ""
		set %BitmapIndices("Immunization.reason") = ""
		set %BitmapIndices("Immunization.reason-not-given") = ""
		set %BitmapIndices("Immunization.status") = ""
		set %BitmapIndices("ImmunizationRecommendation.status") = ""
		set %BitmapIndices("ImplementationGuide.experimental") = ""
		set %BitmapIndices("ImplementationGuide.status") = ""
		set %BitmapIndices("List.empty-reason") = ""
		set %BitmapIndices("List.status") = ""
		set %BitmapIndices("Location.address-country") = ""
		set %BitmapIndices("Location.address-state") = ""
		set %BitmapIndices("Location.address-use") = ""
		set %BitmapIndices("Location.status") = ""
		set %BitmapIndices("Media.subtype") = ""
		set %BitmapIndices("Media.type") = ""
		set %BitmapIndices("MedicationAdministration.notgiven") = ""
		set %BitmapIndices("MedicationAdministration.status") = ""
		set %BitmapIndices("MedicationDispense.status") = ""
		set %BitmapIndices("MedicationDispense.type") = ""
		set %BitmapIndices("MedicationOrder.status") = ""
		set %BitmapIndices("MedicationStatement.status") = ""
		set %BitmapIndices("MessageHeader.code") = ""
		set %BitmapIndices("MessageHeader.event") = ""
		set %BitmapIndices("NamingSystem.id-type") = ""
		set %BitmapIndices("NamingSystem.kind") = ""
		set %BitmapIndices("NamingSystem.status") = ""
		set %BitmapIndices("NamingSystem.type") = ""
		set %BitmapIndices("NutritionOrder.status") = ""
		set %BitmapIndices("Observation.category") = ""
		set %BitmapIndices("Observation.component-data-absent-reason") = ""
		set %BitmapIndices("Observation.data-absent-reason") = ""
		set %BitmapIndices("Observation.related-type") = ""
		set %BitmapIndices("Observation.status") = ""
		set %BitmapIndices("OperationDefinition.instance") = ""
		set %BitmapIndices("OperationDefinition.kind") = ""
		set %BitmapIndices("OperationDefinition.status") = ""
		set %BitmapIndices("OperationDefinition.system") = ""
		set %BitmapIndices("OperationDefinition.type") = ""
		set %BitmapIndices("OrderResponse.code") = ""
		set %BitmapIndices("Organization.active") = ""
		set %BitmapIndices("Organization.address-country") = ""
		set %BitmapIndices("Organization.address-state") = ""
		set %BitmapIndices("Organization.address-use") = ""
		set %BitmapIndices("Organization.type") = ""
		set %BitmapIndices("Patient.active") = ""
		set %BitmapIndices("Patient.address-country") = ""
		set %BitmapIndices("Patient.address-state") = ""
		set %BitmapIndices("Patient.address-use") = ""
		set %BitmapIndices("Patient.deceased") = ""
		set %BitmapIndices("Patient.ethnicity") = ""
		set %BitmapIndices("Patient.gender") = ""
		set %BitmapIndices("Patient.language") = ""
		set %BitmapIndices("Person.address-country") = ""
		set %BitmapIndices("Person.address-state") = ""
		set %BitmapIndices("Person.address-use") = ""
		set %BitmapIndices("Person.gender") = ""
		set %BitmapIndices("Practitioner.address-country") = ""
		set %BitmapIndices("Practitioner.address-state") = ""
		set %BitmapIndices("Practitioner.address-use") = ""
		set %BitmapIndices("Practitioner.communication") = ""
		set %BitmapIndices("Practitioner.gender") = ""
		set %BitmapIndices("ProcessRequest.action") = ""
		set %BitmapIndices("Provenance.entitytype") = ""
		set %BitmapIndices("Provenance.sigtype") = ""
		set %BitmapIndices("Questionnaire.status") = ""
		set %BitmapIndices("QuestionnaireResponse.status") = ""
		set %BitmapIndices("ReferralRequest.priority") = ""
		set %BitmapIndices("ReferralRequest.status") = ""
		set %BitmapIndices("RelatedPerson.address-country") = ""
		set %BitmapIndices("RelatedPerson.address-state") = ""
		set %BitmapIndices("RelatedPerson.address-use") = ""
		set %BitmapIndices("RelatedPerson.gender") = ""
		set %BitmapIndices("Schedule.type") = ""
		set %BitmapIndices("SearchParameter.base") = ""
		set %BitmapIndices("SearchParameter.target") = ""
		set %BitmapIndices("SearchParameter.type") = ""
		set %BitmapIndices("Slot.fb-type") = ""
		set %BitmapIndices("Slot.slot-type") = ""
		set %BitmapIndices("Specimen.container") = ""
		set %BitmapIndices("StructureDefinition.abstract") = ""
		set %BitmapIndices("StructureDefinition.context-type") = ""
		set %BitmapIndices("StructureDefinition.experimental") = ""
		set %BitmapIndices("StructureDefinition.kind") = ""
		set %BitmapIndices("StructureDefinition.status") = ""
		set %BitmapIndices("StructureDefinition.type") = ""
		set %BitmapIndices("Subscription.status") = ""
		set %BitmapIndices("Subscription.type") = ""
		set %BitmapIndices("Substance.category") = ""
		set %BitmapIndices("SupplyDelivery.status") = ""
		set %BitmapIndices("SupplyRequest.kind") = ""
		set %BitmapIndices("SupplyRequest.status") = ""
		set %BitmapIndices("ValueSet.status") = ""
		do ..IndexIsBitmapManualChanges(.%BitmapIndices)
	}
	quit $D(%BitmapIndices(pBase_"."_pCode))
}

/// At some point in the future, it may be possible for users may to make their
/// own changes to the list of search parameters that get bitmap indexed. One
/// possible way this could be done is by extending this class, overriding this
/// method, and making the desired changes to the input array. For right now
/// though, this method is just a placeholder and a no-op.
ClassMethod IndexIsBitmapManualChanges(ByRef pBitmapIndices)
{
	// kill pBitmapIndices("Foo.bar")
	// set pBitmapIndices("Sna.fu") = ""
	quit
}

ClassMethod GenSearchTablesFromArrayInternal(ByRef pArray As %Library.RawString, pAbstractClass As %String, pNumericScale As %Integer, pModelPackage As %String, pVerbose As %Boolean = 1) As %Status
{
	
	
	
	try {
		set tSC = $$$OK
				
		set tSearchTablePackage = $PARAMETER(pAbstractClass, "SEARCHTABLEPACKAGE")
		
		// flag "e" = Delete Extent
		// flag "d" = Display
		set tFlags = "e"
		if ('pVerbose) { set tFlags = tFlags_"-d" }
		
		write !, "Deleting "_tSearchTablePackage_".*... "
		set tSC = $system.OBJ.DeletePackage(tSearchTablePackage,tFlags)
		
		quit:$$$ISERR(tSC)
		write "Done."
		write !, "Generating "_tSearchTablePackage_".*... " 
		
		// Find the "base" resource, or create one if it does not exist. The "base" resource
		// contains search params common to all resource types. Then add to it the searchParams 
		// belonging to the "rest" (de-duplicating on name) as these are also common to all
		// resource types.
		
		//**
		//set tResourceType = pArray("resourceType")
		set tResourceName=""
		set tResourceName = $order(pArray("resources",tResourceName))
		while tResourceName'="" {
			
			set tOrigParamName = ""
			set tOrigParamName = $order(pArray("resources",tResourceName,"searchParam",tOrigParamName))
			if tOrigParamName ="" {
				write !, "No search params found for resource type '"_tResourceType_"'. Search table will not be generated."
				set resIt=$order(pData("resources",resIt))
				continue
			}
			write:pVerbose !, "Resource type: "_tResourceName
			
			// Create the class definition for the search table for this type
			set tSearchTableName = tSearchTablePackage_"."_tResourceName
			set tSearchTableDef = ##class(%Dictionary.ClassDefinition).%New(tSearchTableName)
			set tSearchTableDef.Super = "%Library.Persistent"
			set tSearchTableDef.GeneratedBy = $CLASSNAME()_".CLS"
			do tSearchTableDef.ProcedureBlockReset()
			//--------
			
			while tOrigParamName '="" {
				
	
			set tParamName = $classmethod(pAbstractClass, "NormalizeParamName", tOrigParamName)			
			set tParamType = pArray("resources",tResourceName,"searchParam",tOrigParamName,"type")
				
				// Quantities are handled differently from other param types.
				if (tParamType = "quantity") {
					set tQuantityTableName = tSearchTableName_"."_tParamName
					// Create a new table that references the current table as a foreign key
					set tQuantityTableDef = ##class(%Dictionary.ClassDefinition).%New(tQuantityTableName)
					set tQuantityTableDef.Super = "%Persistent"
					set tQuantityTableDef.GeneratedBy = $CLASSNAME()_".CLS"
					// Create the property constrained by the foreign key
					set tFKeyPropDef = ##class(%Dictionary.PropertyDefinition).%New()
					set tFKeyPropDef.Name = "ResourceLogicalId"
					set tFKeyPropDef.Type = "%Integer"
					do tQuantityTableDef.Properties.Insert(tFKeyPropDef)
					// Create the foreign key
					set tForeignKeyDef = ##class(%Dictionary.ForeignKeyDefinition).%New()
					set tForeignKeyDef.Name = "ResourceLogicalIdFKey"
					set tForeignKeyDef.Properties = "ResourceLogicalId"
					set tForeignKeyDef.ReferencedClass = tSearchTableName
					set tForeignKeyDef.OnDelete = "cascade"
					do tQuantityTableDef.ForeignKeys.Insert(tForeignKeyDef)
					// Create the property + index for value (numeric part of the quantity)
					set tNumPropDef = ##class(%Dictionary.PropertyDefinition).%New()
					set tNumPropDef.Name = "value"
					set tNumPropDef.Type = "%Numeric"
					do tNumPropDef.Parameters.SetAt(pNumericScale,"SCALE")
					do tQuantityTableDef.Properties.Insert(tNumPropDef)
					set tNumPropIndexDef = ##class(%Dictionary.IndexDefinition).%New()
					set tNumPropIndexDef.Name = "valueIdx"
					set tNumPropIndexDef.Properties = "value"
					do tQuantityTableDef.Indices.Insert(tNumPropIndexDef)
					// Create the property + index for units
					set tUnitPropDef = ##class(%Dictionary.PropertyDefinition).%New()
					set tUnitPropDef.Name = "unit"
					set tUnitPropDef.Collection = "list"
					set tUnitPropDef.Type = "%String"
					do tUnitPropDef.Parameters.SetAt("", "MAXLEN")
					do tQuantityTableDef.Properties.Insert(tUnitPropDef)
					set tUnitPropIndexDef = ##class(%Dictionary.IndexDefinition).%New()
					set tUnitPropIndexDef.Name = "unitIdx"
					set tUnitPropIndexDef.Properties = "unit(ELEMENTS)"
					set tUnitPropIndexDef.Type = "bitmap"
					do tQuantityTableDef.Indices.Insert(tUnitPropIndexDef)
					
					set tParamName = "ResourceLogicalId"
					set tIndexDefId = tQuantityTableName_"||"_tParamName_"Idx"
					set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
					set tIndexDef.Name = tParamName_"Idx"
					set tIndexDef.Properties = tParamName
					do tQuantityTableDef.Indices.Insert(tIndexDef)
					
					set tSC = tQuantityTableDef.%Save() quit:$$$ISERR(tSC)
				}
				else {
					// If this search param searches a period property, we want to
					// make *two* properties and indices, one for the start time and
					// one for the end time.
					if ($CLASSMETHOD(pAbstractClass, "ParamSearchesPeriod", tResourceName, tOrigParamName)) {
						set tParamList = tParamName_$PARAMETER(pAbstractClass, "PERIODSTARTSUFFIX")_"^"_tParamName_$PARAMETER(pAbstractClass, "PERIODENDSUFFIX")
					}
					else { set tParamList = tParamName }
					for tK=1:1:$L(tParamList,"^") {
						set tOneParamName = $P(tParamList,"^",tK)
						set tPropDefId = tSearchTableName_"||"_tOneParamName
						set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
						set tPropDef.Name = tOneParamName
						do tSearchTableDef.Properties.Insert(tPropDef)
						if (tParamType="number") { 
							set tPropDef.Type = "%Numeric"
							do tPropDef.Parameters.SetAt(pNumericScale,"SCALE")
						}
						// Use the FHIR string type instead of %String to get around MAXLEN issues
						else { set tPropDef.Type = pModelPackage_".Datatype.StringPrimitive" }
						// Search on URIs uses exact matching. See http://hl7.org/fhir/search.html#uri
						if (tParamType="uri") {
							do tPropDef.Parameters.SetAt("EXACT","COLLATION")
						}
						set tPropDef.Collection = "list"
						
						set tIndexDefId = tSearchTableName_"||"_tOneParamName_"Idx"
						set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
						set tIndexDef.Name = tOneParamName_"Idx"
						do tSearchTableDef.Indices.Insert(tIndexDef)			
						set tIndexDef.Properties = tOneParamName_"(ELEMENTS)"
						if ..IndexIsBitmap(tResourceName, tOrigParamName) { set tIndexDef.Type = "bitmap" }
					}
				}
				set tOrigParamName = $order(pArray("resources",tResourceName,"searchParam",tOrigParamName))
			}
			// Additionally, make a property referencing the original resource and index on it
			set tParamName = "ResourceLogicalId"
			set tPropDefId = tSearchTableName_"||"_tParamName
			set tPropDef = ##class(%Dictionary.PropertyDefinition).%New()
			set tPropDef.Name = tParamName
			set tPropDef.Type = pAbstractClass
			do tSearchTableDef.Properties.Insert(tPropDef)
			
			set tIndexDefId = tSearchTableName_"||"_tParamName_"Idx"
			set tIndexDef = ##class(%Dictionary.IndexDefinition).%New()
			set tIndexDef.Name = tParamName_"Idx"
			set tIndexDef.Properties = tParamName
			set tIndexDef.IdKey = 1
			do tSearchTableDef.Indices.Insert(tIndexDef)
			
			set tSC = tSearchTableDef.%Save() quit:$$$ISERR(tSC)
					
			set tResourceName = $order(pArray("resources",tResourceName))
		}
			//**
		//end main loop
		// If no "base" resource was found, create one and insert it into the "rest"
		
			
			
		
		quit:$$$ISERR(tSC)
		write "Done."
		set tFlags = ""
		if ('pVerbose) { set tFlags = tFlags_"-d" }
		
		write !, "Compiling "_tSearchTablePackage_".*... "
		set tSC = $system.OBJ.CompilePackage(tSearchTablePackage,tFlags)
		
		quit:$$$ISERR(tSC)
		write "Done."
	}
	catch (ex) { set tSC = ex.AsStatus() }
	if ($$$ISERR(tSC)) { write !, $system.Status.GetOneErrorText(tSC) }
	quit tSC
}

}

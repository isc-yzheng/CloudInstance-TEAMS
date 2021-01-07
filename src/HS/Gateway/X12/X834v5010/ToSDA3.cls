Class HS.Gateway.X12.X834v5010.ToSDA3 Extends %RegisteredObject
{

/// Used to override non-id fields
ClassMethod Override(target As %ListOfObjects, override As HS.Gateway.X12.X834v5010.SDA3Override) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If target="" || override="" Quit
			
		For i=1:1:target.Count() {
			#Dim tContainer As HS.SDA3.Container = target.GetAt(i)
			#Dim tMemberLevelDetail As HS.Gateway.X12.X834v5010.MemberLevelDetail = ""
			If (override.MemberLevelDetails'="") && (override.MemberLevelDetails.Count()>=i) {
				Set tMemberLevelDetail = override.MemberLevelDetails.GetAt(i)
			}
			If tMemberLevelDetail'="" {
				Set:tMemberLevelDetail.Race tContainer.Patient.Race.Code = tMemberLevelDetail.Race
				Set:tMemberLevelDetail.PrimaryLanguage tContainer.Patient.PrimaryLanguage.Code = tMemberLevelDetail.PrimaryLanguage
				
				For j=1:1:tContainer.MemberEnrollments.Count() {
					#Dim tMemberEnrollment As HS.SDA3.MemberEnrollment = tContainer.MemberEnrollments.GetAt(j)
					#Dim tHealthCoverage As HS.Gateway.X12.X834v5010.HealthCoverage = ""
					If (tMemberLevelDetail.HealthCoverages'="") && (tMemberLevelDetail.HealthCoverages.Count()>=j) {
						Set tHealthCoverage = tMemberLevelDetail.HealthCoverages.GetAt(j)
					}
					If tHealthCoverage'="" {
						Set:tHealthCoverage.NationalPlanID tMemberEnrollment.NationalPlanID = tHealthCoverage.NationalPlanID
				
						Set:'tHealthCoverage.PrimaryCareProvider.%IsNull() tMemberEnrollment.PrimaryCareProvider = tHealthCoverage.PrimaryCareProvider
						Set:'tHealthCoverage.PrimaryCareFacility.%IsNull() tMemberEnrollment.PrimaryCareFacility = tHealthCoverage.PrimaryCareFacility
					}
				} // For j
			}
		} // For i
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Transform a 834 X12 document to a list of SDA messages
ClassMethod Transform(source As EnsLib.EDI.X12.Document, override As HS.Gateway.X12.X834v5010.SDA3Override = "", Output target As %ListOfObjects) As %Status
{
	Set tSC=$$$OK
	
	Try {
		Do source.PokeDocType("HIPAA_5010:834")
		
		Set target = ##class(%ListOfObjects).%New()
	
		Set actionCode = source.GetValueAt("BGN:ActionCode")
		
		Set payerEntityIdCode = source.GetValueAt("loop1000B.N1:EntityIdentifierCode")
		Set payerName = source.GetValueAt("loop1000B.N1:Name")
		Set payerIdCodeQualifier = source.GetValueAt("loop1000B.N1:IdentificationCodeQualifier")
		Set payerIdCode = source.GetValueAt("loop1000B.N1:IdentificationCode")
		If (override'="") && (override.PayerId'="") {
			Set payerIdCode = override.PayerId
		}
		
		// Patients
		Set tNextPatient = ""
		For {
			Set tNextPatient = source.GetNextIndex("loop2000()", tNextPatient, .tSC)
			Quit:($$$ISERR(tSC))||(tNextPatient="")
			
			// Id overides
			Set subscriberIdOR = ""
			Set memberGroupOrPolicyNumberOR = ""
			Set memberIdOR = ""
			If override'="" && (override.MemberLevelDetails.Count()>=tNextPatient) {
				#Dim memberLevelDetail As HS.Gateway.X12.X834v5010.MemberLevelDetail = override.MemberLevelDetails.GetAt(tNextPatient)
				Set subscriberIdOR = memberLevelDetail.SubscriberId
				Set memberGroupOrPolicyNumberOR = memberLevelDetail.MemberGroupOrPolicyNumber
				Set memberIdOR = memberLevelDetail.MemberId
			}
			
			Set loop2000 = "loop2000("_tNextPatient_")"
			
			Set tContainer = ##class(HS.SDA3.Container).%New()
		
			// Yes/No Condition or Response Code
			Set memberIndicator = source.GetValueAt(loop2000_".INS:YesNoConditionorResponseCode")
			
			// Individual Relationship Code
			Set relationShipCode = source.GetValueAt(loop2000_".INS:IndividualRelationshipCode")
			
			Set typeCode = source.GetValueAt(loop2000_".INS:MaintenanceTypeCode")
			Set reasonCode = source.GetValueAt(loop2000_".INS:MaintenanceReasonCode")
			Set medicarePlanCode = source.GetValueAt(loop2000_".INS:MedicareStatusCode")
			
			// Different organization interpret REF loops differently. We make some assumptions here.
			// Assume loop2000().REF(1) contain "Subscriber Identifier"
			Set subscriberId = source.GetValueAt(loop2000_".REF(1):RefId")
			Set:subscriberIdOR'="" subscriberId = subscriberIdOR
				
			// Assume loop2000().REF(2) contain "Member Policy Number"
			Set memberGroupOrPolicyNumber = source.GetValueAt(loop2000_".REF(2):RefId")
			Set:memberGroupOrPolicyNumberOR'="" memberGroupOrPolicyNumber = memberGroupOrPolicyNumberOR
			
			// Assume loop2000().loop2100A.NM1:IdentificationCode contain "Member Identifier"
			Set memberId = source.GetValueAt(loop2000_".loop2100A.NM1:IdentificationCode")
			Set:memberIdOR'="" memberId = memberIdOR
			
			// Patient number (payerId + memberId)
			Set tPatientNumber = ##class(HS.SDA3.PatientNumber).%New()
			Set tPatientNumber.Organization.Code = payerIdCode
			Set tPatientNumber.Number = memberId
			Set tPatientNumber.NumberType = "MRN"
			Set tSC = tContainer.Patient.PatientNumbers.Insert(tPatientNumber)
			Quit:$$$ISERR(tSC)
			
			// This element will contain the following values:
			// 356 — Eligibility begin. The date that follows applies to members currently reported as an “ADD” enrollment status.
			// 357 — Eligibility end. The date that follows applies to members currently reported as a “DISENROLL”. The date reported in DTP03 will reflect the true eligibility end effective date.
			Set tEligibilityBegin = ""
			Set tEligibilityEnd = ""
			Set tNextTime = ""
			For {
				Set tNextTime = source.GetNextIndex(loop2000_".DTP()", tNextTime, .tSC)
				Quit:($$$ISERR(tSC))||(tNextTime="")
			
				Set loopDTP = loop2000_".DTP("_tNextTime_")"
				
				Set dateTimeQualifier = source.GetValueAt(loopDTP_":DateTimeQualifier")
				Set dateTimePeriod = source.GetValueAt(loopDTP_":DateTimePeriod")
				
				Set:"356"=dateTimeQualifier tEligibilityBegin = dateTimePeriod
				Set:"357"=dateTimeQualifier tEligibilityEnd = dateTimePeriod
			}
			
			// Name
			Set tContainer.Patient.Name.FamilyName = source.GetValueAt(loop2000_".loop2100A.NM1:NameLastorOrganizationName")
			Set tContainer.Patient.Name.GivenName = source.GetValueAt(loop2000_".loop2100A.NM1:NameFirst")
			Set tContainer.Patient.Name.MiddleName = source.GetValueAt(loop2000_".loop2100A.NM1:NameMiddle")
			Set tContainer.Patient.Name.NamePrefix = source.GetValueAt(loop2000_".loop2100A.NM1:NamePrefix")
			Set tContainer.Patient.Name.NameSuffix = source.GetValueAt(loop2000_".loop2100A.NM1:NameSuffix")
			
			// Contact Info (PER)
			Set loopPER = loop2000_".loop2100A.PER"
			Set emailAddress = "" 
			Set homePhoneNumber = ""
			Set mobilePhoneNumber = ""
			Set workPhoneNumber = ""
			Set communicationNumberQualifier = source.GetValueAt(loopPER_":CommunicationNumberQualifier")
			Set communicationNumber = source.GetValueAt(loopPER_":CommunicationNumber")
				
			Set:"EM"=communicationNumberQualifier emailAddress = communicationNumber
			Set:"CP"=communicationNumberQualifier mobilePhoneNumber = communicationNumber
			Set:"HP"=communicationNumberQualifier homePhoneNumber = communicationNumber
			Set:"WP"=communicationNumberQualifier workPhoneNumber = communicationNumber
	
			Set tContainer.Patient.ContactInfo.EmailAddress = emailAddress
			Set tContainer.Patient.ContactInfo.HomePhoneNumber = homePhoneNumber
			Set tContainer.Patient.ContactInfo.MobilePhoneNumber = mobilePhoneNumber
			Set tContainer.Patient.ContactInfo.WorkPhoneNumber = workPhoneNumber
			
			// Residence address
			Do source.GetSegmentIndex(loop2000_".loop2100A.N3", .st1)
			Do source.GetSegmentIndex(loop2000_".loop2100A.N4", .st2)
			// At least one segment exists
			If $$$ISOK(st1) || $$$ISOK(st2) {
				Set tAddress = ##class(HS.SDA3.Address).%New()
				Set tAddress.Street = source.GetValueAt(loop2000_".loop2100A.N3:AddressInformation")
				Set tAddress.City.Code = source.GetValueAt(loop2000_".loop2100A.N4:CityName")
				Set tAddress.State.Code = source.GetValueAt(loop2000_".loop2100A.N4:StateorProvinceCode")
				Set tAddress.Zip.Code = source.GetValueAt(loop2000_".loop2100A.N4:PostalCode")
				Set tAddress.Country.Code = source.GetValueAt(loop2000_".loop2100A.N4:CountryCode")
				Set tSC = tContainer.Patient.Addresses.Insert(tAddress)
				Quit:$$$ISERR(tSC)
			}
			
			// Member demographics
			Set birthDate = source.GetValueAt(loop2000_".loop2100A.DMG:DateTimePeriod")
			Set:birthDate'="" tContainer.Patient.BirthTime = $ZDATETIME($ZDATETIMEH(birthDate, 8), 3)
			Set tContainer.Patient.Gender.Code = source.GetValueAt(loop2000_".loop2100A.DMG:GenderCode")
			Set tContainer.Patient.MaritalStatus.Code = source.GetValueAt(loop2000_".loop2100A.DMG:MaritalStatusCode")
			#if $system.Version.GetMajor() <= 2014
				Set race = source.GetValueAt(loop2000_".loop2100A.DMG:RaceOrEthnicity")
			#else // 2015.1 or later
				Set race = source.GetValueAt(loop2000_".loop2100A.DMG:CompositeRaceorEthnicityInfo")
			#endif					
			Set tContainer.Patient.Race.Code = $P(race, ":")
			
			Set tContainer.Patient.Citizenship.Code = source.GetValueAt(loop2000_".loop2100A.DMG:CitizenshipStatusCode")
			
			// Primary language
			// Assume in loop2000().loop2100A.LUI(1)
			Set tContainer.Patient.PrimaryLanguage.Code = source.GetValueAt(loop2000_".loop2100A.LUI(1):IdentificationCode")
			Set desc = source.GetValueAt(loop2000_".loop2100A.LUI(1):Description")
			Set:desc'="" tContainer.Patient.PrimaryLanguage.Description = desc
			
			// Mailing address
			Do source.GetSegmentIndex(loop2000_".loop2100C.N3", .st1)
			Do source.GetSegmentIndex(loop2000_".loop2100C.N4", .st2)
			// At least one segment exists
			If $$$ISOK(st1) || $$$ISOK(st2) {
				Set tMailingAddress = ##class(HS.SDA3.Address).%New()
				Set tMailingAddress.Street = source.GetValueAt(loop2000_".loop2100C.N3:AddressInformation")
				Set tMailingAddress.City.Code = source.GetValueAt(loop2000_".loop2100C.N4:CityName")
				Set tMailingAddress.State.Code = source.GetValueAt(loop2000_".loop2100C.N4:StateorProvinceCode")
				Set tMailingAddress.Zip.Code = source.GetValueAt(loop2000_".loop2100C.N4:PostalCode")
				Set tMailingAddress.Country.Code = source.GetValueAt(loop2000_".loop2100C.N4:CountryCode")
				Set tSC = tContainer.Patient.Addresses.Insert(tMailingAddress)
				Quit:$$$ISERR(tSC)
			}
			
			// loop2000().loop2300()
			Set tNextEnrollment = ""
			For {
				Set tNextEnrollment = source.GetNextIndex(loop2000_".loop2300()", tNextEnrollment, .tSC)
				Quit:($$$ISERR(tSC))||(tNextEnrollment="")
				
				Set loop2300 = loop2000_".loop2300("_tNextEnrollment_")"
				
				// MaintenanceTypeCode (Action Code)
				Set maintenanceTypeCode = source.GetValueAt(loop2300_".HD:MaintenanceTypeCode")
				
				Set insuranceLineCode = source.GetValueAt(loop2300_".HD:InsuranceLineCode")
				Set coverageLevelCode = source.GetValueAt(loop2300_".HD:CoverageLevelCode")
				
				// Benefit period
				// 348 Benefit Begin
				// 349 Benefit End
				Set tBenefitBegin = ""
				Set tBenefitEnd = ""
				Set tNextTime = ""
				For {
					Set tNextTime = source.GetNextIndex(loop2300_".DTP()", tNextTime, .tSC)
					Quit:($$$ISERR(tSC))||(tNextTime="")
			
					Set loopDTP = loop2300_".DTP("_tNextTime_")"
				
					Set dateTimeQualifier = source.GetValueAt(loopDTP_":DateTimeQualifier")
					Set dateTimePeriod = source.GetValueAt(loopDTP_":DateTimePeriod")
				
					Set:"348"=dateTimeQualifier tBenefitBegin = dateTimePeriod
					Set:"349"=dateTimeQualifier tBenefitEnd = dateTimePeriod
				}
				// Used to determine a unique MemberEnrollmentNumber
				Set coveragePeriod = tBenefitBegin_tBenefitEnd
				
				// Coverage policy number: loop2000().loop2300().REF(1):RefId
				Set coveragePolicyNumber = source.GetValueAt(loop2300_".REF(1):RefId")
			
				// Set MemberEnrollment
				Set tMemberEnrollment = ##class(HS.SDA3.MemberEnrollment).%New()
			
				// Action Code
				// Only set for Delete
				Set:"002"=maintenanceTypeCode tMemberEnrollment.ActionCode = "D"
				
				Set tMemberEnrollment.Source = "834"
				Set tMemberEnrollment.MemberEnrollmentNumber = payerIdCode_subscriberId_memberId_insuranceLineCode_coveragePeriod
				Set tMemberEnrollment.IndividualRelationshipCode.Code = relationShipCode
				Set tMemberEnrollment.InsuredGroupOrPolicyNumber = memberGroupOrPolicyNumber
				Set tMemberEnrollment.PlanSpecificSubscriberID = subscriberId
				Set tMemberEnrollment.NationalPlanID = coveragePolicyNumber
				Set:""'=tBenefitBegin tMemberEnrollment.FromTime = $ZDATETIME($ZDATETIMEH(tBenefitBegin, 8), 3)
				Set:""'=tBenefitEnd tMemberEnrollment.ToTime = $ZDATETIME($ZDATETIMEH(tBenefitEnd, 8), 3)
			
				// HealthFund
				Set tMemberEnrollment.HealthFund.MembershipNumber = coveragePolicyNumber
				Set tMemberEnrollment.HealthFund.PlanType = insuranceLineCode
				Set:""'=tBenefitBegin tMemberEnrollment.HealthFund.FromTime = $ZDATETIME($ZDATETIMEH(tBenefitBegin, 8), 3)
				Set:""'=tBenefitEnd tMemberEnrollment.HealthFund.ToTime = $ZDATETIME($ZDATETIMEH(tBenefitEnd, 8), 3)
				 
				// Primary Care Provider
				// Assume in loop2000().loop2300().loop2310(1)
				Set loopPCP = loop2300_".loop2310(1)"
				Set tMemberEnrollment.PrimaryCareProvider.Code = source.GetValueAt(loopPCP_".NM1:EntityIdentifierCode")
				Set tMemberEnrollment.PrimaryCareProvider.IdentifierTypeCode = source.GetValueAt(loopPCP_".NM1:IdentificationCodeQualifier")
				Set tMemberEnrollment.PrimaryCareProvider.Name.FamilyName = source.GetValueAt(loopPCP_".NM1:NameLastorOrganizationName")
				Set tMemberEnrollment.PrimaryCareProvider.Name.GivenName = source.GetValueAt(loopPCP_".NM1:NameFirst")
				Set tMemberEnrollment.PrimaryCareProvider.Name.MiddleName = source.GetValueAt(loopPCP_".NM1:NameMiddle")
				Set tMemberEnrollment.PrimaryCareProvider.Name.NamePrefix = source.GetValueAt(loopPCP_".NM1:NamePrefix")
				Set tMemberEnrollment.PrimaryCareProvider.Name.NameSuffix = source.GetValueAt(loopPCP_".NM1:NameSuffix")
			
				Set tMemberEnrollment.PrimaryCareProvider.Address.Street = source.GetValueAt(loopPCP_".N3(1):AddressInformation")
				Set tMemberEnrollment.PrimaryCareProvider.Address.City.Code = source.GetValueAt(loopPCP_".N4:CityName")
				Set tMemberEnrollment.PrimaryCareProvider.Address.State.Code = source.GetValueAt(loopPCP_".N4:StateProvinceCode")
				Set tMemberEnrollment.PrimaryCareProvider.Address.Zip.Code = source.GetValueAt(loopPCP_".N4:PostalCode")
				Set tMemberEnrollment.PrimaryCareProvider.Address.County.Code = source.GetValueAt(loopPCP_".N4.CountryCode")
			
				Set emailAddress = "" 
				Set homePhoneNumber = ""
				Set mobilePhoneNumber = ""
				Set workPhoneNumber = ""
				Set tNextCommunicationNumber = ""
				For {
					Set tCommunicationNumber = source.GetNextIndex(loopPCP_".PER()", tNextTime, .tSC)
					Quit:($$$ISERR(tSC))||(tNextTime="")
			
					Set loopPER = loopPCP_".PER("_tNextCommunicationNumber_")"
				
					Set communicationNumberQualifier = source.GetValueAt(loopDTP_":CommunicationNumberQualifier")
					Set communicationNumber = source.GetValueAt(loopDTP_":CommunicationNumber")
				
					Set:"EM"=communicationNumberQualifier emailAddress = communicationNumber
					Set:"CP"=communicationNumberQualifier mobilePhoneNumber = communicationNumber
					Set:"HP"=communicationNumberQualifier homePhoneNumber = communicationNumber
					Set:"WP"=communicationNumberQualifier workPhoneNumber = communicationNumber
				}
				Set tMemberEnrollment.PrimaryCareProvider.ContactInfo.EmailAddress = emailAddress
				Set tMemberEnrollment.PrimaryCareProvider.ContactInfo.HomePhoneNumber = homePhoneNumber
				Set tMemberEnrollment.PrimaryCareProvider.ContactInfo.MobilePhoneNumber = mobilePhoneNumber
				Set tMemberEnrollment.PrimaryCareProvider.ContactInfo.WorkPhoneNumber = workPhoneNumber
			
				// Add to MemberEnrollment list
				Set tSC = tContainer.MemberEnrollments.Insert(tMemberEnrollment)
				Quit:$$$ISERR(tSC)
			} // For Each Enrollment
			
			// Add to target
			Set tSC = target.Insert(tContainer)
			Quit:$$$ISERR(tSC)
			
			// Override
			Set:override'="" tSC = ..Override(target, override)
		} // For Each Patient
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Test method
ClassMethod TestTransform(pExtra As %Integer = 0) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	//Set tFile = "C:\InterSystems\X12\834\834_005010X220A1.X12"
	Set tFile = "C:\InterSystems\X12\834\Custom834TestHpf.EDI"
	
	Set tDoc = ##class(EnsLib.EDI.X12.Document).ImportFromFile(tFile,,.tSC)
	Quit:$$$ISERR(tSC) tSC
	
	// Test DTL pipeline
	#Dim tOverride As HS.Gateway.X12.X834v5010.SDA3Override = ""
	Set tSC = $ZOBJCLASSMETHOD("HS.Gateway.X12.DTLPipeline.Sample834v5010", "Transform", tDoc, .tOverride)
	Quit:$$$ISERR(tSC) tSC
	W !, "PayerId = ", tOverride.PayerId
	For i=1:1:tOverride.MemberLevelDetails.Count() {
		#Dim tMemberLevelDetail As HS.Gateway.X12.X834v5010.MemberLevelDetail = tOverride.MemberLevelDetails.GetAt(i)
		W !, "SubscribId = ", tMemberLevelDetail.SubscriberId, " MemberId = ", tMemberLevelDetail.MemberId	
		W !, "Race = ", tMemberLevelDetail.Race
		For j=1:1:tMemberLevelDetail.HealthCoverages.Count() {
			#Dim tHealthCoverage As HS.Gateway.X12.X834v5010.HealthCoverage = tMemberLevelDetail.HealthCoverages.GetAt(j)
			If pExtra {
				// Fake PrimaryCareProvider and PrimaryCareFacility of MemberEnrollments
				Set tHealthCoverage.PrimaryCareProvider.Code = "3628"
				Set tHealthCoverage.PrimaryCareProvider.Description = "Waddle, Lian"
				Set tHealthCoverage.PrimaryCareProvider.Name.FamilyName = "Waddle"
				Set tHealthCoverage.PrimaryCareProvider.Name.GivenName = "Lian"
				Set tHealthCoverage.PrimaryCareProvider.CareProviderType.Code = "FR"
				Set tHealthCoverage.PrimaryCareProvider.CareProviderType.Description = "Fellow/Resident"
		
				Set tHealthCoverage.PrimaryCareFacility.Code = "SDA"
				Set tHealthCoverage.PrimaryCareFacility.Organization.Code = "SDA"
				Set tHealthCoverage.PrimaryCareFacility.Organization.Description = "SDA Hospital"
			
				W !, "PCP = ", tHealthCoverage.PrimaryCareProvider.%IsNull(), "#", tHealthCoverage.PrimaryCareProvider.%IsModified()
			}
		} // For j
	} // For i
	
	Set pathValue = tDoc.Name_"#"_tDoc.TypeVersion_"#"_tDoc.DocTypeCategory_"#"_tDoc.DocTypeName
	W !, pathValue, !
		
	Set tSC = ..Transform(tDoc, tOverride, .tTarget)
	Quit:$$$ISERR(tSC) tSC
	
	Set count = tTarget.Count()
	For i=1:1:count {
		#Dim tContainer As HS.SDA3.Container = tTarget.GetAt(i)
		
		Set tXML = ""
		Set tSC = tContainer.ToQuickXMLString(.tXML)
		Quit:$$$ISERR(tSC)
		Write tXML, !
	}
	
	Quit tSC
}

}

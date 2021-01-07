Class HS.Gateway.X12.X837apPv5010.ToSDA3 Extends %RegisteredObject
{

ClassMethod ParseClaims(source As EnsLib.EDI.X12.Document, rootPath As %String, Output claims As %ListOfObjects) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set claims = ##class(%ListOfObjects).%New()
		
			// Claims
			Set tNextClaim = ""
			For {
				Set tNextClaim = source.GetNextIndex(rootPath_".loop2300()", tNextClaim, .tSC)
				Quit:($$$ISERR(tSC))||(tNextClaim="")
				
				Set loop2300 = rootPath_".loop2300("_tNextClaim_")"
				
				Set tClaim = ##class(HS.SDA3.MedicalClaim).%New()
				
				Set tClaim.MedicalClaimNumber = source.GetValueAt(loop2300_".CLM:ClaimSubmittersIdentifier")
			
				Set contractTypeCode = source.GetValueAt(loop2300_".CN1:ContractTypeCode")
				If "05"=contractTypeCode {
					Set tClaim.GlobalPaymentFlag = 1
				}
				
				Set indicator = source.GetValueAt(loop2300_".CLM:RelatedCausesInformation.RelatedCausesCode")
				//Set indicator = $P(indicator, ":")
				
				// AccidentIndicator
				If ("AA"=indicator) || ("OA"=indicator) {
					Set tClaim.AccidentIndicator = 1
				}
				
				//Set tClaim.Submitter = submitterId
				
				// EmploymentRelatedIndicator
				If "EM"=indicator {
					Set tClaim.EmploymentRelatedIndicator = 1
				}
				
				// PrincipalDiagnosis
				Set loopHI = loop2300_".HI(1)"
				Set diagnosis = source.GetValueAt(loopHI_":HealthCareCodeInformation")
				Set:diagnosis'="" tClaim.PrincipalDiagnosis.Code = diagnosis
				
				// OtherDiagnoses
				For i=2:1:12 {
					Set diagnosis = source.GetValueAt(loopHI_":HealthCareCodeInformation"_i)
					If diagnosis'="" {
						Set tDiagnosis = ##class(HS.SDA3.CodeTableDetail.Diagnosis).%New()
						Set tDiagnosis.Code = diagnosis
						Set tSC = tClaim.OtherDiagnoses.Insert(tDiagnosis)
						Quit:$$$ISERR(tSC)
					}
				}
				
				//Set tClaim.Subscriber = subscribers.GetAt(hParentIDNumber)
				
				// Service lines
				Set tNextLine = ""
				For {
					Set tNextLine = source.GetNextIndex(loop2300_".loop2400()", tNextLine, .tSC)
					Quit:($$$ISERR(tSC))||(tNextLine="")
					
					Set loop2400 = loop2300_".loop2400("_tNextLine_")"
					
					Set tClaimLine = ##class(HS.SDA3.MedicalClaimLine).%New()
					
					Set tClaimLine.LineCounter = source.GetValueAt(loop2400_".LX:AssignedNumber")
					Set tClaimLine.AllowedAmount = source.GetValueAt(loop2400_".HCP:MonetaryAmount")
					Set tClaimLine.ChargedAmount = source.GetValueAt(loop2400_".SV1:MonetaryAmount")
					Set tClaimLine.PaidAmount = source.GetValueAt(loop2400_".loop2430(1).SVD:MonetaryAmount")
					Set actualPaidDate = source.GetValueAt(loop2400_".loop2430(1).DTP:DateTimePeriod")
					Set:""'=actualPaidDate tClaimLine.ActualPaidDate = $ZDATETIME($ZDATETIMEH(actualPaidDate, 8), 3)
					//Set tClaimLine.CopayAmount = source.GetValueAt(loop2400_".loop2430(1).CAS(1):MonetaryAmount")
					//Set tClaimLine.CoinsuranceAmount = source.GetValueAt(loop2400_".loop2430(1).CAS(1):MonetaryAmount2")
					
					Set refIdQualifier = source.GetValueAt(loop2400_".REF(1):RefIdQualifier")
					If "G1"=refIdQualifier {
						Set tClaimLine.AuthorizationNeeded = 1
					}
					
					//Set tClaimLine.DeniedFlag = 1
					//Set tClaimLine.DeniedReasonCode = 1
					
					Set tClaimLine.DiagnosticPointer = source.GetValueAt(loop2400_".SV1:CompositeDiagnosisCodePointe")
					
					Set tClaimLine.DrugCode = source.GetValueAt(loop2400_".loop2410.LIN:ProductServiceID")
					
					// EPSDTIndicator
					Set indicator = source.GetValueAt(loop2400_".SV1:YesNoConditionorResponseCode2")
					If "Y"=indicator {
						Set tClaimLine.EPSDTIndicator = 1
					}
					ElseIf "N"=indicator {
						Set tClaimLine.EPSDTIndicator = 2
					}
					
					//Set tClaimLine.ExcludeExpense = source.GetValueAt(loop2400_".loop2430(1).CAS(1):MonetaryAmount")
					
					// FamilyPlanningIndicator
					Set indicator = source.GetValueAt(loop2400_".SV1:YesNoConditionorResponseCode3")
					If "Y"=indicator {
						Set tClaimLine.FamilyPlanningIndicator.Code = 1
					}
					ElseIf "N"=indicator {
						Set tClaimLine.FamilyPlanningIndicator.Code = 4
					}
					
					// DTPs
					Set loopDTP = loop2400_".DTP(1)"
						
					Set dateTimeQualifier = source.GetValueAt(loopDTP_":DateTimeQualifier")
					Set dateTimePeriodFormatQualifier = source.GetValueAt(loopDTP_":DateTimePeriodFormatQualifie")
					Set dateTimePeriod = source.GetValueAt(loopDTP_":DateTimePeriod")
						
					If "D8"=dateTimePeriodFormatQualifier {
						Set:""'=dateTimePeriod tClaimLine.FromTime = $ZDATETIME($ZDATETIMEH(dateTimePeriod, 8), 3)
						//Set:""'=dateTimePeriod tClaimLine.ToTime = $ZDATETIME($ZDATETIMEH(dateTimePeriod, 8), 3)
					}
					ElseIf "RD8"=dateTimePeriodFormatQualifier
					{
						// First 8 digits of dateTimePeriod
						Set fromTime = $P(dateTimePeriod, "-", 1)
						Set:""'=fromTime tClaimLine.FromTime = $ZDATETIME($ZDATETIMEH(fromTime, 8), 3)
						
						// Last 8 digits of dateTimePeriod
						Set toTime = $P(dateTimePeriod, "-", 2)
						Set:""'=toTime tClaimLine.ToTime = $ZDATETIME($ZDATETIMEH(toTime, 8), 3)
					}
				
					// DeductibleAmount
					//Set tClaimLine.DeductibleAmount = source.GetValueAt(loop2400_".loop2430(1).CAS(1):MonetaryAmount")
					
					// ProcedureCodeType
					Set tClaimLine.ProcedureCodeType = source.GetValueAt(loop2400_".HCP:ProductServiceIDQualifier")
					
					// ProcedureCode
					Set tClaimLine.ProcedureCode = source.GetValueAt(loop2400_".HCP:ProductServiceID2")
					
					// ReferralIndicator
					Set indicator = source.GetValueAt(loop2400_".REF(1).RefIdQualifier")
					If "9F"=indicator {
						Set tClaimLine.ReferralIndicator = 1
					}
					
					// ProcedureModifiers
					Set modifier1 = source.GetValueAt(loop2400_".loop2430(1).SVD:CompositeMedicalProcedureIde.ProcedureModifier")
					Set modifier2 = source.GetValueAt(loop2400_".loop2430(1).SVD:CompositeMedicalProcedureIde.ProcedureModifier2")
					Set:""'=modifier1 tSC = tClaimLine.ProcedureModifiers.Insert(modifier1)
					Quit:$$$ISERR(tSC)
					Set:""'=modifier2 tSC = tClaimLine.ProcedureModifiers.Insert(modifier2)
					Quit:$$$ISERR(tSC)
					
					// Quantity
					Set tClaimLine.Quantity = source.GetValueAt(loop2400_".HCP:Quantity")
					
					// InNetworkIndicator
					Set policyComplianceCode = source.GetValueAt(loop2400_".HCP:PolicyComplianceCode")
					Set exceptionCode = source.GetValueAt(loop2400_".HCP:ExceptionCode")
					If ("5"=policyComplianceCode) || ("1"=exceptionCode) || ("3"=exceptionCode) {
						Set tClaimLine.InNetworkIndicator = 2
					}
					
					// ReferringProvider
					Set tClaimLine.ReferringProvider.IdentifierTypeCode = source.GetValueAt(loop2400_".loop2420F(1).REF(1):RefIdQualifier")
					Set tClaimLine.ReferringProvider.Code = source.GetValueAt(loop2400_".loop2420F(1).REF(1):RefId")
					
					// MedicarePaidAmount
					// OtherInsurancePaid
				
					// Add claim line
					Set tSC = tClaim.MedicalClaimLines.Insert(tClaimLine)
					Quit:$$$ISERR(tSC)
				} // For ClaimLine
				
				Set tSC = claims.Insert(tClaim)
				Quit:$$$ISERR(tSC)
			} // For Claim
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod Transform(source As EnsLib.EDI.X12.Document, Output target As %ListOfObjects) As %Status
{
	Set tSC=$$$OK
	
	Try {
		//Set source.DocType = "HIPAA_5010:837apP"
		// 1000A - Submitter
		// 1000B - Receiver
		// 2000A - Billing Provider
		//	  2000B - Subscriber
		//		2300 - Claim
		//			2400 - Claim Line
		//		2000C - Patient
		//			2300 - Claim
		//				2400 - Claim Line
		Do source.PokeDocType("HIPAA_5010:837apP")
		
		Set target = ##class(%ListOfObjects).%New()
		
		// Submitter
		// Assume the submitter is the payer, submitterId is payerId
		Set submitterId = source.GetValueAt("loop1000A.NM1:IdentificationCode")
		
		// Billing providers (repeating loop 2000A)
		Set tNextProvider = ""
		For {
		Set tNextProvider = source.GetNextIndex("loop2000A()", tNextProvider, .tSC)
		Quit:($$$ISERR(tSC))||(tNextProvider="")
		Set loop2000A = "loop2000A("_tNextProvider_")"
			
		// Subscribers (repeating loop 2000B)
		Set tNextSubscriber = ""
		For {
			Set tNextSubscriber = source.GetNextIndex(loop2000A_".loop2000B()", tNextSubscriber, .tSC)
			Quit:($$$ISERR(tSC))||(tNextSubscriber="")
			
			Set loop2000B = loop2000A_".loop2000B("_tNextSubscriber_")"
			
			Set hl = source.GetValueAt(loop2000B_".HL!3=22")
			//Set hIDNumber = source.GetValueAt(loop2000B_".HL!3=22:HierarchicalIDNumber")
			Set hIDNumber = $P(hl, "*", 2)
			//Set hParentIDNumber = source.GetValueAt(loop2000B_".HL:HierarchicalParentIDNumber")
			Set hParentIDNumber = $P(hl, "*", 3)
			//Set hLevelCode = source.GetValueAt(loop2000B_".HL:HierarchicalLevelCode")
			Set hLevelCode = $P(hl, "*", 4)
			//Set hChildCode = source.GetValueAt(loop2000B_".HL:HierarchicalChildCode")
			Set hChildCode = $P(hl, "*", 5)
			
			Set tSubscriber = ##class(HS.SDA3.Guarantor).%New()
			
			Set respSequenceN = source.GetValueAt(loop2000B_".SBR:PayerResponsibilitySequenceN")
			Set relationshipCode = source.GetValueAt(loop2000B_".SBR:IndividualRelationshipCode")
			Set:""'=relationshipCode tSubscriber.Relationship.Code = relationshipCode
			
			// Name
			Set tSubscriber.Name.FamilyName = source.GetValueAt(loop2000B_".loop2010BA.NM1:NameLastorOrganizationName")
			Set tSubscriber.Name.GivenName = source.GetValueAt(loop2000B_".loop2010BA.NM1:NameFirst")
			Set tSubscriber.Name.MiddleName = source.GetValueAt(loop2000B_".loop2010BA.NM1:NameMiddle")
			Set tSubscriber.Name.NamePrefix = source.GetValueAt(loop2000B_".loop2010BA.NM1:NamePrefix")
			Set tSubscriber.Name.NameSuffix = source.GetValueAt(loop2000B_".loop2010BA.NM1:NameSuffix")
			
			// ID
			// II: Standard Unique Health Identifier
			// MI: Member Identification Number
			Set idCodeQualifier = source.GetValueAt(loop2000B_".loop2010BA.NM1:IdentificationCodeQualifier")
			Set idCode = source.GetValueAt(loop2000B_".loop2010BA.NM1:IdentificationCode")
			Set tSubscriber.GuarantorNumber.Organization.Code = submitterId
			Set tSubscriber.GuarantorNumber.Number = idCode
			Set tSubscriber.GuarantorNumber.NumberType = "MRN"
					
			// Address
			Set tSubscriber.Address.Street =  source.GetValueAt(loop2000B_".loop2010BA.N3:AddressInformation")
			Set tSubscriber.Address.City.Code = source.GetValueAt(loop2000B_".loop2010BA.N4:CityName")
			Set tSubscriber.Address.State.Code = source.GetValueAt(loop2000B_".loop2010BA.N4:StateorProvinceCode")
			Set tSubscriber.Address.Zip.Code = source.GetValueAt(loop2000B_".loop2010BA.N4:PostalCode")
			Set tSubscriber.Address.Country.Code = source.GetValueAt(loop2000B_".loop2010BA.N4:CountryCode")
			
			// DMG (no place to hold dmg in HS.SDA3.Guarantor)
			//Set dateTimeFormatQualifier = source.GetValueAt(loop2000B_".loop2010BA.DMG:DateTimePeriodFormatQualifie")
			//Set tContainer.Patient.BirthTime = source.GetValueAt(loop2000B_".loop2010BA.DMG:DateTimePeriod") // D8
			//Set tContainer.Patient.Gender.Code = source.GetValueAt(loop2000B_".loop2010BA.DMG:GenderCode")
			//Set tContainer.Patient.MaritalStatus.Code = source.GetValueAt(loop2000B_".loop2010BA.DMG:MaritalStatusCode")
			//Set tContainer.Patient.Race.Code = source.GetValueAt(loop2000B_".loop2010BA.DMG:RaceOrEthnicity")
			
			// REFS	
			Set subscriberSSN = ""
			Set loopREF = loop2000B_".loop2010BA.REF(1)"
			Set refIdQualifier = source.GetValueAt(loopREF_":RefIdQualifier")
			Set refId = source.GetValueAt(loopREF_":RefId")
			Set:"SY"=refIdQualifier subscriberSSN = refId
			
			// Claims (Subscriber is the patient)
			#Dim tClaims As list of HS.SDA3.MedicalClaim
			Set tSC = ..ParseClaims(source, loop2000B, .tClaims)
			Quit:$$$ISERR(tSC)
			
			If tClaims.Count() > 0 {
				Set tContainer = ##class(HS.SDA3.Container).%New()
			
				// Set Patient
				Set tContainer.Patient.Name = tSubscriber.Name
				Do tContainer.Patient.Addresses.Insert(tSubscriber.Address)	

				// DMG
				Set dateTimeFormatQualifier = source.GetValueAt(loop2000B_".loop2010BA.DMG:DateTimePeriodFormatQualifie")
				Set birthTime = source.GetValueAt(loop2000B_".loop2010BA.DMG:DateTimePeriod") // D8 format
				Set:""'=birthTime tContainer.Patient.BirthTime = $ZDATETIME($ZDATETIMEH(birthTime, 8), 3) 
				Set tContainer.Patient.Gender.Code = source.GetValueAt(loop2000B_".loop2010BA.DMG:GenderCode")
				Set tContainer.Patient.MaritalStatus.Code = source.GetValueAt(loop2000B_".loop2010BA.DMG:MaritalStatusCode")
				Set tContainer.Patient.Race.Code = source.GetValueAt(loop2000B_".loop2010BA.DMG:RaceOrEthnicity")
			
				Do tContainer.Patient.PatientNumbers.Insert(tSubscriber.GuarantorNumber)
				
				//SSN
				If subscriberSSN'="" {
					Set ssn = ##class(HS.SDA3.PatientNumber).%New()
					Set ssn.Organization.Code = "SSN"
					Set ssn.Number = subscriberSSN
					Set ssn.NumberType = "SSN"
					Do tContainer.Patient.PatientNumbers.Insert(ssn)
				}
				
				// Set Claims
				If tClaims.Count() > 0 {
					For i=1:1:tClaims.Count() {
						Set tClaim = tClaims.GetAt(i)
						Set tClaim.Submitter = submitterId
						Set tClaim.Subscriber = tSubscriber
						Set tSC = tContainer.MedicalClaims.Insert(tClaim)
						Quit:$$$ISERR(tSC)
					}
				}
				
				// Add container
				Set tSC = target.Insert(tContainer)
				Quit:$$$ISERR(tSC)
			}
			
		// Patients
		Set tNextPatient = ""
		For {
			Set tNextPatient = source.GetNextIndex(loop2000B_".loop2000C()", tNextPatient, .tSC)
			Quit:($$$ISERR(tSC))||(tNextPatient="")
			
			Set loop2000C = loop2000B_".loop2000C("_tNextPatient_")"
			
			Set tContainer = ##class(HS.SDA3.Container).%New()
			
			// HL
			Set hIDNumber = source.GetValueAt(loop2000C_".HL:HierarchicalIDNumber")
			Set hParentIDNumber = source.GetValueAt(loop2000C_".HL:HierarchicalParentIDNumber")
			Set hLevelCode = source.GetValueAt(loop2000C_".HL:HierarchicalLevelCode")
			Set hChildCode = source.GetValueAt(loop2000C_".HL:HierarchicalChildCode")
			
			Set individualRelationshipCode = source.GetValueAt(loop2000C_".PAT:IndividualRelationshipCode")
			
			// Patient MRN
			Set patientId = source.GetValueAt(loop2000C_".loop2010CA.NM1:IdentificationCode")
			Set tPatientNumber = ##class(HS.SDA3.PatientNumber).%New()
			Set tPatientNumber.Organization.Code = submitterId
			Set tPatientNumber.Number = patientId
			Set tPatientNumber.NumberType = "MRN"
			Set tSC = tContainer.Patient.PatientNumbers.Insert(tPatientNumber)
			Quit:$$$ISERR(tSC)
			
			// Name
			Set tContainer.Patient.Name.FamilyName = source.GetValueAt(loop2000C_".loop2010CA.NM1:NameLastorOrganizationName")
			Set tContainer.Patient.Name.GivenName = source.GetValueAt(loop2000C_".loop2010CA.NM1:NameFirst")
			Set tContainer.Patient.Name.MiddleName = source.GetValueAt(loop2000C_".loop2010CA.NM1:NameMiddle")
			Set tContainer.Patient.Name.NamePrefix = source.GetValueAt(loop2000C_".loop2010CA.NM1:NamePrefix")
			Set tContainer.Patient.Name.NameSuffix = source.GetValueAt(loop2000C_".loop2010CA.NM1:NameSuffix")
			
			// Address
			Set tAddress = ##class(HS.SDA3.Address).%New()
			Set tAddress.Street = source.GetValueAt(loop2000C_".loop2010CA.N3:AddressInformation")
			Set tAddress.City.Code = source.GetValueAt(loop2000C_".loop2010CA.N4:CityName")
			Set tAddress.State.Code = source.GetValueAt(loop2000C_".loop2010CA.N4:StateorProvinceCode")
			Set tAddress.Zip.Code = source.GetValueAt(loop2000C_".loop2010CA.N4:PostalCode")
			Set tAddress.Country.Code = source.GetValueAt(loop2000C_".loop2010CA.N4:CountryCode")
			Set tSC = tContainer.Patient.Addresses.Insert(tAddress)
			Quit:$$$ISERR(tSC)
			
			// DMG
			Set dateTimeFormatQualifier = source.GetValueAt(loop2000C_".loop2010CA.DMG:DateTimePeriodFormatQualifie")
			Set birthTime = source.GetValueAt(loop2000C_".loop2010CA.DMG:DateTimePeriod") // D8 format
			Set:""'=birthTime tContainer.Patient.BirthTime = $ZDATETIME($ZDATETIMEH(birthTime, 8), 3) 
			Set tContainer.Patient.Gender.Code = source.GetValueAt(loop2000C_".loop2010CA.DMG:GenderCode")
			Set tContainer.Patient.MaritalStatus.Code = source.GetValueAt(loop2000C_".loop2010CA.DMG:MaritalStatusCode")
			Set tContainer.Patient.Race.Code = source.GetValueAt(loop2000C_".loop2010CA.DMG:RaceOrEthnicity")
			
			// REFS
			Set loopREF = loop2000C_".loop2010CA.REF(1)"
			Set refIdQualifier = source.GetValueAt(loopREF_":RefIdQualifier")
			Set refId = source.GetValueAt(loopREF_":RefId")
			// SSN
			If ("SY"=refIdQualifier) && (refId'="") {
				Set tPatientNumber = ##class(HS.SDA3.PatientNumber).%New()
				Set tPatientNumber.Organization.Code = "SSN"
				Set tPatientNumber.Number = refId
				Set tPatientNumber.NumberType = "SSN"
				Set tSC = tContainer.Patient.PatientNumbers.Insert(tPatientNumber)
				Quit:$$$ISERR(tSC)
			}
		
			// Claims
			Set tSC = ..ParseClaims(source, loop2000C, .tClaims)
			Quit:$$$ISERR(tSC)
			If tClaims.Count() > 0 {
				For i=1:1:tClaims.Count() {
					Set tClaim = tClaims.GetAt(i)
					Set tClaim.Submitter = submitterId
					// Change relationshipcode
					Set tSubscriber.Relationship.Code = individualRelationshipCode
					Set tClaim.Subscriber = tSubscriber
					Set tSC = tContainer.MedicalClaims.Insert(tClaim)
					Quit:$$$ISERR(tSC)
				}
			}
			
			// Add container
			Set tSC = target.Insert(tContainer)
			Quit:$$$ISERR(tSC)
		} // For Patient
		} // For Subscriber
		} // For Provider
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod TestTransform(pExtra As %Integer = 0) As %Status [ Internal ]
{
	Set tSC = $$$OK
		
	Set tDoc = ##class(EnsLib.EDI.X12.Document).ImportFromFile("C:\InterSystems\X12\837\apcd.txt",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	
	Set pathValue = tDoc.Name_"#"_tDoc.TypeVersion_"#"_tDoc.DocTypeCategory_"#"_tDoc.DocTypeName
	W pathValue, !
	
	Set tSC = ..Transform(tDoc, .tTarget)
	Quit:$$$ISERR(tSC) tSC
	
	Set count = tTarget.Count()
	For i=1:1:count {
		#Dim tContainer As HS.SDA3.Container = tTarget.GetAt(i)
		
		If pExtra {
			#Dim tMedicalClaim As HS.SDA3.MedicalClaim = tContainer.MedicalClaims.GetAt(1)
			#Dim tMedicalClaimLine As HS.SDA3.MedicalClaimLine = tMedicalClaim.MedicalClaimLines.GetAt(1)
		
			Set tFund1 = ##class(HS.SDA3.HealthFund).%New()
			Set tFund1.HealthFund.Code = "01"
			Set tFund1.HealthFundPlan.Code = "01"
			Set tFund1.InsuredName.FamilyName = "Burns"
			Set tFund1.InsuredName.GivenName = "Steve"
			Do tMedicalClaimLine.HealthFunds.Insert(tFund1)
		
			Set tFund2 = ##class(HS.SDA3.HealthFund).%New()
			Set tFund2.HealthFund.Code = "02"
			Set tFund2.HealthFundPlan.Code = "02"
			Set tFund2.InsuredName.FamilyName = "Burns"
			Set tFund2.InsuredName.GivenName = "Joe"
			Do tMedicalClaimLine.HealthFunds.Insert(tFund2)
		}
		
		Set tXML = ""
		Set tSC = tContainer.ToQuickXMLString(.tXML)
		Quit:$$$ISERR(tSC)
		Write tXML, !
	}
	
	Quit tSC
}

ClassMethod TestPath() As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Set tDoc = ##class(EnsLib.EDI.X12.Document).ImportFromFile("C:\InterSystems\X12\837\apcd.txt",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	
	Set pathValue = tDoc.Name_"#"_tDoc.TypeVersion_"#"_tDoc.DocTypeCategory_"#"_tDoc.DocTypeName
	W pathValue, !
	
	Set tDoc.DocType = "HIPAA_5010:837apP"
	//Do $SYSTEM.OBJ.DisplayError()
	
	Set pathValue = tDoc.GetValueAt("ST:TransactionSetIdentifierCode",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "ST:TransactionSetIdentifierCode = ", pathValue, !
	
	Set pathValue = tDoc.GetValueAt("ST:TransactionSetControlNumber",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "ST:TransactionSetControlNumber = ", pathValue, !
	
	Set pathValue = tDoc.GetValueAt("ST:ImplementationConventionRefe",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "ST:ImplementationConventionRefe = ", pathValue, !
	
	// Submitter
	Set pathValue = tDoc.GetValueAt("loop1000A.NM1:EntityIdentifierCode",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "loop1000A.NM1:EntityIdentifierCode = ", pathValue, !
	
	// Receiver
	Set pathValue = tDoc.GetValueAt("loop1000B.NM1:EntityIdentifierCode",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "loop1000B.NM1:EntityIdentifierCode = ", pathValue, !
	
	// Provider
	Set pathValue = tDoc.GetValueAt("loop2000A(1).loop2010AA.NM1:EntityIdentifierCode",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "loop2000A(1).loop2010AA.NM1:EntityIdentifierCode = ", pathValue, !
	
	// Subscriber
	Set pathValue = tDoc.GetValueAt("loop2000A(1).loop2000B(1).loop2010BA.NM1:EntityIdentifierCode",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "loop2000A(1).loop2000B(1).loop2010BA.NM1:EntityIdentifierCode = ", pathValue, !
	Set pathValue = tDoc.GetValueAt("loop2000A(1).loop2000B(1).loop2010BB.NM1:EntityIdentifierCode",,.tSC)
	Quit:$$$ISERR(tSC) tSC
	W "loop2000A(1).loop2000B(1).loop2010BB.NM1:EntityIdentifierCode = ", pathValue, !
	//Set pathValue = tDoc.GetValueAt("loop2000B(1).loop2300(1).CLM:ClaimSubmittersIdentifier",,.tSC)
	//W "loop2000B(1).loop2300(1).CLM:ClaimSubmittersIdentifier = ", pathValue, !
	
	// Patients
	Set tNextPatient = ""
	For {
		Set rootPath = "loop2000A(1).loop2000B(1)"
		Set tNextPatient = tDoc.GetNextIndex(rootPath_".loop2000C()", tNextPatient, .tSC)
		Quit:($$$ISERR(tSC))||(tNextPatient="")
		Write "Next Patient = ", tNextPatient, !
		
		Set loop2000C = rootPath_".loop2000C("_tNextPatient_")"
		Set pathValue = tDoc.GetValueAt(loop2000C_".loop2010CA.NM1:EntityIdentifierCode",,.tSC)
		Quit:$$$ISERR(tSC)
		W "loop2000A(1).loop2000B(1).loop2000C("_tNextPatient_").loop2010CA.NM1:EntityIdentifierCode = ", pathValue, !
		
		// Claims
		Set tNextClaim = ""
		For {
			Set tNextClaim = tDoc.GetNextIndex(loop2000C_".loop2300()", tNextClaim, .tSC)
			Quit:($$$ISERR(tSC))||(tNextClaim="")
			Write "Next Claim = ", tNextClaim, !
		
			Set loop2300 = loop2000C_".loop2300("_tNextClaim_")"
			Set pathValue = tDoc.GetValueAt(loop2300_".CLM:ClaimSubmittersIdentifier",,.tSC)
			Quit:$$$ISERR(tSC)
			W "loop2000A(1).loop2000B(1).loop2000C("_tNextPatient_").loop2300("_tNextClaim_").CLM:ClaimSubmittersIdentifier = ", pathValue, !
			
			// Service lines
			Set tNextLine = ""
			For {
				Set tNextLine = tDoc.GetNextIndex(loop2300_".loop2400()", tNextLine, .tSC)
				Quit:($$$ISERR(tSC))||(tNextLine="")
				Write "Next Line = ", tNextLine, !
				
				Set loop2400 = loop2300_".loop2400("_tNextLine_")"
				Set pathValue = tDoc.GetValueAt(loop2400_".LX:AssignedNumber",,.tSC)
				Quit:$$$ISERR(tSC)
				W "loop2000A(1).loop2000B(1).loop2000C("_tNextPatient_").loop2300("_tNextClaim_").loop2400("_tNextLine_").LX:AssignedNumber = ", pathValue, !
			}
		}
	}
		
	Quit tSC
}

}

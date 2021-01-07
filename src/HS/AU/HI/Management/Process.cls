/// Three types of transactions to handle
/// AddUpdateHubRequest - new / changes to a mrn
/// MergePatientRequest - one mrn merged into another
/// IDUpdateNotification - MPIID is changing for one or more MRN's
Class HS.AU.HI.Management.Process Extends Ens.BusinessProcess
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS As %String = "QueryOperation";

Property QueryOperation As Ens.DataType.ConfigName [ InitialExpression = "HS.AU.HI.Consumer.Operations" ];

/// Values sent out in the IHI Search request $lb($lb(property,value),$lb(property,value))
Property RequestData As %String(MAXLEN = "");

Property MPIID As %String;

Property CallCount As %Integer [ InitialExpression = 0 ];

Property ValidateItem As HS.AU.HI.Management;

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	try {
		Set tSC=$$$OK
		#; request from HS.Hub.MPI.Manager which handles all types
		If pRequest.%IsA("HS.Message.PostProcessorRequest") {
			#; create an immediate reply so the MPI manager doesn't have to wait
			Set tSC = ..Reply(pRequest.OriginalResponse)
			Set tRequest = pRequest.OriginalRequest 
			If tRequest.%IsA("HS.Message.AddUpdateHubRequest") {
				Do ..AddUpdate(tRequest)
			} ElseIf tRequest.%IsA("HS.Message.MergePatientRequest") {
				Do ..Merge(tRequest)
			} ElseIf tRequest.%IsA("HS.Message.IDUpdateNotificationRequest") {
				Do ..IDUpdate(tRequest)
			}
		} ElseIf pRequest.%IsA("HS.AU.Message.HI.SearchIndividualProviderRequest") {
			Set tSC=..ValidateHPII(pRequest,.pResponse)
		} ElseIf pRequest.%IsA("HS.AU.Message.HI.SearchOrganisationProviderRequest") {
			Set tSC=..ValidateHPIO(pRequest,.pResponse)
		} Else {
			$$$LOGERROR("Unhandled request:"_pRequest)
		}
	} catch ex {
		set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// If the MPIID is changing check to see if other MRN's have the same MPIID and if they have a different IHI
Method Merge(pRequest As HS.Message.MergePatientRequest)
{
	Set tSC=$$$OK
	Try {
		Set tOriginalItem = ##class(HS.AU.IHI.Management).MRNIndexOpen(pRequest.PriorMRN,pRequest.PriorAssigningAuthority,pRequest.Facility)
		Set tKeepItem = ##class(HS.AU.IHI.Management).MRNIndexOpen(pRequest.MRN,pRequest.AssigningAuthority,pRequest.Facility)
		If '$isObject(tOriginalItem) Quit
		If '$IsObject(tKeepItem) {
			#; if no keep item, we are just switching numbers
			Set tKeepItem=tOriginalItem
			Set tKeepItem.MRN=pRequest.MRN
			Set tKeepItem.AssigningAuthority=pRequest.AssigningAuthority
			Set tSC=tKeepItem.%Save()
		} Else {
			#; removing original item / demographics of keep item might be updated	
			Do tOriginalItem.%DeleteId(tOriginalItem.%Id())					
		}
		Set tSC=..ValidateRowRequest(tKeepItem)
	} catch ex {
		set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// If the MPIID is changing, check to see if other MRN's have the same MPIID and if they have a different IHI
Method IDUpdate(pRequest As HS.Message.IDUpdateNotificationRequest)
{
	Set tSC=$$$OK
	Try {
		Set (tIHI,tStatus,tRecordStatus,tAlert)=""
		#; for a MPIID find all MRNs associated and make sure they have the same IHI number
		For tMPIID = pRequest.MPIID,pRequest.PriorMPIID {
			Do ..ValidateMPIID(tMPIID)
		}
		
	} catch ex {
		set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Transaction Type AddUpdateHubRequest 
Method AddUpdate(pRequest As HS.Message.AddUpdateHubRequest)
{
	try {
		Set tSC=$$$OK
		#; query the IHI services
		/// what about ihi numbers in the patient object
		Set tItem = ##class(HS.AU.IHI.Management).MRNIndexOpen(pRequest.MRN,pRequest.AssigningAuthority,pRequest.Facility)
		If '$IsObject(tItem) {
			Set tItem = ##class(HS.AU.IHI.Management).%New()
			Set tItem.MRN=pRequest.MRN,tItem.AssigningAuthority=pRequest.AssigningAuthority,tItem.Facility=pRequest.Facility
			Set tItem.Alert="Created"
			Set tSC = tItem.%Save()
		}
		Do ..ValidateRowRequest(tItem)
		Quit
	} catch ex {
		Set tSC=ex.AsStatus()
		Set tItem.Alert=$system.Status.GetErrorText(tSC)
	}
	Quit
}

/// Validation String Property=value,Property=value ie Sex=M,DateOfBirth=2000-05-24
ClassMethod BuildIHIRequest(pManagementItem As HS.AU.IHI.Management, pPatient As HS.Registry.Patient, Output pHistory = "", pRequest As HS.AU.Message.HI.SearchIHIRequest = "") As %Status
{
	#define ASSIGN(%request,%field,%value,%history) if %value]"" Set $property(%request,%field)=%value,%history=%history_$lb(%field,%value)
	Try {
		Set tSC=$$$OK
		Do ..GetPatientIdentifiers(pPatient,.tIdentifiers)
		If $G(tIdentifiers("Number"))]"" Set pRequest.IHINumber=tIdentifiers("Number"),pHistory=pHistory_$lb("Number",tIdentifiers("Number"))
		
		#; if the patient record doesn't have an IHI and we had one before that was Verified use that
		If pRequest.IHINumber="" && (pManagementItem.Number]"")&&(pManagementItem.RecordStatus="Verified") {
			Set pRequest.IHINumber=$p(pManagementItem.Number,"/",$l(pManagementItem.Number,"/")),pHistory=pHistory_$lb("Number",pRequest.IHINumber)
		}
		If pRequest.IHINumber]"" {
			Set tSC = ..ValidateIHI(pRequest.IHINumber) Quit:$$$ISERR(tSC)
			Set pRequest.IHINumber="http://ns.electronichealth.net.au/id/hi/ihi/1.0/"_pRequest.IHINumber
		}

		If pRequest.IHINumber="",$G(tIdentifiers("DVAFileNumber"))]"" Set pRequest.DVAFileNumber=tIdentifiers("DVAFileNumber"),pHistory=pHistory_$lb("DVAFileNumber",pRequest.DVAFileNumber)
		If pRequest.IHINumber="",pRequest.DVAFileNumber="",$G(tIdentifiers("MedicareCardNumber"))]"" {
			Set pRequest.MedicareCardNumber=tIdentifiers("MedicareCardNumber"),pHistory=pHistory_$lb("MedicareCardNumber",pRequest.MedicareCardNumber)
			If $G(tIdentifiers("MedicareIRN"))]"" Set pRequest.MedicareIRN = tIdentifiers("MedicareIRN"),pHistory=pHistory_$lb("MedicareIRN",tIdentifiers("MedicareIRN"))
		}
			
		Set tDOB=$S(pPatient.BirthDateTime="":"",1:$zdh(pPatient.BirthDateTime,3))
		If tDOB]"" Set pRequest.DateOfBirth=tDOB,pHistory=pHistory_$lb("DateOfBirth",tDOB)
		If pPatient.Gender]"" Set pRequest.Sex=pPatient.Gender,pHistory=pHistory_$lb("Sex",pRequest.Sex)

		If pPatient.Name.Family]"" Set pRequest.FamilyName=pPatient.Name.Family,pHistory=pHistory_$lb("FamilyName",pRequest.FamilyName)

		#; if looking up by identifier (IHI,DVA,Medicare) just need DOB, Sex, FamilyName and the Number / any more will be rejected by server (ERROR) Multiple search criteria keyed. Please refine the search criteria.
		If pRequest.DVAFileNumber]"" || (pRequest.MedicareCardNumber]"") || (pRequest.IHINumber]"") Quit

		If pPatient.Name.Given]"" Set pRequest.GivenName=pPatient.Name.Given,pHistory=pHistory_$lb("GivenName",pRequest.GivenName)

		Do ..GetPatientAddress(pPatient,pRequest,pHistory)

	} catch ex {
		
		set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Locate the patient IHI number from the identifiers collection
/// According to NEHTA, the number is made up as follows:	80036XnnnnnnnnnY
/// 800 is 'Australia', 36 is 'eHealth'
/// X	is (0) for individual (IHI)
/// 	is (1) for provider (HPI-I)
/// 	is (2) for organisation (HPI-O)
/// nnn	is the serial number
/// Y	is a check digit
ClassMethod GetPatientIdentifiers(pPatient As HS.Registry.Patient, Output pIdentifiers = "") As %Status
{
	Try {
		/// Build array of Number, DVAFileNumber, MedicareCardNumber, MedicareIRN from Patient record
		Set tSC=$$$OK
		Set tCount=pPatient.Identifiers.Count()
		Quit:'tCount
		Set tIHIRoot = ##class(HS.Registry.Config).GetKeyValue("\AU\AssigningAuthority\HI")
		Set tDVARoot = ##class(HS.Registry.Config).GetKeyValue("\AU\AssigningAuthority\DVA")
		Set tMedicareRoot = ##class(HS.Registry.Config).GetKeyValue("\AU\AssigningAuthority\MEDICARE")
		Set tMedicare10Root = ##class(HS.Registry.Config).GetKeyValue("\AU\AssigningAuthority\MEDICARE10")
		For tIdx=1:1:tCount {
			Set tIdentifier = pPatient.Identifiers.GetAt(tIdx)
			Set tRoot = $S(tIdentifier.Root]"":tIdentifier.Root,1:tIdentifier.AssigningAuthorityName)
			If tRoot = tIHIRoot {
				Set:$e(tIdentifier.Extension,6)=0 pIdentifiers("Number")=tIdentifier.Extension
			} Elseif (tRoot = tMedicareRoot) {
				Set pIdentifiers("MedicareCardNumber")=$E(tIdentifier.Extension,1,10)
				Set pIdentifiers("MedicareIRN")=$E(tIdentifier.Extension,11)
			} Elseif (tRoot = tMedicare10Root) {
				Set pIdentifiers("MedicareCardNumber")=tIdentifier.Extension
			} Elseif (tRoot = tDVARoot) {
				Set pIdentifiers("DVAFileNumber")=tIdentifier.Extension
			}
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

/// Locate the patient IHI number from the identifiers collection
ClassMethod GetPatientAddress(pPatient As HS.Registry.Patient, pRequest As HS.AU.Message.HI.SearchIHIRequest = "", ByRef pHistory) As %Status
{
	#dim tAddress as HS.Types.Address = pPatient.Addresses.GetAt(1)
	Quit:'$IsObject(tAddress)
	If tAddress.Country="" {
		If tAddress.POBox]"" {
		} Else {
			Set pRequest.AustralianStreetAddress.State=tAddress.State
			Set pRequest.AustralianStreetAddress.StreetName = tAddress.StreetName
			Set pRequest.AustralianStreetAddress.StreetNumber = tAddress.StreetNumber
			#; street type validation issues... CR instead of CRST
			//Set pRequest.AustralianStreetAddress.StreetType = tAddress.StreetType
			Set:pRequest.AustralianStreetAddress.StreetTypeIsValid(tAddress.StreetType) pRequest.AustralianStreetAddress.StreetType=tAddress.StreetType
			Set pRequest.AustralianStreetAddress.Suburb = tAddress.City
			Set pRequest.AustralianStreetAddress.Postcode = tAddress.PostalCode
		}
	} Else {
		Set pRequest.InternationalAddress.Country=tAddress.Country
		Set pRequest.InternationalAddress.InternationalAddressLine = tAddress.StreetLine
		Set pRequest.InternationalAddress.InternationalPostcode = tAddress.PostalCode
		Set pRequest.InternationalAddress.InternationalStateProvince = tAddress.State
	}	
		//Set tRequest.AustralianStreetAddress.
		#; what about australian street versus postal
		/*

	Property AustralianPostalAddress As HS.AU.Types.HI.Address.AustralianPostalAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "australianPostalAddress", XMLREF = 1);

	Property AustralianStreetAddress As HS.AU.Types.HI.Address.AustralianStreetAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "australianStreetAddress", XMLREF = 1);

	Property InternationalAddress As HS.AU.Types.HI.Address.InternationalAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "internationalAddress", XMLREF = 1);

		
		*/


	Quit $$$OK
}

/// Given patient demographics find the IHI number for the patient
Method ValidateRowRequest(pItem As HS.AU.IHI.Management) As %Status
{
	Set tSC=$$$OK
	Try {
		Set ..ValidateItem=pItem
		Set tRequest = ##class(HS.AU.Message.HI.SearchIHIRequest).%New()
		Set tPatient = ##class(HS.Registry.Patient).MRNIndexOpen(pItem.MRN,pItem.AssigningAuthority,pItem.Facility)
		If '$IsObject(tPatient) {Set pItem.Alert="Patient not found" Set tSC=pItem.%Save() Quit}
		If tPatient.BirthDateTime="" {Set pItem.Alert="Patient has no Date of Birth" Set tSC=pItem.%Save() Quit}
		Set ..MPIID=tPatient.MPIID
		Set tSC=..BuildIHIRequest(pItem,tPatient,.tRequestData,tRequest)
		If $$$ISERR(tSC) {Set pItem.Alert=$system.Status.GetErrorText(tSC) Set tSC=pItem.%Save() Quit}
		#; if the item is verified/active and request values are identical and the request has been made in the last 24Hrs no need to validate
		If '..Revalidate(pItem,tRequestData) Quit
		
		#; save the request data for logging with the response
		Set ..RequestData = tRequestData
		Do ..GetSAMLData(tRequest)
		Set tSC = ..SendRequestAsync(..QueryOperation,tRequest,1,"ValidateRow")
	} catch ex {
		Set tSC=ex.AsStatus()
		Set pItem.Alert=$system.Status.GetErrorText(tSC)
		Set tSC1 = pItem.%Save()
	}
	
	Quit tSC
}

/// Verify whether the record has been verified with the same values in the last 24Hrs
ClassMethod Revalidate(pItem As HS.AU.IHI.Management, pRequestData) As %Boolean
{
	try {
		Set tRevalidate=1
		
		Set tNow=$ztimestamp
		Set tLast = $zdth(pItem.LastValidation,3)
		#; if more than 1 day, automatically validate
		Set tDiff = tNow-tLast
		If tDiff>1 Quit
		If tDiff=1 && ($p(tLast,",",2)-$p(tNow,",",2)<0) Quit

		Set tAlert=pItem.Alert
		If tAlert="Unusable" || (tAlert="Patient has no Date of Birth") set tAlert=""
		#; an alert on the record requires revalidation
		If (tAlert]"" || (pItem.Number="")) && ((tAlert'["No Healthcare Individual records") && (tAlert'["ERROR #6248")) Quit
		If (tAlert="Created") Quit
		#; within 24 Hrs - validation depends on the values
		Set tHistory = pItem.History.GetAt(pItem.History.Count())
		If '$IsObject(tHistory) Quit
		If pRequestData=tHistory.RequestValues Set tRevalidate=0 Quit
	} Catch ex {
	}
	Quit tRevalidate
}

/// Calculate the checkdigit for the IHI number
ClassMethod ValidateIHI(pNumber As %String) As %Status
{
	try {
		Set tSC=$$$OK
		Set tCD=$e(pNumber,*)
		Set tIHI=$e(pNumber,1,*-1)
		Set totalString = ""
		For tIdx=$l(tIHI):-1:1 {
			Set tNum=$e(tIHI,tIdx)
			If tIdx#2 {
				Set totalString=totalString_$e(tNum*2_" ",1,*-1)
			} Else {
				Set totalString=totalString_tNum
			}
		}
		Set total=0
		For tIdx=1:1:$l(totalString) {
			Set total=total+$e(totalString,tIdx)
		}
		Set ones=$e(total,*)
		Set tCCD=$e(10-ones,*)
		If tCCD'=tCD Set tSC = $$$ERROR($$$GeneralError,"Invalid check digit")
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Once a record is updated, validate other records with the same MPIID
Method ValidateMPIID(pMPIID) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tAlert=""
		set tSQL = "SELECT MRN,AssigningAuthority,Facility FROM HS_Registry.Patient WHERE MPIID=?"
		set tResult = ##class(%SQL.Statement).%ExecDirect(,tSQL,pMPIID)
		if (tResult.%SQLCODE '= 0) { Set tSC=$$$ERROR($$$GeneralError,"Unable to execute query on Registry.Patient "_tResult.%SQLCODE) Quit }
		While tResult.%Next() {
			#; all the MRN/AA/FAC with the same MPIID find local record -> should we queue things to verify that are not found as local records?
			Set tArray(tResult.MRN_" ",tResult.AssigningAuthority_" ",tResult.Facility_" ")=""
			set tSQL = "SELECT Number,Status,RecordStatus,Alert FROM HS_AU_IHI.Management WHERE MRN=? and AssigningAuthority=? and Facility=?"
			set tResultInner = ##class(%SQL.Statement).%ExecDirect(,tSQL,tResult.MRN,tResult.AssigningAuthority,tResult.Facility)
			if (tResultInner.%SQLCODE '= 0) { Set tSC=$$$ERROR($$$GeneralError,"Unable to execute query on AU_IHI.Management "_tResultInner.%SQLCODE) Quit }
			While tResultInner.%Next() {
				If $p(tResultInner.Alert,"Non-matching ",2)]"" Set tFix(tResult.MRN_" ",tResult.AssigningAuthority_" ",tResult.Facility_" ")=""
				Set:'$d(tIHI) tIHI = tResultInner.Number
				If tResultInner.Number'=tIHI Set tAlert="Non-matching IHI" Continue
				Set:'$d(tStatus) tStatus = tResultInner.Status
				If tResultInner.Status'=tStatus Set tAlert="Non-matching IHI Number Status" Continue
				Set:'$d(tRecordStatus) tRecordStatus = tResultInner.RecordStatus
				If tResultInner.RecordStatus'=tRecordStatus Set tAlert="Non-matching IHI Record Status"
			}
		}
		#; was previously an alert but no longer and there are records to fix (clear the alert)
		If tAlert="" && $d(tFix) {
			Set (tMRN,tAA,tFacility)=""
			For  {
				Set tMRN=$O(tFix(tMRN)) Quit:tMRN=""
				For  {
					Set tAA=$O(tFix(tMRN,tAA)) Quit:tAA=""
					For  {
						Set tFacility=$O(tFix(tMRN,tAA,tFacility)) Quit:tFacility=""
						Set tItem = ##class(HS.AU.IHI.Management).MRNIndexOpen(tMRN,tAA,tFacility)
						Set tItem.Alert=""
						Set tSC=tItem.%Save()
						If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
					}	
				}
			}
		}

		Quit:tAlert=""
		#; add the alert for any related mrns
		Set (tMRN,tAA,tFacility)=""
		For  {
			Set tMRN=$O(tArray(tMRN)) Quit:tMRN=""
			For  {
				Set tAA=$O(tArray(tMRN,tAA)) Quit:tAA=""
				For  {
					Set tFacility=$O(tArray(tMRN,tAA,tFacility)) Quit:tFacility=""
					Set tItem = ##class(HS.AU.IHI.Management).MRNIndexOpen(tMRN,tAA,tFacility)
					Continue:('$isObject(tItem) || (tItem.Alert]""))
					Set tItem.Alert=tAlert
					Set tSC=tItem.%Save()
					If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
				}	
			}
			
		}
	} catch ex {
		set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method GetSAMLData(pRequest)
{
	try { 
		Set pRequest.SAMLData.UserName="SFarrell"
		Set pRequest.SAMLData.HSRoles="%All"
		
	} catch ex {}
}

/// Verify whether the record has been verified with the same values in the last 24Hrs
Method ValidateHPII(pRequest As HS.AU.Message.HI.SearchIndividualProviderRequest, Output pResponse As HS.AU.Message.HI.SearchIndividualProviderResponse) As %Boolean
{
	try { 
		Set tSC=$$$OK
		If $l(pRequest.HPIINumber,"/")=1 {
			Set pRequest="http://ns.electronichealth.net.au/id/hi/hpii/1.0/"_pRequest
		}
		Set tItem = ##class(HS.AU.HPI.Management).ObjectForNumber(pRequest.HPIINumber)
		Do ..BuildHPIRequest(tItem,.tRequestData,pRequest)
		Set ..RequestData=tRequestData
		If $IsObject(tItem) {
			Set pResponse = ##class(HS.AU.Message.HI.SearchIndividualProviderResponse).%New()
			Quit:'..RevalidateHPI(tItem,.pResponse,tRequestData)
		} Else {
			Set tItem = ##class(HS.AU.HPI.Management).%New()
			Set tItem.Number=pRequest.HPIINumber
			Set tItem.Alert="Created"
		}
		Set tSC = ..SendRequestAsync(..QueryOperation,pRequest,1,"ValidateHPI") 
		If $$$ISERR(tSC) {
			Set tItem.Alert=$system.Status.GetErrorText(tSC)
			
		} Else {
		}
		Set tSC1=tItem.%Save()
		
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Verify whether the record has been verified with the same values in the last 24Hrs
Method ValidateHPIO(pRequest As HS.AU.Message.HI.SearchOrganisationProviderRequest, Output pResponse As HS.AU.Message.HI.SearchOrganisationProviderResponse) As %Boolean
{
	try { 
		Set tSC=$$$OK
		If $l(pRequest.HPIONumber,"/")=1 {
			Set pRequest="http://ns.electronichealth.net.au/id/hi/hpio/1.0/"_pRequest
		}
		Set tItem = ##class(HS.AU.HPI.Management).ObjectForNumber(pRequest.HPIONumber)
		Do ..BuildHPIRequest(tItem,.tRequestData,pRequest)
		Set ..RequestData=tRequestData
		If $IsObject(tItem) {
			Set pResponse = ##class(HS.AU.Message.HI.SearchOrganisationProviderResponse).%New()
			Quit:'..RevalidateHPI(tItem,.pResponse,tRequestData)
		} Else {
			Set tItem = ##class(HS.AU.HPI.Management).%New()
			Set tItem.Number=pRequest.HPIONumber
			Set tItem.Alert="Created"
		}
		Set tSC = ..SendRequestAsync(..QueryOperation,pRequest,1,"ValidateHPI") 
		If $$$ISERR(tSC) {
			Set tItem.Alert=$system.Status.GetErrorText(tSC)
		} Else {
		}
		Set tSC1=tItem.%Save()
		
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Validation String Property=value,Property=value ie FamilyName=FOSTER
ClassMethod BuildHPIRequest(pManagementItem As HS.AU.IHI.Management, Output pHistory = "", pRequest As Ens.Request = "") As %Status
{
	Try {
		Set tSC=$$$OK
		If pRequest.%IsA("HS.AU.Message.HI.SearchIndividualProviderRequest") {
			Set pHistory=pHistory_$lb("FamilyName",pRequest.FamilyName,"Number",pRequest.HPIINumber)
		} Else {
			Set pHistory=pHistory_$lb("Number",pRequest.HPIONumber)
		}
		
	} catch ex {
		set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Verify whether the record has been verified with the same values in the last 24Hrs
ClassMethod RevalidateHPI(pItem As HS.AU.IHI.Management, pResponse, pRequestData As %String) As %Boolean
{
	try {
		Set tRevalidate=1
		
		Set tNow=$ztimestamp
		Set tLast = $zdth(pItem.LastValidation,3)
		#; if more than 1 day, automatically validate
		Set tDiff = tNow-tLast
		If tDiff>1 Quit
		If tDiff=1 && ($p(tLast,",",2)-$p(tNow,",",2)<0) Quit

		Set tAlert=pItem.Alert
		If tAlert="Unusable" set tAlert=""
		#; an alert on the record requires revalidation
		If (tAlert]"" || (pItem.Number=""))  Quit
		If (tAlert="Created") Quit
		#; within 24 Hrs - validation depends on the values
		Set tHistory = pItem.History.GetAt(pItem.History.Count())
		If '$IsObject(tHistory) Quit
		If pRequestData=tHistory.RequestValues {
			Set tRevalidate=0
			If pResponse.%IsA("HS.AU.Message.HI.SearchIndividualProviderResponse") {
				Set pResponse.Result.HPIINumber=pItem.Number
				Set pResponse.Result.FamilyName=$li(pRequestData,$lf(pRequestData,"FamilyName")+1)
				Set pResponse.Result.Status=pItem.Status
			} Else {
				Set pResponse.Result.HPIONumber=pItem.Number
				Set pResponse.Result.Status=pItem.Status
			}
			Quit
		}
	} Catch ex {
	}
	Quit tRevalidate
}

Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	try {
		Set tSC=$$$OK
		If pCompletionKey="ValidateRow" {
			Set tSC = ..ValidateRowResponse(pRequest,.pResponse, pCallrequest, pCallresponse)
		} ElseIf pCompletionKey="ValidateHPI" {
			Set tSC = ..ValidateHPIRowResponse(pRequest,.pResponse, pCallrequest, pCallresponse)
		}
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

/// method called once the validation response (Web Service response) received
Method ValidateRowResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response) As %Status
{
	try {
		Set tSC=$$$OK
		If '$IsObject(pCallresponse) Set tSC = $$$ERROR($$$GeneralError,"No response") Quit
		Set tRequest = pRequest.OriginalRequest
		Set tItem = ##class(HS.AU.IHI.Management).MRNIndexOpen(tRequest.MRN,tRequest.AssigningAuthority,tRequest.Facility)
		Set tHistoryItem = ##class(HS.AU.IHI.Management.History).%New()
		Do tItem.History.Insert(tHistoryItem)
		Set tHistoryItem.RequestValues = ..RequestData

		If $$$ISERR(pCallresponse.ServiceCallStatus) {
			$$$LOGSTATUS(pCallresponse.ServiceCallStatus)
			Set tItem.Alert=$system.Status.GetErrorText(pCallresponse.ServiceCallStatus)
			Set tHistoryItem.RequestStatus=pCallresponse.ServiceCallStatus
		} ElseIf (pCallresponse.Result.ServiceMessages.HighestSeverity="" || (pCallresponse.Result.ServiceMessages.HighestSeverity="Informational")) {
			Set (tHistoryItem.Number,tItem.Number)=pCallresponse.Result.IHINumber
			Set (tHistoryItem.Status,tItem.Status)=pCallresponse.Result.IHIStatus
			Set (tHistoryItem.RecordStatus,tItem.RecordStatus)=pCallresponse.Result.IHIRecordStatus
			Set tHistoryItem.RequestStatus=$$$OK
			Set tItem.Alert=$S(tItem.RecordStatus="Verified"&&(tItem.Status="Active"):"",1:"Unusable")
		} Else {
			Set tHistoryItem.RequestStatus=$$$ERROR($$$GeneralError,pCallresponse.Result.ServiceMessages.ServiceMessage.GetAt(1).Reason)
			Set tItem.Alert=pCallresponse.Result.ServiceMessages.ServiceMessage.GetAt(1).Reason
		}
		Set tItem.LastValidation=$ZDateTime($ZTimeStamp, 3, 1, 2)
		Set tSC=tItem.%Save()
		#; don't update other MPIID records if this one failed 
		Do:$$$ISOK(pCallresponse.ServiceCallStatus) ..ValidateMPIID(..MPIID)
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

/// method called once the validation response (Web Service response) received
Method ValidateHPIRowResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response) As %Status
{
	try {
		Set tSC=$$$OK
		Set pResponse=pCallresponse
		If '$IsObject(pCallresponse) Set tSC = $$$ERROR($$$GeneralError,"No response") Quit
		Set tIndividual=1
		If pCallresponse.%IsA("HS.AU.Message.HI.SearchOrganisationProviderResponse") {
			Set tIndividual=0,tNumber=pRequest.HPIONumber
		} Else {
			Set tIndividual=1,tNumber=pRequest.HPIINumber
		}
		Set tItem = ##class(HS.AU.HPI.Management).ObjectForNumber(tNumber)
		
		Set tHistoryItem = ##class(HS.AU.HPI.Management.History).%New()
		Do tItem.History.Insert(tHistoryItem)
		Set tHistoryItem.RequestValues = ..RequestData

		If $$$ISERR(pCallresponse.ServiceCallStatus) {
			$$$LOGSTATUS(pCallresponse.ServiceCallStatus)
			Set tItem.Alert=$system.Status.GetErrorText(pCallresponse.ServiceCallStatus)
			Set tHistoryItem.RequestStatus=pCallresponse.ServiceCallStatus
		} ElseIf (pCallresponse.Result.ServiceMessages.HighestSeverity="" || (pCallresponse.Result.ServiceMessages.HighestSeverity="Informational")) {
			Set (tHistoryItem.Number,tItem.Number)=$S(tIndividual:pCallresponse.Result.HPIINumber,1:pCallresponse.Result.HPIONumber)
			Set (tHistoryItem.Status,tItem.Status)=pCallresponse.Result.Status
			Set tHistoryItem.RequestStatus=$$$OK
			Set tItem.Alert=$S(tItem.Status="A":"",1:"Unusable")
		} Else {
			Set tHistoryItem.RequestStatus=$$$ERROR($$$GeneralError,pCallresponse.Result.ServiceMessages.ServiceMessage.GetAt(1).Reason)
			Set tItem.Alert=pCallresponse.Result.ServiceMessages.ServiceMessage.GetAt(1).Reason
		}
		Set tItem.LastValidation=$ZDateTime($ZTimeStamp, 3, 1, 2)
		Set tSC=tItem.%Save()
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

Method OnComplete(request As Ens.Request, ByRef response As Ens.Response) As %Status
{
	Quit $$$OK
}

Method OnError(request As Ens.Request, ByRef response As Ens.Response, callrequest As Ens.Request, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	$$$TRACE("received error "_$$$StatusDisplayString(pErrorStatus))
	Quit $$$OK
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>QueryOperation</Value>
</Value>
<Value name="2">
<Value>RequestData</Value>
</Value>
<Value name="3">
<Value>MPIID</Value>
</Value>
<Value name="4">
<Value>CallCount</Value>
</Value>
<Value name="5">
<Value>ValidateItem</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

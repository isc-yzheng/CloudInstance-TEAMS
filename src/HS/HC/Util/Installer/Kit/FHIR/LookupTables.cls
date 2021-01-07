/// HS.HC.Util.Installer.Kit.FHIR.LookupTables sets up DTL Data Lookup Tables
/// for use with the FHIR-related DTL transforms.  If a given lookup table
/// is already established, an overwrite must be explicitly requested.
/// 
/// Example:
/// 
/// Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.LookupTables).Add( , "FHIR")
/// 
Class HS.HC.Util.Installer.Kit.FHIR.LookupTables Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = "", pOverwrite As %Boolean = 0) As %Status
{
	try {
		If pFoundationNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		Set tSC = ..AddFoundation(,pFoundationNS)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = "", pOverwrite As %Boolean = 0) As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		
		Set $Namespace = pNS
		
		If $$$WriteProg Write !!,"Loading Data Lookup Tables",!
		
		Kill tMappings
		Set tMappings(414285001)="food"
		Set tMappings(416098002)="medication"
		Set tMappings(426232007)="environment"
		Set tMappings("Drug")="medication"
		Set tMappings("DrugAllergy")="medication"
		Set tMappings("Environment")="environment"
		Set tMappings("EnvironmentalAllergy")="environment"
		Set tMappings("Food")="food"
		Set tMappings("FoodAllergy")="food"
		Set tMappings("drug")="medication"
		Set tMappings("environment")="environment"
		Set tMappings("food")="food"
		Do ..LoadTable("FromSDAAllergyCategory", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("Confirmed")="confirmed"
		Set tMappings("Likely")="likely"
		Set tMappings("Unlikely")="unlikely"
		Set tMappings("confirmed")="confirmed"
		Set tMappings("likely")="likely"
		Set tMappings("unlikely")="unlikely"
		Do ..LoadTable("FromSDAAllergyCertainty", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings(6736007)="moderate"
		Set tMappings(24484000)="severe"
		Set tMappings(255604002)="mild"
		Set tMappings("Mild")="mild"
		Set tMappings("Moderate")="moderate"
		Set tMappings("Severe")="severe"
		Set tMappings("mild")="mild"
		Set tMappings("moderate")="moderate"
		Set tMappings("severe")="severe"
		Do ..LoadTable("FromSDAAllergySeverity", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("A")="active"
		Set tMappings("C")="unconfirmed"
		Set tMappings("I")="inactive"
		Set tMappings("R")="resolved"
		Do ..LoadTable("FromSDAAllergyStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("BOOKED")="booked"
		Set tMappings("Booked")="booked"
		Set tMappings("CANCELLED")="cancelled"
		Set tMappings("Cancelled")="cancelled"
		Set tMappings("DC")="cancelled"
		Set tMappings("booked")="booked"
		Set tMappings("cancelled")="cancelled"
		Do ..LoadTable("FromSDAAppointmentStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("E")="emergency"
		Set tMappings("I")="inpatient"
		Set tMappings("O")="outpatient"
		Do ..LoadTable("FromSDAEncounterEncounterType", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("A")="in-progress"
		Set tMappings("C")="cancelled"
		Set tMappings("CA")="cancelled"
		Set tMappings("CM")="completed"
		Set tMappings("D")="rejected"
		Set tMappings("DC")="rejected"
		Set tMappings("E")="completed"
		Set tMappings("ER")="failed"
		Set tMappings("H")="suspended"
		Set tMappings("HD")="suspended"
		Set tMappings("IP")="in-progress"
		Set tMappings("R")="rejected"
		Set tMappings("RP")="rejected"
		Set tMappings("SC")="in-progress"
		Do ..LoadTable("FromSDALabOrderDiagnosticOrderStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("ASAP")="asap"
		Set tMappings("Asap")="asap"
		Set tMappings("R")="routine"
		Set tMappings("ROUTINE")="routine"
		Set tMappings("Routine")="routine"
		Set tMappings("STAT")="stat"
		Set tMappings("Stat")="stat"
		Set tMappings("URGENT")="urgent"
		Set tMappings("Urgent")="urgent"
		Set tMappings("asap")="asap"
		Set tMappings("routine")="routine"
		Set tMappings("stat")="stat"
		Set tMappings("urgent")="urgent"
		Do ..LoadTable("FromSDALabOrderDiagnosticOrderPriority", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("A")="partial"
		Set tMappings("C")="cancelled"
		Set tMappings("CA")="cancelled"
		Set tMappings("CM")="final"
		Set tMappings("D")="cancelled"
		Set tMappings("DC")="cancelled"
		Set tMappings("E")="final"
		Set tMappings("ER")="cancelled"
		Set tMappings("H")="partial"
		Set tMappings("HD")="partial"
		Set tMappings("IP")="partial"
		Set tMappings("R")="entered-in-error"
		Set tMappings("RP")="entered-in-error"
		Set tMappings("SC")="partial"
		Do ..LoadTable("FromSDALabOrderDiagnosticReportStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("C")="amended"
		Set tMappings("D")="cancelled"
		Set tMappings("F")="final"
		Set tMappings("I")="registered"
		Set tMappings("K")="amended"
		Set tMappings("N")="registered"
		Set tMappings("O")="preliminary"
		Set tMappings("P")="preliminary"
		Set tMappings("R")="preliminary"
		Set tMappings("S")="preliminary"
		Set tMappings("U")="final"
		Set tMappings("W")="entered-in-error"
		Set tMappings("X")="unknown"
		Do ..LoadTable("FromSDALabResultItemStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("A")="partial"
		Set tMappings("C")="corrected"
		Set tMappings("COR")="corrected"
		Set tMappings("ENT")="partial"
		Set tMappings("F")="final"
		Set tMappings("FIN")="final"
		Set tMappings("I")="registered"
		Set tMappings("K")="corrected"
		Set tMappings("O")="registered"
		Set tMappings("P")="partial"
		Set tMappings("R")="partial"
		Set tMappings("S")="registered"
		Set tMappings("V")="partial"
		Set tMappings("X")="cancelled"
		Do ..LoadTable("FromSDARadOrderDiagnosticReportStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("A")="preliminary"
		Set tMappings("C")="amended"
		Set tMappings("COR")="amended"
		Set tMappings("ENT")="preliminary"
		Set tMappings("F")="final"
		Set tMappings("FIN")="final"
		Set tMappings("I")="registered"
		Set tMappings("K")="amended"
		Set tMappings("O")="registered"
		Set tMappings("P")="preliminary"
		Set tMappings("R")="preliminary"
		Set tMappings("S")="registered"
		Set tMappings("V")="preliminary"
		Set tMappings("X")="cancelled"
		Do ..LoadTable("FromSDARadOrderObservationStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("C")="entered-in-error"
		Set tMappings("D")="entered-in-error"
		Set tMappings("E")="completed"
		Set tMappings("H")="on-hold"
		Set tMappings("I")="entered-in-error"
		Set tMappings("IP")="in-progress"
		Set tMappings("P")="in-progress"
		Set tMappings("PO")="in-progress"
		Set tMappings("Q")="in-progress"
		Set tMappings("R")="stopped"
		Set tMappings("S")="in-progress"
		Set tMappings("U")="in-progress"
		Set tMappings("V")="in-progress"
		Do ..LoadTable("FromSDAMedicationAdministrationStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("C")="entered-in-error"
		Set tMappings("D")="entered-in-error"
		Set tMappings("E")="completed"
		Set tMappings("H")="on-hold"
		Set tMappings("I")="entered-in-error"
		Set tMappings("IP")="in-progress"
		Set tMappings("P")="in-progress"
		Set tMappings("PO")="in-progress"
		Set tMappings("Q")="in-progress"
		Set tMappings("R")="stopped"
		Set tMappings("S")="in-progress"
		Set tMappings("U")="in-progress"
		Set tMappings("V")="in-progress"
		Do ..LoadTable("FromSDAMedicationDispenseStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("C")="stopped"
		Set tMappings("D")="stopped"
		Set tMappings("E")="completed"
		Set tMappings("H")="on-hold"
		Set tMappings("I")="entered-in-error"
		Set tMappings("IP")="active"
		Set tMappings("P")="active"
		Set tMappings("PO")="active"
		Set tMappings("Q")="active"
		Set tMappings("R")="stopped"
		Set tMappings("S")="active"
		Set tMappings("U")="active"
		Set tMappings("V")="active"
		Do ..LoadTable("FromSDAMedicationOrderStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("C")="stopped"
		Set tMappings("CA")="entered-in-error"
		Set tMappings("CM")="completed"
		Set tMappings("DC")="stopped"
		Set tMappings("E")="completed"
		Set tMappings("H")="on-hold"
		Set tMappings("HD")="on-hold"
		Set tMappings("IP")="in-progress"
		Set tMappings("SC")="in-progress"
		Set tMappings("V")="completed"
		Do ..LoadTable("FromSDAVaccinationStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("active")="A"
		Set tMappings("confirmed")="A"
		Set tMappings("entered-in-error")="C"
		Set tMappings("inactive")="I"
		Set tMappings("refuted")="C"
		Set tMappings("resolved")="R"
		Set tMappings("unconfirmed")="C"
		Do ..LoadTable("ToSDAAllergyStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("accepted")="IP"
		Set tMappings("cancelled")="CA"
		Set tMappings("completed")="CM"
		Set tMappings("draft")="SC"
		Set tMappings("failed")="ER"
		Set tMappings("in-progress")="IP"
		Set tMappings("planned")="SC"
		Set tMappings("proposed")="SC"
		Set tMappings("received")="IP"
		Set tMappings("rejected")="DC"
		Set tMappings("requested")="IP"
		Set tMappings("review")="IP"
		Set tMappings("suspended")="DC"
		Do ..LoadTable("ToSDADiagnosticOrderStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("appended")="E"
		Set tMappings("cancelled")="C"
		Set tMappings("corrected")="E"
		Set tMappings("entered-in-error")="R"
		Set tMappings("final")="E"
		Set tMappings("partial")="IP"
		Set tMappings("registered")="IP"
		Do ..LoadTable("ToSDADiagnosticReportStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("emergency")="E"
		Set tMappings("inpatient")="I"
		Set tMappings("outpatient")="O"
		Do ..LoadTable("ToSDAEncounterEncounterType", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("completed")="E"
		Set tMappings("entered-in-error")="C"
		Set tMappings("in-progress")="IP"
		Set tMappings("on-hold")="H"
		Set tMappings("stopped")="R"
		Do ..LoadTable("ToSDAMedicationDispenseStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("active")="IP"
		Set tMappings("completed")="E"
		Set tMappings("entered-in-error")="C"
		Set tMappings("in-progress")="IP"
		Set tMappings("on-hold")="H"
		Set tMappings("stopped")="R"
		Do ..LoadTable("ToSDAMedicationOrderStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("amended")="C"
		Set tMappings("cancelled")="D"
		Set tMappings("entered-in-error")="W"
		Set tMappings("final")="F"
		Set tMappings("preliminary")="P"
		Set tMappings("registered")="I"
		Set tMappings("unknown")="X"
		Do ..LoadTable("ToSDAObservationLabResultItemStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("amended")="C"
		Set tMappings("cancelled")="X"
		Set tMappings("entered-in-error")="X"
		Set tMappings("final")="F"
		Set tMappings("preliminary")="R"
		Set tMappings("registered")="I"
		Set tMappings("unknown")="X"
		Do ..LoadTable("ToSDAObservationRadResultStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("completed")="E"
		Set tMappings("entered-in-error")="C"
		Set tMappings("in-progress")="IP"
		Set tMappings("on-hold")="H"
		Set tMappings("stopped")="D"
		Do ..LoadTable("ToSDAImmunizationStatus", .tMappings, pOverwrite)
		
		Kill tMappings
		Set tMappings("junior")=1
		Set tMappings("jr")=1
		Set tMappings("jnr")=1
		Set tMappings("fils")=1
		Set tMappings("hijo")=1
		Set tMappings("menor")=1
		Set tMappings("senior")=1
		Set tMappings("snr")=1
		Set tMappings("senor")=1
		Set tMappings("pere")=1
		Set tMappings("i")=1
		Set tMappings("ii")=1
		Set tMappings("iii")=1
		Set tMappings("iv")=1
		Set tMappings("v")=1
		Set tMappings("segundo")=1
		Do ..LoadTable("ToSDAIsNameSuffix", .tMappings, pOverwrite)

		If $$$WriteProg Write !
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	If $$$ISERR(tSC) If $$$WriteProg Write !,$system.Status.GetErrorText(tSC)
	
	Quit tSC
}

ClassMethod LoadTable(pTableName As %String, ByRef pMappings As %String, pOverwrite As %Boolean)
{
	If ($Data(^Ens.LookupTable(pTableName))'>9)||(pOverwrite=1) {
		Merge ^Ens.LookupTable(pTableName) = pMappings
		Set ^Ens.LookupTable(pTableName)=$ListBuild($Horolog)
		If $$$WriteProg Write !,"Loaded "_pTableName
	} Else {
		If $$$WriteProg Write !,pTableName_" already exists - not overwritten"
	}
	Quit
}

}

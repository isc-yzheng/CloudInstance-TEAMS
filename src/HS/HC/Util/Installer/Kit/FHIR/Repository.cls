Include %ZHSLIB

/// HS.HC.Util.Installer.Kit.FHIR.Repository adds production components needed for supporting the FHIR resource repository.
/// 
/// Example:
/// 
/// Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.Repository).Add( , "FHIR", "STU3", "/csp/fhir")
/// 
Class HS.HC.Util.Installer.Kit.FHIR.Repository Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

/// This method calls AddFoundation() to add the FHIR components and definitions needed for supporting the resource repository.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) FHIR version (e.g., "DSTU2", "STU3").
/// <li>pCSPApp       : (required) CSP application name to use in the Conformance/CapabilityStatement
///                     resource that will be saved to the repository as part of this install.
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = "", pFHIRVersion As %String, pCSPApp As %String) As %Status
{
	Quit ..AddFoundation( , pFoundationNS, $Get(pFHIRVersion), pCSPApp)
}

/// This method adds the FHIR components and definitions needed for supporting the resource repository.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) FHIR version (e.g., "DSTU2", "STU3").
ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = "", pFHIRVersion As %String, pCSPApp As %String = "") As %Status
{
	New $Namespace
	
	New %propsByName
	New %HSFHIRPeriodParams
	New %HSFHIRSearchParams
	New %maxlocallength
	New %BitmapIndices
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set pNS = $ZConvert(pNS, "U")
		
		Set $Namespace = pNS
		
		Set tSC = ..ProductionMods(pNS, "FoundationItems"_pFHIRVersion, 1)
		If $$$ISERR(tSC) Quit
		
		If pFHIRVersion="DSTU2" {
			Set tXDataName = "InterSystemsConformanceDSTU2"
			Set tStorageClass = "HS.FHIR.vDSTU2.Repository.Storage"
			Set tResourceSchema = "HS.FHIR.vDSTU2.Model.Resource"
			Set tSearchTableBuilder = "HS.FHIR.vDSTU2.SearchTableBuilder"
		} ElseIf pFHIRVersion="STU3" {
			Set tXDataName = "InterSystemsFHIRCapabilitySTU3"
			Set tStorageClass = "HS.FHIR.vSTU3.Repository.Storage"
			Set tResourceSchema = "HS.FHIR.vSTU3.Model.Resource"
			Set tSearchTableBuilder = "HS.FHIR.vSTU3.SearchTableBuilder"
		}
		
		Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.CapabilityStatement).Add( , pNS, pFHIRVersion, ..%ClassName(1), tXDataName, "InterSystemsFHIR", pCSPApp, 1)
		If $$$ISERR(tSC) Quit
		
		Set $Namespace = pNS
		
		Set tSC = ##class(Ens.Director).GetProductionStatus(.tProdName, .tProdStatus)
		If $$$ISERR(tSC) Quit
		
		If tProdStatus=$$$eProductionStateStopped {
			Set tSC = ##class(HS.HC.Util.Installer).StartProduction(pNS, tProdName)
			Write !
		} ElseIf tProdStatus=$$$eProductionStateRunning {
			Set tSC = ##class(Ens.Director).UpdateProduction()
			Write !
		} ElseIf tProdStatus=$$$eProductionStateSuspended {
			Set tSC = $$$ERROR($$$GeneralError, "Production is currently suspended - cannot activate changes")
		} ElseIf tProdStatus=$$$eProductionStateTroubled {
			Set tSC = $$$ERROR($$$GeneralError, "Production is currently troubled - cannot activate changes")
		}
		If $$$ISERR(tSC) Quit
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	If $$$WriteProg {
		If $$$ISERR(tSC) {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC),!
		} Else {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" completed successfully",!
		}
	}
	
	Quit tSC
}

XData FoundationItemsDSTU2
{
<Items>
  <Item Name="HS.FHIR.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Repository.Operations.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Server.Process.DSTU2" Category="" ClassName="HS.FHIR.Server.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.Repository.Operations.DSTU2</Setting>
  </Item>
</Items>
}

XData FoundationItemsSTU3
{
<Items>
  <Item Name="HS.FHIR.Service.STU3" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Repository.Operations.STU3" Category="" ClassName="HS.FHIR.vSTU3.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Server.Process.STU3" Category="" ClassName="HS.FHIR.Server.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.Repository.Operations.STU3</Setting>
  </Item>
</Items>
}

XData InterSystemsConformanceDSTU2
{
<Conformance xmlns="http://hl7.org/fhir">
  <placeholder>resource_id</placeholder>
  <text>
    <status value="generated"/>
    <div xmlns="http://www.w3.org/1999/xhtml">
      <p>Conformance resource for InterSystems FHIR</p>
    </div>
  </text>
  <placeholder>url</placeholder>
  <version value="1"/>
  <name value="InterSystems Conformance statement"/>
  <status value="draft"/>
  <experimental value="true"/>
  <publisher value="InterSystems Corporation"/>
  <date value="2018-03-16"/>
  <kind value="instance"/>
  <placeholder>software</placeholder>
  <implementation>
    <description value="InterSystems FHIR server"/>
    <placeholder>implementation_url</placeholder>
  </implementation>
  <fhirVersion value="1.0.2"/>
  <acceptUnknown value="extensions"/>
  <format value="xml"/>
  <format value="json"/>
  <rest>
    <mode value="server"/>
    <security>
      <placeholder>security_oauth_uris_extension</placeholder>
      <placeholder>security_cors</placeholder>
      <placeholder>security_service</placeholder>
    </security>
    <resource>
      <type value="Account"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Account.owner"/>
      <searchInclude value="Account.patient"/>
      <searchInclude value="Account.subject"/>
      <searchParam>
        <name value="balance"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="owner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="AllergyIntolerance"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="AllergyIntolerance.patient"/>
      <searchInclude value="AllergyIntolerance.recorder"/>
      <searchInclude value="AllergyIntolerance.reporter"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="criticality"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="last-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="manifestation"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="onset"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="recorder"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reporter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="route"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="severity"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="substance"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Appointment"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Appointment.actor"/>
      <searchInclude value="Appointment.location"/>
      <searchInclude value="Appointment.patient"/>
      <searchInclude value="Appointment.practitioner"/>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="AppointmentResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="AppointmentResponse.actor"/>
      <searchInclude value="AppointmentResponse.appointment"/>
      <searchInclude value="AppointmentResponse.location"/>
      <searchInclude value="AppointmentResponse.patient"/>
      <searchInclude value="AppointmentResponse.practitioner"/>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="appointment"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="AuditEvent"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="AuditEvent.participant"/>
      <searchInclude value="AuditEvent.patient"/>
      <searchInclude value="AuditEvent.reference"/>
      <searchParam>
        <name value="action"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="altid"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="desc"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identity"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="object-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="participant"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="policy"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="reference"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="site"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subtype"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="user"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Basic"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Basic.author"/>
      <searchInclude value="Basic.patient"/>
      <searchInclude value="Basic.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Binary"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="contenttype"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Bundle"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="BodySite"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="BodySite.patient"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CarePlan"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="CarePlan.activityreference"/>
      <searchInclude value="CarePlan.condition"/>
      <searchInclude value="CarePlan.goal"/>
      <searchInclude value="CarePlan.participant"/>
      <searchInclude value="CarePlan.patient"/>
      <searchInclude value="CarePlan.performer"/>
      <searchInclude value="CarePlan.relatedplan"/>
      <searchInclude value="CarePlan.subject"/>
      <searchParam>
        <name value="activitycode"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="activitydate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="activityreference"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="condition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="goal"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="participant"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relatedcode"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="relatedplan"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Claim"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Claim.patient"/>
      <searchInclude value="Claim.provider"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="use"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ClaimResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ClinicalImpression"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ClinicalImpression.action"/>
      <searchInclude value="ClinicalImpression.assessor"/>
      <searchInclude value="ClinicalImpression.investigation"/>
      <searchInclude value="ClinicalImpression.patient"/>
      <searchInclude value="ClinicalImpression.plan"/>
      <searchInclude value="ClinicalImpression.previous"/>
      <searchInclude value="ClinicalImpression.problem"/>
      <searchInclude value="ClinicalImpression.trigger"/>
      <searchParam>
        <name value="action"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="assessor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="finding"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="investigation"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="plan"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="previous"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="problem"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="resolved"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="ruledout"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="trigger"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="trigger-code"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Communication"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Communication.encounter"/>
      <searchInclude value="Communication.patient"/>
      <searchInclude value="Communication.recipient"/>
      <searchInclude value="Communication.request"/>
      <searchInclude value="Communication.sender"/>
      <searchInclude value="Communication.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medium"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="received"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sender"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sent"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CommunicationRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="CommunicationRequest.encounter"/>
      <searchInclude value="CommunicationRequest.patient"/>
      <searchInclude value="CommunicationRequest.recipient"/>
      <searchInclude value="CommunicationRequest.requester"/>
      <searchInclude value="CommunicationRequest.sender"/>
      <searchInclude value="CommunicationRequest.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medium"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requested"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sender"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="time"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Composition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Composition.attester"/>
      <searchInclude value="Composition.author"/>
      <searchInclude value="Composition.encounter"/>
      <searchInclude value="Composition.entry"/>
      <searchInclude value="Composition.patient"/>
      <searchInclude value="Composition.subject"/>
      <searchParam>
        <name value="attester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="class"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="confidentiality"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="entry"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="section"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ConceptMap"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ConceptMap.source"/>
      <searchInclude value="ConceptMap.sourceuri"/>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dependson"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="product"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sourcecode"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="sourcesystem"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="sourceuri"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="targetcode"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="targetsystem"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Condition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Condition.asserter"/>
      <searchInclude value="Condition.encounter"/>
      <searchInclude value="Condition.patient"/>
      <searchParam>
        <name value="asserter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="body-site"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="clinicalstatus"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date-recorded"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="evidence"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="onset"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="onset-info"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="severity"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="stage"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Conformance"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Conformance.profile"/>
      <searchInclude value="Conformance.supported-profile"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="event"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="fhirversion"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="format"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="mode"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="profile"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="resource"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="security"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="software"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supported-profile"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Contract"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Contract.actor"/>
      <searchInclude value="Contract.patient"/>
      <searchInclude value="Contract.signer"/>
      <searchInclude value="Contract.subject"/>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="signer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Coverage"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Coverage.issuer"/>
      <searchParam>
        <name value="dependent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="group"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="issuer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="plan"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="sequence"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subplan"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DataElement"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="stringency"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="objectClass"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="objectClassProperty"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DetectedIssue"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DetectedIssue.author"/>
      <searchInclude value="DetectedIssue.implicated"/>
      <searchInclude value="DetectedIssue.patient"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="implicated"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Device"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Device.location"/>
      <searchInclude value="Device.organization"/>
      <searchInclude value="Device.patient"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="manufacturer"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="model"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="udi"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceComponent"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DeviceComponent.parent"/>
      <searchInclude value="DeviceComponent.source"/>
      <searchParam>
        <name value="parent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceMetric"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DeviceMetric.parent"/>
      <searchInclude value="DeviceMetric.source"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="parent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceUseRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DeviceUseRequest.device"/>
      <searchInclude value="DeviceUseRequest.patient"/>
      <searchInclude value="DeviceUseRequest.subject"/>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceUseStatement"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DeviceUseStatement.device"/>
      <searchInclude value="DeviceUseStatement.patient"/>
      <searchInclude value="DeviceUseStatement.subject"/>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DiagnosticOrder"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DiagnosticOrder.actor"/>
      <searchInclude value="DiagnosticOrder.encounter"/>
      <searchInclude value="DiagnosticOrder.orderer"/>
      <searchInclude value="DiagnosticOrder.patient"/>
      <searchInclude value="DiagnosticOrder.specimen"/>
      <searchInclude value="DiagnosticOrder.subject"/>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="bodysite"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="event-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="event-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="item-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="item-past-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="item-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="orderer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="specimen"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DiagnosticReport"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DiagnosticReport.encounter"/>
      <searchInclude value="DiagnosticReport.image"/>
      <searchInclude value="DiagnosticReport.patient"/>
      <searchInclude value="DiagnosticReport.performer"/>
      <searchInclude value="DiagnosticReport.request"/>
      <searchInclude value="DiagnosticReport.result"/>
      <searchInclude value="DiagnosticReport.specimen"/>
      <searchInclude value="DiagnosticReport.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="diagnosis"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="image"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="issued"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="result"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="specimen"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DocumentManifest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DocumentManifest.author"/>
      <searchInclude value="DocumentManifest.content-ref"/>
      <searchInclude value="DocumentManifest.patient"/>
      <searchInclude value="DocumentManifest.recipient"/>
      <searchInclude value="DocumentManifest.related-ref"/>
      <searchInclude value="DocumentManifest.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="content-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="related-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="related-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DocumentReference"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="DocumentReference.authenticator"/>
      <searchInclude value="DocumentReference.author"/>
      <searchInclude value="DocumentReference.custodian"/>
      <searchInclude value="DocumentReference.encounter"/>
      <searchInclude value="DocumentReference.patient"/>
      <searchInclude value="DocumentReference.related-ref"/>
      <searchInclude value="DocumentReference.relatesto"/>
      <searchInclude value="DocumentReference.subject"/>
      <searchParam>
        <name value="authenticator"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="class"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="custodian"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="event"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="facility"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="format"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="indexed"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="language"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="related-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="related-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relatesto"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relation"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="securitylabel"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="setting"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EligibilityRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EligibilityResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Encounter"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Encounter.appointment"/>
      <searchInclude value="Encounter.condition"/>
      <searchInclude value="Encounter.episodeofcare"/>
      <searchInclude value="Encounter.incomingreferral"/>
      <searchInclude value="Encounter.indication"/>
      <searchInclude value="Encounter.location"/>
      <searchInclude value="Encounter.part-of"/>
      <searchInclude value="Encounter.participant"/>
      <searchInclude value="Encounter.patient"/>
      <searchInclude value="Encounter.practitioner"/>
      <searchInclude value="Encounter.procedure"/>
      <searchParam>
        <name value="appointment"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="condition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="episodeofcare"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="incomingreferral"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="indication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="length"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="participant"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="participant-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="procedure"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="special-arrangement"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EnrollmentRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="EnrollmentRequest.patient"/>
      <searchInclude value="EnrollmentRequest.subject"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EnrollmentResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EpisodeOfCare"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="EpisodeOfCare.care-manager"/>
      <searchInclude value="EpisodeOfCare.condition"/>
      <searchInclude value="EpisodeOfCare.incomingreferral"/>
      <searchInclude value="EpisodeOfCare.organization"/>
      <searchInclude value="EpisodeOfCare.patient"/>
      <searchInclude value="EpisodeOfCare.team-member"/>
      <searchParam>
        <name value="care-manager"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="condition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="incomingreferral"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="team-member"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ExplanationOfBenefit"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="FamilyMemberHistory"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="FamilyMemberHistory.patient"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relationship"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Flag"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Flag.author"/>
      <searchInclude value="Flag.encounter"/>
      <searchInclude value="Flag.patient"/>
      <searchInclude value="Flag.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Generic"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
    </resource>
    <resource>
      <type value="Goal"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Goal.patient"/>
      <searchInclude value="Goal.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="targetdate"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Group"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Group.member"/>
      <searchParam>
        <name value="actual"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="characteristic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="exclude"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="member"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="value"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="HealthcareService"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="HealthcareService.location"/>
      <searchInclude value="HealthcareService.organization"/>
      <searchParam>
        <name value="characteristic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="programname"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="servicecategory"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="servicetype"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImagingObjectSelection"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ImagingObjectSelection.author"/>
      <searchInclude value="ImagingObjectSelection.patient"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="authoring-time"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="selected-study"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImagingStudy"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ImagingStudy.order"/>
      <searchInclude value="ImagingStudy.patient"/>
      <searchParam>
        <name value="accession"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="bodysite"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="dicom-class"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="modality"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="order"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="series"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="started"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="study"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="uid"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Immunization"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Immunization.location"/>
      <searchInclude value="Immunization.manufacturer"/>
      <searchInclude value="Immunization.patient"/>
      <searchInclude value="Immunization.performer"/>
      <searchInclude value="Immunization.reaction"/>
      <searchInclude value="Immunization.requester"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dose-sequence"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="lot-number"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="manufacturer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="notgiven"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reaction"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reaction-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="reason-not-given"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="vaccine-code"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImmunizationRecommendation"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ImmunizationRecommendation.information"/>
      <searchInclude value="ImmunizationRecommendation.patient"/>
      <searchInclude value="ImmunizationRecommendation.support"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dose-number"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="dose-sequence"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="information"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="support"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="vaccine-type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImplementationGuide"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dependency"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="experimental"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="List"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="List.encounter"/>
      <searchInclude value="List.item"/>
      <searchInclude value="List.patient"/>
      <searchInclude value="List.source"/>
      <searchInclude value="List.subject"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="empty-reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="item"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="notes"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Location"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Location.organization"/>
      <searchInclude value="Location.partof"/>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="partof"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Media"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Media.operator"/>
      <searchInclude value="Media.patient"/>
      <searchInclude value="Media.subject"/>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="operator"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subtype"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="view"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Medication"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Medication.content"/>
      <searchInclude value="Medication.ingredient"/>
      <searchInclude value="Medication.manufacturer"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="container"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="content"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="form"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="ingredient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="manufacturer"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationAdministration"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="MedicationAdministration.device"/>
      <searchInclude value="MedicationAdministration.encounter"/>
      <searchInclude value="MedicationAdministration.medication"/>
      <searchInclude value="MedicationAdministration.patient"/>
      <searchInclude value="MedicationAdministration.practitioner"/>
      <searchInclude value="MedicationAdministration.prescription"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="effectivetime"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="notgiven"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="prescription"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationDispense"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="MedicationDispense.destination"/>
      <searchInclude value="MedicationDispense.dispenser"/>
      <searchInclude value="MedicationDispense.medication"/>
      <searchInclude value="MedicationDispense.patient"/>
      <searchInclude value="MedicationDispense.prescription"/>
      <searchInclude value="MedicationDispense.receiver"/>
      <searchInclude value="MedicationDispense.responsibleparty"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="destination"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="dispenser"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="prescription"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="receiver"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="responsibleparty"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="whenhandedover"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="whenprepared"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationOrder"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="MedicationOrder.encounter"/>
      <searchInclude value="MedicationOrder.medication"/>
      <searchInclude value="MedicationOrder.patient"/>
      <searchInclude value="MedicationOrder.prescriber"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="datewritten"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="prescriber"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationStatement"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="MedicationStatement.medication"/>
      <searchInclude value="MedicationStatement.patient"/>
      <searchInclude value="MedicationStatement.source"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="effectivedate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MessageHeader"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="MessageHeader.author"/>
      <searchInclude value="MessageHeader.data"/>
      <searchInclude value="MessageHeader.enterer"/>
      <searchInclude value="MessageHeader.receiver"/>
      <searchInclude value="MessageHeader.responsible"/>
      <searchInclude value="MessageHeader.target"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="data"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="destination"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="destination-uri"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="enterer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="event"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="receiver"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="response-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="responsible"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="source-uri"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="timestamp"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="NamingSystem"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="NamingSystem.replaced-by"/>
      <searchParam>
        <name value="contact"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="id-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="kind"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="replaced-by"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="responsible"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="value"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="NutritionOrder"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="NutritionOrder.encounter"/>
      <searchInclude value="NutritionOrder.patient"/>
      <searchInclude value="NutritionOrder.provider"/>
      <searchParam>
        <name value="additive"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="datetime"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="formula"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="oraldiet"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supplement"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Observation"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Observation.device"/>
      <searchInclude value="Observation.encounter"/>
      <searchInclude value="Observation.patient"/>
      <searchInclude value="Observation.performer"/>
      <searchInclude value="Observation.related-target"/>
      <searchInclude value="Observation.specimen"/>
      <searchInclude value="Observation.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component-data-absent-reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component-value-concept"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component-value-quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="component-value-string"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="data-absent-reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="related-target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="related-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="specimen"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="value-concept"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="value-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="value-quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="value-string"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="OperationDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="OperationDefinition.base"/>
      <searchInclude value="OperationDefinition.profile"/>
      <searchParam>
        <name value="base"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="instance"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="kind"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="profile"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="system"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Order"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Order.detail"/>
      <searchInclude value="Order.patient"/>
      <searchInclude value="Order.source"/>
      <searchInclude value="Order.subject"/>
      <searchInclude value="Order.target"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="detail"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="when"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="when_code"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="OrderResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="OrderResponse.fulfillment"/>
      <searchInclude value="OrderResponse.request"/>
      <searchInclude value="OrderResponse.who"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="fulfillment"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="who"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Organization"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Organization.partof"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="partof"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Patient"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Patient.careprovider"/>
      <searchInclude value="Patient.link"/>
      <searchInclude value="Patient.organization"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="animal-breed"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="animal-species"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="birthdate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="careprovider"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="deathdate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="deceased"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="family"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="given"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="language"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="link"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="race"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="ethnicity"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="PaymentNotice"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="PaymentReconciliation"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Person"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Person.link"/>
      <searchInclude value="Person.organization"/>
      <searchInclude value="Person.patient"/>
      <searchInclude value="Person.practitioner"/>
      <searchInclude value="Person.relatedperson"/>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="birthdate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="link"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relatedperson"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Practitioner"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Practitioner.location"/>
      <searchInclude value="Practitioner.organization"/>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="communication"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="family"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="given"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="role"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="specialty"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Procedure"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Procedure.encounter"/>
      <searchInclude value="Procedure.location"/>
      <searchInclude value="Procedure.patient"/>
      <searchInclude value="Procedure.performer"/>
      <searchInclude value="Procedure.subject"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ProcedureRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ProcedureRequest.encounter"/>
      <searchInclude value="ProcedureRequest.orderer"/>
      <searchInclude value="ProcedureRequest.patient"/>
      <searchInclude value="ProcedureRequest.performer"/>
      <searchInclude value="ProcedureRequest.subject"/>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="orderer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ProcessRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ProcessRequest.organization"/>
      <searchInclude value="ProcessRequest.provider"/>
      <searchParam>
        <name value="action"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ProcessResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ProcessResponse.organization"/>
      <searchInclude value="ProcessResponse.request"/>
      <searchInclude value="ProcessResponse.requestorganization"/>
      <searchInclude value="ProcessResponse.requestprovider"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requestorganization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requestprovider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Provenance"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Provenance.agent"/>
      <searchInclude value="Provenance.location"/>
      <searchInclude value="Provenance.patient"/>
      <searchInclude value="Provenance.target"/>
      <searchParam>
        <name value="agent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="end"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="entity"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="entitytype"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sigtype"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="start"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="userid"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Questionnaire"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="QuestionnaireResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="QuestionnaireResponse.author"/>
      <searchInclude value="QuestionnaireResponse.encounter"/>
      <searchInclude value="QuestionnaireResponse.patient"/>
      <searchInclude value="QuestionnaireResponse.questionnaire"/>
      <searchInclude value="QuestionnaireResponse.source"/>
      <searchInclude value="QuestionnaireResponse.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="authored"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="questionnaire"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ReferralRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="ReferralRequest.patient"/>
      <searchInclude value="ReferralRequest.recipient"/>
      <searchInclude value="ReferralRequest.requester"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="specialty"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="RelatedPerson"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="RelatedPerson.patient"/>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="birthdate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="RiskAssessment"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="RiskAssessment.condition"/>
      <searchInclude value="RiskAssessment.encounter"/>
      <searchInclude value="RiskAssessment.patient"/>
      <searchInclude value="RiskAssessment.performer"/>
      <searchInclude value="RiskAssessment.subject"/>
      <searchParam>
        <name value="condition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="method"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Schedule"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Schedule.actor"/>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="SearchParameter"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="base"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Slot"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Slot.schedule"/>
      <searchParam>
        <name value="fb-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="schedule"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="slot-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="start"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Specimen"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Specimen.collector"/>
      <searchInclude value="Specimen.parent"/>
      <searchInclude value="Specimen.patient"/>
      <searchInclude value="Specimen.subject"/>
      <searchParam>
        <name value="accession"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="bodysite"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="collected"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="collector"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="container"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="container-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="parent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="StructureDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="abstract"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="base"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="base-path"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="display"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="experimental"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="ext-context"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="kind"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="path"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="valueset"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Subscription"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="contact"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="criteria"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="payload"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="tag"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Substance"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="Substance.substance"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="container-identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="expiry"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="substance"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="SupplyDelivery"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="SupplyDelivery.patient"/>
      <searchInclude value="SupplyDelivery.receiver"/>
      <searchInclude value="SupplyDelivery.supplier"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="receiver"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supplier"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="SupplyRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="SupplyRequest.patient"/>
      <searchInclude value="SupplyRequest.source"/>
      <searchInclude value="SupplyRequest.supplier"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="kind"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supplier"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="TestScript"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="testscript-capability"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="testscript-setup-capability"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="testscript-test-capability"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ValueSet"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="expansion"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="reference"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="system"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="VisionPrescription"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="false"/>
      <conditionalUpdate value="false"/>
      <conditionalDelete value="not-supported"/>
      <searchInclude value="VisionPrescription.encounter"/>
      <searchInclude value="VisionPrescription.patient"/>
      <searchInclude value="VisionPrescription.prescriber"/>
      <searchParam>
        <name value="datewritten"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="prescriber"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <interaction>
      <code value="transaction"/>
    </interaction>
    <interaction>
      <code value="search-system"/>
    </interaction>
    <searchParam><name value="_id"/><type value="token"/></searchParam>
    <searchParam><name value="_lastUpdated"/><type value="date"/></searchParam>
    <searchParam><name value="_profile"/><type value="uri"/></searchParam>
    <searchParam><name value="_security"/><type value="token"/></searchParam>
    <searchParam><name value="_tag"/><type value="token"/></searchParam>
  </rest>
</Conformance>
}

XData InterSystemsFHIRCapabilitySTU3
{
<CapabilityStatement xmlns="http://hl7.org/fhir">
   <placeholder>resource_id</placeholder>
   <text>
      <status value="generated"/>
      <div xmlns="http://www.w3.org/1999/xhtml">
                                                         <p>CapabilityStatement resource for InterSystems FHIR</p>
                                                                                                                       </div>
   </text>
   <placeholder>url</placeholder>
   <version value="1"/>
   <name value="InterSystems FHIR CapabilityStatement"/>
   <status value="draft"/>
   <experimental value="true"/>
   <date value="2018-03-05"/>
   <publisher value="InterSystems Corporation"/>
   <kind value="instance"/>
   <placeholder>software</placeholder>
   <implementation>
      <description value="InterSystems FHIR"/>
      <placeholder>implementation_url</placeholder>
   </implementation>
   <fhirVersion value="3.0.1"/>
   <acceptUnknown value="no"/>
   <format value="xml"/>
   <format value="json"/>
   <rest>
      <mode value="server"/>
      <security>
       <placeholder>security_oauth_uris_extension</placeholder>
      	<placeholder>security_cors</placeholder>
      	<placeholder>security_service</placeholder>
      </security>
    <resource>
      <type value="Account"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Account.owner"/>
      <searchInclude value="Account.patient"/>
      <searchInclude value="Account.subject"/>
      <searchInclude value="Account.owner"/>
      <searchInclude value="Account.patient"/>
      <searchInclude value="Account.subject"/>
      <searchInclude value="Account.owner"/>
      <searchInclude value="Account.patient"/>
      <searchInclude value="Account.subject"/>
      <searchParam>
        <name value="balance"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="owner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ActivityDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ActivityDefinition.composed-of"/>
      <searchInclude value="ActivityDefinition.depends-on"/>
      <searchInclude value="ActivityDefinition.derived-from"/>
      <searchInclude value="ActivityDefinition.predecessor"/>
      <searchInclude value="ActivityDefinition.successor"/>
      <searchInclude value="ActivityDefinition.composed-of"/>
      <searchInclude value="ActivityDefinition.depends-on"/>
      <searchInclude value="ActivityDefinition.derived-from"/>
      <searchInclude value="ActivityDefinition.predecessor"/>
      <searchInclude value="ActivityDefinition.successor"/>
      <searchInclude value="ActivityDefinition.composed-of"/>
      <searchInclude value="ActivityDefinition.depends-on"/>
      <searchInclude value="ActivityDefinition.derived-from"/>
      <searchInclude value="ActivityDefinition.predecessor"/>
      <searchInclude value="ActivityDefinition.successor"/>
      <searchParam>
        <name value="composed-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="depends-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="derived-from"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="effective"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="predecessor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="successor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="topic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="AdverseEvent"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="AdverseEvent.location"/>
      <searchInclude value="AdverseEvent.reaction"/>
      <searchInclude value="AdverseEvent.recorder"/>
      <searchInclude value="AdverseEvent.study"/>
      <searchInclude value="AdverseEvent.subject"/>
      <searchInclude value="AdverseEvent.substance"/>
      <searchInclude value="AdverseEvent.location"/>
      <searchInclude value="AdverseEvent.reaction"/>
      <searchInclude value="AdverseEvent.recorder"/>
      <searchInclude value="AdverseEvent.study"/>
      <searchInclude value="AdverseEvent.subject"/>
      <searchInclude value="AdverseEvent.substance"/>
      <searchInclude value="AdverseEvent.location"/>
      <searchInclude value="AdverseEvent.reaction"/>
      <searchInclude value="AdverseEvent.recorder"/>
      <searchInclude value="AdverseEvent.study"/>
      <searchInclude value="AdverseEvent.subject"/>
      <searchInclude value="AdverseEvent.substance"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reaction"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="recorder"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="seriousness"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="study"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="substance"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="AllergyIntolerance"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="AllergyIntolerance.asserter"/>
      <searchInclude value="AllergyIntolerance.patient"/>
      <searchInclude value="AllergyIntolerance.recorder"/>
      <searchInclude value="AllergyIntolerance.asserter"/>
      <searchInclude value="AllergyIntolerance.patient"/>
      <searchInclude value="AllergyIntolerance.recorder"/>
      <searchInclude value="AllergyIntolerance.asserter"/>
      <searchInclude value="AllergyIntolerance.patient"/>
      <searchInclude value="AllergyIntolerance.recorder"/>
      <searchParam>
        <name value="asserter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="clinical-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="criticality"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="last-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="manifestation"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="onset"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="recorder"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="route"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="severity"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="verification-status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Appointment"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Appointment.actor"/>
      <searchInclude value="Appointment.incomingreferral"/>
      <searchInclude value="Appointment.location"/>
      <searchInclude value="Appointment.patient"/>
      <searchInclude value="Appointment.practitioner"/>
      <searchInclude value="Appointment.actor"/>
      <searchInclude value="Appointment.incomingreferral"/>
      <searchInclude value="Appointment.location"/>
      <searchInclude value="Appointment.patient"/>
      <searchInclude value="Appointment.practitioner"/>
      <searchInclude value="Appointment.actor"/>
      <searchInclude value="Appointment.incomingreferral"/>
      <searchInclude value="Appointment.location"/>
      <searchInclude value="Appointment.patient"/>
      <searchInclude value="Appointment.practitioner"/>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="appointment-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="incomingreferral"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="service-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="AppointmentResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="AppointmentResponse.actor"/>
      <searchInclude value="AppointmentResponse.appointment"/>
      <searchInclude value="AppointmentResponse.location"/>
      <searchInclude value="AppointmentResponse.patient"/>
      <searchInclude value="AppointmentResponse.practitioner"/>
      <searchInclude value="AppointmentResponse.actor"/>
      <searchInclude value="AppointmentResponse.appointment"/>
      <searchInclude value="AppointmentResponse.location"/>
      <searchInclude value="AppointmentResponse.patient"/>
      <searchInclude value="AppointmentResponse.practitioner"/>
      <searchInclude value="AppointmentResponse.actor"/>
      <searchInclude value="AppointmentResponse.appointment"/>
      <searchInclude value="AppointmentResponse.location"/>
      <searchInclude value="AppointmentResponse.patient"/>
      <searchInclude value="AppointmentResponse.practitioner"/>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="appointment"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="AuditEvent"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="AuditEvent.agent"/>
      <searchInclude value="AuditEvent.entity"/>
      <searchInclude value="AuditEvent.patient"/>
      <searchInclude value="AuditEvent.agent"/>
      <searchInclude value="AuditEvent.entity"/>
      <searchInclude value="AuditEvent.patient"/>
      <searchInclude value="AuditEvent.agent"/>
      <searchInclude value="AuditEvent.entity"/>
      <searchInclude value="AuditEvent.patient"/>
      <searchParam>
        <name value="action"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="agent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="agent-name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="agent-role"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="altid"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="entity"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="entity-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="entity-name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="entity-role"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="entity-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="outcome"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="policy"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="site"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subtype"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="user"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Basic"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Basic.author"/>
      <searchInclude value="Basic.patient"/>
      <searchInclude value="Basic.subject"/>
      <searchInclude value="Basic.author"/>
      <searchInclude value="Basic.patient"/>
      <searchInclude value="Basic.subject"/>
      <searchInclude value="Basic.author"/>
      <searchInclude value="Basic.patient"/>
      <searchInclude value="Basic.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Binary"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="contenttype"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="BodySite"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="BodySite.patient"/>
      <searchInclude value="BodySite.patient"/>
      <searchInclude value="BodySite.patient"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Bundle"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="composition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="message"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CapabilityStatement"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="CapabilityStatement.resource-profile"/>
      <searchInclude value="CapabilityStatement.supported-profile"/>
      <searchInclude value="CapabilityStatement.resource-profile"/>
      <searchInclude value="CapabilityStatement.supported-profile"/>
      <searchInclude value="CapabilityStatement.resource-profile"/>
      <searchInclude value="CapabilityStatement.supported-profile"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="event"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="fhirversion"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="format"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="guide"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="mode"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="resource"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="resource-profile"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="security-service"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="software"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supported-profile"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CarePlan"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="CarePlan.activity-reference"/>
      <searchInclude value="CarePlan.based-on"/>
      <searchInclude value="CarePlan.care-team"/>
      <searchInclude value="CarePlan.condition"/>
      <searchInclude value="CarePlan.context"/>
      <searchInclude value="CarePlan.definition"/>
      <searchInclude value="CarePlan.encounter"/>
      <searchInclude value="CarePlan.goal"/>
      <searchInclude value="CarePlan.part-of"/>
      <searchInclude value="CarePlan.patient"/>
      <searchInclude value="CarePlan.performer"/>
      <searchInclude value="CarePlan.replaces"/>
      <searchInclude value="CarePlan.subject"/>
      <searchInclude value="CarePlan.activity-reference"/>
      <searchInclude value="CarePlan.based-on"/>
      <searchInclude value="CarePlan.care-team"/>
      <searchInclude value="CarePlan.condition"/>
      <searchInclude value="CarePlan.context"/>
      <searchInclude value="CarePlan.definition"/>
      <searchInclude value="CarePlan.encounter"/>
      <searchInclude value="CarePlan.goal"/>
      <searchInclude value="CarePlan.part-of"/>
      <searchInclude value="CarePlan.patient"/>
      <searchInclude value="CarePlan.performer"/>
      <searchInclude value="CarePlan.replaces"/>
      <searchInclude value="CarePlan.subject"/>
      <searchInclude value="CarePlan.activity-reference"/>
      <searchInclude value="CarePlan.based-on"/>
      <searchInclude value="CarePlan.care-team"/>
      <searchInclude value="CarePlan.condition"/>
      <searchInclude value="CarePlan.context"/>
      <searchInclude value="CarePlan.definition"/>
      <searchInclude value="CarePlan.encounter"/>
      <searchInclude value="CarePlan.goal"/>
      <searchInclude value="CarePlan.part-of"/>
      <searchInclude value="CarePlan.patient"/>
      <searchInclude value="CarePlan.performer"/>
      <searchInclude value="CarePlan.replaces"/>
      <searchInclude value="CarePlan.subject"/>
      <searchParam>
        <name value="activity-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="activity-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="activity-reference"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="care-team"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="condition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="goal"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="intent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="part-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="replaces"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CareTeam"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="CareTeam.context"/>
      <searchInclude value="CareTeam.encounter"/>
      <searchInclude value="CareTeam.participant"/>
      <searchInclude value="CareTeam.patient"/>
      <searchInclude value="CareTeam.subject"/>
      <searchInclude value="CareTeam.context"/>
      <searchInclude value="CareTeam.encounter"/>
      <searchInclude value="CareTeam.participant"/>
      <searchInclude value="CareTeam.patient"/>
      <searchInclude value="CareTeam.subject"/>
      <searchInclude value="CareTeam.context"/>
      <searchInclude value="CareTeam.encounter"/>
      <searchInclude value="CareTeam.participant"/>
      <searchInclude value="CareTeam.patient"/>
      <searchInclude value="CareTeam.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="participant"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ChargeItem"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ChargeItem.account"/>
      <searchInclude value="ChargeItem.context"/>
      <searchInclude value="ChargeItem.enterer"/>
      <searchInclude value="ChargeItem.participant-actor"/>
      <searchInclude value="ChargeItem.patient"/>
      <searchInclude value="ChargeItem.performing-organization"/>
      <searchInclude value="ChargeItem.requesting-organization"/>
      <searchInclude value="ChargeItem.service"/>
      <searchInclude value="ChargeItem.subject"/>
      <searchInclude value="ChargeItem.account"/>
      <searchInclude value="ChargeItem.context"/>
      <searchInclude value="ChargeItem.enterer"/>
      <searchInclude value="ChargeItem.participant-actor"/>
      <searchInclude value="ChargeItem.patient"/>
      <searchInclude value="ChargeItem.performing-organization"/>
      <searchInclude value="ChargeItem.requesting-organization"/>
      <searchInclude value="ChargeItem.service"/>
      <searchInclude value="ChargeItem.subject"/>
      <searchInclude value="ChargeItem.account"/>
      <searchInclude value="ChargeItem.context"/>
      <searchInclude value="ChargeItem.enterer"/>
      <searchInclude value="ChargeItem.participant-actor"/>
      <searchInclude value="ChargeItem.patient"/>
      <searchInclude value="ChargeItem.performing-organization"/>
      <searchInclude value="ChargeItem.requesting-organization"/>
      <searchInclude value="ChargeItem.service"/>
      <searchInclude value="ChargeItem.subject"/>
      <searchParam>
        <name value="account"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="entered-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="enterer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="factor-override"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="occurrence"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="participant-actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="participant-role"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performing-organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="price-override"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="requesting-organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="service"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Claim"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Claim.care-team"/>
      <searchInclude value="Claim.encounter"/>
      <searchInclude value="Claim.enterer"/>
      <searchInclude value="Claim.facility"/>
      <searchInclude value="Claim.insurer"/>
      <searchInclude value="Claim.organization"/>
      <searchInclude value="Claim.patient"/>
      <searchInclude value="Claim.payee"/>
      <searchInclude value="Claim.provider"/>
      <searchInclude value="Claim.care-team"/>
      <searchInclude value="Claim.encounter"/>
      <searchInclude value="Claim.enterer"/>
      <searchInclude value="Claim.facility"/>
      <searchInclude value="Claim.insurer"/>
      <searchInclude value="Claim.organization"/>
      <searchInclude value="Claim.patient"/>
      <searchInclude value="Claim.payee"/>
      <searchInclude value="Claim.provider"/>
      <searchInclude value="Claim.care-team"/>
      <searchInclude value="Claim.encounter"/>
      <searchInclude value="Claim.enterer"/>
      <searchInclude value="Claim.facility"/>
      <searchInclude value="Claim.insurer"/>
      <searchInclude value="Claim.organization"/>
      <searchInclude value="Claim.patient"/>
      <searchInclude value="Claim.payee"/>
      <searchInclude value="Claim.provider"/>
      <searchParam>
        <name value="care-team"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="enterer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="facility"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="insurer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="payee"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="use"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ClaimResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ClaimResponse.insurer"/>
      <searchInclude value="ClaimResponse.patient"/>
      <searchInclude value="ClaimResponse.request"/>
      <searchInclude value="ClaimResponse.request-provider"/>
      <searchInclude value="ClaimResponse.insurer"/>
      <searchInclude value="ClaimResponse.patient"/>
      <searchInclude value="ClaimResponse.request"/>
      <searchInclude value="ClaimResponse.request-provider"/>
      <searchInclude value="ClaimResponse.insurer"/>
      <searchInclude value="ClaimResponse.patient"/>
      <searchInclude value="ClaimResponse.request"/>
      <searchInclude value="ClaimResponse.request-provider"/>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="disposition"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="insurer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="outcome"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="payment-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request-provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ClinicalImpression"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ClinicalImpression.action"/>
      <searchInclude value="ClinicalImpression.assessor"/>
      <searchInclude value="ClinicalImpression.context"/>
      <searchInclude value="ClinicalImpression.finding-ref"/>
      <searchInclude value="ClinicalImpression.investigation"/>
      <searchInclude value="ClinicalImpression.patient"/>
      <searchInclude value="ClinicalImpression.previous"/>
      <searchInclude value="ClinicalImpression.problem"/>
      <searchInclude value="ClinicalImpression.subject"/>
      <searchInclude value="ClinicalImpression.action"/>
      <searchInclude value="ClinicalImpression.assessor"/>
      <searchInclude value="ClinicalImpression.context"/>
      <searchInclude value="ClinicalImpression.finding-ref"/>
      <searchInclude value="ClinicalImpression.investigation"/>
      <searchInclude value="ClinicalImpression.patient"/>
      <searchInclude value="ClinicalImpression.previous"/>
      <searchInclude value="ClinicalImpression.problem"/>
      <searchInclude value="ClinicalImpression.subject"/>
      <searchInclude value="ClinicalImpression.action"/>
      <searchInclude value="ClinicalImpression.assessor"/>
      <searchInclude value="ClinicalImpression.context"/>
      <searchInclude value="ClinicalImpression.finding-ref"/>
      <searchInclude value="ClinicalImpression.investigation"/>
      <searchInclude value="ClinicalImpression.patient"/>
      <searchInclude value="ClinicalImpression.previous"/>
      <searchInclude value="ClinicalImpression.problem"/>
      <searchInclude value="ClinicalImpression.subject"/>
      <searchParam>
        <name value="action"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="assessor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="finding-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="finding-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="investigation"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="previous"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="problem"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CodeSystem"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="content-mode"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="language"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="system"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Communication"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Communication.based-on"/>
      <searchInclude value="Communication.context"/>
      <searchInclude value="Communication.definition"/>
      <searchInclude value="Communication.encounter"/>
      <searchInclude value="Communication.part-of"/>
      <searchInclude value="Communication.patient"/>
      <searchInclude value="Communication.recipient"/>
      <searchInclude value="Communication.sender"/>
      <searchInclude value="Communication.subject"/>
      <searchInclude value="Communication.based-on"/>
      <searchInclude value="Communication.context"/>
      <searchInclude value="Communication.definition"/>
      <searchInclude value="Communication.encounter"/>
      <searchInclude value="Communication.part-of"/>
      <searchInclude value="Communication.patient"/>
      <searchInclude value="Communication.recipient"/>
      <searchInclude value="Communication.sender"/>
      <searchInclude value="Communication.subject"/>
      <searchInclude value="Communication.based-on"/>
      <searchInclude value="Communication.context"/>
      <searchInclude value="Communication.definition"/>
      <searchInclude value="Communication.encounter"/>
      <searchInclude value="Communication.part-of"/>
      <searchInclude value="Communication.patient"/>
      <searchInclude value="Communication.recipient"/>
      <searchInclude value="Communication.sender"/>
      <searchInclude value="Communication.subject"/>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medium"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="part-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="received"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sender"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sent"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CommunicationRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="CommunicationRequest.based-on"/>
      <searchInclude value="CommunicationRequest.context"/>
      <searchInclude value="CommunicationRequest.encounter"/>
      <searchInclude value="CommunicationRequest.patient"/>
      <searchInclude value="CommunicationRequest.recipient"/>
      <searchInclude value="CommunicationRequest.replaces"/>
      <searchInclude value="CommunicationRequest.requester"/>
      <searchInclude value="CommunicationRequest.sender"/>
      <searchInclude value="CommunicationRequest.subject"/>
      <searchInclude value="CommunicationRequest.based-on"/>
      <searchInclude value="CommunicationRequest.context"/>
      <searchInclude value="CommunicationRequest.encounter"/>
      <searchInclude value="CommunicationRequest.patient"/>
      <searchInclude value="CommunicationRequest.recipient"/>
      <searchInclude value="CommunicationRequest.replaces"/>
      <searchInclude value="CommunicationRequest.requester"/>
      <searchInclude value="CommunicationRequest.sender"/>
      <searchInclude value="CommunicationRequest.subject"/>
      <searchInclude value="CommunicationRequest.based-on"/>
      <searchInclude value="CommunicationRequest.context"/>
      <searchInclude value="CommunicationRequest.encounter"/>
      <searchInclude value="CommunicationRequest.patient"/>
      <searchInclude value="CommunicationRequest.recipient"/>
      <searchInclude value="CommunicationRequest.replaces"/>
      <searchInclude value="CommunicationRequest.requester"/>
      <searchInclude value="CommunicationRequest.sender"/>
      <searchInclude value="CommunicationRequest.subject"/>
      <searchParam>
        <name value="authored"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="group-identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medium"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="occurrence"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="replaces"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sender"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="CompartmentDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="resource"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Composition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Composition.attester"/>
      <searchInclude value="Composition.author"/>
      <searchInclude value="Composition.encounter"/>
      <searchInclude value="Composition.entry"/>
      <searchInclude value="Composition.patient"/>
      <searchInclude value="Composition.related-ref"/>
      <searchInclude value="Composition.subject"/>
      <searchInclude value="Composition.attester"/>
      <searchInclude value="Composition.author"/>
      <searchInclude value="Composition.encounter"/>
      <searchInclude value="Composition.entry"/>
      <searchInclude value="Composition.patient"/>
      <searchInclude value="Composition.related-ref"/>
      <searchInclude value="Composition.subject"/>
      <searchInclude value="Composition.attester"/>
      <searchInclude value="Composition.author"/>
      <searchInclude value="Composition.encounter"/>
      <searchInclude value="Composition.entry"/>
      <searchInclude value="Composition.patient"/>
      <searchInclude value="Composition.related-ref"/>
      <searchInclude value="Composition.subject"/>
      <searchParam>
        <name value="attester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="class"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="confidentiality"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="entry"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="related-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="related-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="section"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ConceptMap"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ConceptMap.source"/>
      <searchInclude value="ConceptMap.source-uri"/>
      <searchInclude value="ConceptMap.target"/>
      <searchInclude value="ConceptMap.target-uri"/>
      <searchInclude value="ConceptMap.source"/>
      <searchInclude value="ConceptMap.source-uri"/>
      <searchInclude value="ConceptMap.target"/>
      <searchInclude value="ConceptMap.target-uri"/>
      <searchInclude value="ConceptMap.source"/>
      <searchInclude value="ConceptMap.source-uri"/>
      <searchInclude value="ConceptMap.target"/>
      <searchInclude value="ConceptMap.target-uri"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dependson"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="other"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="product"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="source-system"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="source-uri"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="target-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="target-system"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="target-uri"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Condition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Condition.asserter"/>
      <searchInclude value="Condition.context"/>
      <searchInclude value="Condition.encounter"/>
      <searchInclude value="Condition.evidence-detail"/>
      <searchInclude value="Condition.patient"/>
      <searchInclude value="Condition.subject"/>
      <searchInclude value="Condition.asserter"/>
      <searchInclude value="Condition.context"/>
      <searchInclude value="Condition.encounter"/>
      <searchInclude value="Condition.evidence-detail"/>
      <searchInclude value="Condition.patient"/>
      <searchInclude value="Condition.subject"/>
      <searchInclude value="Condition.asserter"/>
      <searchInclude value="Condition.context"/>
      <searchInclude value="Condition.encounter"/>
      <searchInclude value="Condition.evidence-detail"/>
      <searchInclude value="Condition.patient"/>
      <searchInclude value="Condition.subject"/>
      <searchParam>
        <name value="abatement-age"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="abatement-boolean"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="abatement-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="abatement-string"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="asserted-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="asserter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="body-site"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="clinical-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="evidence"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="evidence-detail"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="onset-age"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="onset-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="onset-info"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="severity"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="stage"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="verification-status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Consent"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Consent.actor"/>
      <searchInclude value="Consent.consentor"/>
      <searchInclude value="Consent.data"/>
      <searchInclude value="Consent.organization"/>
      <searchInclude value="Consent.patient"/>
      <searchInclude value="Consent.actor"/>
      <searchInclude value="Consent.consentor"/>
      <searchInclude value="Consent.data"/>
      <searchInclude value="Consent.organization"/>
      <searchInclude value="Consent.patient"/>
      <searchInclude value="Consent.actor"/>
      <searchInclude value="Consent.consentor"/>
      <searchInclude value="Consent.data"/>
      <searchInclude value="Consent.organization"/>
      <searchInclude value="Consent.patient"/>
      <searchParam>
        <name value="action"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="consentor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="data"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="purpose"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="securitylabel"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Contract"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Contract.agent"/>
      <searchInclude value="Contract.authority"/>
      <searchInclude value="Contract.domain"/>
      <searchInclude value="Contract.patient"/>
      <searchInclude value="Contract.signer"/>
      <searchInclude value="Contract.subject"/>
      <searchInclude value="Contract.term-topic"/>
      <searchInclude value="Contract.agent"/>
      <searchInclude value="Contract.authority"/>
      <searchInclude value="Contract.domain"/>
      <searchInclude value="Contract.patient"/>
      <searchInclude value="Contract.signer"/>
      <searchInclude value="Contract.subject"/>
      <searchInclude value="Contract.term-topic"/>
      <searchInclude value="Contract.agent"/>
      <searchInclude value="Contract.authority"/>
      <searchInclude value="Contract.domain"/>
      <searchInclude value="Contract.patient"/>
      <searchInclude value="Contract.signer"/>
      <searchInclude value="Contract.subject"/>
      <searchInclude value="Contract.term-topic"/>
      <searchParam>
        <name value="agent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="authority"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="domain"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="issued"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="signer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="term-topic"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Coverage"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Coverage.beneficiary"/>
      <searchInclude value="Coverage.payor"/>
      <searchInclude value="Coverage.policy-holder"/>
      <searchInclude value="Coverage.subscriber"/>
      <searchInclude value="Coverage.beneficiary"/>
      <searchInclude value="Coverage.payor"/>
      <searchInclude value="Coverage.policy-holder"/>
      <searchInclude value="Coverage.subscriber"/>
      <searchInclude value="Coverage.beneficiary"/>
      <searchInclude value="Coverage.payor"/>
      <searchInclude value="Coverage.policy-holder"/>
      <searchInclude value="Coverage.subscriber"/>
      <searchParam>
        <name value="beneficiary"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="class"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="dependent"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="group"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="payor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="plan"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="policy-holder"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sequence"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="subclass"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="subgroup"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="subplan"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="subscriber"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DataElement"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="objectClass"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="objectClassProperty"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="stringency"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DetectedIssue"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DetectedIssue.author"/>
      <searchInclude value="DetectedIssue.implicated"/>
      <searchInclude value="DetectedIssue.patient"/>
      <searchInclude value="DetectedIssue.author"/>
      <searchInclude value="DetectedIssue.implicated"/>
      <searchInclude value="DetectedIssue.patient"/>
      <searchInclude value="DetectedIssue.author"/>
      <searchInclude value="DetectedIssue.implicated"/>
      <searchInclude value="DetectedIssue.patient"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="implicated"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Device"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Device.location"/>
      <searchInclude value="Device.organization"/>
      <searchInclude value="Device.patient"/>
      <searchInclude value="Device.location"/>
      <searchInclude value="Device.organization"/>
      <searchInclude value="Device.patient"/>
      <searchInclude value="Device.location"/>
      <searchInclude value="Device.organization"/>
      <searchInclude value="Device.patient"/>
      <searchParam>
        <name value="device-name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="manufacturer"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="model"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="udi-carrier"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="udi-di"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceComponent"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DeviceComponent.parent"/>
      <searchInclude value="DeviceComponent.source"/>
      <searchInclude value="DeviceComponent.parent"/>
      <searchInclude value="DeviceComponent.source"/>
      <searchInclude value="DeviceComponent.parent"/>
      <searchInclude value="DeviceComponent.source"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="parent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceMetric"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DeviceMetric.parent"/>
      <searchInclude value="DeviceMetric.source"/>
      <searchInclude value="DeviceMetric.parent"/>
      <searchInclude value="DeviceMetric.source"/>
      <searchInclude value="DeviceMetric.parent"/>
      <searchInclude value="DeviceMetric.source"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="parent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DeviceRequest.based-on"/>
      <searchInclude value="DeviceRequest.definition"/>
      <searchInclude value="DeviceRequest.device"/>
      <searchInclude value="DeviceRequest.encounter"/>
      <searchInclude value="DeviceRequest.patient"/>
      <searchInclude value="DeviceRequest.performer"/>
      <searchInclude value="DeviceRequest.priorrequest"/>
      <searchInclude value="DeviceRequest.requester"/>
      <searchInclude value="DeviceRequest.subject"/>
      <searchInclude value="DeviceRequest.based-on"/>
      <searchInclude value="DeviceRequest.definition"/>
      <searchInclude value="DeviceRequest.device"/>
      <searchInclude value="DeviceRequest.encounter"/>
      <searchInclude value="DeviceRequest.patient"/>
      <searchInclude value="DeviceRequest.performer"/>
      <searchInclude value="DeviceRequest.priorrequest"/>
      <searchInclude value="DeviceRequest.requester"/>
      <searchInclude value="DeviceRequest.subject"/>
      <searchInclude value="DeviceRequest.based-on"/>
      <searchInclude value="DeviceRequest.definition"/>
      <searchInclude value="DeviceRequest.device"/>
      <searchInclude value="DeviceRequest.encounter"/>
      <searchInclude value="DeviceRequest.patient"/>
      <searchInclude value="DeviceRequest.performer"/>
      <searchInclude value="DeviceRequest.priorrequest"/>
      <searchInclude value="DeviceRequest.requester"/>
      <searchInclude value="DeviceRequest.subject"/>
      <searchParam>
        <name value="authored-on"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="event-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="group-identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="intent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priorrequest"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DeviceUseStatement"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DeviceUseStatement.device"/>
      <searchInclude value="DeviceUseStatement.patient"/>
      <searchInclude value="DeviceUseStatement.subject"/>
      <searchInclude value="DeviceUseStatement.device"/>
      <searchInclude value="DeviceUseStatement.patient"/>
      <searchInclude value="DeviceUseStatement.subject"/>
      <searchInclude value="DeviceUseStatement.device"/>
      <searchInclude value="DeviceUseStatement.patient"/>
      <searchInclude value="DeviceUseStatement.subject"/>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DiagnosticReport"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DiagnosticReport.based-on"/>
      <searchInclude value="DiagnosticReport.context"/>
      <searchInclude value="DiagnosticReport.encounter"/>
      <searchInclude value="DiagnosticReport.image"/>
      <searchInclude value="DiagnosticReport.patient"/>
      <searchInclude value="DiagnosticReport.performer"/>
      <searchInclude value="DiagnosticReport.result"/>
      <searchInclude value="DiagnosticReport.specimen"/>
      <searchInclude value="DiagnosticReport.subject"/>
      <searchInclude value="DiagnosticReport.based-on"/>
      <searchInclude value="DiagnosticReport.context"/>
      <searchInclude value="DiagnosticReport.encounter"/>
      <searchInclude value="DiagnosticReport.image"/>
      <searchInclude value="DiagnosticReport.patient"/>
      <searchInclude value="DiagnosticReport.performer"/>
      <searchInclude value="DiagnosticReport.result"/>
      <searchInclude value="DiagnosticReport.specimen"/>
      <searchInclude value="DiagnosticReport.subject"/>
      <searchInclude value="DiagnosticReport.based-on"/>
      <searchInclude value="DiagnosticReport.context"/>
      <searchInclude value="DiagnosticReport.encounter"/>
      <searchInclude value="DiagnosticReport.image"/>
      <searchInclude value="DiagnosticReport.patient"/>
      <searchInclude value="DiagnosticReport.performer"/>
      <searchInclude value="DiagnosticReport.result"/>
      <searchInclude value="DiagnosticReport.specimen"/>
      <searchInclude value="DiagnosticReport.subject"/>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="diagnosis"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="image"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="issued"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="result"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="specimen"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DocumentManifest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DocumentManifest.author"/>
      <searchInclude value="DocumentManifest.content-ref"/>
      <searchInclude value="DocumentManifest.patient"/>
      <searchInclude value="DocumentManifest.recipient"/>
      <searchInclude value="DocumentManifest.related-ref"/>
      <searchInclude value="DocumentManifest.subject"/>
      <searchInclude value="DocumentManifest.author"/>
      <searchInclude value="DocumentManifest.content-ref"/>
      <searchInclude value="DocumentManifest.patient"/>
      <searchInclude value="DocumentManifest.recipient"/>
      <searchInclude value="DocumentManifest.related-ref"/>
      <searchInclude value="DocumentManifest.subject"/>
      <searchInclude value="DocumentManifest.author"/>
      <searchInclude value="DocumentManifest.content-ref"/>
      <searchInclude value="DocumentManifest.patient"/>
      <searchInclude value="DocumentManifest.recipient"/>
      <searchInclude value="DocumentManifest.related-ref"/>
      <searchInclude value="DocumentManifest.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="content-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="related-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="related-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DocumentReference"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="DocumentReference.authenticator"/>
      <searchInclude value="DocumentReference.author"/>
      <searchInclude value="DocumentReference.custodian"/>
      <searchInclude value="DocumentReference.encounter"/>
      <searchInclude value="DocumentReference.patient"/>
      <searchInclude value="DocumentReference.related-ref"/>
      <searchInclude value="DocumentReference.relatesto"/>
      <searchInclude value="DocumentReference.subject"/>
      <searchInclude value="DocumentReference.authenticator"/>
      <searchInclude value="DocumentReference.author"/>
      <searchInclude value="DocumentReference.custodian"/>
      <searchInclude value="DocumentReference.encounter"/>
      <searchInclude value="DocumentReference.patient"/>
      <searchInclude value="DocumentReference.related-ref"/>
      <searchInclude value="DocumentReference.relatesto"/>
      <searchInclude value="DocumentReference.subject"/>
      <searchInclude value="DocumentReference.authenticator"/>
      <searchInclude value="DocumentReference.author"/>
      <searchInclude value="DocumentReference.custodian"/>
      <searchInclude value="DocumentReference.encounter"/>
      <searchInclude value="DocumentReference.patient"/>
      <searchInclude value="DocumentReference.related-ref"/>
      <searchInclude value="DocumentReference.relatesto"/>
      <searchInclude value="DocumentReference.subject"/>
      <searchParam>
        <name value="authenticator"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="class"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="custodian"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="event"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="facility"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="format"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="indexed"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="language"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="related-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="related-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relatesto"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relation"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="relationship"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="securitylabel"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="setting"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="DomainResource"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="_text"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EligibilityRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="EligibilityRequest.enterer"/>
      <searchInclude value="EligibilityRequest.facility"/>
      <searchInclude value="EligibilityRequest.organization"/>
      <searchInclude value="EligibilityRequest.patient"/>
      <searchInclude value="EligibilityRequest.provider"/>
      <searchInclude value="EligibilityRequest.enterer"/>
      <searchInclude value="EligibilityRequest.facility"/>
      <searchInclude value="EligibilityRequest.organization"/>
      <searchInclude value="EligibilityRequest.patient"/>
      <searchInclude value="EligibilityRequest.provider"/>
      <searchInclude value="EligibilityRequest.enterer"/>
      <searchInclude value="EligibilityRequest.facility"/>
      <searchInclude value="EligibilityRequest.organization"/>
      <searchInclude value="EligibilityRequest.patient"/>
      <searchInclude value="EligibilityRequest.provider"/>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="enterer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="facility"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EligibilityResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="EligibilityResponse.insurer"/>
      <searchInclude value="EligibilityResponse.request"/>
      <searchInclude value="EligibilityResponse.request-organization"/>
      <searchInclude value="EligibilityResponse.request-provider"/>
      <searchInclude value="EligibilityResponse.insurer"/>
      <searchInclude value="EligibilityResponse.request"/>
      <searchInclude value="EligibilityResponse.request-organization"/>
      <searchInclude value="EligibilityResponse.request-provider"/>
      <searchInclude value="EligibilityResponse.insurer"/>
      <searchInclude value="EligibilityResponse.request"/>
      <searchInclude value="EligibilityResponse.request-organization"/>
      <searchInclude value="EligibilityResponse.request-provider"/>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="disposition"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="insurer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="outcome"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request-organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request-provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Encounter"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Encounter.appointment"/>
      <searchInclude value="Encounter.diagnosis"/>
      <searchInclude value="Encounter.episodeofcare"/>
      <searchInclude value="Encounter.incomingreferral"/>
      <searchInclude value="Encounter.location"/>
      <searchInclude value="Encounter.part-of"/>
      <searchInclude value="Encounter.participant"/>
      <searchInclude value="Encounter.patient"/>
      <searchInclude value="Encounter.practitioner"/>
      <searchInclude value="Encounter.service-provider"/>
      <searchInclude value="Encounter.subject"/>
      <searchInclude value="Encounter.appointment"/>
      <searchInclude value="Encounter.diagnosis"/>
      <searchInclude value="Encounter.episodeofcare"/>
      <searchInclude value="Encounter.incomingreferral"/>
      <searchInclude value="Encounter.location"/>
      <searchInclude value="Encounter.part-of"/>
      <searchInclude value="Encounter.participant"/>
      <searchInclude value="Encounter.patient"/>
      <searchInclude value="Encounter.practitioner"/>
      <searchInclude value="Encounter.service-provider"/>
      <searchInclude value="Encounter.subject"/>
      <searchInclude value="Encounter.appointment"/>
      <searchInclude value="Encounter.diagnosis"/>
      <searchInclude value="Encounter.episodeofcare"/>
      <searchInclude value="Encounter.incomingreferral"/>
      <searchInclude value="Encounter.location"/>
      <searchInclude value="Encounter.part-of"/>
      <searchInclude value="Encounter.participant"/>
      <searchInclude value="Encounter.patient"/>
      <searchInclude value="Encounter.practitioner"/>
      <searchInclude value="Encounter.service-provider"/>
      <searchInclude value="Encounter.subject"/>
      <searchParam>
        <name value="appointment"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="class"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="diagnosis"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="episodeofcare"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="incomingreferral"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="length"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="location-period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="part-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="participant"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="participant-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="service-provider"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="special-arrangement"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Endpoint"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Endpoint.organization"/>
      <searchInclude value="Endpoint.organization"/>
      <searchInclude value="Endpoint.organization"/>
      <searchParam>
        <name value="connection-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="payload-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EnrollmentRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="EnrollmentRequest.organization"/>
      <searchInclude value="EnrollmentRequest.patient"/>
      <searchInclude value="EnrollmentRequest.subject"/>
      <searchInclude value="EnrollmentRequest.organization"/>
      <searchInclude value="EnrollmentRequest.patient"/>
      <searchInclude value="EnrollmentRequest.subject"/>
      <searchInclude value="EnrollmentRequest.organization"/>
      <searchInclude value="EnrollmentRequest.patient"/>
      <searchInclude value="EnrollmentRequest.subject"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EnrollmentResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="EnrollmentResponse.organization"/>
      <searchInclude value="EnrollmentResponse.request"/>
      <searchInclude value="EnrollmentResponse.organization"/>
      <searchInclude value="EnrollmentResponse.request"/>
      <searchInclude value="EnrollmentResponse.organization"/>
      <searchInclude value="EnrollmentResponse.request"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="EpisodeOfCare"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="EpisodeOfCare.care-manager"/>
      <searchInclude value="EpisodeOfCare.condition"/>
      <searchInclude value="EpisodeOfCare.incomingreferral"/>
      <searchInclude value="EpisodeOfCare.organization"/>
      <searchInclude value="EpisodeOfCare.patient"/>
      <searchInclude value="EpisodeOfCare.care-manager"/>
      <searchInclude value="EpisodeOfCare.condition"/>
      <searchInclude value="EpisodeOfCare.incomingreferral"/>
      <searchInclude value="EpisodeOfCare.organization"/>
      <searchInclude value="EpisodeOfCare.patient"/>
      <searchInclude value="EpisodeOfCare.care-manager"/>
      <searchInclude value="EpisodeOfCare.condition"/>
      <searchInclude value="EpisodeOfCare.incomingreferral"/>
      <searchInclude value="EpisodeOfCare.organization"/>
      <searchInclude value="EpisodeOfCare.patient"/>
      <searchParam>
        <name value="care-manager"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="condition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="incomingreferral"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ExpansionProfile"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ExplanationOfBenefit"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ExplanationOfBenefit.care-team"/>
      <searchInclude value="ExplanationOfBenefit.claim"/>
      <searchInclude value="ExplanationOfBenefit.coverage"/>
      <searchInclude value="ExplanationOfBenefit.encounter"/>
      <searchInclude value="ExplanationOfBenefit.enterer"/>
      <searchInclude value="ExplanationOfBenefit.facility"/>
      <searchInclude value="ExplanationOfBenefit.organization"/>
      <searchInclude value="ExplanationOfBenefit.patient"/>
      <searchInclude value="ExplanationOfBenefit.payee"/>
      <searchInclude value="ExplanationOfBenefit.provider"/>
      <searchInclude value="ExplanationOfBenefit.care-team"/>
      <searchInclude value="ExplanationOfBenefit.claim"/>
      <searchInclude value="ExplanationOfBenefit.coverage"/>
      <searchInclude value="ExplanationOfBenefit.encounter"/>
      <searchInclude value="ExplanationOfBenefit.enterer"/>
      <searchInclude value="ExplanationOfBenefit.facility"/>
      <searchInclude value="ExplanationOfBenefit.organization"/>
      <searchInclude value="ExplanationOfBenefit.patient"/>
      <searchInclude value="ExplanationOfBenefit.payee"/>
      <searchInclude value="ExplanationOfBenefit.provider"/>
      <searchInclude value="ExplanationOfBenefit.care-team"/>
      <searchInclude value="ExplanationOfBenefit.claim"/>
      <searchInclude value="ExplanationOfBenefit.coverage"/>
      <searchInclude value="ExplanationOfBenefit.encounter"/>
      <searchInclude value="ExplanationOfBenefit.enterer"/>
      <searchInclude value="ExplanationOfBenefit.facility"/>
      <searchInclude value="ExplanationOfBenefit.organization"/>
      <searchInclude value="ExplanationOfBenefit.patient"/>
      <searchInclude value="ExplanationOfBenefit.payee"/>
      <searchInclude value="ExplanationOfBenefit.provider"/>
      <searchParam>
        <name value="care-team"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="claim"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="coverage"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="disposition"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="enterer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="facility"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="payee"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="FamilyMemberHistory"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="FamilyMemberHistory.definition"/>
      <searchInclude value="FamilyMemberHistory.patient"/>
      <searchInclude value="FamilyMemberHistory.definition"/>
      <searchInclude value="FamilyMemberHistory.patient"/>
      <searchInclude value="FamilyMemberHistory.definition"/>
      <searchInclude value="FamilyMemberHistory.patient"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relationship"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Flag"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Flag.author"/>
      <searchInclude value="Flag.encounter"/>
      <searchInclude value="Flag.patient"/>
      <searchInclude value="Flag.subject"/>
      <searchInclude value="Flag.author"/>
      <searchInclude value="Flag.encounter"/>
      <searchInclude value="Flag.patient"/>
      <searchInclude value="Flag.subject"/>
      <searchInclude value="Flag.author"/>
      <searchInclude value="Flag.encounter"/>
      <searchInclude value="Flag.patient"/>
      <searchInclude value="Flag.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Goal"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Goal.patient"/>
      <searchInclude value="Goal.subject"/>
      <searchInclude value="Goal.patient"/>
      <searchInclude value="Goal.subject"/>
      <searchInclude value="Goal.patient"/>
      <searchInclude value="Goal.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="start-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="target-date"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="GraphDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="start"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Group"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Group.member"/>
      <searchInclude value="Group.member"/>
      <searchInclude value="Group.member"/>
      <searchParam>
        <name value="actual"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="characteristic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="characteristic-value"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="exclude"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="member"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="value"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="GuidanceResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="GuidanceResponse.patient"/>
      <searchInclude value="GuidanceResponse.subject"/>
      <searchInclude value="GuidanceResponse.patient"/>
      <searchInclude value="GuidanceResponse.subject"/>
      <searchInclude value="GuidanceResponse.patient"/>
      <searchInclude value="GuidanceResponse.subject"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="HealthcareService"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="HealthcareService.endpoint"/>
      <searchInclude value="HealthcareService.location"/>
      <searchInclude value="HealthcareService.organization"/>
      <searchInclude value="HealthcareService.endpoint"/>
      <searchInclude value="HealthcareService.location"/>
      <searchInclude value="HealthcareService.organization"/>
      <searchInclude value="HealthcareService.endpoint"/>
      <searchInclude value="HealthcareService.location"/>
      <searchInclude value="HealthcareService.organization"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="characteristic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="endpoint"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="programname"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImagingManifest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ImagingManifest.author"/>
      <searchInclude value="ImagingManifest.endpoint"/>
      <searchInclude value="ImagingManifest.imaging-study"/>
      <searchInclude value="ImagingManifest.patient"/>
      <searchInclude value="ImagingManifest.author"/>
      <searchInclude value="ImagingManifest.endpoint"/>
      <searchInclude value="ImagingManifest.imaging-study"/>
      <searchInclude value="ImagingManifest.patient"/>
      <searchInclude value="ImagingManifest.author"/>
      <searchInclude value="ImagingManifest.endpoint"/>
      <searchInclude value="ImagingManifest.imaging-study"/>
      <searchInclude value="ImagingManifest.patient"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="authoring-time"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="endpoint"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="imaging-study"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="selected-study"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImagingStudy"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ImagingStudy.basedon"/>
      <searchInclude value="ImagingStudy.context"/>
      <searchInclude value="ImagingStudy.endpoint"/>
      <searchInclude value="ImagingStudy.patient"/>
      <searchInclude value="ImagingStudy.performer"/>
      <searchInclude value="ImagingStudy.basedon"/>
      <searchInclude value="ImagingStudy.context"/>
      <searchInclude value="ImagingStudy.endpoint"/>
      <searchInclude value="ImagingStudy.patient"/>
      <searchInclude value="ImagingStudy.performer"/>
      <searchInclude value="ImagingStudy.basedon"/>
      <searchInclude value="ImagingStudy.context"/>
      <searchInclude value="ImagingStudy.endpoint"/>
      <searchInclude value="ImagingStudy.patient"/>
      <searchInclude value="ImagingStudy.performer"/>
      <searchParam>
        <name value="accession"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="basedon"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="bodysite"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="dicom-class"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="endpoint"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="modality"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="series"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="started"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="study"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="uid"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Immunization"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Immunization.location"/>
      <searchInclude value="Immunization.manufacturer"/>
      <searchInclude value="Immunization.patient"/>
      <searchInclude value="Immunization.practitioner"/>
      <searchInclude value="Immunization.reaction"/>
      <searchInclude value="Immunization.location"/>
      <searchInclude value="Immunization.manufacturer"/>
      <searchInclude value="Immunization.patient"/>
      <searchInclude value="Immunization.practitioner"/>
      <searchInclude value="Immunization.reaction"/>
      <searchInclude value="Immunization.location"/>
      <searchInclude value="Immunization.manufacturer"/>
      <searchInclude value="Immunization.patient"/>
      <searchInclude value="Immunization.practitioner"/>
      <searchInclude value="Immunization.reaction"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dose-sequence"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="lot-number"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="manufacturer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="notgiven"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reaction"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reaction-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="reason-not-given"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="vaccine-code"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImmunizationRecommendation"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ImmunizationRecommendation.information"/>
      <searchInclude value="ImmunizationRecommendation.patient"/>
      <searchInclude value="ImmunizationRecommendation.support"/>
      <searchInclude value="ImmunizationRecommendation.information"/>
      <searchInclude value="ImmunizationRecommendation.patient"/>
      <searchInclude value="ImmunizationRecommendation.support"/>
      <searchInclude value="ImmunizationRecommendation.information"/>
      <searchInclude value="ImmunizationRecommendation.patient"/>
      <searchInclude value="ImmunizationRecommendation.support"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dose-number"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="dose-sequence"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="information"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="support"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="target-disease"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="vaccine-type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ImplementationGuide"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="dependency"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="experimental"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="resource"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Library"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Library.composed-of"/>
      <searchInclude value="Library.depends-on"/>
      <searchInclude value="Library.derived-from"/>
      <searchInclude value="Library.predecessor"/>
      <searchInclude value="Library.successor"/>
      <searchInclude value="Library.composed-of"/>
      <searchInclude value="Library.depends-on"/>
      <searchInclude value="Library.derived-from"/>
      <searchInclude value="Library.predecessor"/>
      <searchInclude value="Library.successor"/>
      <searchInclude value="Library.composed-of"/>
      <searchInclude value="Library.depends-on"/>
      <searchInclude value="Library.derived-from"/>
      <searchInclude value="Library.predecessor"/>
      <searchInclude value="Library.successor"/>
      <searchParam>
        <name value="composed-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="depends-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="derived-from"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="effective"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="predecessor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="successor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="topic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Linkage"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Linkage.author"/>
      <searchInclude value="Linkage.item"/>
      <searchInclude value="Linkage.source"/>
      <searchInclude value="Linkage.author"/>
      <searchInclude value="Linkage.item"/>
      <searchInclude value="Linkage.source"/>
      <searchInclude value="Linkage.author"/>
      <searchInclude value="Linkage.item"/>
      <searchInclude value="Linkage.source"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="item"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="List"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="List.encounter"/>
      <searchInclude value="List.item"/>
      <searchInclude value="List.patient"/>
      <searchInclude value="List.source"/>
      <searchInclude value="List.subject"/>
      <searchInclude value="List.encounter"/>
      <searchInclude value="List.item"/>
      <searchInclude value="List.patient"/>
      <searchInclude value="List.source"/>
      <searchInclude value="List.subject"/>
      <searchInclude value="List.encounter"/>
      <searchInclude value="List.item"/>
      <searchInclude value="List.patient"/>
      <searchInclude value="List.source"/>
      <searchInclude value="List.subject"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="empty-reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="item"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="notes"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Location"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Location.endpoint"/>
      <searchInclude value="Location.organization"/>
      <searchInclude value="Location.partof"/>
      <searchInclude value="Location.endpoint"/>
      <searchInclude value="Location.organization"/>
      <searchInclude value="Location.partof"/>
      <searchInclude value="Location.endpoint"/>
      <searchInclude value="Location.organization"/>
      <searchInclude value="Location.partof"/>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="endpoint"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="near"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="near-distance"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="operational-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="partof"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Measure"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Measure.composed-of"/>
      <searchInclude value="Measure.depends-on"/>
      <searchInclude value="Measure.derived-from"/>
      <searchInclude value="Measure.predecessor"/>
      <searchInclude value="Measure.successor"/>
      <searchInclude value="Measure.composed-of"/>
      <searchInclude value="Measure.depends-on"/>
      <searchInclude value="Measure.derived-from"/>
      <searchInclude value="Measure.predecessor"/>
      <searchInclude value="Measure.successor"/>
      <searchInclude value="Measure.composed-of"/>
      <searchInclude value="Measure.depends-on"/>
      <searchInclude value="Measure.derived-from"/>
      <searchInclude value="Measure.predecessor"/>
      <searchInclude value="Measure.successor"/>
      <searchParam>
        <name value="composed-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="depends-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="derived-from"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="effective"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="predecessor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="successor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="topic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MeasureReport"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="MeasureReport.patient"/>
      <searchInclude value="MeasureReport.patient"/>
      <searchInclude value="MeasureReport.patient"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Media"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Media.based-on"/>
      <searchInclude value="Media.context"/>
      <searchInclude value="Media.device"/>
      <searchInclude value="Media.operator"/>
      <searchInclude value="Media.patient"/>
      <searchInclude value="Media.subject"/>
      <searchInclude value="Media.based-on"/>
      <searchInclude value="Media.context"/>
      <searchInclude value="Media.device"/>
      <searchInclude value="Media.operator"/>
      <searchInclude value="Media.patient"/>
      <searchInclude value="Media.subject"/>
      <searchInclude value="Media.based-on"/>
      <searchInclude value="Media.context"/>
      <searchInclude value="Media.device"/>
      <searchInclude value="Media.operator"/>
      <searchInclude value="Media.patient"/>
      <searchInclude value="Media.subject"/>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="operator"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="site"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="subtype"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="view"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Medication"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Medication.ingredient"/>
      <searchInclude value="Medication.manufacturer"/>
      <searchInclude value="Medication.package-item"/>
      <searchInclude value="Medication.ingredient"/>
      <searchInclude value="Medication.manufacturer"/>
      <searchInclude value="Medication.package-item"/>
      <searchInclude value="Medication.ingredient"/>
      <searchInclude value="Medication.manufacturer"/>
      <searchInclude value="Medication.package-item"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="container"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="form"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="ingredient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="ingredient-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="manufacturer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="over-the-counter"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="package-item"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="package-item-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationAdministration"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="MedicationAdministration.context"/>
      <searchInclude value="MedicationAdministration.device"/>
      <searchInclude value="MedicationAdministration.medication"/>
      <searchInclude value="MedicationAdministration.patient"/>
      <searchInclude value="MedicationAdministration.performer"/>
      <searchInclude value="MedicationAdministration.prescription"/>
      <searchInclude value="MedicationAdministration.subject"/>
      <searchInclude value="MedicationAdministration.context"/>
      <searchInclude value="MedicationAdministration.device"/>
      <searchInclude value="MedicationAdministration.medication"/>
      <searchInclude value="MedicationAdministration.patient"/>
      <searchInclude value="MedicationAdministration.performer"/>
      <searchInclude value="MedicationAdministration.prescription"/>
      <searchInclude value="MedicationAdministration.subject"/>
      <searchInclude value="MedicationAdministration.context"/>
      <searchInclude value="MedicationAdministration.device"/>
      <searchInclude value="MedicationAdministration.medication"/>
      <searchInclude value="MedicationAdministration.patient"/>
      <searchInclude value="MedicationAdministration.performer"/>
      <searchInclude value="MedicationAdministration.prescription"/>
      <searchInclude value="MedicationAdministration.subject"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="effective-time"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="not-given"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="prescription"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="reason-given"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="reason-not-given"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationDispense"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="MedicationDispense.context"/>
      <searchInclude value="MedicationDispense.destination"/>
      <searchInclude value="MedicationDispense.medication"/>
      <searchInclude value="MedicationDispense.patient"/>
      <searchInclude value="MedicationDispense.performer"/>
      <searchInclude value="MedicationDispense.prescription"/>
      <searchInclude value="MedicationDispense.receiver"/>
      <searchInclude value="MedicationDispense.responsibleparty"/>
      <searchInclude value="MedicationDispense.subject"/>
      <searchInclude value="MedicationDispense.context"/>
      <searchInclude value="MedicationDispense.destination"/>
      <searchInclude value="MedicationDispense.medication"/>
      <searchInclude value="MedicationDispense.patient"/>
      <searchInclude value="MedicationDispense.performer"/>
      <searchInclude value="MedicationDispense.prescription"/>
      <searchInclude value="MedicationDispense.receiver"/>
      <searchInclude value="MedicationDispense.responsibleparty"/>
      <searchInclude value="MedicationDispense.subject"/>
      <searchInclude value="MedicationDispense.context"/>
      <searchInclude value="MedicationDispense.destination"/>
      <searchInclude value="MedicationDispense.medication"/>
      <searchInclude value="MedicationDispense.patient"/>
      <searchInclude value="MedicationDispense.performer"/>
      <searchInclude value="MedicationDispense.prescription"/>
      <searchInclude value="MedicationDispense.receiver"/>
      <searchInclude value="MedicationDispense.responsibleparty"/>
      <searchInclude value="MedicationDispense.subject"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="destination"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="prescription"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="receiver"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="responsibleparty"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="whenhandedover"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="whenprepared"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="MedicationRequest.context"/>
      <searchInclude value="MedicationRequest.intended-dispenser"/>
      <searchInclude value="MedicationRequest.medication"/>
      <searchInclude value="MedicationRequest.patient"/>
      <searchInclude value="MedicationRequest.requester"/>
      <searchInclude value="MedicationRequest.subject"/>
      <searchInclude value="MedicationRequest.context"/>
      <searchInclude value="MedicationRequest.intended-dispenser"/>
      <searchInclude value="MedicationRequest.medication"/>
      <searchInclude value="MedicationRequest.patient"/>
      <searchInclude value="MedicationRequest.requester"/>
      <searchInclude value="MedicationRequest.subject"/>
      <searchInclude value="MedicationRequest.context"/>
      <searchInclude value="MedicationRequest.intended-dispenser"/>
      <searchInclude value="MedicationRequest.medication"/>
      <searchInclude value="MedicationRequest.patient"/>
      <searchInclude value="MedicationRequest.requester"/>
      <searchInclude value="MedicationRequest.subject"/>
      <searchParam>
        <name value="authoredon"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="intended-dispenser"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="intent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MedicationStatement"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="MedicationStatement.context"/>
      <searchInclude value="MedicationStatement.medication"/>
      <searchInclude value="MedicationStatement.part-of"/>
      <searchInclude value="MedicationStatement.patient"/>
      <searchInclude value="MedicationStatement.source"/>
      <searchInclude value="MedicationStatement.subject"/>
      <searchInclude value="MedicationStatement.context"/>
      <searchInclude value="MedicationStatement.medication"/>
      <searchInclude value="MedicationStatement.part-of"/>
      <searchInclude value="MedicationStatement.patient"/>
      <searchInclude value="MedicationStatement.source"/>
      <searchInclude value="MedicationStatement.subject"/>
      <searchInclude value="MedicationStatement.context"/>
      <searchInclude value="MedicationStatement.medication"/>
      <searchInclude value="MedicationStatement.part-of"/>
      <searchInclude value="MedicationStatement.patient"/>
      <searchInclude value="MedicationStatement.source"/>
      <searchInclude value="MedicationStatement.subject"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="effective"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="medication"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MessageDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="event"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="focus"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="MessageHeader"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="MessageHeader.author"/>
      <searchInclude value="MessageHeader.enterer"/>
      <searchInclude value="MessageHeader.focus"/>
      <searchInclude value="MessageHeader.receiver"/>
      <searchInclude value="MessageHeader.responsible"/>
      <searchInclude value="MessageHeader.sender"/>
      <searchInclude value="MessageHeader.target"/>
      <searchInclude value="MessageHeader.author"/>
      <searchInclude value="MessageHeader.enterer"/>
      <searchInclude value="MessageHeader.focus"/>
      <searchInclude value="MessageHeader.receiver"/>
      <searchInclude value="MessageHeader.responsible"/>
      <searchInclude value="MessageHeader.sender"/>
      <searchInclude value="MessageHeader.target"/>
      <searchInclude value="MessageHeader.author"/>
      <searchInclude value="MessageHeader.enterer"/>
      <searchInclude value="MessageHeader.focus"/>
      <searchInclude value="MessageHeader.receiver"/>
      <searchInclude value="MessageHeader.responsible"/>
      <searchInclude value="MessageHeader.sender"/>
      <searchInclude value="MessageHeader.target"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="destination"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="destination-uri"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="enterer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="event"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="focus"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="receiver"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="response-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="responsible"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sender"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="source-uri"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="timestamp"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="NamingSystem"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="NamingSystem.replaced-by"/>
      <searchInclude value="NamingSystem.replaced-by"/>
      <searchInclude value="NamingSystem.replaced-by"/>
      <searchParam>
        <name value="contact"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="id-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="kind"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="replaced-by"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="responsible"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="value"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="NutritionOrder"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="NutritionOrder.encounter"/>
      <searchInclude value="NutritionOrder.patient"/>
      <searchInclude value="NutritionOrder.provider"/>
      <searchInclude value="NutritionOrder.encounter"/>
      <searchInclude value="NutritionOrder.patient"/>
      <searchInclude value="NutritionOrder.provider"/>
      <searchInclude value="NutritionOrder.encounter"/>
      <searchInclude value="NutritionOrder.patient"/>
      <searchInclude value="NutritionOrder.provider"/>
      <searchParam>
        <name value="additive"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="datetime"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="formula"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="oraldiet"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supplement"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Observation"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Observation.based-on"/>
      <searchInclude value="Observation.context"/>
      <searchInclude value="Observation.device"/>
      <searchInclude value="Observation.encounter"/>
      <searchInclude value="Observation.patient"/>
      <searchInclude value="Observation.performer"/>
      <searchInclude value="Observation.related-target"/>
      <searchInclude value="Observation.specimen"/>
      <searchInclude value="Observation.subject"/>
      <searchInclude value="Observation.based-on"/>
      <searchInclude value="Observation.context"/>
      <searchInclude value="Observation.device"/>
      <searchInclude value="Observation.encounter"/>
      <searchInclude value="Observation.patient"/>
      <searchInclude value="Observation.performer"/>
      <searchInclude value="Observation.related-target"/>
      <searchInclude value="Observation.specimen"/>
      <searchInclude value="Observation.subject"/>
      <searchInclude value="Observation.based-on"/>
      <searchInclude value="Observation.context"/>
      <searchInclude value="Observation.device"/>
      <searchInclude value="Observation.encounter"/>
      <searchInclude value="Observation.patient"/>
      <searchInclude value="Observation.performer"/>
      <searchInclude value="Observation.related-target"/>
      <searchInclude value="Observation.specimen"/>
      <searchInclude value="Observation.subject"/>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code-value-concept"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="code-value-date"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="code-value-quantity"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="code-value-string"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="combo-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="combo-code-value-concept"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="combo-code-value-quantity"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="combo-data-absent-reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="combo-value-concept"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="combo-value-quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="component-code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component-code-value-concept"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="component-code-value-quantity"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="component-data-absent-reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component-value-concept"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component-value-quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="data-absent-reason"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="device"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="method"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="related"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="related-target"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="related-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="specimen"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="value-concept"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="value-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="value-quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="value-string"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="OperationDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="OperationDefinition.base"/>
      <searchInclude value="OperationDefinition.param-profile"/>
      <searchInclude value="OperationDefinition.base"/>
      <searchInclude value="OperationDefinition.param-profile"/>
      <searchInclude value="OperationDefinition.base"/>
      <searchInclude value="OperationDefinition.param-profile"/>
      <searchParam>
        <name value="base"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="instance"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="kind"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="param-profile"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="system"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Organization"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Organization.endpoint"/>
      <searchInclude value="Organization.partof"/>
      <searchInclude value="Organization.endpoint"/>
      <searchInclude value="Organization.partof"/>
      <searchInclude value="Organization.endpoint"/>
      <searchInclude value="Organization.partof"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="endpoint"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="partof"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Patient"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Patient.general-practitioner"/>
      <searchInclude value="Patient.link"/>
      <searchInclude value="Patient.organization"/>
      <searchInclude value="Patient.general-practitioner"/>
      <searchInclude value="Patient.link"/>
      <searchInclude value="Patient.organization"/>
      <searchInclude value="Patient.general-practitioner"/>
      <searchInclude value="Patient.link"/>
      <searchInclude value="Patient.organization"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="animal-breed"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="animal-species"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="birthdate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="death-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="deceased"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="family"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="general-practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="given"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="language"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="link"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="PaymentNotice"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="PaymentNotice.organization"/>
      <searchInclude value="PaymentNotice.provider"/>
      <searchInclude value="PaymentNotice.request"/>
      <searchInclude value="PaymentNotice.response"/>
      <searchInclude value="PaymentNotice.organization"/>
      <searchInclude value="PaymentNotice.provider"/>
      <searchInclude value="PaymentNotice.request"/>
      <searchInclude value="PaymentNotice.response"/>
      <searchInclude value="PaymentNotice.organization"/>
      <searchInclude value="PaymentNotice.provider"/>
      <searchInclude value="PaymentNotice.request"/>
      <searchInclude value="PaymentNotice.response"/>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="payment-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="response"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="statusdate"/>
        <type value="date"/>
      </searchParam>
    </resource>
    <resource>
      <type value="PaymentReconciliation"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="PaymentReconciliation.organization"/>
      <searchInclude value="PaymentReconciliation.request"/>
      <searchInclude value="PaymentReconciliation.request-organization"/>
      <searchInclude value="PaymentReconciliation.request-provider"/>
      <searchInclude value="PaymentReconciliation.organization"/>
      <searchInclude value="PaymentReconciliation.request"/>
      <searchInclude value="PaymentReconciliation.request-organization"/>
      <searchInclude value="PaymentReconciliation.request-provider"/>
      <searchInclude value="PaymentReconciliation.organization"/>
      <searchInclude value="PaymentReconciliation.request"/>
      <searchInclude value="PaymentReconciliation.request-organization"/>
      <searchInclude value="PaymentReconciliation.request-provider"/>
      <searchParam>
        <name value="created"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="disposition"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="outcome"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request-organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request-provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Person"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Person.link"/>
      <searchInclude value="Person.organization"/>
      <searchInclude value="Person.patient"/>
      <searchInclude value="Person.practitioner"/>
      <searchInclude value="Person.relatedperson"/>
      <searchInclude value="Person.link"/>
      <searchInclude value="Person.organization"/>
      <searchInclude value="Person.patient"/>
      <searchInclude value="Person.practitioner"/>
      <searchInclude value="Person.relatedperson"/>
      <searchInclude value="Person.link"/>
      <searchInclude value="Person.organization"/>
      <searchInclude value="Person.patient"/>
      <searchInclude value="Person.practitioner"/>
      <searchInclude value="Person.relatedperson"/>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="birthdate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="link"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="relatedperson"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="PlanDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="PlanDefinition.composed-of"/>
      <searchInclude value="PlanDefinition.depends-on"/>
      <searchInclude value="PlanDefinition.derived-from"/>
      <searchInclude value="PlanDefinition.predecessor"/>
      <searchInclude value="PlanDefinition.successor"/>
      <searchInclude value="PlanDefinition.composed-of"/>
      <searchInclude value="PlanDefinition.depends-on"/>
      <searchInclude value="PlanDefinition.derived-from"/>
      <searchInclude value="PlanDefinition.predecessor"/>
      <searchInclude value="PlanDefinition.successor"/>
      <searchInclude value="PlanDefinition.composed-of"/>
      <searchInclude value="PlanDefinition.depends-on"/>
      <searchInclude value="PlanDefinition.derived-from"/>
      <searchInclude value="PlanDefinition.predecessor"/>
      <searchInclude value="PlanDefinition.successor"/>
      <searchParam>
        <name value="composed-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="depends-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="derived-from"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="effective"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="predecessor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="successor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="topic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Practitioner"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="communication"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="family"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="given"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="PractitionerRole"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="PractitionerRole.endpoint"/>
      <searchInclude value="PractitionerRole.location"/>
      <searchInclude value="PractitionerRole.organization"/>
      <searchInclude value="PractitionerRole.practitioner"/>
      <searchInclude value="PractitionerRole.service"/>
      <searchInclude value="PractitionerRole.endpoint"/>
      <searchInclude value="PractitionerRole.location"/>
      <searchInclude value="PractitionerRole.organization"/>
      <searchInclude value="PractitionerRole.practitioner"/>
      <searchInclude value="PractitionerRole.service"/>
      <searchInclude value="PractitionerRole.endpoint"/>
      <searchInclude value="PractitionerRole.location"/>
      <searchInclude value="PractitionerRole.organization"/>
      <searchInclude value="PractitionerRole.practitioner"/>
      <searchInclude value="PractitionerRole.service"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="endpoint"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="practitioner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="role"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="service"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="specialty"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Procedure"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Procedure.based-on"/>
      <searchInclude value="Procedure.context"/>
      <searchInclude value="Procedure.definition"/>
      <searchInclude value="Procedure.encounter"/>
      <searchInclude value="Procedure.location"/>
      <searchInclude value="Procedure.part-of"/>
      <searchInclude value="Procedure.patient"/>
      <searchInclude value="Procedure.performer"/>
      <searchInclude value="Procedure.subject"/>
      <searchInclude value="Procedure.based-on"/>
      <searchInclude value="Procedure.context"/>
      <searchInclude value="Procedure.definition"/>
      <searchInclude value="Procedure.encounter"/>
      <searchInclude value="Procedure.location"/>
      <searchInclude value="Procedure.part-of"/>
      <searchInclude value="Procedure.patient"/>
      <searchInclude value="Procedure.performer"/>
      <searchInclude value="Procedure.subject"/>
      <searchInclude value="Procedure.based-on"/>
      <searchInclude value="Procedure.context"/>
      <searchInclude value="Procedure.definition"/>
      <searchInclude value="Procedure.encounter"/>
      <searchInclude value="Procedure.location"/>
      <searchInclude value="Procedure.part-of"/>
      <searchInclude value="Procedure.patient"/>
      <searchInclude value="Procedure.performer"/>
      <searchInclude value="Procedure.subject"/>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ProcedureRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ProcedureRequest.based-on"/>
      <searchInclude value="ProcedureRequest.context"/>
      <searchInclude value="ProcedureRequest.definition"/>
      <searchInclude value="ProcedureRequest.encounter"/>
      <searchInclude value="ProcedureRequest.patient"/>
      <searchInclude value="ProcedureRequest.performer"/>
      <searchInclude value="ProcedureRequest.replaces"/>
      <searchInclude value="ProcedureRequest.requester"/>
      <searchInclude value="ProcedureRequest.specimen"/>
      <searchInclude value="ProcedureRequest.subject"/>
      <searchInclude value="ProcedureRequest.based-on"/>
      <searchInclude value="ProcedureRequest.context"/>
      <searchInclude value="ProcedureRequest.definition"/>
      <searchInclude value="ProcedureRequest.encounter"/>
      <searchInclude value="ProcedureRequest.patient"/>
      <searchInclude value="ProcedureRequest.performer"/>
      <searchInclude value="ProcedureRequest.replaces"/>
      <searchInclude value="ProcedureRequest.requester"/>
      <searchInclude value="ProcedureRequest.specimen"/>
      <searchInclude value="ProcedureRequest.subject"/>
      <searchInclude value="ProcedureRequest.based-on"/>
      <searchInclude value="ProcedureRequest.context"/>
      <searchInclude value="ProcedureRequest.definition"/>
      <searchInclude value="ProcedureRequest.encounter"/>
      <searchInclude value="ProcedureRequest.patient"/>
      <searchInclude value="ProcedureRequest.performer"/>
      <searchInclude value="ProcedureRequest.replaces"/>
      <searchInclude value="ProcedureRequest.requester"/>
      <searchInclude value="ProcedureRequest.specimen"/>
      <searchInclude value="ProcedureRequest.subject"/>
      <searchParam>
        <name value="authored"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="body-site"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="intent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="occurrence"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="replaces"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requisition"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="specimen"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ProcessRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ProcessRequest.organization"/>
      <searchInclude value="ProcessRequest.provider"/>
      <searchInclude value="ProcessRequest.organization"/>
      <searchInclude value="ProcessRequest.provider"/>
      <searchInclude value="ProcessRequest.organization"/>
      <searchInclude value="ProcessRequest.provider"/>
      <searchParam>
        <name value="action"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ProcessResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ProcessResponse.organization"/>
      <searchInclude value="ProcessResponse.request"/>
      <searchInclude value="ProcessResponse.request-organization"/>
      <searchInclude value="ProcessResponse.request-provider"/>
      <searchInclude value="ProcessResponse.organization"/>
      <searchInclude value="ProcessResponse.request"/>
      <searchInclude value="ProcessResponse.request-organization"/>
      <searchInclude value="ProcessResponse.request-provider"/>
      <searchInclude value="ProcessResponse.organization"/>
      <searchInclude value="ProcessResponse.request"/>
      <searchInclude value="ProcessResponse.request-organization"/>
      <searchInclude value="ProcessResponse.request-provider"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request-organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="request-provider"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Provenance"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Provenance.entity-ref"/>
      <searchInclude value="Provenance.location"/>
      <searchInclude value="Provenance.patient"/>
      <searchInclude value="Provenance.target"/>
      <searchInclude value="Provenance.entity-ref"/>
      <searchInclude value="Provenance.location"/>
      <searchInclude value="Provenance.patient"/>
      <searchInclude value="Provenance.target"/>
      <searchInclude value="Provenance.entity-ref"/>
      <searchInclude value="Provenance.location"/>
      <searchInclude value="Provenance.patient"/>
      <searchInclude value="Provenance.target"/>
      <searchParam>
        <name value="agent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="agent-role"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="end"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="entity-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="entity-ref"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="location"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="recorded"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="signature-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="start"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Questionnaire"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="effective"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="QuestionnaireResponse"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="QuestionnaireResponse.author"/>
      <searchInclude value="QuestionnaireResponse.based-on"/>
      <searchInclude value="QuestionnaireResponse.context"/>
      <searchInclude value="QuestionnaireResponse.parent"/>
      <searchInclude value="QuestionnaireResponse.patient"/>
      <searchInclude value="QuestionnaireResponse.questionnaire"/>
      <searchInclude value="QuestionnaireResponse.source"/>
      <searchInclude value="QuestionnaireResponse.subject"/>
      <searchInclude value="QuestionnaireResponse.author"/>
      <searchInclude value="QuestionnaireResponse.based-on"/>
      <searchInclude value="QuestionnaireResponse.context"/>
      <searchInclude value="QuestionnaireResponse.parent"/>
      <searchInclude value="QuestionnaireResponse.patient"/>
      <searchInclude value="QuestionnaireResponse.questionnaire"/>
      <searchInclude value="QuestionnaireResponse.source"/>
      <searchInclude value="QuestionnaireResponse.subject"/>
      <searchInclude value="QuestionnaireResponse.author"/>
      <searchInclude value="QuestionnaireResponse.based-on"/>
      <searchInclude value="QuestionnaireResponse.context"/>
      <searchInclude value="QuestionnaireResponse.parent"/>
      <searchInclude value="QuestionnaireResponse.patient"/>
      <searchInclude value="QuestionnaireResponse.questionnaire"/>
      <searchInclude value="QuestionnaireResponse.source"/>
      <searchInclude value="QuestionnaireResponse.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="authored"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="parent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="questionnaire"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="source"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ReferralRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ReferralRequest.based-on"/>
      <searchInclude value="ReferralRequest.context"/>
      <searchInclude value="ReferralRequest.definition"/>
      <searchInclude value="ReferralRequest.encounter"/>
      <searchInclude value="ReferralRequest.patient"/>
      <searchInclude value="ReferralRequest.recipient"/>
      <searchInclude value="ReferralRequest.replaces"/>
      <searchInclude value="ReferralRequest.requester"/>
      <searchInclude value="ReferralRequest.subject"/>
      <searchInclude value="ReferralRequest.based-on"/>
      <searchInclude value="ReferralRequest.context"/>
      <searchInclude value="ReferralRequest.definition"/>
      <searchInclude value="ReferralRequest.encounter"/>
      <searchInclude value="ReferralRequest.patient"/>
      <searchInclude value="ReferralRequest.recipient"/>
      <searchInclude value="ReferralRequest.replaces"/>
      <searchInclude value="ReferralRequest.requester"/>
      <searchInclude value="ReferralRequest.subject"/>
      <searchInclude value="ReferralRequest.based-on"/>
      <searchInclude value="ReferralRequest.context"/>
      <searchInclude value="ReferralRequest.definition"/>
      <searchInclude value="ReferralRequest.encounter"/>
      <searchInclude value="ReferralRequest.patient"/>
      <searchInclude value="ReferralRequest.recipient"/>
      <searchInclude value="ReferralRequest.replaces"/>
      <searchInclude value="ReferralRequest.requester"/>
      <searchInclude value="ReferralRequest.subject"/>
      <searchParam>
        <name value="authored-on"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="group-identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="intent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="occurrence-date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="recipient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="replaces"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="service"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="specialty"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="RelatedPerson"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="RelatedPerson.patient"/>
      <searchInclude value="RelatedPerson.patient"/>
      <searchInclude value="RelatedPerson.patient"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="address"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-city"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-country"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-postalcode"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-state"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="address-use"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="birthdate"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="email"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="gender"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="phone"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="telecom"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="RequestGroup"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="RequestGroup.author"/>
      <searchInclude value="RequestGroup.context"/>
      <searchInclude value="RequestGroup.definition"/>
      <searchInclude value="RequestGroup.encounter"/>
      <searchInclude value="RequestGroup.participant"/>
      <searchInclude value="RequestGroup.patient"/>
      <searchInclude value="RequestGroup.subject"/>
      <searchInclude value="RequestGroup.author"/>
      <searchInclude value="RequestGroup.context"/>
      <searchInclude value="RequestGroup.definition"/>
      <searchInclude value="RequestGroup.encounter"/>
      <searchInclude value="RequestGroup.participant"/>
      <searchInclude value="RequestGroup.patient"/>
      <searchInclude value="RequestGroup.subject"/>
      <searchInclude value="RequestGroup.author"/>
      <searchInclude value="RequestGroup.context"/>
      <searchInclude value="RequestGroup.definition"/>
      <searchInclude value="RequestGroup.encounter"/>
      <searchInclude value="RequestGroup.participant"/>
      <searchInclude value="RequestGroup.patient"/>
      <searchInclude value="RequestGroup.subject"/>
      <searchParam>
        <name value="author"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="authored"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="definition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="group-identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="intent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="participant"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ResearchStudy"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ResearchStudy.partof"/>
      <searchInclude value="ResearchStudy.principalinvestigator"/>
      <searchInclude value="ResearchStudy.protocol"/>
      <searchInclude value="ResearchStudy.site"/>
      <searchInclude value="ResearchStudy.sponsor"/>
      <searchInclude value="ResearchStudy.partof"/>
      <searchInclude value="ResearchStudy.principalinvestigator"/>
      <searchInclude value="ResearchStudy.protocol"/>
      <searchInclude value="ResearchStudy.site"/>
      <searchInclude value="ResearchStudy.sponsor"/>
      <searchInclude value="ResearchStudy.partof"/>
      <searchInclude value="ResearchStudy.principalinvestigator"/>
      <searchInclude value="ResearchStudy.protocol"/>
      <searchInclude value="ResearchStudy.site"/>
      <searchInclude value="ResearchStudy.sponsor"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="focus"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="keyword"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="partof"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="principalinvestigator"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="protocol"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="site"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="sponsor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ResearchSubject"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ResearchSubject.individual"/>
      <searchInclude value="ResearchSubject.patient"/>
      <searchInclude value="ResearchSubject.individual"/>
      <searchInclude value="ResearchSubject.patient"/>
      <searchInclude value="ResearchSubject.individual"/>
      <searchInclude value="ResearchSubject.patient"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="individual"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Resource"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="_content"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="_id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="_lastUpdated"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="_profile"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="_query"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="_security"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="_tag"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="RiskAssessment"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="RiskAssessment.condition"/>
      <searchInclude value="RiskAssessment.encounter"/>
      <searchInclude value="RiskAssessment.patient"/>
      <searchInclude value="RiskAssessment.performer"/>
      <searchInclude value="RiskAssessment.subject"/>
      <searchInclude value="RiskAssessment.condition"/>
      <searchInclude value="RiskAssessment.encounter"/>
      <searchInclude value="RiskAssessment.patient"/>
      <searchInclude value="RiskAssessment.performer"/>
      <searchInclude value="RiskAssessment.subject"/>
      <searchInclude value="RiskAssessment.condition"/>
      <searchInclude value="RiskAssessment.encounter"/>
      <searchInclude value="RiskAssessment.patient"/>
      <searchInclude value="RiskAssessment.performer"/>
      <searchInclude value="RiskAssessment.subject"/>
      <searchParam>
        <name value="condition"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="method"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="probability"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="risk"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Schedule"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Schedule.actor"/>
      <searchInclude value="Schedule.actor"/>
      <searchInclude value="Schedule.actor"/>
      <searchParam>
        <name value="active"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="actor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="SearchParameter"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="SearchParameter.component"/>
      <searchInclude value="SearchParameter.component"/>
      <searchInclude value="SearchParameter.component"/>
      <searchParam>
        <name value="base"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="component"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="derived-from"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="target"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Sequence"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Sequence.patient"/>
      <searchInclude value="Sequence.patient"/>
      <searchInclude value="Sequence.patient"/>
      <searchParam>
        <name value="chromosome"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="coordinate"/>
        <type value="composite"/>
      </searchParam>
      <searchParam>
        <name value="end"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="start"/>
        <type value="number"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ServiceDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="ServiceDefinition.composed-of"/>
      <searchInclude value="ServiceDefinition.depends-on"/>
      <searchInclude value="ServiceDefinition.derived-from"/>
      <searchInclude value="ServiceDefinition.predecessor"/>
      <searchInclude value="ServiceDefinition.successor"/>
      <searchInclude value="ServiceDefinition.composed-of"/>
      <searchInclude value="ServiceDefinition.depends-on"/>
      <searchInclude value="ServiceDefinition.derived-from"/>
      <searchInclude value="ServiceDefinition.predecessor"/>
      <searchInclude value="ServiceDefinition.successor"/>
      <searchInclude value="ServiceDefinition.composed-of"/>
      <searchInclude value="ServiceDefinition.depends-on"/>
      <searchInclude value="ServiceDefinition.derived-from"/>
      <searchInclude value="ServiceDefinition.predecessor"/>
      <searchInclude value="ServiceDefinition.successor"/>
      <searchParam>
        <name value="composed-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="depends-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="derived-from"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="effective"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="predecessor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="successor"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="topic"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Slot"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Slot.schedule"/>
      <searchInclude value="Slot.schedule"/>
      <searchInclude value="Slot.schedule"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="schedule"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="slot-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="start"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Specimen"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Specimen.collector"/>
      <searchInclude value="Specimen.parent"/>
      <searchInclude value="Specimen.patient"/>
      <searchInclude value="Specimen.subject"/>
      <searchInclude value="Specimen.collector"/>
      <searchInclude value="Specimen.parent"/>
      <searchInclude value="Specimen.patient"/>
      <searchInclude value="Specimen.subject"/>
      <searchInclude value="Specimen.collector"/>
      <searchInclude value="Specimen.parent"/>
      <searchInclude value="Specimen.patient"/>
      <searchInclude value="Specimen.subject"/>
      <searchParam>
        <name value="accession"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="bodysite"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="collected"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="collector"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="container"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="container-id"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="parent"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="StructureDefinition"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="abstract"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="base"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="base-path"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context-type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="derivation"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="experimental"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="ext-context"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="keyword"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="kind"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="path"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="valueset"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="StructureMap"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Subscription"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="add-tag"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="contact"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="criteria"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="payload"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="type"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Substance"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Substance.substance-reference"/>
      <searchInclude value="Substance.substance-reference"/>
      <searchInclude value="Substance.substance-reference"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="container-identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="expiry"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="quantity"/>
        <type value="quantity"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="substance-reference"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="SupplyDelivery"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="SupplyDelivery.patient"/>
      <searchInclude value="SupplyDelivery.receiver"/>
      <searchInclude value="SupplyDelivery.supplier"/>
      <searchInclude value="SupplyDelivery.patient"/>
      <searchInclude value="SupplyDelivery.receiver"/>
      <searchInclude value="SupplyDelivery.supplier"/>
      <searchInclude value="SupplyDelivery.patient"/>
      <searchInclude value="SupplyDelivery.receiver"/>
      <searchInclude value="SupplyDelivery.supplier"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="receiver"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supplier"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="SupplyRequest"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="SupplyRequest.requester"/>
      <searchInclude value="SupplyRequest.supplier"/>
      <searchInclude value="SupplyRequest.requester"/>
      <searchInclude value="SupplyRequest.supplier"/>
      <searchInclude value="SupplyRequest.requester"/>
      <searchInclude value="SupplyRequest.supplier"/>
      <searchParam>
        <name value="category"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="supplier"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="Task"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="Task.based-on"/>
      <searchInclude value="Task.context"/>
      <searchInclude value="Task.focus"/>
      <searchInclude value="Task.organization"/>
      <searchInclude value="Task.owner"/>
      <searchInclude value="Task.part-of"/>
      <searchInclude value="Task.patient"/>
      <searchInclude value="Task.requester"/>
      <searchInclude value="Task.subject"/>
      <searchInclude value="Task.based-on"/>
      <searchInclude value="Task.context"/>
      <searchInclude value="Task.focus"/>
      <searchInclude value="Task.organization"/>
      <searchInclude value="Task.owner"/>
      <searchInclude value="Task.part-of"/>
      <searchInclude value="Task.patient"/>
      <searchInclude value="Task.requester"/>
      <searchInclude value="Task.subject"/>
      <searchInclude value="Task.based-on"/>
      <searchInclude value="Task.context"/>
      <searchInclude value="Task.focus"/>
      <searchInclude value="Task.organization"/>
      <searchInclude value="Task.owner"/>
      <searchInclude value="Task.part-of"/>
      <searchInclude value="Task.patient"/>
      <searchInclude value="Task.requester"/>
      <searchInclude value="Task.subject"/>
      <searchParam>
        <name value="authored-on"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="based-on"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="business-status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="code"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="context"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="focus"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="group-identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="intent"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="modified"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="organization"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="owner"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="part-of"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="performer"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="period"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="priority"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="requester"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="subject"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="TestReport"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="TestReport.testscript"/>
      <searchInclude value="TestReport.testscript"/>
      <searchInclude value="TestReport.testscript"/>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="issued"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="participant"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="result"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="tester"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="testscript"/>
        <type value="reference"/>
      </searchParam>
    </resource>
    <resource>
      <type value="TestScript"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="testscript-capability"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="ValueSet"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchParam>
        <name value="date"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="description"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="expansion"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="jurisdiction"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="name"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="publisher"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="reference"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="status"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="title"/>
        <type value="string"/>
      </searchParam>
      <searchParam>
        <name value="url"/>
        <type value="uri"/>
      </searchParam>
      <searchParam>
        <name value="version"/>
        <type value="token"/>
      </searchParam>
    </resource>
    <resource>
      <type value="VisionPrescription"/>
      <interaction>
        <code value="read"/>
      </interaction>
      <interaction>
        <code value="vread"/>
      </interaction>
      <interaction>
        <code value="update"/>
      </interaction>
      <interaction>
        <code value="patch"/>
      </interaction>
      <interaction>
        <code value="delete"/>
      </interaction>
      <interaction>
        <code value="history-instance"/>
      </interaction>
      <interaction>
        <code value="create"/>
      </interaction>
      <interaction>
        <code value="search-type"/>
      </interaction>
      <versioning value="versioned-update"/>
      <readHistory value="true"/>
      <updateCreate value="true"/>
      <conditionalCreate value="true"/>
      <conditionalRead value="not-supported"/>
      <conditionalUpdate value="true"/>
      <conditionalDelete value="multiple"/>
      <searchInclude value="VisionPrescription.encounter"/>
      <searchInclude value="VisionPrescription.patient"/>
      <searchInclude value="VisionPrescription.prescriber"/>
      <searchInclude value="VisionPrescription.encounter"/>
      <searchInclude value="VisionPrescription.patient"/>
      <searchInclude value="VisionPrescription.prescriber"/>
      <searchInclude value="VisionPrescription.encounter"/>
      <searchInclude value="VisionPrescription.patient"/>
      <searchInclude value="VisionPrescription.prescriber"/>
      <searchParam>
        <name value="datewritten"/>
        <type value="date"/>
      </searchParam>
      <searchParam>
        <name value="encounter"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="identifier"/>
        <type value="token"/>
      </searchParam>
      <searchParam>
        <name value="patient"/>
        <type value="reference"/>
      </searchParam>
      <searchParam>
        <name value="prescriber"/>
        <type value="reference"/>
      </searchParam>
    </resource>
      <interaction>
         <code value="transaction"/>
      </interaction>
      <interaction>
         <code value="batch"/>
      </interaction>
      <interaction>
         <code value="search-system"/>
      </interaction>
      <searchParam>
         <name value="_id"/>
         <type value="token"/>
      </searchParam>
      <searchParam>
         <name value="_lastUpdated"/>
         <type value="date"/>
      </searchParam>
      <searchParam>
         <name value="_profile"/>
         <type value="uri"/>
      </searchParam>
      <searchParam>
         <name value="_security"/>
         <type value="token"/>
      </searchParam>
      <searchParam>
         <name value="_tag"/>
         <type value="token"/>
      </searchParam>
      <operation>
         <name value="everything"/>
         <definition>
            <reference value="http://hl7.org/fhir/OperationDefinition/patient-everything"/>
         </definition>
      </operation>
      <operation>
         <name value="validate"/>
         <definition>
            <reference value="http://hl7.org/fhir/OperationDefinition/resource-validate"/>
         </definition>
      </operation>
   </rest>
</CapabilityStatement>
}

}

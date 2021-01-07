/// XSDb Coded values, sync'd from HUB
Class HS.IHE.CodedEntry Extends (%Persistent, %XML.Adaptor, HS.Sync.BaseClass) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 140;

/// XDSb Classification Type (i.e. contentTypeCode, formatCode, etc)
/// NOTE: NIST defines mimeType as a code, we do not
Property CodeType As %String(VALUELIST = ",contentTypeCode,classCode,confidentialityCode,formatCode,healthcareFacilityTypeCode,practiceSettingCode,eventCodeList,typeCode,folderCodeList,associationDocumentation") [ Required ];

/// Classification coding scheme
Property CodingScheme As %String(MAXLEN = 255) [ Required ];

/// Classification code
Property Code As %String(MAXLEN = 255) [ Required ];

/// Classification display string
Property Description As %String(MAXLEN = 1024);

/// Optional XSLT transform for converting to HTML
Property ToHTML As %String(MAXLEN = 1024);

/// Optional XSLT transform for converting to SDA
Property ToSDA As %String(MAXLEN = 1024);

/// Optional arbitrary processing for repository documents when opened via the documents tab in the viewer
/// Insert the full classname of a custom class which extends HS.IHE.XDSb.Consumer.ViewerFetchProcess.BaseOtherHandler
/// Note: This will not execute if ToHTML is valued
Property ToOther As %String(MAXLEN = 255);

Index UniqueIndex On (CodeType, CodingScheme, Code) [ Unique ];

///  Import codes from an XML source, such as http://ihexds.nist.gov:80/xdsref/codes/codes.xml
ClassMethod ImportFromURL(pLocation As %String) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC=##class(Ens.Util.URLStream).GetURLStream(pLocation,.tStream) Quit:$$$ISERR(tSC)
		Set tSC=##class(%XML.XPATH.Document).CreateFromStream(tStream,.tDocument) Quit:$$$ISERR(tSC)
		
		#; Loop over each type of code
		Set tSC=tDocument.EvaluateExpression("/Codes/CodeType","@name",.tCodeTypes) Quit:$$$ISERR(tSC)
		Set i="" For { Set tCodeType=tCodeTypes.GetNext(.i) Quit:i=""  
			If tCodeType.Value="mimeType" Continue
			
			#; Loop over each code for this type
			Set tSC=tDocument.EvaluateExpression("/Codes/CodeType[@name='"_tCodeType.Value_"']/Code",".",.tCodeNodes) If $$$ISERR(tSC) $$$ThrowStatus(tSC)
			Set j="" For { Set tCodeNode=tCodeNodes.GetNext(.j) Quit:j=""
				Do tCodeNode.Read()
				If tCodeNode.HasAttributes {
					#; Get the code, scheme and display text then create/update the entry
					Set tCodedEntry=..%New()
					Set tCodedEntry.CodeType=tCodeType.Value
					If tCodeNode.MoveToAttributeName("code") Set tCodedEntry.Code=tCodeNode.Value
					If tCodeNode.MoveToAttributeName("display") Set tCodedEntry.Description=tCodeNode.Value
					If tCodeNode.MoveToAttributeName("codingScheme") Set tCodedEntry.CodingScheme=tCodeNode.Value
					Set tSC=tCodedEntry.CreateOrUpdate() If $$$ISERR(tSC) $$$ThrowStatus(tSC)
				}
			}
		}
		
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

Method CreateOrUpdate() As %Status
{
	Set tSC=$$$OK
	Try {
		#dim tCoded2Entry As CodedEntry
		If ..UniqueIndexExists(..CodeType,..CodingScheme,..Code) {
			Set tCoded2Entry=..UniqueIndexOpen(..CodeType,..CodingScheme,..Code,4,.tSC) If $$$ISERR(tSC) $$$ThrowStatus(tSC)
			If ..Description'="" Set tCoded2Entry.Description = ..Description
			If ..ToSDA'="" Set tCoded2Entry.ToSDA = ..ToSDA
			If ..ToHTML'="" Set tCoded2Entry.ToHTML = ..ToHTML
			Set tSC=tCoded2Entry.%Save() Quit:$$$ISERR(tSC)
		} Else {
			Set tSC=..%Save() Quit:$$$ISERR(tSC)
		}
	} Catch ex { Set tSC=ex.AsStatus() }
	If $$$ISERR(tSC) Set tSC=$$$ERROR($$$GeneralError,$$$FormatText("Failed to save coded entry (%1,%2,%3): %4",..CodeType,..CodingScheme,..Code,$SYSTEM.Status.GetErrorText(tSC)))
	Quit tSC
}

/// Get the XSL transform for converting a XDSb DocumentEntry from specified format to HTML
ClassMethod GetFormatToHTML(pCode As %String = "", pScheme As %String = "", Output pTransform As %String = "") As %Status
{
	&sql(SELECT ToHTML INTO :pTransform FROM HS_IHE.CodedEntry WHERE CodeType='formatCode' AND CodingScheme=:pScheme AND Code=:pCode)
	If SQLCODE,SQLCODE'=100 Quit $$$ERROR($$$GeneralError,"Failed to find HTML transform: "_$SYSTEM.SQL.SQLCODE(SQLCODE))
	Quit $$$OK
}

ClassMethod GetToOtherFlag(pCode As %String = "", pScheme As %String = "", Output pTransform As %String = "") As %Status
{
	&sql(SELECT ToOther INTO :pTransform FROM HS_IHE.CodedEntry WHERE CodeType='formatCode' AND CodingScheme=:pScheme AND Code=:pCode)
	If SQLCODE,SQLCODE'=100 Quit $$$ERROR($$$GeneralError,"Failed to find HTML transform: "_$SYSTEM.SQL.SQLCODE(SQLCODE))
	Quit $$$OK
}

/// Get the XSL transform for converting a XDSb DocumentEntry from specified format to SDA
ClassMethod GetFormatToSDA(pCode As %String = "", pScheme As %String = "", Output pTransform As %String = "") As %Status
{
	&sql(SELECT ToSDA INTO :pTransform FROM HS_IHE.CodedEntry WHERE CodeType='formatCode' AND CodingScheme=:pScheme AND Code=:pCode)
	If SQLCODE,SQLCODE'=100 Quit $$$ERROR($$$GeneralError,"Failed to find HTML transform: "_$SYSTEM.SQL.SQLCODE(SQLCODE))
	Quit $$$OK
}

ClassMethod ValidateEntry(pClassificationScheme As %String, pCode As %String, pCodingScheme As %String, ByRef pValid As %Boolean = 0, pCodeType As %String = "") As %Status
{
	try {
		Set tSC=$$$OK
		Set:pCodeType="" pCodeType=$Case(pClassificationScheme,
			"urn:uuid:aa543740-bdda-424e-8c96-df4873be8500":"contentTypeCode",
			"urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a":"classCode",
			"urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f":"confidentialityCode",
			"urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d":"formatCode",
			"urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1":"healthcareFacilityTypeCode",
			"urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead":"practiceSettingCode",
			"urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4":"eventCodeList",
			"urn:uuid:f0306f51-975f-434e-a61c-c59651d33983":"typeCode",
			"urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5":"folderCodeList",
			"urn:uuid:abd807a3-4432-4053-87b4-fd82c643d1f3":"associationDocumentation",
			:"")
		If pCode]"",pCodeType]"" {
			&sql(select id from CodedEntry where CodeType=:pCodeType and CodingScheme=:pCodingScheme and Code=:pCode)
			Set pValid = $S(SQLCODE:0,1:1)
		} Else {
			Set pValid=1
		}
	} catch eException {
		Set tSC=eException.AsStatus() 
	}
	Quit tSC
}

ClassMethod SetupNHIN() As %Status
{
	Set tSC=$$$OK
	Try {
		For tType="classCode","typeCode","contentTypeCode" {
			Set tCode=..%New(tType,"LOINC","57017-6","Privacy Policy"),tSC=tCode.%Save() If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		}
		For tType="healthcareFacilityTypeCode","practiceSettingCode" {
			Set tCode=..%New(tType,"SNOMED","385432009","Not Applicable"),tSC=tCode.%Save() If $$$ISERR(tSC) $$$ThrowStatus(tSC)
		}
		Set tCode=..%New("formatCode","1.3.6.1.4.1.19376.1.2.3","urn:nhin:names:acp:XACML","XACML Policy"),tSC=tCode.%Save() If $$$ISERR(tSC) $$$ThrowStatus(tSC)
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

ClassMethod SetupCDA() As %Status
{
	Set tSC=$$$OK
	Try {
		Set tToSDA = "SDA3/CDA-to-SDA.xsl"
		Set tToHTML ="SDA3/CDA-Support-Files/Reports/CDA-to-HTML.xsl"
		$$$ThrowOnError( ..Create("formatCode", "2.16.840.1.113883.3.88", "2.16.840.1.113883.10.20.1", "HL7 CCD Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "HITSP", "2.16.840.1.113883.10.20.1", "HL7 CCD Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "Connect-a-thon formatCodes", "CDA/IHE 1.0", "CDA/IHE 1.0", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "Connect-a-thon formatCodes", "CDAR2/IHE 1.0", "CDAR2/IHE 1.0", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "Connect-a-thon formatCodes", "CCR/IHE 0.9", "CCR/IHE 0.9", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "Connect-a-thon formatCodes", "CCR V1.0", "CCR V1.0", tToSDA, tToHTML)  )
		$$$ThrowOnError( ..Create("formatCode", "IHE PCC", "urn:ihe:pcc:xphr:2007", "Exchange of Personal Health Records", tToSDA, tToHTML)  )
		$$$ThrowOnError( ..Create("formatCode", "IHE PCC", "urn:ihe:pcc:xds-ms:2007", "Medical Summaries", tToSDA, tToHTML)  )
		$$$ThrowOnError( ..Create("formatCode", "MU Certification", "CCR V2.0", "CCR V2.0", "SDA/CCR-to-SDA.xsl", "SDA/CDA-Support-Files/Reports/CCR-to-HTML.xsl")  )
		
		Set tToSDA = "SDA3/XDLAB-to-SDA.xsl"
		Set tToHTML ="SDA3/CDA-Support-Files/Reports/CDA-to-HTML.xsl"
		$$$ThrowOnError( ..Create("formatCode", "IHE PCC", "urn:ihe:lab:xd-lab:2008", "CDA Laboratory Report", tToSDA, tToHTML)  )
		
		Set tToSDA = ""
		Set tToHTML =""
		$$$ThrowOnError( ..Create("typeCode", "LOINC", "60591-5", "Patient Summary Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("typeCode", "LOINC", "57133-1", "Referral Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "60591-5", "Patient Summary Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "57133-1", "Referral Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "60591-5", "Patient Summary Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "57133-1", "Referral Note", tToSDA, tToHTML) )
		
		// For Australian CDA
		Set tSC=..SetupAUCDA()
		
		// For XDS-SD
		Set tSC=..SetupScannedDocument()
		
		// For Consolidated CDA (C-CDA) Release 1.1
		$$$ThrowOnError( ..SetupCCDAR11() )
		
		// For Consolidated CDA (C-CDA) Release 2.1
		$$$ThrowOnError( ..SetupCCDAR21() )
		
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

ClassMethod SetupAUCDA() As %Status
{
	try {
		Set tSC=$$$OK
		
		// FormatCodes - classificationScheme="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d"
		Set tToSDA = "SDA3/AU-CDA-to-SDA.xsl"
		Set tToHTML ="SDA3/CDA-Support-Files/Reports/AU-CDA-to-HTML.xsl"
		$$$ThrowOnError( ..Create("formatCode", "PCEHR_FormatCodes", "1.2.36.1.2001.1006.1.20000.26", "Discharge Summary 3A HPI-I Required", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "PCEHR_FormatCodes", "1.2.36.1.2001.1006.1.16473.14", "Event Summary Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "PCEHR_FormatCodes", "1.2.36.1.2001.1006.1.21000.21", "Referral Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "PCEHR_FormatCodes", "1.2.36.1.2001.1006.1.16565.10", "Shared Health Summary Document", tToSDA, tToHTML) )
		
		Set (tToHTML,tToSDA) = ""
		// ConfidentialityTypeCodes (DocAccessLevels) - classificationScheme="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f"
		$$$ThrowOnError( ..Create("confidentialityCode", "PCEHR_DocAccessLevels", "GENERAL", "NA", tToSDA, tToHTML) )
		
		// ClassCodes - classificationScheme="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a"
		$$$ThrowOnError( ..Create("classCode", "LOINC", "60591-5", "Shared Health Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "LOINC", "57133-1", "e-Referral", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "LOINC", "51852-2", "Specialist Letter", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "LOINC", "18842-5", "Discharge Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "LOINC", "34133-9", "Event Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "NCTIS Data Components", "100.32001", "Pathology Report", tToSDA, tToHTML) )
		
		// TypeCodes - classificationScheme="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983"
		$$$ThrowOnError( ..Create("typeCode", "LOINC", "60591-5", "Shared Health Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("typeCode", "LOINC", "57133-1", "e-Referral", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("typeCode", "LOINC", "51852-2", "Specialist Letter", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("typeCode", "LOINC", "18842-5", "Discharge Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("typeCode", "LOINC", "34133-9", "Event Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("typeCode", "NCTIS Data Components", "100.32001", "Pathology Report", tToSDA, tToHTML) )
		
		// ContentTypeCodes - classificationScheme="urn:uuid:aa543740-bdda-424e-8c96-df4873be8500"
		$$$ThrowOnError( ..Create("contentTypeCode", "LOINC", "60591-5", "Shared Health Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "LOINC", "57133-1", "e-Referral", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "LOINC", "51852-2", "Specialist Letter", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "LOINC", "18842-5", "Discharge Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "LOINC", "34133-9", "Event Summary", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "NCTIS Data Components", "100.32001", "Pathology Report", tToSDA, tToHTML) )
		
		// HealthcareFacilityTypeCodes - classificationScheme="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1"
		$$$ThrowOnError( ..Create("healthcareFacilityTypeCode", "ANZSIC", "8401", "Hospitals (except Psychiatric Hospitals)", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("healthcareFacilityTypeCode", "ANZSIC", "8520", "Pathology and Diagnostic Imaging Services", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("healthcareFacilityTypeCode", "ANZSIC", "8511", "General Practice", tToSDA, tToHTML) )
		
		// PracticeSettingCodes - classificationScheme="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead"
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-6", "Hospital (except psychiatric or veterinary hospitals)", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8511-2", "General medical practitioner service", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8520-2", "Medical laboratory service", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8599-4", "Community Health Facility", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-11", "Public day centre/hospital", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-5", "General Hospital", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8512-16", "Specialist surgical service", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8512-19", "Emergency Department Services", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-15", "Public acute care hospital", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-16", "Private acute care hospital", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-8", "Maternity Hospital", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8511-5", "Community Health Care", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-9", "Obstetric Hospital", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-13", "Private day centre/hospital", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("practiceSettingCode", "ANZSIC", "8401-10", "Women's Hospital", tToSDA, tToHTML) )
		
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod SetupScannedDocument() As %Status
{
	try {
		Set tSC=$$$OK
		&sql(update hs_ihe.codedentry set ToOther = 'HS.IHE.XDSb.Consumer.ViewerFetchProcess.CDAWrapped' where code in ('urn:ihe:rad:TEXT', 'urn:ihe:rad:PDF', 'urn:ihe:pcc:apr:lab:2008', 'urn:ihe:iti:xds-sd:pdf:2008', 'urn:ihe:iti:xds-sd:text:2008', 'urn:ihe:iti:bppc-sd:2007', 'urn:ihe:iti:xds-sd:pdf:2008', 'urn:ihe:iti:xds-sd:text:2008'))
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Adds BPPC specific codes, called by the HS.Util.Installer
ClassMethod SetupBPPC() As %Status
{
	Set tSC = $$$OK
	Try {
		#; do not consume BPPC CDA, but do allow HTML rendering
		Set tToSDA = ""  
		Set tToHTML ="SDA3/CDA-Support-Files/Reports/CDA-to-HTML.xsl"
		$$$ThrowOnError( ..Create("formatCode", "1.3.6.1.4.1.19376.1.2.3", "urn:ihe:iti:bppc:2007", "Basic Patient Privacy Consents", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "1.3.6.1.4.1.19376.1.2.3", "urn:ihe:iti:bppc-sd:2007", "Basic Patient Privacy Consents with Scanned Document", tToSDA, tToHTML) )
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Adds Consolidated CDA R1.1 officially sanctioned codes, called by SetupCDA and by upgrade step.
ClassMethod SetupCCDAR11() As %Status
{
	Set tSC = $$$OK
	Try {
		Set tToSDA = ""
		Set tToHTML =""
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11488-4", "Consultation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "18748-4", "Diagnostic Imaging Report", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "18842-5", "Discharge Summary Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "34117-2", "History and Physical Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11504-8", "Surgical Operation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "28570-0", "Procedure Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11506-3", "Subsequent Evaluation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11490-0", "Physician Discharge Summarization Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11488-4", "Consultation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "18748-4", "Diagnostic Imaging Report", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "18842-5", "Discharge Summary Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "34117-2", "History and Physical Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11504-8", "Surgical Operation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "28570-0", "Procedure Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11506-3", "Subsequent Evaluation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11490-0", "Physician Discharge Summarization Note", tToSDA, tToHTML) )
		
		#; Officially sanctioned C-CDA R1.1 formatCodes
		#; IHE PCC TF-2 Rev 10.0
		#; http://wiki.hl7.org/index.php?title=CDA_Format_Codes_for_IHE_XDS
		Set tToSDA = "SDA3/CCDA-to-SDA.xsl"
		Set tToHTML ="SDA3/CDA-Support-Files/Reports/CCDA-to-HTML.xsl"
		$$$ThrowOnError( ..Create("formatCode", "1.3.6.1.4.1.19376.1.2.3", "urn:hl7-org:sdwg:ccda-structuredBody:1.1", "Consolidated CDA R1.1 Structured Body Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "1.3.6.1.4.1.19376.1.2.3", "urn:hl7-org:sdwg:ccda-nonXMLBody:1.1", "Consolidated CDA R1.1 Unstructured Document", tToSDA, tToHTML) )
		
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Adds Consolidated CDA R2.1 officially sanctioned codes, called by SetupCDA and by upgrade step.
ClassMethod SetupCCDAR21() As %Status
{
	Set tSC = $$$OK
	Try {
		Set tToSDA = ""
		Set tToHTML =""
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11488-4", "Consultation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "18748-4", "Diagnostic Imaging Report", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "18842-5", "Discharge Summary Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "34117-2", "History and Physical Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11504-8", "Surgical Operation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "28570-0", "Procedure Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11506-3", "Subsequent Evaluation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "11490-0", "Physician Discharge Summarization Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "52521-2", "Overall Plan of Care/Advance Care Directives", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("classCode", "2.16.840.1.113883.6.1", "57133-1", "Referral Note", tToSDA, tToHTML) )				
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11488-4", "Consultation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "18748-4", "Diagnostic Imaging Report", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "18842-5", "Discharge Summary Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "34117-2", "History and Physical Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11504-8", "Surgical Operation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "28570-0", "Procedure Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11506-3", "Subsequent Evaluation Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "11490-0", "Physician Discharge Summarization Note", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "52521-2", "Overall Plan of Care/Advance Care Directives", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("contentTypeCode", "2.16.840.1.113883.6.1", "57133-1", "Referral Note", tToSDA, tToHTML) )		
		
		#; Officially sanctioned C-CDA R2.1 formatCodes
		#; IHE PCC TF-2 Rev 10.0
		#; http://wiki.hl7.org/index.php?title=CDA_Format_Codes_for_IHE_XDS
		Set tToSDA = "SDA3/CCDAv21-to-SDA.xsl"
		Set tToHTML ="SDA3/CDA-Support-Files/Reports/CCDAv21-to-HTML.xsl"		
		$$$ThrowOnError( ..Create("formatCode", "1.3.6.1.4.1.19376.1.2.3", "urn:hl7-org:sdwg:ccda-structuredBody:2.1", "Consolidated CDA R2.1 Structured Body Document", tToSDA, tToHTML) )
		$$$ThrowOnError( ..Create("formatCode", "1.3.6.1.4.1.19376.1.2.3", "urn:hl7-org:sdwg:ccda-nonXMLBody:2.1", "Consolidated CDA R2.1 Unstructured Document", tToSDA, tToHTML) )
		
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

ClassMethod Create(CodeType As %String = "", CodingScheme As %String = "", Code As %String = "", Description As %String = "", ToSDA As %String = "", ToHTML As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tCodedEntry = ..%New(CodeType,CodingScheme,Code,Description)
		Set:ToSDA]"" tCodedEntry.ToSDA = ToSDA
		Set:ToHTML]"" tCodedEntry.ToHTML = ToHTML
		Set tSC = tCodedEntry.CreateOrUpdate()
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

Method %OnNew(CodeType As %String = "", CodingScheme As %String = "", Code As %String = "", Description As %String = "") As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..CodeType=CodeType
	Set ..CodingScheme=CodingScheme
	Set ..Code=Code
	Set ..Description=Description
	Quit $$$OK
}

Query Items(pType As %String, pSearch As %String) As %Query(ROWSPEC = "ID:%Integer,CodeType:%String,Code:%String,Scheme:%String,Description:%String,ToHTML:%String,ToOther:%String,ToSDA:%String")
{
}

ClassMethod ItemsExecute(ByRef qHandle As %Binary, pType As %String = "", pSearch As %String = "") As %Status
{
	Set tSelectClause = "select %ID,Codetype,Code,Codingscheme,Description,ToHTML,ToOther,ToSDA from HS_IHE.CodedEntry"
	Set tWhere = ""
	If $g(pType)="" {
		Set tArgs=0
		If pSearch'="" {
			Set tArgs=3 For tI=1:1:3 Set tArgs(tI)=$ZCVT(pSearch,"U")
			Set tWhere=" Where Upper(Code)[? OR Upper(CodingScheme)[? OR Upper(Description)[?"
		}
	} Else {
		Set tArgs=1,tArgs(1)=pType, tAnd=""
		If pSearch'="" {
			Set tArgs=4 For tI=2:1:4 Set tArgs(tI)=$ZCVT(pSearch,"U")
			Set tAnd=" And (Upper(Code)[? OR Upper(CodingScheme)[? OR Upper(Description)[? )"
		}
		Set tWhere = " WHERE CodeType=?"_tAnd
	}	
	Set tSQL=tSelectClause_tWhere_" ORDER BY Code"
	Set qHandle = ##class(%SQL.Statement).%ExecDirect(,tSQL,tArgs...)	
	Quit $$$OK
}

ClassMethod ItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemsExecute ]
{
	Set qHandle=""
	Quit $$$OK
}

ClassMethod ItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemsExecute ]
{
	Set AtEnd='qHandle.%Next()
	Set Row=$S(AtEnd:"",1:$lb(qHandle.%GetData(1),qHandle.%GetData(2),qHandle.%GetData(3),qHandle.%GetData(4),qHandle.%GetData(5),qHandle.%GetData(6),qHandle.%GetData(7),qHandle.%GetData(8)))
	Quit $$$OK
}

Query DistinctTypes() As %Query(ROWSPEC = "Type:%String")
{
}

ClassMethod DistinctTypesExecute(ByRef qHandle As %Binary) As %Status
{
	Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT CodeType from HS_IHE.CodedEntry")
	While tRS.%Next() {
		Set tValue = tRS.CodeType
		Set tArray(tValue)=""
	}
	Set tValue=""
	For  {
		Set tValue=$o(tArray(tValue)) Quit:tValue=""
		Set qHandle($i(qHandle))=tValue
	}
	Set qHandle=0	
	Quit $$$OK
}

ClassMethod DistinctTypesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DistinctTypesExecute ]
{
	Quit $$$OK
}

ClassMethod DistinctTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DistinctTypesExecute ]
{
	Set qHandle=$O(qHandle(qHandle),1,Row)
	Set AtEnd=(qHandle="") 
	Set Row=$S(AtEnd:"",1:$lb(Row))
	Set:'AtEnd AtEnd=($O(qHandle(qHandle))="")
	Quit $$$OK
}

Storage Default
{
<Data name="CodedEntryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CodeType</Value>
</Value>
<Value name="3">
<Value>CodingScheme</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>ToHTML</Value>
</Value>
<Value name="7">
<Value>ToSDA</Value>
</Value>
<Value name="8">
<Value>ToOther</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.CodedEntryD</DataLocation>
<DefaultData>CodedEntryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.CodedEntryD</IdLocation>
<IndexLocation>^HS.IHE.CodedEntryI</IndexLocation>
<StreamLocation>^HS.IHE.CodedEntryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Include (HS.IHE.XDSb, HS.IHE.ATNA)

/// Abstract functions common for XDSb Document Source and XDM Media Creator
Class HS.IHE.XDSb.DocumentSource.Abstract Extends (HS.Util.BaseHost, HS.HC.Util.Trace.Helper, HS.Util.XSLTTransformer) [ Abstract ]
{

Parameter DOMAIN = "HS";

/// Send documents inline instead of as attachments
Property DocumentsInline As %Boolean [ InitialExpression = 0 ];

/// True:  If a ProvideAndRegisterRequest comes in with no patientId, and the sourceId doesn't match anyone in the registry, add them.<br>
/// False: If a ProvideAndRegisterRequest comes in with no patientId, and the sourceId doesn't match anyone in the registry, throw an error.
Property AddNewPatients As %Boolean [ InitialExpression = 0 ];

/// Config Item where the Add/Update Operations will be sent 
Property MPIOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.Hub.MPI.Manager" ];

/// Use the content of the document (if CDA) to extract values for the metadata <br>
/// pRequest - the  will be updated with values where available 
Method GetUpdatedRequest(ByRef pRequest As HS.Message.IHE.XDSb.Metadata, pHost As Ens.Host = {##this}) As %Status
{
	try {
		Set tSC=$$$OK
		#dim tSubmission as HS.Types.IHE.XDSb.Submission = pRequest.Submissions.GetAt(1)
		Set tPatientID = tSubmission.PatientIdentifier.Value
		
		For tIdx=1:1:pRequest.Documents.Count() {
			#dim tDocument as HS.Types.IHE.XDSb.Document = pRequest.Documents.GetAt(tIdx)
			$$$HSTRACE("Processing document "_tIdx)
			Set tXPathDoc = ""

			#; if it is binary we will not extract values
			If 'tDocument.BodyCharacter.Size Continue

			#; if there is no value for the typeId it is not CDA
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:typeId","@root",.tValue,.tXPathDoc)
			If $$$ISERR(tSC) || (tValue="") Set tSC = $$$OK Continue

			#; Fetch source patient mrn and assigning authority from the document
			If tDocument.SourcePatientId="" Set tSC = ..UpdateSourcePatientId(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC)

			Set tPatientIDRequired = '(pRequest.Name=$$$XDMDistributeDocumentSetOnMediaRequest)
			If tDocument.PatientIdentifier.Value="" Set tSC = ..UpdatePatientIdentifier(.tDocument,.tXPathDoc,tPatientIDRequired) Quit:$$$ISERR(tSC)
			Set:tPatientID="" tPatientID=tDocument.PatientIdentifier.Value
			If tPatientID '= tDocument.PatientIdentifier.Value Set tSC =$$$ERROR($$$GeneralError,$$$FormatText("Mismatched patient identifiers submission ['%1'] and document ['%2']",tPatientID,tDocument.PatientIdentifier.Value)) Quit

			If tDocument.SourcePatientInfo.Count()=0 { Set tSC=..UpdateSourcePatientInfo(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }

			If tDocument.ConfidentialityCode.Count()=0 { Set tSC = ..UpdateConfidentialityCode(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }

			If tDocument.ClassCode.Code="" { Set tSC = ..UpdateClassCode(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }

			If tDocument.TypeCode.Code="" { Set tSC = ..UpdateTypeCode(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }

			If tDocument.CreationTime="" { Set tSC = ..UpdateCreationTime(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }

			If tDocument.ServiceStartTime="" || (tDocument.ServiceStopTime="") { Set tSC = ..UpdateServiceTimes(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }

			If tDocument.LanguageCode="" { Set tSC = ..UpdateLanguageCode(tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }
				
			If 'tDocument.Names.Count()="" { Set tSC = ..UpdateNames(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }
			
			If tDocument.Author.Count()=0 { Set tSC = ..UpdateDocumentAuthor(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }
			
			If tDocument.FormatCode.Code="" { Set tSC = ..UpdateFormatCode(.tDocument,.tXPathDoc) Quit:$$$ISERR(tSC) }				
		}
		if tSubmission.PatientIdentifier.Value = "" {
			Set tSubmission.PatientIdentifier.Value = tPatientID
		}
		Quit:$$$ISERR(tSC)
		$$$HSTRACE("About to call update associations"_pRequest.Associations.Count())
		Set tSC=..GetUpdatedAssociations(pRequest)
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$HSTRACE("Error","tSC",tSC)
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the ServiceStart and ServiceStop times <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Assigning the service times can be done in either the OnPre or OnPost code using the following (YYYYMMDDHHMMSS as UTC)<br>
/// 		<li>Set pDocument.ServiceStartTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(##class(HS.Util.XSLTHelper).timestamp())<li>
/// 		<li>Set pDocument.ServiceStopTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(##class(HS.Util.XSLTHelper).timestamp())<li><br>
///   <Method>ClassMethod OnPreUpdateServiceTimes(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the pDocument object prior to any additional processing, such as extracting the service times from a different location in the CDA document</li>
///   <Method>ClassMethod OnPostUpdateServiceTimes(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object, such as defaulting a value (Set pDocument.ServiceStartTime=$TR($zdt($h,8),": "),Document.ServiceStopTime=$TR($zdt($h,8),": ")) if the base code failed to locate a value</li>
Method UpdateServiceTimes(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateServiceTimes(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the service times from the CDA document
ClassMethod CMUpdateServiceTimes(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		/*
			A= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/@value"
			B= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low/@value"
			C= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value"
			D= "/cda:ClinicalDocument/cda:effectiveTime/@value"

			The UTC date we will use is the first one that has a value.

				serviceStartTime = B,A,D (only going to get A or B, never both, defaulting back to D which is mandatory)
				serviceEndTime   = C,A,D (only going to get A or C, never both, defaulting back to D which is mandatory)
		*/
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime","@value",.tA,.pXPathDoc)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:low","@value",.tB,.pXPathDoc)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:high","@value",.tC,.pXPathDoc)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tD,.pXPathDoc)
		If pDocument.ServiceStartTime="" {
			Set tTime=$S($G(tB)]"":tB,$G(tA)]"":tA,1:$g(tD))
			Set pDocument.ServiceStartTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
		}
		If pDocument.ServiceStopTime="" {
			Set tTime=$S($G(tC)]"":tC,$G(tA)]"":tA,1:$g(tD))
			Set pDocument.ServiceStopTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
		}

		If pDocument.ServiceStartTime="" {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:low","@value",.tValue,.pXPathDoc)
			If $$$ISOK(tSC) && (tValue]"") Set pDocument.ServiceStartTime=tValue
		}
		If pDocument.ServiceStopTime="" {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:high","@value",.tValue,.pXPathDoc)
			If $$$ISOK(tSC) && (tValue]"") Set pDocument.ServiceStopTime=tValue
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "ConfidentialityCode" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning a Confidentiality code could be done in either the OnPre or OnPost code using the following<br>
/// 	<li>Do pDocument.ConfidentialityCode.Insert(##class(HS.Types.IHE.XDSb.CodedValue).Create(tCode,tScheme,tDescription))</li>
///   <Method>ClassMethod OnPreUpdateConfidentialityCode(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing.</li>
///   <Method>ClassMethod OnPostUpdateConfidentialityCode(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object, such as defining the value</li>
Method UpdateConfidentialityCode(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateConfidentialityCode(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the confidentiality code from the CDA document
ClassMethod CMUpdateConfidentialityCode(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@code",.tCode,.pXPathDoc)
		Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@codeSystem",.tScheme,.pXPathDoc)
		Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@displayName",.tDescription,.pXPathDoc)
		Quit:$$$ISERR(tSC)
		// Document-level confidentialityCode could be nullFlavor.  If so, default in N for Normal.
		If tCode="",tScheme="" Set tCode="N",tScheme="2.16.840.1.113883.5.25",tDescription="Normal"
		Do pDocument.ConfidentialityCode.Insert(##class(HS.Types.IHE.XDSb.SerialClassification).Create(tCode,tScheme,tDescription))
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the Document Author <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning a document author could be done in either the OnPre or OnPost code using the following<br>
/// 	As suggested by ITI TF-3 section 4.2.3.1.4 example, the format is identifier^last^first^middle^suffix^prefix.
/// 		<li>Quit:pDocument.Author.Count() $$$OK</li>
/// 		<li>Set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New()<br>
/// 			Set tAuthor.AuthorPerson=LastName_"^"_FirstName_"^"_MiddleName_"^"_Suffix_"^"_Prefix</li>
/// 		<li>Do tAuthor.AuthorInstitution.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New(SomeInstitutionName))</li>
/// 		<li>Do tDocument.Author.Insert(tAuthor)</li>
///   <Method>ClassMethod OnPreUpdateDocumentAuthor(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the pDocument object prior to any additional processing.</li>
///   <Method>ClassMethod OnPostUpdateDocumentAuthor(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object, such as defining the value</li>
Method UpdateDocumentAuthor(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateDocumentAuthor(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the author from the CDA document
ClassMethod CMUpdateDocumentAuthor(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		#;cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']/@root
		#;cda:ClinicalDocument/cda:author/cda:assignedAuthor/ cda:assignedPerson/cda:name
		Set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New(),tFound=0
		Set (tFirstName,tMiddleName,tLastName,tPrefix,tSuffix)=""
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given[1]","text()",.tFirstName,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given[2]","text()",.tMiddleName,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:family","text()",.tLastName,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:prefix","text()",.tPrefix,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:suffix","text()",.tSuffix,.pXPathDoc) Quit:$$$ISERR(tSC)
		If tFirstName'=""!(tLastName'="") {
			// As suggested by ITI TF-3 2012 section 4.2.3.1.4 example, the format is identifier^last^first^middle^suffix^prefix.
			Set tValue=""
			Set $Piece(tValue,"^",2)=tLastName
			Set $Piece(tValue,"^",3)=tFirstName
			Set $Piece(tValue,"^",4)=tMiddleName
			Set $Piece(tValue,"^",5)=tSuffix
			Set $Piece(tValue,"^",6)=tPrefix
			Set tAuthor.AuthorPerson=tValue
			Set tFound=1
		}
		If tFound=0 {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name","text()",.tValue,.pXPathDoc) Quit:$$$ISERR(tSC)
			Set tValue=$Translate(tValue,$Char(10))
			Set tAuthor.AuthorPerson=tValue Set:tValue]"" tFound=1
		}
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:name","text()",.tValue,.pXPathDoc) Quit:$$$ISERR(tSC)
		If tValue]"" Do tAuthor.AuthorInstitution.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New(tValue)) Set tFound=1

		If tFound {
			Do pDocument.Author.Insert(tAuthor)					
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "CreationTime" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning the CreationTime can be done in either the OnPre or OnPost code using the following (YYYYMMDDHHMMSS as UTC)<br>
/// 		<li>Set:pDocument.CreationTime="" pDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(##class(HS.Util.XSLTHelper).timestamp())<li><br>
///   <Method>ClassMethod OnPreUpdateCreationTime(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostUpdateCreationTime(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object</li>
Method UpdateCreationTime(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateCreationTime(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the creation time from the CDA document
ClassMethod CMUpdateCreationTime(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tValue,.pXPathDoc)
		#; if there is a value, it probably has an offset, we need to drop the offset for creation time
		If $$$ISOK(tSC) && (tValue]"") Set pDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tValue)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "FormatCode" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning the FormatCode can be done in either the OnPre or OnPost code using the following <br>
/// 		<li>Set:pDocument.FormatCode.Code="" pDocument.FormatCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")<li>
/// 		<li>or If pDocument.FormatCode.Code="" Set pDocument.FormatCode.Code="2.16.840.1.113883.10.20.1",pDocument.FormatCode.CodingScheme="2.16.840.1.113883.3.88" Do pDocument.FormatCode.Names.Insert("HL7 CCD Document")<li><br>
///   <Method>ClassMethod OnPreUpdateFormatCode(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostUpdateFormatCode(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object</li>
Method UpdateFormatCode(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateFormatCode(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the format code from the CDA document
ClassMethod CMUpdateFormatCode(ByRef pDocument, ByRef pXPathDoc) As %Status [ Internal ]
{
	try {
		Set tSC=$$$OK
		For tIdx = 1:1 {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:templateId["_tIdx_"]","@root",.tValue,.pXPathDoc)
			Quit:$$$ISERR(tSC)||(tValue="")
			#dim tResultSet as %SQL.StatementResult = ##class(%SQL.Statement).%ExecDirect(.tStmt,"SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType=? And Code=?","formatCode",tValue)
			Quit:tResultSet.%SQLCODE 
			If tResultSet.%Next() {
				If pDocument.%IsA("HS.Types.IHE.XDSb.Document") {
					Set pDocument.FormatCode.Code=tResultSet.Code
					Set pDocument.FormatCode.CodingScheme=tResultSet.CodingScheme
					Do pDocument.FormatCode.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(tResultSet.Description))
				} Else {
					Set pDocument.FormatCode.Code=tResultSet.Code
					Set pDocument.FormatCode.Scheme=tResultSet.CodingScheme
					Set pDocument.FormatCode.Description = tResultSet.Description
				}
			}
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "TypeCode" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning the TypeCode can be done in either the OnPre or OnPost code using the following <br>
/// 	<li>Set:pDocument.TypeCode.Code="" pDocument.TypeCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New("34133-9","2.16.840.1.113883.6.1","Summarization of episode note")<li>
/// 	<li>or If pDocument.TypeCode.Code="" Set pDocument.TypeCode.Code="34133-9",pDocument.TypeCode.CodingScheme="2.16.840.1.113883.6.1" Do pDocument.TypeCode.Names.Insert("Summarization of episode note")<li><br>
///   <Method>ClassMethod OnPreUpdateTypeCode(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostUpdateTypeCode(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object</li>
Method UpdateTypeCode(pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateTypeCode(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the TypeCode from the CDA document
ClassMethod CMUpdateTypeCode(pDocument, ByRef pXPathDoc) As %Status [ Internal ]
{
	try {
		Set tSC=$$$OK
		#; A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tCode,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tCodeSystem,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tCodeSystem)

		#dim tStmt as %SQL.Statement
		#dim tResultSet as %SQL.StatementResult = ##class(%SQL.Statement).%ExecDirect(.tStmt,"SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType=? And Code=? And CodingScheme=?","typeCode",tCode,tCodeSystem)
		Quit:tResultSet.%SQLCODE 
		Set (tCode,tScheme,tDescription)=""
		If tResultSet.%Next() {
			Set tCode=tResultSet.Code
			Set tScheme=tResultSet.CodingScheme
			Set tDescription = tResultSet.Description
		} Else {
			#; try the code system name as text
			Set tResultSet = tStmt.%Execute("typeCode",tCode,tCodeSystemName)
			Quit:tResultSet.%SQLCODE 
			If tResultSet.%Next() {
				Set tCode=tResultSet.Code
				Set tScheme=tResultSet.CodingScheme
				Set tDescription = tResultSet.Description
			}
		}
		If pDocument.%IsA("HS.Types.IHE.XDSb.Document") {
			Set pDocument.TypeCode.Code=tCode
			Set pDocument.TypeCode.CodingScheme=tScheme
			Do pDocument.TypeCode.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(tDescription))
		} Else {
			Set pDocument.TypeCode.Code=tCode
			Set pDocument.TypeCode.Scheme=tScheme
			Set pDocument.TypeCode.Description = tDescription
		}

	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "ClassCode" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning the ClassCode can be done in either the OnPre or OnPost code using the following <br>
/// 	<li>Set:pDocument.ClassCode.Code="" pDocument.ClassCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New("34133-9","2.16.840.1.113883.6.1","Summarization of episode note")<li>
/// 	<li>or If pDocument.ClassCode.Code="" Set pDocument.ClassCode.Code="34133-9",pDocument.ClassCode.CodingScheme="2.16.840.1.113883.6.1" Do pDocument.ClassCode.Names.Insert("Summarization of episode note")<li><br>
///   <Method>ClassMethod OnPreUpdateClassCode(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostUpdateTypeCode(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object</li>
Method UpdateClassCode(pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateClassCode(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the class code from the CDA document
ClassMethod CMUpdateClassCode(pDocument, ByRef pXPathDoc) As %Status [ Internal ]
{
	try {
		Set tSC=$$$OK
		#; A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tCode,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tCodeSystem,.pXPathDoc) Quit:$$$ISERR(tSC)
		Set tCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tCodeSystem)

		#dim tStmt as %SQL.Statement
		#dim tResultSet as %SQL.StatementResult = ##class(%SQL.Statement).%ExecDirect(.tStmt,"SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType=? And Code=? And CodingScheme=?","classCode",tCode,tCodeSystem)
		Quit:tResultSet.%SQLCODE 
		Set (tCode,tScheme,tDescription)=""
		If tResultSet.%Next() {
			Set tCode=tResultSet.Code
			Set tCodingScheme=tResultSet.CodingScheme
			Set tDescription = tResultSet.Description
		} Else {
			#; try the code system name as text
			Set tResultSet = tStmt.%Execute("classCode",tCode,tCodeSystemName)
			Quit:tResultSet.%SQLCODE 
			If tResultSet.%Next() {
				Set tCode=tResultSet.Code
				Set tCodingScheme=tResultSet.CodingScheme
				Set tDescription = tResultSet.Description
			}
		}
		
		If pDocument.%IsA("HS.Types.IHE.XDSb.Document") {
			Set pDocument.ClassCode.Code=tCode
			Set pDocument.ClassCode.CodingScheme=tCodingScheme
			Do pDocument.ClassCode.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(tDescription))
		} Else {
			Set pDocument.ClassCode.Code=tCode
			Set pDocument.ClassCode.Scheme=tCodingScheme
			Set pDocument.ClassCode.Description = tDescription
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "LanguageCode" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning the LanguageCode can be done in either the OnPre or OnPost code using the following <br>
/// 		<li>Set pDocument.LanguageCode=tValue<li>
///   <Method>ClassMethod OnPreUpdateLanguageCode(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostUpdateLanguageCode(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object</li>
Method UpdateLanguageCode(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateLanguageCode(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the language code from the CDA document
ClassMethod CMUpdateLanguageCode(ByRef pDocument, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:languageCode","@code",.tValue,.pXPathDoc)
		If $$$ISOK(tSC) && (tValue]"") Set pDocument.LanguageCode=tValue
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "Names" also thought of as title <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning the Name can be done in either the OnPre or OnPost code using the following <br>
/// 	<li>Do pDocument.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(tValue))</li>
///   <Method>ClassMethod OnPreUpdateNames(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostUpdateNames(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object</li>
Method UpdateNames(ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateNames(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting the name(title) from the CDA document
ClassMethod CMUpdateNames(ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:title","text()",.tValue,.pXPathDoc)
		If $$$ISOK(tSC) && (tValue]"") Do pDocument.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(tValue))
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "SourcePatientId" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
///   <Method>ClassMethod OnPreUpdateSourcePatientId(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the pDocument object prior to any additional processing, or the source patient id could be extracted from a different location in the document</li>
///   <Method>ClassMethod OnPostUpdateSourcePatientId(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object, such as defaulting a value (Set pDocument.SourcePatientId="111^^^&1.2.3&ISO") if the base code failed to locate a value</li>
Method UpdateSourcePatientId(ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateSourcePatientId(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting SourcePatientId from the CDA document
ClassMethod CMUpdateSourcePatientId(ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@root",.tValueRoot,.pXPathDoc)
		Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@extension",.tValueExtension,.pXPathDoc)
		Quit:$$$ISERR(tSC)

		#; If this is a AU CDA document, patientRole id will be just a UUID in @root. Look down in ext:asEntityIdentifier for an MRN.
		If (((tValueExtension="") && (tValueRoot="")) || ((tValueExtension="") && ($Length(tValueRoot,"-")>3) && ($Translate(tValueRoot,"-")?1LN.LN))) {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@root",.tValueRoot,.pXPathDoc)
			Quit:$$$ISERR(tSC)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@extension",.tValueExtension,.pXPathDoc)
			Quit:$$$ISERR(tSC)
			If (tValueExtension="") && (tValueRoot="") {
				#; If MRN not found in AU document, look down in ext:asEntityIdentifier for an IHI.
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@root",.tValueRoot,.pXPathDoc)
				Quit:$$$ISERR(tSC)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@extension",.tValueExtension,.pXPathDoc)
				Quit:$$$ISERR(tSC)
				If $Extract(tValueRoot,1,27)="1.2.36.1.2001.1003.0.800360",tValueExtension="" Set tValueExtension=$Extract(tValueRoot,22,*),tValueRoot="1.2.36.1.2001.1003.0"
			}
		}
		If (tValueExtension]"") && (tValueRoot]"")  Set pDocument.SourcePatientId=tValueExtension_"^^^&"_tValueRoot_"&ISO"
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Use the content of the CDA document to extract the "SourcePatientInfo" <br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to another Host Using pHost.SendRequestSync() or pHost.SendRequestAsync()<br>
/// Assigning the SourcePatientInfo can be done in either the OnPre or OnPost code using the following <br>
/// 	<li>Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-3|"_pDocument.SourcePatientId))</li>
/// 	<li>Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-5|family^given^middle"))</li>
/// 	<li>Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-7|birthtime(yyyymmddhhmmss)"))</li>
/// 		<li>Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-8|gender"))</li>
/// 	<li>Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-11|addressline1;line2^additionallocator^city^state^postalcode"))</li>
///   <Method>ClassMethod OnPreSourcePatientInfo(pHost As Ens.Host , Output pStopProcessing as %Boolean, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (returned from the method). </li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostSourcePatientInfo(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object</li>
Method UpdateSourcePatientInfo(ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CMUpdateSourcePatientInfo(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		$$$OnPost(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Internal processing method for extracting SourcePatientInfo from the CDA document
ClassMethod CMUpdateSourcePatientInfo(ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) As %Status
{
	try {
		Set tSC=$$$OK
		If pDocument.SourcePatientId="" Set tSC = ..CMUpdateSourcePatientId(.pDocument,.pXPathDoc) Quit:$$$ISERR(tSC)
		Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-3|"_pDocument.SourcePatientId))
		#; patient name
		Set tPID="PID-5|"
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:family","text()",.tValue,.pXPathDoc)
		Set tPID=tPID_tValue_"^"
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[1]","text()",.tValue,.pXPathDoc)
		Set tPID=tPID_tValue_"^"
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[2]","text()",.tValue,.pXPathDoc)
		Set tPID=tPID_tValue
		Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New(tPID))
		#; BirthDate
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime","@value",.tValue,.pXPathDoc)
		Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-7|"_tValue))
		#; Gender
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode","@code",.tValue,.pXPathDoc)
		Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-8|"_tValue))
		#; Address
		Set tStreet=""				
		Set tSC = pXPathDoc.EvaluateExpression("/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:streetAddressLine", "text()", .tResults)
		For tIdx=1:1:tResults.Count() { Set tStreet=tStreet_";"_tResults.GetAt(tIdx).Value}
		Set tPID=$e(tStreet,2,*)
				
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:additionalLocator","text()",.tValue,.pXPathDoc)
		Set tPID=tPID_"^"_tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:city","text()",.tValue,.pXPathDoc)
		Set tPID=tPID_"^"_tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:state","text()",.tValue,.pXPathDoc)
		Set tPID=tPID_"^"_tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:postalCode","text()",.tValue,.pXPathDoc)
		Set tPID=tPID_"^"_tValue

		Do pDocument.SourcePatientInfo.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("PID-11|"_tPID))

	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Attach binary or character documents to the outbound request
Method AttachDocuments(pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, pOutboundRequest As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC = $$$OK
		For tIdx=1:1:pUpdatedRequest.Documents.Count() {
			Set tDoc = pUpdatedRequest.Documents.GetAt(tIdx)
			If '..DocumentsInline {
				Set tAttach = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
				Set tAttach.ContentId=tDoc.EntryUUID
				If tDoc.Body.Size {
					Do tAttach.Body.CopyFrom(tDoc.Body)
					Set tDoc.Body=""
				} Else {
					Do tAttach.Body.CopyFrom(tDoc.BodyCharacter)
					Set tDoc.BodyCharacter=""
				}
				Do pOutboundRequest.StreamCollection.Insert(tAttach)
				Set:tDoc.Size="" tDoc.Size=tAttach.Body.Size
				Set:tDoc.Hash="" tDoc.Hash=##class(HS.IHE.XDSb.Util).StreamHash(tAttach.Body)
			} Else {
				#; inline documents
				If tDoc.BodyCharacter.Size {
					Do tDoc.Body.CopyFrom(tDoc.BodyCharacter) Set tDoc.BodyCharacter=""
					Set:tDoc.Size="" tDoc.Size=tDoc.Body.Size
					Set:tDoc.Hash="" tDoc.Hash=##class(HS.IHE.XDSb.Util).StreamHash(tDoc.Body)
				}
			}
		}
	} Catch ex { Set tSC=ex.AsStatus() }
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	Quit tSC
}

/// if the request is CDA we may need to extract values from the document and update the request
/// for this reason tUdpatedRequest is used so that the original transaction is not updated
Method GetUpdatedProvideRequest(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, Output pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	#define CloneObject Set tDocument=pUpdatedRequest.Documents.GetAt(tIdx)
	try {
		Set pUpdatedRequest=pRequest.%ConstructClone(1) 
		Set tSC=$$$OK
		$$$HSTRACE("patientid","patientid",pRequest.PatientId)
		If pRequest.PatientId="" Set tSC = ..GetUpdatedPatientId(pRequest,.pUpdatedRequest) Quit:$$$ISERR(tSC)

		For tIdx=1:1:pUpdatedRequest.Documents.Count() {
			#dim tDocument as HS.Message.IHE.XDSb.Document = pUpdatedRequest.Documents.GetAt(tIdx)
			Set tDocObject=""
			Set:tDocument.PatientId="" tDocument.PatientId=$S($isObject(pUpdatedRequest):pUpdatedRequest.PatientId,1:pRequest.PatientId)
			#; locate document to replace
			$$$HSTRACE("ReplacmentContext "_tDocument.ReplacementContext.Count())
			If tDocument.ReplacementContext.Count() $$$CloneObject Set tSC=..GetReplacementId(tDocument,pUpdatedRequest.PatientId) Quit:$$$ISERR(tSC)

			#; if it is binary we will not extract values
			If 'tDocument.BodyCharacter.Size Continue
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:typeId","@root",.tValue,.tDocObject)
			/// if there is no value for the typeId it is not CDA
			If $$$ISERR(tSC) || (tValue="") Set tSC=$$$OK Continue
			If tDocument.CreationTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tValue,.tDocObject)
				#; if there is a value, it probably has an offset, we need to drop the offset for creation time
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tValue)
			}
			/*
				A= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/@value"
				B= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low/@value"
				C= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value"
				D= "/cda:ClinicalDocument/cda:effectiveTime/@value"
 
				The UTC date we will use is the first one that has a value.
 
					serviceStartTime = B,A,D (only going to get A or B, never both, defaulting back to D which is mandatory)
					serviceEndTime   = C,A,D (only going to get A or C, never both, defaulting back to D which is mandatory)
			*/
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime","@value",.tA,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:low","@value",.tB,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:high","@value",.tC,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tD,.tDocObject)
			If tDocument.ServiceStartTime="" {
				Set tTime=$S($G(tB)]"":tB,$G(tA)]"":tA,1:$g(tD))
				Set tDocument.ServiceStartTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
			}
			If tDocument.ServiceStopTime="" {
				Set tTime=$S($G(tC)]"":tB,$G(tA)]"":tA,1:$g(tD))
				Set tDocument.ServiceStopTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
			}

			If tDocument.LanguageCode="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:languageCode","@code",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.LanguageCode=tValue
			}
			If tDocument.SourcePatientId="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@root",.tValueRoot,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@extension",.tValueExtension,.tDocObject)
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && (((tValueExtension="") && (tValueRoot="")) || ((tValueExtension="") && ($Length(tValueRoot,"-")>3) && ($Translate(tValueRoot,"-")?1LN.LN))) {
					// If this is a AU CDA document, patientRole id will be just a UUID in @root. Look down in ext:asEntityIdentifier for an MRN.
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@root",.tValueRoot,.tDocObject)
					Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@extension",.tValueExtension,.tDocObject)
					If $$$ISOK(tSC) && $$$ISOK(tSC2) && (tValueExtension="") && (tValueRoot="") {
						// If MRN not found in AU document, look down in ext:asEntityIdentifier for an IHI.
						Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@root",.tValueRoot,.tDocObject)
						Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@extension",.tValueExtension,.tDocObject)
						If $Extract(tValueRoot,1,27)="1.2.36.1.2001.1003.0.800360",tValueExtension="" Set tValueExtension=$Extract(tValueRoot,22,*),tValueRoot="1.2.36.1.2001.1003.0"
					}
				}
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && (tValueExtension]"") && (tValueRoot]"") $$$CloneObject Set tDocument.SourcePatientId=tValueExtension_"^^^&"_tValueRoot_"&ISO"
			}
			If tDocument.ServiceStartTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:low","@value",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.ServiceStartTime=tValue
			}
			If tDocument.ServiceStopTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:high","@value",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.ServiceStopTime=tValue
			}
			If tDocument.Title="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:title","text()",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.Title=tValue
			
			}
			If tDocument.ConfidentialityCode.Count()=0 {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@code",.tCode,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@codeSystem",.tScheme,.tDocObject)
				Set tSC3 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@displayName",.tDescription,.tDocObject)
				// Document-level confidentialityCode could be nullFlavor.  If so, default in N for Normal.
				If $$$ISOK(tSC),$$$ISOK(tSC2),$$$ISOK(tSC3),tCode="",tScheme="" Set tCode="N",tScheme="2.16.840.1.113883.5.25",tDescription="Normal"
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && $$$ISOK(tSC3) $$$CloneObject Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create(tCode,tScheme,tDescription))
			}
			If tDocument.SourcePatientInfo.Count()=0 {
				$$$CloneObject
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-3|"_tDocument.SourcePatientId))
				#; patient name
				Set tPID="PID-5|"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:family","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue_"^"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[1]","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue_"^"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[2]","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tPID))
				#; BirthDate
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime","@value",.tValue,.tDocObject)
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|"_tValue))
				#; Gender
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode","@code",.tValue,.tDocObject)
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-8|"_tValue))
				#; Address

				Set tStreet=""				
				Set tSC = tDocObject.EvaluateExpression("/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:streetAddressLine", "text()", .tResults)
				For tIdx=1:1:tResults.Count() { Set tStreet=tStreet_";"_tResults.GetAt(tIdx).Value}
				Set tPID=$e(tStreet,2,*)
				
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:additionalLocator","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:city","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:state","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:postalCode","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue

				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-11|"_tPID))

			}
			
			If tDocument.Author.Count()=0 {
				///cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']/@root
				///cda:ClinicalDocument/cda:author/cda:assignedAuthor/ cda:assignedPerson/cda:name
				Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New(),tFound=0
				Set (tFirstName,tMiddleName,tLastName,tPrefix,tSuffix)=""
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given[1]","text()",.tFirstName,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:given[2]","text()",.tMiddleName,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:family","text()",.tLastName,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:prefix","text()",.tPrefix,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name/hl7:suffix","text()",.tSuffix,.tDocObject)
				If tFirstName'=""!(tLastName'="") {
					// As suggested by ITI TF-3 2012 section 4.2.3.1.4 example, the format is identifier^last^first^middle^suffix^prefix.
					Set tValue=""
					Set $Piece(tValue,"^",2)=tLastName
					Set $Piece(tValue,"^",3)=tFirstName
					Set $Piece(tValue,"^",4)=tMiddleName
					Set $Piece(tValue,"^",5)=tSuffix
					Set $Piece(tValue,"^",6)=tPrefix
					Set tAuthor.AuthorPerson=tValue
					Set tFound=1
				}
				If tFound=0 {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name","text()",.tValue,.tDocObject)
					Set tValue=$Translate(tValue,$Char(10))
					Set tAuthor.AuthorPerson=tValue Set:tValue]"" tFound=1
				}
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:name","text()",.tValue,.tDocObject)
				If tValue]"" Do tAuthor.AuthorInstitution.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tValue)) Set tFound=1

				/// need role and specialty
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && tFound {
					Do tDocument.Author.Insert(tAuthor)					
				}
								
			}
			
		
			If tDocument.FormatCode.Code="" {
				Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='formatCode'"
				Set tStatement = ##class(%SQL.Statement).%New()
				Set tStatement.%SelectMode = 2
				Set tStatus = tStatement.%Prepare(tSQL)
				Set tResultSet = tStatement.%Execute()
				While tResultSet.%Next() {
					// If there's duplicate entries (different CodingSchemes) then we end up with the last one only.
					Set tFormatCodes(tResultSet.Code)=tResultSet.CodingScheme_"|"_tResultSet.Description
				}
				Kill tResultSet
				Kill tStatement
				
				// There can be several document-level templateIds.  Loop until
				// the end or until you find one that matches a valid formatCode.
				For jj = 1:1 {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:templateId["_jj_"]","@root",.tValue,.tDocObject)
					If $$$ISERR(tSC)!(tValue="") Quit
					If $Data(tFormatCodes(tValue))#10 Set tDocument.FormatCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tValue,$Piece(tFormatCodes(tValue),"|",1),$Piece(tFormatCodes(tValue),"|",2)) Quit
				}
				Kill tFormatCodes
			}
			
			If tDocument.TypeCode.Code="" {
				// A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
				Set tDocCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tDocCodeSystem)
				Set tDocCodeSystemNameUp = $ZCVT(tDocCodeSystemName,"U")
				
				// First look for the Code with the OID as the CodingScheme.
				// If not found then look for the Code with the OID's IdentityCode (case-insensitive) as the CodingScheme.
				If tDocCode'="",tDocCodeSystem'="" {
					Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='typeCode' AND Code=?"
					Set tStatement = ##class(%SQL.Statement).%New()
					Set tStatement.%SelectMode = 2
					Set tStatus = tStatement.%Prepare(tSQL)
					Set tResultSet = tStatement.%Execute(tDocCode)
					While tResultSet.%Next() {
						Set tCodeSchemes($ZCVT(tResultSet.CodingScheme,"U"))=tResultSet.CodingScheme_"|"_tResultSet.Description
					}
					Kill tResultSet
					Kill tStatement
					If $Data(tCodeSchemes(tDocCodeSystem))#10 {
						Set tDocument.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystem),"|",1),$Piece(tCodeSchemes(tDocCodeSystem),"|",2))
					} Else {
						If $Data(tCodeSchemes(tDocCodeSystemNameUp))#10 Set tDocument.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",1),$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",2))
					}
					Kill tCodeSchemes
				}
			}
			
			If tDocument.ClassCode.Code="" {
				If $Get(tDocCode)="" {
					// A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
					Set tDocCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tDocCodeSystem)
					Set tDocCodeSystemNameUp = $ZCVT(tDocCodeSystemName,"U")
				}
				
				// First look for the Code with the OID as the CodingScheme.
				// If not found then look for the Code with the OID's IdentityCode (case-insensitive) as the CodingScheme.
				If tDocCode'="",tDocCodeSystem'="" {
					Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='classCode' AND Code=?"
					Set tStatement = ##class(%SQL.Statement).%New()
					Set tStatement.%SelectMode = 2
					Set tStatus = tStatement.%Prepare(tSQL)
					Set tResultSet = tStatement.%Execute(tDocCode)
					While tResultSet.%Next() {
						Set tCodeSchemes($ZCVT(tResultSet.CodingScheme,"U"))=tResultSet.CodingScheme_"|"_tResultSet.Description
					}
					Kill tResultSet
					Kill tStatement
					If $Data(tCodeSchemes(tDocCodeSystem))#10 {
						Set tDocument.ClassCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystem),"|",1),$Piece(tCodeSchemes(tDocCodeSystem),"|",2))
					} Else {
						If $Data(tCodeSchemes(tDocCodeSystemNameUp))#10 Set tDocument.ClassCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",1),$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",2))
					}
					Kill tCodeSchemes
				}
			}
		}
		Quit:$$$ISERR(tSC)		
		$$$HSTRACE("About to call update associations"_pUpdatedRequest.Associations.Count())
		Set tSC=..UpdateAssociations(pUpdatedRequest)
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$HSTRACE("Error","tSC",tSC)
	}
	Quit tSC
}

Method UpdateAssociations(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	Quit pRequest.UpdateAssociations()
}

Method GetUpdatedAssociations(pRequest As HS.Message.IHE.XDSb.Metadata) As %Status
{
	Set tSC=$$$OK
	try {
		If pRequest.%IsA("HS.Message.IHE.XDSb.ProvideAndRegisterRequest") {
			Set tSubmission = pRequest
		} Else {
			Set tSubmission = pRequest.Submissions.GetAt(1)
		}
		#; user may have already created associations track which items and don't create them again
		Set tAssociations=""
		For tIdx =1:1:pRequest.Associations.Count() {
			Set tAssociation = pRequest.Associations.GetAt(tIdx)
			If tAssociation.Type="HasMember",tAssociation.ChildUUID]"" Set tAssociations(tAssociation.ChildUUID,tAssociation.ParentUUID)=""
		}
		For tIdx=1:1:pRequest.Documents.Count() {
			Set tDocument = pRequest.Documents.GetAt(tIdx)
			#; don't add the association if it is already in there
			If $D(tAssociations(tDocument.EntryUUID,tSubmission.EntryUUID)) Continue
			Set tAssociation = ##class(HS.Types.IHE.XDSb.Association).Create("HasMember",tSubmission.EntryUUID,tDocument.EntryUUID)
			If tDocument.Version]"" Set tAssociation.PreviousVersion=tDocument.Version
			Set tAssociation.SubmissionSetStatus="Original"
			Do pRequest.Associations.Insert(tAssociation)
			If tDocument.ReplaceSource]"" {
				Set tReplaceSource=tDocument.ReplaceSource
				If $E(tReplaceSource,1,3)="urn" Set tReplaceSource=$p(tReplaceSource,"urn:uuid:",2)
				Set tAssociation = ##class(HS.Types.IHE.XDSb.Association).Create("Replaces",tDocument.EntryUUID,tReplaceSource)
				Do pRequest.Associations.Insert(tAssociation)
			}
		}
		For tIdx=1:1:pRequest.Folders.Count() {
			Set tFolder=pRequest.Folders.GetAt(tIdx)
			#; don't add the association if it is already in there

			If $D(tAssociations(tFolder.EntryUUID,tSubmission.EntryUUID)) Continue
			Set tAssociation = ##class(HS.Types.IHE.XDSb.Association).Create("HasMember",tSubmission.EntryUUID,tFolder.EntryUUID)
			Do pRequest.Associations.Insert(tAssociation)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method UpdatePatientIdentifier(ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc, pRequired As %Boolean = 1) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,.pDocument,.pXPathDoc,pRequired) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tValueRoot = $p(pDocument.SourcePatientId,"&",2)
		Set tValueExtension = $p(pDocument.SourcePatientId,"^")

		Set tValueRootCode = ##class(HS.Data.OIDMap).GetCodeForOID(tValueRoot,"") 
		If tValueRootCode="" Set tSC=$$$ERROR($$$GeneralError,$$$FormatText("Unknown OID %1",tValueRoot)) Quit

		Set tPatientID=""
		If tValueRootCode = $$$AffinityDomain {
			Set tPatientID = pDocument.SourcePatientId
		} Else {
			Set tSC = ..FindPatientID(tValueExtension,tValueRootCode,.tSearchResponse)

			If $IsObject(tSearchResponse) && (tSearchResponse.Results.Count()=1) {
				Set tPatientID=tSearchResponse.Results.GetAt(1).MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
			} 
		}
		If $p(tPatientID,"^")="" {
			#; it's only an error if the patient id is required (not required for XDM)
			Set:pRequired tSC = $$$ERROR($$$GeneralError,"Unable to determine the Patient ID") 
		} Else {
			Set pDocument.PatientIdentifier.Value = tPatientID
		}
		$$$OnPost(.pDocument,.pXPathDoc,pRequired) Quit:$$$ISERR(tSC)
		$$$HSTRACE("Patient identifier","tPatientID,tSC,tValueRootCode,tValueExtension",tPatientID,tSC,tValueRootCode,tValueExtension)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// HealthShare creates CCD's with MRN/AA as the source patient ID.  We need to submit the document with the MPI ID
Method GetUpdatedPatientId(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, Output pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	#define CloneObject Set:'$IsObject(pUpdatedRequest) pUpdatedRequest = pRequest.%ConstructClone(1) Set tDocument=pUpdatedRequest.Documents.GetAt(tIdx)
	Set tSC=$$$OK
	Try {		
		Set tIdx=1  /// first document (used by clone)
		$$$CloneObject
		If tDocument.SourcePatientId="" && (tDocument.BodyCharacter.Size=0) Set tSC = $$$ERROR($$$GeneralError,"First document is not CDA, unable to determine the Patient ID") Quit 
		If tDocument.SourcePatientId]"" {
			Set tValueRoot = $p($p(tDocument.SourcePatientId,"^",4),"&",2)
			Set tValueExtension = $p(tDocument.SourcePatientId,"^")
		} Else {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@root",.tValueRoot,.tDocObject)
			Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@extension",.tValueExtension,.tDocObject)
			If $$$ISERR(tSC) || $$$ISERR(tSC2) Quit
			Set tDocument.SourcePatientId=tValueExtension_"^^^&"_tValueRoot_"&ISO"
		}
		Set tValueRootCode = ##class(HS.Data.OIDMap).GetCodeForOID(tValueRoot,"") If tValueRootCode="" Set tSC=$$$ERROR($$$GeneralError,"Unknown OID "_tValueRoot) Quit
		Set tValueRoot=tValueRootCode
		If tValueRoot = $$$AffinityDomain {
			Set pUpdatedRequest.PatientId=tDocument.SourcePatientId
		} Else {
			Set tSC = ..FindPatientID(tValueExtension,tValueRoot,.tSearchResponse)

			If $isObject(tSearchResponse) && (tSearchResponse.ResultsCount=1) {
				Set pUpdatedRequest.PatientId=tSearchResponse.Results.GetAt(1).MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
				$$$HSTRACE("patientid","patientid",pUpdatedRequest.PatientId)
			}
			ElseIf (..AddNewPatients) {
				Set tSC = ..AddPatientRequest(tDocument.BodyCharacter,.tSourcePatientID,.tGlobalPatientId)
				Quit:$$$ISERR(tSC)
				Set pUpdatedRequest.PatientId=tGlobalPatientId
			} Else { ; $IsObject(tSearchResponse) || 'tSearchResponse.Results.Count()
				Set tSC = $$$ERROR($$$GeneralError,"Unable to locate patient identifier") Quit
			}
		}
		If $p(pUpdatedRequest.PatientId,"^")="" Set tSC = $$$ERROR($$$GeneralError,"Unable to determine the Patient ID") Quit 
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	$$$HSTRACE("patientid","patientid,tSC",pUpdatedRequest.PatientId,tSC)
	Quit tSC
}

Method FindPatientID(pMRN, pAssigningAuthority, ByRef pSearchResponse) As %Status
{
	try {
		Set pSearchResponse=""
		Set tSearchRequest = ##class(HS.Message.PatientSearchRequest).%New()
		Set tSearchRequest.MRN=pMRN
		Set tSearchRequest.AssigningAuthority=pAssigningAuthority
		Set tSC = ..SendRequestSync(..PIXv3ConsumerOperations,tSearchRequest,.pSearchResponse)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod GetAddPatientRequest(pCDAStream As %Stream, Output pAddRequest As HS.Message.AddUpdateHubRequest = "", Output pCDADocObject = "") As %Status
{
	try {
		Set:'$Isobject(pAddRequest) pAddRequest=##class(HS.Message.AddUpdateHubRequest).%New()
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given","text()",.tValue,.pCDADocObject)
		Set pAddRequest.FirstName=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:family","text()",.tValue,.pCDADocObject)
		Set pAddRequest.LastName=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:middle","text()",.tValue,.pCDADocObject)
		Set pAddRequest.MiddleName=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode","@code",.tValue,.pCDADocObject)
		Set pAddRequest.Sex=tValue
		#; BirthDate
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime","@value",.tValue,.pCDADocObject)
		Set pAddRequest.DOB=$zdh($e(tValue,1,8),8,,,,,,,"")
		
		Set tAddr=##class(HS.Types.Address).%New()
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:streetAddressLine","text()",.tValue,.pCDADocObject)
		Set tAddr.StreetLine=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:city","text()",.tValue,.pCDADocObject)
		Set tAddr.City=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:state","text()",.tValue,.pCDADocObject)
		Set tAddr.State=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:postalCode","text()",.tValue,.pCDADocObject)
		Set tAddr.PostalCode=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]","@use",.tValue,.pCDADocObject)
		Set tAddr.Use=$Case(tValue,"":"HP","H":"HP","W":"WP",:tValue)
		Do pAddRequest.Addresses.Insert(tAddr)

		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@root",.tValueRoot,.tDocObject)
		Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id","@extension",.tValueExtension,.tDocObject)
		If $$$ISOK(tSC) && $$$ISOK(tSC2) && (((tValueExtension="") && (tValueRoot="")) || ((tValueExtension="") && ($Length(tValueRoot,"-")>3) && ($Translate(tValueRoot,"-")?1LN.LN))) {
			// If this is a AU CDA document, patientRole id will be just a UUID in @root. Look down in ext:asEntityIdentifier for an MRN.
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@root",.tValueRoot,.tDocObject)
			Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id","@extension",.tValueExtension,.tDocObject)
			If $$$ISOK(tSC) && $$$ISOK(tSC2) && (tValueExtension="") && (tValueRoot="") {
				// If MRN not found in AU document, look down in ext:asEntityIdentifier for an IHI.
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@root",.tValueRoot,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(pCDAStream,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@extension",.tValueExtension,.tDocObject)
				If $Extract(tValueRoot,1,27)="1.2.36.1.2001.1003.0.800360",tValueExtension="" Set tValueExtension=$Extract(tValueRoot,22,*),tValueRoot="1.2.36.1.2001.1003.0"
			}
		}
		If $$$ISOK(tSC) && $$$ISOK(tSC2) && (tValueExtension]"") && (tValueRoot]"") Set pAddRequest.MRN=tValueExtension,pAddRequest.AssigningAuthority=##class(HS.Data.OIDMap).GetCodeForOID(tValueRoot)
		Set pAddRequest.Facility=pAddRequest.AssigningAuthority
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method AddPatientRequest(pStream As %Stream, Output pSourcePatientID As %String, Output pGlobalIdentifier As %String) As %Status
{
	Set tSC=$$$OK
	Try{
		Set tSC = ..GetAddPatientRequest(pStream,.tAddRequest)
		Quit:$$$ISERR(tSC)
		If tAddRequest.MRN="" || (tAddRequest.AssigningAuthority="") {
			Set tSC = $$$ERROR($$$GeneralError,"Patient MRN / Assigning Authority not located in CDA")
			Quit
		}
		If tAddRequest.Facility]"" {
			Set tFAC = ##class(HS.Facility.Config).%OpenId(tAddRequest.Facility)
			Set tAddRequest.GatewayName=$S($isObject(tFAC):tFAC.Gateway.Name,1:"")
		}
		Set tSC=..SendRequestSync(..MPIOperations,tAddRequest,.tAddResponse)
		Quit:$$$ISERR(tSC) 
		Set pSourcePatientID=tAddRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).OIDForType(tAddRequest.AssigningAuthority)_"&ISO"
		Set pGlobalIdentifier=tAddResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	}
	Catch ex{
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

}

Include Ensemble

Class HS.IHE.ATNA.Repository.Data.AuditMessage Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "AuditMessage";

Parameter XMLSEQUENCE = 1;

Property EventIdentification As HS.IHE.ATNA.Repository.Data.EventIdentificationType(XMLNAME = "EventIdentification") [ Required ];

Property ActiveParticipant As list Of HS.IHE.ATNA.Repository.Data.ActiveParticipant(XMLNAME = "ActiveParticipant", XMLPROJECTION = "ELEMENT") [ Required, SqlListType = SUBNODE ];

Property AuditSourceIdentification As list Of HS.IHE.ATNA.Repository.Data.AuditSourceIdentificationType(XMLNAME = "AuditSourceIdentification", XMLPROJECTION = "ELEMENT") [ Required, SqlListType = SUBNODE ];

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Storage.Persistent) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

Property ParticipantObjectIdentification As list Of HS.IHE.ATNA.Repository.Data.ParticipantObjectIdentificationType(XMLNAME = "ParticipantObjectIdentification", XMLPROJECTION = "ELEMENT") [ SqlListType = SUBNODE ];

/// This is only used to record external audit messages.  They will be converted to an Aggregation record,
/// which will contain the entire inbound AuditMessage stream in its ATNAMessage string property
ClassMethod SaveRequest(pRequest As HS.Message.XMLMessage, Output pAuditIndex As HS.IHE.ATNA.Repository.Aggregation) As %Status
{
	#dim tAuditEntry As HS.IHE.ATNA.Repository.Data.AuditMessage
	Set pAuditIndex=##Class(HS.IHE.ATNA.Repository.Aggregation).%New()
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"

	DO {
	    Set tReader = ##class(%XML.Reader).%New()
 
	    Do tReader.OpenStream(pRequest.ContentStream)
	    Do tReader.Correlate("AuditMessage", "HS.IHE.ATNA.Repository.Data.AuditMessage")
	    //Note - there should only ever be one record here, so this loop should only ever run one iteration
	    While (tReader.Next(.tAuditEntry, .tSC)) {
	        If $$$ISERR(tSC) Quit
	        Do ..ATNAToAggregation(tAuditEntry,.tAggregate)
	        #; Get facility internal from SAML, if present
	        Set tAggregate.FacilityInternal=pRequest.SAMLData.Organization
	        //otherwise, try to compute it from the user
	        If tAggregate.FacilityInternal="", tAggregate.UserName'="" Set tAggregate.FacilityInternal=tAggregate.GetPrimFac(tAggregate.UserName)

			Set tKey=""
			For {
				Set tVal=pRequest.CustomAuditInfo.GetNext(.tKey)
				Quit:tKey=""
				Set tPair=##class(HS.IHE.ATNA.Repository.CustomPair).%New()
				Set tPair.Name=tKey, tPair.Value=tVal
				Do tAggregate.CustomPairs.Insert(tPair)
			}
			// get inbound IP as a custom pair from additionalinfo, if present
			Set tInboundIP=pRequest.AdditionalInfo.GetAt("AuditRecord:InboundIP")
			If tInboundIP'="" {
				Set tPair=##class(HS.IHE.ATNA.Repository.CustomPair).%New()
				Set tPair.Name="AuditRecord:InboundIP"
				Set tPair.Value=tInboundIP
				Do tAggregate.CustomPairs.Insert(tPair)
			}
			Do pRequest.ContentStream.Rewind()
			Set tAggregate.ATNAMessage=pRequest.ContentStream.Read()
			Set tAggregate.ATNAMessageType="RFC3881"
			
			Set tSC= ##class(HS.IHE.ATNA.Repository.Aggregation).RecordAudit(tAggregate)
			Quit:$$$ISERR(tSC)
		    Set pAuditIndex=tAggregate
	    }
	} While 0
	
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// To convert an externally received audit message to our internal aggregation structure
ClassMethod ATNAToAggregation(pAuditMessage As AuditMessage, Output pAggregation As HS.IHE.ATNA.Repository.Aggregation)
{
	#dim tActPart As HS.IHE.ATNA.Repository.Data.ActiveParticipant
	#dim tPart As HS.IHE.ATNA.Repository.Data.ParticipantObjectIdentificationType
	#dim tEvent As HS.IHE.ATNA.Repository.Data.CodedValueType
	#dim tEventId As HS.IHE.ATNA.Repository.Data.CodedValueType
    Set pAggregation=##Class(HS.IHE.ATNA.Repository.Aggregation).%New()

    #; Event
    Set pAggregation.EventType=pAuditMessage.EventIdentification.EventID.code
    IF pAuditMessage.EventIdentification.EventID.displayName'="" Set pAggregation.EventType=pAuditMessage.EventIdentification.EventID.displayName
    IF pAuditMessage.EventIdentification.EventTypeCode.Count()>0 {
        //this should give us a more specific one
        Set tEvent=pAuditMessage.EventIdentification.EventTypeCode.GetAt(1)
        Set tEventId=pAuditMessage.EventIdentification.EventID
        Set pAggregation.EventInfo=tEvent.code_","_tEvent.codeSystemName_","_tEvent.displayName_"^"
        	_tEventId.code_","_tEventId.codeSystemName_","_tEventId.displayName
        If "ITI-44" = tEvent.code {
        	Set pAggregation.EventType = $Case(pAuditMessage.EventIdentification.EventActionCode
        		,"C":"PIXv3 Add"
        		,"U":"PIXv3 Update"
        		,"D":"PIXv3 Delete"
        		,:"Patient Identity Feed")
        } 
        Else {
	        Set tEv=tEvent.displayName
	        IF tEv'="" {
		        //to handle IHE's way of dealing with login failures
		        Set:tEv="Login"&&(pAuditMessage.EventIdentification.EventOutcomeIndicator'=0) tEv="LoginFailure"
		        Set pAggregation.EventType=tEv
	        }
        }
    }
    Set pAggregation.EventDateTime=pAuditMessage.EventIdentification.EventDateTime
    Set pAggregation.ActionCode=pAuditMessage.EventIdentification.EventActionCode
    Set pAggregation.Outcome=pAuditMessage.EventIdentification.EventOutcomeIndicator

	#; Audit Source
	If pAuditMessage.AuditSourceIdentification.Count() {
		Set pAggregation.InitiatedAt = pAuditMessage.AuditSourceIdentification.GetAt(1).AuditSourceID
		Set pAggregation.AuditSourceID=pAggregation.InitiatedAt
	}
    
    Set pAggregation.RecordedAt=$ZU(131,1)_":"_$ZNSPACE
    #; Participants
    Do ..Participants(pAuditMessage,.pAggregation)
}

/// Also called by the conversion to hscore 13
ClassMethod Participants(pAuditMessage As AuditMessage, ByRef pAggregation As HS.IHE.ATNA.Repository.Aggregation)
{
    #; Active Participants
    Set i=""
    For { Set tActPart = pAuditMessage.ActiveParticipant.GetNext(.i) Quit:i=""
    	If tActPart.RoleIDCode.Count() {
        	Set tRoleCode = tActPart.RoleIDCode.GetAt(1).displayName
       		If tRoleCode = "Application" {
	      	  Set pAggregation.Criteria = tActPart.UserID
    		}
        	ElseIf tRoleCode = "Source" {
	        	Set pAggregation.SourceURI = tActPart.UserID
	        	Set pAggregation.SourceNetworkAccess=tActPart.NetworkAccessPointID
	        	//for conversion
	        	If pAggregation.EnsembleSessionId'="",tActPart.AlternativeUserID=pAggregation.EnsembleSessionId Set pAggregation.IsSource=1
        	}
        	ElseIf tRoleCode = "Destination" {
	        	Set pAggregation.DestinationURI = tActPart.UserID
	        	Set pAggregation.DestinationNetworkAccess=tActPart.NetworkAccessPointID
	        	//for conversion
	        	If pAggregation.EnsembleSessionId'="",tActPart.AlternativeUserID=pAggregation.EnsembleSessionId Set pAggregation.IsSource=0
        	}
        	ElseIf pAggregation.UserName="" {
	        	//this will be skipped for conversion
	        	#; IHE "Human Requestor" or similar
		        Set pAggregation.UserName=tActPart.UserID
		        Set pAggregation.UserFullName=tActPart.UserName
			    Set tRoles=""
    			For tI=1:1:tActPart.RoleIDCode.Count() {
			        Set:tRoles'="" tRoles=tRoles_", "
			        Set tRoles=tRoles_tActPart.RoleIDCode.GetAt(tI).code
		        }
		        If tActPart.AlternativeUserID'=""{
			        Set:tRoles]"" tRoles=tRoles_", "
			        Set tRoles=tRoles_tActPart.AlternativeUserID
		        }
        Set pAggregation.Roles=tRoles
        // For backward compatibility (the IHE Human Requestor will not set this and thus not override the audit source)
        		Set:tActPart.NetworkAccessPointID]"" pAggregation.InitiatedAt=tActPart.NetworkAccessPointID
        	}
    	}
    }

	
	For tPartNo=1:1:pAuditMessage.ParticipantObjectIdentification.Count() {
        Set tPart=pAuditMessage.ParticipantObjectIdentification.GetAt(tPartNo)
        Set tPartType=tPart.ParticipantObjectIDTypeCode.code
        If (tPartType=1||(tPartType=2))&&(tPart.ParticipantObjectName'="") {
	        Set pAggregation.PatientName = tPart.ParticipantObjectName
        }
        If tPart.ParticipantObjectTypeCodeRole=24 {
	        //part that holds query parameters for various participant types
	        Set pAggregation.QueryRequestID=tPart.ParticipantObjectID
	        Set j=""
	        For {
		        Set tPair=tPart.ParticipantObjectDetail.GetNext(.j) Quit:j=""
		        Do pAggregation.AdditionalInfo.SetAt(tPair.value,tPair.type)
        	}
        } ElseIf tPartType=1 {  // medical record number
	        Set tID = tPart.ParticipantObjectID
	        If tID["^^^&",tID["&ISO" { // convert IHE ID
	        	Set tMRN = $P(tID,"^^^&",1)
	        	Set tAAOID = $P($P(tID,"^^^&",2),"&ISO",1)
	        	Set tAA = ##class(HS.Data.OIDMap).GetCodeForOID(tAAOID,tAAOID) //worst case, uses OID if not configured correctly
	        	Set tFac = ##class(HS.Data.OIDMap).GetCodeForOID(tAAOID)  //aa may or may not be a facility too, "" if not
	        	Set tID = tFac_"^"_tMRN_"^"_tAA  
	        }
	        Do pAggregation.AddPatient(tID,"MRN",tPart.ParticipantObjectName)
        } ElseIf tPartType=2 { // patient number (MPI ID)
        	Set tMPIID = $P(tPart.ParticipantObjectID,"^",1)
        	Set tMPIID = $P(tMPIID,"||",1) 
	        Do pAggregation.AddPatient(tMPIID,"MPIID",tPart.ParticipantObjectName)
        } ElseIf tPartType=9 { // XDSb Document
        	Set tDocId = tPart.ParticipantObjectID
        	If tDocId ] "" {
	        	Set (tRepo,tHome)=""
	        	Set j="" For { Set tPair=tPart.ParticipantObjectDetail.GetNext(.j) Quit:j=""
	        		If tPair.type = "Repository Unique Id" { Set tRepo = tPair.value }
	        		ElseIf tPair.type = "ihe:homeCommunityID" { Set tHome = tPair.value }
	        	}
	        	Do pAggregation.AddXDSbDocument(tDocId,tRepo,tHome)
		    }
        } ElseIf tPartType="99SupHPD-ISO21091" {
		    Set pAggregation.ProviderId=tPart.ParticipantObjectID
		    Set pAggregation.ProviderName=tPart.ParticipantObjectName
	    } ElseIf tPartType="urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd" {
		    Set pAggregation.SubmissionSetUniqueID=tPart.ParticipantObjectID
	    }
	    // Don't do this on conversion, if we already have it
        If pAggregation.%Id()=""||(pAggregation.Criteria=""),tPart.ParticipantObjectQuery'="" {
	        Set:pAggregation.Criteria'="" pAggregation.Criteria=pAggregation.Criteria_"; "
	        Set pAggregation.Criteria=$ZCVT(pAggregation.Criteria_tPart.ParticipantObjectQuery,"I","UTF8")
        }
    }
}

ClassMethod Test()
{
	Set tSC=$$$OK
FN	R !,"Enter File Name: ",tFileName Quit:tFileName=""  GoTo FN:tFileName["*"
	Set tFile=##Class(%File).%New(tFileName)
	Set tSC=tFile.Open("RU")
	If $$$ISERR(tSC) W !,tSC GoTo FN
	Set tString=tFile.Read()
	Set tMessage=##class(HS.Message.XMLMessage).%New()
	Do tMessage.ContentStream.Write(tString)
	Set tSC=..SaveRequest(tMessage,.tAuditIndex)
	Break
}

Storage Default
{
<Data name="ActiveParticipant">
<Attribute>ActiveParticipant</Attribute>
<Structure>subnode</Structure>
<Subscript>"ActiveParticipant"</Subscript>
</Data>
<Data name="AuditMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventIdentification</Value>
</Value>
</Data>
<Data name="AuditSourceIdentification">
<Attribute>AuditSourceIdentification</Attribute>
<Structure>subnode</Structure>
<Subscript>"AuditSourceIdentification"</Subscript>
</Data>
<Data name="ParticipantObjectIdentification">
<Attribute>ParticipantObjectIdentification</Attribute>
<Structure>subnode</Structure>
<Subscript>"ParticipantObjectIdentification"</Subscript>
</Data>
<DataLocation>^HS.IHE.Audit("AuditMessageD")</DataLocation>
<DefaultData>AuditMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.Audit("AuditMessageD")</IdLocation>
<IndexLocation>^HS.IHE.Audit("AuditMessageI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("AuditMessageS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

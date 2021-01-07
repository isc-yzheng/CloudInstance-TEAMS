/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsLib.EDI.ASTM.Service.Standard Extends (Ens.BusinessService, EnsLib.EDI.ServiceInterface) [ Abstract, ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS As %String = "EnsLib.EDI.ASTM.Document";

/// Configuration items to which to send Documents
Property TargetConfigNames As %String(MAXLEN = 1000);

/// Store a set of searchable properties associated with each ASTM document processed.<p>
/// These records will be stored in the named SearchTable class, if any.
Property SearchTableClass As %String [ InitialExpression = "EnsLib.EDI.ASTM.SearchTable" ];

/// Category to apply to incoming ASTM document type names to produce a complete DocType specification.<p>
/// Combines with the document type name to produce a DocType assignment.<p>
/// This setting may also contain multiple comma-separated type names followed by = and then a 
/// DocTypeCategory or full DocType value to apply to documents declared as that type.<p>
/// A trailing asterisk (*) at the end of a given partial type Name will match any types with that beginning part.<p/>
/// An example: DocSchemaCategory='E1394, Q=E1394_Custom, M-*=PVT' <br>
/// Note that a DocType assignment may be needed for Validation or SearchTableClass indexing.
Property DocSchemaCategory As %String(MAXLEN = 1000) [ InitialExpression = "E1394" ];

/// This is a 2-way interface; you can send outbound on it using a partner Business Operation. However if your target config item wishes to return an immediate response you can enable this by selecting ReplyMode='Application'.<br>
/// - Never : Do not send back any reply <br>
/// - Application : Wait for response from target config item and forward it back when it arrives
Property ReplyMode As %String(DISPLAYLIST = ",Never,Application", VALUELIST = ",Never,App") [ InitialExpression = "Never" ];

/// Colon-separated Local ID:Qualifier codes representing this (receiving) facility and application.<p>
/// These are used in constructing reply document headers.<p>
/// The '@' symbol represents using the corresponding field from the incoming message.<p>
/// If your ID must contain a literal @ symbol, escape it with backslash: '\@'
Property LocalApplicationID As %String(MAXLEN = 1000) [ InitialExpression = "ASTMService:ENS" ];

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SearchTableClass::selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.EDI.ASTM.Service.Standard},LocalApplicationID,ReplyMode,DocSchemaCategory:Basic:selector?context={Ens.ContextSearch/SchemaCategories?host=EnsLib.EDI.ASTM.Service.Standard}";

/// Comma-separated string specifying types of Validation to perform; make it a Setting in your subclass if you override OnValidate() and need to provide options
Property Validation As %String;

/// If SearchTableClass is set, use it to index any reply documents
Parameter IndexReplies As %Boolean = 0;

Property %Parser As EnsLib.EDI.ASTM.Parser;

Method OnInit() As %Status
{
	Set ..%Parser=##class(EnsLib.EDI.ASTM.Parser).%New($this)
	Set:""=..ReplyMode ..ReplyMode="Never"
	Quit $$$OK
}

/// Note: pDocIn is not declared as EnsLib.EDI.ASTM.Document so that subclasses can handle other types and transform them before calling ##super().
Method OnProcessInput(pDocIn As %RegisteredObject, Output pDocOut As %RegisteredObject) As %Status
{
	$$$ASSERT(0_"Subclass Responsibility")
}

/// Override this method to implement your own custom method for validating of an incoming Document
/// Return non-zero to prevent default validation of the message (if any);
Method OnValidate(pDoc As EnsLib.EDI.Document, pValSpec As %String, Output pStatus As %Status) As %Boolean
{
	Quit 0
}

/// Override this method to implement your own custom method for resolving the DocType of an incoming Message
/// Returning nonzero means you are overriding the framework's standard DocType resolution.
Method OnResolveDocType(pDoc As EnsLib.EDI.Document, ByRef pDocType As %String) As %Boolean
{
	Quit 0
}

Method standardOnProcessInput(pDocIn As EnsLib.EDI.ASTM.Document, Output pDocOut As EnsLib.EDI.ASTM.Document) As %Status
{
	Set tSC=$$$OK, pDocOut=$$$NULLOREF
	$$$ASSERT($$$IsdefObject(pDocIn) && pDocIn.%IsA("EnsLib.EDI.ASTM.Document"))
	$$$sysTRACE("Got Document "_pDocIn_" / "_pDocIn.%Id())
	#; get accepted doc, resolve DocType
	Set tSCVal=..resolveAndIndex(pDocIn)
	Set tResponse=$$$NULLOREF
	If $$$ISOK(tSC)&&$$$ISOK(tSCVal)&&(""'=..TargetConfigNames) {
		Set pDocIn.IsMutable=0
		If $Case(..ReplyMode,"Never":1,:0) {
			$$$SyncCommitSet(tSyncCommit)
			For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
				$$$sysTRACE("Sending ASTM document "_pDocIn_"/"_pDocIn.%Id()_" from "_pDocIn.Source_" to '"_tOneTarget_"'")
				Set tSC1=..SendRequestAsync(tOneTarget,pDocIn)
				Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			}
			$$$SyncCommitClear(tSyncCommit)
			If $$$ISOK(tSC) $$$sysTRACE("After async forwarding document "_pDocIn_"/"_pDocIn.%Id())
			If ..ReplyMode'="Never" {
				Set pDocOut=..reportReply(pDocIn,,.tSC)
			}
		} Else { ;  Application reply mode (either explicit or ISA-requested)
			If 1'=$L(..TargetConfigNames, ",") $$$LOGWARNING("More than one target config name specified for synchronous forwarding: "_..TargetConfigNames)
			$$$sysTRACE("Sending "_pDocIn_"/"_pDocIn.%Id()_" from "_pDocIn.Source_" to '"_..TargetConfigNames_"'")
			Set tSC=..SendRequestSync(..TargetConfigNames,pDocIn,.tResponse) Quit:$$$ISERR(tSC) tSC
			If '$IsObject(tResponse) { ; no reply message
				$$$sysTRACE("Not returning reply because SendRequestSync() of "_pDocIn_"/"_pDocIn.%Id()_" returned with no response object and status: "_$$$StatusDisplayString(tSC))
			} Else { 
				$$$sysTRACE("Returning reply document "_tResponse.%Id()_" ("_tResponse.Name_") received from document "_pDocIn.%Id()_" forwarded to "_..TargetConfigNames)
			}
		}
	} Else { ; not forwarding due to error or no target
		If $Case(..ReplyMode,"Never":0,:1) {
			If $$$ISOK(tSC)&&$$$ISOK(tSCVal) {
				$$$SyncCommitSet(tSyncCommit)
				Set pDocIn.IsMutable=0, tSC=pDocIn.%Save() ; save the document because we're going to reply to it.
				$$$SyncCommitClear(tSyncCommit)
				If $$$ISERR(tSC) {
					$$$LOGERROR("Failed to save document "_pDocIn_" / "_pDocIn.%Id()_" : "_$$$StatusDisplayString(tSC))
				}
			}
			$$$sysTRACE("Returning reply but not forwarding document "_pDocIn_"/"_pDocIn.%Id()_$S($$$ISERR(tSC):" status "_$$$StatusDisplayString(tSC),1:""))
			Set tSC=$$$ADDSC(tSC,tSCVal)
			Set pDocOut=..reportReply(pDocIn,,.tSC)
		} Else {
			$$$sysTRACE("Not returning reply for document "_pDocIn_"/"_pDocIn.%Id()_"; ReplyMode="_..ReplyMode_$S($$$ISERR(tSC):" status "_$$$StatusDisplayString(tSC),1:""))
		}
	}
	If $IsObject(tResponse) {
		Set pDocOut=..reportReply(pDocIn,tResponse,.tSC)
	}
	Quit tSC
}

Method getReplyCode(pMSH As EnsLib.EDI.ASTM.Segment, pSC As %Status, pSCVal As %Status, pAppACK As %Boolean) As %String
{
	If pAppACK>-1&&$IsObject(pMSH) { Set tAckType=pMSH.GetValueAt($S(pAppACK:16,1:15)), tVersionID=pMSH.GetValueAt("12.1") }
	Else { Set (tAckType,tVersionID)="" }
	#; Choose the appropriate Status character
	Set tCode=$S($$$ISERR(pSCVal):"R", $$$ISERR(pSC):"E", 1:"A") ; Reject / Error / Accept
	#; Send no ACK if the MSH requests not to
	Quit:pAppACK>-1&&$Case(..ReplyMode,"Never":1,"Immed":pAppACK,"App":'pAppACK,"Msh":$Case(tAckType,"NE":1,"ER":(tCode="A"),"SU":(tCode'="A"),:0),:0) ""
	Quit "C"_tCode ; Commit / Application
}

/// Accept only specified document names; resolve DocType and perform requested validation if any
Method resolveAndIndex(pDoc As EnsLib.EDI.Document) As %Status
{
	Set tDocType=..resolveDocType(pDoc)
	Do pDoc.PokeDocType(tDocType)

	#; Do further validation if required
	Set tSC=$$$OK
	If ""=..Validation||'..OnValidate(pDoc,..Validation,.tSC) {
		#; no default validation
	}
	Quit:$$$ISERR(tSC) tSC

	If ""'=..SearchTableClass {
		TRY {		
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",pDoc)
			If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for document "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
		} CATCH errobj { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' : "_errobj.AsSystemError()) }
	}
	Quit tSC
}

/// Return the DocType that this service will assign to this document
Method resolveDocType(pDoc As EnsLib.EDI.ASTM.Document, pMSH As EnsLib.EDI.ASTM.Segment = {$$$NULLOREF}) As %String
{
	Set tDocType=pDoc.DocType
	If ""=tDocType {
		#; Match with the DocType specified if any in DocSchemaCategory for the received Document's type name
		Set tAcceptTypes=..DocSchemaCategory, tNameFound=pDoc.Name, tUNameFound=$ZCVT(tNameFound,"U")
		Set nTypes=$S(""=$ZStrip(tAcceptTypes,"<>W"):0, 1:$L(tAcceptTypes,","))
		Set (tVal,tDef)=""
		For i=1:1:nTypes { Set tType=$P(tAcceptTypes,",",i) Continue:""=tType
			Set tVal=$ZStrip($P(tType,"=",2),"<>W")
			Set tName=$ZStrip($P(tType,"=",1),"<>W"), tNameLen=$L(tName), tUName=$ZCVT(tName,"U")
			If ""=tVal {
				Set:""=tDef tDef=tName
			} Else {
				#; Quit on match; accept trailing wildcard also
				If tUNameFound=tUName
				 || ("*"=$E(tName,tNameLen) && ($E(tUName,1,tNameLen-1)=$E(tUNameFound,1,tNameLen-1))) {
					If tVal[":" { Set tDocType=tVal }
					Else { Set tDocType=##class(EnsLib.EDI.ASTM.Schema).ResolveSchemaTypeToDocType(tVal,tNameFound) }
					Quit
				}
				Set tVal=""
			}
		}
		If ""'=tDocType {
			If tVal[":" {
				$$$sysTRACE("Using DocType='"_tDocType_"' for type name '"_tNameFound_"' matching '"_tUName_"' in DocSchemaCategory list; calling OnResolveDocType()")
			} Else {
				$$$sysTRACE("Using DocType='"_tDocType_"' from schema category '"_tVal_"' for type name '"_tNameFound_"' matching '"_tUName_"' in DocSchemaCategory list; calling OnResolveDocType()")
			}
		} ElseIf ""'=tDef {
			If tDef[":" {
				Set tDocType=tDef
				$$$sysTRACE("Using default DocType='"_tDocType_"' from DocSchemaCategory list '"_tAcceptTypes_"'; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
			} Else {
				Set tDocType=tDef_":"_tNameFound
				$$$sysTRACE("Using DocType='"_tDocType_"' from default schema category in DocSchemaCategory list '"_tAcceptTypes_"'; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
			}
		} Else {
			$$$sysTRACE("No match or default DocType found for type name '"_tNameFound_"' in DocSchemaCategory list '"_tAcceptTypes_"'; calling OnResolveDocType()")
		}
	} Else {
		$$$sysTRACE("Accepted document with DocType='"_tDocType_"'; calling OnResolveDocType()")
	}
	Set ttDocType=tDocType  If ..OnResolveDocType(pDoc,.ttDocType) {
		Set tDocType=$Get(ttDocType)
		$$$sysTRACE("OnResolveDocType returned DocType="_tDocType)
	}
	Quit tDocType
}

Method reportReply(pOriginalDoc As EnsLib.EDI.Document, pReplyCode As %String = "", ByRef pSC As %Status) As EnsLib.EDI.Document
{
	If $IsObject(pReplyCode) {
		Set tReplyDoc=pReplyCode, pSC=$$$OK
		$$$sysTRACE("Reporting reply document "_tReplyDoc_" for document "_pOriginalDoc_$S('$IsObject(pOriginalDoc):"",1:" / "_pOriginalDoc.%Id()))
	}
	If ""'=..SearchTableClass && $IsObject(tReplyDoc) && ..#IndexReplies {
		Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",tReplyDoc)
		If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for reply document "_tReplyDoc_" / "_tReplyDoc.%Id()_" with DocType='"_tReplyDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
	}
	Quit:""=tReplyDoc $$$NULLOREF
	Do ..SendReply(tReplyDoc, pOriginalDoc)
	Quit $$$NULLOREF ; default behavior is not to return the reply doc from OnProcessInput()
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit $$$EnsError($$$EnsErrGeneral, "Service does not support Reply; Document "_pReplyDocument)
}

/// Called by the Parser at the end of a document
Method OnDocumentEnd(pDocument As EnsLib.EDI.Document, pSource As %String, pStatus As %Status) As %Status
{
	Set tSC=$$$OK  Set:'$D(pStatus) pStatus=tSC
	Quit:..%PreserveSession>1 tSC ; don't let Service process the document; we're in ImportFrom...()
	If '..%PreserveSession { 
		#; We do not want to clean %SuperSession if set before %SessionId
		If '..%SuperSessionCreatedBeforeSession  Set ..%SuperSession = ""
		Set ..%SessionId=""  Kill $$$JobSessionId 
	}
	Set:"EnsLib.EDI.ASTM.Adapter.TCPAdapter"=..#ADAPTER pDocument.Source=..Adapter.OutQueueName_$C(13,10)_pDocument.Source
	Set tSC=..standardOnProcessInput(pDocument,.tDocOut)
	If $$$ISERR(tSC) && $$$StatusEquals(tSC,$$$EnsErrGeneral) Set pStatus=$$$ADDSC(pStatus,tSC) // !!! quit on fatal errors only
	Quit pStatus
}

ClassMethod GetRequestClassList() As %String [ CodeMode = objectgenerator, GenerateAfter = OnProcessInput ]
{
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"standardOnProcessInput",$$$cMETHformalspecparsed)
	Set tClass=$lg($lg(tSignature,1),2)
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"OnProcessInput",$$$cMETHformalspecparsed)
	Set tClass=tClass_""","""_$lg($lg(tSignature,1),2)
	Do %code.WriteLine(" Quit $lb("""_tClass_""")")
	Quit $$$OK
}

ClassMethod GetResponseClassList(pRequest As %String = "") As %String [ CodeMode = objectgenerator, GenerateAfter = OnProcessInput ]
{
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"standardOnProcessInput",$$$cMETHformalspecparsed)
	Set tRequest1=$lg($lg(tSignature,1),2)
	Set tClass1=$lg($lg(tSignature,2),2)
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"OnProcessInput",$$$cMETHformalspecparsed)
	Set tRequest2=$lg($lg(tSignature,1),2)
	Set tClass2=$lg($lg(tSignature,2),2)

	Set tClass12=tClass1_$S(tClass1=tClass2:"",1:""","""_tClass2)
	If tRequest1=tRequest2 {
		Set (tClass1,tClass2)=tClass12
	}
	Do %code.WriteLine(" Quit:pRequest="""" $lb("""_tClass12_""")")
	Do %code.WriteLine(" Quit:pRequest="""_tRequest1_""" $lb("""_tClass1_""")")
	Do %code.WriteLine(" Quit:pRequest="""_tRequest2_""" $lb("""_tClass2_""")")
	Do %code.WriteLine(" Quit $lb("""")")
	Quit $$$OK
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

/// Add discarded characters to IO Archive
Method IOLogDiscard(pSC As %Status, pNote As %String, pDiscard As %GlobalCharacterStream)
{
	Set tIOLogEntry = ..IOLogEntry, ..IOLogEntry=$$$NULLOREF ; Save a separate entry for the unexpected input
	$$$NEWINIOLOGENTRY(pSC,pNote,pDiscard)
	$$$CLOSEIOLOGENTRY($$$OK,"",$$$NULLOREF)
	Set ..IOLogEntry = tIOLogEntry
}

}

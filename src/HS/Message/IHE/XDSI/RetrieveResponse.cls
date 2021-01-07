Include (HS.HC, HS.IHE.XCAI)

Class HS.Message.IHE.XDSI.RetrieveResponse Extends (HS.Util.EnsRequest, HS.Message.XMLMessage) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Parameter XMLTYPE = "XDSI-RetrieveResponse";

/// Automatically calcuated based on calls to AddError, AddDocument, and AddAttachment
/// 
Property Status As %String(MAXLEN = 255);

/// List of response errors; do not insert directly, instead use AddError
/// 
Property Errors As HS.Types.IHE.Errors;

/// List of response documents; do not insert directly, install use AddDocument and AddAttachment
/// 
Property DocumentResponses As list Of HS.Message.IHE.XDSI.DocumentResponse;

/// Append error, cleanup description, ensure location, and update status
/// 
Method AddError(pError As HS.Types.IHE.Error)
{
	Set tDesc = pError.Description
	If tDesc[" [" Set tDesc = $P(tDesc," [",1)                ##; foo [tag+1^rou]
	If $E(tDesc,1,6)="ERROR " Set tDesc = $P(tDesc,": ",2,*)  ##; ERROR 5001: foo

	Set tLoc = pError.Location
	Set:tLoc="" tLoc = $$$HomeCommunityOID
	
	Do ..Errors.logError(pError.Code,pError.Severity,tDesc,tLoc)
	If pError.Severity = $$$XCAISeverityError Do ..UpdateStatus($$$XCAIStatusFailure)
}

/// Append document, move inline to attachment, and update status
/// 
Method AddDocument(pDocument As HS.Message.IHE.XDSI.DocumentResponse) As %Status
{
	$$$QuitOnError(..MoveInlineDocument(pDocument))
	$$$QuitOnError(..DocumentResponses.Insert(pDocument))
	Do ..UpdateStatus($$$XCAIStatusSuccess)
	Quit $$$OK
}

/// Append attachment, moves stream to temp file (does NOT update status)
/// 
Method AddAttachment(pAttach As HS.IHE.Common.Messages.MIMEAttachment) As %Status
{
	If pAttach.%Id()="",pAttach.Body.Size>0,pAttach.FilePath="" {
		$$$QuitOnError(pAttach.SaveBodyToFile(pAttach.Body))
		Do pAttach.Body.Clear()
	}
	$$$QuitOnError(..StreamCollection.Insert(pAttach))
	Quit $$$OK
}

/// Calculate the response status based on the given value and current value
/// 
Method UpdateStatus(pStatus As %String) [ Internal ]
{
	Set tOpposite = $S(pStatus=$$$XCAIStatusSuccess:$$$XCAIStatusFailure, 1:$$$XCAIStatusSuccess)
	If ..Status = tOpposite {
		Set ..Status = $$$XCAIStatusPartial
	}
	ElseIf ..Status="" {
		Set ..Status = pStatus
	}
}

/// Ensure status is set and at least one error message if not successful
/// 
Method FinalizeStatus()
{
	If ..Status="" Set ..Status = $$$XCAIStatusFailure
	If ..DocumentResponses=0 Set ..Status = $$$XCAIStatusFailure
	If ..Status'=$$$XCAIStatusSuccess,..Errors.Errors.Count()=0 {
		Do ..Errors.logError($$$XCAIError, $$$XCAISeverityError, "No documents found")
	}
}

/*
 * Move methods for normalizing response w/o affecting status/errors (e.g. operation response)
 */
/// Move any inline documents to attachments
/// 
Method MoveInlineDocuments() As %Status
{
	Set tSC = $$$OK
	Try {
		Set i="" For { Set tDoc = ..DocumentResponses.GetNext(.i) Quit:i=""
			$$$ThrowOnError(..MoveInlineDocument(tDoc))
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method MoveInlineDocument(pDocument As HS.Message.IHE.XDSI.DocumentResponse) As %Status
{
	#dim tAttach As HS.IHE.Common.Messages.MIMEAttachment

	If pDocument.XOP="" {
		Set tAttach = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
		Set tAttach.ContentId = ##class(HS.Util.XSLTHelper).createUUID()
		Set tAttach.ContentType = pDocument.MimeType
		$$$QuitOnError(tAttach.SaveBodyToFile(pDocument.Body))
		$$$QuitOnError(..StreamCollection.Insert(tAttach))	
		Set pDocument.XOP = tAttach.ContentId
	}
	Do pDocument.Body.Clear()
	Quit $$$OK
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSI.RetrieveResponse.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSI.RetrieveResponse.CustomAuditInfo"</Subscript>
</Data>
<Data name="RetrieveResponseDefaultData">
<Subscript>"RetrieveResponse"</Subscript>
<Value name="1">
<Value>Status</Value>
</Value>
<Value name="2">
<Value>DocType</Value>
</Value>
<Value name="3">
<Value>DocumentResponses</Value>
</Value>
<Value name="4">
<Value>ContentStream</Value>
</Value>
<Value name="5">
<Value>StreamCollection</Value>
</Value>
<Value name="6">
<Value>SOAPFault</Value>
</Value>
<Value name="7">
<Value>SAMLData</Value>
</Value>
<Value name="8">
<Value>Errors</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
</Data>
<DefaultData>RetrieveResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsLib.EDI.ASTM.Operation.Standard Extends Ens.BusinessOperation [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// String of separator characters to use in encoding outbound documents. Order is Field separator, Repeat separator, ComponentSeparator, Escape separator.<p>
/// Empty string means use the default values of the outbound document.
Property Separators As %String(MAXLEN = 4) [ InitialExpression = {$$$ASTMDefSeparators} ];

/// Store a set of searchable properties in SearchTable records associated with each document processed.<p>
/// These records will be of the named SearchTable class, if any.
Property SearchTableClass As %String(MAXLEN = 100);

Parameter SETTINGS = "Separators,SearchTableClass::selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.EDI.ASTM.Operation.Standard}";

/// Comma-separated string specifying types of Validation to perform; make it a Setting in your subclass if you override OnValidate() and need to provide options
Property Validation As %String;

/* override default value */
/// How long to keep retrying before giving up and returning an error code
Property FailureTimeout As %Numeric(MINVAL = -1) [ InitialExpression = -1 ];

/// If SearchTableClass is set, use it to index any replies (including ACKs unless IndexACKs=false)
Parameter IndexReplies As %Boolean = 0;

/// Override this method to implement your own custom method for validating of an incoming Document
Method OnValidate(pDoc As EnsLib.EDI.Document, pValSpec As %String, Output pStatus As %Status) As %Boolean
{
	Quit 0
}

Method validateAndIndex(pDoc As EnsLib.EDI.Document) As %Status
{
	If ""=..Validation||'$zobjmethod($this,"OnValidate",pDoc,..Validation,.tSC) { /* no default validation */ }
	Set:'$D(tSC) tSC=$$$OK
	If $$$ISERR(tSC) {
		Set ..SuspendMessage=1
		Do ..SendAlert(##Class(Ens.AlertRequest).%New($LB(..%ConfigName,"Suspended document "_pDoc.%Id()_" because it failed validation using spec '"_..Validation_"' with error "_$$$StatusDisplayString(tSC))))
		Quit tSC
	}
	If ""'=..SearchTableClass {
		TRY {		
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",pDoc)
			If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for document "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
		} CATCH errobj { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' : "_errobj.AsSystemError()) }
	}
	Quit $$$OK
}

}

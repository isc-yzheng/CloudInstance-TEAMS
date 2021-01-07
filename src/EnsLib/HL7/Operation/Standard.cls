/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

/// This is an abstract superclass for HL7 Operations that send an HL7 message
Class EnsLib.HL7.Operation.Standard Extends (Ens.BusinessOperation, EnsLib.HL7.Util.IOFraming) [ Abstract, ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

/// String of separator characters to use in encoding outbound messages. Order is FS, CS, RS, ESC, SS.<p>
/// Empty string means use the default values of the outbound message.<p>
/// Additional characters will be used to override the default output Segment Terminator which is Ascii 13.<p>
/// After position 5, '\r' means Ascii 13 (Carriage Return) and '\n' means Ascii 10 (Linefeed / Newline).<p>
/// You can also pad the separators up to position 5 with \x if you need to specify a line terminator but want
/// your output messages to show less than 5 separators. The separators designated by \x will not be written out.
Property Separators As %String(MAXLEN = 14) [ InitialExpression = {$$$HL7DefSeparators} ];

/// Store a set of searchable properties in SearchTable records associated with each message processed.<p>
/// These records will be of the named SearchTable class, if any.
Property SearchTableClass As %String(MAXLEN = 100);

Parameter SETTINGS = "Separators,SearchTableClass::selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.HL7.Operation.Standard},DefCharEncoding::selector?context={Ens.ContextSearch/CharacterSets}";

/* override default value */
/// How long to keep retrying before giving up and returning an error code
Property FailureTimeout As %Numeric(MINVAL = -1) [ InitialExpression = -1 ];

/// Comma-separated string specifying types of Validation to perform; make it a Setting in your subclass if you override OnValidate() and need to provide options
Property Validation As %String;

Method OnInit() As %Status
{
	#; parse and convert \x, \r, \n
	Set tSeps=..Separators, pos=2
	For { Set pos=$F(tSeps,"\",pos)  Quit:'pos  Set c=$E(tSeps,pos)
		Set tNew=$Case($ZCVT(c,"L")
						, "x":$E($C(17,18,19,20),pos-2)
						, "r":$E($C(17,18,19,20),pos-2,4)_$C(13)
						, "n":$E($C(17,18,19,20),pos-2,4)_$C(10)
						, :"\"_c)
		Set $E(tSeps,pos-1,pos)=tNew, pos=pos+$L(tNew)-1-("\"=$E(tNew,*)&&("\"'=tNew))
	}
	Set ..Separators=tSeps
	Quit $$$OK
}

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
		Do ..SendAlert(##Class(Ens.AlertRequest).%New($LB(..%ConfigName,"Suspended message "_pDoc.%Id()_" because it failed validation using spec '"_..Validation_"' with error "_$$$StatusDisplayString(tSC))))
		Quit tSC
	}
	If ""'=..SearchTableClass {
		TRY {		
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",pDoc)
			If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for message "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
		} CATCH errobj { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' : "_errobj.AsSystemError()) }
	}
	Quit $$$OK
}

}

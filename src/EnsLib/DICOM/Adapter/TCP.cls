/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsDICOM

IncludeGenerator EnsDICOM

/// This adapter is the principal means for DICOM peers to communicate with IRIS
Class EnsLib.DICOM.Adapter.TCP Extends EnsLib.TCP.DuplexAdapter [ System = 4 ]
{

/// Domain for $$$Text()
Parameter DOMAIN = "EnsDICOM";

/// Configurable settings
Parameter SETTINGS = "LocalAET,RemoteAET,TraceVerbosity,ARTIM,TXTIM";

Parameter SERVICEINPUTCLASS = "EnsLib.DICOM.Document";

Parameter SERVICEOUTPUTCLASS = "EnsLib.DICOM.Document";

// --------------------------------------------------------------------------------------------

// Properties influenced by Settings

// --------------------------------------------------------------------------------------------

/// This holds the Called Application Entity Title (AET) that remote DICOM peers should use to communicate with US.
/// When the adapter is in the role of Service Class Provider (SCP, server), it may contain the special wild card
/// value '*'. Wildcard values for both LocalAET and RemoteAET force the adapter to accept any combination of Local
/// and Remote AET provided a predefined AssociationContext exists which matches these values.
Property LocalAET As %String(MAXLEN = 16);

/// This holds the Calling Application Entity Title(s) of remote DICOM peers. When the adapter is in the role of Service
/// Class Provider (SCP, server) it should contain either a wildcard '*' or a comma delimited list of 'names' of the DICOM peers
/// which are allowed to connect. A name can either be a literal string or a pattern/substitution specification of the form
/// ?Pattern/Substitution. For the pattern/substitution form a calling AET is matches against the pattern,If there is a match
/// then the substitution is used for the purposes of association validation. Example ?1"B".E/JD-SCU would match any calling 
/// AET that starts with 'B' and substitutes JD-SCU. To accept ANY AET use ?.E for a pattern
/// When the adapter is in the role of Service Class User (SCU, client) it MUST contain the AET 
/// of the DICOM peer to which WE are connecting.
Property RemoteAET As %String(MAXLEN = "");

/// This holds the debug flag, set to 1 for terse debug information, 2 for verbose, 0 for none.
Property TraceVerbosity As %Integer [ InitialExpression = 0 ];

/// This holds the ARTIM (Association Request/Reject/Release Timeout). It may need to be adjusted upwards
/// if it is found that a peer takes a long time to respond to association requests
Property ARTIM As %Integer [ InitialExpression = 5, Internal, Private ];

/// This holds the TXTIM (Data Transfer Timeout). It may need to be adjusted upwards
/// if it is found that a peer takes a long time to respond during data transfer
Property TXTIM As %Integer [ InitialExpression = 5, Internal, Private ];

/// This holds the Role. If this adapter is associatied with a DuplexService then the role is 
/// ServiceClassProvider (SCP, server) otherwise the role is ServiceClassUser (SCU, client)
Property Role As %Integer;

// --------------------------------------------------------------------------------------------

// Public Properties

// --------------------------------------------------------------------------------------------

/// This holds the association identifier. Each established association has its own unique value.
Property AssociationId As %String;

/// This holds the context id. For each message exchanged within an association the context id
/// indicates the index of the Presentation Context that should be used.
Property ContextId As %Integer;

// --------------------------------------------------------------------------------------------

// Private Properties

// --------------------------------------------------------------------------------------------

/// This holds the 'reason' code. Its value alters depending upon the PDU type and the 'Source' property. This is
/// reported to the DICOM peer when certain messages are issued by this process. It gives the peer some idea of
/// the reason for the current action
Property AbortReason As %Integer [ Internal, Private ];

/// This holds the 'source' code. Its value alters depending upon the Role. This is reported to the DICOM peer
/// when certain messages are issued by this process. It gives the peer some idea of the source of the current 
/// action.
Property AbortSource As %Integer [ Internal, Private ];

/// This holds the 'Any Presentation Context Acceptable' flag
Property AnyPCAcceptable As %Boolean [ Internal, Private ];

/// This holds the association is established flag
Property AssociationIsEstablished As %Boolean [ Calculated, Internal, Private, ReadOnly ];

/// This holds the incoming Document
Property InboundDocument As EnsLib.DICOM.Document;

/// This holds the maximum PDU (Protocol Data Unit )length for data to be exchanged with a DICOM peer 
/// It is derived from the user information during the association negotiation
Property MaxPDULen As %Integer [ InitialExpression = {$$$ALIGNEDCHUNKLEN}, Internal ];

/// This holds the outgoing message id counter. 
Property MessageId As %Integer;

/// This holds the next state to switch to
Property NextState As %String [ InitialExpression = {$$$NOSTATE} ];

/// This holds the current state of the FSM, Initial state is "{NOSTATE}"
/// Before the machine can run a valid state needs to be established
Property State As %String [ InitialExpression = {$$$NOSTATE}, Internal ];

/// This holds the status of the most recent error encountered during processing
Property Status As %Status [ InitialExpression = {$$$OK}, Internal, Private ];

/// This holds the incoming CommandSet stream
Property WireStream As %GlobalBinaryStream [ Internal, Private ];

/// This holds the current stream, it either points at the WireStream or the Incoming documents FileStream
Property CurrentStream [ Internal, Private ];

/// This holds the current calling AET
Property CallingAET As %String [ Internal, Private ];

/// This holds the current called AET
Property CalledAET As %String [ Internal, Private ];

/// This holds the (overriden) transfer syntax
Property TransferSyntax As %String(MAXLEN = "");

/// This holds the ORIGINAL value of the calling AET, prior to any transformation
Property OriginalCallingAET As %String [ Internal, Private ];

// --------------------------------------------------------------------------------------------

// Property Accessors

// --------------------------------------------------------------------------------------------

/// Accessor for AbortReason 
Method AbortReasonGet() As %Integer
{
    If i%AbortReason="" Quit $$$ABORTREASONNOTSPECIFIED
    Quit i%AbortReason
}

/// Accessor for AbortSource
Method AbortSourceGet() As %Integer
{
    If i%AbortSource="" {
        Quit $Case(..Role,$$$SERVICECLASSPROVIDER:$$$ABORTSOURCESERVICEPROVIDER,:$$$ABORTSOURCESERVICEUSER)
    }
    Quit i%AbortReason
}

/// Accessor for AssociationIsEstablished
Method AssociationIsEstablishedGet() As %Boolean [ CodeMode = expression ]
{
(..AssociationId'="")
}

/// Accessor for Role 
Method RoleGet() As %Integer [ CodeMode = expression ]
{
$Case(..IPAddress,"":$$$SERVICECLASSPROVIDER,:$$$SERVICECLASSUSER)
}

// --------------------------------------------------------------------------------------------

// Private implementation 

// --------------------------------------------------------------------------------------------

/// Accept a Protocol Data Unit from the peer
Method AcceptPDU(Output pBytes As %String, pTimeout) As %Status [ Internal, Private ]
{
    
    #dim tSC As %Status = $$$OK
    
    #dim tHdr,tPDU As %String
    #dim tIO As %String = $IO
    
    try {
    
        #; Read the packet header
        Use ..IPDevice Read tHdr#6:pTimeout Else  Set tSC=$$$EnsError($$$EnsDICOMTimedOutWaitingForResponseFromPeer,..State) Quit

        #; Read the PDU
        Read tPDU#$$$BEUINT32($Extract(tHdr,3,6)):pTimeout Else   Set tSC=$$$EnsError($$$EnsDICOMTimedOutWaitingForResponseFromPeer,..State) Quit
    
        #; Concat
        Set pBytes=tHdr_tPDU
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Use tIO

    Quit tSC
}

/// Compose a 'Bad Length' reason. Used in mesage validation. Set the Reason property and form an appropriate error message.
Method BADLEN(pType As %Integer, pItem As %String, pExpectedValue As %String, pReceivedValue As %String) As %Status [ Internal, Private ]
{
    Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONINVALIDPDUPARAMETERVALUE)
    Quit $$$EnsError($$$EnsDICOMPDUBadLength,..PDU2EYE(pType),pItem,pExpectedValue,pReceivedValue)
}

/// Compose a 'Bad Value' reason. Used in message validation. Set the Reason property and form an appropriate error message
Method BADVAL(pType As %Integer, pItem As %String, pExpectedValue As %String, pReceivedValue As %String) As %Status [ Internal, Private ]
{
    Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONINVALIDPDUPARAMETERVALUE)
    Quit $$$EnsError($$$EnsDICOMPDUBadValue,..PDU2EYE(pType),pItem,pExpectedValue,pReceivedValue)
}

/// Compose an Associate Abort Item, the source and reason are inserted into the item
Method ComposeAABORT(pSource As %Integer, pReason As %Integer) As %String [ Internal, Private ]
{
    #; PDU type, reserved, length, filler, source, reason
    Quit ($$$2BEUINT8($$$AABORT)_$Char($$$FILLER)_$$$2BEUINT32(4)_$Char($$$FILLER,$$$FILLER)_$$$2BEUINT8(pSource)_$$$2BEUINT8(pReason))
}

/// Compose an Associate Accept Item. This is used to indicate to the external communicating entity the acceptability
/// of the proposed association. The presentation content items ( there may be many ), indicate the acceptability of the
/// proposed abstract syntaxes and also specify the Transfer Syntax that MUST be used.
Method ComposeAASSOCIATEAC(ByRef pDataToInsert As %String, Output pBytes As %String) As %Status [ Internal, Private ]
{
    Quit ..ComposeAssociationContext($$$AASSOCIATEAC,.pDataToInsert,.pBytes)
}

/// Compose an Associate Request Item. This is used to indicate to an external communicating entity that this process
/// wishes to connect. The presentation content items ( there may be many ), indicate this peers request for
/// proposed abstract syntaxes and also specify the Transfer Syntax that MAY be used.
Method ComposeAASSOCIATERQ(ByRef pDataToInsert As %String, Output pBytes As %String) As %Status [ Internal, Private ]
{
    Quit ..ComposeAssociationContext($$$AASSOCIATERQ,.pDataToInsert,.pBytes)
}

/// Compose an Associate Reject Item. This is used to indicate to the external communicating entity that the
/// Association request has been rejected. Source and Reason are supplied.
Method ComposeAASSOCIATERJ(pSource, pReason) As %String [ Internal, Private ]
{
    #; PDU type, reserved, length, filler, result (1 = rejected-permanent), source, reason
    Quit $Char($$$AASSOCIATERJ,$$$FILLER)_$$$2BEUINT32(4)_$Char($$$FILLER,1)_$$$2BEUINT8(pSource)_$$$2BEUINT8(pReason)
}

/// Compose a Presentation Data PDU. The stream contains the data bytes. The last flag indicates that this is the last PDU
/// of the message
Method ComposePDATATF(pByteStream As %Stream.TmpBinary, Output pPDU As %String, Output pLast As %Boolean) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tLen As %Integer
    #dim tBytes As %String
    
    try {
        
        #; There are 6 bytes overhead per PDU
        Set tLen=..MaxPDULen-6
        
        #; Read from the stream
        Set tBytes=pByteStream.Read(.tLen,.tSC) If $$$ISERR(tSC) Quit
        
        #; Set the last flag
        If pByteStream.AtEnd() Set pLast=1
         
        #; Build the pdu
        Set pPDU=$Char($$$PDATATF,$$$FILLER)_$$$2BEUINT32(tLen)_tBytes
         
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Compose an AssocationContext
Method ComposeAssociationContext(pAssociationType As %Integer, ByRef pDataToInsert As %String, Output pBytes As %String)
{
    #dim tSC As %Status = $$$OK
    
    #dim tBytes,tDataToInsert As %String
    #dim tPCIndex,tPCType As %Integer 
    
    try {
        
        #; Start with Protocol Header
        Set pBytes=$$$2BEUINT16(pDataToInsert($$$ASSOCIATIONCONTEXT,"Protocol-version"))_$Char($$$FILLER,$$$FILLER)_$$$PAD2LEN(pDataToInsert($$$ASSOCIATIONCONTEXT,"Called-AE-title"),16," ")_$$$PAD2LEN(pDataToInsert($$$ASSOCIATIONCONTEXT,"Calling-AE-title"),16," ")_$$$PAD2LEN("",32,$Char($$$FILLER))
        
        #; Add the Application context
        Set pBytes=pBytes_..ComposeApplicationContext()
        
        #; For each proposed presentation context
        Set tPCIndex="" For {
                
            Set tPCIndex=$Order(pDataToInsert($$$PRESENTATIONCONTEXT,tPCIndex)) If tPCIndex="" Quit
            
            #; Select the individual Presentation context subtree
            Kill tDataToInsert Merge tDataToInsert=pDataToInsert($$$PRESENTATIONCONTEXT,tPCIndex)
            
            #; Determine the PresentationContext type from the association type
            Set tPCType=$Case(pAssociationType,$$$AASSOCIATERQ:$$$PRESENTATIONCONTEXT,:$$$PRESENTATIONCONTEXTREPLY)
        
            #; Compose the individual presentation context
            Set tSC=..ComposePresentationContext(tPCType,.tDataToInsert,.tBytes) If $$$ISERR(tSC) Quit
            Set pBytes=pBytes_tBytes,tBytes=""
        }
        
        #; Add the User information
        Set pBytes=pBytes_..ComposeUserInformation()
        
        #; Finally, add PDU type, filler, PDU length
        Set pBytes=$Char(pAssociationType,$$$FILLER)_$$$2BEUINT32($Length(pBytes))_pBytes
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Compose the 'fixed' ApplicationContext item. We can use a generator here because the values never change
Method ComposeApplicationContext() As %String [ CodeMode = objectgenerator, Internal, Private ]
{
    #dim tBytes,tCode As %String
    #dim tIndex As %Integer
    Set tBytes=$Char($$$APPLICATIONCONTEXT,0)_$$$2BEUINT16($Length($$$DICOMAPPLICATIONCONTEXTUID))_$$$DICOMAPPLICATIONCONTEXTUID
    Set tCode=" Quit $Char(" For tIndex=1:1:$Length(tBytes) Set tCode=tCode_$Ascii(tBytes,tIndex)_","
    Set $Extract(tCode,$Length(tCode))=")"
    Do %code.WriteLine(tCode)
}

/// Compose a PresentationContext request Item
Method ComposePresentationContext(pContextType As %Integer, ByRef pDataToInsert As %String, Output pBytes As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tBytes,tDataToInsert As %String
    
    try {
            
        #; Presentation context id, reserved, result/reason, reserved
        Set pBytes=$Char(pDataToInsert("id"),$$$FILLER,pDataToInsert("result"),$$$FILLER)
        
        #; Only add the abstract syntax for requests, not replies
        If (pContextType=$$$PRESENTATIONCONTEXT) {
            
            #; Abstract syntax
            Kill tDataToInsert Merge tDataToInsert=pDataToInsert($$$ABSTRACTSYNTAX)
            Set tSC=..ComposeAbstractSyntax(.tDataToInsert,.tBytes) If $$$ISERR(tSC) Quit
            Set pBytes=pBytes_tBytes
        }
        
        #; Transfer syntax
        Kill tDataToInsert Merge tDataToInsert=pDataToInsert($$$TRANSFERSYNTAX)
        Set tSC=..ComposeTransferSyntax(.tDataToInsert,.tBytes) If $$$ISERR(tSC) Quit
        Set pBytes=pBytes_tBytes
        
        #; Item type,item length
        Set pBytes=$Char(pContextType,$$$FILLER)_$$$2BEUINT16($Length(pBytes))_pBytes
    
    } catch {
        
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Compose AbstractSyntax Item(s)
Method ComposeAbstractSyntax(ByRef pDataToInsert As %String, Output pBytes As %String) As %Status [ Internal, Private ]
{
    #dim tAbstractSyntax As %String
    #dim tASIndex As %Integer
    #dim tSC As %Status = $$$OK
    Set (pBytes,tASIndex)="" For {
        Set tASIndex=$Order(pDataToInsert(tASIndex)) If tASIndex="" Quit
        Set tAbstractSyntax=pDataToInsert(tASIndex,"name")
        Set pBytes=pBytes_$Char($$$ABSTRACTSYNTAX,$$$FILLER)_$$$2BEUINT16($Length(tAbstractSyntax))_tAbstractSyntax
    }
    Quit tSC
}

/// Compose TransferSyntax Item(s)
Method ComposeTransferSyntax(ByRef pDataToInsert As %String, Output pBytes As %String) As %Status [ Internal, Private ]
{
    #dim tTransferSyntax As %String
    #dim tTSIndex As %Integer
    #dim tSC As %Status = $$$OK
    Set (pBytes,tTSIndex)="" For {
        Set tTSIndex=$Order(pDataToInsert(tTSIndex)) If tTSIndex="" Quit    
        Set tTransferSyntax=pDataToInsert(tTSIndex,"name")
        Set pBytes=pBytes_$Char($$$TRANSFERSYNTAX,$$$FILLER)_$$$2BEUINT16($Length(tTransferSyntax))_tTransferSyntax
    }
    If (pBytes="") {
	    Set pBytes=$Char($$$TRANSFERSYNTAX,$$$FILLER)_$$$2BEUINT16(0)
    }
    Quit tSC
}

/// Compose the UserInformation Item
Method ComposeUserInformation() As %String [ Internal ]
{
    #dim tUserItems As %String
    Set tUserItems=
        $Char($$$USERLEN,$$$FILLER)_$$$2BEUINT16(4)_$$$2BEUINT32(..MaxPDULen)_
        $Char($$$USERIMP,$$$FILLER)_$$$2BEUINT16($Length($$$OURUSERIMPLEMENTATIONCLASSUID))_$$$OURUSERIMPLEMENTATIONCLASSUID_
        $Char($$$USERVER,$$$FILLER)_$$$2BEUINT16($Length($$$OURUSERVERSION))_$$$OURUSERVERSION
    
    Quit $Char($$$USERINFORMATION,$$$FILLER)_$$$2BEUINT16($Length(tUserItems))_tUserItems
}

Method CreateAssociation(ByRef pREQUEST As %String, ByRef pACCEPT) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tCallingAET,tCalledAET As %String
    
    try {
        
        Set tCallingAET=pREQUEST($$$ASSOCIATIONCONTEXT,"Calling-AE-title"),tCalledAET=pREQUEST($$$ASSOCIATIONCONTEXT,"Called-AE-title")
        
        #; Association is established, create new AssociationId
        Set ..AssociationId=$System.Util.CreateGUID()
        
        Merge $$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"RQ")=pREQUEST
        Merge $$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"AC")=pACCEPT
        
        #; Add an index on the association
        Set $$$EnsRuntimeAppData($$$AdapterName,"i",tCallingAET,tCalledAET,..AssociationId)=""
        
        #; Initialize the message id
        Set ..MessageId=-1
    
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// Decompose an Associate Accept
Method DecomposeAASSOCIATEAC(pType As %Integer, ByRef pBytes As %String, ByRef pExtractedData As %String) [ Internal, Private ]
{
    Quit ..DecomposeAssociationContext(pType,.pBytes,.pExtractedData)
}

/// Decompose an Associate Request
Method DecomposeAASSOCIATERQ(pType As %Integer, ByRef pBytes As %String, ByRef pExtractedData As %String) [ Internal, Private ]
{
    Quit ..DecomposeAssociationContext(pType,.pBytes,.pExtractedData)
}

/// Decompose an Associate Reject
Method DecomposeAASSOCIATERJ(ByRef pBytes As %String, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tItemLength As %Integer
    #dim tItemData As %String
    
    try {
        #; Validate PDU length
        Set tItemLength=$$$BEUINT32($Extract(pBytes,3,6))
        If tItemLength>4 {
            Set tSC=..BADLEN($$$AASSOCIATERJ,"PDU-Length","4",tItemLength) Quit
        }
        
        #; Validate Result
        Set tItemData=$$$BEUINT8($Extract(pBytes,8))
        If (tItemData'=1)&&(tItemData'=2)
        {
            Set tSC=..BADVAL($$$AASSOCIATERJ,"Result",$$$Text("1 or 2"),tItemData) Quit
        } 
        Set pExtractedData("Result")=tItemData
        
        #; Validate Source
        Set tItemData=$$$BEUINT8($Extract(pBytes,9))
        If (tItemData'=1)&&(tItemData'=2)&&(tItemData'=3)
        {
            Set tSC=..BADVAL($$$AASSOCIATERJ,"Source",$$$Text("1, 2 or 3"),tItemData) Quit
        } 
        Set pExtractedData("Source")=tItemData
        
        #; Validate Reason
        Set tItemData=$$$BEUINT8($Extract(pBytes,10))
        If (tItemData'=1)&&(tItemData'=2)&&(tItemData'=3)&&(tItemData'=7)
        {
            Set tSC=..BADVAL($$$AASSOCIATERJ,"Reason",$$$Text("1, 2, 3 or 7"),tItemData) Quit
        } 
        Set pExtractedData("Reason")=tItemData
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// Decompose a Data Packet
Method DecomposePDATATF(ByRef pBytes As %String, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    Set pExtractedData("VariableField")=$Extract(pBytes,7,7+$$$BEUINT32($Extract(pBytes,3,6)))
    Quit $$$OK
}

/// Decompose an Abort
Method DecomposeAABORT(ByRef pBytes As %String, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim tItemLength As %Integer
    #dim tItemData As %String
    
    try {
        #; Validate PDU length
        Set tItemLength=$$$BEUINT32($Extract(pBytes,3,6))
        If tItemLength>4 {
            Set tSC=..BADLEN($$$AABORT,"PDU-Length","4",tItemLength) Quit
        }
        
        #; Validate Source
        Set tItemData=$$$BEUINT8($Extract(pBytes,9))
        If (tItemData'=0)&&(tItemData'=1)&&(tItemData'=2)
        {
            Set tSC=..BADVAL($$$AABORT,"Source","0, 1 or 2",tItemData) Quit
        } 
        Set pExtractedData("Source")=tItemData
                    
        #; Validate Reason
        Set tItemData=$$$BEUINT8($Extract(pBytes,10))
        If (tItemData'=0)&&(tItemData'=1)&&(tItemData'=2)&&(tItemData'=4)&&(tItemData'=5)&&(tItemData'=6)
        {
            Set tSC=..BADVAL($$$AABORT,"Reason",$$$Text("0, 1, 2, 4, 5, 6 or 7"),tItemData) Quit
        } 
        Set pExtractedData("Reason")=tItemData
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Decompose a PDU
Method DecomposePDU(ByRef pBytes As %String, Output pType As %Integer, Output pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status
    
    #; Validate the PDU type
    Set pType=$$$BEUINT8($Extract(pBytes))
    
    If (pType=$$$AASSOCIATEAC) {
        Set tSC=..DecomposeAASSOCIATEAC(pType,.pBytes,.pExtractedData)
    } elseif pType=$$$AASSOCIATERQ {
        Set tSC=..DecomposeAASSOCIATERQ(pType,.pBytes,.pExtractedData)
    } elseif pType=$$$AASSOCIATERJ {
        Set tSC=..DecomposeAASSOCIATERJ(.pBytes,.pExtractedData)
    } elseif pType=$$$PDATATF {
        Set tSC=..DecomposePDATATF(.pBytes,.pExtractedData)
    } elseif (pType=$$$ARELEASERQ) {
        Set tSC=$$$OK // Doesn't require decomposition
    } elseif (pType=$$$ARELEASERP) {
        Set tSC=$$$OK // Doesn't require decomposition
    } elseif pType=$$$AABORT {
        Set tSC=..DecomposeAABORT(.pBytes,.pExtractedData)
    } else {
        Set tSC=$$$EnsError($$$EnsDICOMUnrecognizedPDU,..PDU2EYE(pType))
    }
    
    Quit tSC
}

/// Decompose an Association Context
Method DecomposeAssociationContext(pType As %Integer, ByRef pBytes As %String, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tItemData As %String
    #dim tItemType,tItemLength,tAppContextCount,tPresContextCount,tUserInfoCount,tOffset,tLimit As %Integer

    try {
        Set tItemLength=$$$BEUINT32($Extract(pBytes,3,6))-68,tOffset=0
        
        #; Validate the Protocol-version
        Set tItemData=$$$BEUINT16($Extract(pBytes,7,8))
        If tItemData'=1 Set tSC=..BADVAL(pType,"Protocol-version","0x01",$ZHex(tItemData)) Quit
        Set pExtractedData($$$ASSOCIATIONCONTEXT,"Protocol-version")=tItemData
        
        #; Validate Called-AE-title
        Set tItemData=$ZStrip($Extract(pBytes,11,26),"<>WC")
        If tItemData="" Set tSC=..BADVAL(pType,"Called-AE-title",$$$Text("Non-empty string"),$$$Text("empty string")) Quit
        Set pExtractedData($$$ASSOCIATIONCONTEXT,"Called-AE-title")=tItemData
        
        #; Validate Calling-AE-Title
        Set tItemData=$ZStrip($Extract(pBytes,27,42),"<>WC")
        If tItemData="" Set tSC=..BADVAL(pType,"Calling-AE-title",$$$Text("Non-empty string"),$$$Text("empty string")) Quit
        Set pExtractedData($$$ASSOCIATIONCONTEXT,"Calling-AE-title")=tItemData
        
        #; Initialize counters
        Set (tAppContextCount,tPresContextCount,tUserInfoCount)=0
        
        #; Update the offset, thats the fixed header and the variable length
        Set tOffset=tOffset+74,tLimit=tOffset+tItemLength
        
        for  {
            
            #; Ran out of data
            If tOffset>=tLimit Quit
            
            #; Validate the Item type
            Set tItemType=$$$BEUINT8($Extract(pBytes,tOffset+1))
            If tItemType=$$$APPLICATIONCONTEXT {
                
                Set tAppContextCount=tAppContextCount+1
                
                #; Only 1 instance of an Application context item allowed
                If tAppContextCount>1 Set tSC=$$$EnsError($$$EnsDICOMMaxApplicationContextCountExceeded) Quit
                
                #; Process the application context item
                Set tSC=..DecomposeApplicationContext(pType,.pBytes,.tOffset,.pExtractedData)
                If $$$ISERR(tSC) Quit
                
                
            } elseif tItemType=$$$PRESENTATIONCONTEXT {
                
                Set tPresContextCount=tPresContextCount+1
                
                #; Process the presentation context item
                Set tSC=..DecomposePresentationContext(tPresContextCount,pType,.pBytes,.tOffset,.pExtractedData)
                If $$$ISERR(tSC) Quit
                
            } elseif tItemType=$$$PRESENTATIONCONTEXTREPLY {
                
                Set tPresContextCount=tPresContextCount+1
                
                #; Process the presentation context item
                Set tSC=..DecomposePresentationContext(tPresContextCount,pType,.pBytes,.tOffset,.pExtractedData)
                If $$$ISERR(tSC) Quit
                
        
            } elseif tItemType=$$$USERINFORMATION {
                
                Set tUserInfoCount=tUserInfoCount+1
                
                #; Only 1 instance of an UserInformation item allowed
                If tUserInfoCount>1 Set tSC=$$$EnsError($$$EnsDICOMMaxUserInfoItemsExceeded) Quit
        
                #; Process the user information item
                Set tSC=..DecomposeUserInformation(pType,.pBytes,.tOffset,.pExtractedData)
                If $$$ISERR(tSC) Quit
                
            } else {
                Set tSC=$$$EnsError($$$EnsDICOMUnexpectedItem,$ZHex(tItemType)) Quit
            }
        }
        If $$$ISERR(tSC) Quit
        
        If '((tAppContextCount=1)&&(tPresContextCount>=1)&&(tUserInfoCount=1)) {
            Set tSC=$$$EnsError($$$EnsDICOMMessageIncomplete,..PDU2EYE(pType)) Quit
        }
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Decompose an Application Context Item
Method DecomposeApplicationContext(pType As %Integer, ByRef pBytes As %String, ByRef pOffset As %Integer, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tItemLength,tInstanceCount As %Integer
    #dim tItemData As %String
    
    try {
        #; Pick out the item length,data and adjust the offset
        Set tItemLength=$$$BEUINT16($Extract(pBytes,pOffset+3,pOffset+4))
        If (tItemLength>64)||(tItemLength<=0) {
            Set tSC=..BADLEN(pType,"Application-context-name",">=0,<=64",tItemLength) Quit
        }
        
        #; Pick out the item data, this is the Application-context-name
        Set tItemData=$Extract(pBytes,pOffset+5,pOffset+5+tItemLength-1)
        
        Set tInstanceCount=$Increment(pExtractedData($$$APPLICATIONCONTEXT))
        Set pExtractedData($$$APPLICATIONCONTEXT,tInstanceCount,"name")=tItemData
        
        #; Update the offset, thats the fixed header and the variable length
        Set pOffset=pOffset+4+tItemLength
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// This method accepts the presentation data value item and decomposes it into command and/or data set fragments of the message.
Method DecomposePDVItem(pBytes As %String, pOffset As %Integer, pLimit As %Integer, Output pLast As %Boolean) As %Status [ Internal ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tMsgCtrlHeader,tType As %Integer
    #dim tTransferSyntax,tStorageLocation As %String
    #dim tDataSetType As Integer

    try {
    
        #; The Presentation Data Value Item contains DICOM message information
        Set tMsgCtrlHeader=$$$BEUINT8($Extract(pBytes,pOffset))
        
        #; Type is first bit (command or dataset)
        Set tType=$Case(''$Zboolean(tMsgCtrlHeader,1,1),1:$$$PDVCOMMAND,0:$$$PDVDATASET)
        
        #; Last fragment indicator is second bit
        Set pLast=''$Zboolean(tMsgCtrlHeader,2,1)
        
        #; Write the data to the stream
        Set tSC=..CurrentStream.Write($Extract(pBytes,pOffset+1,pLimit)) 
        If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
            
        #; If this is the last fragment
        If pLast=1 {
            
            #; ? CommandSet or DataSet
            If tType=$$$PDVCOMMAND {
                
                #; Initialize the command set ( ALWAYS implicit vr little endian)
                Set tSC=..InboundDocument.InitializeCommandSet(..CurrentStream) If $$$ISERR(tSC) Quit
            
                #; If there is a data set present, reset the last flag
                If ..InboundDocument.CommandSet.GetValueAt("(0000,0800)",,.tSC)'=$$$NODATASETPRESENT Set pLast=0
                If $$$ISERR(tSC) Quit
                
                If pLast=0 {
                    
                    #; There IS a dataset, switch the CurrentStream to point to the inbound documentents FileStream
                    #; This is a violation of encapsulation but in a well understood and controlled manner
                    Set ..CurrentStream=..InboundDocument.FixedDataSet.FileStream
                
                    #; Also update the transfer syntax of the persistent data set
                    Set ..InboundDocument.FixedDataSet.TransferSyntax=..GetCurrentTransferSyntax(..ContextId)
                    
                } else {
                    
                    #; All done, save the document
                    Set tSC=..InboundDocument.%Save() 
                    If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
                }   
                
            } else {
            
                #; All done, save the document
                Set tSC=..InboundDocument.%Save()
                If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
            }
        }
            
    } catch {
        Set tSC=$$$EnsSystemError
    }
        
    Quit tSC
}

/// Decompose an Presentation Context Item
Method DecomposePresentationContext(pPCIndex As %Integer, pType As %Integer, ByRef pBytes As %String, ByRef pOffset As %Integer, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tItemType,tItemLength,tID,tAbstractSyntaxCount,tTransferSyntaxCount,tLimit As %Integer
    #dim tItemData,tExtractedData As %String
    
    try {
        #; Pick out the item length
        Set tItemLength=$$$BEUINT16($Extract(pBytes,pOffset+3,pOffset+4))-4
        
        #; Get the 'Presentation-context-id"
        Set tItemData=$$$BEUINT8($Extract(pBytes,pOffset+5))
        If tItemData#2'=1 {
            Set tSC=..BADVAL(pType,"Presentation-context-id",$$$Text("Odd integer between 1 and 255"),tItemData) Quit
        }
        
        Set tID=tItemData,pExtractedData($$$PRESENTATIONCONTEXT,tID,"id")=tID
        
        If pType=$$$AASSOCIATEAC {
            
            #; Get the 'Result/Reason"
            Set tItemData=$$$BEUINT8($Extract(pBytes,pOffset+7))
            If tItemData>4 {
                Set tSC=..BADVAL(pType,"Result/Reason",$$$Text("Integer between 0 and 4"),tItemData) Quit
            }
            
            Set pExtractedData($$$PRESENTATIONCONTEXT,tID,"result")=tItemData
        }
        
        #; Update the offset, thats the fixed header and the variable length
        Set pOffset=pOffset+8,tLimit=pOffset+tItemLength
        
        #; Initialize counts
        Set (tAbstractSyntaxCount,tTransferSyntaxCount)=0
    
        for  {
            
            #; Ran out of data
            If pOffset>=tLimit Quit
            
            #; Validate the Item type
            Set tItemType=$$$BEUINT8($Extract(pBytes,pOffset+1))
            If tItemType=$$$ABSTRACTSYNTAX {
                
                Set tAbstractSyntaxCount=tAbstractSyntaxCount+1
                
                #; Only 1 instance of an AbstractSyntax item allowed
                If pType=$$$AASSOCIATERQ {
                    
                    If tAbstractSyntaxCount>1 
                    {
                        Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONUNEXPECTEDPDUPARAMETER)
                        Set tSC=$$$EnsError($$$EnsDICOMMaxAbstractSyntaxCountExceeded) Quit
                    }
                }   
                
                #; Decompose the 'AbstractSyntax' item
                Kill tExtractedData
                Set tSC=..DecomposeAbstractSyntax(pType,.pBytes,.pOffset,.tExtractedData) If $$$ISERR(tSC) Quit
                
                Merge pExtractedData($$$PRESENTATIONCONTEXT,tID,$$$ABSTRACTSYNTAX,tAbstractSyntaxCount)=tExtractedData
                
            } elseif tItemType=$$$TRANSFERSYNTAX {
                
                #; Decompose the 'TransferSyntax' item
                Kill tExtractedData
                Set tSC=..DecomposeTransferSyntax(pType,.pBytes,.pOffset,.tExtractedData) If $$$ISERR(tSC) Quit
                
                #; Now check for "" transfer syntax ( some buggy software sends these, e.g. IQ-VIEW)
                If tExtractedData("name")'="" {
                
                    Set tTransferSyntaxCount=tTransferSyntaxCount+1
                
                    If pType=$$$AASSOCIATEAC {
                    
                        #; Only 1 instance of a TransferSyntax item allowed
                        If tTransferSyntaxCount>1 
                        {
                            Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONUNEXPECTEDPDUPARAMETER)
                            Set tSC=$$$EnsError($$$EnsDICOMMaxTransferSyntaxCountExceeded) Quit
                        }
                    }
                
                    Merge pExtractedData($$$PRESENTATIONCONTEXT,tID,$$$TRANSFERSYNTAX,tTransferSyntaxCount)=tExtractedData
                }
                
            } else {
                
                #; Unexpected item
                Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONUNEXPECTEDPDUPARAMETER)
                Set tSC=$$$EnsError($$$EnsDICOMUnexpectedItem,$ZHex(tItemType)) Quit
            }
        }
        
        If $$$ISERR(tSC) Quit
        
        If pType=$$$AASSOCIATERQ {
            
            If '((tAbstractSyntaxCount=1)&&(tTransferSyntaxCount>=1)) {

                #; Message is incomplete
                Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
                Set tSC=$$$EnsError($$$EnsDICOMMessageIncomplete,..PDU2EYE($$$AASSOCIATERQ)) Quit
            }
            
        } elseif pType=$$$AASSOCIATEAC {
            
            #; If the DICOM peer has indicated that the presentation context is acceptable 
            #; (some peers send bad data if not), check for a single TransferSyntax
            If pExtractedData($$$PRESENTATIONCONTEXT,tID,"result") = 0 {
            
                If '((tAbstractSyntaxCount=0)&&(tTransferSyntaxCount=1)) {
                
                    #; Message is incomplete
                    Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
                    Set tSC=$$$EnsError($$$EnsDICOMMessageIncomplete,..PDU2EYE($$$AASSOCIATEAC)) Quit
                }
            }
        }
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Decompose an UserInformation Item. We are primarily interested in the user max length for protocol data units
/// but will derive additional information too.
Method DecomposeUserInformation(pType As %Integer, ByRef pBytes As %String, ByRef pOffset As %Integer, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim tItemType,tItemLength,tInstanceCount,tLimit,tMaxLenCount As %Integer
    #dim tItemData As %String
    
    try {
    
        #; Pick out the item length,data and adjust the offset
        Set tItemLength=$$$BEUINT16($Extract(pBytes,pOffset+3,pOffset+4))
        
        #; Pick out the data, thats the 'User-data'
        Set tItemData=$Extract(pBytes,pOffset+5,pOffset+5+tItemLength-1)
        
        Set tInstanceCount=$Increment(pExtractedData($$$USERINFORMATION))
        Set pExtractedData($$$USERINFORMATION,tInstanceCount,"user-data")=tItemData
        
        #; Update the offset, thats the fixed header and the variable length
        Set pOffset=pOffset+4,tLimit=pOffset+tItemLength
        
        #; Initialize counts
        Set tMaxLenCount=0
        for {
            
            #; Ran out of data
            If pOffset>=tLimit Quit
            
            #; Validate the Item type
            Set tItemType=$$$BEUINT8($Extract(pBytes,pOffset+1))
            If tItemType=$$$USERLEN {
                
                #; Decompose the MaxLen
                Set tSC=..DecomposeUserMaxLen(tInstanceCount,pType,.pBytes,.pOffset,.pExtractedData)
                If $$$ISERR(tSC) Quit
                
                Set tMaxLenCount=tMaxLenCount+1
                If tMaxLenCount>1 {
                    Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONINVALIDPDUPARAMETERVALUE)
                    Set tSC=$$$EnsError($$$EnsDICOMMaxUserMaxLenCountExceeded) Quit
                }
            } else {
                
                #; Decompose the 'Other'
                Set tSC=..DecomposeUserOther(tInstanceCount,pType,.pBytes,.pOffset,.pExtractedData)
                If $$$ISERR(tSC) Quit
            }
        }
        
        If $$$ISERR(tSC) Quit
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Decompose 'Other' User item
Method DecomposeUserOther(pUserItemInstance As %Integer, pType As %Integer, ByRef pBytes As %String, ByRef pOffset As %Integer, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{

    #dim tItemType,tItemLength,tInstance,tInstanceCount As %Integer
    #dim tItemData As %String
    
    #; Pick out the item type
    Set tItemType=$$$BEUINT8($Extract(pBytes,pOffset+1))
    
    #; Pick out the item length,data and adjust the offset
    Set tItemLength=$$$BEUINT16($Extract(pBytes,pOffset+3,pOffset+4))
    
    #; Pick out the data, thats the 'other data'
    Set tItemData=$Extract(pBytes,pOffset+5,pOffset+5+tItemLength-1)
    
    Set tInstanceCount=$Increment(pExtractedData($$$USERINFORMATION,pUserItemInstance,"subitems",tItemType))
    Set pExtractedData($$$USERINFORMATION,pUserItemInstance,"subitems",tItemType,tInstanceCount,"data")=tItemData
    
    #; Update the offset, thats the fixed header and the variable length
    Set pOffset=pOffset+4+tItemLength
    
    Quit $$$OK
}

/// This method decomposes raw bytes into Presentation Data Value Items. 
Method DecomposeVariableData(pBytes As %String, Output pLast As %Boolean) As %Status [ Internal ]
{
    #dim tSC As %Status = $$$OK
    #dim tItemLength,tOffset,tLimit,tContextId As %Integer
    #dim tItemData As %String

    #; The variable field may be made up of 1 or more presentation data value items
    try {

        #; The variable field consists of 1 or more PDV items
        Set (tOffset,pLast)=0 
        For {

            #; Pick out the item length,data and adjust the offset
            Set tItemLength=$$$BEUINT32($Extract(pBytes,tOffset+1,tOffset+4))

            #; Pick out the context id
            Set tContextId=$$$BEUINT8($Extract(pBytes,tOffset+5))
            If ..ContextId="" {

                #; First VariableField for this message
                Set ..ContextId=tContextId
            } else {

                #; Additional VariableFields, make sure the context ids are the same (same message)
                If tContextId'=..ContextId Set tSC=$$$EnsError($$$EnsDICOMContextMismatch) Quit
            }

            #; Adjust offset for header
            Set tOffset=tOffset+6,tLimit=tOffset+tItemLength-2

            #; Decompose the ProtocolData item
            Set tSC=..DecomposePDVItem(pBytes,tOffset,tLimit,.pLast) If $$$ISERR(tSC) Quit

            #; Adjust the offset
            Set tOffset=tLimit

            If tOffset>=$Length(pBytes) Quit
        }

    } catch {
        Set tSC=$$$EnsSystemError
    }

    Quit tSC
}

/// Decompose UserMaxLen
Method DecomposeUserMaxLen(pUserItemInstance As %Integer, pType As %Integer, ByRef pBytes As %String, ByRef pOffset As %Integer, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tItemLength,tInstance,tInstanceCount As %Integer
    #dim tItemData As %String
    
    #; Pick out the item length,data and adjust the offset
    Set tItemLength=$$$BEUINT16($Extract(pBytes,pOffset+3,pOffset+4))
    
    #; Pick out the data, thats the 'UserMaxLen'
    Set tItemData=$$$BEUINT32($Extract(pBytes,pOffset+5,pOffset+5+tItemLength-1))
    
    Set tInstanceCount=$Increment(pExtractedData($$$USERINFORMATION,pUserItemInstance,"subitems",$$$USERLEN))
    Set pExtractedData($$$USERINFORMATION,pUserItemInstance,"subitems",$$$USERLEN,tInstanceCount,"Maximum-length-received")=tItemData
    
    #; Update the offset, thats the fixed header and the variable length
    Set pOffset=pOffset+4+tItemLength
        
    Quit $$$OK
}

/// Decompose AbstractSyntax Item
Method DecomposeAbstractSyntax(pType As %Integer, ByRef pBytes As %String, ByRef pOffset As %Integer, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim tItemLength,tInstance,tInstanceCount As %Integer
    #dim tItemData As %String
    
    try {
        #; Pick out the item length,data and adjust the offset
        Set tItemLength=$$$BEUINT16($Extract(pBytes,pOffset+3,pOffset+4))
        If (tItemLength>64)||(tItemLength<=0) {
            Set tSC=..BADLEN(pType,"Abstract-syntax-name",">=0,<=64",tItemLength) Quit
        }
        
        #; Pick out the data, thats the 'Abstract-syntax-name'
        Set tItemData=$Extract(pBytes,pOffset+5,pOffset+5+tItemLength-1)
        
        Set pExtractedData("name")=tItemData
        
        #; Update the offset, thats the fixed header and the variable length
        Set pOffset=pOffset+4+tItemLength
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Decompose TransferSyntax Item
Method DecomposeTransferSyntax(pType, ByRef pBytes As %String, ByRef pOffset As %Integer, ByRef pExtractedData As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tItemLength,tInstance,tInstanceCount As %Integer
    #dim tItemData As %String
    
    try {
        
        #; Pick out the item length,data and adjust the offset
        Set tItemLength=$$$BEUINT16($Extract(pBytes,pOffset+3,pOffset+4))
        
        #; We can't invalidate an 0 length transfer syntax here because some buggy devices
        #; do send 0 length strings! This situation is caught and handled elsewhere
        If tItemLength>64 {
            Set tSC=..BADLEN(pType,"Transfer-syntax-name","<=64",tItemLength) Quit
        }

        #; Pick out the item data, thats the 'Transfer-syntax-name'     
        Set tItemData=$Extract(pBytes,pOffset+5,pOffset+5+tItemLength-1)
        
        Set pExtractedData("name")=tItemData
        
        #; Update the offset, thats the fixed header and the variable length
        Set pOffset=pOffset+4+tItemLength
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Erase the Assocation AET/AET -> AssociationId Mapping
Method DeleteAssociation() As %Status [ Internal, Private ]
{
    #dim tData,tCallingAET,tCalledAET As %String
    
    #; Must check because Association may not have been established yet
    If ..AssociationId'="" {
        
        #; Get the calling and called AETs
        If $Data($$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId)) {
                
            Set tCallingAET=$$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"RQ",$$$ASSOCIATIONCONTEXT,"Calling-AE-title")
            Set tCalledAET =$$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"RQ",$$$ASSOCIATIONCONTEXT,"Called-AE-title")
        
            Kill $$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId)
            Kill $$$EnsRuntimeAppData($$$AdapterName,"i",tCallingAET,tCalledAET,..AssociationId)
        }
    
        Set ..AssociationId="",..MessageId=""
    }
    
    Quit $$$OK
}

/// Given an abstract syntax, find the context id for the accepted presentation context. The alogrithm employed is VERY
/// important. Ideally we want an EXACT match between negotiated transfer syntax and the transfer syntax which the document
/// is encoded in as this involves as expensive conversion process. Additionally some conversions may NOT be possible, for
/// example, converting a compressed/encapsulated transfer syntax to one of the basic syntaxes would or vice versa would require
/// a compression/decompresssion step which is currently NOT supported. If an exact match cannot be found then the next best
/// thing is to find a match where a supported conversion IS possible.
Method FindContextForOutboundTransfer(pAbstractSyntax As %String, pTransferSyntax As %String, Output pContextId As %Integer) As %Status
{
    #dim tSC As %Status = $$$OK

    #dim tFound,tAccepted As %Boolean = 0
    #dim tContextId As %Integer  = 0
    #dim tTransferSyntax As %String
    
    try {
        
        #; Clear the output
        Set pContextId=0
        
        #; Check that the association exists
        If ..AssociationIsEstablished=0 Set tSC=$$$EnsError($$$EnsDICOMNoActiveAssociation,..LocalAET,..RemoteAET) Quit
                
        #; Search the Accepted presentation contexts for the context id which matches
        For {
            
            Set tContextId=$Order($$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"RQ",$$$PRESENTATIONCONTEXT,tContextId)) If tContextId="" Quit
            
            If $Get($$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"RQ",$$$PRESENTATIONCONTEXT,tContextId,$$$ABSTRACTSYNTAX,1,"name"))=pAbstractSyntax
            {
                Set tFound=1
            
                If $Get($$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"AC",$$$PRESENTATIONCONTEXT,tContextId,"result"))=0 {
                
                    #; Found an accepted context id for the specified abstract syntax, now check for an exact match on the
                    #; transfer syntax
                    Set tAccepted=1
                    
                    Set tTransferSyntax=$$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"AC",$$$PRESENTATIONCONTEXT,tContextId,64,1,"name")
                    
                    #; Found an EXACT match!, no point looking further
                    If tTransferSyntax=pTransferSyntax Set pContextId=tContextId Quit
                    
                    #; Found a compatible match?
                    If ##class(EnsLib.DICOM.Util.CalloutDCM).CanConvertBetween(pTransferSyntax,tTransferSyntax)
                    {
                        #; Record the fact that there is a compatible match, but continue search
                        Set tContextId(tContextId)=""
                    }
                }
            }
        }
    
        #; OK, found an exact match
        If pContextId'=0 Quit
        
        #; Requested?
        If tFound=0 Set tSC=$$$ERROR($$$EnsDICOMAbstractSyntaxNotRequested,pAbstractSyntax,..LocalAET,..RemoteAET) Quit
        
        #; Accepted?
        If tAccepted=0 Set tSC=$$$ERROR($$$EnsDICOMAbstractSyntaxNotAccepted,pAbstractSyntax,..LocalAET,..RemoteAET) Quit
        
        #; Did we have a compatible match?
        Set pContextId=$Order(tContextId("")) If pContextId'="" Quit
        
        #; No compatible match found, thats an error
        Set tSC=$$$ERROR($$$EnsDICOMNoCompatibleTransferSyntaxFound,pAbstractSyntax,pTransferSyntax)
        
    } catch {
        Set tSC=$$$SystemError
    }
    
    Quit tSC
}

Method GetAssociationDetail(pDirection As %Integer, pContextId, Output pAbstractSyntax As %String, Output pTransferSyntax As %String) As %Status
{
    #; Determine the requested syntaxes for the data set
    Set pAbstractSyntax=..GetCurrentAbstractSyntax(pContextId)
    Set pTransferSyntax=..GetCurrentTransferSyntax(pContextId)

    #; Display details if asked
    If ..TraceVerbosity {   
    
        If ($$$OUTBOUND = pDirection) {
            Do ..TraceMessage($$$Verbose,$$$Text("Outbound AbstractSyntax      : ")_$$$AS2EYE(pAbstractSyntax))
            Do ..TraceMessage($$$Verbose,$$$Text("Outbound Transfer Syntax     : ")_$$$TS2EYE(pTransferSyntax))
        } Else {
            Do ..TraceMessage($$$Verbose,$$$Text("Inbound  AbstractSyntax      : ")_$$$AS2EYE(pAbstractSyntax))
            Do ..TraceMessage($$$Verbose,$$$Text("Inbound  Transfer Syntax     : ")_$$$TS2EYE(pTransferSyntax))
        }
    }

    Quit $$$OK
}

/// Given a presentation context id, return the negotiated syntax
Method GetCurrentTransferSyntax(pPCId) As %String [ CodeMode = expression ]
{
$$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"AC",$$$PRESENTATIONCONTEXT,pPCId,$$$TRANSFERSYNTAX,1,"name")
}

/// Given a presentation context id, return the negotiated syntax
Method GetCurrentAbstractSyntax(pPCId) As %String [ CodeMode = expression ]
{
$$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"RQ",$$$PRESENTATIONCONTEXT,pPCId,$$$ABSTRACTSYNTAX,1,"name")
}

/// Increment the message id. This is done when sending out a new message
Method GetNextMessageId() As %Integer
{
    Set ..MessageId=..MessageId+2 Quit ..MessageId
}

/// Load the Association Data to Send. This loads the stored AssociationContext instance for the Called/CallingAET
/// tuple and makes a list of the presentation contexts to be presented to the DICOM peer, as well as (crucially ),
/// the maximum PDU length
Method LoadAssociationData(pCallingAET As %String, pCalledAET As %String, ByRef pREQUEST As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    
    #dim tAssociationContext As EnsLib.DICOM.Util.AssociationContext
    #dim tPresentationContext As EnsLib.DICOM.Util.PresentationContext
    #dim tI,tJ,tPCId As %Integer
    #dim tTransferSyntax,tAbstractSyntax,tCalledAET As %String
    try {
        
        #; There MUST be an instance of EnsLib.DICOM.Util.Association extant which matches the 
        #; Calling and Called AETs, otherwise the Association cannot be established.
        Set tAssociationContext=##class(EnsLib.DICOM.Util.AssociationContext).AETOpen(pCallingAET,pCalledAET)
        If '$IsObject(tAssociationContext) {
            Do ..TraceMessage($$$Verbose,$$$Text("No Association Context Match for Calling AET: ")_pCallingAET_$$$Text(" Called AET: ")_pCalledAET) 
            Set tSC=$$$EnsError($$$EnsDICOMNoAssociationDefinedForPeers,pCallingAET,pCalledAET) Quit
        }
            
        Set pREQUEST($$$ASSOCIATIONCONTEXT,"Protocol-version")=1
        Set pREQUEST($$$ASSOCIATIONCONTEXT,"Calling-AE-title")=pCallingAET
        Set pREQUEST($$$ASSOCIATIONCONTEXT,"Called-AE-title")=pCalledAET
        Set pREQUEST($$$ASSOCIATIONCONTEXT,$$$APPLICATIONCONTEXT,1,"name")=$$$DICOMAPPLICATIONCONTEXTUID
        
        Set tPCId=1 For tI=1:1:tAssociationContext.PresentationContexts.Count() {
            
            Set tPresentationContext=tAssociationContext.PresentationContexts.GetAt(tI)
            
            Set tAbstractSyntax=tPresentationContext.AbstractSyntax
                
            #; Fill in the presentation context details
            Set pREQUEST($$$PRESENTATIONCONTEXT,tPCId,$$$ABSTRACTSYNTAX,1,"name")=tAbstractSyntax
            Set pREQUEST($$$PRESENTATIONCONTEXT,tPCId,"id")=tPCId
            Set pREQUEST($$$PRESENTATIONCONTEXT,tPCId,"result")=0
            
            #; If an override transfer syntax has been specified then use that instead of those
            #; configured in the association context
            If ..TransferSyntax'="" {
                
                #; Support more than one (overridden) transfer syntax
                For tJ=1:1:$Length(..TransferSyntax,",") {
                    Set pREQUEST($$$PRESENTATIONCONTEXT,tPCId,$$$TRANSFERSYNTAX,tJ,"name")=$Piece(..TransferSyntax,",",tJ)
                }
                
            } else {
            
                #; Fill in the transfer syntax details
                For tJ=1:1:tPresentationContext.TransferSyntaxes.Count() {
                    Set tTransferSyntax=tPresentationContext.TransferSyntaxes.GetAt(tJ)
                    Set pREQUEST($$$PRESENTATIONCONTEXT,tPCId,$$$TRANSFERSYNTAX,tJ,"name")=tTransferSyntax
                }
            
            }
            
            #; Presentation Contexts MUST be odd integers
            Set tPCId=tPCId+2
        }
        
        #; The max pdu len MUST not be bigger than the aligned chunklen
        Set pREQUEST($$$USERINFORMATION,1,"subitems",$$$USERLEN,1,"Maximum-length-received")=$$$ALIGNEDCHUNKLEN
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// This method is called repeatedly by the business host, it is the logical equivalent of the OnTask() method
/// for non TCP adapters
Method OnDeviceReady(Output pShouldQuit As %Boolean) As %Status [ Internal ]
{
    Quit ..SwitchState(.pShouldQuit)
}

/// This method is called by the business host when a connection is opened
/// For a service this will be called when the external AE connects in a TCP sense
/// For an operation when the adapter is instructed to open the Association.
Method OnOpenConnection() As %Status
{
    #dim tSC As %Status =$$$OK
    
    #; Determine the next state according to role being played
    Set ..State=$Case(..Role,$$$SERVICECLASSUSER:"State4",:"State2")
    
    #; If we are SCP we want to start the time immediately
    If ..State="State2" Set ..TCPReadTimeout=..ARTIM
    
    Quit tSC
}

Method OnCloseConnection() As %Status
{
    #dim tSC As %Status
    
    #; Delete the association
    Set tSC=..DeleteAssociation() If $$$ISERR(tSC) Quit tSC
    
    #; Return to original state
    Set ..State=$$$NOSTATE
    
    Quit $$$OK
}

Method OnInit() As %Status
{
    $$$InitTracing(..TraceVerbosity)
    Quit ##super()
}

/// Use this method to Establish an Association (when role is SCU)
Method EstablishAssociation(pRequest As EnsLib.DICOM.Command.Establish) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim tShouldQuit As %Boolean = 0
    try {
        
        #; Retain the (overriden) TransferSyntax
        Set ..TransferSyntax=pRequest.TransferSyntax
        
        #; Open the device, OnOpenConnection() will determine next state
        Set tSC=..OpenDevice() If $$$ISERR(tSC) Set ..State=$$$NOSTATE Quit
        
        #; Start the state machine
        Set tShouldQuit=0,tSC=..SwitchState(.tShouldQuit)
        If $$$ISERR(tSC) Quit
        
        If tShouldQuit=1 Set tSC=..ResetDevice(),..State=$$$NOSTATE     
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    #; Alert the host
    If $$$ISERR(tSC) Set tSC=..BusinessHost.OnAdapterErrored(tSC)
    
    Quit tSC
}

/// Use this method to close an Association
Method ReleaseAssociation() As %Status
{
    #dim tSC As %Status = $$$OK 
    #dim tShouldQuit As %Boolean = 0
    try {
        
        #; If the association is not established, nothing to do
        If ..AssociationIsEstablished=0 Quit
        
        #; Send a release request
        Do ..SendARELEASERQ()
        
        #; Switch to State7
        Set ..State="State7"
        
        #; Set the timeout
        Set ..TCPReadTimeout=..ARTIM
        
    } catch {
        
        Set tSC=$$$EnsSystemError
    }
    
    #; Don't want to report the error via the normal mechanism
    Quit $$$OK
}

/// Use this method to abort an Association
Method AbortAssociation(pSource As %Integer, pReason As %Integer) As %Status
{
    #dim tSC As %Status = $$$OK 
    #dim tShouldQuit As %Boolean = 0
    try {
        
        #; If the association is not established, nothing to do
        If ..AssociationIsEstablished=0 Quit
            
        #; Send an abort request
        Do ..SendAABORT(pSource,pReason)
        
        #; Switch to State13
        Set ..State="State13"
        
        #; Run the state machine until we reach State13 or an error occurs
        For {
            Set tSC=..SwitchState(.tShouldQuit) If $$$ISERR(tSC) Quit
            
            #; Reached appropriate state?
            If (tShouldQuit)||(..State="State13") Quit
        }
    
    } catch {
        
        Set tSC=$$$EnsSystemError
    }
    
    #; Don't want to report the error via the normal mechanism
    Quit $$$OK
}

/// This method expands a PDU type into eye-readable format
Method PDU2EYE(pType As %Integer) [ CodeMode = expression ]
{
$Case(pType,
    $$$PDATATF:     "P-DATA-TF",
    $$$AASSOCIATERQ:"A-ASSOCIATE-RQ",
    $$$AASSOCIATEAC:"A-ASSOCIATE-AC",
    $$$AASSOCIATERJ:"A-ASSOCIATE-RJ",
    $$$ARELEASERQ:  "A-RELEASE-RQ",
    $$$ARELEASERP:  "A-RELEASE-RP",
    $$$AABORT:      "A-ABORT",:"?PDU?")
}

/// This method prepares for an incoming message
Method PrepareForIncomingDocument() As %Status
{
    #dim tSC As %Status = $$$OK
    #dim tStorageLocation As %String
    
    try {
        #; Clear the wire stream and ContextId
        Do ..WireStream.Clear() Set ..ContextId=""
        
        #; Get the current storage location
        Set tStorageLocation=..BusinessHost.GetProductionSettingValue("StorageLocation",.tSC)
        If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
        
        If tStorageLocation'=""&&(0=##class(%File).DirectoryExists(tStorageLocation)) {
            Set tSC=$$$EnsError($$$DirectoryNotExist,tStorageLocation) $$$LOGSTATUS(tSC) Quit
        }
        
        #; Create a new document, pass the storage location
        Kill %objlasterror Set ..InboundDocument=##class(EnsLib.DICOM.Document).%New(tStorageLocation)
        If '$IsObject(..InboundDocument) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
    
        #; CurrentStream is pointing tp wire stream
        Set ..CurrentStream=..WireStream
        
    } catch {
        
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// This method composes and sends either an A-ABORT or A-P-ABORT PDU as determined by the 'source'
Method SendAABORT(pSource, pReason) As %Status [ Internal, Private ]
{
    #dim tBytes As %String
    
    Do ..TraceMessage($$$Verbose,$$$Text("Sending ABORT ")_##class(EnsLib.DICOM.Util.Encoding).ABORTREASON2EYE(pSource,pReason))
        
    #; Compose an abort, reset reason and source
    Set tBytes=..ComposeAABORT(pSource,pReason)
    
    #; Send it
    Quit ..SendPDU(tBytes)
}

/// This method composes and sends an A-ASSOCIATE-AC PDU
Method SendAASSOCIATEAC() As %Status [ Internal, Private ]
{
    #dim tSC As %Status
    #dim tBytes,tDataToInsert
    
    #; If we are sending an associate accept, we already have the details of the Association cached
    Merge tDataToInsert=$$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"AC")
    
    #; Compose the Associate Accept PDU
    Set tSC=..ComposeAASSOCIATEAC(.tDataToInsert,.tBytes) If $$$ISERR(tSC) Quit tSC
    
    #; Send it
    Quit ..SendPDU(.tBytes)
}

/// This method composes and sends an A-ASSOCIATE-RQ PDU
Method SendAASSOCIATERQ() As %Status [ Internal, Private ]
{
    #dim tSC As %Status
    #dim tBytes,tDataToInsert
    
    #; Merge in the data from the Association Request
    Merge tDataToInsert=$$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"RQ")
    
    #; Compose the Associate Accept PDU
    Set tSC=..ComposeAASSOCIATERQ(.tDataToInsert,.tBytes) If $$$ISERR(tSC) Quit tSC
    
    #; Send it
    Quit ..SendPDU(.tBytes)
}

/// This method composes and sends an A-REJECT PDU
Method SendAASSOCIATERJ(pSource, pReason) As %Status [ Internal, Private ]
{
    #dim tBytes As %String
    #dim tSC As %Status = $$$OK
    
    try {   
    
        Do ..TraceMessage($$$Verbose,$$$Text("Sending REJECT ")_##class(EnsLib.DICOM.Util.Encoding).REJECTREASON2EYE(pSource,pReason))
            
        Set tBytes=..ComposeAASSOCIATERJ(pSource,pReason)

        #; Send it
        Set tSC=..SendPDU(tBytes)
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// This methods sends the fixed Associate Release Request 
Method SendARELEASERQ() As %Status [ Internal ]
{
    Quit ..SendPDU($$$ARELEASERQPDU)
}

/// This method sends the fixed Associate Release Response
Method SendARELEASERP() As %Status [ Internal ]
{
    Quit ..SendPDU($$$ARELEASERPPDU)
}

/// This method sends the specified document to the connected peer
Method SendDocument(pDocument As EnsLib.DICOM.Document) As %Status
{
    #dim tSC,tSCUPS,tSCTemp As %Status = $$$OK
    
    #dim tContextId,tSyntaxId,tDataSetType As %Integer
    #dim tStream As %Stream.TmpBinary
    #dim tShouldQuit As %Boolean
    #dim tAffectedSOPClassUID,tMsgType,tAbstractSyntax,tTransferSyntax,tResponseMsgId,tUPSSOPClassUID,tStatusCodes As %String
    
    try {
        
        #; If the adapter is not in the correct state then issue an error message
        If ..State'="State6" Set tSC=$$$EnsError($$$EnsDICOMNoActiveAssociation,..LocalAET,..RemoteAET) Quit
        
        #; Get the command field
        Set tMsgType=$$$MsgTyp2Str(pDocument.GetValueAt("CommandSet.(0000,0100)",,.tSC))
        If $$$ISERR(tSC) Quit
        
        #; Need special processing for C-CANCEL-RQ
        If tMsgType="C-CANCEL-RQ" {
            
            #; C-CANCEL-RQ has no AffectedSOPClassUID, so don't attempt to fetch
            Set tTransferSyntax=$$$IMPLICITVRLETRANSFERSYNTAX,tContextId=0
            
        } else {
        
            #; Get the AbstractSyntax from the command set (this is the AffectedSOPClassUID)
            Set tAffectedSOPClassUID=pDocument.GetValueAt("CommandSet.(0000,0002)",,.tSC)
            If $$$ISERR(tSC) {
                #; Not found, try the RequestedSOPClassUID
                Set tSC=$$$OK Set tAffectedSOPClassUID=pDocument.GetValueAt("CommandSet.(0000,0003)",,.tSC)
                If $$$ISERR(tSC) Quit
            }
           
            If tAffectedSOPClassUID="" Set tSC=$$$EnsError($$$EnsDICOMUnrecognizedAbstractSyntax,"(null)") Quit
            
            #; Get the transfer syntax which this document is encoded in
            Set tTransferSyntax=pDocument.DataSet.TransferSyntax
            
            #; Find the context which matches this SOP UID, if we haven't got a match there is no sense trying to send this
            Set tSC=..FindContextForOutboundTransfer(tAffectedSOPClassUID,tTransferSyntax,.tContextId) 
            If $$$ISERR(tSC) {
	            /*
	            	For DIMSE-N Services, the Affected SOP Class UID (0000,0002) or
	            	Requested SOP Class UID (0000,0003), when present, will be the UID
	            	of the UPS Push SOP Class regardless of the negotiated Abstract Syntax UID.
	            	The SCU and SCP will not reject DIMSE-N messages on the basis of the 
	            	Affected/Requested SOP Class UID being that of the UPS Push SOP Class, 
	            	rather than one of the other three SOP Class UIDs as listed in the Abstract 
	            	Syntax UID during association negotiation.
	            */
	            #; Quit since error and not DIMSE-N nor UPS Push SOP Class
	            If ($E(tMsgType)'="N") || (tAffectedSOPClassUID'=$$$UPSPUSHSOPCLASS) {
		            $$$LOGERROR($System.Status.GetErrorText(tSC))
		            Quit
	            } Elseif ($System.Status.Equals(tSC,$$$EnsDICOMAbstractSyntaxNotRequested)) {
		            Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("Abstract Syntax '%1' not requested between peers '%2' and '%3'.  Trying other UPS SOP UIDs"),$$$AS2EYE($$$UPSPUSHSOPCLASS),..LocalAET,..RemoteAET))
	            } Elseif ($System.Status.Equals(tSC,$$$EnsDICOMAbstractSyntaxNotAccepted)) {
		            Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("Abstract Syntax '%1' rejected between between peers '%2' and '%3'.  Trying other UPS SOP UIDs"),$$$AS2EYE($$$UPSPUSHSOPCLASS),..LocalAET,..RemoteAET))
	            } Elseif ($System.Status.Equals(tSC,$$$EnsDICOMNoCompatibleTransferSyntaxFound)) {
		            Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("No negotiated transfer syntax for SOP class '%1' is compatible with document transfer syntax '%2'.  Trying other UPS SOP UIDs"),$$$AS2EYE($$$UPSPUSHSOPCLASS),tTransferSyntax))
	            } Else {
		            Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("Trying other UPS SOP UIDs after an error was encountered in trying to find context for Abstract Syntax '%1' :  "),$$$AS2EYE($$$UPSPUSHSOPCLASS))_$System.Status.GetErrorText(tSC))
	            }

	            #; Look to find context for one of the other 3 UPS SOP UIDs
				For tUPSSOPClassUID = $$$UPSWATCHSOPCLASS,$$$UPSPULLSOPCLASS,$$$UPSEVENTSOPCLASS {
					Set tSCTemp=..FindContextForOutboundTransfer(tUPSSOPClassUID,tTransferSyntax,.tContextId)
					If $$$ISOK(tSCTemp) Quit
					Set tSCUPS = $System.Status.AppendStatus(tSCUPS,tSCTemp)
				}
				
				#; If still didn't find adjust error message
				If $$$ISERR(tSCTemp) {
					Set tSCUPS = $System.Status.AppendStatus(tSCUPS,tSC)
					Set tStatusCodes = ","_$System.Status.GetErrorCodes(tSCUPS)_","
					If tStatusCodes [ ",<EnsDICOM>NoCompatibleTransferSyntaxFound," {
						Set tSC = $$$EnsError($$$EnsDICOMUPSNoCompatibleTransferSyntaxFound,tTransferSyntax)
					} Elseif tStatusCodes [ ",<EnsDICOM>AbstractSyntaxNotAccepted," {
						Set tSC = $$$EnsError($$$EnsDICOMUPSAbstractSyntaxesNotAccepted,..LocalAET,..RemoteAET)
					} Elseif tStatusCodes [ ",<EnsDICOM>AbstractSyntaxNotRequested," {
						Set tSC = $$$EnsError($$$EnsDICOMUPSAbstractSyntaxesNotRequested,..LocalAET,..RemoteAET)
					} Else {
						// leave original error code
						$$$LOGERROR($System.Status.GetErrorText(tSC))
					}
					Quit
				}
            }
                        
            #; Attempt to get the value, will throw if value does not exist (this is the MessageIDBeingRespondedTo)
            Set tResponseMsgId=pDocument.GetValueAt("CommandSet.(0000,0120)",,.tSC)
            
            #; Don't check status, value may be missing
            
            #; Check to see if there is a response id, if not then it means this is a request, not a response
            If (tResponseMsgId="") {
        
                #; This is a request message, first check to see if the user has set a message id
                Set tMsgId=pDocument.GetValueAt("CommandSet.(0000,0110)",,.tSC)
                
                #; Don't check status, value may not be present. 
                
                #; If the user has set a message id then update the internal counter
                If tMsgId'="" {
                    
                    #; The counter will be updated to the correct value by GetNextMessageId() below 
                    Set ..MessageId=tMsgId-2
                }
                
                #; Get a new message id and update the command set ( this is the MessageID )
                Set tSC=pDocument.SetValueAt(..GetNextMessageId(),"CommandSet.(0000,0110)") If $$$ISERR(tSC) Quit
            }

            #; Get the association details
            Set tSC=..GetAssociationDetail($$$OUTBOUND,tContextId,.tAbstractSyntax,.tTransferSyntax)
            If $$$ISERR(tSC) Quit
        }
        
        Do ..TraceMessage($$$Terse,$$$Text("Sending  MSG type ")_tMsgType)
        
        #; Ask the document to send itself
        Set tSC=pDocument.SendWireStream(##this,tContextId,tTransferSyntax) If $$$ISERR(tSC) Quit
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    #; If an error has occurred notify the business host
    If $$$ISERR(tSC) Set tSC=..BusinessHost.OnAdapterErrored(tSC)
    
    Quit tSC
}

/// This method sends one or more PDU(s) by writing to the device
Method SendPDU(ByRef pBytes As %String) As %Status [ Internal ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tIO As %Integer
    
    try {
        Set tIO=$IO Use ..IPDevice Write pBytes,*-3 Use tIO
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// This method sends the outbound stream by writing PDU size packets to the device
Method SendStream(pStream As %Stream.TmpBinary) As %Status [ Internal, Private ]
{
    #dim tSC As %Status
    #dim tPacketLength As %Integer
    #dim tPrefixBytes,tBytes As %String
    
    try {
        
        Set tSC=pStream.Rewind() If $$$ISERR(tSC) Quit
        While 'pStream.AtEnd
        {
            Set tPrefixBytes=pStream.Read(2),tPacketLength=pStream.Read(4),tPrefixBytes=tPrefixBytes_tPacketLength
            Set tBytes=pStream.Read($$$BEUINT32(tPacketLength),.tSC) If $$$ISERR(tSC) Quit
            Set tSC=..SendPDU(tPrefixBytes_tBytes) If $$$ISERR(tSC) Quit
        }
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// This method implements the 'Transport Connection Open (Awaiting A-ASSOCIATE-RQ PDU)' state
Method State2() As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tBytes,tCalledAET,tCallingAET,tRequest,tACCEPT,tREQUEST,tOneAET,tPattern As %String
    #dim tTimedOut,tRecognizedRemoteAET,tAnyPCAcceptable,tPatternUsed As %Boolean
    #dim tI,tType,tMaxLen As %Integer
    #dim tAC As EnsLib.DICOM.Util.AssociationContext
    
    #; Reset the AETs
    Set ..CallingAET="",..CalledAET="",..OriginalCallingAET=""
    
    try {

        #; Accept a PDU
        Set tSC=..AcceptPDU(.tBytes,..ARTIM) If $$$ISERR(tSC) Quit
        
        #; Now Decompose the PDU into its components
        Set tSC=..DecomposePDU(.tBytes,.tType,.tREQUEST) If $$$ISERR(tSC) Quit
        
        #; If an ABORT received, just close the transport (AA-2)
        If tType=$$$AABORT Set ..NextState="State13" Quit   
        
        #; Check for unexpected type
        If tType'=$$$AASSOCIATERQ { 
                
            Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONUNEXPECTEDPDU)
            
            #; Unexpected PDU received, issue an ABORT (AA-1)
            Set tSC=$$$EnsError($$$EnsDICOMUnexpectedPDU,..PDU2EYE(tType))
            
            Quit
        }
        
        #; Just copy across the application context details
        Merge tACCEPT($$$ASSOCIATIONCONTEXT)=tREQUEST($$$ASSOCIATIONCONTEXT)
    
        #; AE-6, determine if Association Request is Acceptable
        If tREQUEST($$$APPLICATIONCONTEXT,1,"name")'=$$$DICOMAPPLICATIONCONTEXTUID {
        
            #; Invalid Application Context
            Do ..TraceMessage($$$Verbose,$$$Text("Invalid DICOMApplicationContext received"))
            Do ..SendAASSOCIATERJ($$$REJECTSOURCESERVICEUSER,$$$REJECTREASONAPPLICATIONCONTEXTNAMENOTSUPPORTED) 
            Set ..NextState="State13"
            Quit
        }
        
        #; Validate the Called AET (thats our name)
        Set tCalledAET=tREQUEST($$$ASSOCIATIONCONTEXT,"Called-AE-title") 
        
        #; If the LocalAET is not defined as the wildcard
        If ..LocalAET'="*" {
            
            #; Then the CalledAET MUST match the defined LocalAET
            If tCalledAET'=..LocalAET { 
            
                Do ..TraceMessage($$$Verbose,$$$Text("Called AET: ")_tCalledAET_$$$Text(" does not match Local AET: ")_..LocalAET)  
                Do ..SendAASSOCIATERJ($$$REJECTSOURCESERVICEUSER,$$$REJECTREASONULCALLEDAETNOTRECOGNIZED)
                Set ..NextState="State13"
                Quit
            }
        }
        
        #; Validate the Calling AET (thats their name)
        Set tCallingAET=tREQUEST($$$ASSOCIATIONCONTEXT,"Calling-AE-title")
        
        #; Record the CallingAET As OriginalCallingAET, i.e prior to any transformation
        Set ..OriginalCallingAET=tCallingAET
        
        #; If the RemoteAET is not the 'wildcard' specification
        If ..RemoteAET'="*" {
            
            #; Validate that the CallingAET appears in our list our RemoteAETs (including pattern substitution)
            Set (tRecognizedRemoteAET,tPatternUsed)=0,tPattern="" 
            
            For tI=1:1:$Length(..RemoteAET,",") {
                Set tOneAET=$Piece(..RemoteAET,",",tI)
                If $Extract(tOneAET)="?" {
                    Set tPattern=$Piece($Extract(tOneAET,2,*),"/")
                    If tCallingAET?@tPattern Set (tRecognizedRemoteAET,tPatternUsed)=1,tCallingAET=$Piece($Extract(tOneAET,2,*),"/",2)
                } else {
                    If tCallingAET=tOneAET Set tRecognizedRemoteAET=1 Quit
                }
            } 
            
            #; Did we recognize the remote AET?
            If 0=tRecognizedRemoteAET {
                Do ..TraceMessage($$$Verbose,$$$Text("Calling AET: ")_tCallingAET_$$$Text(" not contained in Remote AET list:  ")_..RemoteAET)      
                Do ..SendAASSOCIATERJ($$$REJECTSOURCESERVICEUSER,$$$REJECTREASONULCALLINGAETNOTRECOGNIZED)
                Set ..NextState="State13"
                Quit
            }
            
            #; The user DID? specify an AET when matching a pattern
            If tPatternUsed'=0 {
                
                If tCallingAET="" {
                    
                    Do ..TraceMessage($$$Verbose,$$$Text("No AET specified for matching pattern")_tPattern_" "_$$$Text(" in Remote AET list:  ")_..RemoteAET)       
                    Do ..SendAASSOCIATERJ($$$REJECTSOURCESERVICEUSER,$$$REJECTREASONULCALLINGAETNOTRECOGNIZED)
                    Set ..NextState="State13"
                    Quit
                }
            }
        }
        
        
        #; There MUST be an instance of EnsLib.DICOM.Util.Association extant which matches the 
        #; Calling and Called AETs, otherwise the Association is rejected outright.
        Set tAC=##class(EnsLib.DICOM.Util.AssociationContext).AETOpen(tCallingAET,tCalledAET)
        If '$IsObject(tAC) {
            
            #; This is NOT a hard error condition, we log a trace and reject the association
            Do ..TraceMessage($$$Verbose,$$$Text("No Association Context Defined for Calling AET: ")_tCallingAET_$$$Text(" Called AET: ")_tCalledAET)   
            Do ..SendAASSOCIATERJ($$$REJECTSOURCESERVICEUSER,$$$REJECTREASONNOREASONGIVEN)
            Set ..NextState="State13"
            Quit
        }
        
        #; Record the current AET
        Set ..CallingAET=tCallingAET,..CalledAET=tCalledAET
        
        #; Validate the Association against the stored AssociationContext Object
		Set tSC=..ValidateAssociateRequest(tAC,.tREQUEST,.tACCEPT,.tAnyPCAcceptable) If $$$ISERR(tSC) Quit

        #; Record if at least one of the requested Presentation Contexts is acceptable.
        Set ..AnyPCAcceptable=tAnyPCAcceptable
        
        #; Negotiate the Max PDU Length
        Set tMaxLen=tREQUEST($$$USERINFORMATION,1,"subitems",$$$USERLEN,1,"Maximum-length-received")
        
        #; MaxPDULen is the smaller of $$$ALIGNEDCHUNKLEN or proposed maxlen
        #; Zero means 'you choose' so we choose our own max len
        if ((tMaxLen<$$$ALIGNEDCHUNKLEN)&&(tMaxLen'=0)) {
            Set ..MaxPDULen=tMaxLen
        } else {
            Set ..MaxPDULen=$$$ALIGNEDCHUNKLEN
        }
        
        #; Create an Association
        Set tSC=..CreateAssociation(.tREQUEST,.tACCEPT) If $$$ISERR(tSC) Quit
        
        #; Send an acceptance, AE-7, even if no presentation contexts were acceptable
        Set tSC=..SendAASSOCIATEAC() If $$$ISERR(tSC) Quit
        
        #; Move on
        Set ..NextState="State3"
     
    } catch {
        
        Set tSC=$$$EnsSystemError
    }

    Quit tSC
}

/// This method implements the 'Awaiting local A-ASSOCIATE response primitive (from local user)' state
Method State3() As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    try {
        
        #; None of the PresentationContexts were acceptable, we should close the connection
        If ..AnyPCAcceptable=0 {
            Do ..TraceMessage($$$Terse,$$$Text("No Presentation Contexts Acceptable, Connection Closed"))
            Set ..NextState="State13" Quit
        }
        
        #; Notify the business host that association has been accepted
        Set tSC=..BusinessHost.OnAdapterEstablished() If $$$ISERR(tSC) Quit
        
        #; Prepare for an incoming message!
        Set tSC=..PrepareForIncomingDocument() If $$$ISERR(tSC) Quit
        
        #; Move on
        Set ..NextState="State6"
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// This method implements the 'Awaiting Transport connection opening to complete ( from local user )'
Method State4() As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tCallingAET,tCalledAET,tREQUEST As %String
    
    try {
        Set tCallingAET=..LocalAET,tCalledAET=$Piece(..RemoteAET,",")
    
        #; Load the Association Data
        Set tSC=..LoadAssociationData(tCallingAET,tCalledAET,.tREQUEST) 
        If $$$ISERR(tSC) Quit   
        
        #; Create an Association ( We don't have the details of acceptance yet, thats OK)
        Set tSC=..CreateAssociation(.tREQUEST)
        If $$$ISERR(tSC) Quit
        
        #; AE-2, Transport connection confirmed, send A-Associate-RQ PDU
        Set tSC=..SendAASSOCIATERQ()
        If $$$ISERR(tSC) Quit
        
        Set ..TCPReadTimeout=..ARTIM
        
        #; Move on
        Set ..NextState="State5"
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// This method implements the 'Awaiting A-ASSOCIATE-AC or A-ASSOCIATE-RJ PDU' state
Method State5() As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tBytes As %String
    #dim tACCEPT,tType,tMaxPDULen As %Integer
    #dim tTimedOut As %Boolean
    #dim tStatusCode As %Status
    
    try {
    
        #; Accept a PDU, if timed out indicate so
        Set tSC=..AcceptPDU(.tBytes,..ARTIM) If $$$ISERR(tSC) Quit
            
        #; Now Decompose the PDU    
        Set tSC=..DecomposePDU(.tBytes,.tType,.tACCEPT)
        If $$$ISERR(tSC) Quit
        
        #; Test for an Abort
        If tType=$$$AABORT {
            
            Set tSC=..BusinessHost.OnAdapterAborted(tACCEPT("Source"),tACCEPT("Reason"))
            If $$$ISERR(tSC) Quit
            
            Set ..NextState="State13" 
            Quit
        }
        
        #; Only expecting an associate accept or an associate reject
        If '((tType=$$$AASSOCIATEAC)||(tType=$$$AASSOCIATERJ)) {
                
            Set tStatusCode=$$$EnsDICOMUnexpectedPDU
            Do ..RecordAbortDetails($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONUNEXPECTEDPDU)
            
            #; Unexpected PDU received, AA-8
            Set tSC=$$$EnsError(tStatusCode,..PDU2EYE(tType))
            Quit
        }
        
        #; Rejected, form an error message from the specified source and reason
        If tType=$$$AASSOCIATERJ {
                
            #; Inform the business host
            Set tSC=..BusinessHost.OnAdapterRejected(tACCEPT("Source"),tACCEPT("Reason")) If $$$ISERR(tSC) Quit
            Set ..NextState="State13" 
            Quit
        }
        
        If 0=..ValidateAssociateAccept(.tACCEPT) {
            
            #; None of the requested Presentation Contexts were acceptable, we should close the connection with a hard error
            Set tSC=$$$ERROR($$$EnsDICOMPeerRejectedALLPCS) 
            Quit
        }
        
        #; Store the Acceptance data
        Merge $$$EnsRuntimeAppData($$$AdapterName,"d",..AssociationId,"AC")=tACCEPT
        
        #; Validate the Max PDU Len
        Set tMaxPDULen=tACCEPT($$$USERINFORMATION,1,"subitems",$$$USERLEN,1,"Maximum-length-received")
        
        #; The protocol can be more efficient IF the peer can accept packets > 32k AND we have long strings 
        #; switched on. Currently we will NOT send packets greater than approx 32K regardless.
        #; If the maximum length subitem is zero, it means 'unspecified', so we choose our own max len
        If (tMaxPDULen>$$$ALIGNEDCHUNKLEN)||(tMaxPDULen=0) {
	        Set tMaxPDULen=$$$ALIGNEDCHUNKLEN
        }
        
        #; Set the Max PDU Length
        Set ..MaxPDULen=tMaxPDULen
        
        #; Prepare for an incoming message!
        Set tSC=..PrepareForIncomingDocument() If $$$ISERR(tSC) Quit
        
        #; Notify the business host that association has been accepted
        Do ..BusinessHost.OnAdapterEstablished()
        
        #; Move on
        Set ..NextState="State6"
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// This method implements the 'Association established and ready for data transfer' state. Data Transfer may
/// be initiated in either direction, from an incoming data pdu on the TCP connection or via an enqueued outbound
/// message
Method State6() As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tBytes,tPDUs,tIndex,tHint,tMsgType,tTransferSyntax,tAbstractSyntax,tTraceMsg,tAffectedSOPClassUID As %String
    #dim tExtractedData,tLen,tType,tKey,tContextId,tMsgId As %Integer
    #dim tLast,tTimedOut As %Boolean = 0
    #dim tOutboundDocument As EnsLib.DICOM.Document
    #dim tOutboundStream As %Stream.TmpBinary
    
    try {
        
        #; Accept data from peer. Regularly we would not need a timeout here as we are only called
        #; where data is ready to receive. However, a specific amount of data is required
        #; which must be accepted in two reads and we need a timeout incase the second read fails
        Set tSC=..AcceptPDU(.tBytes,..TXTIM) If $$$ISERR(tSC) Quit 
        
        #; Now Decompose the PDU    
        Set tSC=..DecomposePDU(.tBytes,.tType,.tExtractedData) If $$$ISERR(tSC) Quit
        
        #; If asked to release the association then comply (AR-2)
        If tType=$$$ARELEASERQ Set ..NextState="State8" Quit
        
        #; If asked to abort, log that fact and end
        If tType=$$$AABORT {
            
            Set tSC=..BusinessHost.OnAdapterAborted(tExtractedData("Source"),tExtractedData("Reason"))
            If $$$ISERR(tSC) Quit
            
            Set ..NextState="State13" 
            
            Quit
        }
        
        If (tType'=$$$PDATATF) {
            
            #; Unexpected PDU received, AA-1
            If ..Role=$$$SERVICECLASSUSER {
                Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONUNEXPECTEDPDU)
            } else {
                Do ..RecordAbortDetails($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONUNEXPECTEDPDU)
            }
                
            Set tSC=$$$EnsError($$$EnsDICOMUnexpectedPDU,..PDU2EYE(tType))
            Quit
        }
        
        #; Data PDU Received, DT-2
        Set tLast=0,tSC=..DecomposeVariableData(tExtractedData("VariableField"),.tLast)
        If $$$ISERR(tSC) Quit
        
        #; Is this the last fragment of the message?
        If tLast=1 {
            
            #; Get the Association detail
            Set tSC=..GetAssociationDetail($$$INBOUND,..ContextId,.tAbstractSyntax,.tTransferSyntax)
            If $$$ISERR(tSC) Quit
                    
            #; Get the message type
            Set tMsgType=$$$MsgTyp2Str(..InboundDocument.GetValueAt("CommandSet.(0000,0100)",,.tSC))
            If $$$ISERR(tSC) Quit
            
            Do ..TraceMessage($$$Terse,$$$Text("Received MSG type ")_tMsgType)
            
            #; Update the Documents Source IPAddress and Calling AET
            Set ..InboundDocument.SourceIPAddress=..GetPeerAddress()
            Set ..InboundDocument.SourceAET=..CallingAET
            Set ..InboundDocument.OriginalSourceAET=..OriginalCallingAET
            Set ..InboundDocument.DestinationAET=..CalledAET

        	Set ..InboundDocument.DataSet.TransferSyntax = tTransferSyntax

            #; Delegate message handling to the business host 
            Set tOutboundDocument=$$$NULLOREF
    
            Set tSC=..BusinessHost.ProcessInput(..InboundDocument,.tOutboundDocument,.tHint)
            If $$$ISERR(tSC) Quit
    
            #; If there is a outbound document, send it to the peer
            If $IsObject(tOutboundDocument) {
                Set tSC=..SendDocument(tOutboundDocument) If $$$ISERR(tSC) Quit         
            }
            
            #; Now prepare for another incoming message
            Set tSC=..PrepareForIncomingDocument() If $$$ISERR(tSC) Quit
        }
            
        If $$$ISERR(tSC) Quit
        
        #; Move On
        Set ..TCPReadTimeout=..TXTIM,..NextState="State6"
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// This method implements the 'Awaiting A-RELEASE-RP' state
Method State7() As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tBytes As %String
    #dim tExtractedData,tType As %Integer
    #dim tTimedOut As %Boolean
    
    try {
        
        #; Accept a PDU
        Set tSC=..AcceptPDU(.tBytes,..ARTIM) If $$$ISERR(tSC) Quit
            
        #; Now Decompose the PDU    
        Set tSC=..DecomposePDU(.tBytes,.tType,.tExtractedData)
        If $$$ISERR(tSC) Quit
        
        if (tType=$$$ARELEASERP) {
            
            #; Release Response received, close the connection
            Set tSC=..BusinessHost.OnAdapterReleased()
            If $$$ISERR(tSC) Quit
            
            Set ..NextState="State13"
                
        } elseif (tType=$$$ARELEASERQ) {
            
            #; Release collision (AR-8)
            Set tSC=..SendARELEASERP()
            If $$$ISERR(tSC) Quit
                        
            Set ..NextState="State13"
            
        } elseif (tType=$$$AABORT) {
        
            #; Peer requested abort
            Set tSC=..BusinessHost.OnAdapterAborted(tExtractedData("Source"),tExtractedData("Reason"))
            If $$$ISERR(tSC) Quit
            
            Set ..NextState="State13"
            
        } else {

            #; Unexpected PDU received
            If ..Role=$$$SERVICECLASSUSER {
                Do ..RecordAbortDetails($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONUNEXPECTEDPDU)
            } else {
                Do ..RecordAbortDetails($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONUNEXPECTEDPDU)
            }
                
            Set tSC=$$$EnsError($$$EnsDICOMUnexpectedPDU,..PDU2EYE(tType))
            Quit
        }
    } catch {
        Set tSC=$$$EnsSystemError
    }

    Quit tSC
}

Method State8() As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    try {
        #; Send an association release reply, this is AR-9
        Set tSC=..SendARELEASERP(),..NextState="State13"
        If $$$ISERR(tSC) Quit
        
        Set tSC=..BusinessHost.OnAdapterReleased()
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// Run the State Machine by switching states
Method SwitchState(Output pShouldQuit As %Boolean) As %Status [ Internal ]
{
    #dim tSC As %Status = $$$OK
    
    For  {
        
        #; Don't run the state machine if its in an indeterminate state
        If ..State=$$$NOSTATE||(..State="State13") {
            Set ..State=$$$NOSTATE,pShouldQuit=1 Quit
        }
        
        try {
            #; Run the state machine
            Set tSC=$zobjmethod(##this,..State) 
        } catch {
            Set tSC=$$$EnsSystemError
        }   
        
        #; If an error has occurred
        If $$$ISERR(tSC) {
            
            #; Inform the business host
            Set tSC=..BusinessHost.OnAdapterErrored(tSC)
            If $$$ISERR(tSC) Quit
            
            #; Send an abort to the peer
            Set tSC=..SendAABORT(..AbortSource,..AbortReason)
            If $$$ISERR(tSC) Quit
            
            #; The host should quit running the machine
            Set ..State="State13"
            
            Quit
        }
        
        #; Switch the states
        Set ..State=..NextState
        
        If ..State="State13" Set pShouldQuit=1
        
        #; Must relinquish control for certain states
        If ..State="State2"||(..State="State5")||(..State="State6") Quit
    }
    
    #; We don't want to report an error via this mechanism
    Quit $$$OK
}

/// Validate the Received Acceptance Data. Return 1 is at least one of the requested presentation
/// contexts is acceptable
Method ValidateAssociateAccept(ByRef pACCEPT As %String) As %Boolean [ Internal, Private ]
{
    
    #dim tPCIndex As %Integer
    #dim tAnyPCAcceptable As %Boolean = 0
        
    Set tPCIndex="" For  {
        
        Set tPCIndex=$Order(pACCEPT($$$PRESENTATIONCONTEXT,tPCIndex)) If tPCIndex="" Quit
        
        #; If the peer has accepted this presentation context
        If pACCEPT($$$PRESENTATIONCONTEXT,tPCIndex,"result")=0 Set tAnyPCAcceptable=1 Quit
    }

    Quit tAnyPCAcceptable
}

/// Validate the Received Association Data
Method ValidateAssociateRequest(pAC As EnsLib.DICOM.Util.AssociationContext, ByRef pREQUEST As %String, ByRef pACCEPT As %String, Output pAnyAcceptable As %Boolean) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    
    #dim tPCIndex,tASIndex,tPresentationContextId,tTSIndex As %Integer
    #dim tAbstractSyntax,tTransferSyntaxes,tSelectedTransferSyntax As %String
    #dim tAssociationContext As EnsLib.DICOM.Util.AssociationContext
    #dim tAccepted, tAbstractSyntaxSupported As %Boolean
        
    try {
        
        #; Assume miserable failure
        Set pAnyAcceptable = 0
        
        #; For each presentation context determine if the proposed abstract syntaxes are acceptable
        Set tPCIndex="" For  {
            
            Set tPCIndex=$Order(pREQUEST($$$PRESENTATIONCONTEXT,tPCIndex)) If tPCIndex="" Quit
            
            #; For each abstract syntax (there should only be 1 per presentation context)
            Set tASIndex="" For {
                
                Set tASIndex=$Order(pREQUEST($$$PRESENTATIONCONTEXT,tPCIndex,$$$ABSTRACTSYNTAX,tASIndex)) If tASIndex="" Quit
                
                #; Get the PresentationContextId
                Set tPresentationContextId=pREQUEST($$$PRESENTATIONCONTEXT,tPCIndex,"id")
                Set pACCEPT($$$PRESENTATIONCONTEXT,tPCIndex,"id")=tPresentationContextId
                
                #; Get the Abstract syntax for this PC
                Set tAbstractSyntax=pREQUEST($$$PRESENTATIONCONTEXT,tPCIndex,$$$ABSTRACTSYNTAX,tASIndex,"name")
                
                #; Get the array of transfer syntaxes
                Kill tTransferSyntaxes Merge tTransferSyntaxes=pREQUEST($$$PRESENTATIONCONTEXT,tPCIndex,$$$TRANSFERSYNTAX)
                
                Set tAccepted=0
                
                #; Ask the AssociationContext object to determine acceptability of the proposed presentation context
                If pAC.OnAcceptPresentationContext(tAbstractSyntax,.tTransferSyntaxes,.tSelectedTransferSyntax,.tAbstractSyntaxSupported)=0
                {
	                If tAbstractSyntaxSupported {
		                
		                #; There was no matching transfer syntax
                    	Set pACCEPT($$$PRESENTATIONCONTEXT,tPCIndex,"result")=$$$PCTRANSFERSYNTAXNOTSUPPORTED
	                
	                } Else {
		                
	                    #; Reject the abstract syntax
	                    Set pACCEPT($$$PRESENTATIONCONTEXT,tPCIndex,"result")=$$$PCABSTRACTSYNTAXNOTSUPPORTED
	                }
            
                } Else {
                
                    #; Accept the abstract syntax
                    Set pACCEPT($$$PRESENTATIONCONTEXT,tPCIndex,"result")=$$$PCACCEPTANCE
        
                    #; Indicate the Transfer syntax selected by the user
                    Set pACCEPT($$$PRESENTATIONCONTEXT,tPCIndex,$$$TRANSFERSYNTAX,1,"name")=tSelectedTransferSyntax
                    
                    #; At least one PC is acceptable
                    Set (tAccepted,pAnyAcceptable) = 1
                }
                
                Do ..TraceMessage($$$Detail,"Abstract Syntax ("_tAbstractSyntax_") - "_$Case(tAccepted,1:"Accepted",:"Rejected"))
            }
        }   
    } catch {
        Set tSC=$$$EnsSystemError
    }   
        
    Quit tSC
}

/// Write a message to the console
Method TraceMessage(pVerbosity As %Integer, pMessage As %String)
{
    #dim tIO
    if (pVerbosity<=..TraceVerbosity) {
        Set tIO=$IO Use $Principal $$$catTRACE(pVerbosity,pMessage) Use tIO
    }
}

/// Get the Peer Address
Method GetPeerAddress() As %String [ Internal, Private ]
{
    #dim tRetVal,tIO As %String = ""
    try {
        Set tIO=$IO Use ..IPDevice Set tRetVal=$System.TCPDevice.PeerAddr() Use tIO
    } catch {
    }
    Quit tRetVal
}

/// This user callback method is called just before %OnClose()
Method OnTearDown() As %Status
{
    #dim tSC As %Status = $$$OK 
    #dim tBytes,tType As %String
    try {
        
        #; If the association is not established, nothing to do
        If ..AssociationIsEstablished=0 Quit
        
        #; Send a release request
        Set tSC=..SendARELEASERQ() If $$$ISERR(tSC) Quit
        
        #; Accept the expected release reply with the accept/release timeout
        Set tSC=..AcceptPDU(.tBytes,..ARTIM) If $$$ISERR(tSC) Quit
        
        #; Decompose the PDU
        Set tSC=..DecomposePDU(tBytes,.tType) If $$$ISERR(tSC) Quit
        
    } catch {
        
        Set tSC=$$$EnsSystemError
    }
    
    #; Always reset the device
    Quit ..ResetDevice()
}

Method OnDeviceDisconnected() As %Status
{
    #dim tSC As %Status = $$$OK
    If (..State'="State13")&&(..State'=$$$NOSTATE) 
    {
        Set tSC=..BusinessHost.OnAdapterErrored($$$EnsError($$$EnsDICOMPeerClosedConnection))
    }
    Quit tSC
}

/// This method records details regarding an error situation so the correct abort information
/// can be sent to the peer.
Method RecordAbortDetails(pSource As %Integer, pReason As %Integer)
{
    Set ..AbortSource=pSource,..AbortReason=pReason
    Quit
}

/// This method is called when the timeout expires
Method OnDeviceTimeout(pShouldQuit As %Boolean) As %Status
{
    #dim tSC As %Status = $$$OK
    do {
        If ..State="State2" {
            
            #; ARTIM expired
            Set tSC=$$$EnsError($$$EnsDICOMAcceptReleaseTimerExpired)
            
            #; Reset the device
            Do ..ResetDevice()
            
            Set ..State=$$$NOSTATE
            
        } elseif ..State="State5"||(..State="State7") {
            
            #; ARTIM expired
            Set tSC=$$$EnsError($$$EnsDICOMAcceptReleaseTimerExpired)
                    
            #; Inform the adapter
            Do ..BusinessHost.OnAdapterErrored(tSC)
            
            #; Reset the device
            Do ..ResetDevice()
            
            Set ..State=$$$NOSTATE  
        }
        
    } while (0) 
    Quit $$$OK
}

}

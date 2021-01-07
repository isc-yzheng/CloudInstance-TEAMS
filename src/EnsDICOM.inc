ROUTINE EnsDICOM [Type=INC]
#; DICOM Specific Definitions
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#include EnsDICOMErrors
 
#define INFINITE -1

#define ThrowPropertyDoesNotExistError(%property) Do $ZU(96,3,149,1,"",%property)
#define ThrowPropertyIsUndefinedError(%property) Do $ZU(96,3,9,1,%property)
#define MANGLE(%name) ($Translate($Extract(%name),"0123456789_","zottffss")_$Translate($Extract(%name,2,$Length(%name)),"_"))
 
#define Terse   1_":"_$zobjclass()_$J
#define Verbose 2_":"_$zobjclass()_$J 
#define Detail  3_":"_$zobjclass()_$J

#define InitTracing(%debug) ##continue
	If %debug=1 { Set ^Ens.Debug("TraceCat",$$$Terse)=1,^($$$Verbose)=0,^($$$Detail)=0} ##continue
	elseif %debug=2 { Set ^Ens.Debug("TraceCat",$$$Terse)=1,^($$$Verbose)=1,^($$$Detail)=0 } ##continue
	elseif %debug=3 { Set ^Ens.Debug("TraceCat",$$$Terse)=1,^($$$Verbose)=1,^($$$Detail)=1 } ##continue
	else { Kill ^Ens.Debug("TraceCat",$$$Terse),^($$$Verbose),^($$$Detail) } 
	
#; LVD array macros
#define vaSchemaGbl       ^EnsEDI.DICOM.Schema
#define vaSchemaDescGbl   ^EnsEDI.DICOM.Description

#define AdapterName 	"EnsLib.DICOM.Adapter.TCP"
#define NOSTATE     	"State0"

#; PDU types from DICOM TCP Protocol
#define AASSOCIATERQ		1
#define AASSOCIATEAC		2
#define AASSOCIATERJ		3
#define PDATATF				4
#define ARELEASERQ			5
#define ARELEASERP			6
#define AABORT				7

#; Peer Roles
#define SERVICECLASSUSER						0
#define SERVICECLASSPROVIDER					1

#; For use with A-ASSOCIATE-AC (Presentation Context)
#define PCACCEPTANCE							0
#define PCUSERREJECTION							1
#define PCNOREASON								2
#define PCABSTRACTSYNTAXNOTSUPPORTED			3
#define PCTRANSFERSYNTAXNOTSUPPORTED			4

#; For use with A-ABORT PDU
#define ABORTSOURCESERVICEUSER					0
#define ABORTSOURCESERVICEPROVIDER				2

#define ABORTREASONNOTSPECIFIED					0
#define ABORTREASONUNRECOGNIZEDPDU				1
#define ABORTREASONUNEXPECTEDPDU				2
#define ABORTREASONRESERVED						3
#define ABORTREASONUNRECOGNIZEDPDUPARAMETER 	4
#define ABORTREASONUNEXPECTEDPDUPARAMETER   	5
#define ABORTREASONINVALIDPDUPARAMETERVALUE 	6

#; ------------------------------------------------------
#; For use with A-ASSOCIATE-RJ PDU
#define REJECTSOURCESERVICEUSER							1

#; Reasons for use with $$$REJECTSOURCSERVICEUSER

#; 1 - no-reason-given
#define REJECTREASONNOREASONGIVEN					    1

#; 2 - application-context-name-not-supported
#define REJECTREASONAPPLICATIONCONTEXTNAMENOTSUPPORTED 	2

#; 3 - calling-AE-title-not-recognized
#define REJECTREASONULCALLINGAETNOTRECOGNIZED			3

#; 7 - called-AE-title-not-recognized
#define REJECTREASONULCALLEDAETNOTRECOGNIZED  			7

#; ------------------------------------------------------

#define REJECTSOURCESERVICEPROVIDER						2

#; Reasons for use with $$$REJECTSOURCESERVICEPROVIDER

#; 1 - no-reason-given
#define REJECTREASONACSENOREASONGIVEN					1

#; 2 - protocol-version-not-supported
#define REJECTREASONACSEPROTOCOLVERSIONOTSUPPORTED		2

#; ------------------------------------------------------

#define REJECTSOURCESERVICEPROVIDERPRSN					3

#; Reasons for use with $$$REJECTSOURCESERVICEPROVIDERPRSN

#; 1 - temporary-congestion
#define	REJECTREASONPRSNTEMPORARYCONGESTION				1

#; 2 - local-limit-exceeded
#define REJECTREASONPRSNLOCALLIMITEXCEEDED				2		

#; ------------------------------------------------------

#; Item types from DICOM TCP Protocol
#define ASSOCIATIONCONTEXT		  0
#define APPLICATIONCONTEXT 		 16
#define PRESENTATIONCONTEXT		 32
#define PRESENTATIONCONTEXTREPLY 33
#define ABSTRACTSYNTAX			 48
#define TRANSFERSYNTAX		     64
#define USERINFORMATION		     80

#; User Information Sub Item Types
#define USERLEN			81
#define USERIMP			82
#define USERVER			85

#; Abstract syntaxes
#define VerificationSOPClass			"1.2.840.10008.1.1"

#; Transfer Syntaxes
#define IMPLICITVRLETRANSFERSYNTAX		"1.2.840.10008.1.2"
#define RAWDATAEXPLICITVRLTLENDIAN		"1.2.840.10008.1.2.1"
#define DEFLATEDEXPLICITVRLTLENDIAN     "1.2.840.10008.1.2.1.99"
#define RAWDATAEXPLICITVRBIGENDIAN		"1.2.840.10008.1.2.2"
#define PAPYRUSIMPLICITVRLTLENDIAN		"1.2.840.10008.1.20"

#; for encapsulated transfer syntaxes: the overall transfer syntax is explicit vr, little-endian

#; JPEG transfer syntaxes
#define TRANSFERSYNTAXISJPEG(%ts)     $Select($Get(^EnsDICOM.Dictionary("ts","u",%ts))["JPEG":1,1:0)

#; RLE transfer syntax
#define RLECOMPRESSION                  "1.2.840.10008.1.2.5"
#define TRANSFERSYNTAXISRLE(%ts)       $Case(%ts,$$$RLECOMPRESSION:1,:0)

#; MIME transfer syntax
#define MIMEENCAPSULATION				"1.2.840.10008.1.2.6.1"
#define TRANSFERSYNTAXISMIME(%ts)		$Case(%ts,$$$MIMEENCAPSULATION:1,:0)

#; XML transfer syntax
#define XMLENCODING						"1.2.840.10008.1.2.6.2"
#define TRANSFERSYNTAXISXML(%ts)		$Case(%ts,$$$XMLENCODING:1,:0)

#; JPIP transfer syntaxes
#define JPIPREFERENCED					"1.2.840.10008.1.2.4.94"
#define DEFLATEDJPIPREFERENCED			"1.2.840.10008.1.2.4.95"
#define TRANSFERSYNTAXISJPIP(%ts)		$Case(%ts,$$$JPIPREFERENCED:1,$$$DEFLATEDJPIPREFERENCED:1,:0)

#; MPEG2 image compression transfer syntax
#define MPEG2IMAGECOMPRESSION           "1.2.840.10008.1.2.4.100"
#define MPEG2IMAGECOMPRESSIONHL			"1.2.840.10008.1.2.4.101"
#define TRANSFERSYNTAXISMPEG2IMAGECOMPRESSION(%ts) $Case(%ts,$$$MPEG2IMAGECOMPRESSION:1,$$$MPEG2IMAGECOMPRESSIONHL:1,:0)

#; MPEG4 image compression transfer syntax
#define MPEG4IMAGECOMPRESSION			"1.2.840.10008.1.2.4.102"
#define MPEG4IMAGECOMPRESSIONBDCOMPAT	"1.2.840.10008.1.2.4.103"
#define MPEG4IMAGECOMPRESSION2DVIDEO	"1.2.840.10008.1.2.4.104"
#define MPEG4IMAGECOMPRESSION3DVIDEO	"1.2.840.10008.1.2.4.105"
#define MPEG4IMAGECOMPRESSIONSTEREO		"1.2.840.10008.1.2.4.106"
#define TRANSFERSYNTAXISMPEG4IMAGECOMPRESSION(%ts) $Case(%ts,$$$MPEG4IMAGECOMPRESSION:1,$$$MPEG4IMAGECOMPRESSIONBDCOMPAT:1,$$$MPEG4IMAGECOMPRESSION2DVIDEO:1,$$$MPEG4IMAGECOMPRESSION3DVIDEO:1,$$$MPEG4IMAGECOMPRESSIONSTEREO:1,:0)

#; HEVC video compression transfer syntaxes
#define HEVCIMAGECOMPRESSION			"1.2.840.10008.1.2.4.107"
#define HEVCIMAGECOMPRESSIONMAIN10		"1.2.840.10008.1.2.4.108"
#define TRANSFERSYNTAXISHEVCIMAGECOMPRESSION(%ts)	$Case(%ts,$$$HEVCIMAGECOMPRESSION:1,$$$HEVCIMAGECOMPRESSIONMAIN10:1,:0)

#; any encapsulated transfer syntax
#define TRANSFERSYNTAXISENCAPSULATED(%ts) (($$$TRANSFERSYNTAXISJPEG(%ts)) || ($$$TRANSFERSYNTAXISRLE(%ts)) || ($$$TRANSFERSYNTAXISMPEG2IMAGECOMPRESSION(%ts)) || ($$$TRANSFERSYNTAXISMPEG4IMAGECOMPRESSION(%ts)) || ($$$TRANSFERSYNTAXISHEVCIMAGECOMPRESSION(%ts)) || ($$$TRANSFERSYNTAXISMIME(%ts)) || ($$$TRANSFERSYNTAXISXML(%ts)) || ($$$TRANSFERSYNTAXISJPIP(%ts)) )

#define TRANSFERSYNTAXISSUPPORTED(%ts)  ($Case(%ts,$$$IMPLICITVRLETRANSFERSYNTAX:1,$$$RAWDATAEXPLICITVRLTLENDIAN:1,$$$RAWDATAEXPLICITVRBIGENDIAN:1,$$$DEFLATEDEXPLICITVRLTLENDIAN:1,$$$PAPYRUSIMPLICITVRLTLENDIAN:1,:0) || $$$TRANSFERSYNTAXISENCAPSULATED(%ts))
#define TRANSFERSYNTAXISLTLENDIAN(%ts)  ($Case(%ts,$$$IMPLICITVRLETRANSFERSYNTAX:1,$$$RAWDATAEXPLICITVRLTLENDIAN:1,$$$DEFLATEDEXPLICITVRLTLENDIAN:1,$$$PAPYRUSIMPLICITVRLTLENDIAN:1,:0) || $$$TRANSFERSYNTAXISENCAPSULATED(%ts))
#define TRANSFERSYNTAXISEXPLICIT(%ts)   ($Case(%ts,$$$RAWDATAEXPLICITVRLTLENDIAN:1,$$$RAWDATAEXPLICITVRBIGENDIAN:1,$$$DEFLATEDEXPLICITVRLTLENDIAN:1,:0) || $$$TRANSFERSYNTAXISENCAPSULATED(%ts))
#define TRANSFERSYNTAXBYTEORDERING(%ts) ($Case($$$TRANSFERSYNTAXISLTLENDIAN(%ts),1:$$$LTLENDIAN,:$$$BIGENDIAN))

#; The unique DICOM application context
#define DICOMAPPLICATIONCONTEXTUID 		"1.2.840.10008.3.1.1.1"

#; This value is used for storing binary and long data. For binary data we may need
#; to do byte swapping. This ensures that the data is aligned on a 4 byte boundary whilst
#; taking into account the block storage overhead of cache
#define ALIGNEDCHUNKLEN				   32648

#; NOTE: We will need to register our own unique id here
#define OURUSERIMPLEMENTATIONCLASSUID	$Get(^Ens.Config("DICOM","UIC"),"1.2.840.114475.1")

#; NOTE: Must be an even number of characters not more than 16 characters in length
#define OURUSERVERSION					$Get(^Ens.Config("DICOM","VER"),"ENSDICOM")

#; report a data format error
#define DATAFORMATERROR(%MESSAGE,%STREAM) ##class(EnsLib.DICOM.Util.Reporting).DataFormatError(%MESSAGE,%STREAM)

#; debug stream input
#if 1
#define DEBUGSTREAM(%CLIENT,%OPER,%STREAM,%COUNT) If $Data(^EnsDICOM.Debug("stream")) {Do ##class(EnsLib.DICOM.Util.Reporting).DebugStream(%CLIENT,%OPER,%STREAM,%COUNT)}
#else
#define DEBUGSTREAM(%CLIENT,%OPER,%STREAM,%COUNT)
#endif

#; fixed-length read of %COUNT bytes from pStream into %DEST, setting tSC
#define FIXEDREAD(%CLIENT,%DEST,%COUNT) $$$DEBUGSTREAM(%CLIENT,"Read",pStream,%COUNT) Set %DEST=pStream.Read(%COUNT,.tSC) If '$$$ISERR(tSC),$Length(%DEST)'=%COUNT {Set tSC=$$$DATAFORMATERROR(%CLIENT_": Unexpected end of stream",pStream)}

#; fixed-length peek of %COUNT bytes from pStream into %DEST, setting tSC
#define FIXEDPEEK(%CLIENT,%DEST,%COUNT) $$$DEBUGSTREAM(%CLIENT,"Peek",pStream,%COUNT) Set %DEST=pStream.Peek(%COUNT,.tSC) If '$$$ISERR(tSC),$Length(%DEST)'=%COUNT {Set tSC=$$$DATAFORMATERROR(%CLIENT_": Unexpected end of stream",pStream)}

#; fixed-length skip of %COUNT bytes from pStream, setting tSC
#define FIXEDSKIP(%CLIENT,%COUNT) $$$DEBUGSTREAM(%CLIENT,"Skip",pStream,%COUNT) Set tSC=pStream.Skip(%COUNT)

#; PDV Types
#define PDVCOMMAND	"c"
#define PDVDATASET	"d"

#define DATASETISPRESENT 65278
#define NODATASETPRESENT 257

#; Fill character for PDUs
#define FILLER		 0

#; FileMetaDataVersion (1)
#define FILEMETADATAVERSION $Char(0,1)

#; Fixed PDUs
#define ARELEASERPPDU $Char(6,0,0,0,0,4,0,0,0,0)
#define ARELEASERQPDU $Char(5,0,0,0,0,4,0,0,0,0)

#; Endian stuff
#define LTLENDIAN	0
#define BIGENDIAN	1

#; Direction
#define INBOUND		0
#define OUTBOUND	1

#define BESINT8(%s)   $SCONVERT(%s,"S1",$$$BIGENDIAN)
#define BESINT16(%s)  $SCONVERT(%s,"S2",$$$BIGENDIAN)
#define BESINT32(%s)  $SCONVERT(%s,"S4",$$$BIGENDIAN)

#define 2BESINT8(%i)  $NCONVERT(%i,"S1",$$$BIGENDIAN)
#define 2BESINT16(%i) $NCONVERT(%i,"S2",$$$BIGENDIAN)
#define 2BESINT32(%i) $NCONVERT(%i,"S4",$$$BIGENDIAN)

#define BEUINT8(%s)   $SCONVERT(%s,"U1",$$$BIGENDIAN)
#define BEUINT16(%s)  $SCONVERT(%s,"U2",$$$BIGENDIAN)
#define BEUINT32(%s)  $SCONVERT(%s,"U4",$$$BIGENDIAN)

#define 2BEUINT8(%i)  $NCONVERT(%i,"U1",$$$BIGENDIAN)
#define 2BEUINT16(%i) $NCONVERT(%i,"U2",$$$BIGENDIAN)
#define 2BEUINT32(%i) $NCONVERT(%i,"U4",$$$BIGENDIAN)

#define BEIEEE4(%s)   $SCONVERT(%s,"F4",$$$BIGENDIAN)
#define BEIEEE8(%s)   $SCONVERT(%s,"F8",$$$BIGENDIAN)

#define 2BEIEEE4(%f)  $NCONVERT(%f,"F4",$$$BIGENDIAN)
#define 2BEIEEE8(%d)  $NCONVERT(%d,"F8",$$$BIGENDIAN)

#define LESINT8(%s)   $SCONVERT(%s,"S1",$$$LTLENDIAN)
#define LESINT16(%s)  $SCONVERT(%s,"S2",$$$LTLENDIAN)
#define LESINT32(%s)  $SCONVERT(%s,"S4",$$$LTLENDIAN)

#define 2LESINT8(%i)  $NCONVERT(%i,"S1",$$$LTLENDIAN)
#define 2LESINT16(%i) $NCONVERT(%i,"S2",$$$LTLENDIAN)
#define 2LESINT32(%i) $NCONVERT(%i,"S4",$$$LTLENDIAN)

#define LEUINT8(%s)   $SCONVERT(%s,"U1",$$$LTLENDIAN)
#define LEUINT16(%s)  $SCONVERT(%s,"U2",$$$LTLENDIAN)
#define LEUINT32(%s)  $SCONVERT(%s,"U4",$$$LTLENDIAN)

#define 2LEUINT8(%i)  $NCONVERT(%i,"U1",$$$LTLENDIAN)
#define 2LEUINT16(%i) $NCONVERT(%i,"U2",$$$LTLENDIAN)
#define 2LEUINT32(%i) $NCONVERT(%i,"U4",$$$LTLENDIAN)

#define LEIEEE4(%s)   $SCONVERT(%s,"F4",$$$LTLENDIAN)
#define LEIEEE8(%s)   $SCONVERT(%s,"F8",$$$LTLENDIAN)

#define 2LEIEEE4(%f)  $NCONVERT(%f,"F4",$$$LTLENDIAN)
#define 2LEIEEE8(%d)  $NCONVERT(%d,"F8",$$$LTLENDIAN)

#define PAD2LEN(%s,%l,%c)  $Extract(%s_$Translate($Justify("",%l)," ",%c),1,%l)
#define PADZERO(%s,%c)     $Translate($Justify(%s,%c)," ","0")

#; Convert a tag hhhh,hhhh to an order pair of 16 bit unsigned integers
#define LECOMPOSETAG(%g,%e) $$$2LEUINT16($ZH(%g))_$$$2LEUINT16($ZH(%e))
#define BECOMPOSETAG(%g,%e) $$$2BEUINT16($ZH(%g))_$$$2BEUINT16($ZH(%e))

#define GRPMASK			4294901760
#define ELEMASK			65535
#define TWOPOW16		65536

#define TAG2GRP(%t) 	($ZBOOLEAN(+%t,$$$GRPMASK,1)\$$$TWOPOW16)
#define TAG2ELE(%t) 	($ZBOOLEAN(+%t,$$$ELEMASK,1))
#define MAKETAG(%g,%e)	((%g)*$$$TWOPOW16+(%e))

#; Distinguished tags
#define TAG2TAG(%t)		$$$TAG2EYE($$$PADZERO($ZHex($$$TAG2GRP(%t)),4),$$$PADZERO($ZHex($$$TAG2ELE(%t)),4))

#; Pixel Data = (7FE0,0010)
#define TAGPIXELDATA     2145386512
#define TAGPIXELDATAEYE  "(7FE0,0010)"

#; Make an eye-readable tag
#define TAG2EYE(%g,%e) ("("_%g_","_%e_")")

#; Expand a Tag
#define TAG2EXP(%g,%e) $Piece($Get(^EnsDICOM.Dictionary("e","t",%g,%e),$$$TAG2EYE(%g,%e)),"`")

#define CURRENTNAME(%n) $G(^EnsDICOM.Dictionary("e","o",%n),%n)

#; Expand a TransferSyntax
#define TS2EYE(%ts) $Get(^EnsDICOM.Dictionary("ts","u",%ts),$$$Text("Unknown Transfer Syntax"))

#; Expand an AbstractSyntax
#define AS2EYE(%as) $Get(^EnsDICOM.Dictionary("as","u",%as),$$$Text("Unknown Abstract Syntax"))

#; Test for Binary Value Representation (OX is undocumented)
#define ISBINARYVR(%vr) $Case(%vr,"SS":1,"US":1,"SL":1,"UL":1,"AT":1,"FL":1,"FD":1,"OX":1,"OB":1,"OD":1,"OL":1,"OW":1,"OF":1,"UN":1,:0)

#; Test for needs byte swapping (OX is undocumented)
#define ALIGNMENTVR(%vr) $Case(%vr,"SS":1,"US":2,"SL":4,"UL":4,"AT":1,"FL":4,"FD":8,"OX":1,"OB":1,"OD":8,"OL":4,"OW":2,"OF":4,"UN":1)

#; Test for Pixel representation (OX is undocumented)
#define ISPIXELVR(%vr) $Case(%vr,"OX":1,"OB":1,"OW":1,:0)

#; Test for Long Value Representation (OX is undocumented)
#define ISLONGVR(%vr) $Case(%vr,"OX":1,"OB":1,"OD":1,"OL":1,"OW":1,"OF":1,"SQ":1,"UT":1,"UC":1,"UN":1,:0)

#; Test for EyeReadble Representation
#define ISTEXTVR(%vr) $Case(%vr,"CS":1,"SH":1,"LO":1,"ST":1,"LT":1,"UT":1,"UC":1,"AE":1,"PN":1,"UI":1,"DA":1,"TM":1,"DT":1,"AS":1,"IS":1,"DS":1,:0)

#; Test for allows Undefined Length. (OB/OW depends on transfer syntax: revisit)
#define ALLOWSUNDEFLENVR(%vr) $Case(%vr,"SQ":1,"UN":1,"OB":1,"OW":1,:0)

#; Test for VR for which multiple values are simply concatenated with no backslash
#define VALSCONCATVR(%vr) $Case(%vr,"SS":1,"US":1,"SL":1,"UL":1,"AT":1,"FL":1,"FD":1,:0) 

#; Item delimination identifiers for SQ/Item processing
#define ITMGRP  65534
#define ITMNEW	57344
#define ITMDLM	57357
#define SEQDLM	57565

#; well-known tags
#define ITMBEGTAG ##safeexpression($ZHex("FFFEE000"))
#define ITMENDTAG ##safeexpression($ZHex("FFFEE00D"))
#define SEQENDTAG ##safeexpression($ZHex("FFFEE0DD"))

#define CallerNone     "None"
#define CallerSequence "Sequence"
#define CallerItem     "Item"

#; Undefined Length marker (0xFFFFFFFF)
#define UNDEFINEDLENGTH 4294967295

#; what NameTag returns for an unknown or ambiguous tag name (0xFFFFFFFF)
#define NOTAGID 4294967295

#define UPPERCASE "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define DIGITS    "0123456789"

#; Translate message types
#define MsgTyp2Str(%t) ^EnsDICOM.Dictionary("e","t","0000","0100","e2v",%t)
#define Str2MsgTyp(%s) ^EnsDICOM.Dictionary("e","t","0000","0100","v2e",%s)

#define FORMATFILE	1
#define FORMATDATA	2

#define SERVICE  	1
#define OPERATION 	2
#define PROCESS		3

#; UPS SOP Classes
#define UPSPUSHSOPCLASS					"1.2.840.10008.5.1.4.34.6.1"
#define UPSWATCHSOPCLASS				"1.2.840.10008.5.1.4.34.6.2"
#define UPSPULLSOPCLASS					"1.2.840.10008.5.1.4.34.6.3"
#define UPSEVENTSOPCLASS				"1.2.840.10008.5.1.4.34.6.4"

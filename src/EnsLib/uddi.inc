ROUTINE EnsLib.uddi [Type=INC]
#; Definitions, Macros for EnsLib.UDDI Package
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#; 
#; Find Qualifiers
#define AndAllKeys  		         "AndAllKeys"
#define CaseSensitiveMatch           "CaseSensitiveMatch"
#define CombineCategoryBags		     "CombineCategoryBags"
#define ExactNameMatch		         "ExactNameMatch"
#define OrAllKeys                    "OrAllKeys"
#define OrLikeKeys                   "OrLikeKeys"
#define ServiceSubset                "ServiceSubset"
#define SortByDateAscending          "SortByDateAscending"
#define SortByDateDescending         "SortByDateDescending"
#define SortByNameAscending          "SortByNameAscending"
#define SortByNameDescending         "SortByNameDescending"
 
#;
#; Core tModels - see http://www.uddi.org/taxonomies/Core_Taxonomy_OverviewDoc.htm
#;
#define UddiOrgTypes                 "uddi:uddi.org:categorization:types"
 
#; Conversion Macros
#define ToBoolean(%b)				$Case(%b,"true":1,1:1,:0)

#; Structural Macros
#define PROLOGUE Set tSC=$$$OK,$ZT="Trap",$ZE="" do {
#define EPILOGUE } while (0) ##continue
Exit Quit tSC ##continue
Trap Set $ZT="",tSC=$Select($ZE["<ZSOAP>":%objlasterror,1:$$$ERROR($$$ObjectScriptError,$ZE)) Goto Exit

#; Creation Macros
#define NEW(%o,%c) Kill %objlasterror Set %o=$zobjclassmethod(%c,"%New") If '$IsObject(%o) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,%c)) Quit
#define NEW1(%o,%c,%a) Kill %objlasterror Set %o=$zobjclassmethod(%c,"%New",%a) If '$IsObject(%o) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,%c)) Quit

#; UDDI WebServiceClass Names
#define UDDIPUBLICATIONCLASS	"EnsLib.UDDI.UDDIPublicationSoapBinding"
#define UDDIINQUIRYCLASS        "EnsLib.UDDI.UDDIInquirySoapBinding"
#define UDDISECURITYCLASS       "EnsLib.UDDI.UDDISecuritySoapBinding"

#define URLRESOLVERPOLICYCLASS  "EnsLib.UDDI.URLResolutionPolicy"
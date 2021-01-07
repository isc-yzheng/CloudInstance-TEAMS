ROUTINE HS.IHE.PDQ [Type=INC]
#; IHE PDQ Supplier related Actions
#;
#define PDQv3QueryAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201305UV02",1:"SOAP Action not defined "_%Version)
#define PDQv3QueryResponseAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201306UV02",1:"SOAP Action not defined "_%Version)
#define PDQv3QueryRequest				"PDQv3_QueryRequest"
#define PDQv3QueryResponse			"PDQv3_QueryResponse"
#define PDQv3ContinueAction(%Version) $S(%Version=1:"urn:hl7-org:v3:QUQI_IN000003UV01_Continue",1:"SOAP Action not defined "_%Version)
#define PDQv3ContinueRequest	 		"PDQv3_ContinueRequest"
#define PDQv3ContinueResponse	 		"PDQv3_ContinueResponse"
#define PDQv3ContinueResponseAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:QUQI_IN000003UV01_ContinueResponse",1:"SOAP Action not defined "_%Version)
#define PDQv3CancelAction(%Version) 	$S(%Version=1:"urn:hl7-org:v3:QUQI_IN000003UV01_Cancel",1:"SOAP Action not defined "_%Version)
#define PDQv3CancelRequest 			"PDQv3_CancelRequest"
#define PDQv3CancelResponse 			"PDQv3_CancelResponse"
#define PDQv3CancelResponseAction(%Version) 	$S(%Version=1:"urn:hl7-org:v3:MCCI_IN000002UV01",1:"SOAP Action not defined "_%Version)

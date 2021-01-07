ROUTINE HS.IHE.PIX [Type=INC]
#; IHE PIX Manager related Actions
#;
#define PIXv3AddAction(%Version)		$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201301UV02",1:"SOAP Action not defined "_%Version)
#define PIXv3AddResponseAction(%Version)		$S(%Version=1:"urn:hl7-org:v3:MCCI_IN000002UV01",1:"SOAP Action not defined "_%Version)
#define PIXv3AddRequest				"PIXv3_PatientAddRequest"
#define PIXv3AddResponse			"PIXv3_PatientAddResponse"
#define PIXv3ReviseAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201302UV02",1:"SOAP Action not defined "_%Version)
#define PIXv3ReviseResponseAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:MCCI_IN000002UV01",1:"SOAP Action not defined "_%Version)
#define PIXv3ReviseRequest			"PIXv3_PatientReviseRequest"
#define PIXv3ReviseResponse			"PIXv3_PatientReviseResponse"
#define PIXv3MergeAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201304UV02",1:"SOAP Action not defined "_%Version)
#define PIXv3MergeResponseAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:MCCI_IN000002UV01",1:"SOAP Action not defined "_%Version)
#define PIXv3MergeRequest			"PIXv3_PatientMergeRequest"
#define PIXv3MergeResponse			"PIXv3_PatientMergeResponse"
#define PIXv3QueryAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201309UV02",1:"SOAP Action not defined "_%Version)
#define PIXv3QueryResponseAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201310UV02",1:"SOAP Action not defined "_%Version)
#define PIXv3QueryRequest			"PIXv3_QueryRequest"
#define PIXv3QueryResponse			"PIXv3_QueryResponse"

#define XPIDNotificationRequest					"XPID_NotificationRequest"

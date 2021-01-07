ROUTINE HS.IHE.XCPD [Type=INC]
#; IHE XCPD related Actions
#;
#; the XCA macros are needed by the XCPD processes
#define XCAQueryRequest				"XCA_QueryRequest"
#define XCAQueryResponse			"XCA_QueryResponse"

#define XCPDPatientDiscoveryAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201305UV02:CrossGatewayPatientDiscovery",1:"SOAP Action not defined "_%Version)
#define XCPDPatientDiscoveryResponseAction(%Version)	$S(%Version=1:"urn:hl7-org:v3:PRPA_IN201306UV02:CrossGatewayPatientDiscovery",1:"SOAP Action not defined "_%Version)
#define XCPDPatientDiscoveryRequest		"XCPD_PatientDiscoveryRequest"
#define XCPDPatientDiscoveryResponse	"XCPD_PatientDiscoveryResponse"

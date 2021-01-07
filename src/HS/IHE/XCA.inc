ROUTINE HS.IHE.XCA [Type=INC]
#; IHE XCA related Actions
#;
#define XCAQueryAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:CrossGatewayQuery",1:"SOAP Action not defined "_%Version)
#define XCAQueryResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:CrossGatewayQueryResponse",1:"SOAP Action not defined "_%Version)
#define XCAQueryRequest				"XCA_QueryRequest"
#define XCAQueryResponse			"XCA_QueryResponse"

#define XCARetrieveAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:CrossGatewayRetrieve",1:"SOAP Action not defined "_%Version)
#define XCARetrieveResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:CrossGatewayRetrieveResponse",1:"SOAP Action not defined "_%Version)
#define XCARetrieveRequest			"XCA_RetrieveRequest"
#define XCARetrieveResponse			"XCA_RetrieveResponse"

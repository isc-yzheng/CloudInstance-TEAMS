ROUTINE HS.AU.Common [Type=INC]
#include HS.HC

#; HI 
#define HISearchIHIAction				"http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHI/3.0/ConsumerSearchIHIPortType/searchIHIRequest"
#define HISearchIHIRequest				"HI_SearchIHIRequest"
#define HISearchIHIResponse				"HI_SearchIHIResponse"

#define HISearchIHIBatchSyncAction		"http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHIBatchSync/3.0/ConsumerSearchIHIBatchSyncPortType/searchIHIBatchSyncRequest"
#define HISearchIHIBatchSyncRequest		"HI_SearchIHIBatchSyncRequest"
#define HISearchIHIBatchSyncResponse	"HI_SearchIHIBatchSyncResponse"

#define HICreateProvisionalIHIAction	"http://ns.electronichealth.net.au/hi/svc/ConsumerCreateProvisionalIHI/3.0/ConsumerCreateProvisionalIHIPortType/createProvisionalIHIRequest"
#define HICreateProvisionalIHIRequest	"HI_CreateProvisionalIHIRequest"
#define HICreateProvisionalIHIResponse	"HI_CreateProvisionalIHIResponse"
#define HICreateUnverifiedIHIAction		"http://ns.electronichealth.net.au/hi/svc/ConsumerCreateUnverifiedIHI/3.0.2/ConsumerCreateUnverifiedIHIPortType/createUnverifiedIHIRequest"
#define HICreateUnverifiedIHIRequest	"HI_CreateUnverifiedIHIRequest"
#define HICreateUnverifiedIHIResponse	"HI_CreateUnverifiedIHIResponse"
#define HIMergeProvisionalIHIAction		"http://ns.electronichealth.net.au/hi/svc/ConsumerMergeProvisionalIHI/3.0/ConsumerMergeProvisionalIHIPortType/mergeProvisionalIHIRequest"
#define HIMergeProvisionalIHIRequest	"HI_MergeProvisionalIHIRequest"
#define HIMergeProvisionalIHIResponse	"HI_MergeProvisionalIHIResponse"

#define HINotifyDuplicateIHIAction		"http://ns.electronichealth.net.au/hi/svc/ConsumerNotifyDuplicateIHI/3.2.0/ConsumerNotifyDuplicateIHIPortType/notifyDuplicateIHIRequest"
#define HINotifyDuplicateIHIRequest		"HI_NotifyDuplicateIHIRequest"
#define HINotifyDuplicateIHIResponse	"HI_NotifyDuplicateIHIResponse"

#define HINotifyReplicaIHIAction		"http://ns.electronichealth.net.au/hi/svc/ConsumerNotifyReplicaIHI/3.2.0/ConsumerNotifyReplicaIHIPortType/notifyReplicaIHIRequest"
#define HINotifyReplicaIHIRequest		"HI_NotifyReplicaIHIRequest"
#define HINotifyReplicaIHIResponse		"HI_NotifyReplicaIHIResponse"

#define HIResolveProvisionalIHIAction	"http://ns.electronichealth.net.au/hi/svc/ConsumerResolveProvisionalIHI/3.0.2/ConsumerResolveProvisionalIHIPortType/resolveProvisionalIHIRequest"
#define HIResolveProvisionalIHIRequest	"HI_ResolveProvisionalIHIRequest"
#define HIResolveProvisionalIHIResponse	"HI_ResolveProvisionalIHIResponse"

#define HIUpdateIHIAction				"http://ns.electronichealth.net.au/hi/svc/ConsumerUpdateIHI/3.2.0/ConsumerUpdateIHIPortType/updateIHIRequest"
#define HIUpdateIHIRequest				"HI_UpdateIHIRequest"
#define HIUpdateIHIResponse				"HI_UpdateIHIResponse"

#define HIUpdateProvisionalIHIAction	"http://ns.electronichealth.net.au/hi/svc/ConsumerUpdateProvisionalIHI/3.0/ConsumerUpdateProvisionalIHIPortType/updateProvisionalIHIRequest"
#define HIUpdateProvisionalIHIRequest	"HI_UpdateProvisionalIHIRequest"
#define HIUpdateProvisionalIHIResponse	"HI_UpdateProvisionalIHIResponse"

#define PCEHRDoesPCEHRExistAction		"http://ns.electronichealth.net.au/pcehr/svc/PCEHRProfile/1.1/PCEHRProfilePortType/doesPCEHRExistRequest"
#define PCEHRDoesPCEHRExistRequest		"PCEHR_DoesPCEHRExistRequest"
#define PCEHRDoesPCEHRExistResponse		"PCEHR_DoesPCEHRExistResponse"

#define PCEHRGainPCEHRAccessAction		"http://ns.electronichealth.net.au/pcehr/svc/PCEHRProfile/1.1/PCEHRProfilePortType/gainPCEHRAccessRequest"
#define PCEHRGainPCEHRAccessRequest		"PCEHR_GainPCEHRAccessRequest"
#define PCEHRGainPCEHRAccessResponse	"PCEHR_GainPCEHRAccessResponse"

#define HISearchIndividualProviderAction		"http://ns.electronichealth.net.au/hi/svc/ProviderSearchForProviderIndividual/5.0.0/ProviderSearchForProviderIndividualPortType/searchForProviderIndividualRequest"
#define HISearchIndividualProviderRequest		"HI_SearchIndividualProviderRequest"
#define HISearchIndividualProviderResponse		"HI_SearchIndividualProviderResponse"

#define HISearchOrganisationProviderAction		"http://ns.electronichealth.net.au/hi/svc/ProviderSearchForProviderOrganisation/5.0.0/ProviderSearchForProviderOrganisationPortType/searchForProviderOrganisationRequest"
#define HISearchOrganisationProviderRequest		"HI_SearchOrganisationProviderRequest"
#define HISearchOrganisationProviderResponse	"HI_SearchOrganisationProviderResponse"

ROUTINE HS.HC [Type=INC]
#include Ensemble
#include EnsUtil
#include HS.HC.Errors
#include HS.Upgrade
#include %ZHSLIB
#; previously $$$HSLIB was implemented as ##class(HS.Util.Installer).findHSLib() which returned "HSLIB" updating to a macro
#define HSLIB "HSLIB"
#; Namespace is a Hub
#define IsHub (($G(^%SYS("HealthShare","Instances",$namespace,"Type"))="Hub") || (($G(^%SYS("HealthShare","Instances",$namespace,"Type"))="Foundation") && (##class(HS.Util.Installer.ConfigItem).%OpenId($namespace).Products.Count()=0)))
#define OIDMapCacheNS $S((($G(^%SYS("HealthShare","Instances",$namespace,"Type"))="Foundation") && (##class(HS.Util.Installer.ConfigItem).%OpenId($namespace).Products.Count()=0)):$namespace,1:"HSSYS")
#;
#def1arg HSError(%args) $$$EnsError(%args)
#def1arg HSErrorNoLog(%args) $$$ERROR(##safeexpression($$macroERRORArgList^%occMsgXML(%literalargs,1)))
#def1arg HSThrowError(%sc) Throw:$$$ISERR(%sc) ##class(%Exception.StatusException).CreateFromStatus(%sc)
#;
#define HSThrowErrors(%Status) Throw:$$$ISERR(%Status) ##class(%Exception.StatusException).CreateFromStatus(%Status)

#define HSSecureURL(%host, %port, %prefix) ("https://"_%host_$s((%port="")||(%port=443):"",1:":"_%port)_$s(%prefix="":"", 1:"/"_%prefix))
#define HSSecureRootURL  $$$HSSecureURL($$$HSSecureHostName, $$$HSSecurePort, $$$HSSecurePrefix)

#define HSDebug 0

#define HomeCommunity				##class(HS.IHE.Util).GetHomeCommunity()
#define HomeCommunityOID			$$$HomeCommunityOIDGet($$$HomeCommunity)
#define HomeCommunityOIDGet(%arg)	##class(HS.Data.OIDMap).OIDForType(%arg,"HomeCommunity")
#define AffinityDomain				##class(HS.IHE.Util).GetAffinityDomain()
#define AffinityDomainOID			$$$AffinityDomainOIDGet($$$AffinityDomain)
#define AffinityDomainOIDGet(%arg)  ##class(HS.Data.OIDMap).OIDForType(%arg,"AssigningAuthority")

#define GetTransformer(%1) 	Set %1 = $select($IsObject($get(%healthshare("Transformer"))): %healthshare("Transformer"), 1: ##class(HS.Util.XSLTTransformer).%New()),%healthshare("Transformer")=%1

#; Namespace is a Bus
#define IsBus ($G(^%SYS("HealthShare","Instances",$namespace,"Type"))="Bus")
#;don't use these in the installer or other places that switch namespace
#define IsEdgeGW ($$$HSThisNSType="EdgeGateway")
#define IsAccessGW ($$$HSThisNSType="AccessGateway")
#define HSThisNSType $S($D(%HSNSType):%HSNSType,$D(^%SYS("HealthShare","Instances",$namespace,"Type"),%HSNSType):%HSNSType)

#; this belongs in HS.IHE.ATNA.inc but causes a circular reference
#; returns a boolean, and if it's the audit instance, the database of the audit repository
#define IsAuditInstance(%DB) ##class(%ZHSLIB.HealthShareMgr).IsAuditInstance(.%DB)
#; Write (to current device) only if in programmers mode
#define Write Write:$zjob\1#2
#define WriteProg $zjob\1#2

#define NVPairToList(%PairArray) ##Class(HS.Util.SystemAPIMethods).NVPairToList(.%PairArray)
#define HSNSType(%NS) $G(^%SYS("HealthShare","Instances",%NS,"Type"))
#; used during repetitive operations, versus installation which would use ValidateComponentStatus
#define CheckComponentStatus(%Component) ##class(HS.Util.Installer).ComponentStatus(%Component)
#; used during installation / configuration
#define ValidateComponentStatus(%Component,%Licensed,%Revalidate) ##class(HS.Util.Installer).ComponentStatus(%Component,%Licensed,%Revalidate)

#; is HealthShare feeding analytics
#define AnalyticsFeed ##class(HS.Registry.Config).GetKeyValue("\AnalyticsFeed",0)
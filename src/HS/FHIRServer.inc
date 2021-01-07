ROUTINE HS.FHIRServer [Type=INC]
#include HS.FHIRServer.Errors
#include HS.FHIRMeta

#define CurrentClass         $classname()
#define CurrentMethod        ##safeexpression(""""_$get(%methodname)_"""")

#define FHIRContentCodeJSON "JSON"
#define FHIRContentCodeXML "XML"
#define FHIRContentCodeForm "Form"
#define FHIRContentCodeXPatch "XPatch"
#define FHIRContentCodeJPatch "JPatch"

/// Debug Flags provided in the DebugMode configuration item
#define FHIRDebugAllowNoAuthCheck	4
#define FHIRDebugNewInstance		2
#define FHIRDebugIncludeTracebacks	1



#define DefaultSessionId "_"

#define FSLogGlobal ^FSLOG
#define FSChanGlobal ^FSLogChannel

#define FSChannelGeneral "Msg"
#define FSChannelSQL "SQL"
#define FSChannelInclude "_include"
#define FSChannelCritSec "CritSec"

#define FSChannelList  $LB($$$FSChannelGeneral, $$$FSChannelSQL, $$$FSChannelInclude, $$$FSChannelCritSec)

#define FSLogSQL(%msg) $$$FSDebug($$$FSChannelSQL, %msg)
#define FSLogInclude(%msg) $$$FSDebug($$$FSChannelInclude, %msg)
#define FSLogCritSec(%msg) $$$FSDebug($$$FSChannelCritSec, %msg)
#define FSLog(%msg) $$$FSDebug($$$FSChannelGeneral, %msg)
#define FSLogIsActive(%chan) ($Get($$$FSChanGlobal("all")) || $Get($$$FSChanGlobal(%chan))) 

#define FSDebug(%chan, %msg) if $$$FSLogIsActive(%chan) { set $$$FSLogGlobal($I($$$FSLogGlobal))=$$$CurrentMethod_"^"_$$$CurrentClass_"^"_$Job_"|"_%chan_"|"_%msg }

#define FSLogStream(%msg, %stream) set $$$FSLogGlobal($I($$$FSLogGlobal))=$$$CurrentMethod_"^"_$$$CurrentClass_"|"_%msg_"; "_$E(##class(HS.Util.StreamUtils).EnsureString(%stream),1,100)
#define FSLogEx(%ex) Do %ex.StackAsArray(.eXiXa) for eXiX=1:1:%ex { Set $$$FSLogGlobal($I($$$FSLogGlobal))="    :: "_eXiXa(eXiX) }
#define ParseToJSON(%s) ##class(%Library.DynamicAbstractObject).%FromJSON(%s)
#define NewJSONObject ##class(%Library.DynamicObject).%New()
#define NewJSONArray ##class(%Library.DynamicArray).%New()
#define FormatJSON(%json) ##class(HS.FHIRServer.Util.JsonHelper).ToJSONString(%json)
#define FormatJSONToStream(%json,%stream) Do ##class(HS.FHIRServer.Util.JsonHelper).ToJSONStream(%json,%stream)

#def1Arg ThrowFHIR(%arglist) $$$ThrowStatus($$$ERROR(%arglist))
#define FHIRAddError(%to, %err) Set %to = $System.Status.AppendStatus(%to, %err)

#define AppKeyFromApp(%app) $Select($E(%app,*)="/":$E(%app,1,*-1), 1:%app)

/// INTERNAL - Build key
#define BuildRsrcKey(%type, %id)  (%type _ "/" _ %id) 
#define BuildRsrcVerKey(%type, %id, %vid)  ($$$BuildRsrcKey(%type,%id) _ "/" _ %vid)
#define CollateSQLUpper(%s) $system.Util.Collation(%s, 7)


#define OutcomeIs(%http, %severity, %code) "|"_%http_"|"_%severity_"|"_%code
#define OutcomeWithPath(%http, %severity, %code, %path) $$$OutcomeIs(%http,%severity,%code)_"|"_%path
#define OutcomeInvalidPath(%path) $$$OutcomeInvalid(400)_"|"_%path
#define HttpIs(%http) "|"_%http
#define OutcomeNotFound     $$$OutcomeIs(404, "error", "not-found")
#define OutcomeNotSupported(%http) $$$OutcomeIs(%http, "error", "not-supported")
#define OutcomeInvalid(%http)      $$$OutcomeIs(%http, "error", "invalid")
#define HttpOnlyResponse(%http) $$$HSFHIRErrHttpOnlyResponse, $$$HttpIs(%http)

/// Macros defining the scope of a FHIR Request
#define ReqScopeInstance "Instance"
#define ReqScopeType "Type"
#define ReqScopeSystem "System"

/// Macros to manipulate the FHIR Session key (which is 2-part)
#define FHIRSessionKey(%app, %id)  $ListBuild(%app, %id)
#define FHIRSessionApp(%key) $ListGet(%key, 1)
#define FHIRSessionId(%key) $ListGet(%key, 2)
#define FHIRSessionString(%key) $Select(%key="":"_", 1:$ListToString(%key, "||"))


#def1arg FHIRLOGERROR(%param) $$$FSLog(%param)
#def1arg FHIRLOGWARNING(%param) $$$FSLog(%param)

/// ----- Macros for Indexes into GetResourceMeta result $LIST
#define IxRsrcObjectKey 1 
#define IxRsrcVersionId 2 
#define IxRsrcIsDeleted 3 
#define IxRsrcIsCurrent 4 
#define IxRsrcLastModified 5
#define IxRsrcVerb 6

#define RsrcMetaObjectKey(%meta)  $ListGet(%meta, $$$IxRsrcObjectKey)
#define RsrcMetaVersionId(%meta) $ListGet(%meta, $$$IxRsrcVersionId)
#define RsrcMetaIsDeleted(%meta) $ListGet(%meta, $$$IxRsrcIsDeleted)
#define RsrcMetaIsCurrent(%meta) $ListGet(%meta, $$$IxRsrcIsCurrent)
#define RsrcMetaLastModified(%meta) $ListGet(%meta, $$$IxRsrcLastModified)
#define RsrcMetaVerb(%meta)      $ListGet(%meta, $$$IxRsrcVerb)


///------ Macros for Config UI
#define StartCapture(%cookie) $$$ThrowOnError(##class(%ZHSLIB.PackageManager.Developer.Utils).BeginCaptureOutput(%cookie))
#define EndCapture(%cookie) if $get(%cookie)'= "" $$$ThrowOnError(##class(%ZHSLIB.PackageManager.Developer.Utils).EndCaptureOutput(%cookie))
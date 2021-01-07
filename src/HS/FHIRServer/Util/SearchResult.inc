ROUTINE HS.FHIRServer.Util.SearchResult [Type=INC]

#define SearchResultColDeleted 1
#define SearchResultColKey 2
#define SearchResultColResourceType 3
#define SearchResultColResourceId 4
#define SearchResultColVersionId 5
#define SearchResultColMode 6
#define SearchResultColVerb 7
#define SearchResultColJson 8
#define SearchResultColReferredToBy 9

#define SearchResultAddCol(%name, %index) if ..%AddColumn(%name, "%String") '= %index { $$$ThrowFHIR($$$GeneralError, "Unexpected column number for "_%name) }


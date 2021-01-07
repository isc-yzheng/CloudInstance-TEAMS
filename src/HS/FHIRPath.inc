ROUTINE HS.FHIRPath [Type=INC]
#include HS.FHIRPath.Errors


#define CollGetValueAt(%coll, %index) %coll(%index)
#define CollGetTypeAt(%coll, %index) %coll(%index,"t")
#define CollPushValue(%coll, %value, %t) Set %coll($I(%coll))=%value  Set %coll(%coll,"t")=%t
#define CollPushBoolean(%coll, %value) $$$CollPushValue(%coll,%value,"boolean")
#define CollPushString(%coll, %value) $$$CollPushValue(%coll,%value,"string")
#define CollPushNumber(%coll, %value) $$$CollPushValue(%coll,%value,"integer")
#define CollPushFromColl(%coll, %fromcoll, %fromix)   Merge %coll($I(%coll))=%fromcoll(%fromix)
#define CollIsBoolean(%coll,%index) ($$$CollGetTypeAt(%coll,%index)="boolean")
#define CollIsString(%coll,%index) (..fhirTypeToJsonType($$$CollGetTypeAt(%coll,%index)="s"))
#define CollIsNumber(%coll,%index) (..fhirTypeToJsonType($$$CollGetTypeAt(%coll,%index))="n")
#define CollIsInteger(%coll,%index) ($$$CollGetTypeAt(%coll,%index)="integer")


ROUTINE EnsEDI [Type=INC]
#; EnsEDI.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#Include Ensemble
#Include EnsEDIErrors
 
#; LVD array macros
#ifdef LOCALMAPS
#define vaTempInstanceGbl    
#define vaMgetIndex		 	
#define vaMkill		 
#def1arg vaM(%args)        ..%maps(%args)
#define vaMobj(%o,%m)      %o.%maps(%m)
#define vaMobja(%o,%m,%a)  %o.%maps(%m,%a)
#else
#define vaMgetIndex        Set i%%maps=$I($$$vaTempInstanceGbl("maps"))
#define vaMkill            Kill $$$vaTempInstanceGbl("maps",..%maps)
#def1arg vaM(%args)        $$$vaTempInstanceGbl("maps",..%maps,%args)
#define vaMobj(%o,%m)      $$$vaTempInstanceGbl("maps",%o.%maps,%m)
#define vaMobja(%o,%m,%a)  $$$vaTempInstanceGbl("maps",%o.%maps,%m,%a)
#endif
 
#define vaIsOref(%seg)   ("@"=$E(%seg))
#define vaIsIndex(%path) (+%path=%path||$S("("=$E(%path)&&(")"=$E(%path,*)):+$E(%path,2,*-1)=$E(%path,2,*-1),1:0))
#define vaIndex(%path)   $S("("=$E(%path)&&(")"=$E(%path,*)):$E(%path,2,*-1),1:%path)

#; Get SegId|SegType from runtimeIndex, or if blank then from "segs" storage of object %objid. (%objid should be the current object if saved, otherwise the object the current object was cloned from, if any)
#; Make sure that "" gets returned and not "|" or "|SegType"
#define vaSegLookthru(%index,%objid)  $S(""'=$P($G($$$vaM("runtimeIndex",%index)),"|"):$$$vaM("runtimeIndex",%index), $G($$$vaExtentGbl(%objid,"segs",%index)):$$$vaExtentGbl(%objid,"segs",%index)_$S(""=$P($G($$$vaM("runtimeIndex",%index)),"|",2):"", 1:"|"_$P($$$vaM("runtimeIndex",%index),"|",2)), 1:"")
 
#; LVD array schema macros for default SEF
#define vaSchemaGbl       ^EnsEDI.Schema
#define vaSchemaDescGbl   ^EnsEDI.Description
 
#; Notes on LVD (Large Virtual Document) implementation
#; In runtimeIndex, id means look in the corresponding spot in $$$vaSegmentGbl
#; In runtimeIndex, @ means look in the corresponding spot in mapOrefs
#; In runtimeIndex, empty first piece means look through to the corresponding slot in $$$vaExtentGbl(..%Id(),"segs")
#; If we are a clone, look through instead to the clonee's slot at $$$vaExtentGbl(..%ClonedId,"segs")
#; In runtimePath, id means look in the corresponding spot in $$$vaSegmentGbl
#; In runtimePath, @n means look in the slot n in mapOrefs
#;
#; Unsaved Doc will never have "segs" lookthroughs unless cloned from a saved Doc
#; Because saved Doc is immutable, it is safe to share index lookthrough to "segs" storage with a mutable clone
#;
#; Re-order mapOrefs and refs from Path when (re)building Index map
#; Store mapOrefs at negative index when inserting orefs in Path mode. (This eliminates the need for collision avoidance in re-ordering when building Index map)
#;
#; When saving, lookthrough to Cloned segs in case we are saving for the first time
#; When switching to Path-only mode, the PathMap has no lookthroughs so when we save we will rebuild the segs map completely
#;
#; $$$vaM("runtimePath") = ^IRIS.Temp map array for runtime path to segment
#; $$$vaM("runtimeIndex") = ^IRIS.Temp map array for runtime index to segment; will always be defined unless mapRuntimePath is defined
#; $$$vaM("bidirectionalLink") = ^IRIS.Temp map array for runtime path and index linkage

#define REFSEGFLDINDEX 1
#define REFSEGFLDCOUNT 2
#define MAXSEG 32767
#define MAXEDIARRAYSUBSCRIPT	230
 
 
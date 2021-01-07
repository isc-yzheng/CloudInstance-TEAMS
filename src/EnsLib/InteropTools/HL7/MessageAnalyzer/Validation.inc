ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.Validation [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
/// where the information needed to decode status message definitions is stored
#define VSMROOT ^||Ens.MAVSM

/// used by RegisterPatterns methods
#define RPPATTERN(%pattern) Set RPPATTERN=%pattern_"~"
#define RPADDRECORD(%regex,%class,%varnames) Set pRecords(RPPATTERN,$I(pRecords(RPPATTERN)))=$ListBuild(%regex,%class,%varnames)

/// list offsets for segment structure field definition
#define SSFDATASTRUCTURE 1
#define SSFSYMBOL 2
#define SSFREPEATCOUNT 3
#define SSFMAXLENGTH 4
#define SSFREQUIRED 5
#define SSFREPEATING 6
#define SSFMINLENGTH 7

/// list offsets for data structure component definition
#define DTCDATASTRUCTURE 1
#define DTCMINLENGTH 2
#define DTCMAXLENGTH 3
#define DTCREQUIRED 4

/// macros for showing label+code+description
#define SSINFOX(%ss) ##class(HL7Configuration).SegmentStructureInfo(%ss)
#define DTINFOX(%dt) ##class(HL7Configuration).DataStructureInfo(%dt)
#define CTINFOX(%ct) ##class(HL7Configuration).CodeTableInfo(%ct)
#define FIELDINFOX(%hc,%ss,%fi) %hc.FieldInfo(%ss,%fi)
#define COMPINFOX(%hc,%dt,%ci) %hc.ComponentInfo(%dt,%ci)

/// macros for showing label+code+description from method arguments and instance properties
#define SSINFO $$$SSINFOX(..SegmentStructure)
#define DTINFO $$$DTINFOX(..DataStructure)
#define CTINFO $$$CTINFOX(..CodeTable)
#define FIELDINFO $$$FIELDINFOX(pHL7Configuration,..SegmentStructure,..FieldIndex)
#define COMPINFO $$$COMPINFOX(pHL7Configuration,..DataStructure,..ComponentIndex)

/// macros for vStats top-level keys
#define VSTATSVALFLAGS "valflags"
#define VSTATSTOTALVALID "totalvalid"
#define VSTATSINVALID "invalid"
#define VSTATSVALFAILCANAUTOFIX "valfailcanautofix"
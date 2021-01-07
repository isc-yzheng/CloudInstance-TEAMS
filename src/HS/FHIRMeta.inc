ROUTINE HS.FHIRMeta [Type=INC]
/// FHIR Metadata Support
#def1Arg ThrowError(%arglist) $$$ThrowStatus($$$ERROR(%arglist))

#define FSMetaGlobal ^HS.FHIRServer.Meta
#define FHIRMetaNode(%md,%key) $Name(@%md.GlobalRoot@(%md.FHIRMetadataSetKey,%key))
/// ------ Macros to access Multidimensional Schema Data (in the Schema object) ------
#define FSMetaVersion(%md)           $$$FHIRMetaNode(%md, "v")
#define FSMetaTypeInfoGlobal(%md)    $$$FHIRMetaNode(%md, "ti")
#define FSMetaSearchParamGlobal(%md) $$$FHIRMetaNode(%md, "sp")
#define FSMetaCompartmentGlobal(%md) $$$FHIRMetaNode(%md, "cp")
/// For new metadata structure
#define FSMetaPTypeInfoGlobal(%md)   $$$FHIRMetaNode(%md, "pti")
/// For old metadata structure
#define FSRegexGlobal(%md)           $$$FHIRMetaNode(%md, "rx")

/// Type-level Accessors
///
#define TypeInfoCache(%md) @%md.TiGbl
#define GetPropertyNameList(%md, %type) @%md.TiGbl@(%type, "*pn")
#define GetSuperclass(%md, %type) @%md.TiGbl@(%type, "*dt")
#define IsDatatypeDefined(%md, %type) ($Data(@%md.TiGbl@(%type)) '= 0)


/// Property-Level Accessors
#define IsPropertyDefined(%md, %type, %name) ($Data(@%md.TiGbl@(%type, %name)) '= 0)
#define GetPropertyJsonType(%md, %type, %name) $Get(@%md.TiGbl@(%type, %name, "jt"))
#define GetPropertyFHIRType(%md, %type, %name) $Get(@%md.TiGbl@(%type, %name, "dt"))
#define GetPropertyFHIRTypeList(%md, %type, %name) @%md.TiGbl@(%type, %name, "dt", "list")
#define GetPropertyTargetList(%md, %type, %name) @%md.TiGbl@(%type, %name, "tl")
#define GetPropertyIndex(%md, %type, %name) @%md.TiGbl@(%type, %name, "ix")
#define GetPropertyValueSetURL(%md, %type, %name) $Get(@%md.TiGbl@(%type, %name, "vs"))
#define GetPropertyValueSetStrength(%md, %type, %name) $Get(@%md.TiGbl@(%type, %name, "vss"))
#define NextPropertyNameInType(%md, %type, %name) $Order(@%md.TiGbl@(%type, %name))
#define NextXMLAttrProperty(%md, %type, %name) $Order(@%md.TiGbl@(%type, "*xa", %name))
#define IsPropertyRequired(%md, %type, %name) ($D(@%md.TiGbl@(%type, "*rq", %name)) '= 0)
#define NextRequiredProperty(%md, %type, %name) $Order(@%md.TiGbl@(%type, "*rq", %name))

/// Value Set Macros
#define IsPropertyValueSet(%md, %type, %name) ($Data(@%md.TiGbl@(%type, %name, "enum")) >= 10)
#define IsPropertyValueInSet(%md, %type, %name, %val) ($Get(@%md.TiGbl@(%type, %name, "enum", %val)) = 1)
#define NextValueInPropertyValueSet(%md, %type, %name, %val) $Order(@%md.TiGbl@(%type, %name, "enum", %val))


/// Primitive Type Info
/// For new metadata structure
#define GetRegexForPrimitive(%md, %type) $Get(@$$$FHIRMetaNode(%md,"pti")@(%type,"rx"))
/// For old metadata structure
#define GetRegexForType(%md, %type) $Get(@$$$FHIRMetaNode(%md,"rx")@(%type))

/// Property Type Booleans
#define IsPropertyArray(%md, %type, %name) ($Get(@%md.TiGbl@(%type, %name, "arr")) = 1)
#define IsPropertyXMLAttr(%md, %type, %name) ($D(@%md.TiGbl@(%type, "*xa", %name)) '= 0)
#define IsChoiceProperty(%md, %type, %name) ($$$GetPropertyJsonType(%md, %type, %name) = "c")
#define IsStringProperty(%md, %type, %name) ($$$GetPropertyJsonType(%md, %type, %name) = "s")
#define IsNumberProperty(%md, %type, %name) ($$$GetPropertyJsonType(%md, %type, %name) = "n")
#define IsObjectProperty(%md, %type, %name) ($$$GetPropertyJsonType(%md, %type, %name) = "o")
#define IsBooleanProperty(%md, %type, %name) ($$$GetPropertyJsonType(%md, %type, %name) = "b")
#define IsXMLDivProperty(%md, %type, %name) ($$$GetPropertyJsonType(%md, %type, %name) = "x")

/// ------ Macros to access Multidimensional Search Param Data (in the Schema object) ------
#define NextSearchParamRsrcName(%md, %type) Set %type = %md.NextSearchParamResourceType(%type)
#define NextSearchParamName(%md, %type, %name) Set %name = %md.NextSearchParamName(%type, %name)

/// ------ Macros to access Multidimensional Compartment Data (in the Schema object) ------
#define NextCompartment(%md, %comp) Set %comp = $Order(@%md.CpGbl@(%comp))
#define NextTypeInCompartment(%md, %comp, %type) Set %name = $Order(@%md.CpGbl@(%comp, %type))
#define NextParamNameInCompartment(%md, %comp, %type, %name) Set %name = $Order(@%md.CpGbl@(%comp, %type, %name))
#define IsCompartmentParameter(%md, %comp, %type, %name)  ($Data(@%md.CpGbl@(%comp, %type, %name))'=0)
#define IsTypeInCompartment(%md, %comp, %type)  ($Data(@%md.CpGbl@(%comp, %type))>=10)
#define IsCompartment(%md, %comp)  ($Data(@%md.CpGbl@(%comp))'=0)
#define CompartmentName(%rsrc) $ZConvert(%rsrc, "L")

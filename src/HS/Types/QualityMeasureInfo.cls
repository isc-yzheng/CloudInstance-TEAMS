/// *** THIS CLASS, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
/// HS.Types.QualityMeasureInfo defines the HealthShare-relevant properties
/// of a given QualityMeasure.  It may be used by a Quality Measure
/// Registry and/or as an SDA Container property for passing transient
/// data.
Class HS.Types.QualityMeasureInfo Extends (%RegisteredObject, %XML.Adaptor, HS.SDA3.QuickXML)
{

/// Identifying Code for user reference.
Property Code As %String(MAXLEN = 128) [ Required ];

/// Version-specific identifier.  HQMF location /hl7:QualityMeasureDocument/hl7:id/@root.
Property VersionSpecificId As %String(MAXLEN = 128) [ Required ];

/// NQF Number
Property NQFNumber As %String;

/// Authoring Tool Id Assigning Authority OID
Property AuthoringToolIdRoot As %String;

/// Authoring Tool Id, usually the CMS number
Property AuthoringToolIdExtension As %String;

/// Measure Title.  HQMF location /hl7:QualityMeasureDocument/hl7:title.
Property Title As %String(MAXLEN = 256);

/// Version Neutral Id, also known as setId.  HQMF location /hl7:QualityMeasureDocument/hl7:setId/@root.
Property VersionNeutralId As %String(MAXLEN = 128);

/// Measure Version Number.  HQMF location /hl7:QualityMeasureDocument/hl7:versionNumber/@value.
Property VersionNumber As %String;

Property TemplateIds As list Of %String(STORAGEDEFAULT = "array");

}

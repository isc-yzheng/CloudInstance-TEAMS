/// HS.SDA3.Vaccination corresponds to the CDA Immunizations section.
Class HS.SDA3.Vaccination Extends (HS.SDA3.AbstractMedication, HS.SDA3.SuperClass)
{

Property Extension As HS.Local.SDA3.VaccinationExtension;

Parameter ORDERITEMTYPE = "VXU";

/// List of observations made for this Vaccination<br><br>
/// HL7ToSDA3:<br>
/// Parsing of OBXs into VXUObservations is documented in depth in<br>
/// HS.SDA3.Observation. Note that Observation is also its own streamlet type.<br>
/// Instances where the parsing is different for independent Observations<br>
/// versus Vaccination Observations are noted in the annotations. Also, note<br>
/// that the parsing is sometimes dependent on the value of the<br>
/// ObservationCompatibilityMode setting of the HL7 Inbound Process operation<br>
/// of the Edge production. The details of this are documented in the<br>
/// Observation class as well.<br><br>
/// Streamlet cache:<br>
/// The Streamlet Cache processing of VXUObservations is also documented in<br>
/// HS.SDA3.Observation but will be repeated here. In the OnBeforeMatch method<br>
/// of the Vaccination Streamlet class, if the ObservationTime of any<br>
/// Observation in the list is null, it will be defaulted to the last non-null<br>
/// ObservationTime in the list (that was originally non-null, not defaulted),<br>
/// then to the EnteredOn of the current Observation, then to the current<br>
/// date/time. In the OnValidate method of the Vaccination Streamlet class, if<br>
/// any of the Observations in VXUObservations has no ObservationCode, a warning<br>
/// will be logged and the Vaccination will be saved without the bad Observation.<br><br>
/// HL7:  OBX<br>
/// VIEWERLIB: Not stored
Property VXUObservations As list Of HS.SDA3.Observation;

}

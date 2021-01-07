Include HS.HC

Class HS.FHIR.vDSTU2.Repository.BundleProcessor Extends HS.FHIR.vCommon.Repository.BundleProcessor
{

/// Class that provides the FHIR Bundle resource validation logic for this Bundle processing class.
/// The BundleValidatorClass must implement the class methods ValidateBundle and ValidateBundleStream.
/// The class is intended to handle Bundle-specific validation, i.e., the rules applying to transaction,
/// batch, document, and message Bundles.
Parameter BundleValidatorClass = "HS.FHIR.vDSTU2.Repository.BundleValidator";

/// The class to use for handling direct interaction with the desired data and storage model.
Parameter StorageClass As %String = "HS.FHIR.vDSTU2.Repository.Storage";

}

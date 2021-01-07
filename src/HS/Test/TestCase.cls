Include HS.Test

/// HealthShare aware unit testing class. See also <class>HS.Test.Manager</class>
/// <p>
/// Differences from <class>%UnitTest.TestCase</class>
/// <ul>
/// <li>Test* methods are executed in order of definition, not alphabetically
/// <li>A single session is maintained for each test case
/// <li>Can be called directly from the command line using the Run() method
/// </ul>
/// 
/// A test case class is broken out into 3 types of methods:
/// <ol>
/// <li>Test* methods, that are invoked by the framework. Typically, these methods do a task and check the results.
/// <li>A series of public class methods for performing a task. These are intended to be called from other test
/// 		case classes or the command line
/// <li>Private methods for supporting logic
/// </ol>
/// 
/// See <class>HS.Test.Manager</class> for examples on invoking test methods.
Class HS.Test.TestCase Extends HS.HC.Test.TestCase
{

/// Ensure the given patient exists in the MPI and is cached in the session
Method EnsurePatientExists(pPatientKey As %String = "", Output pErrors As HS.Types.IHE.Errors) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pErrors = ##class(HS.Types.IHE.Errors).%New()

		#dim tPatient As HS.Test.Types.Patient
		Set tPatient = ..GetObject(pPatientKey, .tSC) $$$ThrowOnError(tSC)

		If '$IsObject(tPatient) || '$IsObject(tPatient.MPI) {
			$$$HSTestTrace("PIX Add "_pPatientKey)
			///Get XData block from HS.Test.Data.IHE
			Set tScript = ..GetClone("PIXv3ManagerAdd", .tSC) $$$ThrowOnError(tSC)
			Set tScript.Patient = tPatient
			Set tSC = tScript.Run(tScript,.tErrors) $$$ThrowOnError($$$LogResults(tSC,tErrors))

			$$$HSTestTrace("PIX Query "_pPatientKey)
			///Get XData block from HS.Test.Data.IHE
			Set tScript = ..GetClone("PIXv3ManagerQuery", .tSC) $$$ThrowOnError(tSC)
			Set tScript.Patient = tPatient
			Set tSC = tScript.Run(tScript,.tErrors) $$$ThrowOnError($$$LogResults(tSC,tErrors))
			
			#; Ensure an MPI ID was returned
			If '$IsObject(tPatient) || '$IsObject(tPatient.MPI) {
				$$$ThrowStatus($$$ERROR($$$GeneralError,"Failed to add/update patient: "_pPatientKey))
			}
		}
		Do pErrors.logError("HSTest","Information",pPatientKey_" has MPI ID "_tPatient.MPI.ID)
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Ensure the given documents exist for a patient and are cached in the session
Method EnsureDocumentsExist(pPatientKey As %String = "", Output pErrors As HS.Types.IHE.Errors, pDocumentKeys...) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pErrors = ##class(HS.Types.IHE.Errors).%New()

		$$$HSTestTrace("Checking documents for patient "_pPatientKey)
		Set tPatient = ..GetObject(pPatientKey, .tSC) $$$ThrowOnError(tSC)
		
		Set tScript = ..GetClone("XDSbRegistryQuery", .tSC) $$$ThrowOnError(tSC)
		Set tScript.Patient = tPatient
		Set tSC = tScript.Run(tScript, .pErrors, .tDocuments) $$$ThrowOnError($$$LogResults(tSC,tErrors))
		$$$HSTestTrace("Query returned "_tDocuments.Count()_" documents") Set i="" For  Set tDocument=tDocuments.GetNext(.i) Quit:i=""  $$$HSTestWrite("  "_i)

		#dim tDocument As HS.Test.Types.IHE.Document
		For i=1:1:$G(pDocumentKeys) {
			$$$HSTestTrace("Checking document key "_pDocumentKeys(i))
			Set tDocument = ..GetObject(pDocumentKeys(i),.tSC) $$$ThrowOnError(tSC)
			If $IsObject(tDocument.UniqueId) {
				$$$HSTestTrace("Checking document list for "_tDocument.UniqueId.Value_" = "_tDocuments.IsDefined(tDocument.UniqueId.Value))
				If 'tDocuments.IsDefined(tDocument.UniqueId.Value) {
					Set tScript = ..GetClone("XDSbRepositoryProvide", .tSC) $$$ThrowOnError(tSC)
					Set tScript.Patient = tPatient
					Set tSC = tScript.Documents.Insert(tDocument) $$$ThrowOnError(tSC)
					Set tSC = tScript.Run(tScript, .tErrors) $$$ThrowOnError($$$LogResults(tSC,tErrors))
					Do pErrors.logError("HSTest","Information","Provided document "_tDocument.Key)
				} Else {
					Do pErrors.logError("HSTest","Information",tDocument.Key_" is registered")	
				}
			} Else {
				Do pErrors.logError("HSTest","Error",tDocument.Key_" does not have uniqueId")
			}
		}		
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

}

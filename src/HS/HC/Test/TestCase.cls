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
Class HS.HC.Test.TestCase Extends (%UnitTest.TestCase, HS.Test.Util) [ Inheritance = left ]
{

/// Specifies other TestCase classes to run before this one
Parameter RunAfter As %String;

/// Run all test methods for this class
ClassMethod Run(methodname, qspec, userparam) As %Status
{
	Quit ##class(HS.Test.Manager).RunTest(..%PackageName()_":"_..%ClassName()_":"_$G(methodname), $G(qspec)_"/norecursive", .userparam)
}

/// Enter an error message in the log
Method LogError(message)
{
 Set manager=r%Manager
 Do manager.LogError($g(message))
 Quit
}

/// Log results, returning an error status if either the input status or results are an error
/// Errors present in the results and exception list will will not return an error (but will be logged as expected)
Method LogResults(pStatus As %Status = {$$$OK}, pResults As HS.Types.IHE.Errors = {$$$NULLOREF}, pExceptions As HS.Types.IHE.Errors = {$$$NULLOREF}) As %Status
{
	#; NOTE: This must be a method so the Manager can be referenced
	If $IsObject(pResults),pResults.%Extends("HS.Types.IHE.Errors") {
		Set tIsError = 0
		Set i = "" For { Set tError = pResults.Errors.GetNext(.i) Quit:i=""
			Set tMsg = $$$FormatText("%1 [%2]:%3%4",tError.Severity,tError.Code,tError.Description,$s(tError.Location:" ("_tError.Location_")",1:""))
			If tError.Severity = "Error" {
				#; If the error is in the exception list, log it but not as a failure
				Set tIsException = 0
				If pExceptions]"",$IsObject(pExceptions) {
					#; Scan exception list for match, case insensitive
					#; A * in the exception means match any value
					Set j="" For { Set tException=pExceptions.Errors.GetNext(.j) Quit:j=""
						Set tMatches = 0
						For tProp="Severity","Code","Description","Location" {
							If ($property(tException,tProp)="*") {
								Set tMatches = tMatches + 1 
							} Else {
								#;Simple pattern match -- only trailing * supported at this time
								Set tEr = $ZCVT($p($property(tException,tProp),"*",1),"L")
								Set tEx = $ZCVT($e($property(tError,tProp),1,$L(tEr)),"L")
								If tEx=tEr Set tMatches = tMatches + 1
							}
						}
						#; An exception only applies to the result once. 
						#; This way, the framework can catch when expected errors do not occur
						If tMatches = 4 {
							Set tIsException = 1 
							Do pExceptions.Errors.RemoveAt(j)
							Quit
						}
					}		
				}
				If tIsException {
					Do ..LogMessage("** Expected: "_tMsg)
				} Else {
					Set tIsError = 1
					Do ..LogError(tMsg)
				}
			} Else {
				Do ..LogMessage(tMsg)	
			}
		}
		Set pStatus = $S($$$ISERR(pStatus):pStatus,tIsError:$$$ERROR($$$GeneralError,"Test returned errors"),1:$$$OK)
	}
	If $IsObject(pExceptions),pExceptions.Errors.Count()>0 {
		Set i = "" For { Set tError = pExceptions.Errors.GetNext(.i) Quit:i=""
			Set tMsg = $$$FormatText("%1 [%2]:%3%4",tError.Severity,tError.Code,tError.Description,$s(tError.Location:" ("_tError.Location_")",1:""))
			Do ..LogError("** Missing Expected: "_tMsg)			
		}
		Quit $$$ERROR($$$GeneralError,"Returned errors did not contian all exceptions")
	}
	Quit pStatus
}

/// Ensure the given patient exists in the MPI and is cached in the session
Method GetOrCreatePatient(pPatientKey As %String = "", Output pPatientSearchResponse, pStandardHub = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pPatientSearchResponse=""
		Set tSC = ##class(Ens.Util.URLStream).GetURLStream(pPatientKey,.tStream)
		Quit:$$$ISERR(tSC)
		Set tReader = ##class(%XML.Reader).%New()
		Do tReader.Correlate("Patient","HS.Message.AddUpdateHubRequest")
		Set tSC = tReader.OpenStream(tStream) $$$ThrowOnError(tSC)
		Set tOK = tReader.Next(.pObject, .tSC) $$$ThrowOnError(tSC)
		Quit:$$$ISERR(tSC) 
		If 'tOK Set tSC = $$$ERROR($$$GeneralError,"No object") //// need something better
		Set tMPIManager = ..Manager.UserFields.GetAt("MPIManager")
		If tMPIManager="" {
			Set tSC = ..GetProductionItemName("HS.HC.MPI.Manager",.tMPIManager,.tProd)
			If tMPIManager="" {
				Set tSC = ..GetProductionItemName("HS.Hub.MPI.Manager",.tMPIManager,.tProd)
			}
			Do ..Manager.UserFields.SetAt(tMPIManager,"MPIManager")
		}
		Do pObject.AdditionalInfo.SetAt($S($$$IsHub:tMPIManager,1:"Hub"),"Host")
		Set tSC = ##class(HS.Test.Service).SendSync(pObject,.tResponse)
		Quit:$$$ISERR(tSC)
		Do tReader.Correlate("Patient","HS.Message.PatientSearchRequest")
		Set tSC = tReader.OpenStream(tStream) $$$ThrowOnError(tSC)
		Set tOK = tReader.Next(.pObject, .tSC) $$$ThrowOnError(tSC)
		If $$$IsHub {
			If tMPIManager="" Return $$$ERROR($$$GeneralError,"Unable to locate MPI.Manager")
			Do pObject.AdditionalInfo.SetAt(tMPIManager,"Host")
		} Else {
			Do pObject.AdditionalInfo.SetAt("HS.IHE.PDQv3.Consumer.Operations","Host")
		}
		Set pObject.Facility=""
		Set pObject.SearchMode="PIXPDQ"  /// using PIXPDQ because we don't care about facilities - works without for HS.HC.MPI.Manager but not HS.Hub.MPI.Manager
		Set tSC = ##class(HS.Test.Service).SendSync(pObject,.tResponse) 
		If tResponse.ResultsCount=1 {
			Set pPatientSearchResponse=tResponse.Results.GetAt(1)
		}
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// using an XData correlate to an object after performing substitutions
ClassMethod XDataAsObject(pXData, pClassName, ByRef pObject, pTagName = "") As %Status
{
	New %expression,%value
	Set tSC=..GetXDataAsStreamWithSubstitutions(pXData,.tStream) Quit:$$$ISERR(tSC) tSC
	Set:pTagName="" pTagName=$p(pClassName,".",$l(pClassName,"."))
	Set tReader = ##class(%XML.Reader).%New()
	Do tReader.Correlate(pTagName,pClassName)
	Set tSC = tReader.OpenStream(.tStream) $$$ThrowOnError(tSC)
	If tReader.Next(.pObject, .tSC)
	Quit tSC
}

Method GetXDataAsStream(pXData, ByRef pStream) As %Status
{
	If pXData'[":" Set pXData="xdata://"_$classname()_":"_pXData
	Set tSC = ##class(Ens.Util.URLStream).GetURLStream(pXData,.pStream)
	Quit tSC
}

/// Make substitions on {$method{}} and {$expression{}} calls - limited to string size
ClassMethod GetXDataAsStreamWithSubstitutions(pXData, ByRef pStream) As %Status
{
	If pXData'[":" Set pXData="xdata://"_$classname()_":"_pXData
	Set tSC = ##class(Ens.Util.URLStream).GetURLStream(pXData,.tStream)
	Quit:$$$ISERR(tSC) tSC
	New %expression,%value
	Set tString=tStream.Read(30000000000)
	For  {
		Set tPos=$f(tString,"{$expression{")
		Quit:'tPos
		Set tPosEnd=$f(tString,"}}",tPos)
		Quit:'tPosEnd
		Set %expression=$e(tString,tPos,tPosEnd-3)
		X "Set %value="_%expression
		Set tString=$e(tString,1,tPos-14)_%value_$e(tString,tPosEnd,*)
	}
	For  {
		Set tPos=$f(tString,"{$method{")
		Quit:'tPos
		Set tPosEnd=$f(tString,"}}",tPos)
		Quit:'tPosEnd
		Set %expression=$e(tString,tPos,tPosEnd-3)
		X "Set %value="_%expression
		Set tString=$e(tString,1,tPos-10)_%value_$e(tString,tPosEnd,*)
	}
	Set pStream=##class(%Stream.GlobalCharacter).%New()
	Do pStream.Write(tString),pStream.Rewind()
	Quit tSC
}

Method XMLGlobalPatientOID()
{
	Quit "^^^&amp;"_$$$AffinityDomainOID_"&amp;ISO"
}

ClassMethod ChangeToHub()
{
	Set tNS=""
	For  {
		Set tNS=$O(^%SYS("HealthShare","Instances",tNS))
		Quit:tNS=""
		If $$$HSNSType(tNS)="Hub" Quit
	}
	Quit:tNS=""
	Set $namespace=tNS
}

/// Given the message header id, get the response message (XMLMessage) and check the ContentStream for the text
Method ResponseContainsText(pID, pText)
{
	/// Validate Minimal response
	Set tHeader = ##class(Ens.MessageHeader).%OpenId(pID)
	Set tMessage = $classmethod(tHeader.MessageBodyClassName,"%OpenId",tHeader.MessageBodyId)
	Quit $$$AssertTrue(tMessage.ContentStream.Read()[pText,"Response contains "_pText)
}

/// Return the highest Audit ID
Method FindHighAuditID() As %Integer
{
	Quit +$G(^HS.IHE.Audit("AggregationD"))
}

/// Find all audit records from a starting point
/// 	pStartingID - value of FindHighAuditID from before the start of the tests
/// 		pIsSource - boolean is the source or recipient of the message
/// 		pActionCode - 'C' 'D' 'R' etc
/// 		pEventsCodesContains - what to look for in the EventsCodes, ie ITI-52
/// 		Output of the count of records found
/// 		return value of a result set containing the rows found
Method FindAuditRecords(pStartingID, pIsSource, pActionCode, pEventCodesContains, Output pCount, pAuditSourceID = "") As %SQL.StatementResult
{
	Set tSQL = "Select Count(*),* FROM HS_IHE_ATNA_Repository.Aggregation Where ID>? AND IsSource=? AND ActionCode=? AND EventCodes[?"

	Set tParam($i(tParam)) = pStartingID
	Set tParam($i(tParam)) = pIsSource
	Set tParam($i(tParam)) = pActionCode
	Set tParam($i(tParam)) = pEventCodesContains
	If pAuditSourceID]"" {
		Set tParam($i(tParam)) = pAuditSourceID
		Set tSQL=tSQL_" AND AuditSourceID [ ?"
	}
	Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,tParam...)
	Do tRS.%Next() 
	Set pCount=+(tRS.%GetData(1))
	Quit tRS
}

/// Given a configuration name, return the Highest ID given a starting point
/// 	pConfigName name of configuration item ie HS.IHE.DSUB.NotificationConsumer.Services
/// 	pStart an optional starting point
/// 		pCount an output value of the count
ClassMethod MessagesForItem(pConfigName = "", pStart = "", Output pCount, pMessageBodyClassName = "") As %Integer
{
	Set tSQL="SELECT ID,Count(*) FROM Ens.MessageHeader where SourceConfigName=? "
	Set tParams($i(tParams))=pConfigName
	Set:pStart]"" tParams($i(tParams))=pStart,tSQL=tSQL_"and ID>?"
	If pMessageBodyClassName]"" Set tParams($i(tParams))=pMessageBodyClassName,tSQL=tSQL_" and MessageBodyClassName=?"
	Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL_" Order By ID Desc",tParams...)
	Do tRS.%Next()
	Set pCount=+(tRS.%GetData(2))
	Quit tRS.%GetData(1)
}

/// locate production item by Class
ClassMethod GetProductionItemName(pClass, Output pItemName, Output pProdRef As Ens.Config.Production) As %Status
{
	try {
	
		Set tSC=##class(HS.Util.Installer.Upgrade.Abstract).OpenCurrentProduction(.pProdRef)
		If $$$ISERR(tSC) Return tSC
		Set tCount=0
		For tI=pProdRef.Items.Count():-1:1 {
			Set tItem=pProdRef.Items.GetAt(tI)
			If tItem.ClassName=pClass {Set pItemName = tItem.Name,tCount=tCount+1}
		}
		If tCount>1 Set tSC=$$$ERROR($$$GeneralError,"More than 1 item with class found")
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// pTest - "Test" or "LoadTest" <br>
/// pClass - "HS.IHE.XDSb.Registry.Services"<br>
/// pNewClass - value of new class name such as HS.Generated.Test.IHE.XDSb.Registry.Services<br>
ClassMethod CreateTestClass(pTest, pClass, Output pNewClassName, pIsWebService = 0)
{
	Set tClassName = $p(pClass,"HS.",2,*)
	Set pNewClassName = "HS.Generated."_pTest_"."_tClassName
	Set tSC = $$$OK
	If ##class(%Dictionary.ClassDefinition).%ExistsId(pNewClassName) {
		Set tSC = $system.OBJ.Delete(pNewClassName,"-d")
	}
	Set tClass=##class(%Dictionary.ClassDefinition).%New(pNewClassName)
	Set tClass.Super=pClass
	Set tClass.GeneratedBy="HS.HC.Test.TestCase"
	If pIsWebService {
		Set tParameter = ##class(%Dictionary.ParameterDefinition).%New(tClass.Name_":SOAPMETHODINHERITANCE")
		Set tParameter.Default=1
		Do tClass.Parameters.Insert(tParameter)
	}
	Set tSC = tClass.%Save()
	Set tSC= $system.OBJ.Compile(pNewClassName,"fck-dv")
	Quit tSC
}

/// 
/// Remove HS.Generated.{pTestName} items that have been added to a production
ClassMethod CleanupProductionChanges(pTestName)
{
	try {
		Set tTestName="HS.Generated."_pTestName
		Set tSC=##class(HS.Util.Installer.Kit.Base).GetProduction(.tProduction)
		Quit:$$$ISERR(tSC)
		For tIdx=tProduction.Items.Count():-1:1 {
			Set tItem = tProduction.Items.GetAt(tIdx)
			If $E(tItem.Name,1,$l(tTestName))'=tTestName Continue
			If $E(tItem.ClassName,1,$l(tTestName))=tTestName {
				Do $system.OBJ.Delete(tItem.ClassName,"-d")
			}
			Do tProduction.Items.RemoveAt(tIdx)
		}
		Set tSC=##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProduction)
		Do ##class(Ens.Director).UpdateProduction()
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod GetLastEnsembleSessionID() As %String
{
	&sql(select top 1 SessionId into :tSession from Ens.MessageHeader Order By SessionId desc)
	Quit $S(SQLCODE:0,1:tSession)
}

}

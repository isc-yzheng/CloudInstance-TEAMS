/// *** THIS CLASS, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.
Class HS.Util.QRDA Extends %RegisteredObject
{

/// DisplayMeasureInfoPrompt provides a simple prompt to
/// display Quality Measure Registry info or one or all
/// stored quality measures.
ClassMethod DisplayMeasureInfoPrompt()
{
	Write !,"Measure Code <all>: " Read tRead
	
	If tRead'="" Do ..DisplayMeasureInfo(tRead) Quit
	
	Set tStatement = ##class(%SQL.Statement).%New()
	Set tStatement.%SelectMode=2
	Set tQuery = "SELECT Code FROM HS_Registry.QualityMeasure"
	Set tStatus = tStatement.%Prepare(tQuery)
	Set tResultSet = tStatement.%Execute()
	While tResultSet.%Next() { If $i(tCodes) Set tCodes(tCodes) = tResultSet.Code }
	Kill tResultSet
	Kill tStatus
	Kill tQuery
	Kill tStatement
	If $Get(tCodes)>0 For i = 1:1:tCodes Do ..DisplayMeasureInfo(tCodes(i))
	
	Quit
}

/// DisplayMeasureInfo is a Terminal-based means of displaying
/// Quality Measure Registry information for a given quality
/// measure.  Input parameter pMeasureCode may be a measure
/// Code, an NQF number (with or without the "NQF") or a
/// string contained in a measure Title.
ClassMethod DisplayMeasureInfo(pMeasureCode As %String = "")
{
	Set tSC = $$$OK
	
	Try {
		If pMeasureCode="" Set tSC = $$$ERROR($$$GeneralError,"Measure code not specified") Quit
		
		Set tSC = ..SearchMeasure(pMeasureCode, .tCodes)
		If $$$ISERR(tSC) Quit
		If $Data(tCodes)=0 Set tSC = $$$ERROR($$$GeneralError,"Could not find a quality measure for "_pMeasureCode) Quit
		
		For i = 1:1:tCodes {
			Set tObj = ##class(HS.Registry.QualityMeasure).CodeIndexOpen(tCodes(i))
			Write !,"Code                     = "_tObj.Code
			Write !,"VersionSpecificId        = "_tObj.VersionSpecificId
			Write !,"AuthoringToolIdExtension = "_tObj.AuthoringToolIdExtension
			Write !,"NQF Number               = "_tObj.NQFNumber
			Write !,"Title                    = "_tObj.Title
			Write !,"VersionNeutralId         = "_tObj.VersionNeutralId
			Write !,"VersionNumber            = "_tObj.VersionNumber
			Write !,"TemplateIds:"
			Set tMaxlen = 0
			For j = 1:1:tObj.TemplateIds.Count() {
				Set tTemplateId = tObj.TemplateIds.GetAt(j)
				Set:$Length(tTemplateId)>tMaxlen tMaxlen = $Length(tTemplateId)
			}
			For j = 1:1:tObj.TemplateIds.Count() {
				Set tTemplateId = tObj.TemplateIds.GetAt(j)
				Set tTemplateName = ##class(HS.Data.OIDMap).OIDDescription(tTemplateId,"")
				Write !,tTemplateId Write:tTemplateName'=""&(tTemplateName'=tTemplateId) ?(tMaxlen+2),tTemplateName
			}
			Write !
			Kill tObj
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Kill tObj
	
	If $$$ISERR(tSC) Write !!,"Error displaying "_pMeasureCode_" - "_$system.Status.GetErrorText(tSC)
	
	Quit
}

ClassMethod SearchMeasure(pMeasureCode As %String, ByRef pCodes As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Kill pCodes
		
		#dim tResultSet As %SQL.StatementResult
		
		// Search by external Code.
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%SelectMode=2
		Set tQuery = "SELECT Code FROM HS_Registry.QualityMeasure WHERE Code = ?"
		Set tStatus = tStatement.%Prepare(tQuery)
		Set tResultSet = tStatement.%Execute(pMeasureCode)
		While tResultSet.%Next() { If $i(pCodes) Set pCodes(pCodes) = tResultSet.Code }
		Kill tResultSet
		Kill tStatus
		Kill tQuery
		Kill tStatement
		If $Data(pCodes) Quit
		
		// If not found on search by Code, then search by NQF Number.
		Set tTempMeasureCode = $Select($ZConvert(pMeasureCode,"U")?1"NQF"1N.N:$Extract(pMeasureCode,4,*),1:pMeasureCode)
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%SelectMode=2
		Set tQuery = "SELECT Code FROM HS_Registry.QualityMeasure WHERE NQFNumber = ?"
		Set tStatus = tStatement.%Prepare(tQuery)
		Set tResultSet = tStatement.%Execute(tTempMeasureCode)
		While tResultSet.%Next() { If $i(pCodes) Set pCodes(pCodes) = tResultSet.Code }
		Kill tResultSet
		Kill tStatus
		Kill tQuery
		Kill tStatement
		If $Data(pCodes) Quit
		
		// If not found on search by NQF Number, then search by Authoring Tool Id.
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%SelectMode=2
		Set tQuery = "SELECT Code FROM HS_Registry.QualityMeasure WHERE AuthoringToolIdExtension = ?"
		Set tStatus = tStatement.%Prepare(tQuery)
		Set tResultSet = tStatement.%Execute(pMeasureCode)
		While tResultSet.%Next() { If $i(pCodes) Set pCodes(pCodes) = tResultSet.Code }
		Kill tResultSet
		Kill tStatus
		Kill tQuery
		Kill tStatement
		If $Data(pCodes) Quit
		
		// If not found on search by Authoring Tool Id, then search by Title containing search string.
		Set tTempMeasureCode = "%"_pMeasureCode_"%"
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%SelectMode=2
		Set tQuery = "SELECT Code FROM HS_Registry.QualityMeasure WHERE Title LIKE ?"
		Set tStatus = tStatement.%Prepare(tQuery)
		Set tResultSet = tStatement.%Execute(tTempMeasureCode)
		While tResultSet.%Next() { If $i(pCodes) Set pCodes(pCodes) = tResultSet.Code }
		Kill tResultSet
		Kill tStatus
		Kill tQuery
		Kill tStatement
		If $Data(pCodes) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// BuildAssertionObjectString builds a string of QRDA Quality
/// Measure Assertion Information in SDA3 CustomObject XML format,
/// for the purpose of inserting the string into an SDA3 Container
/// stream.  Multiple consecutive calls to this method will
/// add on to the pString value, rather than overwrite it each
/// time.
ClassMethod BuildAssertionObjectString(pMeasureCode As %String, pAssertionCode As %String, pAssertionResult As %Boolean, pPopulationId As %String, pProbability As %String, ByRef pString As %String) As %Status
{
	Set tSC = $$$OK
	
	If $Data(pString)=0 Set pString = ""
	
	Try {
		Set tObj = ##class(HS.Registry.QualityMeasure).CodeIndexOpen(pMeasureCode)
		If '$IsObject(tObj) Set tSC = $$$ERROR($$$GeneralError,"Invalid Measure Code") Quit
		Kill tObj
		
		Set tValidAssertions = "|DENEX|DENEXCEP|DENOM|IPP|MSRPOPL|NUMER|NUMEX|"
		Set tAssertionCodeUp = $ZConvert(pAssertionCode,"U")
		If tValidAssertions'[("|"_tAssertionCodeUp_"|") Set tSC = $$$ERROR($$$GeneralError,"Invalid Assertion Code "_pAssertionCode) Quit
		
		If pAssertionResult'=0,pAssertionResult'=1 Set tSC = $$$ERROR($$$GeneralError,"Invalid Assertion Result "_pAssertionResult) Quit
		
		If pPopulationId="" Set tSC = $$$ERROR($$$GeneralError,"Population Id not specified") Quit
		
		Set pString = pString_"<CustomObject>"
		Set pString = pString_"<CustomType>QualityMeasureAssertion</CustomType>"
		Set pString = pString_"<NVPair><Name>MeasureCode</Name><Value>"_pMeasureCode_"</Value></NVPair>"
		Set pString = pString_"<NVPair><Name>AssertionCode</Name><Value>"_tAssertionCodeUp_"</Value></NVPair>"
		Set pString = pString_"<NVPair><Name>AssertionResult</Name><Value>"_pAssertionResult_"</Value></NVPair>"
		Set pString = pString_"<NVPair><Name>PopulationId</Name><Value>"_pPopulationId_"</Value></NVPair>"
		If $Get(pProbability)'="" Set pString = pString_"<NVPair><Name>Probability</Name><Value>"_pProbability_"</Value></NVPair>"
		Set pString = pString_"</CustomPairs>"
		Set pString = pString_"</CustomObject>"
				
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ImportVSAC is the installation method for Value Set Authority Center (VSAC)
/// XML files.  You need a free license from the National Library of Medicine
/// (NLM) in order to be able to download the value set XML file.<br>
/// <br>
/// 1.  Use a web browser to navigate to https://vsac.nlm.nih.gov/<br>
/// 2.  On the web site page, select the Download tab.<br>
/// 3.  There will appear a table of download choices.<br>
/// 4.  In the table row "All 2014 eCQM Value Sets (EP and EH)",
///     under the column "Sorted By Value Set Name", click the
///     "SVS (xml)" button.<br>
/// 5.  If you do not have a license, you will be prompted to apply
///     for one.  You should be granted the license within 1-3 days.<br>
/// 6.  If you already have a license and a login account, log in.<br>
/// 7.  Click the "SVS (xml)" button that was described in step 4.<br>
/// 8.  Note the operating system path and the file name of the XML
///     file that you downloaded.<br>
/// 9.  Open a Terminal session in Cache.<br>
/// 10. Navigate to the HSREGISTRY namespace.<br>
/// 11. Import the value sets from the XML file, using the command<br>
///     Do ##class(HS.Util.QRDA).ImportVSAC("<i>FilePathAndName</i>")
ClassMethod ImportVSAC(pFile As %String = "")
{
	If pFile="" Write !,"File name not specified.",! Quit
	
	If '##class(%Library.File).Exists(pFile) Write !,"File "_pFile_" not found.",! Quit
	
	Set tSource = ##class(%FileBinaryStream).%New()
	Set tSource.Filename=pFile
	
	Write !,"Deleting value set table...",!!
	Set tSC = ##class(HS.Data.ValueSet).%DeleteExtent()
	If $$$ISERR(tSC) Write "delete failed - "_$system.Status.GetErrorText(tSC),! Quit
	Write "delete succeeded.",!
	Write !,"Starting import...",!!
	Set tTransformer = ##class(HS.Util.XSLTTransformer).%New()
	Set tXSLPath = "SDA3/VSAC-to-HSValueSet.xsl"
	Set tSC = tTransformer.Transform(tSource, tXSLPath, .tOutputStream, .tParams)
	If $$$ISERR(tSC) Write "import failed - "_$system.Status.GetErrorText(tSC),! Quit
	Write "import succeeded.",!
	Quit
}

/// SetupQualityMeasureRegistry uses the data stored in the
/// QualityMeasure XData block of this class to populate
/// the HealthShare Quality Measure Registry.
ClassMethod SetupQualityMeasureRegistry(pSilent As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If 'pSilent Write !,"Setting up Quality Measure Registry...",!!
		Set tXData=##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1)_"||QualityMeasure").Data
		Set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tXData)
		If $$$ISERR(tSC) Quit
		Do tReader.Correlate("QualityMeasure","HS.Registry.QualityMeasure")
		While tReader.Next(.tObject,.tSC) {
			If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,"Error in tReader.Next - "_$system.Status.GetErrorText(tSC)) Quit
			Set tStoredMeasure = ##class(HS.Registry.QualityMeasure).CodeIndexOpen(tObject.Code)
			If $IsObject(tStoredMeasure) {
				Do tStoredMeasure.CopyFrom(tObject,tStoredMeasure)
				For i = tStoredMeasure.TemplateIds.Count():-1:1 {
					Do tStoredMeasure.TemplateIds.RemoveAt(i)
				}
				For i = 1:1:tObject.TemplateIds.Count() {
					Do tStoredMeasure.TemplateIds.SetAt(tObject.TemplateIds.GetAt(i),i)
				}
			} Else {
				Set tStoredMeasure = tObject
			}
			
			Set tSC=tStoredMeasure.%Save()
			If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,"Error in %Save - "_$system.Status.GetErrorText(tSC)) Quit
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If 'pSilent{
		If $$$ISERR(tSC) Write "setup failed - "_$system.Status.GetErrorText(tSC),!
		If $$$ISOK(tSC) Write "setup succeeded."
	}
	
	Quit tSC
}

XData QualityMeasure
{
<root>
<QualityMeasure>
<Code>CMS100v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9dfa522927ed</VersionSpecificId>
<NQFNumber>0142</NQFNumber>
<Title>Aspirin Prescribed at Discharge</Title>
<VersionNeutralId>bb481284-30dd-4383-928c-82385bbf1b17</VersionNeutralId>
<AuthoringToolIdExtension>100</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.199</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.1</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.200</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.78</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.401</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS102v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-95dd84641cd4</VersionSpecificId>
<NQFNumber>0441</NQFNumber>
<Title>Assessed for Rehabilitation</Title>
<VersionNeutralId>7dc26160-e615-4cc2-879c-75985189ec1a</VersionNeutralId>
<AuthoringToolIdExtension>102</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.106</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS104v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9e6e127929e3</VersionSpecificId>
<NQFNumber>0435</NQFNumber>
<Title>Discharged on Antithrombotic Therapy</Title>
<VersionNeutralId>42bf391f-38a3-4c0f-9ece-dcd47e9609d9</VersionNeutralId>
<AuthoringToolIdExtension>104</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.199</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.200</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS105v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9e73dc162a27</VersionSpecificId>
<NQFNumber>0439</NQFNumber>
<Title>Discharged on Statin Medication</Title>
<VersionNeutralId>1f503318-bb8d-4b91-af63-223ae0a2328e</VersionNeutralId>
<AuthoringToolIdExtension>105</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.199</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.1</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.200</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.13</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.12</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.5</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS107v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-95de2f641cec</VersionSpecificId>
<NQFNumber/>
<Title>Stroke Education</Title>
<VersionNeutralId>217fdf0d-3d64-4720-9116-d5e5afa27f2c</VersionNeutralId>
<AuthoringToolIdExtension>107</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.31</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.30</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.130</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS108v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9edba9142cba</VersionSpecificId>
<NQFNumber>0371</NQFNumber>
<Title>Venous Thromboembolism Prophylaxis</Title>
<VersionNeutralId>38b0b5ec-0f63-466f-8fe3-2cd20ddd1622</VersionNeutralId>
<AuthoringToolIdExtension>108</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.23</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.10</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.110</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.12</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.21</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.37</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.137</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.78</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS109v3</Code>
<VersionSpecificId>40280381-43db-d64c-0144-65df36c22e97</VersionSpecificId>
<NQFNumber/>
<Title>Venous Thromboembolism Patients Receiving Unfractionated Heparin with Dosages/Platelet Count Monitoring by Protocol or Nomogram</Title>
<VersionNeutralId>bcce43dd-08e3-46c3-bfdd-0b1b472690f0</VersionNeutralId>
<AuthoringToolIdExtension>109</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.5</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS110v3</Code>
<VersionSpecificId>40280381-43db-d64c-0144-6670a0c42f05</VersionSpecificId>
<NQFNumber/>
<Title>Venous Thromboembolism Discharge Instructions</Title>
<VersionNeutralId>7fe69617-fa28-4305-a2b8-ceb6bcd9693d</VersionNeutralId>
<AuthoringToolIdExtension>110</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.31</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.131</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.199</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS111v3</Code>
<VersionSpecificId>40280381-43db-d64c-0144-64e3651a2dcc</VersionSpecificId>
<NQFNumber>0497</NQFNumber>
<Title>Median Admit Decision Time to ED Departure Time for Admitted Patients</Title>
<VersionNeutralId>979f21bd-3f93-4cdd-8273-b23dfe9c0513</VersionNeutralId>
<AuthoringToolIdExtension>111</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.83</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS113v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-95ddb52a1cdc</VersionSpecificId>
<NQFNumber>0469</NQFNumber>
<Title>Elective Delivery</Title>
<VersionNeutralId>fd7ca18d-b56d-4bca-af35-71ce36b15246</VersionNeutralId>
<AuthoringToolIdExtension>113</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.23</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.18</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.24</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS114v3</Code>
<VersionSpecificId>40280381-43db-d64c-0144-6678b7972f10</VersionSpecificId>
<NQFNumber/>
<Title>Incidence of Potentially-Preventable Venous Thromboembolism</Title>
<VersionNeutralId>32cfc834-843a-4f45-b359-8e158eac4396</VersionNeutralId>
<AuthoringToolIdExtension>114</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.10</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.110</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.40</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS171v4</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9f324c5b2d25</VersionSpecificId>
<NQFNumber>0527</NQFNumber>
<Title>Prophylactic Antibiotic Received Within One Hour Prior to Surgical Incision</Title>
<VersionNeutralId>d09add1d-30f5-462d-b677-3d17d9ccd664</VersionNeutralId>
<AuthoringToolIdExtension>171</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.401</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS172v4</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9edb61c22cb1</VersionSpecificId>
<NQFNumber>0528</NQFNumber>
<Title>Prophylactic Antibiotic Selection for Surgical Patients</Title>
<VersionNeutralId>feea3922-f61f-4b05-98f9-b72a11815f12</VersionNeutralId>
<AuthoringToolIdExtension>172</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.404</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.71</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.1</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.13</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.401</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS178v4</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9f5f1ff92d7a</VersionSpecificId>
<NQFNumber>0453</NQFNumber>
<Title>Urinary catheter removed on Postoperative Day 1 (POD 1) or Postoperative Day 2 (POD 2) with day of surgery being day zero</Title>
<VersionNeutralId>d78ce034-8288-4012-a31e-7f485a74f2a9</VersionNeutralId>
<AuthoringToolIdExtension>178</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.18</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.10</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.404</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.401</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.106</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS185v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9e536719293d</VersionSpecificId>
<NQFNumber>0716</NQFNumber>
<Title>Healthy Term Newborn</Title>
<VersionNeutralId>ff796fd9-f99d-41fd-b8c2-57d0a59a5d8d</VersionNeutralId>
<AuthoringToolIdExtension>185</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.18</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS188v4</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-95d106da1cb4</VersionSpecificId>
<NQFNumber>0147</NQFNumber>
<Title>Initial Antibiotic Selection for Community-Acquired Pneumonia (CAP) in Immunocompetent Patients</Title>
<VersionNeutralId>8243eae0-bbd7-4107-920b-fc3db04b9584</VersionNeutralId>
<AuthoringToolIdExtension>188</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.1001</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.23</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.71</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.1</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.12</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.13</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS190v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9edb149b2ca8</VersionSpecificId>
<NQFNumber>0372</NQFNumber>
<Title>Intensive Care Unit Venous Thromboembolism Prophylaxis</Title>
<VersionNeutralId>fa91ba68-1e66-4a23-8eb2-baa8e6df2f2f</VersionNeutralId>
<AuthoringToolIdExtension>190</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.23</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.10</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.110</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.12</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.21</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.37</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.137</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.78</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS26v2</Code>
<VersionSpecificId>40280381-43db-d64c-0144-2d29b1eb14ef</VersionSpecificId>
<NQFNumber/>
<Title>Home Management Plan of Care (HMPC) Document Given to Patient/Caregiver</Title>
<VersionNeutralId>e1cb05e0-97d5-40fc-b456-15c5dbf44309</VersionNeutralId>
<AuthoringToolIdExtension>26</AuthoringToolIdExtension>
<VersionNumber>2</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.31</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.131</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS30v4</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9e27b6eb2897</VersionSpecificId>
<NQFNumber>0639</NQFNumber>
<Title>Statin Prescribed at Discharge</Title>
<VersionNeutralId>ebfa203e-acc1-4228-906c-855c4bf11310</VersionNeutralId>
<AuthoringToolIdExtension>30</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.12</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.1</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.78</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.199</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.200</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.401</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS31v3</Code>
<VersionSpecificId>40280381-43db-d64c-0144-5571970a2685</VersionSpecificId>
<NQFNumber>1354</NQFNumber>
<Title>Hearing Screening Prior To Hospital Discharge</Title>
<VersionNeutralId>0924fbae-3fdb-4d0a-aab7-9f354e699fde</VersionNeutralId>
<AuthoringToolIdExtension>31</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.111</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.404</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS32v4</Code>
<VersionSpecificId>40280381-43db-d64c-0144-6a8b0a3b30c6</VersionSpecificId>
<NQFNumber>0496</NQFNumber>
<Title>Median Time from ED Arrival to ED Departure for Discharged ED Patients</Title>
<VersionNeutralId>3fd13096-2c8f-40b5-9297-b714e8de9133</VersionNeutralId>
<AuthoringToolIdExtension>32</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.72</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS53v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9e0b96c12843</VersionSpecificId>
<NQFNumber>0163</NQFNumber>
<Title>Primary PCI Received Within 90 Minutes of Hospital Arrival</Title>
<VersionNeutralId>84b9d0b5-0caf-4e41-b345-3492a23c2e9f</VersionNeutralId>
<AuthoringToolIdExtension>53</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.71</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.401</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.3</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.106</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS55v3</Code>
<VersionSpecificId>40280381-43db-d64c-0144-64cb12982d97</VersionSpecificId>
<NQFNumber>0495</NQFNumber>
<Title>Median Time from ED Arrival to ED Departure for Admitted ED Patients</Title>
<VersionNeutralId>9a033274-3d9b-11e1-8634-00237d5bf174</VersionNeutralId>
<AuthoringToolIdExtension>55</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS60v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9e043be8281f</VersionSpecificId>
<NQFNumber>0164</NQFNumber>
<Title>Fibrinolytic Therapy Received Within 30 Minutes of Hospital Arrival</Title>
<VersionNeutralId>909cf4b4-7a85-4abf-a1c7-cb597ed1c0b6</VersionNeutralId>
<AuthoringToolIdExtension>60</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.71</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.401</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.3</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS71v4</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9e682a3b29ae</VersionSpecificId>
<NQFNumber>0436</NQFNumber>
<Title>Anticoagulation Therapy for Atrial Fibrillation/Flutter</Title>
<VersionNeutralId>03876d69-085b-415c-ae9d-9924171040c2</VersionNeutralId>
<AuthoringToolIdExtension>71</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.23</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.199</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.200</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS72v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-95dd11681ccc</VersionSpecificId>
<NQFNumber>0438</NQFNumber>
<Title>Antithrombotic Therapy By End of Hospital Day 2</Title>
<VersionNeutralId>93f3479f-75d8-4731-9a3f-b7749d8bcd37</VersionNeutralId>
<AuthoringToolIdExtension>72</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.78</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS73v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-9edbdf9f2cc2</VersionSpecificId>
<NQFNumber>0373</NQFNumber>
<Title>Venous Thromboembolism Patients with Anticoagulation Overlap Therapy</Title>
<VersionNeutralId>6f069bb2-b3c4-4bf4-adc5-f6dd424a10b7</VersionNeutralId>
<AuthoringToolIdExtension>73</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.12</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.199</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.78</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.200</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.45</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.46</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.11</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS91v4</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-95de69f81cf4</VersionSpecificId>
<NQFNumber>0437</NQFNumber>
<Title>Thrombolytic Therapy</Title>
<VersionNeutralId>2838875a-07b5-4bf0-be04-c3eb99f53975</VersionNeutralId>
<AuthoringToolIdExtension>91</AuthoringToolIdExtension>
<VersionNumber>4</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.400</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.18</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.12</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.21</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.14</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.114</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.17</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.78</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
<QualityMeasure>
<Code>CMS9v3</Code>
<VersionSpecificId>40280381-446b-b8c2-0144-95ddf0421ce4</VersionSpecificId>
<NQFNumber>0480</NQFNumber>
<Title>Exclusive Breast Milk Feeding</Title>
<VersionNeutralId>7d374c6a-3821-4333-a1bc-4531005d77b8</VersionNeutralId>
<AuthoringToolIdExtension>9</AuthoringToolIdExtension>
<VersionNumber>3</VersionNumber>
<TemplateIds>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.1001</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.64</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.30</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.2</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.6</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.18</TemplateIdsItem>
<TemplateIdsItem>2.16.840.1.113883.3.560.1.79</TemplateIdsItem>
</TemplateIds>
</QualityMeasure>
</root>
}

}

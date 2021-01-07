Include HS.HC

Class HS.Test.UI.PDQm Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "PDQm Search and Retrieve";

Parameter SERVICEREGISTRYENTRY = "PDQm.Supplier";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textReadOnly {
	border: 1px inset threedface;
	color:#777777;
	background: #EEEEEE;
}

</style>
}

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="20"/>
<html>Search by Patient Demographics or MRN/AA using PDQm</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility" hidden="1"/>
<spacer width="5" />
<combobox id="cmbFormat" label="FHIR Format:" size="22" tabIndex="35" title="Value to use for the _format URL parameter" />
<spacer width="5" />
<combobox id="cmbVersion" label="FHIR Version:" size="22" tabIndex="35" title="FHIR version to use" />
<spacer width="5" />
<hgroup>
<radioSet id="version" name="version" hidden="true" valueList="v2,v3,PDQm" captionClass="lblNormal" onclick="zenPage.UpdateSvcParams();"/>
</hgroup>
<spacer height="5"/>
<text label="Domains:" name="Domains" id="txtDomains" size="30" hint="domainCode1,...domainCodeN" hintStyle="font-size:10px;font-weight:bold;" tabIndex="5" />
<text label="First Name:" name="FirstName" id="txtFirstName" size="30" tabIndex="6" />
<text label="Last Name:" name="LastName" id="txtLastName" size="30" tabIndex="10" />
<checkbox label="Exact Match:" id="chkExactMatch" title="Name search is exact match" tabIndex="13"/>
<text label="Street:" name="Street" id="txtStreet" size="80" tabIndex="15" />
<text label="City:" name="City" id="txtCity" size="20" tabIndex="20" />
<text label="State:" name="State" id="txtState" size="10" tabIndex="25" />
<text label="Zip:" name="Zip" id="txtZip" size="10" tabIndex="30" />
<text label="Home Phone:" name="HomePhone" id="txtHomePhone" size="20" hint="(XXX-XXX-XXXX)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="31" />
<combobox id="cmbGender" label="Gender:" size="22" tabIndex="35"/>
<dateText id="dtDOB" label="Date of Birth:" size="22" minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="60"/>
<dataCombo id="cmbAA" maxRows="10000" label="AssigningAuthority:" size="80" tabIndex="65" sql="select oidmap->identitycode as Code,(oidmap->identitycode _' ['_ oidmap->OID _']') as Description from HS_Data.OIDMAP_identitytypes where identitytypes='AssigningAuthority' order by oidmap->identitycode" sqlLookup="select oidmap->identitycode || ' [' || oidmap->OID || ']' from HS_Data.OIDMAP_identitytypes where oidmap->identitycode = ?"/>
<text label="MRN:" name="MRN" id="txtMRN" size="22" readOnly="0"/>
<checkbox hidden="true" label="Test w/NIST:" id="chkNIST" title="Check this check box only when you are testing PDQv3 Continuation with the NIST pre-Connectathon PDQ Supplier.  NIST wants the PDQv3 Continuation queryExtension to always be 'NIST_CONTINUATION'." tabIndex="70"/>
<spacer height="15"/>
<text label="Max Matches:" name="MaxMatches" id="txtMaxMatches" size="10" tabIndex="75" title="Maximum number of matches before incurring paged data return"/>
<text label="Page #:" name="PageNum" id="txtPageNum" size="10" tabIndex="75" title="Page number to return on a search result that is expected to be paged. Not an expected use case but it is mentioned in the PDQm specification."/>
<text label="First:" name="First" id="txtFirst" size="120" tabIndex="80" title="First page of search matches" />
<button id="btnFirst" caption=" Submit First " onclick="zenPage.Continue('btnFirst');" />
<text label="Previous:" name="Previous" id="txtPrevious" size="120" tabIndex="80" title="Previous page of search matches" />
<button id="btnPrevious" caption=" Submit Previous " onclick="zenPage.Continue('btnPrevious');" />
<text label="Next:" name="Next" id="txtNext" size="120" tabIndex="80" title="Next page of search matches" />
<button id="btnNext" caption=" Submit Next " onclick="zenPage.Continue('btnNext');" />
<text label="Last:" name="Last" id="txtLast" size="120" tabIndex="80" title="Last page of search matches" />
<button id="btnLast" caption=" Submit Last " onclick="zenPage.Continue('btnLast');" />
<text label="URL:" name="URL" id="txtURL" size="120" tabIndex="90" title="URL for FHIR Patient resource retrieve (read)" />
<dataCombo id="cmbServiceRegistry" size='80' label="EndPoint: *" dropdownWidth="800" labelClass="caption"
	editable="true"
	searchKeyLen="10"
	cached="true"
	OnCreateResultSet="CreatePIXPDQServiceRegistryRS"
	maxRows="10000">
	<parameter id="pType" value="HTTP"/>
</dataCombo><hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.StartSend('btnSend');" />
<spacer width="5" />
<button id="btnClear" caption=" Clear " onclick="zenPage.ClearDemographics();" />
</hgroup>
</form>
<vgroup>
<pane paneName="asyncPane"/>
</vgroup>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod ClearDemographics() [ Language = javascript ]
{
	this.getComponentById('txtDomains').setValue("");
	this.getComponentById('txtFirstName').setValue("");
	this.getComponentById('txtLastName').setValue("");
	this.getComponentById('txtStreet').setValue("");
	this.getComponentById('txtCity').setValue("");
	this.getComponentById('txtState').setValue("");
	this.getComponentById('txtZip').setValue("");
	this.getComponentById('txtHomePhone').setValue("");
	this.getComponentById('cmbGender').setValue("");
	this.getComponentById('dtDOB').setValue("");
	this.getComponentById('cmbAA').setValue("");
	this.getComponentById('txtMRN').setValue("");
	this.getComponentById('txtMaxMatches').setValue("");
	this.getComponentById('txtFirst').setValue("");
	this.getComponentById('txtPrevious').setValue("");
	this.getComponentById('txtNext').setValue("");
	this.getComponentById('txtLast').setValue("");
	this.getComponentById('chkExactMatch').setValue("");
	this.getComponentById('chkNIST').setValue("");
	this.getComponentById('txtMaxMatches').setValue("");
	this.getComponentById('txtPageNum').setValue("");
	this.getComponentById('txtURL').setValue("");
	zenPage.ClearResultsPane();
	zenPage.disableNavigation();
}

Method Send(pURL = "") As %String [ ZenMethod ]
{
	try {
		Set tSessionID=""
		
		set tFHIRVersion = %page.%GetValueById("cmbVersion")
		If tFHIRVersion="" &js< alert('FHIR Version is required');> Quit

		Do ..ClearRecentPatients()
		
		If %page.%GetValueById("txtURL")'="" {
			set tSessionID = ..SendGetURL(%page.%GetValueById("txtURL"))
			quit
		}
		
		set tRequest=##class(HS.Message.PatientSearchRequest).%New()
		// If a URL is passed in, add it to Additional Info
		// This is done for PDQm continue navigation
		Do:pURL'="" tRequest.AdditionalInfo.SetAt(pURL,"GetURL")
		Set tExactMatch=%page.%GetValueById("chkExactMatch")
		Set tNIST=%page.%GetValueById("chkNIST")
		
		Set tPageNum=%page.%GetValueById("txtPageNum")
		Do:tPageNum'="" tRequest.AdditionalInfo.SetAt(tPageNum,"page")
		
		Set tURL=%page.%GetValueById("txtURL")
		Do:tURL'="" tRequest.AdditionalInfo.SetAt(tURL,"GetURL")
		
		do tRequest.AdditionalInfo.SetAt(tExactMatch,"ExactMatch")
		do tRequest.AdditionalInfo.SetAt(tNIST,"TestNIST")
		if %page.%GetValueById("txtDomains")'="" {
			set tDomains = %page.%GetValueById("txtDomains")
			for i = 1:1:$Length(tDomains,",") {
				set tDomainCode = $Piece(tDomains,",",i)
				set tDomainCode = $ZStrip(tDomainCode,"<>"," ")
				do tRequest.AdditionalInfo.SetAt("","scopingOrganization_"_tDomainCode)
				do tRequest.AdditionalInfo.SetAt("","ScopingOrganizations")
			}
		}
		Set tMRN=%page.%GetValueById("txtMRN")
		If tMRN'="" {
			set tRequest.MRN=%page.%GetValueById("txtMRN")
			set tRequest.AssigningAuthority=%page.%GetValueById("cmbAA")
			set tRequest.Facility=%page.%GetValueById("cmbAA")
			Set tAA = %page.%GetComponentById("cmbAA")
			Set tAADisplay = tAA.%GetDisplayValue(tAA.value)
		} Else {
			set tRequest.LastName=%page.%GetValueById("txtLastName")
			set tRequest.FirstName=%page.%GetValueById("txtFirstName")
			set tRequest.Street=%page.%GetValueById("txtStreet")
			set tRequest.City=%page.%GetValueById("txtCity")
			set tRequest.State=%page.%GetValueById("txtState")
			set tRequest.Zip=%page.%GetValueById("txtZip")
			Set tDOB=%page.%GetValueById("dtDOB")
			set tRequest.DOB=$S(tDOB]"":$ZDH(tDOB,3,,,,,,,-1),1:"")
			set tRequest.Telephone=%page.%GetValueById("txtHomePhone")
			set tRequest.Sex=%page.%GetValueById("cmbGender")
		}
		If +%page.%GetValueById("txtMaxMatches")>0 Set tRequest.MaxMatches = %page.%GetValueById("txtMaxMatches")
		
		Set tServiceRegistry=%page.%GetValueById("cmbServiceRegistry")
		
		set tFormat = %page.%GetValueById("cmbFormat")
		if (tFormat'="") { Do tRequest.AdditionalInfo.SetAt($ZConvert(tFormat,"L"),"_format") }
		do tRequest.AdditionalInfo.SetAt(tServiceRegistry,"ServiceName")
		do tRequest.AdditionalInfo.SetAt("PDQmConsumer"_tFHIRVersion,"FHIRActor")
		
		Set %session.Data("IHE.Test",..%ClassName(0),"Domains")=$g(tDomains)
		Set %session.Data("IHE.Test",..%ClassName(0),"ExactMatch")=tExactMatch
		Set %session.Data("IHE.Test",..%ClassName(0),"NIST")=tNIST
		Set %session.Data("IHE.Test",..%ClassName(0),"MaxMatches")=tRequest.MaxMatches
		Set %session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry")=tServiceRegistry
		Set %session.Data("IHE.Test",..%ClassName(0),"FHIRFormat")=tFormat
		Set %session.Data("IHE.Test",..%ClassName(0),"FHIRVersion")=tFHIRVersion
		
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tChkLogging = %page.%GetValueById("chkLogging")
		#; Disable logging for FHIR-related options.
		Set tChkLogging = 0
		Set tTest=tGroup.NewTest(tRequest,tChkLogging)
		
		If tMRN'="" {
			Set %session.Data("IHE.Test",..%ClassName(0),"Facility")=tRequest.Facility
			Set %session.Data("IHE.Test",..%ClassName(0),"AA")=tRequest.AssigningAuthority
			Set %session.Data("IHE.Test",..%ClassName(0),"AA Display")=$g(tAADisplay)
			Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=tRequest.MRN
			Do tGroup.AdditionalInfo.SetAt(tRequest.Facility,"Facility")
			Do tGroup.AdditionalInfo.SetAt(tRequest.AssigningAuthority,"AssigningAuthority")
			Do tGroup.AdditionalInfo.SetAt(tAADisplay,"AA Display")
			Do tGroup.AdditionalInfo.SetAt(tRequest.MRN,"MRN")
			
			// Clear out other demographic fields
			Set %session.Data("IHE.Test",..%ClassName(0),"LastName")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"FirstName")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"StreetLine")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"City")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"State")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"PostalCode")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"DOB")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"Sex")=""
			Do tGroup.AdditionalInfo.SetAt("","LastName")
			Do tGroup.AdditionalInfo.SetAt("","FirstName")
			Do tGroup.AdditionalInfo.SetAt("","Street")
			Do tGroup.AdditionalInfo.SetAt("","City")
			Do tGroup.AdditionalInfo.SetAt("","State")
			Do tGroup.AdditionalInfo.SetAt("","Zip")
			Do tGroup.AdditionalInfo.SetAt("","DOB")
			Do tGroup.AdditionalInfo.SetAt("","Sex")
		}
		Else {
			Set %session.Data("IHE.Test",..%ClassName(0),"LastName")=tRequest.LastName
			Set %session.Data("IHE.Test",..%ClassName(0),"FirstName")=tRequest.FirstName
			Set %session.Data("IHE.Test",..%ClassName(0),"StreetLine")=tRequest.Street
			Set %session.Data("IHE.Test",..%ClassName(0),"City")=tRequest.City
			Set %session.Data("IHE.Test",..%ClassName(0),"State")=tRequest.State
			Set %session.Data("IHE.Test",..%ClassName(0),"PostalCode")=tRequest.Zip
			Set %session.Data("IHE.Test",..%ClassName(0),"DOB")=tDOB
			Set %session.Data("IHE.Test",..%ClassName(0),"Sex")=tRequest.Sex
			Do tGroup.AdditionalInfo.SetAt(tRequest.LastName,"LastName")
			Do tGroup.AdditionalInfo.SetAt(tRequest.FirstName,"FirstName")
			Do tGroup.AdditionalInfo.SetAt(tRequest.Street,"Street")
			Do tGroup.AdditionalInfo.SetAt(tRequest.City,"City")
			Do tGroup.AdditionalInfo.SetAt(tRequest.State,"State")
			Do tGroup.AdditionalInfo.SetAt(tRequest.Zip,"Zip")
			Do:tDOB]"" tGroup.AdditionalInfo.SetAt(tDOB,"DOB")
			Do tGroup.AdditionalInfo.SetAt(tRequest.Sex,"Sex")
			
			// Clear out MRN/AA fields
			Set %session.Data("IHE.Test",..%ClassName(0),"Facility")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"AA")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"AA Display")=""
			Set %session.Data("IHE.Test",..%ClassName(0),"MRN")=""
			Do tGroup.AdditionalInfo.SetAt("","Facility")
			Do tGroup.AdditionalInfo.SetAt("","AssigningAuthority")
			Do tGroup.AdditionalInfo.SetAt("","AA Display")
			Do tGroup.AdditionalInfo.SetAt("","MRN")
		}
		Do tGroup.AdditionalInfo.SetAt(tServiceRegistry,"ServiceRegistry")
		If $g(tDomains)]"" Do tGroup.AdditionalInfo.SetAt(tDomains,"Domains")
		Do tGroup.AdditionalInfo.SetAt(tExactMatch,"ExactMatch")
		Do tGroup.AdditionalInfo.SetAt(tNIST,"NIST")
		Do tGroup.AdditionalInfo.SetAt(tRequest.MaxMatches,"MaxMatches")
		
		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
		} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID = ""
	}
	Quit tSessionID
}

Method SendGetURL(pURL) As %String
{
	set tSessionID = ""
	
	try {
		set tServiceName = %page.%GetValueById("cmbServiceRegistry")
		
		set tRequest = ##class(HS.Message.FHIR.Request).%New()
		
		set tRequest.Interaction = "read"
		
		do tRequest.AdditionalInfo.SetAt(pURL, "GetURL")
		
		do ..%SetValueById("txtResponse","")
		
		do tRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		set tFHIRVersion = %page.%GetValueById("cmbVersion")
		do tRequest.AdditionalInfo.SetAt("PDQmConsumer"_tFHIRVersion, "FHIRActor")
		
		if pURL'["_format=" {
			if tFHIRVersion="DSTU2" {
				if %page.%GetValueById("cmbFormat")["json" {
					set tRequest.ContentType = "application/json+fhir"
				} else {
					set tRequest.ContentType = "application/xml+fhir"
				}
			} else {
				if %page.%GetValueById("cmbFormat")["json" {
					set tRequest.ContentType = "application/fhir+json"
				} else {
					set tRequest.ContentType = "application/fhir+xml"
				}
			}
		}
		
		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tChkLogging = %page.%GetValueById("chkLogging")
		#; Disable logging for FHIR-related options.
		Set tChkLogging = 0
		Set tTest=tGroup.NewTest(tRequest,tChkLogging)
		
		Set tSessionID = ..ExecuteAsync(tTest,tGroup)
	} catch ex {
		Do ..LogException(ex,$g(tGroup))
		Set tSessionID = ""
	}
	quit tSessionID
}

Method DisplayTestResult(pTest As HS.Test.UI.Test, pGroupTest As HS.Test.UI.TestGroup = "", pClear = 0)
{
	Do ##super(pTest,pGroupTest,pClear)
	Set tResponse=pTest.Response
	If $isObject(tResponse) {
		If tResponse.%Extends("HS.Message.PatientSearchResponse") {
			If ($$$ISERR(tResponse.ErrStatus))&&(+tResponse.AdditionalInfo.GetAt("HTTPStatus")>399) {
				Set results=%page.%GetComponentById("paneResults")
				Set label=##class(%ZEN.Component.label).%New()
				Set tStatus = tResponse.AdditionalInfo.GetAt("HTTPStatus")
				If tStatus?1N.N {
					Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(tStatus, .tText)
					Set tStatus = tStatus_" "_tText
				}
				Set label.label = "HTTP Status = "_tStatus
				Do results.%AddChild(label)
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label = $system.Status.GetErrorText(tResponse.ErrStatus)
				Do results.%AddChild(label)
			} ElseIf $$$ISOK(pTest.Status) {
				If +%page.%GetValueById("txtMaxMatches")>0 Do %page.enableNavigation()
				Set results=%page.%GetComponentById("paneResults")
				Set tService = ..GetServiceRegistryEntry()
				Set tAffinityDomain = $$$AffinityDomain
				If $isObject(tService) {
					If tService.OIDMapCode.GetAt("AssigningAuthority")]"" Set tAffinityDomain=tService.OIDMapCode.GetAt("AssigningAuthority")
				}
				Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomain)
				If tResponse.Results.Count() {
					For tIdx=1:1:tResponse.Results.Count() {
						Set tItem = tResponse.Results.GetAt(tIdx)
						Set tName=tResponse.Results.GetAt(tIdx).FirstName_" "_tResponse.Results.GetAt(tIdx).LastName

						Set tGender=tItem.Sex
						Set tDOB=$ZDATE(tItem.DOB,5)
						If tItem.Addresses.Count()>0 {
							Set tAddressTemp=tItem.Addresses.GetAt(1)
							Set tAddress=tAddressTemp.StreetLine_", "_tAddressTemp.City_", "_tAddressTemp.State_" "_tAddressTemp.PostalCode
							Set tDemo="("_tGender_" / "_tDOB_" / "_tAddress_")"
						} Else {
							Set tDemo="("_tGender_" / "_tDOB_")"
						}

						Set tPatientId = ""
						Set tIdentifierList=tItem.Identifiers
						Set tIdentifiers=""
						For tIdx2=1:1:tIdentifierList.Count() {
							Set tRoot = ##class(HS.Data.OIDMap).GetURIForCode(tIdentifierList.GetAt(tIdx2).Root, tIdentifierList.GetAt(tIdx2).Root)
							Set tExtension = tIdentifierList.GetAt(tIdx2).Extension
							Set tRootOID = ""
							If $Extract(tRoot,1,8)="urn:oid:" {
								Set tRootOID = $Extract(tRoot,9,*)
							} ElseIf ##class(HS.FHIR.Utils).IsOID(tRoot) {
								Set tRootOID = tRoot
							} ElseIf $Extract(tRoot,1,4)="http" {
								Set tRootOID = ##class(HS.Data.OIDMap).GetOIDForURL(tRoot)
							}
							If tRootOID=tAffinityDomainOID {
								// Only setup tPatientId for the ID that matches the Affinity Domain, and skip writing
								// it to the identifier list to avoid duplication.
								// This will NOT be present for MRN/AA searches, as results are filtered to just the 
								// AA searched for initially.
								Set tPatientId = tExtension_"^^^&"_tRootOID_"&ISO"
								Continue
							}
							Set tIdentifier = tExtension_"^^^&"_tRootOID_"&ISO"
							Set tIdentifiers=tIdentifiers_","_tIdentifier
						}
						If tIdx=1 {
							Do:$G(tPatientId)'="" %page.%SetValueById("txtPatientID", tPatientId)
							Do ..AddRecentPatients(tResponse,,tAffinityDomainOID)
						}
						Set tIdentifiers=$e(tIdentifiers,2,*)
						
						Do:$G(tPatientId)'="" ..AddRecentPatientMRNAA(tPatientId,tIdentifiers)
						
						// Add FullUrl to RecentPatients without modifying HS.Test.UI.Main.
						If tItem.AdditionalInfo.GetAt("FullUrl")'="" {
							Kill tRecentPatients
							Merge tRecentPatients = %session.Data("IHE.Test","RecentPatients")
							Set tIndex = ""
							For {
								Set tIndex = $Order(tRecentPatients(tIndex))
								If tIndex="" Quit
								If $ListGet(tRecentPatients(tIndex),1)=tPatientId {
									Set tRecentPatients(tIndex) = $ListBuild($ListGet(tRecentPatients(tIndex),1),$ListGet(tRecentPatients(tIndex),2),tItem.AdditionalInfo.GetAt("FullUrl"))
								}
							}
							Merge %session.Data("IHE.Test","RecentPatients")=tRecentPatients
						}
						
						Do ..LogMessage() // First, just write a timestamp
						
						Set results=%page.%GetComponentById("paneResults")
						Set label=##class(%ZEN.Component.label).%New()
						Set tStatus = tResponse.AdditionalInfo.GetAt("HTTPStatus")
						If tStatus?1N.N {
							Set tSC = ##class(HS.FHIR.Helper).LookupHTTPStatusText(tStatus, .tText)
							Set tStatus = tStatus_" "_tText
						}
						Set label.label = "HTTP Status = "_tStatus
						Do results.%AddChild(label)
						
						Set label=##class(%ZEN.Component.label).%New()
						Set label.label=tName_"  "_tDemo
						// If we have tPatientId (not an MRN/AA Search), append it to the patient name.
						Set:$G(tPatientId) label.label=label.label_" ("_tPatientId_")"
						Do results.%AddChild(label)
						
						// Display the PDQm Patient resource id.
						If tItem.AdditionalInfo.GetAt("FullUrl")'="" {
							Set label=##class(%ZEN.Component.label).%New()
							Set label.value=tItem.AdditionalInfo.GetAt("FullUrl")
							Do results.%AddChild(label)
						}
						
						// Display the identifiers on separate lines.
						For jj = 1:1:$Length(tIdentifiers,",") {
							Set tX = $Piece(tIdentifiers,",",jj)
							If tX'="" {
								Set tX = $Replace(tX,"  "," ")
								Set tCode = ##class(HS.Data.OIDMap).GetCodeForURI($Piece(tX," ",2))
								If tCode'="" Set tX = tX_" ("_tCode_")"
								Set label=##class(%ZEN.Component.label).%New()
								Set label.value=tX
								Do results.%AddChild(label)
							}
						}
						
						// Add blank line between each patient.
						Set label=##class(%ZEN.Component.label).%New()
						Set label.label=" "
						Do results.%AddChild(label)
					}
				} ElseIf $$$ISERR(tResponse.ErrStatus) {
					Set label=##class(%ZEN.Component.label).%New()
					Set label.label=$system.Status.GetErrorText(tResponse.ErrStatus)
					Do results.%AddChild(label)
				} Else {
					Set label=##class(%ZEN.Component.label).%New()
					Set label.label="No Patients Found"
					Do results.%AddChild(label)
				}
				Set txtFirst = tResponse.AdditionalInfo.GetAt("first")
				If txtFirst["_format" {
					Set tFormatValue = $Piece($Piece(txtFirst,"_format=",2),"&",1)
					Set txtFirst = $Replace(txtFirst,"+","%2B")
				}
				Set txtPrevious = tResponse.AdditionalInfo.GetAt("previous")
				If txtPrevious["_format" {
					Set tFormatValue = $Piece($Piece(txtPrevious,"_format=",2),"&",1)
					Set txtPrevious = $Replace(txtPrevious,"+","%2B")
				}
				Set txtNext = tResponse.AdditionalInfo.GetAt("next")
				If txtNext["_format" {
					Set tFormatValue = $Piece($Piece(txtNext,"_format=",2),"&",1)
					Set txtNext = $Replace(txtNext,"+","%2B")
				}
				Set txtLast = tResponse.AdditionalInfo.GetAt("last")
				If txtLast["_format" {
					Set tFormatValue = $Piece($Piece(txtLast,"_format=",2),"&",1)
					Set txtLast = $Replace(txtLast,"+","%2B")
				}
				Do %page.%SetValueById("txtFirst",txtFirst)
				Do %page.%SetValueById("txtPrevious",txtPrevious)
				Do %page.%SetValueById("txtNext",txtNext)
				Do %page.%SetValueById("txtLast",txtLast)
			}
		} Else {
			#; It is an HS.Message.FHIR.Response.
			Set results=%page.%GetComponentById("paneResults")
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label="HTTP Status = "_tResponse.Status
			Do results.%AddChild(label)
			
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label=" "
			Do results.%AddChild(label)
			
			Set tStream = ##class(%Stream.GlobalCharacter).%New()
			Do tStream.CopyFrom(tResponse.Payload)
			Set tChar = ""
			For i = 1:1 Set tChar = tStream.Read(1,.tSC) Quit:$$$ISERR(tSC)  Quit:(tChar="<")||(tChar="{")  Quit:tStream.AtEnd
			Set tContentType = $Select(tChar="<":"xml",1:"json")
			Do tStream.Rewind()
			Set tFHIRVersion = %page.%GetValueById("cmbVersion")
			If tFHIRVersion="DSTU2" {
				Set tResourceSchemaRoot = "HS.FHIR.vDSTU2.Model.Resource"
			} Else {
				Set tResourceSchemaRoot = "HS.FHIR.vSTU3.Model.Resource"
			}
			Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(tContentType,tStream,.tHSFHIRObj,tResourceSchemaRoot)
			If tHSFHIRObj.%ClassName(0)="Patient" {
				Set (tFirstName,tMiddleName,tLastName)=""
				If tHSFHIRObj.name.Count()>0 {
					Set tNameObj = tHSFHIRObj.name.GetAt(1)
					If tNameObj.given.Count()>0 {
						Set tFirstName = tNameObj.given.GetAt(1).value
						If tNameObj.given.Count()>1 {
							Set tMiddleName = tNameObj.given.GetAt(2).value
						}
					}
					If tFHIRVersion="DSTU2" {
						If tNameObj.family.Count()>0 Set tLastName = tNameObj.family.GetAt(1).value
					} Else {
						Set tLastName = tNameObj.family.value
					}
				}
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label=tFirstName_$Select(tMiddleName'="":" "_tMiddleName,1:"")_" "_tLastName_" ("_tHSFHIRObj.gender.value_" / "_tHSFHIRObj.birthDate.value_")"
				Do results.%AddChild(label)
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label=" "
				Do results.%AddChild(label)
			} ElseIf tHSFHIRObj.%ClassName(0)="OperationOutcome" {
				If tHSFHIRObj.issue.Count()>0 {
					If ($IsObject(tHSFHIRObj.issue.GetAt(1).details))&&(tHSFHIRObj.issue.GetAt(1).details.text.value'="") {
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label=tHSFHIRObj.issue.GetAt(1).details.text.value
				Do results.%AddChild(label)
				Set label=##class(%ZEN.Component.label).%New()
				Set label.label=" "
				Do results.%AddChild(label)
					}
				}
			}
			Set label=##class(%ZEN.Component.label).%New()
			Set label.label=tResponse.Payload.Read()
			Do results.%AddChild(label)
		}
	}
}

ClientMethod Continue(pButton) [ Language = javascript ]
{
	// Generic method for navigating results
	// Extracts option from button name, retrieves URL for option, and calls StartSend(button,url) to start async process
	
	// Extract option from button name (First, Previous, Next, Last)
	var tOption = pButton.substring(3);
	var tFieldId = "txt"+tOption;
	// Get URL for specified option
	var tField = zenPage.getComponentById(tFieldId);
	var tURL = tField.getValue();
	
	zenPage.StartSend(pButton,tURL);
	zenPage.ToggleButton(pButton,0);
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	// Load dropdowns from parameters
	Set tCombo=..%GetComponentById("cmbGender")
	Set tCombo.valueList=",M,F,O,U"
	Set tCombo.displayList=",Male,Female,Other,Unknown"

	Set tCombo=..%GetComponentById("cmbFormat")
	Set tCombo.valueList=",application/fhir+xml,application/fhir+json,xml,json,application/xml+fhir,application/json+fhir"
	Set tCombo.displayList=tCombo.valueList
	
	Set tCombo=..%GetComponentById("cmbVersion")
	Set tCombo.valueList="STU3,DSTU2"
	Set tCombo.displayList=tCombo.valueList
	
	Set tLastName=$g(%session.Data("IHE.Test",..%ClassName(0),"LastName"))
	Set tFirstName=$g(%session.Data("IHE.Test",..%ClassName(0),"FirstName"))
	Set tStreet=$g(%session.Data("IHE.Test",..%ClassName(0),"Street"))
	Set tCity=$g(%session.Data("IHE.Test",..%ClassName(0),"City"))
	Set tState=$g(%session.Data("IHE.Test",..%ClassName(0),"State"))
	Set tZip=$g(%session.Data("IHE.Test",..%ClassName(0),"Zip"))
	Set tDOB=$g(%session.Data("IHE.Test",..%ClassName(0),"DOB"))
	Set tSex=$g(%session.Data("IHE.Test",..%ClassName(0),"Sex"))
	Set tFacility=$g(%session.Data("IHE.Test",..%ClassName(0),"Facility"))
	Set tAA=$g(%session.Data("IHE.Test",..%ClassName(0),"AA"))
	Set tAADisplay=$g(%session.Data("IHE.Test",..%ClassName(0),"AA Display"))
	Set tMRN=$g(%session.Data("IHE.Test",..%ClassName(0),"MRN"))
	Set tDomains=$g(%session.Data("IHE.Test",..%ClassName(0),"Domains"))
	Set tExactMatch=$g(%session.Data("IHE.Test",..%ClassName(0),"ExactMatch"))
	Set tNIST=$g(%session.Data("IHE.Test",..%ClassName(0),"NIST"))
	Set tMaxMatches=$g(%session.Data("IHE.Test",..%ClassName(0),"MaxMatches"))
	Set tFHIRFormat=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRFormat"))
	Do ..%SetValueById("cmbFormat", tFHIRFormat)
	Set tFHIRVersion=$g(%session.Data("IHE.Test",..%ClassName(0),"FHIRVersion"))
	Do ..%SetValueById("cmbVersion", tFHIRVersion)
	Set tServiceRegistry=$g(%session.Data("IHE.Test",..%ClassName(0),"ServiceRegistry"))
	Set:tServiceRegistry="" tServiceRegistry=..#SERVICEREGISTRYENTRY

	Do ..SetLogging()
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		Set tLastName=tGroup.AdditionalInfo.GetAt("LastName")
		Set tFirstName=tGroup.AdditionalInfo.GetAt("FirstName")
		Set tStreetLine=tGroup.AdditionalInfo.GetAt("Street")
		Set tCity=tGroup.AdditionalInfo.GetAt("City")
		Set tState=tGroup.AdditionalInfo.GetAt("State")
		Set tZip=tGroup.AdditionalInfo.GetAt("Zip")
		Set tDOB=tGroup.AdditionalInfo.GetAt("DOB")
		Set tSex=tGroup.AdditionalInfo.GetAt("Sex")
		Set tFacility=tGroup.AdditionalInfo.GetAt("Facility")
		Set tAA=tGroup.AdditionalInfo.GetAt("AssigningAuthority")
		Set tAADisplay=tGroup.AdditionalInfo.GetAt("AADisplay")
		Set tMRN=tGroup.AdditionalInfo.GetAt("MRN")
		Set tDomains=tGroup.AdditionalInfo.GetAt("Domains")
		Set tExactMatch=tGroup.AdditionalInfo.GetAt("ExactMatch")
		Set tNIST=tGroup.AdditionalInfo.GetAt("NIST")
		Set tMaxMatches=tGroup.AdditionalInfo.GetAt("MaxMatches")
		Set tServiceRegistry=tGroup.AdditionalInfo.GetAt("ServiceRegistry")
		
		If $isObject(tGroup) Do ..PostAsyncExecuteDisplay(tGroup,1)
	}
	
	Do ..%SetValueById("txtLastName",tLastName)
	Do ..%SetValueById("txtFirstName",tFirstName)
	Do ..%SetValueById("txtStreet",tStreet)	
	Do ..%SetValueById("txtCity",tCity)
	Do ..%SetValueById("txtState",tState)
	Do ..%SetValueById("txtZip",tZip)
	Do ..%SetValueById("cmbGender",tSex)
	Do ..%SetValueById("dtDOB",tDOB)
	Do ..%SetValueById("cmbAA",tAA)
	Do ..%SetValueById("cmbFacility",tFacility)
	Do ..%SetValueById("txtMRN",tMRN)
	Do ..%SetValueById("chkExactMatch",tExactMatch)
	Do ..%SetValueById("chkNIST",tNIST)
	Do ..%SetValueById("txtMaxMatches",tMaxMatches)
	Do ..%SetValueById("cmbServiceRegistry",tServiceRegistry)
	Do ..%SetValueById("version","PDQm")
	
	Do %page.disableNavigation()
	
	Quit $$$OK
}

Method disableNavigation() [ ZenMethod ]
{
	Set %page.%GetComponentById("txtFirst").hidden="1"
	Set %page.%GetComponentById("btnFirst").hidden="1"
	Set %page.%GetComponentById("txtPrevious").hidden="1"
	Set %page.%GetComponentById("btnPrevious").hidden="1"
	Set %page.%GetComponentById("txtNext").hidden="1"
	Set %page.%GetComponentById("btnNext").hidden="1"
	Set %page.%GetComponentById("txtLast").hidden="1"
	Set %page.%GetComponentById("btnLast").hidden="1"
}

Method enableNavigation() [ ZenMethod ]
{
	Set %page.%GetComponentById("txtFirst").hidden="0"
	Set %page.%GetComponentById("btnFirst").hidden="0"
	Set %page.%GetComponentById("txtPrevious").hidden="0"
	Set %page.%GetComponentById("btnPrevious").hidden="0"
	Set %page.%GetComponentById("txtNext").hidden="0"
	Set %page.%GetComponentById("btnNext").hidden="0"
	Set %page.%GetComponentById("txtLast").hidden="0"
	Set %page.%GetComponentById("btnLast").hidden="0"
}

}

Class HS.Types.Identifier Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

// temporarily updating the MAXLEN to support PIX / PDQ transformation to Request with a post conversion to the code

Property Root As %String(MAXLEN = 512);

Property Extension As %String(MAXLEN = 512);

Property AssigningAuthorityName As %String(MAXLEN = "");

/// Legacy Values taken from HL7v2 2.6:203 Identifer Type code table
/// Full list: ",American Express,American Medical Association Number,Account number,Anonymous identifier,Account number Creditor,Account number debitor,Temporary Account Number,Advanced Practice Registered Nurse number,Bank Account Number,Bank Card Number,Birth Certificate,Birth registry number,Breed Registry Number,Cost Center number,Change of Name Document,Citizenship Card,County number,Dentist license number,Drug Enforcement Administration registration number,Diner's Club card,Drug Furnishing or prescriptive authority Number,Driver's license number,Doctor number,Osteopathic License number,Diplomatic Passport,Podiatrist license number,Donor Registration Number,Discover Card,Employee number,Employer number,Staff Enterprise Number,Facility ID,Guarantor internal identifier,General ledger number,Guarantor external identifier,Health Card Number,Jurisdictional health number (Canada),Indigenous/Aboriginal,Labor and industries number,License number,Local Registry ID,Patient Medicaid number,Member Number,Patient's Medicare number,Practitioner Medicaid number,Microchip Number,Practitioner Medicare number,Marriage Certificate,Medical License number,Military ID number,Medical record number,Temporary Medical Record Number,MasterCard,Naturalization Certificate,National employer identifier,National Health Plan Identifier,National unique individual identifier,National Insurance Organization Identifier,National Insurance Payor Identifier (Payor),National Person Identifier where the xxx is the ISO table 3166 3-character (alphabetic) country code,Nurse practitioner number,National provider identifier,Optometrist license number,Physician Assistant number,Parole Card,Penitentiary/correctional institution Number,Living Subject Enterprise Number,Pension Number,Patient internal identifier,Person number,Temporary Living Subject Number,Medicare/CMS Performing Provider Identification Number,Passport number,Permanent Resident Card Number,Provider number,Patient external identifier,QA number,Resource identifier,Pharmacist license number,Registered Nurse Number,Railroad Retirement number,Regional registry ID,Railroad Retirement Provider,State license,Subscriber Number,Study Permit,State registry ID,Social Security number,Tax ID number,Treaty Number/ (Canada),Temporary Permanent Resident (Canada),Unspecified identifier,Medicare/CMS (formerly HCFA)'s Universal Physician Identification numbers,Visit number,Visitor Permit,VISA,WIC identifier,Workers' Comp Number,Work Permit,Organization identifier", VALUELIST = ",AM,AMA,AN,ANON,ANC,AND,ANT,APRN,BA,BC,BCT,BR,BRN,CC,CONM,CZ,CY,DDS,DEA,DI,DFN,DL,DN,DO,DP,DPM,DR,DS,EI,EN,ESN,FI,GI,GL,GN,HC,JHN,IND,LI,LN,LR,MA,MB,MC,MCD,MCN,MCR,MCT,MD,MI,MR,MRT,MS,NCT,NE,NH,NI,NII,NIIP,NNxxx,NP,NPI,OD,PA,PC,PCN,PE,PEN,PI,PN,PNT,PPIN,PPN,PRC,PRN,PT,QA,RI,RPH,RN,RR,RRI,RRP,SL,SN,SP,SR,SS,TAX,TN,TPR,U,UPIN,VN,VP,VS,WC,WCN,WP,XX"
/// Property Use As %String(DISPLAYLIST = ",Driver's license number,Doctor number,License number,Medical record number,Patient internal identifier,Passport number,Patient external identifier,Resouce Identifier,Subscriber Number,Social Security number,Organization identifier", VALUELIST = ",DL,DN,LN,MR,PI,PPN,PT,RI,SN,SS,XX");
/// We no longer use this to restrict it, for patient identifiers.
/// If ##class(HS.Registry.Config).GetKeyValue("\General\LegacyPatientIdentifierTypeRestriction",0) we restrict it to DL (driver license), XX (corporate ID), SN (subscriber number), PPN (passport number)
/// Otherwise, we validate using the Identifier Type table (HS.AssignAuth.IdentifierType)
Property Use As %String;

Property Status As %String(DISPLAYLIST = ",Active,Inactive,Revoked,Suspended", VALUELIST = ",A,I,R,S") [ InitialExpression = "A" ];

/// Further classification of the type of identifier.  Currently used by Provider Directory
Property Type As %String;

/// Base JSON translations.
XData BasicReference [ XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="Root" FieldName="root"/>
<Property Name="Extension" FieldName="extension"/>
<Property Name="AssigningAuthorityName" FieldName="assigning_authority_name"/>
<Property Name="Use" FieldName="use"/>
<Property Name="Status" FieldName="status"/>
<Property Name="Type" FieldName="type"/>
</Mapping>
}

/// JSON translations for a Clinician Identifier as used by the User/Clinician registry.
/// Root - not used
/// Status - not used
/// Type - not used
/// Can see these are not used by looking at HS.UI.Registry.User.Manage:SaveUserData
XData ClinicianIdentifier [ XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="Root" Include="NONE"/>
<Property Name="Extension" FieldName="extension"/>
<Property Name="AssigningAuthorityName" FieldName="assigning_authority_name"/>
<Property Name="Use" FieldName="use"/>
<Property Name="Status" Include="NONE"/>
<Property Name="Type" Include="NONE"/>
</Mapping>
}

/*
 * NOTE: Need to be careful about adding any validation in %OnValidateObject() in this class as it is used
 * for multiple features so validation can break some features.
 */
/// Do validation on property <property>AssigningAuthorityName</property>. <br />
/// Optionally validate that the assigning authority type matches <var>pType</var>. <br />
Method ValidateAssigningAuthorityName(pType As %String = "") [ Internal ]
{
	/*
	 * AssigningAuthorityName comes from class query as per HS.UI.Registry.User.Util:%LoadAssigningAuthorities for User/Clinician registry
	 * Logic is mirrored from there while maintaining generality by using pType as an optional argument.
	 */
	#dim resultSet As %SQL.StatementResult
	Set statement = ##class(%SQL.Statement).%New()
	Set query = "SELECT ID FROM HS_AssignAuth.Config WHERE Code = ?"
	Set arguments($Increment(arguments)) = ..AssigningAuthorityName
	If (pType '= "") {
		Set query = query _ " AND %Internal(IdentifierType) = ?"
		Set arguments($Increment(arguments)) = pType
	}
	$$$ThrowOnError(statement.%Prepare(query))
	Set resultSet = statement.%Execute(arguments...)
	If (resultSet.%SQLCODE < 0) {
		Throw ##class(%Exception.SQL).CreateFromSQLCODE(resultSet.%SQLCODE, resultSet.%Message)
	}
	If 'resultSet.%Next(.sc) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Non-existent assigning authority code provided: "_..AssigningAuthorityName))
	}
}

Storage Default
{
<Data name="IdentifierState">
<Value name="1">
<Value>Root</Value>
</Value>
<Value name="2">
<Value>Extension</Value>
</Value>
<Value name="3">
<Value>AssigningAuthorityName</Value>
</Value>
<Value name="4">
<Value>Use</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<State>IdentifierState</State>
<StreamLocation>^HS.Types.IdentifierS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

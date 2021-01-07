Class HS.Gateway.SDA3.SDA3ToX12.X837apPv5010 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.EDI.X12.Document) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.EDI.X12.Document' sourceDocType='HS.SDA3:Container' targetDocType='HIPAA_5010:837apP' create='new' language='objectscript' >
<assign value='"837"' property='target.{ST:TransactionSetIdentifierCode}' action='set' />
<assign value='"0021"' property='target.{ST:TransactionSetControlNumber}' action='set' />
<assign value='"005010X298"' property='target.{ST:ImplementationConventionRefe}' action='set' />
<assign value='"0019"' property='target.{BHT:HierarchicalStructureCode}' action='set' />
<assign value='"00"' property='target.{BHT:TransactionSetPurposeCode}' action='set' />
<assign value='"244579"' property='target.{BHT:RefId}' action='set' />
<assign value='"20120315"' property='target.{BHT:Date}' action='set' />
<assign value='"1023"' property='target.{BHT:Time}' action='set' />
<assign value='"RP"' property='target.{BHT:TransactionTypeCode}' action='set' />
<assign value='"41"' property='target.{loop1000A.NM1:EntityIdentifierCode}' action='set' />
<assign value='"2"' property='target.{loop1000A.NM1:EntityTypeQualifier}' action='set' />
<assign value='"ABC Plan"' property='target.{loop1000A.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"46"' property='target.{loop1000A.NM1:EntityIdentifierCode2}' action='set' />
<assign value='"TGJ23"' property='target.{loop1000A.NM1:NameLastorOrganizationName2}' action='set' />
<assign value='"IC"' property='target.{loop1000A.PER(1):ContactFunctionCode}' action='set' />
<assign value='"IT Group"' property='target.{loop1000A.PER(1):Name}' action='set' />
<assign value='"TE"' property='target.{loop1000A.PER(1):CommunicationNumberQualifier}' action='set' />
<assign value='"3055552222"' property='target.{loop1000A.PER(1):CommunicationNumber}' action='set' />
<assign value='"EX"' property='target.{loop1000A.PER(1):CommunicationNumberQualifier2}' action='set' />
<assign value='"231"' property='target.{loop1000A.PER(1):CommunicationNumber2}' action='set' />
<assign value='"40"' property='target.{loop1000B.NM1:EntityIdentifierCode}' action='set' />
<assign value='"2"' property='target.{loop1000B.NM1:EntityTypeQualifier}' action='set' />
<assign value='"REPORTING ENTITY"' property='target.{loop1000B.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"46"' property='target.{loop1000B.NM1:EntityIdentifierCode2}' action='set' />
<assign value='"66783JJT"' property='target.{loop1000B.NM1:NameLastorOrganizationName2}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).HL!3=20:HierarchicalIDNumber}' action='set' />
<assign value='"20"' property='target.{loop2000A(1).HL!3=20:HierarchicalLevelCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).HL!3=20:HierarchicalChildCode}' action='set' />
<assign value='"BI"' property='target.{loop2000A(1).PRV:ProviderCode}' action='set' />
<assign value='"85"' property='target.{loop2000A(1).loop2010AA.NM1:EntityIdentifierCode}' action='set' />
<assign value='"2"' property='target.{loop2000A(1).loop2010AA.NM1:EntityTypeQualifier}' action='set' />
<assign value='"PHYSICIAN CLINIC"' property='target.{loop2000A(1).loop2010AA.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"XX"' property='target.{loop2000A(1).loop2010AA.NM1:EntityIdentifierCode2}' action='set' />
<assign value='"9876543210"' property='target.{loop2000A(1).loop2010AA.NM1:NameLastorOrganizationName2}' action='set' />
<assign value='"234 SEAWAY ST"' property='target.{loop2000A(1).loop2010AA.N3:AddressInformation}' action='set' />
<assign value='"MIAMI"' property='target.{loop2000A(1).loop2010AA.N4:CityName}' action='set' />
<assign value='"FL"' property='target.{loop2000A().loop2010AA.N4:StateorProvinceCode}' action='set' />
<assign value='"33111"' property='target.{loop2000A(1).loop2010AA.N4:PostalCode}' action='set' />
<assign value='"EI"' property='target.{loop2000A(1).loop2010AA.REF(1):RefIdQualifier}' action='set' />
<assign value='"587654321"' property='target.{loop2000A(1).loop2010AA.REF(1):RefId}' action='set' />
<assign value='"2"' property='target.{loop2000A(1).loop2000B(1).HL!3=22:HierarchicalIDNumber}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).HL!3=22:HierarchicalParentIDNumber}' action='set' />
<assign value='"22"' property='target.{loop2000A(1).loop2000B(1).HL!3=22:HierarchicalLevelCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).HL!3=22:HierarchicalChildCode}' action='set' />
<assign value='"N"' property='target.{loop2000A(1).loop2000B(1).SBR:PayerResponsibilitySequenceN}' action='set' />
<assign value='"IL"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.NM1:EntityIdentifierCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.NM1:EntityTypeQualifier}' action='set' />
<assign value='"SMITH"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"JANE"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.NM1:NameFirst}' action='set' />
<assign value='"MI"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.NM1:EntityIdentifierCode2}' action='set' />
<assign value='"JS00111223333"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.NM1:NameLastorOrganizationName2}' action='set' />
<assign value='"891 GREENWAY ST"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.N3:AddressInformation}' action='set' />
<assign value='"MIAMI"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.N4:CityName}' action='set' />
<assign value='"FL"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.N4:StateorProvinceCode}' action='set' />
<assign value='"33111"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.N4:PostalCode}' action='set' />
<assign value='"D8"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.DMG:DateTimePeriodFormatQualifie}' action='set' />
<assign value='"19430501"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.DMG:DateTimePeriod}' action='set' />
<assign value='"F"' property='target.{loop2000A(1).loop2000B(1).loop2010BA.DMG:GenderCode}' action='set' />
<assign value='"ZD"' property='target.{loop2000A(1).loop2000B(1).loop2010BB.NM1:EntityIdentifierCode}' action='set' />
<assign value='"2"' property='target.{loop2000A(1).loop2000B(1).loop2010BB.NM1:EntityTypeQualifier}' action='set' />
<assign value='"DATA RECEIVER"' property='target.{loop2000A(1).loop2000B(1).loop2010BB.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"3"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).HL!3=23:HierarchicalIDNumber}' action='set' />
<assign value='"2"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).HL!3=23:HierarchicalParentIDNumber}' action='set' />
<assign value='"23"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).HL!3=23:HierarchicalLevelCode}' action='set' />
<assign value='"0"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).HL!3=23:HierarchicalChildCode}' action='set' />
<assign value='"19"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).PAT:IndividualRelationshipCode}' action='set' />
<assign value='"QC"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.NM1:EntityIdentifierCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.NM1:EntityTypeQualifier}' action='set' />
<assign value='"SMITH"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"236 N MAIN ST"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.N3:AddressInformation}' action='set' />
<assign value='"MIAMI"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.N4:CityName}' action='set' />
<assign value='"D8"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.DMG:DateTimePeriodFormatQualifie}' action='set' />
<assign value='"19730501"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.DMG:DateTimePeriod}' action='set' />
<assign value='"M"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.DMG:GenderCode}' action='set' />
<assign value='"FL"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.N4:StateorProvinceCode}' action='set' />
<assign value='"33413"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.N4:PostalCode}' action='set' />
<assign value='"TED"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.NM1:NameFirst}' action='set' />
<assign value='"MI"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.NM1:EntityIdentifierCode2}' action='set' />
<assign value='"JS00111224444"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2010CA.NM1:NameLastorOrganizationName2}' action='set' />
<assign value='"26463774"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).CLM:ClaimSubmittersIdentifier}' action='set' />
<assign value='"100"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).CLM:MonetaryAmount}' action='set' />
<assign value='"11:B:1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).CLM:HealthCareServiceLocationInf}' action='set' />
<assign value='"BK:0340"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).HI(1):HealthCareCodeInformation}' action='set' />
<assign value='"BF:V7389"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).HI(1):HealthCareCodeInformation2}' action='set' />
<assign value='"88"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.NM1:EntityIdentifierCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.NM1:EntityTypeQualifier}' action='set' />
<assign value='"JONES"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"BARNABY"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.NM1:NameFirst}' action='set' />
<assign value='"XX"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.NM1:IdentificationCodeQualifier}' action='set' />
<assign value='"1234567890"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.NM1:IdentificationCode}' action='set' />
<assign value='"123 MAIN ST"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.N3:AddressInformation}' action='set' />
<assign value='"CAMBRIDGE"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.N4:CityName}' action='set' />
<assign value='"MA"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.N4:StateorProvinceCode}' action='set' />
<assign value='"02139"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2310C.N4:PostalCode}' action='set' />
<assign value='"P"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).SBR:PayerResponsibilitySequenceN}' action='set' />
<assign value='"01"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).SBR:IndividualRelationshipCode}' action='set' />
<assign value='"2222-SJ"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).SBR:RefId}' action='set' />
<assign value='"6"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).SBR:CoordinationofBenefitsCode}' action='set' />
<assign value='"Cl"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).SBR:ClaimFilingIndicatorCode}' action='set' />
<assign value='"D"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).AMT(1):AmountQualifierCode}' action='set' />
<assign value='"75"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).AMT(1):MonetaryAmount}' action='set' />
<assign value='"IL"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.NM1:EntityIdentifierCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.NM1:EntityTypeQualifier}' action='set' />
<assign value='"SMITH"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"JANE"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.NM1:NameFirst}' action='set' />
<assign value='"MI"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.NM1:IdentificationCodeQualifier}' action='set' />
<assign value='"JS0011223333"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.NM1:IdentificationCode}' action='set' />
<assign value='"236 N MAIN ST"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.N3:AddressInformation}' action='set' />
<assign value='"MIAMI"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.N4:CityName}' action='set' />
<assign value='"FL"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.N4:StateorProvinceCode}' action='set' />
<assign value='"33413"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330A.N4:PostalCode}' action='set' />
<assign value='"PR"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.NM1:EntityIdentifierCode}' action='set' />
<assign value='"2"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.NM1:EntityTypeQualifier}' action='set' />
<assign value='"ABC PLAN"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"PI"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.NM1:IdentificationCodeQualifier}' action='set' />
<assign value='"59999"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.NM1:IdentificationCode}' action='set' />
<assign value='"573"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.DTP:DateTimeQualifier}' action='set' />
<assign value='"D8"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.DTP:DateTimePeriodFormatQualifie}' action='set' />
<assign value='"20120314"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.DTP:DateTimePeriod}' action='set' />
<assign value='"F8"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.REF(1):RefIdQualifier}' action='set' />
<assign value='"20121092600001"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330B.REF(1):RefId}' action='set' />
<assign value='"QC"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.NM1:EntityIdentifierCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.NM1:EntityTypeQualifier}' action='set' />
<assign value='"SMITH"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.NM1:NameLastorOrganizationName}' action='set' />
<assign value='"TED"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.NM1:NameFirst}' action='set' />
<assign value='"MI"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.NM1:IdentificationCodeQualifier}' action='set' />
<assign value='"JS0011224444"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.NM1:IdentificationCode}' action='set' />
<assign value='"236 N MAIN ST"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.N3:AddressInformation}' action='set' />
<assign value='"MIAMI"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.N4:CityName}' action='set' />
<assign value='"FL"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.N4:StateorProvinceCode}' action='set' />
<assign value='"33413"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2320(1).loop2330C.N4:PostalCode}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).LX:AssignedNumber}' action='set' />
<assign value='"HC:99213"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:CompositeMedicalProcedureIde}' action='set' />
<assign value='"100"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:MonetaryAmount}' action='set' />
<assign value='"UN"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:UnitorBasisforMeasurementCod}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:Quantity}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:CompositeDiagnosisCodePointe}' action='set' />
<assign value='"Y"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:YesNoConditionorResponseCode}' action='set' />
<assign value='"N"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:YesNoConditionorResponseCode2}' action='set' />
<assign value='"N"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).SV1:YesNoConditionorResponseCode3}' action='set' />
<assign value='"472"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).DTP(1):DateTimeQualifier}' action='set' />
<assign value='"D8"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).DTP(1):DateTimePeriodFormatQualifie}' action='set' />
<assign value='"20120204"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).DTP(1):DateTimePeriod}' action='set' />
<assign value='"P"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).SVD:IdentificationCode}' action='set' />
<assign value='"75"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).SVD:MonetaryAmount}' action='set' />
<assign value='"HC:99213"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).SVD:CompositeMedicalProcedureIde}' action='set' />
<assign value='"1"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).SVD:Quantity}' action='set' />
<assign value='"CO"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).CAS(1):ClaimAdjustmentGroupCode}' action='set' />
<assign value='"45"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).CAS(1):ClaimAdjustmentReasonCode}' action='set' />
<assign value='"25"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).CAS(1):MonetaryAmount}' action='set' />
<assign value='"573"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).DTP:DateTimeQualifier}' action='set' />
<assign value='"D8"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).DTP:DateTimePeriodFormatQualifie}' action='set' />
<assign value='"20120314"' property='target.{loop2000A(1).loop2000B(1).loop2000C(1).loop2300(1).loop2400(1).loop2430(1).DTP:DateTimePeriod}' action='set' />
<assign value='"46"' property='target.{SE:NumberofIncludedSegments}' action='set' />
</transform>
}

}

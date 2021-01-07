Class HS.SDA3.AbstractOrder [ Abstract ]
{

/// Must be filled in on descendent class<br>
/// This will determine the order type of the order item
Parameter ORDERITEMTYPE;

/// The ID assigned to the order when it was placed<br><br>
/// HL7ToSDA3:<br>
/// OBR-3.1 will be used if present, else ORC-3.1 will be used.<br><br>
/// Streamlet cache:<br>
/// The processing the PlacerId undergoes in the Streamlet Cache is dependent<br>
/// on the type of Order being processed:<br>
/// -LAB:<br>
/// In the OnBeforeMatch method of the Streamlet class, if PlacerId is null, it<br>
/// is defaulted to ExternalId. If the PlacerId, FillerId, ExternalId, and<br>
/// Result.ExternalId are all null, an error will be logged and the LabOrder<br>
/// will not be processed. If the LabOrder has no OrderItem and does not match<br>
/// exactly 1 other LabOrder in the same Encounter on PlacerId (ALPHAUP<br>
/// collated), an error will be logged and the LabOrder will not be processed.<br>
/// -RAD,OTH:<br>
/// In the OnBeforeMatch method of the Streamlet class, if PlacerId is null, it<br>
/// is defaulted to ExternalId, then to FillerId, which itself may have been<br>
/// defaulted to the Result ExternalId. If PlacerId, FillerId, ExternalId and<br>
/// Result.ExternalId are all null, an error will be logged and the Order will<br>
/// not be processed. If the Order has no OrderItem and does not match exactly<br>
/// 1 other Order of the same type in the same Encounter on PlacerId (ALPHAUP<br>
/// collated), an error will be logged and the Order will not be processed.<br>
/// -MED,VXU:<br>
/// In the OnBeforeMatch method of the Streamlet class, if PlacerId is null, it<br>
/// is defaulted to ExternalId, then to FillerId. If the Order has no OrderItem<br>
/// or DrugProduct and does not match exactly 1 other Order of the same type in<br>
/// the same Encounter on PlacerId (ALPHAUP collated), an error will be logged<br>
/// and the Order will not be processed.<br><br>
/// Viewer cache:<br>
/// For LabOrders only, if FillerId is null and Result.ResultType = "AT", then<br>
/// FillerId will be defaulted to PlacerId.<br><br>
/// HL7:  ORC-2.1 : PlacerOrderNumber.EntityIdentifier<br>
/// HL7:  OBR-2.1 : PlacerOrderNumber.EntityIdentifier<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIPlacerNo)
Property PlacerId As %String(MAXLEN = 220);

/// The namespace from which the ID is assigned to the order when it was placed<br><br>
/// HL7ToSDA3:<br>
/// OBR-2 will be used if a value can be parsed from it, else ORC-2 will be<br>
/// used. In either case, PlacerAssigningAuthority is composed of subfields 2,<br>
/// 3, and 4 concatenated together as "[.2]^[.3]^[.4]", but only if at least<br>
/// one of these is not null.<br><br>
/// HL7:  ORC-2.2 : PlacerOrderNumber.NamespaceID<br>
/// HL7:  ORC-2.3 : PlacerOrderNumber.UniversalID<br>
/// HL7:  ORC-2.4 : PlacerOrderNumber.UniversalIDType<br>
/// HL7:  OBR-2.2 : PlacerOrderNumber.NamespaceID<br>
/// HL7:  OBR-2.3 : PlacerOrderNumber.UniversalID<br>
/// HL7:  OBR-2.4 : PlacerOrderNumber.UniversalIDType<br>
/// VIEWERLIB: Not stored
Property PlacerAssigningAuthority As %String(MAXLEN = 220);

/// The ID assigned to the order when it was filled<br><br>
/// HL7ToSDA3:<br>
/// OBR-3.1 will be used if present, else ORC-3.1 will be used.<br><br>
/// Streamlet cache:<br>
/// The processing the FillerId undergoes in the Streamlet Cache is dependent<br>
/// on the type of Order being processed:<br>
/// -LAB:<br>
/// In the OnBeforeMatch method of the Streamlet class, if FillerId is null, it<br>
/// will be defaulted to the Result ExternalId, then to PlacerId, which itself<br>
/// may have been defaulted to ExternalId. If FillerId, PlacerId, ExternalId,<br>
/// and Result.ExternalId are all null, an error will be logged and the<br>
/// LabOrder will not be processed.<br>
/// -RAD,OTH:<br>
/// In the OnBeforeMatch method of the Streamlet class, if FillerId is null, it<br>
/// will be defaulted to the Result ExternalId. If FillerId, PlacerId,<br>
/// ExternalId, and Result.ExternalId are all null, an error will be logged and<br>
/// the Order will not be processed.<br><br>
/// Viewer cache:<br>
/// For LabOrders only, if FillerId is null and Result.ResultType = "AT", then<br>
/// FillerId will be defaulted to PlacerId. Also for LabOrders only, the stored<br>
/// value for FillerId in the Viewer Cache is required to be unique. If an<br>
/// inbound LabOrder.FillerId matches one already in the Viewer Cache (if the<br>
/// same patient record has been loaded multiple times, for example), the<br>
/// inbound value is made unique by appending "x[OEORDId]" to it, where<br>
/// "[OEORDId]" is the ID of the parent OEOrder to the OEOrdItem that the<br>
/// LabOrder is stored as.<br><br>
/// HL7:  ORC-3.1 : FillerOrderNumber.EntityIdentifier<br>
/// HL7:  OBR-3.1 : FillerOrderNumber.EntityIdentifier<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIFillerNo)<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORILabEpisodeNo)<br>
Property FillerId As %String(MAXLEN = 220);

/// The namespace from which the ID was assigned to the order when it was<br>
/// filled<br><br>
/// HL7ToSDA3:<br>
/// OBR-3 will be used if a value can be parsed from it, else ORC-3 will be<br>
/// used. In either case, FillerAssigningAuthority is composed of subfields 2,<br>
/// 3, and 4 concatenated together as "[.2]^[.3]^[.4]", but only if at least<br>
/// one of these is not null.<br><br>
/// HL7:  ORC-3.2 : FillerOrderNumber.NamespaceID<br>
/// HL7:  ORC-3.3 : FillerOrderNumber.UniversalID<br>
/// HL7:  ORC-3.4 : FillerOrderNumber.UniversalIDType<br>
/// HL7:  OBR-3.2 : FillerOrderNumber.NamespaceID<br>
/// HL7:  OBR-3.3 : FillerOrderNumber.UniversalID<br>
/// HL7:  OBR-3.4 : FillerOrderNumber.UniversalIDType<br>
/// VIEWERLIB: Not stored
Property FillerAssigningAuthority As %String(MAXLEN = 220);

/// What was ordered<br><br>
/// HL7ToSDA3:<br>
/// OBR-4 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// Streamlet cache:<br>
/// For Medications and Vaccinations, in the OnBeforeMatch method of the<br>
/// Streamlet class, if the Order has no OrderItem but does have a DrugProduct,<br>
/// then an OrderItem will be defaulted in with Code, Description, and<br>
/// SDACodingStandard copied from the DrugProduct. For all types of Orders (and<br>
/// for Medications and Vaccinations, following this defaulting), if the Order<br>
/// has no OrderItem and does not match exactly 1 other Order of the same type<br>
/// in the same Encounter on PlacerId (ALPHAUP collated), an error will be<br>
/// logged and the Order will not be processed. In the OnValidate method, if<br>
/// the Order does not have an OrderItem (if it was deleted in an update, for<br>
/// example), an error will be logged and the Order will not be saved.<br><br>
/// HL7: OBR-4 : UniversalServiceIdentifier<br>
/// SDATableName=Order, ViewerClass=User.HS.ARCItmMast<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIItmMastDR)<br><br>
/// .Code<br>
/// Viewer cache:<br>
/// TRName is for text results only.<br>
/// HL7:  OBR-4.1 : UniversalServiceIdentifier.Identifier<br>
/// VIEWERLIB: User.HS.ARCItmMast(ARCIMCode)<br>
/// VIEWERLIB: User.HS.OETextResult(TRName)<br>
/// .Description<br>
/// HL7:  OBR-4.2 : UniversalServiceIdentifier.Text<br>
/// VIEWERLIB: User.HS.ARCItmMast(ARCIMDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  OBR-4.3 : UniversalServiceIdentifier.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .CodeSystemVersionId<br>
/// HL7:  OBR-4.7 : UniversalServiceIdentifier.CodingSystemVersionID<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// In addition to subfield 1 or 2 not being null, if subfield 4 or 5 is not<br>
/// null, then subfields 4, 5, 6, and 8 will be parsed into the Code,<br>
/// Description, CodeSystem, and CodeSystemVersionId, respectively, of a<br>
/// PriorCode in the list of PriorCodes. In this case, the PriorCode Type is<br>
/// set to "A".<br>
/// HL7:  OBR-4.4 : UniversalServiceIdentifier.AlternateIdentifier<br>
/// HL7:  OBR-4.5 : UniversalServiceIdentifier.AlternateText<br>
/// HL7:  OBR-4.6 : UniversalServiceIdentifier.NameofAlternateCodingSystem<br>
/// HL7:  OBR-4.8 : UniversalServiceIdentifier.AlternateCodingSystemVersionID<br>
/// VIEWERLIB: Not stored<br>
/// .OriginalText<br>
/// HL7:  OBR-4.9 : UniversalServiceIdentifier.OriginalText<br>
/// VIEWERLIB: Not stored
Property OrderItem As HS.SDA3.CodeTableDetail.Order;

/// Can be used to group orders in the Clinical Viewer.<br><br>
/// HL7ToSDA3:<br>
/// OBR-24 is parsed to the OrderCategory Code. HL7ToSDA3 does not set the<br>
/// Description. The parsed value is converted to uppercase in the SDA.<br><br>
/// Streamlet cache:<br>
/// For all Order types, in the OnValidate method of the Streamlet class, if<br>
/// the Order has an OrderCategory, then the InfoSubType of the streamlet is<br>
/// set to the OrderCategory Code, converted to uppercase.<br><br>
/// Viewer cache:<br>
/// The OrderCategory is stored as a property of the ARCItmMast (OrderItem),<br>
/// which is itself a property of the OEOrderItem (Order).<br><br>
/// HL7:  OBR-24 : DiagnosticServSectID<br>
/// SDATableName=OrderCategory, ViewerClass=User.HS.ARCItemCat<br>
/// VIEWERLIB: User.HS.ARCItmMast(ARCIMItemCatDR)<br>
Property OrderCategory As HS.SDA3.CodeTableDetail.OrderCategory;

/// Number of items ordered<br><br>
/// HL7ToSDA3:<br>
/// OrderQuantity is parsed from (in order of precendence) TQ1-2.1, RXE-1.1.1,<br>
/// OBR-27.1.1, or ORC-7.1.1. Though ORC-7 is a repeating field, HL7ToSDA3 only<br>
/// parses the first non-null instance. OBR-27 is also a repeating field, and<br>
/// HL7ToSDA3 parses every non-null instance of it. The last non-null instance<br>
/// of Quantity in OBR-27 is the one that takes precedence. Note that an<br>
/// RDE_O11 message may contain TQ1 segments in two different places. HL7ToSDA3<br>
/// parses the one following the RXE segment.<br><br>
/// HL7:  ORC-7.1.1 : QuantityTiming.Quantity.Quantity<br>
/// HL7:  OBR-27.1.1 : QuantityTiming.Quantity.Quantity<br>
/// HL7:  RXE-1.1.1 : QuantityTiming.Quantity.Quantity<br>
/// HL7:  TQ1-2.1   : Quantity.Quantity<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIQty)
Property OrderQuantity As %String;

/// Who placed the order<br><br>
/// HL7ToSDA3:<br>
/// OrderedBy is parsed from (in order of precendence) OBR-16, RXO-14, RXE-13,<br>
/// or ORC-12 and -24. Though each of these fields is repeating, for each one<br>
/// except ORC-24, HL7ToSDA3 will only parse the first non-null instance. For<br>
/// ORC-24, the instance corresponding to the first non-null instance of ORC-12<br>
/// will be parsed. ORC-12 and -24 are used in combination to set the<br>
/// provider's Name and Address in the SDA. Every other field only sets the<br>
/// Name. For Adress.City, .State, .Zip, .Country, and .County as well as NameTypeCode<br>
/// and IdentifierTypeCode, only the Code is parsed. HL7ToSDA3 does not set the<br>
/// Description. Note that an RDE_O11 message technically can contain both an<br>
/// RXO segment and an RXE, however HL7ToSDA3 does not parse the RXO segment<br>
/// from an RDE message.<br><br>
/// HL7:  ORC-12 : OrderingProvider<br>
/// HL7:  ORC-24 : OrderingProviderAddress<br>
/// HL7:  RXE-13 : OrderingProvidersDEANumber<br>
/// HL7:  RXO-14 : OrderingProvidersDEANumber<br>
/// HL7:  OBR-16 : OrderingProvider<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDoctorDR)<br><br>
/// .Code<br>
/// HL7:  ORC-12.1 : OrderingProvider.IDNumber<br>
/// HL7:  RXE-13.1 : OrderingProvidersDEANumber.IDNumber<br>
/// HL7:  RXO-14.1 : OrderingProvidersDEANumber.IDNumber<br>
/// HL7:  OBR-16.1 : OrderingProvider.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The family and given names are concatenated together as "[Family], [Given]"<br>
/// to make the Description.<br>
/// HL7:  ORC-12.2.1 : OrderingProvider.FamilyName.Surname<br>
/// HL7:  ORC-12.3 : OrderingProvider.GivenName<br>
/// HL7:  RXE-13.2.1 : OrderingProvidersDEANumber.FamilyName.Surname<br>
/// HL7:  RXE-13.3 : OrderingProvidersDEANumber.GivenName<br>
/// HL7:  RXO-14.2.1 : OrderingProvidersDEANumber.FamilyName.Surname<br>
/// HL7:  RXO-14.3 : OrderingProvidersDEANumber.GivenName<br>
/// HL7:  OBR-16.2.1 : OrderingProvider.FamilyName.Surname<br>
/// HL7:  OBR-16.3 : OrderingProvider.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  ORC-12.9 : OrderingProvider.AssigningAuthority<br>
/// HL7:  RXE-13.9 : OrderingProvidersDEANumber.AssigningAuthority<br>
/// HL7:  RXO-14.9 : OrderingProvidersDEANumber.AssigningAuthority<br>
/// HL7:  OBR-16.9 : OrderingProvider.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  ORC-12.2.1 : OrderingProvider.FamilyName.Surname<br>
/// HL7:  RXE-13.2.1 : OrderingProvidersDEANumber.FamilyName.Surname<br>
/// HL7:  RXO-14.2.1 : OrderingProvidersDEANumber.FamilyName.Surname<br>
/// HL7:  OBR-16.2.1 : OrderingProvider.FamilyName.Surname<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  ORC-12.3 : OrderingProvider.GivenName<br>
/// HL7:  RXE-13.3 : OrderingProvidersDEANumber.GivenName<br>
/// HL7:  RXO-14.3 : OrderingProvidersDEANumber.GivenName<br>
/// HL7:  OBR-16.3 : OrderingProvider.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  ORC-12.4 : OrderingProvider.MiddleName<br>
/// HL7:  RXE-13.4 : OrderingProvidersDEANumber.MiddleName<br>
/// HL7:  RXO-14.4 : OrderingProvidersDEANumber.MiddleName<br>
/// HL7:  OBR-16.4 : OrderingProvider.MiddleName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  ORC-12.6 : OrderingProvider.NamePrefix<br>
/// HL7:  RXE-13.6 : OrderingProvidersDEANumber.NamePrefix<br>
/// HL7:  RXO-14.6 : OrderingProvidersDEANumber.NamePrefix<br>
/// HL7:  OBR-16.6 : OrderingProvider.NamePrefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Address.Street<br>
/// HL7ToSDA3:<br>
/// If ORC-24.2 is not null, Street will be parsed as "[.1.1]; [.2]". Otherwise<br>
/// Street will simply be parsed from ORC-24.1.1.<br>
/// HL7:  ORC-24.1.1 : OrderingProviderAddress.StreetAddress.StreetorMailingAddress<br>
/// HL7:  ORC-24.2 : OrderingProviderAddress.OtherDesignation<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPStName)<br>
/// .Address.City<br>
/// HL7:  ORC-24.3 : OrderingProviderAddress.City<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCityDR)<br>
/// .Address.State<br>
/// HL7:  ORC-24.4 : OrderingProviderAddress.StateorProvince<br>
/// VIEWERLIB: Not stored<br>
/// .Address.Zip<br>
/// HL7:  ORC-24.5 : OrderingProviderAddress.ZiporPostalCode<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPZipDR)<br>
/// .Address.Country<br>
/// HL7:  ORC-24.6 : OrderingProviderAddress.Country<br>
/// VIEWERLIB: Not stored<br>
/// .Address.County<br>
/// HL7:  ORC-24.9 : OrderingProviderAddress.CountyParishCode<br>
/// VIEWERLIB: Not stored<br>
/// .NameTypeCode<br>
/// HL7:  OBR-16.10 : OrderingProvider.NameTypeCode<br>
/// VIEWERLIB: Not stored<br>
/// .IdentifierTypeCode<br>
/// HL7:  OBR-16.13 : OrderingProvider.IdentifierTypeCode<br>
/// VIEWERLIB: Not stored
Property OrderedBy As HS.SDA3.CodeTableDetail.CareProvider;

/// Entering Facility (Location)<br><br>
/// HL7ToSDA3:<br>
/// ORC-13 is only parsed if subfield 1 is not null. Only the Code is parsed.<br>
/// HL7ToSDA3 does not set the Description.<br><br>
/// HL7:  ORC-13.1 : EnterersLocation.PointofCare<br>
/// SDATableName=HealthCareFacility, ViewerClass=User.HS.CTLoc<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIOrdDeptDR)<br><br>
/// .Organization<br>
/// HL7ToSDA3:<br>
/// Only the Code is parsed. HL7ToSDA3 does not set the Description.<br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.CTLoc(CTLOCHospitalDR)
Property EnteringOrganization As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// VerifiedBy (CareProvider)<br><br>
/// HL7ToSDA3:<br>
/// OBR-32 will be used if present, else the first non-null instance of ORC-11<br>
/// will be used, if there is one.<br><br>
/// HL7:  ORC-11 : VerifiedBy<br> 
/// HL7:  OBR-32 : PrincipalResultInterpreter<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIAuthoriseClinicianDR)<br><br>
/// .Code<br>
/// HL7:  ORC-11.1 : VerifiedBy.IDNumber<br>
/// HL7:  OBR-32.1.1 : PrincipalResultInterpreter.Name.IDNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// For both fields, the given and family names are concatenated together as<br>
/// "[Family], [Given]" to make the Description.<br>
/// HL7:  ORC-11.2.1 : VerifiedBy.FamilyName.Surname<br>
/// HL7:  ORC-11.3 : VerifiedBy.GivenName<br>
/// HL7:  OBR-32.1.2 : PrincipalResultInterpreter.Name.FamilyName<br>
/// HL7:  OBR-32.1.3 : PrincipalResultInterpreter.Name.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  ORC-11.9 : VerifiedBy.AssigningAuthority<br>
/// HL7:  OBR-32.1.9 : PrincipalResultInterpreter.Name.AssigningAuthorityNamespaceID<br>
/// VIEWERLIB: Not stored<br>
/// .Name.FamilyName<br>
/// HL7:  ORC-11.2.1 : VerifiedBy.FamilyName.Surname<br>
/// HL7:  OBR-32.1.2 : PrincipalResultInterpreter.Name.FamilyName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .Name.GivenName<br>
/// HL7:  ORC-11.3 : VerifiedBy.GivenName<br>
/// HL7:  OBR-32.1.3 : PrincipalResultInterpreter.Name.GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .Name.MiddleName<br>
/// HL7:  ORC-11.4 : VerifiedBy.SecondandFurtherGivenNames<br>
/// HL7:  OBR-32.1.4 : PrincipalResultInterpreter.Name.SecondandFurtherGivenNames<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .Name.NamePrefix<br>
/// HL7:  ORC-11.6 : VerifiedBy.Prefix<br>
/// HL7:  OBR-32.1.6 : PrincipalResultInterpreter.Name.Prefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .Name.NameSuffix<br>
/// HL7:  ORC-11.7 : VerifiedBy.Degree<br>
/// HL7:  OBR-32.1.5 : PrincipalResultInterpreter.Name.Suffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
/// .Name.ProfessionalSuffix<br>
/// HL7:  OBR-32.1.7 : PrincipalResultInterpreter.Name.Degree<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextThree)<br>
Property VerifiedBy As HS.SDA3.CodeTableDetail.CareProvider;

/// Callback number (who to contact with questions, etc.)<br><br>
/// HL7ToSDA3:<br>
/// OBR-17 is used if any regular (business), mobile, or fax numbers or e-mail<br>
/// addresses can be parsed from it, else ORC-14 is used. In either case, the<br>
/// format of CallbackNumber is: "[List of business #s], Mobile: [List of<br>
/// mobile #s], Fax: [List of fax #s], email: [List of e-mail addresses]". Each<br>
/// list is comma-delimited. Each tag (Mobile, Fax, email) will only be used if<br>
/// there are elements of that type. For each field, every instance will be<br>
/// parsed, if that field is used. Up to three numbers can be parsed from each<br>
/// instance of a field:<br>
/// -If subfields 5, 6, 7, and 8 are not all null, a number is parsed from them<br>
/// as "+[.5] ([.6]) [.7] x[.8]".<br>
/// -If subfield 12 is not null, it is parsed.<br>
/// -If subfield 1 is not null, it is parsed.<br>
/// -Additionally, if subfield 9 is not null, the first number parsed from that<br>
/// instance will have it appended to the end after a semicolon separator.<br>
/// Ex: "###-###-####;Main Number"<br>
/// The logic to determine the type of the number is:<br>
/// -If subfield 2 is in ["",WPN,ASN,EMR] and subfield 3 is in ["",PH], the<br>
/// number is a regular (business) number.<br>
/// -If subfield 2 = "BPN" and subfield 3 is in [CP,BP], the number is a mobile<br>
/// number.<br>
/// -If subfield 2 is in ["",WPN,ASN,EMR] and subfield 3 = "FX", the number is<br>
/// a fax number.<br>
/// Finally, each non-null instance of subfield 4 is parsed as an e-mail<br>
/// address.<br><br>
/// HL7:  OBR-17 : OrderCallbackPhoneNumber<br>
/// HL7:  ORC-14 : CallBackPhoneNumber<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORINotify)
Property CallbackNumber As %String(MAXLEN = 220);

/// Specimen code or description as a string<br>
/// Not to be confused with the Specimens property of LabOrder, RadOrder, and<br>
/// OtherOrder, which is of type List of HS.SDA3.Specimen.<br><br>
/// HL7ToSDA3:<br>
/// OBR-15.1.2 will be used if not null, else OBR-15.1.1 will be used.<br><br>
/// Viewer cache:<br>
/// Specimen is inserted into the Viewer Cache as a CTSpecimen with SPECCode<br>
/// and SPECDesc=[Specimen]. The CTSpecimen is the linked to the ARCItmMast<br>
/// (OrderItem) via an ARCItemSpecimen. Specimen is also inserted as an<br>
/// OEOrdSpecimen (with SPECCode=[Specimen]) that is linked to the OEOrdItem<br>
/// (Order). Note that backslash ("\") is a reserved character for the<br>
/// CTSpecimen table, so Specimen should not contain a backslash.<br><br>
/// HL7: OBR-15 : SpecimenSource<br>
/// SDATableName=None, ViewerClass=User.HS.CTSpecimen<br>
/// VIEWERLIB: User.HS.OEOrdSpecimen(SPECCode)<br>
/// VIEWERLIB: User.HS.CTSpecimen(SPECCode) + User.HS.CTSpecimen(SPECDesc)
Property Specimen As %String(MAXLEN = 220);

/// Date/time the specimen was collected<br><br>
/// HL7ToSDA3:<br>
/// OBR-7.1 and SPM-17.1 represent the same value and therefore should contain<br>
/// the same value if both are present, however HealthShare does not enforce<br>
/// this. SPM-17.1 is parsed to Specimen.FromTime.<br><br>
/// Viewer cache:<br>
/// OEORIEpisArriveDate and OEORIEpisArriveTime are only set for Lab, Rad, and<br>
/// Other Orders, not Medications or Vaccinations. SPECDate and SPECTime are<br>
/// only set if the Order contains a Specimen (the string property, not an<br>
/// HS.SDA3.Specimen). The properties of lab.HS.EPVisitNumber and<br>
/// EPVisitTestSet are set for atomic results only. Note that while<br>
/// VISTSTimeOfCollection is a %Time, EPVISTimeOfCollection is not. It is a<br>
/// %String value containing the time as a number of minutes since midnight.<br><br>
/// HL7:  OBR-7.1 : ObservationDateTime.Time<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIEpisArriveDate) + User.HS.OEOrdItem(OEORIEpisArriveTime)<br>
/// VIEWERLIB: User.HS.OEOrdSpecimen(SPECDate) + User.HS.OEOrdSpecimen(SPECTime)<br>
/// VIEWERLIB: lab.HS.EPVisitNumber(EPVISDateOfCollection) + lab.HS.EPVisitNumber(EPVISTimeOfCollection)<br>
/// VIEWERLIB: lab.HS.EPVisitTestSet(VISTSDateOfCollection) + lab.HS.EPVisitTestSet(VISTSDateOfCollection)
Property SpecimenCollectedTime As HS.SDA3.TimeStamp;

/// Date/time the specimen was received<br><br>
/// Viewer cache:<br>
/// OEORILabReceiveDate and OEORILabReceiveTime are only set for Lab, Rad, and<br>
/// Other Orders, not Medications or Vaccinations. The properties of<br>
/// lab.HS.EPVisitNumber are set for atomic results only. Note that<br>
/// EPVISTimeOfReceiving is not a %Time but rather a %String value containing<br>
/// the time as a number of minutes since midnight.<br><br>
/// HL7: OBR-14.1 : SpecimenReceivedDateTime.Time<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORILabReceiveDate) + User.HS.OEOrdItem(OEORILabReceiveTime)<br>
/// VIEWERLIB: lab.HS.EPVisitNumber(EPVISDateOfReceiving) + lab.HS.EPVisitNumber(EPVISTimeOfReceiving)
Property SpecimenReceivedTime As HS.SDA3.TimeStamp;

/// If the Order is not final, this is the date/time when it should be reviewed<br>
/// and perhaps finalized.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIReassessmentDate) + User.HS.OEOrdItem(OEORIReassessmentTime)<br>
Property ReassessmentTime As HS.SDA3.TimeStamp;

/// How often (e.g. Code=QID, Desc=QID, Factor=4)<br>
/// QID is Latin, meaning 4x a day.  BID means 2x day, etc.<br><br>
/// HL7ToSDA3:<br>
/// Though TQ1-3 is a repeating field, HL7ToSDA3 will only parse the first<br>
/// non-null instance.<br><br>
/// Viewer cache:<br>
/// If the Order contains at least 1 DosageStep in the DosageSteps property,<br>
/// and if the first DosageStep in that list has a Frequency, then that<br>
/// Frequency will override this one in the Viewer Cache.<br><br>
/// HL7:  TQ1-3 : RepeatPattern<br>
/// SDATableName=Frequency, ViewerClass=User.HS.PHCFreq<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIPHFreqDR)<br><br>
/// .Code<br>
/// HL7:  TQ1-3.1.1 : RepeatPattern.RepeatPatternCode.Identifier<br>
/// VIEWERLIB: User.HS.PHCFreq(PHCFRCode)<br>
/// .Description<br>
/// HL7:  TQ1-3.1.2 : RepeatPattern.RepeatPatternCode.Text<br>
/// VIEWERLIB: User.HS.PHCFreq(PHCFRDesc1)<br>
/// .Factor<br>
/// HL7:  TQ1-3.5 : RepeatPattern.PeriodQuantity<br>
/// VIEWERLIB: User.HS.PHCFreq(PHCFRFactor)
Property Frequency As HS.SDA3.CodeTableDetail.Frequency;

/// HL7ToSDA3:<br>
/// Duration is parsed from (in order of precedence) TQ1-6, RXE-1.3, OBR-27.3,<br>
/// or ORC-7.3. The RXE, OBR, and ORC fields will only set the Duration Code.<br>
/// TQ1-6 will populate the Code, Description, and Factor as described below.<br>
/// Though ORC-7 is a repeating field, HL7ToSDA3 only parses the first non-null<br>
/// instance. OBR-27 is also a repeating field, and HL7ToSDA3 parses every<br>
/// non-null instance of it. The last non-null instance of Duration in OBR-27<br>
/// is the one that takes precedence. Note that an RDE_O11 message may contain<br>
/// TQ1 segments in two different places. HL7ToSDA3 parses the one following<br>
/// the RXE segment.<br><br>
/// Viewer cache:<br>
/// If the Order contains at least 1 DosageStep in the DosageSteps property,<br>
/// and if the first DosageStep in that list has a Duration, then that Duration<br>
/// will override this one in the Viewer Cache.<br><br>
/// HL7:  ORC-7.3 : QuantityTiming.Duration<br>
/// HL7:  OBR-27.3 : QuantityTiming.Duration<br>
/// HL7:  RXE-1.3 : QuantityTiming.Duration<br>
/// HL7:  TQ1-6 : ServiceDuration<br>
/// SDATableName=Duration, ViewerClass=User.HS.PHCDuration<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDuratDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// When parsing the TQ1-6 field, Code is initially parsed from subfield 2.1<br>
/// (Units.Identifier). If subfield 1 (Quantity) is not null, then if subfields<br>
/// 2.1 and 2.2 (Units.Text) are null, Code will be parsed from Quantity. Then,<br>
/// if Quantity starts with a non-zero number and the parsed value for Code<br>
/// does not, the parsed value for Code is set to +[Quantity]_[Code]. For<br>
/// example, if Quantity="2" and Units.Identifier="D", the value parsed to Code<br>
/// is "2D". For the other segments that Duration Code may be parsed from (RXE,<br>
/// OBR, ORC), the value is simply parsed from the field listed below.<br>
/// HL7:  TQ1-6.1 : ServiceDuration.Quantity<br>
/// HL7:  TQ1-6.2.1 : ServiceDuration.Units.Identifier<br>
/// HL7:  RXE-1.3 : QuantityTiming.Duration<br>
/// HL7:  OBR-27.3 : QuantityTiming.Duration<br>
/// HL7:  ORC-7.3 : QuantityTiming.Duration<br>
/// VIEWERLIB: User.HS.PHCDuration(PHCDUCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// If TQ1-6.1 (Quantity) is not null and +[Quantity] is logically "true",<br>
/// and if TQ1-6.2.2 (Units.Text) is not null and +[Units.Text] is logically<br>
/// "false" (basically, if Quantity starts with a number and Units.Text<br>
/// doesn't), then the value parsed to Description is<br>
/// +[Quantity]_" "_[Units.Text]. For example, if Quantity="2" and<br>
/// Units.Text="Days", the value parsed to Description is "2 Days". If these<br>
/// conditions are not all met then the Description is simply parsed from<br>
/// TQ1-6.2.2.<br>
/// HL7:  TQ1-6.1 : ServiceDuration.Quantity<br>
/// HL7:  TQ1-6.2.2 : ServiceDuration.Units.Text<br>
/// VIEWERLIB: User.HS.PHCDuration(PHCDUDesc1)<br>
/// .Factor<br>
/// HL7ToSDA3:<br>
/// If TQ1-6.1 (Quantity) is not null, then if +[Quantity] is logically "true",<br>
/// Factor is parsed as +[Quantity], otherwise Factor is parsed as null. If<br>
/// Quantity is null, then if +[TQ1-2.1/Units.Identifier] is logically "true",<br>
/// Factor is parsed as +[Units.Identifier], else if +[TQ1-2.2/Units.Text] is<br>
/// logically "true", Factor is parsed as +[Units.Text], else Factor is not<br>
/// parsed.<br><br>
/// HL7:  TQ1-6.1 : ServiceDuration.Quantity<br>
/// HL7:  TQ1-6.2.1 : ServiceDuration.Units.Identifier<br>
/// HL7:  TQ1-6.2.2 : ServiceDuration.Units.Text<br>
/// VIEWERLIB: User.HS.PHCDuration(PHCDUFactor)<br>
Property Duration As HS.SDA3.CodeTableDetail.Duration;

/// The current status of the order<br><br>
/// HL7ToSDA3:<br>
/// The following values are mapped in the HL7 to SDA3 parsing:<br>
/// DC->D, CA->C, RP->R, HD->H, SC->IP, CM->E, [Other]->unchanged<br><br>
/// Streamlet cache:<br>
/// For any type of Order, in the OnValidate method of the streamlet class, if<br>
/// Status is null, it is defaulted to "V" for "Verified". Then, for Orders<br>
/// that can have results (LabOrder, RadOrder, OtherOrder), if the Order has a<br>
/// Result, Status is set to "E" for "Executed", unless it is "D", "C", "R", or<br>
/// "H" (for Discontinued, Cancelled, Replaced, or On Hold, respectively). The<br>
/// reasoning behind setting the Status to "E" is that if the Order has a<br>
/// Result, then it must have been executed. The reasoning behind the<br>
/// exceptions to this is that those particular statuses may have been entered<br>
/// after the Result was submitted. Also, for any type of Order, when Orders of<br>
/// of that type are inactivated with ActionCode="I", the Status of each will<br>
/// be set to "I".<br><br>
/// Viewer cache:<br>
/// Status is stored in the Viewer Cache as an OECOrderStatus with OSTATCode<br>
/// matching Status, ALPHAUP collated. If no such entry in OECOrderStatus<br>
/// exists, Status will be stored as V/Verified in the Viewer Cache only and an<br>
/// alert logged in the Ensemble Event Log. Note that the OECOrderStatus table<br>
/// is loaded from the SITE- or HS-Default-OrderStatus.txt file at the time the<br>
/// Access Gateway is reset.<br><br>
/// HL7:  ORC-5 : OrderStatus<br>
/// SDATableName=None, ViewerClass=User.HS.OECOrderStatus<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIItemStatDR)<br>
Property Status As %String(MAXLEN = 32000);

/// The Priority of the Order<br><br>
/// HL7ToSDA3:<br>
/// Priority is parsed from (in order of precendence) TQ1-9, RXE-1.6, OBR-27.6,<br>
/// OBR-5, or ORC-7.6. TQ1-9 may set the Code, Description, and<br>
/// SDACodingStandard. Every other field only sets the Code. Though TQ1-9 and<br>
/// ORC-7 are repeating fields, HL7ToSDA3 only parses the first non-null<br>
/// instance of each. OBR-27 is also a repeating field, and HL7ToSDA3 parses<br>
/// every non-null instance of it. The last non-null instance of Priority in<br>
/// OBR-27 is the one that takes precedence. Note that an RDE_O11 message may<br>
/// contain TQ1 segments in two different places. HL7ToSDA3 parses the one<br>
/// following the RXE segment.<br><br>
/// Streamlet cache:<br>
/// For each type of Order, in the OnValidate method of the Streamlet class, if<br>
/// the Order contains no Priority, one is defaulted in with Code="N" and <br>
/// Description="Normal".<br><br>
/// HL7:  ORC-7.6 : QuantityTiming.Priority<br>
/// HL7:  OBR-5 : PriorityOBR<br>
/// HL7:  OBR-27.6 : QuantityTiming.Priority<br>
/// HL7:  RXE-1.6 : QuantityTiming.Priority<br>
/// HL7:  TQ1-9   : Priority<br>
/// SDATableName=Priority, ViewerClass=User.HS.OECPriority<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIPriorityDR)<br><br>
/// .Code<br>
/// HL7:  ORC-7.6 : QuantityTiming.Priority<br>
/// HL7:  OBR-5 : PriorityOBR<br>
/// HL7:  OBR-27.6 : QuantityTiming.Priority<br>
/// HL7:  RXE-1.6 : QuantityTiming.Priority<br>
/// HL7:  TQ1-9.1  : Priority.Identifier<br>
/// VIEWERLIB: User.HS.OECPriority(OECPRCode)<br>
/// .Description<br>
/// HL7:  TQ1-9.2  : Priority.Text<br>
/// VIEWERLIB: User.HS.OECPriority(OECPRDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  TQ1-9.3  : Priority.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Priority As HS.SDA3.CodeTableDetail.Priority;

/// Confidentiality code (e.g. VIP, etc.)<br><br>
/// HL7ToSDA3:<br>
/// ORC-28 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  ORC-28 : ConfidentialtyCode<br>
/// SDATableName=Confidentiality, ViewerClass=User.HS.OECOverReasonNonConsent<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORINoConsentOverrideReasDR)<br><br>
/// .Code<br>
/// HL7:  ORC-28.1 : ConfidentialtyCode.Identifier<br>
/// VIEWERLIB: User.HS.OECOverReasonNonConsent(ORNCCode)<br>
/// .Description<br>
/// HL7:  ORC-28.2 : ConfidentialtyCode.Text<br>
/// VIEWERLIB: User.HS.OECOverReasonNonConsent(ORNCDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  ORC-28.3 : ConfidentialtyCode.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property ConfidentialityCode As HS.SDA3.CodeTableDetail.Confidentiality;

/// Condition, e.g. "keep BP below 110"<br><br>
/// HL7ToSDA3:<br>
/// Condition is parsed from (in order of precendence) TQ1-10, RXE-1.7,<br>
/// OBR-27.7, or ORC-7.7. Though ORC-7 is a repeating field, HL7ToSDA3 only<br>
/// parses the first non-null instance. OBR-27 is also a repeating field, and<br>
/// HL7ToSDA3 parses every non-null instance of it. The last non-null instance<br>
/// of Condition in OBR-27 is the one that takes precendence. Note that an<br>
/// RDE_O11 message may contain TQ1 segments in two different places. HL7ToSDA3<br>
/// parses the one following the RXE segment.<br><br>
/// HL7:  ORC-7.7 : QuantityTiming.Condition<br>
/// HL7:  OBR-27.7 : QuantityTiming.Condition<br>
/// HL7:  RXE-1.7 : QuantityTiming.Condition<br>
/// HL7:  TQ1-10  : ConditionText<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORILtClinicalCondition)<br>
Property Condition As %String(MAXLEN = 220);

/// Text instructions or directions, e.g. "After food", or if Duration etc.<Br>
/// isn't coded, "Take 3 twice a day"<br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// HL7ToSDA3:<br>
/// TextInstruction is parsed from (in order of precendence) TQ1-11, RXE-1.8,<br>
/// OBR-27.8, or ORC-7.8. Though ORC-7 is a repeating field, HL7ToSDA3 only<br>
/// parses the first non-null instance. OBR-27 is also a repeating field, and<br>
/// HL7ToSDA3 parses every non-null instance of it. The last non-null instance<br>
/// of Text in OBR-27 is the one that takes precendence. Note that an RDE_O11<br>
/// message may contain TQ1 segments in two different places. HL7ToSDA3 parses<br>
/// the one following the RXE segment.<br><br>
/// Viewer cache:<br>
/// If the Order contains at least 1 DosageStep in the DosageSteps property,<br>
/// and if the first DosageStep in that list has a TextInstruction, then that<br>
/// TextInstruction will override this one in the Viewer Cache.<br><br>
/// HL7:  ORC-7.8 : QuantityTiming.Text<br>
/// HL7:  OBR-27.8 : QuantityTiming.Text<br>
/// HL7:  RXE-1.8 : QuantityTimingText<br>
/// HL7:  TQ1-11  : TextInstruction<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDepProcNotes)
Property TextInstruction As %String(MAXLEN = "");

/// This is a way to group related Orders together, such as a prescription<br>
/// chain.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIItemGroup)<br>
Property OrderGroup As %String;

/// Order Comments and notes<br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// HL7ToSDA3:<br>
/// Order Comments are always parsed from NTE segments, though HL7 order<br>
/// messages may contain NTEs in different places, and only certain ones are<br>
/// parsed to Order Comments. For ORM and OMP messages, it is the first set of<br>
/// NTEs following the ORC (in the message schema, not necessarily in the<br>
/// message) that are parsed to Comments.  In an RDE message the set of NTEs<br>
/// following the RXE segment are parsed to Order Comments. Order Comments can<br>
/// only be parsed from an ORU message if it contains a text result (either<br>
/// ORC-29 is not "LAB", or all OBX-2 values = "FT", "TX", or "ED"). In this<br>
/// case the NTEs immediately following the OBR are parsed to Order Comments.<br>
/// In an ORU containing atomic lab results, the NTEs following the OBR are<br>
/// parsed to the Result Comments, and in an ORU containing Observations<br>
/// (ORC-29="OBS"), these NTEs are not parsed.<br><br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIRemarks)
Property Comments As %String(MAXLEN = "");

/// Department or facility that consulted<br><br>
/// Viewer cache:<br>
/// If no Organization is given, one will be defaulted in with Code and<br>
/// Description = SendingFacility of the SDA Container.<br><br>
/// SDATableName=HealthCareFacility, ViewerClass=User.HS.CTLoc<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIConsultDepDR)<br><br>
/// .Organization<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.CTLoc(CTLOCHospitalDR)<br>
Property ConsultationDepartment As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// Date/time the order was authorized<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIAuthorisedDate) + User.HS.OEOrdItem(OEORIAuthorisedTime)
Property AuthorizationTime As HS.SDA3.TimeStamp;

/// Location or facility receiving/performing the order<br><br>
/// Viewer cache:<br>
/// If no Organization is given, one will be defaulted in with Code and<br>
/// Description = SendingFacility of the SDA Container.<br><br>
/// SDATableName=HealthCareFacility, ViewerClass=User.HS.CTLoc<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIRecDepDR)<br><br>
/// .Organization<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.CTLoc(CTLOCHospitalDR)<br>
Property ReceivingLocation As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// Verified order comments and notes<br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIAuthComments)<br>
Property VerifiedComments As %String(MAXLEN = "");

/// Who to send copies of results to<br><br>
/// HL7ToSDA3:<br>
/// OBR-28 is a repeating field, and HL7ToSDA3 will parse each instance with a<br>
/// non-null value in subfield 1.<br><br>
/// HL7:  OBR-28  : ResultCopiesTo<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBR-28.1 : ResultCopiesTo.Code<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The family and given names are concatenated together as "[Family], [Given]"<br>
/// to make the Description.<br>
/// HL7:  OBR-28.2.1 : ResultCopiesTo.FamilyName.Surname<br>
/// HL7:  OBR-28.3 : ResultCopiesTo.GivenName<br>
/// .SDACodingStandard<br>
/// HL7:  OBR-28.9 : ResultCopiesTo.AssigningAuthority<br>
/// .Name.FamilyName<br>
/// HL7:  OBR-28.2.1 : ResultCopiesTo.FamilyName.Surname<br>
/// .Name.GivenName<br>
/// HL7:  OBR-28.3 : ResultCopiesTo.GivenName<br>
/// .Name.NamePrefix<br>
/// HL7:  OBR-28.6 : ResultCopiesTo.Prefix<br>
/// .Name.NameSuffix<br>
/// HL7:  OBR-28.7 : ResultCopiesTo.Degree<br>
Property ResultCopiesTo As list Of HS.SDA3.CodeTableDetail.CareProvider;

/// If this item was ordered as part of a group, this is the identifier of that<br>
/// group. The SDA2-to-SDA3 transform populates this field with the SDA2<br>
/// ExternalId property.<br><br>
/// HL7:  ORC-4.1 : PlacerGroupNumber.EntityIdentifier<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORILab1)
Property GroupId As %String;

/// HL7ToSDA3:<br>
/// GroupAssigningAuthority is composed of subfields 2, 3, and 4 concatenated<br>
/// together as "[.2]^[.3]^[.4]", but only if at least one of these is not<br>
/// null.<br><br>
/// HL7:  ORC-4.2: PlacerGroupNumber.NamespaceID<br>
/// HL7:  ORC-4.3: PlacerGroupNumber.UniversalID<br>
/// HL7:  ORC-4.4: PlacerGroupNumber.UniversalIDType<br>
/// VIEWERLIB: Not stored
Property GroupAssigningAuthority As %String;

/// Supported values:<br>
/// D = Delete<br>
/// I = Inactivate all orders of this type (set Status="I")<br>
/// C = Clear/delete all orders of this type<br>
/// R = Replace - Applies only to Atomic Result Items.  Clears previous result items before storing all new items,
/// ignoring matching on test item code.  <b>Use ONLY when always receiving full updates.  Using this with
/// partial updates may cause a loss of test item data.</b><br>
/// Any other value = Add or Update<br>
/// See the annotation of the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// HL7ToSDA3:<br>
/// Two double quotes ("") in ORC-1 will be parsed as ActionCode="I", while<br>
/// four double quotes ("""") will be parsed as ActionCode="C". <br>
/// ActionCode="R" in ORC-1 will impact parsing of TestItemCode.  See the
/// TestItemCode property of HS.SDA3.LabResultItem for details.<br>
/// Any other value will not be parsed.<br><br>
/// HL7:  ORC-1 : OrderControl<br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// Only used for Medications, see the annotation in HS.SDA3.Medication.<br>
/// Otherwise ActionScope is not used for Orders.<br><br>
/// VIEWERLIB: Not stored
Property ActionScope As %String;

/// HL7ToSDA3:<br>
/// Though ORC-10 is a repeating field, only the first non-null instance is<br>
/// parsed.<br><br>
/// HL7:  ORC-10 : EnteredBy<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIUserUpdate)<br><br>
/// .Code<br>
/// HL7:  ORC-10.1 : EnteredBy.IDNumber<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The family and given names are concatenated together as "[Family], [Given]"<br>
/// to make the Description.<br>
/// HL7:  ORC-10.2.1 : EnteredBy.FamilyName.Surname<br>
/// HL7:  ORC-10.3 : EnteredBy.GivenName<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRName)<br>
/// .SDACodingStandard<br>
/// HL7:  ORC-10.9 : EnteredBy.AssigningAuthority<br>
/// VIEWERLIB: Not stored
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// Though ORC-21 is a repeating field, only the first non-null instance is<br>
/// parsed. ORC-22 is also a repeating field, however HL7ToSDA3 will only parse<br>
/// the instance corresponding to the instance of ORC-21 parsed. For example,<br>
/// if the third instance of ORC-21 is parsed (because the first two are null),<br>
/// then the third instance of ORC-22 will be parsed as well. For Address.City,<br>
/// State, Zip, Country, and County only the Code is parsed. HL7ToSDA3 does not<br>
/// set the Description. Every instance of ORC-23 will be examined but may not<br>
/// be parsed to the SDA. The algorithm to parse a number out of one instance<br>
/// of ORC-23 is:<br>
/// -If subfields 5, 6, 7, and 8 are not all null, compose the number out of<br>
/// them as "+[.5] ([.6]) [.7] x[.8]".<br>
/// -Else if subfield 12 is not null, use that.<br>
/// -Else if subfield 1 is not null, use that.<br>
/// -Else no number can be parsed from this instance.<br>
/// -Whichever number is parsed, if subfield 9 of that instance is not null, it<br>
/// will be appended to the number, delimited by a semicolon.<br>
/// Ex: "###-###-####;Main Number"<br><br>
/// HL7:  ORC-21 : OrderingFacilityName<br>
/// HL7:  ORC-22 : OrderingFacilityAddress<br>
/// HL7:  ORC-23 : OrderingFacilityPhoneNumber<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIUserAddHospDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// ORC-21.10 will be parsed to the Code if present, else ORC-21.3 will.<br>
/// HL7:  ORC-21.10 : OrderingFacilityName.OrganizationIdentifier<br>
/// HL7:  ORC-21.3 : OrderingFacilityName.IDNumber<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCode)<br>
/// .Description<br>
/// HL7:  ORC-21.1 : OrderingFacilityName.OrganizationName<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  ORC-21.6 : OrderingFacilityName.AssigningAuthority<br>
/// VIEWERLIB: Not stored<br>
/// .Address.Street<br>
/// HL7ToSDA3:<br>
/// If ORC-22.2 is not null, Street will be parsed as "[.1.1]; [.2]". Otherwise<br>
/// Street will simply be parsed from ORC-22.1.1.<br>
/// HL7:  ORC-22.1.1 : OrderingFacilityAddress.StreetAddress.StreetorMailingAddress<br>
/// HL7:  ORC-22.2 : OrderingFacilityAddress.OtherDesignation<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPAddress)<br>
/// .Address.City<br>
/// HL7:  ORC-22.3 : OrderingFacilityAddress.City<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCity)<br>
/// .Address.State<br>
/// HL7:  ORC-22.4 : OrderingFacilityAddress.StateorProvince<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPProvinceDR)<br>
/// .Address.Zip<br>
/// HL7:  ORC-22.5 : OrderingFacilityAddress.ZiporPostalCode<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPZipDR)<br>
/// .Address.Country<br>
/// HL7:  ORC-22.6 : OrderingFacilityAddress.Country<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCountryDR)<br>
/// .Address.County<br>
/// HL7:  ORC-22.9 : OrderingFacilityAddress.CountyParishCode<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCountyParishDR)<br>
/// .ContactInfo.WorkPhoneNumber<br>
/// HL7ToSDA3:<br>
/// WorkPhoneNumber is parsed from the first instance of ORC-23 with subfield 2<br>
/// in ["",WPN,ASN,EMR] and subfield 3 in ["",PH] and from which a phone number<br>
/// can be parsed using the above algorithm.<br>
/// HL7:  ORC-23 : OrderingFacilityPhoneNumber<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPPhone)<br>
/// .ContactInfo.MobilePhoneNumber<br>
/// HL7ToSDA3:<br>
/// MobilePhoneNumber is parsed from the first instance of ORC-23 with subfield<br>
/// 2 = "BPN" and subfield 3 in [CP,BP] and from which a phone number can be<br>
/// parsed using the above algorithm.<br>
/// HL7:  ORC-23 : OrderingFacilityPhoneNumber<br>
/// VIEWERLIB: Not stored<br>
/// .ContactInfo.EmailAddress<br>
/// HL7ToSDA3:<br>
/// EmailAddress is parsed from the first non-null instance of ORC-23.4.<br>
/// HL7:  ORC-23.4 : OrderingFacilityPhoneNumber.EmailAddress<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPEmail)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Streamlet cache:<br>
/// For each type of Order, in the OnValidate method of the Streamlet class, if<br>
/// FromTime is null, it is defaulted to EnteredOn. For Orders than can have<br>
/// Results (LabOrder, RadOrder, OtherOrder), if the Order actually has a<br>
/// Result and FromTime, EnteredOn, and Result.ResultTime are all null, an<br>
/// error will be logged and the Order will not be saved.<br><br>
/// HL7:  ORC-9.1 : DateTimeofTransaction.Time<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIUpdateDate) + User.HS.OEOrdItem(OEORIUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Start date and time of the Order<br><br>
/// HL7ToSDA3:<br>
/// FromTime is parsed from (in order of precedence) TQ1-7.1, RXE-1.4,<br>
/// OBR-27.4, OBR-6.1, or ORC-7.4. Though ORC-7 is a repeating field, HL7ToSDA3<br>
/// only parses the first non-null instance. OBR-27 is also a repeating field,<br>
/// and HL7ToSDA3 parses every non-null instance of it. The last non-null<br>
/// instance of StartDateTime.Time in OBR-27 is the one that takes precedence.<br>
/// Note that an RDE_O11 message may contain TQ1 segments in two different<br>
/// places. HL7ToSDA3 parses the one following the RXE segment.<br><br>
/// Streamlet cache:<br>
/// For each type of Order, in the OnValidate method of the Streamlet class, if<br>
/// FromTime is null, it is defaulted to EnteredOn. Then, if the Order has a<br>
/// Result and FromTime is still null, it is defaulted to Result.ResultTime.<br>
/// Finally, if the Order has a Result and FromTime is still null, an error<br>
/// will be logged and the Order will not be saved.<br><br>
/// Viewer Cache:<br>
/// If the Order contains at least 1 DosageStep in the DosageSteps property,<br>
/// and if the first DosageStep in that list has a FromTime, then that FromTime<br>
/// will override this one in the Viewer Cache.<br><br>
/// HL7:  ORC-7.4.1 : QuantityTiming.StartDateTime.Time<br>
/// HL7:  OBR-6.1 : RequestedDateTime.Time<br>
/// HL7:  OBR-27.4.1 : QuantityTiming.StartDateTime.Time<br>
/// HL7:  RXE-1.4.1 : QuantityTiming.StartDateTime.Time<br>
/// HL7:  TQ1-7.1 : StartDateTime.Time<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORISttDat) + User.HS.OEOrdItem(OEORISttTim)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// End date and time of the Order<br><br>
/// HL7ToSDA3:<br>
/// ToTime is parsed from (in order of precedence) TQ1-8, RXE-1.5, OBR-27.5,<br>
/// or ORC-7.5. Though ORC-7 is a repeating field, HL7ToSDA3 only parses the<br>
/// first non-null instance. OBR-27 is also a repeating field, and HL7ToSDA3<br>
/// parses every non-null instance of it. The last non-null instance of<br>
/// EndDateTime.Time in OBR-27 is the one that takes precedence. Note that an<br>
/// RDE_O11 message may contain TQ1 segments in two different places. HL7ToSDA3<br>
/// parses the one following the RXE segment.<br><br>
/// Viewer Cache:<br>
/// If the Order contains at least 1 DosageStep in the DosageSteps property,<br>
/// and if the first DosageStep in that list has a ToTime, then that ToTime<br>
/// will override this one in the Viewer Cache.<br><br>
/// HL7:  ORC-7.5.1 : QuantityTiming.EndDateTime.Time<br>
/// HL7:  OBR-27.5.1 : QuantityTiming.EndDateTime.Time<br>
/// HL7:  RXE-1.5.1 : QuantityTiming.EndDateTimeTime<br>
/// HL7:  TQ1-8.1   : EndDateTime.Time<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIEndDate) + User.HS.OEOrdItem(OEORIEndTime)
Property ToTime As HS.SDA3.TimeStamp;

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>PlacerId</Value>
</Value>
<Value name="9">
<Value>FillerId</Value>
</Value>
<Value name="10">
<Value>OrderItem</Value>
</Value>
<Value name="11">
<Value>OrderQuantity</Value>
</Value>
<Value name="12">
<Value>OrderedBy</Value>
</Value>
<Value name="13">
<Value>EnteringOrganization</Value>
</Value>
<Value name="14">
<Value>VerifiedBy</Value>
</Value>
<Value name="15">
<Value>CallbackNumber</Value>
</Value>
<Value name="16">
<Value>Specimen</Value>
</Value>
<Value name="17">
<Value>SpecimenCollectedTime</Value>
</Value>
<Value name="18">
<Value>SpecimenReceivedTime</Value>
</Value>
<Value name="19">
<Value>StartTime</Value>
</Value>
<Value name="20">
<Value>EndTime</Value>
</Value>
<Value name="21">
<Value>ReassessmentTime</Value>
</Value>
<Value name="22">
<Value>Frequency</Value>
</Value>
<Value name="23">
<Value>Duration</Value>
</Value>
<Value name="24">
<Value>Status</Value>
</Value>
<Value name="25">
<Value>Priority</Value>
</Value>
<Value name="26">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="27">
<Value>Condition</Value>
</Value>
<Value name="28">
<Value>TextInstruction</Value>
</Value>
<Value name="29">
<Value>OrderGroup</Value>
</Value>
<Value name="30">
<Value>Comments</Value>
</Value>
<Value name="31">
<Value>ConsultationDepartment</Value>
</Value>
<Value name="32">
<Value>AuthorizationTime</Value>
</Value>
<Value name="33">
<Value>ReceivingLocation</Value>
</Value>
<Value name="34">
<Value>VerifiedComments</Value>
</Value>
<Value name="35">
<Value>ResultCopiesTo</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

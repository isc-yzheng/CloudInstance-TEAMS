/// Despite having several extended properties, DrugProduct is still only<br>
/// matched on Code, Description, and SDACodingStandard in the Viewer Cache.<br>
/// Properties of the PHCDrgMast will only be set on add or if an inbound<br>
/// DrugProduct matches an existing PHCDrgMast, but not exactly (capitalization<br>
/// of Code or Description differs, for example). Properties of the PHCDrgForm<br>
/// (besides match properties) are always updated when a DrugProduct is<br>
/// inserted into the Viewer Cache. Properties of the PHCFormDoseEquiv are<br>
/// included in the matching on PHCDrgForm, so will never be updated, only<br>
/// inserted.
Class HS.SDA3.CodeTableDetail.DrugProduct Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.DrugProductExtension;

/// VIEWERLIB: User.HS.PHCDrgMast(PHCDCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.PHCDrgMast(PHCDName)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// If the DrugProduct is dispensed as a Package, this is the quantity (per<br>
/// dispensing unit) that will be dispensed. For example, BaseQty=3,<br>
/// BaseUnits=ml, PackageSize=4, PackageSizeUnits=syringes could be a<br>
/// dispensing unit of a strip of 4x3ml syringes.<br><br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFBaseQty)<br>
Property BaseQty As HS.SDA3.Numeric;

/// If the DrugProduct is dispensed as a package, this is the units of the<br>
/// BaseQty that will be dispensed. For example, BaseQty=3, BaseUnits=ml,<br>
/// PackageSize=4, PackageSizeUnits=syringes could be a dispensing unit of a<br>
/// strip of 4x3ml syringes.<br><br>
/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFCTUOMDR)
Property BaseUnits As HS.SDA3.CodeTableDetail.UoM;

/// If the DrugProduct is dispensed as a package, this is the full name or<br>
/// description of the package.<br><br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDProductName)
Property ProductName As %String(MAXLEN = 220);

/// If the DrugProduct is dispensed as a package, this is the official (e.g.<br>
/// government or standard) ID of the package.<br><br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDOfficialCode)
Property OfficialCode As %String(MAXLEN = 220);

/// If the DrugProduct is dispensed as a package, this is the number of items<br>
/// in the package. For example, BaseQty=3, BaseUnits=ml, PackageSize=4,<br>
/// PackageSizeUnits=syringes could be a dispensing unit of a strip of 4x3ml<br>
/// syringes.<br><br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFPackageSizeQty)
Property PackageSize As HS.SDA3.Numeric;

/// If the DrugProduct is dispensed as a package, this is the units of the<br>
/// items in the package. For example, BaseQty=3, BaseUnits=ml, PackageSize=4,<br>
/// PackageSizeUnits=syringes could be a dispensing unit of a strip of 4x3ml<br>
/// syringes.<br><br>
/// SDATableName=PackageSizeUoM, ViewerClass=User.HS.PHCPack<br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFPHCPADR)
Property PackageSizeUnits As HS.SDA3.CodeTableDetail.PackageSizeUoM;

/// If the DrugProduct is dispensed as an individual product, this is the type<br>
/// of product.<br><br>
/// SDATableName=DrugProductType, ViewerClass=User.HS.PHCType<br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDTypeDR)
Property Type As HS.SDA3.CodeTableDetail.DrugProductType;

/// If the DrugProduct is dispensed as an individual product or as a<br>
/// substitute (generic) product, this is the form of the product.<br><br>
/// SDATableName=DrugProductForm, ViewerClass=User.HS.PHCForm<br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFPHCFDR)
Property Form As HS.SDA3.CodeTableDetail.DrugProductForm;

/// If the DrugProduct is dispensed as an individual product, this is an<br>
/// alternative identifier for the product.<br><br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFOfficialCode)
Property Identifier1 As %String(MAXLEN = 220);

/// If the DrugProduct is dispensed as an individual product, this is an<br>
/// alternative identifier for the product.<br><br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFRegionCodeFDB)
Property Identifier2 As %String(MAXLEN = 220);

/// If the DrugProduct is dispensed as an individual product, this is the ATC<br>
/// (Anatomic Therapeutic Chemical) code for the product.<br><br>
/// SDATableName=ATCCode, ViewerClass=User.HS.PHCSubCat<br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDPHCSCDR)
Property ATCCode As HS.SDA3.CodeTableDetail.ATCCode;

/// If the DrugProduct is dispensed as an individual product, this is the<br>
/// quantity part of the strength of the product.<br><br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(ChildPHCFormDoseEquiv)->User.HS.PHCFormDoseEquiv(EQQty)
Property StrengthQty As HS.SDA3.Numeric;

/// If the DrugProduct is dispensed as an individual product, this is the<br>
/// units part of the strength of the product.<br><br>
/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(ChildPHCFormDoseEquiv)->User.HS.PHCFormDoseEquiv(EQCTUOMDR)
Property StrengthUnits As HS.SDA3.CodeTableDetail.UoM;

/// If the DrugProduct is dispensed as a substitute (generic) product, this is<br>
/// the strength (group) of the product.<br><br>
/// SDATableName=Strength, ViewerClass=User.HS.PHCStrength
/// VIEWERLIB: User.HS.PHCDrgMast(ChildPHCDrgForm)->User.HS.PHCDrgForm(PHCDFPHCSDR)
Property Strength As HS.SDA3.CodeTableDetail.Strength;

/// If the DrugProduct is dispensed as a substitute (generic) product, this is<br>
/// the active substance of the product.<br><br>
/// SDATableName=Generic, ViewerClass=User.HS.PHCGeneric<br>
/// VIEWERLIB: User.HS.PHCDrgMast(PHCDGenericDR)
Property Generic As HS.SDA3.CodeTableDetail.Generic;

/// VIEWERLIB: User.HS.PHCDrgMast(PHCDLabelName1)
Property LabelName As %String(MAXLEN = 220);

/// The quantity of the drug product that was dispensed
Property DispensedQuantity As HS.SDA3.Numeric;

Storage Default
{
<Data name="CodeTableDetailState">
<Value name="1">
<Value>SDATableName</Value>
</Value>
<Value name="2">
<Value>SDACodingStandard</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>InternalReference</Value>
</Value>
<Value name="6">
<Value>ErrorStatus</Value>
</Value>
<Value name="7">
<Value>OrderType</Value>
</Value>
<Value name="8">
<Value>OrderCategory</Value>
</Value>
<Value name="9">
<Value>BaseQty</Value>
</Value>
<Value name="10">
<Value>BaseUnits</Value>
</Value>
<Value name="11">
<Value>ProductName</Value>
</Value>
<Value name="12">
<Value>OfficialCode</Value>
</Value>
<Value name="13">
<Value>PackageSize</Value>
</Value>
<Value name="14">
<Value>PackageSizeUnits</Value>
</Value>
<Value name="15">
<Value>Type</Value>
</Value>
<Value name="16">
<Value>Form</Value>
</Value>
<Value name="17">
<Value>Identifier1</Value>
</Value>
<Value name="18">
<Value>Identifier2</Value>
</Value>
<Value name="19">
<Value>ATCCode</Value>
</Value>
<Value name="20">
<Value>StrengthQty</Value>
</Value>
<Value name="21">
<Value>StrengthUnits</Value>
</Value>
<Value name="22">
<Value>Strength</Value>
</Value>
<Value name="23">
<Value>Generic</Value>
</Value>
<Value name="24">
<Value>LabelName</Value>
</Value>
<Value name="25">
<Value>EId</Value>
</Value>
<Value name="26">
<Value>OriginalText</Value>
</Value>
<Value name="27">
<Value>PriorCodes</Value>
</Value>
<Value name="28">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="29">
<Value>Extension</Value>
</Value>
<Value name="30">
<Value>DispensedQuantity</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

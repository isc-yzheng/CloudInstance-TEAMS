Class HS.AU.Types.HI.CurrentNameType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Name/3.2.0";

Parameter XMLNAME = "CurrentNameType";

Parameter XMLSEQUENCE = 1;

Property NameTitle As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", VALUELIST = ",ABBOT,AB,ADML,ACM,AIRCDRE,AM,AVM,AC,ACW,ALD,AMBSR,ARCHBISHOP,ARCHDEACON,ASSOC PROF,BARON,BARONESS,BISHOP,BDR,BRIG,BR,CDT,CANON,CAPT,CAPT, RAN,CARDNL,CHAP,CPO,COL,CMDR,CMM,CDRE,CONST,CONSUL,CPL,COUNT,COUNTESS,DAME,DEACON,DEACONESS,DEAN,DEPUTY SUPT,DIRECTOR,DR,EARL,ENGR,FR,FLTLT,FSGT,FLGOFF,GEN,GOV,GP CAPT,HON,JUDGE,JUSTICE,LADY,LBDR,LCPL,LAC,LACW,LS,(ARMY) LT,LEUT,LTCOL,LCDR,LTGEN,LTGOV,LORD,MADAM,MADAME,MAJ,MAJGEN,MGR,MSTR,MAYOR,MAYORESS,MIDN,MISS,MR,MON,MOST REV,MTHR,MRS,MS,NURSE,OCDT,PASTOR,PO,PLTOFF,PTE,PROF,RABBI,RADM,RECTOR,RSM,RSM-A,REV,RTHON,RT REV,SMN,2LT,SEN,SNR,SGT,SIR,SR,SISTER SUP,SQNLDR,SCDT,SSGT,SM,SBLT,SUPT,SWAMI,VADM,VCE CMNDR,VISCOUNT,WOFF,WO,WO1,WO2,WOFF-AF,WO-N,WCDR", XMLNAME = "nameTitle", XMLREF = 1);

Property FamilyName As %String(MAXLEN = 40, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", XMLNAME = "familyName", XMLREF = 1) [ Required ];

Property GivenName As list Of %String(MAXLEN = 40, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", XMLNAME = "givenName", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property NameSuffix As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", VALUELIST = ",BM,BEM,COMDC,CH,AC,CV,DCMG,DCB,DBE,DCVO,AD,DFM,DSC,DSM,VIII,ESQ,V,I,IV,GC,JNR,JP,KB,KCMG,KCB,KBE,KCVO,AK,KG,KT,MD,OAM,MP,MHA,MHR,MLA,MLC,AM,MBE,MC,IX,OC,AO,OBE,OM,QC,II,SNR,VII,VI,SC,X,III,VC", XMLNAME = "nameSuffix", XMLREF = 1);

Storage Default
{
<Data name="CurrentNameTypeState">
<Value name="1">
<Value>NameTitle</Value>
</Value>
<Value name="2">
<Value>FamilyName</Value>
</Value>
<Value name="3">
<Value>GivenName</Value>
</Value>
<Value name="4">
<Value>NameSuffix</Value>
</Value>
</Data>
<State>CurrentNameTypeState</State>
<StreamLocation>^HS.AU.Type3554.CurrentNameT738S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

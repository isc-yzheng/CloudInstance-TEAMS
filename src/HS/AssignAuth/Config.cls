Class HS.AssignAuth.Config Extends (%Persistent, %XML.Adaptor, HS.Util.CopyFrom, HS.Sync.BaseClass) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 160;

Index NameIdx On (IdentifierType, Name);

Index CodeIdx On (Code, IdentifierType) [ Unique ];

Index OtherIDIdx On (IdentifierType, OtherId);

Property Code As %String;

Property Name As %String;

Property IdentifierType As HS.AssignAuth.IdentifierType;

/// For doctor numbers, a further classification
Property NumberType As %String;

Property AllowMultiple As %Boolean [ InitialExpression = 0 ];

/// The MPI's ID for the assigning authority, which may be different (at least for Quadramed) from our Code.
Property OtherId As %String(MAXLEN = 256);

/// Delete after validating (none currently)
ClassMethod DeleteData(id As %String, concurrency As %Integer = -1) As %Status
{
	Quit ..%DeleteId(id,concurrency)
}

Query ListAssigningAuthorities(pTypeId As %String) As %SQLQuery
{
SELECT %ID,Name,Code,OtherId,AllowMultiple FROM Config
 WHERE (%Internal(IdentifierType) = :pTypeId)
 ORDER BY Name
}

ClassMethod GetNumberType(pCode As %String) As %String
{
	&sql(SELECT NumberType INTO :pNumberType FROM HS_AssignAuth.Config WHERE Code=:pCode AND IdentifierType='DN')
	Quit $S(SQLCODE:"",1:pNumberType)
}

/// Return properties of an Assigning Authority that has Code value equal to <code>pCode</code> that has the IdentifierType given by <code>pType</code>, if provided.
/// If <code>pType</code> is not provided, it is returned as an output value for the AssigningAuthority entry that matches <code>pCode</code>.  In this case, if there is more
/// than one entry that has code <code>pCode</code>, the first one encountered will be returned and its corresponding IdentifierType value will
/// be returned suffixed with "+" and the count in <code>pType</code>. Entries that have an empty NumberType value, which are generally MR (Medical Record) types, are chosen if present.
/// If no entry is found, the return status from this method is $$$OK, <code>pOtherId</code> is empty, and other output arguments are undefined.
ClassMethod FindByCode(ByRef pType As %String, pCode As %String, Output pOtherId As %String, Output pName As %String, Output pNumberType As %String) As %Status
{
	If $D(pType)#2 {
		&sql(SELECT OtherId,Name,NumberType INTO :pOtherId,:pName,:pNumberType FROM HS_AssignAuth.Config WHERE Code=:pCode AND IdentifierType=:pType)
	} Else {
		&sql(SELECT COUNT(*) INTO :tCount FROM HS_AssignAuth.Config WHERE Code=:pCode)
		If 'SQLCODE {
			&sql(SELECT OtherId,Name,NumberType,IdentifierType INTO :pOtherId,:pName,:pNumberType,:pType FROM HS_AssignAuth.Config WHERE Code=:pCode ORDER BY NumberType) ; get the MR types first
			If (tCount>1) Set pType=pType_"+"_(tCount-1)
		}
	}
	If SQLCODE Set pOtherId=""  Kill pName,pNumberType
	Quit $S(SQLCODE<0:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)),1:$$$OK)
}

ClassMethod FindByOtherId(pType As %String, pOtherId As %String, Output pCode As %String = "") As %Status
{
	&sql(SELECT Code INTO :pCode FROM HS_AssignAuth.Config WHERE OtherId = :pOtherId AND IdentifierType=:pType)
	Quit $S(SQLCODE<0:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)),1:$$$OK)
}

/// Validation before save
Method %OnValidateObject() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	
	// Code must be unique for an identifier type
	Set tCode=..Code,tTypeId=..IdentifierTypeGetObjectId()
	&sql(Select ID INTO :tId From HS_AssignAuth.Config Where Code = :tCode And IdentifierType = :tTypeId)
	If SQLCODE = 0,tId'=..%Id() {
		Set tSC = $$$ERROR($$$GeneralError,"The code for this assigning authority has already been assigned")
	}
	
	Quit tSC
}

ClassMethod AddAssigningAuthority(pCode = "", pName = "", pFacilityId = "") As %Status
{
	//Set tCode=..FacilityCode,tName=..Name,tFacilityId=..FacilityId
	For tIDType = "MR","DN" {
		&SQL(Select ID INTO :tAAId FROM HS_AssignAuth.Config WHERE Code = :pCode And IdentifierType = :tIDType)
		If SQLCODE {
			If tIDType="MR" {
				&SQL(INSERT INTO HS_AssignAuth.Config(Code,Name,OtherId,IdentifierType) Values(:pCode,:pName,:pFacilityId,:tIDType))
			} Else {
				&SQL(INSERT INTO HS_AssignAuth.Config(Code,Name,OtherId,IdentifierType,NumberType) Values(:pCode,:pName,:pFacilityId,:tIDType,'HospID'))
			}
			Set tSC=$S(SQLCODE=0:$$$OK,1:$$$ERROR($$$GeneralError,"Unable to create assigning authority"))
		} Else {
			&SQL(UPDATE HS_AssignAuth.Config SET OtherId = :pFacilityId WHERE ID=:tAAId and OtherId <> :pFacilityId)
			Set tSC=$S(SQLCODE=0||(SQLCODE=100):$$$OK,1:$$$ERROR($$$GeneralError,"Unable to update assigning authority"))
		}
	}
	Quit tSC
}

/// Create an assigning authority if not already on file
ClassMethod RegisterAssigningAuthority(pIdentifierType As %String, pCode As %String, pType As %String = "") As %Status
{
	Set tSC=$$$OK
	If pIdentifierType]"",pCode]"" {
		&SQL(Select ID FROM HS_AssignAuth.Config WHERE Code = :pCode And IdentifierType = :pIdentifierType)
		If SQLCODE<0 { Set tSC=$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)) Quit tSC }
		If SQLCODE>0 {
			Set tAssignAuth=##class(HS.AssignAuth.Config).%New()
			Do tAssignAuth.IdentifierTypeSetObjectId(pIdentifierType)
			Set tAssignAuth.Code=pCode
			Set tAssignAuth.Name=pCode
			Set tAssignAuth.NumberType=pType
			Set tSC=tAssignAuth.%Save()
		} 
	}
	Quit tSC
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>IdentifierType</Value>
</Value>
<Value name="5">
<Value>AllowMultiple</Value>
</Value>
<Value name="6">
<Value>OtherId</Value>
</Value>
<Value name="7">
<Value>NumberType</Value>
</Value>
</Data>
<DataLocation>^HS.AssignAuth.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.AssignAuth.ConfigD</IdLocation>
<IndexLocation>^HS.AssignAuth.ConfigI</IndexLocation>
<StreamLocation>^HS.AssignAuth.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

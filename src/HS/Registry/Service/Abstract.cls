/// 
Class HS.Registry.Service.Abstract Extends (%Persistent, %XML.Adaptor, HS.Util.UpdateFrom, HS.Sync.BaseClass) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter SYNCORDER = 90;

/// Codes to be indexed from the OIDMap table where the Array Node is the OIDMapType and the data is the OIDMap Code
Property OIDMapCode As array Of %String;

Index OIDMapIndex On (OIDMapCode(ELEMENTS), OIDMapCode(KEYS));

/// When a single deviceID is used for multiple functions XCA Query / Retrieve could be two end points but only one home community ID
Property DeviceFunction As %String(SELECTIVITY = ".1%");

Property Name As %String(MAXLEN = 255) [ Required ];

Property ServiceAliases As list Of %String(MAXLEN = 255, STORAGEDEFAULT = "array");

Property Type As %String(MAXLEN = 255) [ Required ];

/// Whether available to Push as a delivery destination
Property Push As %Boolean [ InitialExpression = 0 ];

/// Whether the Service is active or not
Property Status As %Boolean [ InitialExpression = 1 ];

Property Timeout As %Integer;

Property CharSet As %String;

Property AdditionalInfo As array Of %String(MAXLEN = 32000);

Property SystemGenerated As %Boolean [ InitialExpression = 0 ];

Property Info As %String(MAXLEN = 512) [ SqlComputeCode = {	
	Set {*} = ""
	}, SqlComputed, Transient ];

Index NameTypeIndex On (Name, Type);

Index TypeIndex On Type;

Index DeviceFunctionIndex On DeviceFunction [ Type = bitmap ];

Index AliasIndex On ServiceAliases(ELEMENTS);

/// Alias
Property Aliases As %String(MAXLEN = 512) [ Calculated, SqlComputeCode = {Set {*}=##Class(HS.Registry.Service.Abstract).CMAliasesGet({ID})}, SqlComputed ];

ClassMethod CMAliasesGet(pID) As %String
{
	Set obj=..%OpenId(pID,0)
	Quit $S($isObject(obj):obj.Aliases,1:"")
}

Method AliasesGet() As %String [ ServerOnly = 1 ]
{
	Set str=""
	For tIdx=1:1:..ServiceAliases.Count() {
		Set tAlias=..ServiceAliases.GetAt(tIdx) continue:tAlias=""
		Set str=str_","_..ServiceAliases.GetAt(tIdx)
	}
	quit $E(str,2,*)
}

/// Provides an exact match for Name and Type 
/// During IHE testing it was common for sites to have a single end point for testing
/// by using defining the name with no type it will allow this non-exact matching if there is only 1 entry
ClassMethod EndPointForNameType(pName As %String = "", pType As %String, pStatus As %Boolean = 1) As HS.Registry.Service.SOAP
{
	Set SQLCODE=100,ID="",tCount=0
	If $g(pType,..%ClassName())]"" {
		&sql(select ID,Count(*) into :ID,:tCount from HS_Registry_Service.Abstract where Name=:pName and Type=:pType and Status=:pStatus )
	} 
	IF SQLCODE=100 {
		&sql(select ID,Count(*) into :ID,:tCount from HS_Registry_Service.Abstract where Name=:pName AND Type is null AND Status=:pStatus )
	}
	IF SQLCODE=100 { // Lookup via Alias
		&sql(select ID,Count(*) into :ID,:tCount from HS_Registry_Service.Abstract where Aliases[:pName AND Type=:pType AND Status=:pStatus )
	}
	Quit $S(SQLCODE:"",tCount=1:..%OpenId(ID),1:"")
}

/// Get the first ID with this Name and Type.
ClassMethod IDForNameType(pName As %String, pType As %String) As %String
{
	Set SQLCODE=100,ID=""
	If $g(pType,..%ClassName())]"" {
		&sql(select ID into :ID from HS_Registry_Service.Abstract where Name=:pName and Type=:pType )
	}
	Quit $S(SQLCODE:"",1:ID)
}

/// Using the deviceID (OID) find the end point (for example a repository ID returned from a registry)
ClassMethod EndPointForDeviceID(pDeviceID As %String = "", pType As %String = "", pStatus As %Boolean = 1, pFunction As %String = "") As HS.Registry.Service.SOAP
{
	Quit ..EndPointForID(pDeviceID,"Device",pFunction,pType,pStatus)
}

/// Using the HomeCommunityOID find the end point 
ClassMethod EndPointForHomeCommunityID(pHomeCommunityID As %String = "", pFunction As %String = "", pType As %String = "", pStatus As %Boolean = 1) As HS.Registry.Service.SOAP
{
	Quit ..EndPointForID(pHomeCommunityID,"HomeCommunity",pFunction,pType,pStatus)
}

/// Using the HomeCommunityOID find the end point 
ClassMethod EndPointForHomeCommunityOID(pHomeCommunityOID As %String = "", pFunction As %String = "", pType As %String = "", pStatus As %Boolean = 1) As HS.Registry.Service.Abstract
{
	Quit ..EndPointForOID(pHomeCommunityOID,"HomeCommunity",pFunction,pType,pStatus)
}

/// Using the ID find the end point 
ClassMethod EndPointForID(pOIDMapCode As %String = "", pCodeType As %String = "", pFunction As %String = "", pType As %String = "", pStatus As %Boolean = 1) As HS.Registry.Service.Abstract
{
	Set SQLCODE=100,ID="",tCount=0 
	For tIdx=1:1:16 Set p(tIdx)="",p=0,tSQLFunction="",tDone=0,tReturnObject=""
	Set tSQL="select Abstract,Count(*) as CNT from HS_Registry_Service.Abstract_OIDMapCode where OIDMapCode=? AND element_key = ? AND Abstract->Status=? "
	If pType]"" Set tSQL=tSQL_"AND Abstract->Type=?",p($I(p))=pType

	If pFunction]"" {
		Set tSQLFunction = " AND Abstract->DeviceFunction=?",p($i(p))=pFunction
	}
	
	While 'tDone {
		Set tRS = ##class(%ResultSet.SQL).%Prepare(tSQL_tSQLFunction,.tER,"",pOIDMapCode,pCodeType,pStatus,p(1),p(2))
		Set tDone=(tSQLFunction="" || (tSQLFunction="AND Abstract->DeviceFunction is null"))
		If $isObject(tER) {
			Throw tER
		}		
		Do tRS.%Next()
		If tRS.CNT>1 {
			Set tText="",tAll=0
			While 'tAll {
				Set tText=tText_","_tRS.Abstract.Name
				Set tAll='tRS.%Next()
			}
			$$$ThrowStatus($$$ERROR($$$GeneralError,"More than 1 row found for code:"_pOIDMapCode_", CodeType:"_pCodeType_" Items:"_$e(tText,2,*)))
		}
		If tRS.CNT=1 Set tReturnObject=tRS.Abstract Quit
		Set:tSQLFunction]"" tSQLFunction="AND Abstract->DeviceFunction is null"  // if we are looking for a function, it is not okay to take an entry with another function
	}

	Quit tReturnObject
}

/// Using the  find the end point 
ClassMethod EndPointForOID(pOID As %String = "", pOIDType, pFunction As %String = "", pType As %String = "", pStatus As %Boolean = 1) As HS.Registry.Service.SOAP
{
	Set tID = ##class(HS.Data.OIDMap).GetCodeForOID(pOID)
	If tID ="" Quit ""
	Quit ..EndPointForID(tID,pOIDType,pFunction,pType,pStatus)
}

Method AddUpdateObject(ByRef pExistingObject = "") As %Status
{
	Set pExistingObject = ..EndPointForNameType(..Name,..Type,..Status)
	if '$isObject(pExistingObject) Set pExistingObject = ..EndPointForNameType(..Name,..Type,'..Status)
	#; can't just use existing as the move does a lookup for references
	If '$isObject(pExistingObject) Set pExistingObject=..%New()
	Set tStatus=..MoveProperties(pExistingObject) Quit:'tStatus tStatus
	Quit pExistingObject.%Save()
}

Method MoveProperties(pExistingObject As %RegisteredObject) As %Status [ CodeMode = objectgenerator ]
{
	If %class.Abstract=1 Quit $$$OK
	Do %code.WriteLine(" Set tStatus=$$$OK")
	Set key=""
	For {
		Set tProperty=%objcompiledclass.Properties.GetNext(.key) 
		Quit:'$isObject(tProperty)
		If tProperty.Transient=1 Continue
		If tProperty.Calculated=1 Continue
		Set tClass=##class(%ClassDefinition).%OpenId(tProperty.Type,0)
		If tProperty.Collection]"" Do %code.WriteLine(" Do pExistingObject."_tProperty.Name_".Clear()")
		If tClass.Super["%DataType" {
			if tProperty.Collection="" {
				Do %code.WriteLine(" Set pExistingObject."_tProperty.Name_"=.."_tProperty.Name)
			} Elseif tProperty.Collection="list" {
				Do %code.WriteLine(" For tIdx=1:1:.."_tProperty.Name_".Count() Set tValue=.."_tProperty.Name_".GetAt(tIdx) Do pExistingObject."_tProperty.Name_".Insert(tValue)")
			} Elseif tProperty.Collection="array" {
				Do %code.WriteLine(" Set tNext="""" for  Set tValue=.."_tProperty.Name_".GetNext(.tNext) Quit:tNext=""""  Do pExistingObject."_tProperty.Name_".SetAt(tValue,tNext) ")
			}
		} Else {
			if tProperty.Collection="" {
				Do %code.WriteLine(" If $isobject(.."_tProperty.Name_") {")
				Do %code.WriteLine(" 	Set tStatus=.."_tProperty.Name_".FindWithObject(.tExistingObject)")
				Do %code.WriteLine(" 	If '$$$ISOK(tStatus) Quit tStatus")
				Do %code.WriteLine(" 	Set pExistingObject."_tProperty.Name_"=tExistingObject")
				Do %code.WriteLine(" }")
			} Elseif tProperty.Collection="list" {
				Do %code.WriteLine(" For tIdx=1:1:.."_tProperty.Name_".Count() Set tValue=.."_tProperty.Name_".GetAt(tIdx) Set tStatus=tValue.FindWithObject(.tExistingObject) If '$isObject(tExistingObject) { Set tStatus=$$$HSError($$$HSErrNoExistingObject,"_tProperty.Name_") Quit } Do pExistingObject."_tProperty.Name_".Insert(tExistingObject)")
			} Elseif tProperty.Collection="array" {
				Do %code.WriteLine(" Set tNext="""" for  Set tValue=.."_tProperty.Name_".GetNext(.tNext) Quit:tNext=""""  Set tStatus=tValue.FindWithObject(.tExistingObject) Quit:'tStatus  Set tStatus=pExistingObject."_tProperty.Name_".SetAt(tExistingObject,tNext) Quit:'tStatus")
			}
		}		
	}
	Do %code.WriteLine(" Quit tStatus")
	Quit $$$OK
}

Query Services(pServiceType As %String, pSearch As %String = "") As %Query(ROWSPEC = "ID:%Integer,Name:%String,Info:%String,Type:%String")
{
}

ClassMethod ServicesExecute(ByRef qHandle As %Binary, pServiceType As %String = "", pSearch As %String = "") As %Status
{
	Set tServiceType=$S(pServiceType="SOAP":"HS_Registry_Service.SOAP",pServiceType="FileType":"HS_Registry_Service.FileType",pServiceType="FTP":"HS_Registry_Service.FTP",pServiceType="TCP":"HS_Registry_Service.TCP",pServiceType="HTTP":"HS_Registry_Service.HTTP",pServiceType="UDP":"HS_Registry_Service.UDP",1:"HS_Registry_Service.Abstract")
	Set:tServiceType="HS_Registry_Service.Abstract" pServiceType=""
	Set tSQL=""
	If pServiceType="TCP" {
		Set tSQL=tSQL_" WHERE ID NOT IN (SELECT ID FROM HS_Registry_Service.SOAP) AND (ID NOT IN (SELECT ID FROM HS_Registry_Service.HTTP))"
	} ElseIf pServiceType="HTTP" {
		Set tSQL=tSQL_" WHERE ID NOT IN (SELECT ID FROM HS_Registry_Service.SOAP) "
	} ElseIf pServiceType="FileType" {
		Set tSQL=tSQL_" WHERE ID NOT IN (SELECT ID FROM HS_Registry_Service.FTP) "
	}
	Set tField=$S(pServiceType="HTTP":"EndPoint",pServiceType="SOAP":"EndPoint",1:"Info")
	If pSearch'="" {
		Set tSQL=tSQL_$S(tSQL["WHERE":" AND ",1:" WHERE")
		Set tSQL=tSQL_" (Upper("_tField_") [? OR Upper(Name) [?)"
	}
	Set tSQL="SELECT ID,Name,"_tField_",Type FROM "_tServiceType_tSQL
	Set qHandle=##class(%ResultSet).%New()
	Do qHandle.Prepare(tSQL)
	If pSearch="" {Do qHandle.Execute()}
	Else {Do qHandle.Execute($ZCVT(pSearch,"U"),$ZCVT(pSearch,"U"))}
	Quit $$$OK
}

ClassMethod ServicesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ServicesExecute ]
{
	Quit $$$OK
}

ClassMethod ServicesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ServicesExecute ]
{
	Set Row=""
	If 'qHandle.Next() Set AtEnd=1 Quit $$$OK
	For tIdx=1:1:5 Set Row=Row_$lb(qHandle.GetData(tIdx))
	Quit $$$OK
}

/// Query to list all SOAP Services
Query ListSoapServices() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID, Aliases, CharSet, DeviceFunction, EncryptX509TokenProfile, EndPoint, HTTPCredentialsConfig, Host, Info, KerberosTokenProfileConfig, MTOM, Name, Port, ProxyHTTPS, ProxyHTTPSSLConnect, ProxyHTTPTunnel, ProxyHost, ProxyPort, Push, SAMLTokenProfileConfig, SOAPVersion, SSLCheckServerIdentity, SSLConfig, SecurityClass, SendSAMLAssertion, SignX509TokenProfile, Status, StayConnected, SystemGenerated, Timeout, Type, URL, UsernameTokenProfileConfig, XUAConfiguration 
	FROM HS_Registry_Service.SOAP WHERE Type='SOAP'
}

/// Query to list all HTTP Services
Query ListHTTPServices() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,Aliases,CharSet,DeviceFunction,EndPoint,HTTPCredentialsConfig,Host,Info,Name,Port,ProxyHTTPS,ProxyHTTPSSLConnect,ProxyHTTPTunnel,ProxyHost,ProxyPort,Push,SSLCheckServerIdentity,SSLConfig,Status,StayConnected,SystemGenerated,Timeout,Type,URL,SignX509TokenProfile
	FROM HS_Registry_Service.HTTP WHERE Type='HTTP'
}

/// Query to list all FTP Services
Query ListFTPServices() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,Aliases,CharSet,DeviceFunction,FilePath,Filename,Host,Info,Name,Overwrite,Port,Push,SSLConfig,Status,SystemGenerated,Timeout,Type,UsePassive,UserCredentialsConfig
	FROM HS_Registry_Service.FTP WHERE Type='FTP'
}

/// Query to list all FileType Services
Query ListFileTypeServices() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,Aliases,CharSet,DeviceFunction,FilePath,Filename,Info,Name,Overwrite,Push,Status,SystemGenerated,Timeout,Type
	FROM HS_Registry_Service.FileType WHERE Type='FileType'
}

/// Query to list all TCP Services
Query ListTCPServices() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,Aliases,CharSet,DeviceFunction,Host,Info,Name,Port,Push,SSLConfig,Status,StayConnected,SystemGenerated,Timeout,Type
	FROM HS_Registry_Service.TCP WHERE Type='TCP'
}

/// Query to list all UDP Services
Query ListUDPServices() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,Aliases,CharSet,DeviceFunction,Host,Info,Name,Port,Push,Status,SystemGenerated,Timeout,Type,UDPSenderCommand
	FROM HS_Registry_Service.UDP WHERE Type='UDP'
}

/// Used by synchronization to determine whether there are any table entries
ClassMethod TableEmpty() As %Boolean
{
	&sql(select count(*) into :tCount from HS_Registry_Service.Abstract)
	Quit '+$G(tCount)
}

Storage Default
{
<Data name="AbstractDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeviceID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Timeout</Value>
</Value>
<Value name="7">
<Value>CharSet</Value>
</Value>
<Value name="8">
<Value>DeviceFunction</Value>
</Value>
<Value name="9">
<Value>HomeCommunityID</Value>
</Value>
<Value name="10">
<Value>Push</Value>
</Value>
<Value name="11">
<Value>SystemGenerated</Value>
</Value>
</Data>
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="OIDMapCode">
<Attribute>OIDMapCode</Attribute>
<Structure>subnode</Structure>
<Subscript>"OIDMapCode"</Subscript>
</Data>
<Data name="ServiceAliases">
<Attribute>ServiceAliases</Attribute>
<Structure>subnode</Structure>
<Subscript>"ServiceAliases"</Subscript>
</Data>
<DataLocation>^HS.Registry.Service.AbstractD</DataLocation>
<DefaultData>AbstractDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.Service.AbstractD</IdLocation>
<IndexLocation>^HS.Registry.Service.AbstractI</IndexLocation>
<StreamLocation>^HS.Registry.Service.AbstractS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

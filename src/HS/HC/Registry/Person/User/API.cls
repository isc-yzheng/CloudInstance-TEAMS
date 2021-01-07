Include (HS.HC, %ZHSLIB)

Class HS.HC.Registry.Person.User.API Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter DOMAIN = "HS";

/// API Method
/// Return the Default Auth Domain.  Defaults to <code>"%HS_Default"</code> if a default is not set
ClassMethod GetDefaultDomain() As %String
{
	Quit ##class(HS.Registry.AuthDomain).GetDefaultDomain()
}

/// API Method
/// Update BadLoginCount for user to passed in value.
/// pDomain is the Login Domain
/// pLoginID is the user's login ID
/// pBadLoginCount is either an integer to set the current count value or 0 to reset it
ClassMethod UpdateBadLoginCount(pDomain As %String, pLoginID As %String, pBadLoginCount As %Integer)
{
	&SQL(Update HS_Registry_Person.UserLoginID Set BadLoginCount=:pBadLoginCount WHERE DomainCode=:pDomain AND LoginID=:pLoginID)
	Quit
}

/// API Method
/// Clear User's Password to disable account due to exceeding bad login attempts.
/// pDomain is the Login Domain
/// pLoginID is the user's login ID
ClassMethod ClearUserPassword(pDomain As %String, pLoginID As %String)
{
	&SQL(Update HS_Registry_Person.UserLoginID Set Salt='', Password='' WHERE DomainCode=:pDomain AND LoginID=:pLoginID)
	Quit
}

/// API Method
/// Return email address for user
ClassMethod GetUserEmail(pUserInternal As %String) As %String
{
	Set tEmailAddress=""
	&SQL(SELECT Telecoms_Email into :tEmailAddress from HS_Registry_Person.UserClinician_Telecoms where UserClinician=:pUserInternal AND Telecoms_Email IS NOT NULL)
	If SQLCODE'=0 Quit ""
	If tEmailAddress="" Quit ""
	Quit tEmailAddress
}

/// API Method
/// Return User Internal ID
ClassMethod GetUserInternal(pLoginInternalID) As %String
{
	Set tUserInternal=""
	&SQL(SELECT UserClinician->ID INTO :tUserInternal FROM HS_Registry_Person.UserLoginID WHERE ID=:pLoginInternalID)
	If SQLCODE'=0 Quit ""
	If tUserInternal="" Quit ""
	Quit tUserInternal
}

/// API Method
/// Return UserLoginID Object
ClassMethod LoadUserLoginIDHSAuth(pRegistryId As %String = "", pDomain As %String = "") As HS.Registry.Person.UserLoginID
{
	Set tUserLoginId=""
	&SQL(Select ID Into :tUserLoginId From HS_Registry_Person.UserLoginID Where LoginID = :pRegistryId And DomainCode = :pDomain And UserClinician->Active = 1 And IsNull(ExpirationDate,CURRENT_DATE)>=CURRENT_DATE)
	If SQLCODE'=0 Quit ""
	If tUserLoginId="" Quit ""
	Set tObj=##class(HS.Registry.Person.UserLoginID).%OpenId(tUserLoginId,4,.tSC)
	Quit tObj
}

/// API Method
/// Return UserLoginID Object with Challenge Questions
ClassMethod LoadUserLoginIDHSAuthChallenge(pRegistryId As %String = "", pDomain As %String = "", pChallengeQ As %String = "", pChallengeA As %String = "") As HS.Registry.Person.UserLoginID
{
	Set tUserLoginId=""
	&SQL(Select ID Into :tUserLoginId From HS_Registry_Person.UserLoginID Where LoginID = :pRegistryId And DomainCode = :pDomain And UserClinician->Active = 1 And IsNull(ExpirationDate,CURRENT_DATE)>=CURRENT_DATE AND ChallengeQuestion=:pChallengeQ AND ChallengeAnswer=:pChallengeA)
	If SQLCODE'=0 Quit ""
	If tUserLoginId="" Quit ""
	Set tObj=##class(HS.Registry.Person.UserLoginID).%OpenId(tUserLoginId,4,.tSC)
	Quit tObj
}

/// API Method
/// Return count of specified email operation found in Ensemble production 
ClassMethod VerifyEmailOperation(pHub As %String = "", pOperation As %String = "") As %Integer
{
	Set tCount=""
	&sql(select count(*) into :tCount from Ens_Config.Item Where Production=:pHub and Name=:pOperation)
	Quit tCount
}

/// API Method
/// Return Callback class for Authentication Domain
ClassMethod GetCallbackClass(pDomain As %String = "") As %String
{
	Set tClass=""
	&SQL(Select CallbackClass INTO :tClass FROM HS_Registry.AuthDomain WHERE Upper(DomainCode)=Upper(:pDomain))
	If SQLCODE'=0 Quit ""
	Quit tClass
}

}

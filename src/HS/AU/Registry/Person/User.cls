/// HS.Registry.Config "\UserLogin\PostLoginCode" = HS.AU.Registry.Person.User:PostLogin
Class HS.AU.Registry.Person.User Extends %RegisteredObject
{

/*
According to NEHTA, the number is made up as follows:	80036XnnnnnnnnnY

800 is 'Australia', 36 is 'eHealth'

X	is (0) for individual (IHI)
	is (1) for provider (HPI-I)
	is (2) for organisation (HPI-O)

nnn	is the serial number
Y	is a check digit

*/
ClassMethod PostLogin(pUser As %String = "", pSessionInfo As HS.Registry.Person.User.WebServices.Containers.SessionInfo)
{
	Set tResponse=##Class(HS.Registry.Person.User.WebServices.Containers.User).%New()
	Set tSC=##Class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","LoadUser",.tResponse,pSessionInfo.UserInternalID)
	Quit:$$$ISERR(tSC)
	Set %session.Data("Username")=pUser
	Set tHIRoot = ##class(HS.Registry.Config).GetKeyValue("\AU\AssigningAuthority\HI")
	For tIdx=1:1:tResponse.Identifiers.Count() {
		Set tIdent=tResponse.Identifiers.GetAt(tIdx)
		If tIdent.AssigningAuthorityName=tHIRoot || (tIdent.Root=tHIRoot) {
			Set tExtension = tIdent.Extension
			If $e(tExtension,6)=1 {
			 	Set %session.Data("HPII")=tExtension
			} ElseIf $e(tExtension,6)=2 {
			 	Set %session.Data("HPIO")=tExtension
			 	&sql(select TOP 1 Description,FacilityCode INTO :tDesc,:tCode from HS_Facility.Config where FacilityId=:tExtension)
			 	Set tName = $S(SQLCODE:"",tDesc]"":tDesc,tCode]"":tCode)
			 	Set %session.Data("HPIO-Name")=$S(tName]"":tName,1:"HealthShare")
			} 
		}
	}
	Quit
}

}

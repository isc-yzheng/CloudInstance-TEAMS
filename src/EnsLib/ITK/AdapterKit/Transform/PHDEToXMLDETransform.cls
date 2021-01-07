/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Transforms an XML Distribution Envelope to an PH base64 encoded DE
/// It is expected that the DE are streams
Class EnsLib.ITK.AdapterKit.Transform.PHDEToXMLDETransform Extends Ens.DataTransform [ ProcedureBlock, System = 4 ]
{

ClassMethod Transform(source As EnsLib.ITK.Framework.RequestData, target As %Stream.Object) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	
	do {
		// a. Convert PH HL7 payload into HL7 Message and into XML
		set hl7Message = ##class(EnsLib.ITK.AdapterKit.ConvertUtil).Base64StreamToHL7(source.Payload)
		set stream=##class(EnsLib.ITK.AdapterKit.ConvertUtil).HL7ToXML(hl7Message)
		
		// b. Create new payload stream as DE
		set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(source.ServiceName)
		set tPayloadID =  ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
		set tTrackingID =  ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
		set tAction = $S($IsObject(sd):sd.SOAPAction, 1:source.ServiceName)
		set tProfile = tAction
	
		set target = ##class(%Stream.GlobalCharacter).%New()
		do target.WriteLine("<itk:DistributionEnvelope xmlns:itk=""urn:nhs-itk:ns:201005"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">")
 		do target.WriteLine("	<itk:header service="""_tAction_""" trackingid="""_tTrackingID_""">")
 		if $G(auditIdentity)'="" {
	 		do target.WriteLine("		<itk:auditIdentity><itk:id uri="""_auditIdentity_"""/></itk:auditIdentity>")
 		}
 		do target.WriteLine("		<itk:manifest count=""1"">")
	 	do target.WriteLine("			<itk:manifestitem id=""uuid_"_tPayloadID_""" mimetype=""text/xml"" profileid="""_tProfile_""" base64=""false"" compressed=""false"" encrypted=""false""/>")
	 	do target.WriteLine("		</itk:manifest>")
 		do target.WriteLine("	</itk:header>")
	 	do target.WriteLine("	<itk:payloads count=""1"">")
 		do target.Write("		<itk:payload id=""uuid_"_tPayloadID_""">")
 		do target.CopyFrom(stream)
	 	do target.WriteLine("</itk:payload>")
 		do target.WriteLine("	</itk:payloads>")
	 	do target.WriteLine("</itk:DistributionEnvelope>")
	} while (0)
	
Exit
	Quit tSC
	
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

}

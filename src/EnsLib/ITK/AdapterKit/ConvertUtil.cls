/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class contains the basic conversion methods that are used
/// in the adapter transformations and processed, but can also be
/// be used in custom code. They are exposed as Ens.Rule.FunctionSet
/// so that they appear as functions when creating transformations
/// and rules.
Class EnsLib.ITK.AdapterKit.ConvertUtil Extends Ens.Rule.FunctionSet [ System = 4 ]
{

/// Takes a payload object and service and produces a lightweight DistributionEnvelope around it	
ClassMethod WrapDistributionEnvelope(payload As %XML.Adaptor, service As %String, auditIdentity As %String, senderAddress As %String) As %Stream
{
	do payload.XMLExportToStream(.xmlStream)
	quit ..WrapStreamDistributionEnvelope(xmlStream, service, auditIdentity, .senderAddress)
}

/// Takes a payload string and service and produces a lightweight DistributionEnvelope around it	
ClassMethod WrapStringDistributionEnvelope(content As %String, service As %String, auditIdentity As %String, senderAddress As %String) As %Stream
{
	set str=##class(%Stream.TmpCharacter).%New()
	do str.Write(content)
	quit ..WrapStreamDistributionEnvelope(str, service, auditIdentity, .senderAddress)
}

/// Takes a payload stream and service and produces a lightweight DistributionEnvelope around it	
ClassMethod WrapStreamDistributionEnvelope(stream As %Stream, service As %String, auditIdentity As %String, senderAddress As %String) As %Stream
{
	// Convert service to SOAPAction if it is required
	set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(service)
	set:$IsObject(sd) service=sd.SOAPAction
	
	set tPayloadID =  ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
	set tTrackingID =  ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
	set tAction = $S($IsObject(sd):sd.SOAPAction, 1:service)
	set tProfile = tAction
	
	// Create Distribution Envelope
	set deStream = ##class(%Stream.GlobalCharacter).%New()
	do deStream.WriteLine("<itk:DistributionEnvelope xmlns:itk=""urn:nhs-itk:ns:201005"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">")
 	do deStream.WriteLine("	<itk:header service="""_tAction_""" trackingid="""_tTrackingID_""">")
 	if $G(auditIdentity)'="" {
	 	do deStream.WriteLine("		<itk:auditIdentity><itk:id uri="""_auditIdentity_"""/></itk:auditIdentity>")
 	}
 	do deStream.WriteLine("		<itk:manifest count=""1"">")
 	do deStream.WriteLine("			<itk:manifestitem id=""uuid_"_tPayloadID_""" mimetype=""text/xml"" profileid="""_tProfile_""" base64=""false"" compressed=""false"" encrypted=""false""/>")
 	do deStream.WriteLine("		</itk:manifest>")
 	if $G(senderAddress)'="" {
	 	do deStream.WriteLine("		<itk:senderAddress uri="""_senderAddress_"""/>")
 	}
 	do deStream.WriteLine("	</itk:header>")
 	do deStream.WriteLine("	<itk:payloads count=""1"">")
 	do deStream.Write("		<itk:payload id=""uuid_"_tPayloadID_""">")
 	
 	do deStream.CopyFrom(stream)
 	
 	do deStream.WriteLine("</itk:payload>")
 	do deStream.WriteLine("	</itk:payloads>")
 	do deStream.WriteLine("</itk:DistributionEnvelope>")
 	
 	quit deStream
}

/// Converts from a HL7 Message into a PipeHat Base64 Encoded version
ClassMethod HL7ToBase64(message As EnsLib.HL7.Message) As %Stream
{
	set ret = ##class(%GlobalCharacterStream).%New()
	 
	set in =##class(%GlobalCharacterStream).%New()
	do message.PokeDocType("ITK:"_message.GetValueAt("1:9.3"))
    set sc = message.OutputToLibraryStream(in)
    
    do in.Rewind()
	set len=60
    while 'in.AtEnd {
		do ret.WriteLine($system.Encryption.Base64Encode(in.Read(.len)))
    }
    
    quit ret
}

/// Converts from an HL7 Message into an XML String
ClassMethod HL7ToXML(message As EnsLib.HL7.Message) As %Stream
{
	set ret = ##class(%GlobalCharacterStream).%New()
	do message.PokeDocType("ITK:"_message.GetValueAt("1:9.3"))
	//do message.OutputToLibraryStream(.ret, "", "", .sc, "EnsLib.ITK.HL7.FormatXMLv2")
	do ret.Write(message.OutputToString("", "", .sc, "EnsLib.ITK.HL7.FormatXMLv2"))
	quit ret
}

/// Converts from an XML stream representing HL7 message into
/// a HL7 Message
ClassMethod XMLStreamToHL7(str As %Stream) As EnsLib.HL7.Message
{
	set tConfigItem="ITK"
	set hl7Request = ##class(EnsLib.HL7.Message).ImportFromLibraryStream(str, .sc, .tConfigItem, "EnsLib.ITK.HL7.FormatXMLv2")
	quit hl7Request
}

/// Converts from a XML string representing HL7 message into
/// a HL7 Message
ClassMethod XMLToHL7(xml As %String) As EnsLib.HL7.Message
{
	set tConfigItem="ITK"
	set hl7Request = ##class(EnsLib.HL7.Message).ImportFromString(xml, .sc, .tConfigItem, "EnsLib.ITK.HL7.FormatXMLv2")
	quit hl7Request
}

/// Converts a string holding the Base64 represetation of a
/// Pipe and Hat message into a HL7 message
ClassMethod Base64ToHL7(base64 As %String) As EnsLib.HL7.Message
{
	// Decode
	set phDecoded=$system.Encryption.Base64Decode(base64)
	
	// Create Message
	set tConfigItem="ITK"
	set ret = ##class(EnsLib.HL7.Message).ImportFromString(phDecoded, .sc)
	quit ret
}

/// Converts a stream holding the Base64 represetation of a
/// Pipe and Hat message into a HL7 message
ClassMethod Base64StreamToHL7(base64 As %Stream) As EnsLib.HL7.Message
{
	// Decode
	set phDecoded = ##class(%GlobalCharacterStream).%New()
	Do base64.Rewind()
	
	While 'base64.AtEnd {
	    set ln=base64.ReadLine()
	    set lnDecoded=$system.Encryption.Base64Decode(ln)
		do phDecoded.Write(lnDecoded)
	}
	do phDecoded.Rewind()
	
	// Create Message
	set tConfigItem="ITK"
	set ret = ##class(EnsLib.HL7.Message).ImportFromLibraryStream(phDecoded, .sc)
	quit ret
}

}

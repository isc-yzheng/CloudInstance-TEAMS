Class HS.Test.IHE.DSUB.General Extends HS.Test.IHE.DSUB.Base
{

/// Clear subscriptions with each test so that there is no confusion
Method ClearSubscriptions()
{
	$$$HSTestAssertTrueOrBail(##class(Ens.Director).IsProductionRunning(),"Please start the production")
	$$$HSTestSkipUnless("core")
	&sql(delete FROM HS_IHE_DSUB_Subscriber.Subscription)
	Quit:'$$$AssertTrue(SQLCODE=0||(SQLCODE=100),"Deleted Subscriber subscriptions")
	&sql(delete FROM HS_IHE_DSUB_NotificationBroker.Subscription)
	Quit:'$$$AssertTrue(SQLCODE=0||(SQLCODE=100),"Deleted Broker subscriptions")
}

Method Test100Setup()
{
	Do:##class(HS.Data.OIDMap).GetOIDForCode($namespace)="" ##class(HS.Data.OIDMap).FileOID($NAMESPACE,"Repository","2.16.840.1.113883.3.86.3.19998")
	Set tSC = ..Setup()
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
}

/// Validates Expired subscriptions by creating a subscription which terminates immediately P0M
/// Validates ATNA logging for create / unsubscribe and notifications
/// Validates the notification is for a Minimal Subscription
Method Test110SubscribeMinimal()
{
	$$$HSTestBailout
	Do ..ClearSubscriptions()
	Set tHighAuditID = ..FindHighAuditID()
	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	/// Create Subscription (expired)
	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetDocumentPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Quit:'$$$AssertStatusOK(tRequest.SetTerminationDuration("P0M"),"Set Duration now:"_tRequest.TerminationTime)
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tRequest.Topic="M"
	Set tRequest.Type="Document"
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Set tNow=$H
	$$$HSTestAssertTrueOrBail($IsObject(tResponse),"Have response")
	$$$HSTestAssertTrueOrBail(tResponse.Errors.Errors.Count()=0,"No Errors "_tResponse.Errors.getErrorText())
	Set tSubscriptionID = tResponse.SubscriptionID
	$$$HSTestAssertTrueOrBail($$$ISOK(tSC),"Created Subscription (ID="_tSubscriptionID_")")

	/// Create Subscription 
	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetDocumentPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Quit:'$$$AssertStatusOK(tRequest.SetTerminationDuration("P7DT6H36M"),"Set Duration")
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tRequest.Topic="M"
	Set tRequest.Type="Document"
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertTrue($IsObject(tResponse),"Have response")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"No Errors "_tResponse.Errors.getErrorText())
	Set tSubscriptionID = tResponse.SubscriptionID
	Quit:'$$$AssertStatusOK(tSC,"Created Subscription (ID="_tSubscriptionID_")")
	/// Provide document and ensure notification
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provide Document")
	/// wait for notification
	Hang 2
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage")
	Quit:'$$$AssertTrue(tCount=1,"Notified of one document:"_tCount)
	/// Validate Minimal response
	Quit:'..ResponseContainsText(tStart,"ihe:MinimalDocumentEntry")

	/// Cancel subscription
	Set tCancelRequest = ##class(HS.Message.IHE.DSUB.CancelSubscriptionRequest).%New()
	Set tCancelRequest.SubscriptionID=tSubscriptionID
	Do tCancelRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tCancelRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Issued Cancel Subscription")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"No Errors "_tResponse.Errors.getErrorText())

	/// provide document, ensure there is no notification
	Do ..GetProvideMessage(.tMessage)	
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provide Document")
	Hang 2  /// wait for notification
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage") /// with tracing turned on there are trace messages for host
	Quit:'$$$AssertTrue(tCount=0,"Should be no notifications:"_tCount)

	/// Validate Audit records
	Do ..FindAuditRecords(tHighAuditID,1,"C","ITI-52",.tCount)
	Quit:'$$$AssertTrue(tCount=2,"Audit should report 2 Subscriptions for the source:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,1,"D","ITI-52",.tCount)
	Quit:'$$$AssertTrue(tCount=1,"Audit should report 1 cancel subscription for the source:"_tCount)

	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-52",.tCount)
	Quit:'$$$AssertTrue(tCount=2,"Audit should report 2 Subscriptions for the broker:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"D","ITI-52",.tCount)
	Quit:'$$$AssertTrue(tCount=1,"Audit should report 1 cancel subscription for the broker:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,1,"R","ITI-54",.tCount)
	Quit:'$$$AssertTrue(tCount=2,"Audit should report 2 publish for the publisher:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-54",.tCount)
	Quit:'$$$AssertTrue(tCount=2,"Audit should report 2 publish for the broker:"_tCount)
	/// import notification
	Set tAuditRecord = ..FindAuditRecords(tHighAuditID,0,"C","ITI-53",.tCount)
	Quit:'$$$AssertTrue(tCount=1,"Audit should report 1 Notification for the notification consumer:"_tCount)
	Quit:'$$$AssertTrue($lg(tAuditRecord.MPIIDs)=tPatient.MPIID,"Patient ID matches")

	/// export notification
	Set tAuditRecord = ..FindAuditRecords(tHighAuditID,1,"R","ITI-53",.tCount)
	Quit:'$$$AssertTrue(tCount=1,"Audit should report 1 notification for the broker:"_tCount)
	Quit:'$$$AssertTrue($lg(tAuditRecord.MPIIDs)=tPatient.MPIID,"Patient ID matches")
	
	Quit $$$OK
}

Method Test200SubscribeFull()
{
	$$$HSTestBailout
	Do ..ClearSubscriptions()
	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	/// create subscription
	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetDocumentPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Quit:'$$$AssertStatusOK(tRequest.SetTerminationDuration("P7DT6H36M"),"Set Duration")
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tRequest.Topic="F"
	Set tRequest.Type="Document"
	//Set tSC= tRequest.AddFilterValues("$XDSDocumentEntryHealthcareFacilityTypeCode","EmergencyDepartment","healthcareFacilityCodingScheme")
	Set tSC= tRequest.AddFilterValues("$XDSDocumentEntryEventCodeList","1.3.6.1.4.1.21367.2006.7.106","Connect-a-thon eventCodeList","1.3.6.1.4.1.21367.2006.7.108","Connect-a-thon eventCodeList")
	Quit:'$$$AssertStatusOK(tSC,"Added EntryHealthcareFacilityTypeCode")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Set tSubscriptionID = $S($IsObject(tResponse):tResponse.SubscriptionID,1:"")
	Quit:'$$$AssertStatusOK(tSC,"Created Subscription (ID="_tSubscriptionID_")")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"No Errors "_tResponse.Errors.getErrorText())

	/// Submit document and ensure we are *NOT* notified (doesn't match filter).  Order is important so that tStart has correct value for Cancel check
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	$$$HSLogSessionID
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provide Document.  Last notification:"_tStart)
	/// wait for notification
	Hang 2
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage")
	Quit:'$$$AssertTrue(tCount=0,"Not notified document.  Count:"_tCount_".  New tStart:"_tStart )

	/// Submit document and ensure we are notified.  Order is important so that tStart has correct value for Cancel check
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	/// insert item we are filtering on
	Do tMessage.Documents.GetAt(1).EventCodeList.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("1.3.6.1.4.1.21367.2006.7.106","Connect-a-thon eventCodeList","OPT-OUT"))
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provide Document.  Last notification:"_tStart)
	/// wait for notification
	Hang 2
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage")
	Quit:'$$$AssertTrue(tCount=1,"Notified of one document.  Count:"_tCount_".  New tStart:"_tStart )
	/// Validate Full response
	Quit:'..ResponseContainsText(tStart,"ihe:FullDocumentEntry")

	/// Cancel Request
	Set tCancelRequest = ##class(HS.Message.IHE.DSUB.CancelSubscriptionRequest).%New()
	Set tCancelRequest.SubscriptionID=tSubscriptionID
	Do tCancelRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tCancelRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Issued Cancel Subscription")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"No Errors "_tResponse.Errors.getErrorText())
	
	/// provide document, ensure there is no notification
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provide Document")
	Hang 2  /// wait for notification
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage")
	Quit:'$$$AssertTrue(tCount=0,"Should be no notifications")
	Quit $$$OK
}

/// We are required to report an error when folder subscriptions arrive and we don't support them
Method Test300SubscribeUnsupportedFolder()
{
	$$$HSTestBailout
	Do ..ClearSubscriptions()
	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetDocumentPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Quit:'$$$AssertStatusOK(tRequest.SetTerminationDuration("P7DT6H36M"),"Set Duration")
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tRequest.Topic="M"
	Set tRequest.Type="Folder"
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()'=0,"Errors")
	Quit:'$$$AssertTrue(tResponse.Errors.getErrorText()["TopicNotSupportedFault","Folder not supported")
}

/// Test subscriptions by submission set
Method Test400SubscribeSubmissionSet()
{
	$$$HSTestBailout
	Do ..ClearSubscriptions()
	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")

	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetSubmissionPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Set tRequest.Type="Submission"
	Set tRequest.Topic="S"
	Quit:'$$$AssertStatusOK(tRequest.SetTerminationDuration("P7DT6H36M"),"Set Duration")
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"No Errors")
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	/// Creating document 1
	$$$HSLogSessionID
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provided Document.  Last notification:"_tStart)
	For tIdx = 1:1:5 { Set tNewStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage") Quit:tCount  Hang .5}
	Quit:'$$$AssertTrue(tCount=1,"Notification expected  Count:"_tCount_".  New tStart:"_tNewStart )
	Set tStart=tNewStart
	Quit:'..ResponseContainsText(tStart,"ihe:SubmissionSetMetadata")

	Do ..ClearSubscriptions()
	Set tSC= tRequest.AddFilterValues("$XDSSubmissionSetSourceId","1.3.6.1.4.1.21367.2010.1.2.300",,"1.3.6.1.4.1.21367.2010.1.2.310")
	Quit:'$$$AssertStatusOK(tSC,"Added SubmissionSet SourceId")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"No Errors")
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	/// Creating document 2
	$$$HSLogSessionID
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provided Document.  Last notification:"_tStart)
	For tIdx = 1:1:5 { Set tNewStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage") Quit:tCount  Hang .5}
	Quit:'$$$AssertTrue(tCount=1,"Notification expected  Count:"_tCount_".  New tStart:"_tNewStart )
	Set tStart=tNewStart
	Quit:'..ResponseContainsText(tStart,"ihe:SubmissionSetMetadata")
}

Method Test410SubmissionSetAuthor()
{
	$$$HSTestBailout
	Do $$$LogMessage("Clear subscriptions") 
	Do ..ClearSubscriptions()

	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")

	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetSubmissionPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Set tRequest.Type="Submission"
	Set tRequest.Topic="S"
	Set tSC= tRequest.AddFilterValues("$XDSSubmissionSetAuthorPerson","%Welby%")
	Quit:'$$$AssertStatusOK(tSC,"Added SubmissionSet Author")
	Quit:'$$$AssertStatusOK(tRequest.SetTerminationDuration("P7DT6H36M"),"Set Duration")
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"No Errors")
	If tResponse.Errors.Errors.Count() {
		Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"No Errors:"_tResponse.Errors.Errors.GetAt(1).Description)	
	}
	
	/// get document
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	/// Creating document 1
	$$$HSLogSessionID
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provided Document.  Last notification:"_tStart)
	For tIdx = 1:1:5 { Set tNewStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage") Quit:tCount  Hang .5}
	Quit:'$$$AssertTrue(tCount=1,"Notification expected  Count:"_tCount_".  New tStart:"_tNewStart )
	Set tStart=tNewStart
	Quit:'..ResponseContainsText(tStart,"ihe:SubmissionSetMetadata")

	/// clear out subscriptions
}

Method Test420SubmissionSetIntendedRecipient()
{
	$$$HSTestBailout
	Do $$$LogMessage("Clear subscriptions") 
	Do ..ClearSubscriptions()

	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")

	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetSubmissionPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Set tRequest.Type="Submission"
	Set tRequest.Topic="S"
	Set tSC= tRequest.AddFilterValues("$XDSSubmissionSetIntendedRecipient","%|^Welby%")
	Quit:'$$$AssertStatusOK(tSC,"Added SubmissionSet IntendedRecipient")
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"No Errors")
	#dim tMessage as HS.Message.IHE.XDSb.ProvideAndRegisterRequest
	Do ..GetProvideMessage(.tMessage)
	Set tIntendedRecipient = ##class(HS.IHE.XDSb.Types.Slot).%New()
	Set tIntendedRecipient.Name = "$XDSSubmissionSetIntendedRecipient"
	Do tMessage.IntendedRecipient.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Some Hospital^^^^^^^^^1.2.3.9.1789.45|^Peirre^LaPointe^^^Dr^MD"))
	Do tMessage.IntendedRecipient.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Some Hospital^^^^^^^^^1.2.3.9.1789.45|^Welby^Marcus^^^Dr^MD|^^Internet^mwel@healthca re.example.org"))
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	/// Creating document 3
	$$$HSLogSessionID
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provided Document.  Last notification:"_tStart)
	For tIdx = 1:1:5 { Set tNewStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage") Quit:tCount  Hang .5}
	Quit:'$$$AssertTrue(tCount=1,"Notification expected  Count:"_tCount_".  New tStart:"_tNewStart )
	Set tStart=tNewStart
	Quit:'..ResponseContainsText(tStart,"ihe:SubmissionSetMetadata")
}

Method Test430NotMatchingSubmissionSetIntendedRecipient()
{
	$$$HSTestBailout
	Do $$$LogMessage("Clear subscriptions") 
	Do ..ClearSubscriptions()

	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")

	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetSubmissionPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Set tRequest.Type="Submission"
	Set tRequest.Topic="S"
	Set tSC= tRequest.AddFilterValues("$XDSSubmissionSetIntendedRecipient","%|^WestCoast%")
	Quit:'$$$AssertStatusOK(tSC,"Added SubmissionSet IntendedRecipient")
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"No Errors")
	#dim tMessage as HS.Message.IHE.XDSb.ProvideAndRegisterRequest
	Do ..GetProvideMessage(.tMessage)
	Set tIntendedRecipient = ##class(HS.IHE.XDSb.Types.Slot).%New()
	Set tIntendedRecipient.Name = "$XDSSubmissionSetIntendedRecipient"
	Do tMessage.IntendedRecipient.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Some Hospital^^^^^^^^^1.2.3.9.1789.45|^Peirre^LaPointe^^^Dr^MD"))
	Do tMessage.IntendedRecipient.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Some Hospital^^^^^^^^^1.2.3.9.1789.45|^Welby^Marcus^^^Dr^MD|^^Internet^mwel@healthca re.example.org"))
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	/// Creating document 3
	$$$HSLogSessionID
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provided Document.  Last notification:"_tStart)
	For tIdx = 1:1:5 { Set tNewStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage") Quit:tCount  Hang .5}
	Quit:'$$$AssertTrue(tCount=0,"Notification expected  Count:"_tCount_".  New tStart:"_tNewStart )
	Set tStart=tNewStart
}

Method Test500ReferenceIdList()
{
	$$$HSTestBailout
	Do $$$LogMessage("Clear subscriptions") 
	Do ..ClearSubscriptions()

	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")

	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetSubmissionPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	Set tRequest.Type="Document"
	Set tRequest.Topic="M"
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
 	// create referenceIdList slot entry to insert into the subscription
	Set tFilterItem = ##class(HS.Types.IHE.DSUB.SubscriptionItems).%New()
	Set tFilterItem.Item="$XDSDocumentEntryReferenceIdList"
	Do tFilterItem.Values.Insert("NOMATCHBEFORE^^^&"_$$$AffinityDomainOID_"&ISO^urn:ihe:iti:xds:2013:accession")
 	Set tRefIdSlotValue = ##class(HS.Util.XSLTHelper).createUUID()_"^^^&"_$$$AffinityDomainOID_"&ISO^urn:ihe:iti:xds:2013:accession"
	Do tFilterItem.Values.Insert(tRefIdSlotValue)
	Do tFilterItem.Values.Insert("NOMATCHAFTER^^^&"_$$$AffinityDomainOID_"&ISO^urn:ihe:iti:xds:2013:accession")
	Do tRequest.FilterItems.Insert(tFilterItem)
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"No Errors")
	/// get document
	Do ..GetProvideMessage(.tMessage)
 	Set tRefIdSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
 	Set tRefIdSlot.Name="urn:ihe:iti:xds:2013:referenceIdList"
 	 do tRefIdSlot.ValueList.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tRefIdSlotValue))
	Do tMessage.Documents.GetAt(1).DocumentSlots.Insert(tRefIdSlot)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	/// Creating document 1
	$$$HSLogSessionID
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provided Document.  Last notification:"_tStart)
	For tIdx = 1:1:5 { Set tNewStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage") Quit:tCount  Hang .5}
	Quit:'$$$AssertTrue(tCount=1,"Notification expected  Count:"_tCount_".  New tStart:"_tNewStart )
}

Method Test510SubscribeWithTimezone()
{
	$$$HSTestBailout
	Do ..ClearSubscriptions()
	Set tHighAuditID = ..FindHighAuditID()
	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Quit:'$$$AssertStatusOK(tSC,"Created Patient "_$s($isObject($g(tPatient)):tPatient.MPPID,1:""))

	/// Create Subscription (expired)
	Set tRequest = ##class(HS.Message.IHE.DSUB.SubscriptionRequest).%New()
	Do tRequest.SetDocumentPatientId(tPatient.MPIID,$$$AffinityDomainOID)
	/// set expiration time to be 1 hour from now
	Set tRequest.TerminationTime=$Extract($zdt($h,3,7),1,*-1)_"-01:00"
	Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.DSUB.NotificationConsumer","SOAP")
	Set tRequest.RecipientAddress=tServiceObject.EndPoint
	Do tRequest.AdditionalInfo.SetAt(..#DSUBSubscriber,"Host")
	Do tRequest.AdditionalInfo.SetAt(..#BrokerServiceName,"ServiceName")
	Set tRequest.Topic="M"
	Set tRequest.Type="Document"
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Set tNow=$H
	$$$HSTestAssertTrueOrBail($IsObject(tResponse),"Have response")
	$$$HSTestAssertTrueOrBail(tResponse.Errors.Errors.Count()=0,"No Errors "_tResponse.Errors.getErrorText())
	Set tSubscriptionID = tResponse.SubscriptionID
	$$$HSTestAssertTrueOrBail($$$ISOK(tSC),"Created Subscription (ID="_tSubscriptionID_")")

	Quit:'$$$AssertStatusOK(tRequest.SetTerminationDuration("PT5S"),"Set Duration:"_tRequest.TerminationTime)
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Set tNow=$H
	$$$HSTestAssertTrueOrBail($IsObject(tResponse),"Have response")
	$$$HSTestAssertTrueOrBail(tResponse.Errors.Errors.Count()=0,"No Errors "_tResponse.Errors.getErrorText())
	Set tSubscriptionID = tResponse.SubscriptionID
	$$$HSTestAssertTrueOrBail(tResponse.TerminationTime = tRequest.TerminationTime,"Termination time matches:"_tResponse.TerminationTime)
	$$$HSTestAssertTrueOrBail($$$ISOK(tSC),"Created Subscription (ID="_tSubscriptionID_")")

	/// Provide document and ensure notification
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provide Document")
	/// wait for notification
	Hang 2
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage")
	Quit:'$$$AssertTrue(tCount=2,"Notified of two documents:"_tCount)
	/// Validate Minimal response
	Quit:'..ResponseContainsText(tStart,"ihe:MinimalDocumentEntry")

	Hang 4
	/// Provide document and ensure notification
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services")
	Do ..GetProvideMessage(.tMessage)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC=##class(HS.Test.Service).SendSync(tMessage,.tProvideResponse)
	Quit:'$$$AssertStatusOK(tSC,"Provide Document")
	/// wait for notification
	Hang 2
	Set tStart=..MessagesForItem("HS.Generated.Test.IHE.DSUB.NotificationConsumer.Services",tStart,.tCount,"HS.Message.XMLMessage")
	Quit:'$$$AssertTrue(tCount=1,"Notified of one document:"_tCount)
	/// Validate Minimal response
	Quit:'..ResponseContainsText(tStart,"ihe:MinimalDocumentEntry")
}

Method GetProvideMessage(Output pMessage As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, pPatient, pDocumentText As %String = "", pDocumentXData = "")
{
	Do ..GetMessage(.pMessage)
	Set tSC = ..GetOrCreatePatient("xdata://HS.Test.Data.Patients:NFDSUB",.tPatient)
	Set pMessage.PatientId=tPatient.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	Do ..GetDocument(.tDocument,.pMessage)
	Do pMessage.Author.Insert(tDocument.Author.GetAt(1))
	Do pMessage.Documents.Insert(tDocument)
	Quit
}

Method GetMessage(Output pMessage As HS.Message.IHE.XDSb.ProvideAndRegisterRequest)
{
	Set pMessage=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set pMessage.SourceId=##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")
	Set pMessage.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Quit
}

Method GetDocument(Output pDocument As HS.Message.IHE.XDSb.Document, pMessage As HS.Message.IHE.XDSb.ProvideAndRegisterRequest)
{
	Set pDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do pDocument.BodyCharacter.Write("Simple DSUB Document "_$zdt($h,8))
	Set pDocument.Hash=$zcvt(##class(HS.IHE.XDSb.Util).StreamHash(pDocument.BodyCharacter),"U")
	set author = ##class(HS.Types.IHE.XDSb.Author).%New()
	Set author.EntryUUID="MyAuthor"
    set author.AuthorPerson = "^Welby^Marcus^^MD^Dr"
	Do author.AuthorInstitution.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New("Some Hospital^^^^^^^^^1.2.3.5.8.9.1789.45"))
	Set tSC= pDocument.Author.Insert(author)
 	Do pDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))

	Set pDocument.CreationTime=$TR($zdt($h,8),": ")
	Set pDocument.CreationTime="20110510102615"
	Set pDocument.LanguageCode="en-US"
	Set pDocument.SourcePatientId="4ee29b626a8d4c4^^^&"_pMessage.SourceId_"&ISO"
	
	
	///
	d pDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-3|4ee29b626a8d4c4^^^&"_pMessage.SourceId_"&ISO"))
	d pDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-5|Vargas^Josiah^"))
	d pDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|19810109"))
	d pDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-8|M"))
	d pDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-11|123 Main St^^Rosemont^Il^60018"))

	Set pDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set pDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","HITSP","HL7 CCD Document")
	Set pDocument.MimeType="text/xml"
	Set pDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set pDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set pDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	Quit
}

}

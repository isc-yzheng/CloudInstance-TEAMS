ROUTINE HS.HC.BaseHost [Type=INC]
#; handling custom code in business hosts
#def1Arg OnPre(%args) Set tSC = ..InvokeCustom("OnPre"_$$$CurrentMethod,%args) $$$ThrowOnError(tSC)
#def1Arg OnPost(%args) Set tSC = ..InvokeCustom("OnPost"_$$$CurrentMethod,%args) $$$ThrowOnError(tSC)

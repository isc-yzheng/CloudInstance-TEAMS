Include HS.HC.TraceHelper

Class HS.HC.Util.Trace.Helper [ Abstract ]
{

Parameter SETTINGS As %String = "TraceOperations:Dev:selector?Select=1&context={HS.Util.ContextSearch/TraceValues}";

/// If this setting is not blank, then the system will expect there to be an operation named "HS.Util.Trace.Operations",
/// and it will direct trace messages to this operation.
Property TraceOperations As %String;

Method HSTrace(pCurrentClass, pMethod, pArgList...)
{
	Set tRequest=##Class(HS.Util.Trace.Request).%New()
	Set tRequest.CurrentClass=pCurrentClass
	Set tRequest.CurrentMethod=pMethod
	Set tRequest.Comment=pArgList(1)
	New %HSBlobMode Set %HSBlobMode="HSTrace" //to prevent the trace from attempting to output giant blobs
	#; Build variable tMaxStringLength as $$$MaxStringLength-2500 to give 2500 byte overhead for other properties
	Set tMaxStringLength = $$$MaxStringLength-2500
	
	If pArgList>2 {
		Set tName=pArgList(2)
		For tI=3:1:pArgList
		{
			Set tVal=$G(pArgList(tI))
			Set tItem=##Class(HS.Util.Trace.Item).%New()
			Set tItem.ItemName=$P(tName,",",tI - 2)
			If $IsObject(tVal) {
				#; Export object to a stream
				Set tSC=$$$OK
				Set tStream = ##class(%GlobalCharacterStream).%New()
				If tVal.%Extends("HS.SDA.QuickXML")||(tVal.%Extends("HS.SDA3.QuickXML")) {
					Set tSC = tVal.ToQuickXMLStream(.tStream,$P(tVal,".",$L(tVal,".")))
				} 
				ElseIf tVal.%Extends("%XML.Adaptor") {
					Set tSC = tVal.XMLExportToStream(.tStream)  
				}
				Elseif tVal.%Extends("%Stream.Object") {
					Do tStream.Write("<![CDATA[")
					Set tSC = tStream.CopyFrom(tVal)
					Do tStream.Write("]]>")
					Do tVal.Rewind()
				}
				
				#; Populate .ItemValue or .ItemStream depending on exported XML length
				#; If XMLExport failed, the error text will be put into the item value
				Set tItem.ItemClass=tVal
				If $$$ISERR(tSC) {
					#; XML encode error text to be safe (i.e. a <STORE> error)
					Set tItem.ItemValue = $ZCVT($SYSTEM.Status.GetErrorText(tSC),"O","XML")
				}
				// Using StringLength property which is $$$MaxStringLength-2500 to give 2500 bytes of overhead for other properties
				ElseIf tStream.Size < tMaxStringLength {
					Do tStream.Rewind()
					Set tItem.ItemValue=tStream.Read(tMaxStringLength)
				} 
				Else {
					Set tItem.ItemStream=tStream
				}

			}
			Else {
				#; Native data value
				If tItem.ItemName="tSC" Set tVal=$S(tVal=1:1,1:$SYSTEM.Status.GetErrorText(tVal))
				Set tItem.ItemValue=$zcvt(tVal,"O","XML")
			}
			Do tRequest.Items.Insert(tItem)
			Set tMaxStringLength=tMaxStringLength-$l(tItem.ItemValue)
		}
	}
	if $this.%IsA("Ens.BusinessProcess") {
		Set tSC = ..SendRequestAsync("HS.Util.Trace.Operations",tRequest,0)
	} Else {
		Set tSC = ..SendRequestAsync("HS.Util.Trace.Operations",tRequest)
	}
}

}

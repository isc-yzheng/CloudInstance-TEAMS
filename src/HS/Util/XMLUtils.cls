/// XML Utility code
Class HS.Util.XMLUtils
{

ClassMethod Digger(tree As %String, node As %Integer, context As %String, get As %String, ByRef results)
{
	If context'="" {
		// First, break the context down
		Set l = $L(context,"/")
		For i=1:1:l {
			Set p = $P(context,"/",i)
			Set n = $P(p,"[")
			Set c = $P($P(p,"[",2),"]")
			
			// Find matching items in the tree
			Set e="" For {
				Set e=$O(@tree@(node,"c",e))
				
				Quit:e=""
				Continue:@tree@(node,"c",e)'="e"
				Continue:@tree@(e)'=n
	
				If c'="" {
					// Condition check
					Set cn = ..findChild(tree,e,$P(c,"="))
					Continue:cn=""
					Continue:@tree@(cn)'=$P(c,"=",2)
				}
				
				If i=l {
					Do ..matches(tree,e,get,.results)
				} Else {
					// move on to the next level of the context
					Set node=e
					Quit
				}
			}
		}
	} Else {
		// Just process the matches
		Do ..matches(tree,node,get,.results)
	}
}

ClassMethod matches(tree, node, get, ByRef results)
{
	// We have a match ... now dig out the 'get' values
	For j=1:1:$L(get,",") {
		Set ge = $P(get,",",j)
		Set cn = ..findChild(tree,node,ge)
		Continue:cn=""
		
		Set results(node,ge)=@tree@(cn)
	}
}

/// [Previously private]
ClassMethod findChild(t, n, v) As %Integer [ Final, Internal ]
{
	Set e="",q="",v2=""
	Set:v["/" v2=$P(v,"/",2,$L(v,"/")),v=$P(v,"/")
	Do {
		Set e=$O(@t@(n,"c",e))
		Quit:e=""
		Continue:@t@(n,"c",e)'="e"
		Continue:@t@(e)'=v
		
		If v2'="" {
			Set q=..findChild(t,e,v2)
		} Else {
			Set q=$O(@t@(e,"c",""))
		}
		
	} While (q="")
	
	Quit q
}

/// Make substitions on {$method{}} and {$expression{}} calls - limited to string size
ClassMethod GetXDataAsStreamWithSubstitutions(pXData, ByRef pStream) As %Status
{
	If pXData'[":" Set pXData="xdata://"_$classname()_":"_pXData
	Set tSC = ##class(Ens.Util.URLStream).GetURLStream(pXData,.tStream) 
	If $$$ISERR(tSC) Quit tSC
	New %expression,%value
	Do tStream.Rewind()
	Set tString=tStream.Read(30000000000)
	For  {
		Set tPos=$f(tString,"{$expression{")
		Quit:'tPos
		Set tPosEnd=$f(tString,"}}",tPos)
		Quit:'tPosEnd
		Set %expression=$e(tString,tPos,tPosEnd-3)
		X "Set %value="_%expression
		Set tString=$e(tString,1,tPos-14)_%value_$e(tString,tPosEnd,*)
	}
	For  {
		Set tPos=$f(tString,"{$method{")
		Quit:'tPos
		Set tPosEnd=$f(tString,"}}",tPos)
		Quit:'tPosEnd
		Set %expression=$e(tString,tPos,tPosEnd-3)
		X "Set %value="_%expression
		Set tString=$e(tString,1,tPos-10)_%value_$e(tString,tPosEnd,*)
	}
	Set pStream=##class(%Stream.GlobalCharacter).%New()
	Do pStream.Write(tString),pStream.Rewind()
	Quit tSC
}

}

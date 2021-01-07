/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7.Annotation

Class EnsLib.HL7.Annotation.EnterData Extends %CSP.Page [ System = 4 ]
{

Parameter DOMAIN = "Ensemble";

Parameter SECURITYRESOURCE = "%Ens_EDISchemaAnnotations:WRITE";

ClassMethod OnPage() As %Status
{
	Set version=$G(%request.Data("version",1),"2.5")
	Set type=$G(%request.Data("type",1),"MG")
	Set item=$G(%request.Data("item",1))
	#dim annot As EnsLib.HL7.Annotation.Data
	Set annot=##Class(EnsLib.HL7.Annotation.Data).%New(version)
	Set basever=annot.GetBase()
	Set tStyle = ##class(%CSP.Page).Link("/csp/sys/intersystems.css")

	&html<<html>
<head> <link rel="stylesheet" type="text/css" href="#(tStyle)#">
<style type="text/css">
h1 { font-size: 1.6em }
td.usage {text-align: center}
textarea.note {font-style: italic ;background-color: white font-family: monospace}
textarea.xnote {font-style: italic ;background-color: AliceBlue}
input.annot {font-style: italic ; font-family: monospace}
input.xannot {font-style: italic ;background-color: AliceBlue ; font-family: monospace}
select {font-style: italic ;background-color: white}
body {background-color: AliceBlue	}
</style>
</head>
<body>>
	W "<form name='ver' method='post' action='EnsLib.HL7.Annotation.EnterDataSave.cls?version=",version,"&amp;type="_type_"&amp;item="_item,"'><br>"
	W "<input type='SUBMIT' name='Save' value='",$$$TextHTML("(S)ave Changes"),"' accesskey='S'>"
	W "&nbsp;&nbsp;<INPUT TYPE='button' VALUE='",$$$TextHTML("Cancel"),"' onClick='history.go(-1)'>"
	IF type="MG" {
		DO annot.LoadMG(.mgs)
		Set mg=""
		Write "<br><br>"
		W "<table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Message Groups"),"</h1></caption>"
		W "<tr align='left'><th>",$$$TextHTML("Group"),"</th><th>",$$$TextHTML("Description"),"</th><th>",$$$TextHTML("Usage"),"</th></tr>"
		FOR  {
			Set mg=$O(mgs(mg)) Q:mg=""
			W "<tr>",$$wtd(mg),$$wtd(mgs(mg,"Name"),700) DO usage(mgs(mg,"U"),mg) W "</tr>"
			DO notes(mgs(mg,"Note"),1,2,mgs(mg,"U"),mg)
		}
		Write "</table><br><br>"
	}
	ElseIF type="MT" {
		Write "<br><br>"
		W "<table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Message Types"),"</h1></caption>"
		W "<tr align='left'><th>",$$$TextHTML("Event"),"</th><th>",$$$TextHTML("Structure"),"</th><th>",$$$TextHTML("Description"),"</th>",$$uheads,"</tr>"
		DO annot.LoadMT(item,.mts) Set mt=""
		FOR {
			Set mt=$O(mts(mt)) Q:mt=""
			W "<tr>",$$wtd(mt),$$wtd($S(mts(mt,"MS")["_":"-"_$P(mts(mt,"MS"),"_",2,9),1:mts(mt,"MS")))
			W $$wtd(mts(mt,"Name"),600) DO usage(mts(mt,"U"),mt) W $$wusage(mts(mt,"UC")),"</tr>"
			DO notes(mts(mt,"Note"),1,4,mts(mt,"U"),mt)
		}
		Write "</table>"
	}
	ElseIF type="MS" {
		Do annot.LoadMS(item,.segs)
		W "<br><br><table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Message Structure"),"  ",item ,"</h1></caption>"
		W "<tr><th>&nbsp;</th><th width=700>",annot.GetName("MS",item),"</th>",$$uheads,"</tr>"
		FOR i=1:1:segs {
			W "<tr><td>"
			W $$nbsp($J("",($L(segs(i,"Path"),",")-1)*3)_segs(i,"Code")) W "</td>"
			W $$wtd($S(segs(i,"Type")'="SEG":"--- ",1:"")_segs(i,"Name")_$S(segs(i,"Type")="GRP":" begin",segs(i,"Type")="END":" end",1:""),700)
			IF segs(i,"Type")="END" {W "</tr>"}
			ELSE {
				DO usage(segs(i,"U"),i) W $$wusage(segs(i,"UC")) W "</tr>"
				DO notes(segs(i,"Note"),1,3,segs(i,"U"),i)
			}
		}
		W "</table>"
	}
	ElseIF type="SS" {
		W "<br><br><table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Segment Structure"),"  ",item,"<br>",annot.GetName("SS",item),"</h1></caption>"
		W "<tr><th>",$$$TextHTML("Seq"),"</th><th>",$$$TextHTML("Description"),"</th>",$$uheads
		#if $$$EnsHSManage
			W "<th>HSPriority</th>"
		#endif

		W "<th>",$$$TextHTML("Code"),"<br>",$$$TextHTML("Table"),"</th><th>",$$$TextHTML("Data"),"<br>",$$$TextHTML("Struct"),"</th><th>",$$$TextHTML("Len"),"</th><th>",$$$TextHTML("HL7"),"<br>",$$$TextHTML("Req"),"</th><th>",$$$TextHTML("HL7"),"<br>",$$$TextHTML("Rpt"),"</th></tr>"
		Do annot.LoadSS(item,.flds)
		For i=1:1:flds {
			W "<tr>"
			Set u=flds(i,"U")
			W $$wtd(i),$$wtd(flds(i,"Name"),500) DO usage(u,i)
			W $$wusage(flds(i,"UC"))
			#if $$$EnsHSManage
				W "<td><input type='text' class='"_$S(u="P":"",1:"x")_"annot' name='HSPRI@"_i_"' size=10 value='"_$G(flds(i,"HSPRI"))_"' onChange=""this.style.color='red'""/></td>"
			#endif
			W $$wtd(flds(i,"CT")) IF flds(i,"DS")="" {W $$wtd("")}
			Else {W $$wtd(flds(i,"DS"))}
			W $$wtd(flds(i,"Len")),$$wtd(flds(i,"Req")),$$wtd(flds(i,"Rpt")),"</tr>"
			#if $$$EnsHSManage
				DO notes(flds(i,"Note"),1,9,u,i)
			#else
				DO notes(flds(i,"Note"),1,8,u,i)
			#endif
			//W "</tr>" DO notes(flds(i,"Note"),1,8,u,i)
		}
		W "</table>"
	}
	ElseIF type="DS" {
	Set ds=""
		W "<br><br><table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Data Structure"),"  ",basever,":",item ," - ",annot.GetName("DS",item),"</h1></caption>"
		W "<tr><th>",$$$TextHTML("Seq"),"</th><th>",$$$TextHTML("Description"),"</th>",$$uheads,"<th>",$$$TextHTML("Code"),"<br>",$$$TextHTML("Table"),"</th><th>",$$$TextHTML("Data"),"<br>",$$$TextHTML("Struct"),"</th></tr>"
		Do annot.LoadDS(item,.flds)
		For i=1:1:flds {
			W "<tr>"
			Set u=flds(i,"U")
			W $$wtd(i),$$wtd(flds(i,"Name"),500) DO usage(u,i)
			W $$wusage(flds(i,"UC")),$$wtd(flds(i,"CT")) IF flds(i,"DS")="" {W $$wtd("")}
			Else {W $$wtd(flds(i,"DS"))}
			W "</tr>" DO notes(flds(i,"Note"),1,6,u,i)
		}
		W "</table>"
	}
	W "</form>"
	&html<</body>
</html>>
	Quit $$$OK
	
notes(note,span1,span2,uu,saveindex)
	W !,"<tr>",$$wtd("","",span1),"<td "
	W " colspan='",span2,"'><Table class='notelabel'><tr><td>Notes:</td><td><textarea name='note@"_saveindex_"' rows='"
	IF uu="X" {w "1' class='xnote'" }
	ELSE {W $L(note)\77++$L(note,$C(13,10))+1,"' class='note'" }
	W " cols='77' onChange=""this.style.color='red'"">",$ZCVT(note,"O","HTML"),"</textarea></td></tr>"
	W "</table></td></tr>" QUIT

uheads()
	QUIT "<th>"_$$$TextHTML("Explicit")_"<br>"_$$$TextHTML("Usage")_"</th><th>"_$$$TextHTML("Implicit")_"<br>"_$$$TextHTML("Usage")_"</th>"

usage(us,saveindex)
	W "<td><select name='usage@",saveindex,"' onChange=""this.style.color='red'"">"
	FOR uoption="S","P","X" {
		W "<option value=",uoption W:us=uoption " selected"
		W ">",$S(uoption="S":$$$TextHTML("Today"),uoption="P":$$$TextHTML("Planned"),1:$$$TextHTML("Not Used")),"</option>"
	}
	W "</select></td>" QUIT

wusage(us)
	QUIT $$wtd($S(us="S":$$$TextHTML("Today"),us="P":$$$TextHTML("Planned"),1:$$$TextHTML("Not Used")),"","","usage")

wtd(xx,wid="",colspan="", class="")
	QUIT "<td"_$s(class'="": " class='"_class_"'",1:"")_$s(wid'="":" width='"_wid_"'",1:"")_$s(colspan'="":" colspan="_colspan,1:"")_">"_$S(xx="":"&nbsp;",1:$ZCVT(xx,"O","HTML"))_"</td>"
	
nbsp(yy)
	WHILE yy[" " { Set yy=$P(yy," ")_"&nbsp;"_$P(yy," ",2,999) }
	QUIT yy
}

}

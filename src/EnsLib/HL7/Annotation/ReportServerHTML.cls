/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7.Annotation

Class EnsLib.HL7.Annotation.ReportServerHTML Extends %CSP.Page [ System = 4 ]
{

Parameter DOMAIN = "Ensemble";

Parameter SECURITYRESOURCE = "%Ens_EDISchemaAnnotations:READ";

ClassMethod OnPage() As %Status
{
	Set version=$G(%request.Data("version",1),"2.5")
	Set planned=$G(%request.Data("planned",1),1),psup="S" S:planned psup="SP"
	#dim annot As EnsLib.HL7.Annotation.Data
	Set annot=##Class(EnsLib.HL7.Annotation.Data).%New(version)
	Set basever=annot.GetBase()

	&html<<html>
<head> <style type="text/css">
td.usage {text-align: center}
td.note {font-style: italic}
td.annotl {width: 100px}
td.annot {font-family: monospace ; font-size: x-small ; width: 800px}
textarea {overflow: hidden ; border: 0 ; font-family: monospace ; font-size: x-small}
</style>
</head>
<body>>
	DO annot.LoadMG(.mgs)
	Set mg=""
	Write "<br><center><h1> -  ",$$$TextHTML("HL7 Version")," ",version," ",$$$TextHTML("support"),"  - </center><br><br>"
	W "<table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Message Types"),"</h1></caption>"
	W "<tr align='left'><th>",$$$TextHTML("Group"),"</th><th>",$$$TextHTML("Event"),"</th><th>",$$$TextHTML("Structure"),"</th><th>",$$$TextHTML("Description"),"</th><th>",$$$TextHTML("Usage"),"</th></tr>"
	FOR  {
		Set mg=$O(mgs(mg)) Q:mg=""
		IF psup'[mgs(mg,"U") Continue
		W "<tr>",$$wtd(mg),$$wtd(mgs(mg,"Name"),700,3),$$usage(mgs(mg,"U")),"</tr>"
		DO notes(mgs(mg,"Note"),2,3)
		DO annot.LoadMT(mg,.mts) Set mt=""
		FOR {
			Set mt=$O(mts(mt)) Q:mt=""
			IF psup'[mts(mt,"UC") Continue
			W "<tr>",$$wtd(""),$$wtd(mt),$$wtd($S(mts(mt,"MS")["_":"-"_$P(mts(mt,"MS"),"_",2,9),1:mts(mt,"MS"))),$$wtd(mts(mt,"Name"),700),$$usage(mts(mt,"UC")),"</tr>"
			DO notes(mts(mt,"Note"),3,2)
		}
	}
	Write "</table><br><br>"
	Write "<h2> HL7 Message Structure Legend: [] means optional, {} means repeating</h2>"
	Set ms="" DO annot.GetType(planned,"MS",.items)
	FOR  {
		Set ms=$O(items(ms),1,usage) Q:ms=""
		Do annot.LoadMS(ms,.segs)
		W "<br><br><table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Message Structure"),"  ",ms,"<br>",annot.GetName("MS",ms) W:usage="P" "  (",$$$TextHTML("planned"),")" W "</h1></caption>"
		W "<tr><th>&nbsp;</th><th width=700>",annot.GetName("MS",ms),"</th><th>",$$$TextHTML("Usage"),"</th></tr>"
		FOR i=1:1:segs {
			IF psup'[segs(i,"UC") CONTINUE
			W "<tr><td>",$$nbsp($J("",($L(segs(i,"Path"),",")-1)*3)_segs(i,"Code")),"</td>"
			W $$wtd($S(segs(i,"Type")'="SEG":"--- ",1:"")_segs(i,"Name")_$S(segs(i,"Type")="GRP":" begin",segs(i,"Type")="END":" end",1:""),700)
			W $$usage($G(segs(i,"UC"))) DO notes(segs(i,"Note"),1,2)
			W "</tr>"
		}
	W "</table>"
	}
	Set ss="" DO annot.GetType(planned,"SS",.items)
	FOR  {
		Set ss=$O(items(ss),1,usage) Q:ss=""
		W "<br><br><table border=4 cellspacing=0 cellpadding=4><caption><h1>",$$$TextHTML("Segment Structure"),"  ",ss_" - "_annot.GetName("SS",ss) W:usage="P" "  (",$$$TextHTML("planned"),")" W "</h1></caption>"
		W "<tr><th>",$$$TextHTML("Seq"),"</th><th>",$$$TextHTML("Description"),"</th><th>",$$$TextHTML("Usage"),"</th>"
		#if $$$EnsHSManage
			W "<th>HSPriority</th>"
		#endif

		W "<th>",$$$TextHTML("Code"),"<br>",$$$TextHTML("Table"),"</th><th>",$$$TextHTML("Data"),"<br>",$$$TextHTML("Struct"),"</th><th>",$$$TextHTML("Len"),"</th><th>",$$$TextHTML("HL7"),"<br>",$$$TextHTML("Required"),"</th><th>",$$$TextHTML("HL7"),"<br>",$$$TextHTML("Rpt"),"</th></tr>"
		Do annot.LoadSS(ss,.flds)
		For i=1:1:flds {
			W "<tr>"
			Set u=flds(i,"UC") Set:(usage="P")&(u="S") u="P" //field usage can't be better than segment usage
			IF psup'[u CONTINUE
			W $$wtd(i),$$wtd(flds(i,"Name"),500),$$usage(u)
			#if $$$EnsHSManage
				W $$wtd($g(flds(i,"HSPRI")))
			#endif
			S x=flds(i,"Req"),x=$S(x="R":"Required",x="O":"Optional",x="C":"Conditional",x="B":"Backwards Compatible",1:x)
			W $$wtd(flds(i,"CT")),$$wtd(flds(i,"DS")),$$wtd(flds(i,"Len")),$$wtd(x,100,,"usage"),$$wtd(flds(i,"Rpt")),"</tr>"
			#if $$$EnsHSManage
				DO notes(flds(i,"Note"),1,8,i)
			#else
				DO notes(flds(i,"Note"),1,7,i)
			#endif
		}
		W "</table>"
	}
	Set ds="" DO annot.GetType(planned,"DS",.items)
	FOR  {
		Set ds=$O(items(ds),1,usage) Q:ds=""
		Do annot.LoadDS(ds,.flds)
		IF flds=0 Continue
		W "<br><br><table border=4 cellspacing=0 cellpadding=4><caption>"
		W "<h1>",$$$TextHTML("Data Structure"),"  ",basever,":",ds," - ",annot.GetName("DS",ds) W:usage="P" "  (",$$$TextHTML("planned"),")" W "</h1></caption>"
		W "<tr><th>",$$$TextHTML("Seq"),"</th><th>",$$$TextHTML("Description"),"</th><th>",$$$TextHTML("Usage"),"</th><th>",$$$TextHTML("Code"),"<br>",$$$TextHTML("Table"),"</th><th>",$$$TextHTML("Data"),"<br>",$$$TextHTML("Struct"),"</th></tr>"
		For i=1:1:flds {
			W "<tr>"
			Set u=flds(i,"UC") Set:(usage="P")&(u="S") u="P" //field usage can't be better than segment usage
			IF psup'[u CONTINUE
			W $$wtd(i),$$wtd(flds(i,"Name"),500),$$usage(u)
			W $$wtd(flds(i,"CT")),$$wtd(flds(i,"DS"))
			W "</tr>" DO notes(flds(i,"Note"),1,5)
		}
		W "</table>"
	}

	W "<br><br><table border=4 cellspacing=0 cellpadding=4><caption><h1>Code Tables</h1></caption>"
	W "<tr><th>",$$$TextHTML("Code Table"),"</th><th>",$$$TextHTML("Description"),"</th><th>",$$$TextHTML("Usage"),"</tr>"
	DO annot.GetType(planned,"CT",.items)
	Set ct=""
	FOR {
		Set ct=$O(items(ct),1,usage) Q:ct=""
		W "<tr>",$$wtd(basever_":"_ct),$$wtd(annot.GetName("CT",ct)),$$usage(usage),"</tr>"
	}
	&html<</body>
</html>>
	Quit $$$OK

usage(us)
	QUIT $$wtd($S(us="S":$$$TextHTML("Today"),us="P":$$$TextHTML("Planned"),1:""),"","","usage")
	
xxxnotes(note,span1,span2)
	Q:note=""  //W "<tr>",$$wtd("","",span1),$$wtd(note,700,span2,"note"),"<tr>" QUIT
	W !,"<tr>",$$wtd("","",span1),"<td colspan='",span2,"'><textarea readonly rows='"
	W $L(note)\77++$L(note,$C(13,10)),"' class='note' cols='77'>",$ZCVT(note,"O","HTML"),"</textarea></td></tr>"
	QUIT
notes(note,span1,span2,fldnum=0)
	QUIT:note=""
	W !,"<tr>",$$wtd("","",span1),"<td colspan='",span2,"'><Table>"
	IF note'="" {
		W "<tr><td class='annotl'>Notes:</td><td><textarea readonly rows='"
		W $L(note)\77++$L(note,$C(13,10)),"' class='note' cols='77'>",$ZCVT(note,"O","HTML"),"</textarea></td></tr>"
	}
	W "</table></td></tr>" Q

wtd(xx,wid="",colspan="", class="")
	QUIT "<td"_$s(class'="": " class='"_class_"'",1:"")_$s(wid'="":" width='"_wid_"'",1:"")_$s(colspan'="":" colspan="_colspan,1:"")_">"_$S(xx="":"&nbsp;",1:$ZCVT(xx,"O","HTML"))_"</td>"
	
nbsp(yy)
	WHILE yy[" " { Set yy=$P(yy," ")_"&nbsp;"_$P(yy," ",2,999) }
	QUIT yy
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Production Configuration Legend.<br>
/// This page renders the SVG needed to display the legend.
/// It is called from the ProductionConfigurationLegend dialog.
Class EnsLib.ITK.Setup.UI.ProductionConfigurationLegendSVG Extends %ZEN.SVGComponent.svgPage [ System = 4 ]
{

/// User needs READ permissions on the %Ens_ProductionConfig resource to view this page.
Parameter RESOURCE = "%Ens_ProductionConfig:READ";

/// Use our own domain for localization
Parameter DOMAIN = "Ensemble";

Method %OnDrawSVGPage() As %Status
{
	Set tSC = ..DrawLegend()
	Quit tSC
}

/// Draw the SVG legend.
Method DrawLegend() As %Status
{
	/*
	Add a Legend option to the SVG context menu on the Config Diagram pane. 
	It should describe what the different color indicators mean for Hosts and Adapters.

Here is a sample description of what they mean:

Host indicators (circular):
Red - The last message this config item processed resulted in an error
Green - The last message processed by this config item was completed successfully
Orange - This config item is retrying its current message
Yellow - This config item is inactive based on its configured Inactivity Timeout
Dim Red -
Dim Green -
Dim Orange -
Dim Yellow - For stopped items, the dimmed colors show the last color an item had before it was stopped.
Grey - not enabled; stopped; starting up

Adapter indicators (triangular) for adapters that can maintain a connection to an external system:
Red - At least one job for the host is not connected and either has queued messages (Operations only) or the host is configured with StayConnected=-1 (meaning it should never voluntarily disconnect).
Green - The adapter has at least one connection active and no job in a state that would make it Red.
Yellow - The adapter is listening for a connection (Services) or has no connection and no queued messages (Operations)
Grey - The adapter is disabled or has no jobs running
Dim Red -
Dim Green -
Dim Yellow - For stopped items, the dimmed colors show the last color an item had before it was stopped.
	*/

	Set msgTime = $$$TextHTML("Time")
	Set msgType = $$$TextHTML("Message Type")

	&html<
<rect class="canvas" x="0" y="0" width="700" height="510" />

<text class="HostTitle" x="30" y="40" text-anchor="start">#($$$TextHTML("Indicators"))#</text>

<g transform="translate(20,60)">
<circle class="itemStopped" cx="10" cy="6" r="7" />
<text class="Label" x="25" y="10" text-anchor="start">#($$$TextHTML("Not running, reconciled"))#</text>
</g>

<g transform="translate(20,90)">
<circle class="itemRunning" cx="10" cy="6" r="7" />
<text class="Label" x="25" y="10" text-anchor="start">#($$$TextHTML("Running"))#</text>
</g>

<g transform="translate(20,120)">
<circle class="itemDisabled" cx="10" cy="6" r="7" />
<text class="Label" x="25" y="10" text-anchor="start">#($$$TextHTML("Disabled"))#</text>
</g>

<g transform="translate(20,150)">
<circle class="itemError" cx="10" cy="6" r="7" />
<text class="Label" x="25" y="10" text-anchor="start">#($$$TextHTML("Error"))#</text>
</g>

<g transform="translate(20,180)">
<circle class="itemInactive" cx="10" cy="6" r="7" />
<text class="Label" x="25" y="10" text-anchor="start">#($$$TextHTML("Configuration item not yet backed by production host"))#</text>
<text class="Label" x="25" y="25" text-anchor="start">#($$$TextHTML("E.g. a consumer that doesn't have any subscriptions or distribution rules"))#</text>
</g>

<text class="HostTitle" x="30" y="230" text-anchor="start">#($$$TextHTML("Interaction"))#</text>

<text class="Label" x="25" y="260" text-anchor="start">#($$$TextHTML("Click on an item's name to view its details"))#</text>

<text class="Label" x="25" y="290" text-anchor="start">#($$$TextHTML("Click on an indicator to view the connections"))#</text>

<text class="Label" x="25" y="320" text-anchor="start">#($$$TextHTML("Double-click on an item to enable or disable it"))#</text>

>

	/*
<g transform="translate(20,70)">
<line class="SepLine" x1="0" y1="-20" x2="240" y2="-20" />
<text class="Label" x="10" y="4" text-anchor="start">#($$$TextHTML("Synchronous request"))#</text>
<rect class="MsgOutline" x="10" y="8" width="190" height="24" rx="3" />
<rect class="MsgTermSync" x="183" y="11" width="14" height="18" rx="2"/>
<line class="MsgLineRequest" x1="20" y1="20" x2="182" y2="20" />
<circle class="MsgStartSync" cx="20" cy="20" r="8"/>
<line class="MsgLineRequest" x1="177" y1="15" x2="182" y2="20" />
<line class="MsgLineRequest" x1="177" y1="25" x2="182" y2="20" />
<text class="MsgLabel" x="35" y="18" text-anchor="start">#(msgTime)#</text>
<text class="MsgLabel" x="35" y="30" text-anchor="start">#(msgType)#</text>
</g>

<g transform="translate(20,140)">
<line class="SepLine" x1="0" y1="-20" x2="240" y2="-20" />
<text class="Label" x="10" y="4" text-anchor="start">#($$$TextHTML("Asynchronous request with response"))#</text>
<rect class="MsgOutline" x="10" y="8" width="190" height="24" rx="3" />
<rect class="MsgTermAsync" x="183" y="11" width="14" height="18" rx="2"/>
<line class="MsgLineRequest" x1="20" y1="20" x2="182" y2="20" />
<circle class="MsgStartAsync" cx="20" cy="20" r="8"/>
<line class="MsgLineRequest" x1="177" y1="15" x2="182" y2="20" />
<line class="MsgLineRequest" x1="177" y1="25" x2="182" y2="20" />
<line class="MsgLineRequest" x1="172" y1="15" x2="177" y2="20" />
<line class="MsgLineRequest" x1="172" y1="25" x2="177" y2="20" />
<text class="MsgLabel" x="35" y="18" text-anchor="start">#(msgTime)#</text>
<text class="MsgLabel" x="35" y="30" text-anchor="start">#(msgType)#</text>
</g>
</g>

<text class="HostTitle" x="320" y="40" text-anchor="start">#($$$TextHTML("Events"))#</text>

<g transform="translate(310,70)">
<line class="SepLine" x1="0" y1="-20" x2="150" y2="-20" />
<text class="Label" x="10" y="4" text-anchor="start">#($$$TextHTML("Event Log Error"))#</text>
<g transform="translate(20,20)">
<rect class="eventMarkerBack" x="-8" y="-8" width="16" height="16" />
<path class="eventMarker2" d="M -6 0 L 0 6 6 0 0 -6 Z" />
</g>
</g>

<g transform="translate(310,140)">
<line class="SepLine" x1="0" y1="-20" x2="150" y2="-20" />
<text class="Label" x="10" y="4" text-anchor="start">#($$$TextHTML("Event Log Warning"))#</text>
<g transform="translate(20,20)">
<rect class="eventMarkerBack" x="-8" y="-8" width="16" height="16" />
<path class="eventMarker3" d="M -6 0 L 0 6 6 0 0 -6 Z" />
</g>
</g>

			case 'error':
				dot.setAttribute('style','fill: red;');
				rect.setAttribute('style','fill: red; stroke: black;');
				label.setAttribute('style','fill: white;');
				break;
			case 'stopped':
				dot.setAttribute('style','fill: #DEFFBC;'); // was: #D0E0D0;
				break;
			case 'inactive':
				dot.setAttribute('style','fill: yellow;');
				break;
			case 'disabled':
				dot.setAttribute('style','fill: #D0D0D0;');
				break;
			default:
				dot.setAttribute('style','fill: #20C020;');
				break;

*/

	Quit $$$OK
}

/// Callback method called when drawing the SVG CSS style for this page.
ClassMethod %OnDrawStyleSVG() As %Status
{
	#; find svg font from localization file
	Set tFont = $$$Text("FontFamily","Arial,Tahoma,Verdana")

	#; style
	Write "<style type=""text/css""><![CDATA[",!
	&html<

.canvas {
	fill: white;
	stroke : gray;
	stroke-width : 1;
}

.itemStopped {
	fill: #DEFFBC;
	stroke: gray;
	stroke-width: 1;
	opacity: 1.0;
}

.itemRunning {
	fill: #20C020;
	stroke: gray;
	stroke-width: 1;
	opacity: 1.0;
}

.itemDisabled {
	fill: #D0D0D0;
	stroke: gray;
	stroke-width: 1;
	opacity: 1.0;
}

.itemError {
	fill: red;
	stroke: gray;
	stroke-width: 1;
	opacity: 1.0;
}

.itemRetrying {
	fill: #DEFFBC;
	stroke: gray;
	stroke-width: 1;
	opacity: 1.0;
}

.itemInactive {
	fill: yellow;
	stroke: gray;
	stroke-width: 1;
	opacity: 1.0;
}

.itemNormalStart {
	stroke: #404080;
	stroke-width: 2;
	opacity: 1.0;
}

.itemPartner {
	fill: url(#glow-silver);
	stroke: black;
	stroke-width: 1;
}

rect.TitleRect {
	fill: #FFEEDD;
	stroke : black;
	stroke-width : 1;
}

rect.HostRect {
	fill: #EEDDFF;
	stroke : blue;
	stroke-width : 1;
}

rect.HostRectSelect {
	fill: yellow;
	stroke : green;
	stroke-width : 2;
}

rect.LaneRect1 {
	fill: none;
	stroke : none;
}

rect.LaneRect2 {
	fill: white;
	stroke : none;
}

rect.LaneRect3 {
	fill: none;
	stroke : none;
}

text.LaneTitle {
	font-size : 16pt;
	stroke : none;
	fill: black;
}

text.HostTitle {
	font-size : 9pt;
	font-weight: bold;
	stroke : none;
	fill: black;
}

text.MsgLabel {
  font-size: 8pt;
  stroke: none;
  fill: black;
}

text.Title {
	font-size : 18pt;
	stroke : none;
	fill: blue;
}

text.Label {
	font-size : 10pt;
	stroke : none;
	fill: black;
}

line.SepLine {
	stroke : gray;
	stroke-width : 1;
}

line.Time {
	stroke : gray;
	stroke-width : 2;
	stroke-linecap: round;
}

rect.HostLine {
	fill: #E0E0E0;
	stroke : gray;
	stroke-width : 1;
}

rect.HostLineSelect {
	fill: yellow;
	stroke : green;
	stroke-width : 2;
}

rect.MsgOutline {
	fill: white;
	stroke: darkblue;
	stroke-width: 2;
	fill-opacity: 0.9;
}

line.MsgLineRequest {
	stroke : blue;
	stroke-width : 2;
	stroke-linecap: round;
	opacity: 0.8;
}

line.MsgLineResponse {
	stroke : green;
	stroke-width : 2;
	stroke-linecap: round;
	opacity: 0.8;
}

rect.MsgTerm {
	fill: gray;
	stroke : blue;
	stroke-width : 1;
}

rect.MsgTermQueued {
	fill: gray;
	stroke : black;
	stroke-width : 1;
}

rect.MsgTermDiscarded {
	fill: silver;
	stroke : blue;
	stroke-width : 1;
}

rect.MsgTermNoResponse {
	fill: orange;
	stroke : blue;
	stroke-width : 1;
}

rect.MsgTermResponse {
	fill: plum;
	stroke : blue;
	stroke-width : 1;
}

rect.MsgTermAsyncResponse {
	fill: plum;
	stroke : blue;
	stroke-width : 1;
}

rect.MsgTermSyncResponse {
	fill: lightblue;
	stroke : blue;
	stroke-width : 1;
}

rect.MsgTermAsync {
	fill: plum;
	stroke : blue;
	stroke-width : 1;
}

rect.MsgTermSync {
	fill: lightblue;
	stroke : blue;
	stroke-width : 1;
}

circle.Discarded {
	fill: silver;
	stroke : blue;
	stroke-width : 1;
}

circle.MsgStart {
	fill: yellow;
	stroke : blue;
	stroke-width : 1;
}

circle.MsgStartNoResponse {
	fill: orange;
	stroke : blue;
	stroke-width : 1;
}

circle.MsgStartSyncResponse {
	fill: lightblue;
	stroke : blue;
	stroke-width : 1;
}

circle.MsgStartResponse {
	fill: plum;
	stroke : blue;
	stroke-width : 1;
}

circle.MsgStartSync {
	fill: lightblue;
	stroke : blue;
	stroke-width : 1;
}

circle.MsgStartAsync {
	fill: plum;
	stroke : blue;
	stroke-width : 1;
}

circle.MsgStartAsyncResponse {
	fill: plum;
	stroke : blue;
	stroke-width : 1;
}

.eventMarkerBack {
	fill: white;
	stroke: blue;
	stroke-width: 1;
	opacity: 0.9;
}

text, tspan {
	font-family: #(tFont)#;
}

/* Assert,Error,Warning,Info,Trace,Alert */

.eventMarker1 {
	fill: silver;
	stroke: black;
	stroke-width: 1;
}

.eventMarker2 {
	fill: red;
	stroke: black;
	stroke-width: 1;
	opacity: 0.7;
}

.eventMarker3 {
	fill: orange;
	stroke: black;
	stroke-width: 1;
}

.eventMarker4 {
	fill: white;
	stroke: black;
	stroke-width: 1;
}

.eventMarker5 {
	fill: lightblue;
	stroke: black;
	stroke-width: 1;
}

.eventMarker6 {
	fill: yellow;
	stroke: black;
	stroke-width: 1;
}

/* IOLog */

.ackArrow {
	fill: green;
	stroke: black;
	stroke-width: 0;
}

.ackBack {
	fill: white;
	stroke: blue;
	stroke-width: 1;
	opacity: 0.9;
}

.ioArrows {
	fill: blue;
	stroke-width: 0;
}
>
	Write "]]></style>>"
	Quit $$$OK
}

}

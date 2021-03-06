Class HS.Test.UI.AU.IHIBatchSearch Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "IHI Batch Search for Patient";

Parameter SERVICEREGISTRYENTRY = "AU.HI";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textReadOnly {
	border: 1px inset threedface;
	color:#777777;
	background: #EEEEEE;
}

</style>
}

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page title="HealthShare Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<html>Search by patient demographics</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<checkbox label="Enable logging" id="chkLogging"/>
<spacer height="5"/>
<text label="IHI Number:" id="txtIHINumber" size="60" tabIndex="5" />
<text label="First Name:" name="FirstName" id="txtFirstName" size="30" tabIndex="5" />
<text label="Last Name:" name="LastName" id="txtLastName" size="30" tabIndex="10" />
<combobox id="cmbGender" label="Gender:" size="22" tabIndex="15">
<option value="" text=""/>
<option value="F" text="Female"/>
<option value="I" text="I"/>
<option value="M" text="Male"/>
<option value="N" text="N"/>
</combobox>
<dateText id="dtDOB" label="Date of Birth:" size="22" minDate="1841-01-01" maxDate="T" hint="(yyyy-mm-dd)" hintStyle="font-size:10px;font-weight:bold;" tabIndex="20"/>
<combobox id="cmbAddressType" label="Address Type:" size="22" tabIndex="25" onchange="zenPage.UpdateAddressType();" value="none">
<option value="none" text=""/>
<option value="0" text="Postal Address"/>
<option value="1" text="Street Address"/>
<option value="2" text="International Address"/>
</combobox>

<!-- postal address -->
<pane id="PostalAddress" hidden="true" labelPosition="left">
<combobox label="Delivery Group:" id="cmbPostDeliveryType" size="20" tabIndex="25" >
<option value="Care PO" text="Care PO"/><option value="CMA" text="CMA"/><option value="CMB" text="CMB"/><option value="GPO Box" text="GPO Box"/><option value="Locked Bag" text="Locked Bag"/><option value="MS" text="MS"/><option value="PO Box" text="PO Box"/><option value="POR" text="POR"/><option value="Private Bag" text="Private Bag"/><option value="RSD" text="RSD"/><option value="RMB" text="RMB"/><option value="RMS" text="RMS"/>
</combobox>
<text label="Delivery Number:" id="txtPostDeliveryNumber" size="20" tabIndex="30" />
<text label="PostCode:" id="txtPostPostCode" size="10" tabIndex="40" />
<combobox label="State:" id="cmbPostState" size="20" tabIndex="25" >
<option value="ACT" text="ACT"/><option value="NSW" text="NSW"/><option value="NT" text="NT"/><option value="QLD" text="QLD"/><option value="SA" text="SA"/><option value="TAS" text="TAS"/><option value="VIC" text="VIC"/><option value="WA" text="WA"/>
</combobox>
<text label="Suburb:" id="txtPostSuburb" size="10" tabIndex="50" />
</pane>

<!-- Street Address -->
<pane id="StreetAddress" hidden="true" labelPosition="left">

<text label="AddressSiteName:" id="txtStreetAddressSiteName" size="80" />
<combobox label="Unit Type:" id="cmbStreetUnitType" size="20" tabIndex="25" >
<option value="ANT" text="ANT"/><option value="APT" text="APT"/><option value="ATM" text="ATM"/><option value="BBQ" text="BBQ"/><option value="BTSD" text="BTSD"/><option value="BLDG" text="BLDG"/><option value="BNGW" text="BNGW"/><option value="CAGE" text="CAGE"/><option value="CARP" text="CARP"/><option value="CARS" text="CARS"/><option value="CLUB" text="CLUB"/><option value="COOL" text="COOL"/><option value="CTGE" text="CTGE"/><option value="DUP" text="DUP"/><option value="FY" text="FY"/><option value="F" text="F"/><option value="GRGE" text="GRGE"/><option value="HALL" text="HALL"/><option value="HSE" text="HSE"/><option value="KSK" text="KSK"/>
<option value="LSE" text="LSE"/><option value="LBBY" text="LBBY"/><option value="LOFT" text="LOFT"/><option value="LOT" text="LOT"/><option value="MSNT" text="MSNT"/><option value="MB" text="MB"/><option value="OFF" text="OFF"/><option value="PTHS" text="PTHS"/><option value="RESV" text="RESV"/><option value="RM" text="RM"/><option value="SHED" text="SHED"/><option value="SHOP" text="SHOP"/><option value="SIGN" text="SIGN"/><option value="SITE" text="SITE"/><option value="SL" text="SL"/><option value="STOR" text="STOR"/><option value="STR" text="STR"/><option value="STU" text="STU"/><option value="SUBS" text="SUBS"/><option value="SE" text="SE"/>
<option value="TNCY" text="TNCY"/><option value="TWR" text="TWR"/><option value="TNHS" text="TNHS"/><option value="U" text="U"/><option value="VLLA" text="VLLA"/><option value="WARD" text="WARD"/><option value="WE" text="WE"/><option value="WKSH" text="WKSH"/>
</combobox>
<text label="Unit Number:" id="txtStreetUnitNumber" size="10"  />
<combobox label="Level Type:" id="cmbStreetLevelType" size="20"  >
<option value="B" text="B"/><option value="FL" text="FL"/><option value="G" text="G"/><option value="L" text="L"/><option value="LG" text="LG"/><option value="M" text="M"/><option value="OD" text="OD"/><option value="P" text="P"/><option value="PTHS" text="PTHS"/><option value="PLF" text="PLF"/><option value="PLZA" text="PLZA"/><option value="PDM" text="PDM"/><option value="RT" text="RT"/><option value="SB" text="SB"/><option value="UG" text="UG"/>
</combobox>
<text label="Level Number:" id="txtStreetLevelNumber" size="10" tabIndex="40" />
<text label="Lot Number:" id="txtStreetLotNumber" size="10" tabIndex="40" />
<text label="Street Number:" id="txtStreetNumber" size="20" tabIndex="25" />
<text label="Street Name:" id="txtStreetName" size="80" tabIndex="25" />
<combobox label="Street Suffix:" id="cmbStreetSuffix" size="20" tabIndex="25">
<option value="CN" text="CN"/><option value="E" text="E"/><option value="EX" text="EX"/><option value="LR" text="LR"/><option value="N" text="N"/><option value="NE" text="NE"/><option value="NW" text="NW"/><option value="S" text="S"/><option value="SE" text="SE"/><option value="SW" text="SW"/><option value="UP" text="UP"/><option value="W" text="W"/>
</combobox>
<combobox label="Street Type:" id="cmbStreetType" size="20" tabIndex="25">
<option value="ACCS" text="ACCS"/><option value="ALLY" text="ALLY"/><option value="ALWY" text="ALWY"/><option value="AMBL" text="AMBL"/><option value="ANCG" text="ANCG"/><option value="APP" text="APP"/><option value="ARC" text="ARC"/><option value="ART" text="ART"/><option value="AVE" text="AVE"/><option value="BASN" text="BASN"/><option value="BCH" text="BCH"/><option value="BEND" text="BEND"/><option value="BLK" text="BLK"/><option value="BWLK" text="BWLK"/><option value="BVD" text="BVD"/><option value="BRCE" text="BRCE"/><option value="BRAE" text="BRAE"/><option value="BRK" text="BRK"/><option value="BDGE" text="BDGE"/><option value="BDWY" text="BDWY"/>
<option value="BROW" text="BROW"/><option value="BYPA" text="BYPA"/><option value="BYWY" text="BYWY"/><option value="CAUS" text="CAUS"/><option value="CTR" text="CTR"/><option value="CNWY" text="CNWY"/><option value="CH" text="CH"/><option value="CIR" text="CIR"/><option value="CLT" text="CLT"/><option value="CCT" text="CCT"/><option value="CRCS" text="CRCS"/><option value="CL" text="CL"/><option value="CLDE" text="CLDE"/><option value="CMMN" text="CMMN"/><option value="CON" text="CON"/><option value="CPS" text="CPS"/><option value="CNR" text="CNR"/><option value="CSO" text="CSO"/><option value="CT" text="CT"/><option value="CTYD" text="CTYD"/>
<option value="COVE" text="COVE"/><option value="CRES" text="CRES"/><option value="CRST" text="CRST"/><option value="CRSS" text="CRSS"/><option value="CRSG" text="CRSG"/><option value="CRD" text="CRD"/><option value="COWY" text="COWY"/><option value="CUWY" text="CUWY"/><option value="CDS" text="CDS"/><option value="CTTG" text="CTTG"/><option value="DALE" text="DALE"/><option value="DELL" text="DELL"/><option value="DEVN" text="DEVN"/><option value="DIP" text="DIP"/><option value="DSTR" text="DSTR"/><option value="DR" text="DR"/><option value="DRWY" text="DRWY"/><option value="EDGE" text="EDGE"/><option value="ELB" text="ELB"/><option value="END" text="END"/>
<option value="ENT" text="ENT"/><option value="ESP" text="ESP"/><option value="EST" text="EST"/><option value="EXP" text="EXP"/><option value="EXTN" text="EXTN"/><option value="FAWY" text="FAWY"/><option value="FTRK" text="FTRK"/><option value="FITR" text="FITR"/><option value="FLAT" text="FLAT"/><option value="FOLW" text="FOLW"/><option value="FTWY" text="FTWY"/><option value="FSHR" text="FSHR"/><option value="FORM" text="FORM"/><option value="FWY" text="FWY"/><option value="FRNT" text="FRNT"/><option value="FRTG" text="FRTG"/><option value="GAP" text="GAP"/><option value="GDN" text="GDN"/><option value="GDNS" text="GDNS"/><option value="GTE" text="GTE"/>
<option value="GTES" text="GTES"/><option value="GLD" text="GLD"/><option value="GLEN" text="GLEN"/><option value="GRA" text="GRA"/><option value="GRN" text="GRN"/><option value="GRND" text="GRND"/><option value="GR" text="GR"/><option value="GLY" text="GLY"/><option value="HTS" text="HTS"/><option value="HRD" text="HRD"/><option value="HWY" text="HWY"/><option value="HILL" text="HILL"/><option value="INTG" text="INTG"/><option value="INTN" text="INTN"/><option value="JNC" text="JNC"/><option value="KEY" text="KEY"/><option value="LDG" text="LDG"/><option value="LANE" text="LANE"/><option value="LNWY" text="LNWY"/><option value="LEES" text="LEES"/>
<option value="LINE" text="LINE"/><option value="LINK" text="LINK"/><option value="LT" text="LT"/><option value="LKT" text="LKT"/><option value="LOOP" text="LOOP"/><option value="LWR" text="LWR"/><option value="MALL" text="MALL"/><option value="MNDR" text="MNDR"/><option value="MEW" text="MEW"/><option value="MEWS" text="MEWS"/><option value="MWY" text="MWY"/><option value="MT" text="MT"/><option value="NOOK" text="NOOK"/><option value="OTLK" text="OTLK"/><option value="PDE" text="PDE"/><option value="PARK" text="PARK"/><option value="PKLD" text="PKLD"/><option value="PKWY" text="PKWY"/><option value="PART" text="PART"/><option value="PASS" text="PASS"/>
<option value="PATH" text="PATH"/><option value="PHWY" text="PHWY"/><option value="PIAZ" text="PIAZ"/><option value="PL" text="PL"/><option value="PLAT" text="PLAT"/><option value="PLZA" text="PLZA"/><option value="PKT" text="PKT"/><option value="PNT" text="PNT"/><option value="PORT" text="PORT"/><option value="PROM" text="PROM"/><option value="QUAD" text="QUAD"/><option value="QDGL" text="QDGL"/><option value="QDRT" text="QDRT"/><option value="QY" text="QY"/><option value="QYS" text="QYS"/><option value="RMBL" text="RMBL"/><option value="RAMP" text="RAMP"/><option value="RNGE" text="RNGE"/><option value="RCH" text="RCH"/><option value="RES" text="RES"/>
<option value="REST" text="REST"/><option value="RTT" text="RTT"/><option value="RIDE" text="RIDE"/><option value="RDGE" text="RDGE"/><option value="RGWY" text="RGWY"/><option value="ROWY" text="ROWY"/><option value="RING" text="RING"/><option value="RISE" text="RISE"/><option value="RVR" text="RVR"/><option value="RVWY" text="RVWY"/><option value="RVRA" text="RVRA"/><option value="RD" text="RD"/><option value="RDS" text="RDS"/><option value="RDSD" text="RDSD"/><option value="RDWY" text="RDWY"/><option value="RNDE" text="RNDE"/><option value="RSBL" text="RSBL"/><option value="RTY" text="RTY"/><option value="RND" text="RND"/><option value="RTE" text="RTE"/>
<option value="ROW" text="ROW"/><option value="RUE" text="RUE"/><option value="RUN" text="RUN"/><option value="SWY" text="SWY"/><option value="SHUN" text="SHUN"/><option value="SDNG" text="SDNG"/><option value="SLPE" text="SLPE"/><option value="SND" text="SND"/><option value="SPUR" text="SPUR"/><option value="SQ" text="SQ"/><option value="STRS" text="STRS"/><option value="SHWY" text="SHWY"/><option value="STPS" text="STPS"/><option value="STRA" text="STRA"/><option value="ST" text="ST"/><option value="STRP" text="STRP"/><option value="SBWY" text="SBWY"/><option value="TARN" text="TARN"/><option value="TCE" text="TCE"/><option value="THOR" text="THOR"/>
<option value="TLWY" text="TLWY"/><option value="TOP" text="TOP"/><option value="TOR" text="TOR"/><option value="TWRS" text="TWRS"/><option value="TRK" text="TRK"/><option value="TRL" text="TRL"/><option value="TRLR" text="TRLR"/><option value="TRI" text="TRI"/><option value="TKWY" text="TKWY"/><option value="TURN" text="TURN"/><option value="UPAS" text="UPAS"/><option value="UPR" text="UPR"/><option value="VALE" text="VALE"/><option value="VDCT" text="VDCT"/><option value="VIEW" text="VIEW"/><option value="VLLS" text="VLLS"/><option value="VSTA" text="VSTA"/><option value="WADE" text="WADE"/><option value="WALK" text="WALK"/><option value="WKWY" text="WKWY"/>
<option value="WAY" text="WAY"/><option value="WHRF" text="WHRF"/><option value="WYND" text="WYND"/><option value="YARD" text="YARD"/>
</combobox>
<text label="PostCode:" id="txtStreetPostCode" size="10" tabIndex="40" />
<combobox label="State:" id="cmbStreetState" size="20" tabIndex="25" >
<option value="ACT" text="ACT"/><option value="NSW" text="NSW"/><option value="NT" text="NT"/><option value="QLD" text="QLD"/><option value="SA" text="SA"/><option value="TAS" text="TAS"/><option value="VIC" text="VIC"/><option value="WA" text="WA"/>
</combobox>
<text label="Suburb:" id="txtStreetSuburb" size="10" tabIndex="50" />

</pane>
<pane id="InternationalAddress" hidden="true" labelPosition="left">
<text label="Address Line:" id="txtIntlStreet" size="80" />
<text label="State/Province:" id="txtIntlState" size="10" />
<text label="PostCode:" id="txtIntlPostCode" size="10" />
<combobox label="Country:" id="cmbIntlCountry" size="20" >
<option value="1601" text="1601"/><option value="7201" text="7201"/><option value="3201" text="3201"/><option value="4101" text="4101"/><option value="3101" text="3101"/><option value="9201" text="9201"/><option value="8401" text="8401"/><option value="8402" text="8402"/><option value="8201" text="8201"/><option value="1602" text="1602"/><option value="7202" text="7202"/><option value="8403" text="8403"/><option value="1101" text="1101"/><option value="1603" text="1603"/><option value="1199" text="1199"/><option value="2301" text="2301"/><option value="7203" text="7203"/><option value="8404" text="8404"/><option value="4201" text="4201"/><option value="7101" text="7101"/>                                        <option value="8405" text="8405"/><option value="3301" text="3301"/><option value="2302" text="2302"/><option value="8301" text="8301"/><option value="9101" text="9101"/><option value="8101" text="8101"/><option value="7102" text="7102"/><option value="8202" text="8202"/><option value="3202" text="3202"/><option value="9202" text="9202"/><option value="8203" text="8203"/><option value="1604" text="1604"/><option value="5201" text="5201"/><option value="3203" text="3203"/><option value="9102" text="9102"/><option value="5101" text="5101"/><option value="9203" text="9203"/><option value="5102" text="5102"/><option value="9103" text="9103"/><option value="8102" text="8102"/>
<option value="9104" text="9104"/><option value="8406" text="8406"/><option value="9105" text="9105"/><option value="9106" text="9106"/><option value="2101" text="2101"/><option value="8204" text="8204"/><option value="1605" text="1605"/><option value="6101" text="6101"/><option value="8205" text="8205"/><option value="9204" text="9204"/><option value="9107" text="9107"/><option value="9108" text="9108"/><option value="1501" text="1501"/><option value="8302" text="8302"/><option value="9111" text="9111"/><option value="3204" text="3204"/><option value="8407" text="8407"/><option value="3205" text="3205"/><option value="3302" text="3302"/><option value="2401" text="2401"/>
<option value="9205" text="9205"/><option value="8408" text="8408"/><option value="8411" text="8411"/><option value="5206" text="5206"/><option value="8206" text="8206"/><option value="4102" text="4102"/><option value="8303" text="8303"/><option value="2102" text="2102"/><option value="9112" text="9112"/><option value="9206" text="9206"/><option value="3303" text="3303"/><option value="9207" text="9207"/><option value="2402" text="2402"/><option value="8207" text="8207"/><option value="1502" text="1502"/><option value="2403" text="2403"/><option value="3206" text="3206"/><option value="2303" text="2303"/><option value="8208" text="8208"/><option value="1503" text="1503"/>
<option value="9113" text="9113"/><option value="9114" text="9114"/><option value="4202" text="4202"/><option value="7204" text="7204"/><option value="2304" text="2304"/><option value="9115" text="9115"/><option value="3102" text="3102"/><option value="3207" text="3207"/><option value="2404" text="2404"/><option value="8412" text="8412"/><option value="8413" text="8413"/><option value="1401" text="1401"/><option value="8304" text="8304"/><option value="9116" text="9116"/><option value="9117" text="9117"/><option value="8211" text="8211"/><option value="8414" text="8414"/><option value="3103" text="3103"/><option value="8305" text="8305"/><option value="6102" text="6102"/>
<option value="3304" text="3304"/><option value="2405" text="2405"/><option value="7103" text="7103"/><option value="5202" text="5202"/><option value="4203" text="4203"/><option value="4204" text="4204"/><option value="2103" text="2103"/><option value="4205" text="4205"/><option value="3104" text="3104"/><option value="8415" text="8415"/><option value="6201" text="6201"/><option value="4206" text="4206"/><option value="7205" text="7205"/><option value="9208" text="9208"/><option value="1402" text="1402"/><option value="6202" text="6202"/><option value="6203" text="6203"/><option value="4207" text="4207"/><option value="7206" text="7206"/><option value="5103" text="5103"/>
<option value="3305" text="3305"/><option value="4208" text="4208"/><option value="9211" text="9211"/><option value="9118" text="9118"/><option value="4103" text="4103"/><option value="2305" text="2305"/><option value="3306" text="3306"/><option value="2306" text="2306"/><option value="6103" text="6103"/><option value="9212" text="9212"/><option value="9213" text="9213"/><option value="5203" text="5203"/><option value="7104" text="7104"/><option value="9121" text="9121"/><option value="3105" text="3105"/><option value="1403" text="1403"/><option value="8416" text="8416"/><option value="9122" text="9122"/><option value="9214" text="9214"/><option value="9215" text="9215"/>
<option value="8306" text="8306"/><option value="1404" text="1404"/><option value="3208" text="3208"/><option value="2307" text="2307"/><option value="6104" text="6104"/><option value="8417" text="8417"/><option value="4104" text="4104"/><option value="9216" text="9216"/><option value="9217" text="9217"/><option value="1405" text="1405"/><option value="7105" text="7105"/><option value="2308" text="2308"/><option value="8418" text="8418"/><option value="1301" text="1301"/><option value="1201" text="1201"/><option value="8307" text="8307"/><option value="9123" text="9123"/><option value="9124" text="9124"/><option value="1504" text="1504"/><option value="1102" text="1102"/>
<option value="4199" text="4199"/><option value="2104" text="2104"/><option value="1406" text="1406"/><option value="2406" text="2406"/><option value="4211" text="4211"/><option value="OTHE" text="OTHE"/><option value="7106" text="7106"/><option value="1407" text="1407"/><option value="8308" text="8308"/><option value="1302" text="1302"/><option value="8212" text="8212"/><option value="8213" text="8213"/><option value="5204" text="5204"/><option value="3307" text="3307"/><option value="1599" text="1599"/><option value="3106" text="3106"/><option value="8421" text="8421"/><option value="4212" text="4212"/><option value="1606" text="1606"/><option value="2201" text="2201"/>
<option value="9218" text="9218"/><option value="3211" text="3211"/><option value="1607" text="1607"/><option value="3308" text="3308"/><option value="9221" text="9221"/><option value="1505" text="1505"/><option value="1506" text="1506"/><option value="3107" text="3107"/><option value="9125" text="9125"/><option value="4213" text="4213"/><option value="2105" text="2105"/><option value="9126" text="9126"/><option value="9223" text="9223"/><option value="9127" text="9127"/><option value="5205" text="5205"/><option value="3311" text="3311"/><option value="3212" text="3212"/><option value="1303" text="1303"/><option value="9224" text="9224"/><option value="9225" text="9225"/>
<option value="8299" text="8299"/><option value="9299" text="9299"/><option value="3108" text="3108"/><option value="7107" text="7107"/>
</combobox>
</pane>
<combobox label="History:" id="cmbHistory" size="10" >
<option value="F" text="F"/><option value="T" text="T"/>
</combobox>
<text label="Number of Search Items:" id="txtNumberOfBatchItems" size="10" tabIndex="40" value="2"/>
<spacer height="15"/>
<combobox id="cmbServiceRegistry" label="EndPoint: *" labelClass="caption" 
 dropdownWidth="300">
</combobox>
<hgroup width="40%" cellAlign="right">
<button id="btnSend" caption=" Submit Request " onclick="zenPage.Start('btnSend',1);zenPage.Send();" />
<spacer width="5" />
<button id="btnClearDemo" caption=" Clear " onclick="zenPage.ClearDemographics();" />
<spacer width="5" />
<button id="btnDemoData" caption=" Demo Data " onclick="zenPage.DemoData();" />

</hgroup>

</form>
<pane id="paneResults"/>
</pane>
</page>
}

ClientMethod ClearDemographics() [ Language = javascript ]
{
	document.getElementById('paneResults').innerHTML='';

	this.getComponentById('txtFirstName').setValue("");
	this.getComponentById('txtLastName').setValue("");
	this.getComponentById('cmbGender').setValue("");
	this.getComponentById('dtDOB').setValue("");
	this.getComponentById('txtIHINumber').setValue("");
	this.getComponentById('cmbAddressType').setValue("");
	//this.UpdateAddressType();

	this.getComponentById('cmbPostDeliveryType').setValue("");
	this.getComponentById('txtPostDeliveryNumber').setValue("");
	this.getComponentById('txtPostPostCode').setValue("");
	this.getComponentById('cmbPostState').setValue("");
	this.getComponentById('txtPostSuburb').setValue("");

	this.getComponentById('txtStreetAddressSiteName').setValue("");
	this.getComponentById('cmbStreetUnitType').setValue("");
	this.getComponentById('txtStreetUnitNumber').setValue("");
	this.getComponentById('cmbStreetLevelType').setValue("");
	this.getComponentById('txtStreetLevelNumber').setValue("");
	this.getComponentById('txtStreetLotNumber').setValue("");
	this.getComponentById('txtStreetNumber').setValue("");
	this.getComponentById('txtStreetName').setValue("");
	this.getComponentById('cmbStreetSuffix').setValue("");
	this.getComponentById('cmbStreetType').setValue("");
	this.getComponentById('txtStreetPostCode').setValue("");
	this.getComponentById('cmbStreetState').setValue("");
	this.getComponentById('txtStreetSuburb').setValue("");

	this.getComponentById('txtIntlStreet').setValue("");
	this.getComponentById('txtIntlState').setValue("");
	this.getComponentById('txtIntlPostCode').setValue("");
	this.getComponentById('cmbIntlCountry').setValue("");
}

ClientMethod DemoData() [ Language = javascript ]
{
	//<userID></userID><userIDType></userIDType><ihiNumber></ihiNumber><medicareCardNumber></medicareCardNumber><dvaFileNumber></dvaFileNumber><dateOfBirth>1955-09-24</dateOfBirth><sex>F</sex><familyName></familyName><givenName></givenName><history></history>
	this.getComponentById('txtFirstName').setValue("KAROLINA");
	this.getComponentById('txtLastName').setValue("LAMM");
	this.getComponentById('cmbGender').setValue("F");
	this.getComponentById('dtDOB').setValue("1955-09-24");

	addressType = this.getComponentById('cmbAddressType');
	address = this.getComponentById('cmbAddressType').getValue();
	if(address == 'none') { 
		this.getComponentById('txtIHINumber').setValue("http://ns.electronichealth.net.au/id/hi/ihi/1.0/8003608500128236");
	} else {
		this.getComponentById('txtIHINumber').setValue("");
	}
	if(address=='0') {
		this.getComponentById('cmbPostDeliveryType').setValue("GPO Box");
		this.getComponentById('txtPostDeliveryNumber').setValue("123");
		this.getComponentById('txtPostPostCode').setValue("2087");
		this.getComponentById('cmbPostState').setValue("NSW");
		this.getComponentById('txtPostSuburb').setValue("Forestville");
	} else if (address=='1') {

		this.getComponentById('txtStreetLevelNumber').setValue(10);
		this.getComponentById('cmbStreetLevelType').setValue("FL");
		this.getComponentById('txtStreetUnitNumber').setValue(10);
		this.getComponentById('cmbStreetUnitType').setValue("APT");

		this.getComponentById('cmbStreetState').setValue("NSW");
		this.getComponentById('txtStreetPostCode').setValue("2000");
		this.getComponentById('txtStreetSuburb').setValue("Sydney");
		this.getComponentById('txtStreetNumber').setValue("20");
		this.getComponentById('txtStreetName').setValue("Kent");
		this.getComponentById('txtStreetNumber').setValue("20");
		this.getComponentById('cmbStreetType').setValue("ST");
		this.getComponentById('cmbStreetSuffix').setValue("N");

	} else if (address=='2') {
		this.getComponentById('txtIntlStreet').setValue("1 Memorial Drive");
		this.getComponentById('txtIntlState').setValue("MA");
		this.getComponentById('txtIntlPostCode').setValue("02142");
		this.getComponentById('cmbIntlCountry').setValue("1601");
	}
}

ClientMethod UpdateAddressType() [ Language = javascript ]
{
	address = this.getComponentById('cmbAddressType').getValue();
	postal=true;
	street=true;
	international=true;
	if(address==0) {
		postal=false;
	} else if (address==1) {
		street=false;
	} else if (address==2) {
		international=false;
	}
	zenPage.getComponentById('PostalAddress').setHidden(postal);
	zenPage.getComponentById('StreetAddress').setHidden(street);
	zenPage.getComponentById('InternationalAddress').setHidden(international);
}

Method Send() [ ZenMethod ]
{
	try {
		set tRequest=##class(HS.AU.Message.HI.SearchIHIRequest).%New()
		set tRequest.FamilyName=%page.%GetValueById("txtLastName")
		set tRequest.GivenName=%page.%GetValueById("txtFirstName")
		Set tDOB=%page.%GetValueById("dtDOB")
		set tRequest.DateOfBirth=$S(tDOB]"":$ZDH(tDOB,3,,,,,,,-1),1:"")
		set tRequest.Sex=%page.%GetValueById("cmbGender")
		Set tRequest.IHINumber=%page.%GetValueById("txtIHINumber")
		Set tRequest.History=%page.%GetValueById("cmbHistory")
		Set addressType = %page.%GetValueById("cmbAddressType")
		If addressType = 0 /* PostalAddress */ {
			Set tRequest.AustralianPostalAddress.PostalDeliveryGroup.PostalDeliveryNumber=%page.%GetValueById("txtPostDeliveryNumber")
			Set tRequest.AustralianPostalAddress.PostalDeliveryGroup.PostalDeliveryType=%page.%GetValueById("cmbPostDeliveryType")
			Set tRequest.AustralianPostalAddress.Postcode=%page.%GetValueById("txtPostPostCode")
			Set tRequest.AustralianPostalAddress.State=%page.%GetValueById("cmbPostState")
			Set tRequest.AustralianPostalAddress.Suburb=%page.%GetValueById("txtPostSuburb")
		} ElseIf addressType=1  /*Street address */ {
			#dim tAUStreet as HS.AU.Types.HI.Address.AustralianStreetAddressType
			Set tAUStreet=tRequest.AustralianStreetAddress
			Set tAUStreet.AddressSiteName=%page.%GetValueById("txtStreetAddressSiteName")
			Set tAUStreet.LevelGroup.LevelNumber=%page.%GetValueById("txtStreetLevelNumber")
			Set tAUStreet.LevelGroup.LevelType=%page.%GetValueById("cmbStreetLevelType")
			Set tAUStreet.UnitGroup.UnitNumber=%page.%GetValueById("txtStreetUnitNumber")
			Set tAUStreet.UnitGroup.UnitType=%page.%GetValueById("cmbStreetUnitType")
			Set tAUStreet.State=%page.%GetValueById("cmbStreetState")
			Set tAUStreet.Postcode=%page.%GetValueById("txtStreetPostCode")
			Set tAUStreet.Suburb=%page.%GetValueById("txtStreetSuburb")
			Set tAUStreet.LotNumber=%page.%GetValueById("txtStreetLotNumber")		; can't be null if StreetNumber supplied and vice versa.
			
			Set tAUStreet.StreetNumber=%page.%GetValueById("txtStreetNumber")
			Set tAUStreet.StreetName=%page.%GetValueById("txtStreetName")
			Set tAUStreet.StreetType=%page.%GetValueById("cmbStreetType")
			Set tAUStreet.StreetSuffix=%page.%GetValueById("cmbStreetSuffix")
		} ElseIf addressType=2 {
			Set tRequest.InternationalAddress.Country=%page.%GetValueById("cmbIntlCountry")
			Set tRequest.InternationalAddress.InternationalAddressLine=%page.%GetValueById("txtIntlStreet")
			Set tRequest.InternationalAddress.InternationalPostcode=%page.%GetValueById("txtIntlPostCode")
			Set tRequest.InternationalAddress.InternationalStateProvince=%page.%GetValueById("txtIntlState")
			
		}

		Set tSearchRequest = ##class(HS.AU.Message.HI.SearchIHIBatchSyncRequest).%New()
		for i=1:1:%page.%GetValueById("txtNumberOfBatchItems") {
			Set tSearchItem = ##class(HS.AU.Types.HI.SearchIHIRequestType).%New()
			Set tSearchItem.SearchIHI=tRequest
			Set tSearchItem.RequestIdentifier=$system.Util.CreateGUID()
			Do tSearchRequest.SearchIHIBatchRequest.Insert(tSearchItem)
		}
		Do tSearchRequest.AdditionalInfo.SetAt("HS.AU.HI.Consumer.Operations","Operation")

		Set tGroup=##class(HS.Test.UI.TestGroup).%New(..%ClassName(1))
		Set tTest=tGroup.NewTest(tSearchRequest,%page.%GetValueById("chkLogging"))
		Set tSC = ..Execute(tTest,tGroup)
		Do ..DisplayTestResult(tTest,tGroup) Quit:$$$ISERR(tSC)
		Set tResponse=tTest.Response
		If $IsObject(tResponse) {
			Set tResultList=tResponse.Result
			If $isObject(tResultList) {
				For tIdx = 1:1:tResultList.Count() {
					Set tResult = tResultList.GetAt(tIdx).SearchIHI
					Do ..LogMessage("ihiRecordStatus:"_tResult.IHIRecordStatus_" ihiStatus:"_tResult.IHIStatus_" ihiNumber:"_tResult.IHINumber,tGroup)
				}
			} Else {
				Do ..LogMessage("No Result",tGroup)
			}
		} Else {
			Do ..LogMessage("No Response",tGroup)
		}
	} catch ex  {
		#dim ex as %Exception.AbstractException
		Do ..LogMessage($zcvt(ex.DisplayString(),"O","JS"))
	}
	&js<zen('btnSend').setProperty('disabled',false);>
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC= ..AddServiceEntries(..#SERVICEREGISTRYENTRY) 
	Do ..SetLogging()
	If %page.TESTGROUPID]"" {
		Set tGroup = ##class(HS.Test.UI.TestGroup).%OpenId(%page.TESTGROUPID)
		If $isObject(tGroup) Do ..DisplayGroupTestResult(tGroup)
	}
	Quit tSC
}

}

/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.Background.Workflow.Template.DownloadExport Extends %CSP.Page [ System = 4 ]
{

ClassMethod OnPage() As %Status
{
	&html<
		<table>
			<tr>
				<td>
				Click <input type='button' value='Download' onclick='var link=zenPage.downloadLink(); if (link.charAt(0)=="\0") {alert(link.split("\0")[1]);} else {window.location=link;}'/> to download the temporary export file.
				<p>
				When finished click 'Completed Download' and the temporary file on the server will be removed.
				</td>
			</tr>
		</table>
	>
	Quit $$$OK
}

}

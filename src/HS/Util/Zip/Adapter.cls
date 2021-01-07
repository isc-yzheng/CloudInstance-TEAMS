Class HS.Util.Zip.Adapter Extends Ens.Adapter
{

Parameter SETTINGS = "-ZipCommand,-UnZipCommand,WorkingDirectory";

Property WorkingDirectory As %String [ InitialExpression = {##class(%File).NormalizeDirectory($zu(12)_"Temp/Zip")} ];

/// The system command to zip a file must be stored in the configuration registry, under "\ZipUtility\ZipCommand".
/// It must have "%1" in place of the path to the output zip file and should zip up the current directory.<br>
/// Examples:<br>
/// <code>"c:\program files\7-zip\7z" a %1 . -r</code> (Windows OS)<br>
/// <code>zip -rm %1 .</code> (non-Windows OS)
Method Zip(pRequest As HS.Message.ZipRequest, pResponse As HS.Message.ZipResponse) As %Status
{
	
	#define ND(%directory) ##class(%File).NormalizeDirectory(%directory)
	try {	
		Set tSC=$$$OK
		Set tSC=pRequest.NewResponse(.pResponse)
		Set tWorkingDirectory=$$$ND(..WorkingDirectory_"/"_$J_"/Files/")
		#; cleanup from any previous run
		If ##class(%File).DirectoryExists($$$ND(..WorkingDirectory_"/"_$J)) Set tSC = ##class(%File).RemoveDirectoryTree($$$ND(..WorkingDirectory_"/"_$J)) 
		Set tSC= ##class(%File).CreateDirectoryChain(tWorkingDirectory) Quit:$$$ISERR(tSC)
		#; write the files out to the directory
		For tIdx = 1:1:pRequest.Items.Count() {
			Set tItem=pRequest.Items.GetAt(tIdx)
			Set tFilePath = $$$ND(tWorkingDirectory_tItem.Path)
			Set tSC= ##class(%File).CreateDirectoryChain(tWorkingDirectory_tItem.Path) Quit:$$$ISERR(tSC)
			Set tFile = ##class(%Stream.FileBinary).%New()			
			Set tSC=tFile.LinkToFile(tFilePath_tItem.Filename) Quit:$$$ISERR(tSC)
			Set tSC= tFile.CopyFrom(tItem.File) Quit:$$$ISERR(tSC)
			Set tSC= tFile.%Save() Quit:$$$ISERR(tSC)
		}

		#; zip the directory
		Set tCurrentDirectory=$system.Process.CurrentDirectory(tWorkingDirectory)
		Set tZipFile=$$$ND(tWorkingDirectory_"..")_"z.zip"
		Set tZipCommand = ##class(HS.Registry.Config).GetKeyValue("\ZipUtility\ZipCommand")
		If (tZipCommand=""){
			Set tSC = $$$ERROR($$$GeneralError,"Missing configuration registry entry \ZipUtility\ZipCommand")
			Quit
		}
		Set tCMD = $p(tZipCommand,"%1")_tZipFile_$p(tZipCommand,"%1",2)
		Set tStatus=$zf(-1,tCMD) If tStatus Set tSC=$$$ERROR($$$GeneralError,"Unable to zip") Quit
		Set tNewDirectory=$system.Process.CurrentDirectory(tCurrentDirectory),tCurrentDirectory=""

		Set tFile=##class(%Stream.FileBinary).%New()
		Set tSC=tFile.LinkToFile(tZipFile) Quit:$$$ISERR(tSC)
		Set tSC= pResponse.File.CopyFrom(tFile) Quit:$$$ISERR(tSC)
		If ##class(%File).DirectoryExists($$$ND(..WorkingDirectory_"/"_$J)) Set tSC = ##class(%File).RemoveDirectoryTree($$$ND(..WorkingDirectory_"/"_$J)) 
	} Catch ex {
		break
		Set tSC = ex.AsStatus()
	}
	Set:$g(tCurrentDirectory)]"" tNewDirectory=$system.Process.CurrentDirectory(tCurrentDirectory)
 
	Quit tSC
}

/// Take a ZipRequest with a File and split it into items including the directory path.<br><br>
/// The system command to unzip a file must be stored in the configuration registry, under "\ZipUtility\UnZipCommand".
/// It must have "%1" in place of the path to the zip file and should unzip into the current directory.<br>
/// Examples:<br>
/// <code>"c:\program files\7-zip\7z" x %1 -o. -r</code> (Windows OS)<br>
/// <code>unzip %1 -d .</code> (non-Windows OS)
Method UnZip(pRequest As HS.Message.ZipRequest, pResponse As HS.Message.ZipResponse) As %Status
{
	
	#define ND(%directory) ##class(%File).NormalizeDirectory(%directory)
	try {
		Set tSC=$$$OK
		Set tSC=pRequest.NewResponse(.pResponse)
		Set tWorkingDirectory=$$$ND(..WorkingDirectory_"/"_$J_"/Files")
		#; cleanup from any previous run
		If ##class(%File).DirectoryExists($$$ND(..WorkingDirectory_"/"_$J)) Set tSC = ##class(%File).RemoveDirectoryTree($$$ND(..WorkingDirectory_"/"_$J)) 
		Set tSC= ##class(%File).CreateDirectoryChain(tWorkingDirectory) Quit:$$$ISERR(tSC)

		#; write out the zip file
		Set tZipDir=$$$ND(tWorkingDirectory_"../")
		Set tFile=##class(%Stream.FileBinary).%New()
		Set tSC=tFile.LinkToFile(tZipDir_"z.zip")
		Set tSC= tFile.CopyFrom(pRequest.File) Quit:$$$ISERR(tSC)
		Set tSC= tFile.%Save() Quit:$$$ISERR(tSC)
		
		Set tCurrentDirectory=$system.Process.CurrentDirectory(tWorkingDirectory)

		#; unzip the file to the directory
		Set tUnZipCommand = ##class(HS.Registry.Config).GetKeyValue("\ZipUtility\UnZipCommand")
		If (tUnZipCommand=""){
			Set tSC = $$$ERROR($$$GeneralError,"Missing configuration registry entry \ZipUtility\UnZipCommand")
			Quit
		}
		Set tCMD = $p(tUnZipCommand,"%1")_tFile.Filename_$p(tUnZipCommand,"%1",2)
		
		Set tStatus=$zf(-1,tCMD) If tStatus Set tSC=$$$ERROR($$$GeneralError,"Unable to unzip "_tCMD) Quit
		Set tSC=..GetFiles(tWorkingDirectory,.pResponse,tWorkingDirectory)
		Set tNewDirectory=$system.Process.CurrentDirectory(tCurrentDirectory),tCurrentDirectory=""

		If ##class(%File).DirectoryExists($$$ND(..WorkingDirectory_"/"_$J)) Set tSC = ##class(%File).RemoveDirectoryTree($$$ND(..WorkingDirectory_"/"_$J)) 
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Set:$g(tCurrentDirectory)]"" tNewDirectory=$system.Process.CurrentDirectory(tCurrentDirectory)
	Quit tSC
}

ClassMethod GetFiles(pWorkingDirectory, pResponse As HS.Types.Zip, pBaseDirectory) As %Status
{
	Set tQuery=##class(%ResultSet).%New("%File:FileSet")
	Set tSC= tQuery.Execute(pWorkingDirectory,"*",,1)
	While tQuery.%Next() {
		Set tFilename=tQuery.GetData(1)
		If tQuery.GetData(2)="D" Do ..GetFiles(tFilename,.pResponse,pBaseDirectory) Continue
		Set tFile=##class(%Stream.FileBinary).%New()
		Set tSC=tFile.LinkToFile(tFilename)
		Set tItem=##class(HS.Types.ZipItem).%New()
		Set tItem.Path=$p(##class(%File).GetDirectory(tFilename),pBaseDirectory,2)
		Set tItem.Filename=##class(%File).GetFilename(tFilename)
		Set tSC = tItem.File.CopyFrom(tFile)
		Do pResponse.Items.Insert(tItem)	
	}
	Quit $$$OK
}

}

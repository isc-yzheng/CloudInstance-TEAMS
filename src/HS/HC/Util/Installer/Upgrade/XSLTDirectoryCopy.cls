/// Copy contents of InstallDir/csp/xslt/ to path found in /csp/xslt application when different
Class HS.HC.Util.Installer.Upgrade.XSLTDirectoryCopy
{

ClassMethod Update(pVerbose = 0)
{
	#define ND(%1) ##class(%File).NormalizeDirectory(%1) 
	Set tXSLTDir = ##class(HS.Util.XSLTTransformer).GetXSLTDirectory()
	Set tInstallXSLTDir = $System.Util.InstallDirectory()_"csp/xslt/"
	If $$$ND(tXSLTDir) = $$$ND(tInstallXSLTDir) {
		///Nothing to copy
		Quit $$$OK
	}
	Do ..DirectoryLoop(tXSLTDir,.tTarget)
	Do ..DirectoryLoop(tInstallXSLTDir,.tInstall)
	Quit ..UpdateTargetDir(.tInstall,.tTarget,pVerbose)
}

ClassMethod DirectoryLoop(pDirectory, Output pOutput)
{
	Set pDirectory=##class(%File).NormalizeDirectory(pDirectory)
	Set:$g(pOutput)="" pOutput=pDirectory  /// remember base directory
	Set tFileSet = ##class(%ResultSet).%New("%File:FileSet")
	Do tFileSet.%Execute(pDirectory,,,1)
	While tFileSet.%Next() {
		If tFileSet.Type="D" {
			Set tName = $tr($zcvt(tFileSet.Name,"l"),"\","/")
			If $p(tName,"/",$l(tName,"/")-1)="custom" Continue  /// exclude custom folders
			Do ..DirectoryLoop(tFileSet.Name,.pOutput)
			Continue
		}
		Set tFile = ##class(%File).GetFilename(tFileSet.Name)
		continue:$zcvt(tFile,"l")=".ds_store"
		Set tDir = $P(##class(%File).GetDirectory(tFileSet.Name),pOutput,2)  /// strip off base directory
		If tDir="" Set tDir=" "
		Set pOutput(tDir,tFile)=$Piece(tFileSet.Name,pOutput,2)
	}
}

ClassMethod UpdateTargetDir(pSource, pTarget, pVerbose = 0) As %Status
{
	Set tDir = "" 
	Set tFile=""
	Set tSC = $$$OK
	For  {
		Set tDir=$O(pSource(tDir)) Quit:tDir=""
		For {
			Set tFile=$O(pSource(tDir,tFile),1,tFilename) Quit:tFile=""
			If '$D(pTarget(tDir)) {
				Set tSC1 = ##class(%File).CreateDirectoryChain(pTarget_tDir)
				If pVerbose {
					Write !," Created directory "_pTarget_tDir_" Status:"_tSC1
				}
				Set tSC=$$$ADDSC(tSC,tSC1)
			}
			If '$D(pTarget(tDir,tFile)) { 
				Set tSC1 = ##class(%File).CopyFile(pSource_tFilename,pTarget_tFilename)
				If pVerbose {
					Write !," Copied "_pSource_tFilename_" to "_pTarget_tFilename_" Status:"_tSC1
				}
				Set tSC = $$$ADDSC(tSC,tSC1)
			}
		}
	}
	/*  Removal of old xslt's (removed due to unintended removal of customer custom xslt's).  Could be re-worked to ignore CUSTOM folders
	For  {
		Set tDir=$O(pTarget(tDir)) Quit:tDir=""
		For {
			Set tFile=$O(pTarget(tDir,tFile),1,tFilename) Quit:tFile=""
			If '$D(pSource(tDir,tFile)) {
				Set tSC1 = ##class(%File).Delete(pTarget_tFilename)
				If pVerbose {
					Write !," Removed "_pTarget_tFilename_" Status:"_tSC1
				}
				Set tSC=$$$ADDSC(tSC,tSC1)
			}
		}
	}
	*/
	Quit tSC
}

}

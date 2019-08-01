$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$name = 'jcliff'
$version = $env:chocolateyPackageVersion
$name_version = "$name-$version"
$jcliff_home = Join-Path $toolsDir $name_version
$jcliff_bat = Join-Path $jcliff_home 'jcliff.bat'

$url = "https://github.com/bserdar/jcliff/releases/download/v$version/jcliff-$version-dist.tar.gz"

# Delete leftovers from previous versions
Remove-Item "$(Join-Path $toolsDir 'jcliff-*')" -Force -Recurse

Install-ChocolateyZipPackage `
    -PackageName $name `
    -Url $url `
    -UnzipLocation $toolsDir

$File = Get-ChildItem -File -Path $toolsDir -Filter *.tar

Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $toolsDir

Remove-Item -Path $File.FullName

Install-ChocolateyEnvironmentVariable `
    -VariableName 'JCLIFF_HOME' `
    -VariableValue $jcliff_home `
    -VariableType 'Machine'

Install-BinFile -Name 'jcliff' -Path $jcliff_bat

$jbossEnvVar = [Environment]::GetEnvironmentVariable('JBOSS_HOME')

if(!$jbossEnvVar) {
    Write-Host "  JBOSS_HOME Environment Variable Referencing the JBoss Server Location Must Be Set Prior to Running jcliff"
}
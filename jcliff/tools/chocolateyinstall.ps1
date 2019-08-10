$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$name = 'jcliff'
$checksum = '04E1A0E5AA40DD2DCCFDAF9C093BD8227E27B122DEAD8A623012F4E9031593AC'
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
    -Checksum $checksum `
    -ChecksumType 'sha256' `
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

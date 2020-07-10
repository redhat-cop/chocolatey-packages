$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$name = 'jcliff'
$checksum = '1738fe4cb8a863e6c609538aad85c1ccbe73ba6326ba7cc1cc186fbb9cd13fd7'
$version = $env:chocolateyPackageVersion
$name_version = "$name-$version"
$jcliff_home = Join-Path $toolsDir $name_version
$jcliff_bat = Join-Path $jcliff_home 'jcliff.bat'

$url = "https://github.com/bserdar/jcliff/releases/download/v$version/jcliff-$version-dist.tar.gz"

# Delete leftovers from previous versions
Remove-Item "$(Join-Path $toolsDir 'jcliff-*')" -Force -Recurse -ErrorAction Ignore

Install-ChocolateyZipPackage `
    -PackageName $name `
    -Url $url `
    -Checksum $checksum `
    -ChecksumType 'sha256' `
    -UnzipLocation $toolsDir

$File = Get-ChildItem -File -Path $toolsDir -Filter *.tar

Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $toolsDir

Remove-Item -Path $File.FullName -ErrorAction Ignore

Install-ChocolateyEnvironmentVariable `
    -VariableName 'JCLIFF_HOME' `
    -VariableValue $jcliff_home `
    -VariableType 'Machine'

Install-BinFile -Name 'jcliff' -Path $jcliff_bat

$jbossEnvVar = [Environment]::GetEnvironmentVariable('JBOSS_HOME')

if(!$jbossEnvVar) {
    Write-Host "  JBOSS_HOME Environment Variable Referencing the JBoss Server Location Must Be Set Prior to Running jcliff"
}

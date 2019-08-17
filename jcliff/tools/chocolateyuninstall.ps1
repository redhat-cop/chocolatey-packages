$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$name = 'jcliff'
$version = $env:chocolateyPackageVersion
$name_version = "$name-$version"
$jcliff_home = Join-Path $toolsDir $name_version
$jcliff_bat = Join-Path $jcliff_home 'jcliff.bat'

Install-ChocolateyEnvironmentVariable `
    -VariableName 'JCLIFF_HOME' `
    -VariableValue $null `
    -VariableType 'Machine'

Remove-Item $jcliff_home -Recurse -Force -ErrorAction Ignore
Uninstall-BinFile -Name 'jcliff' -Path $jcliff_bat
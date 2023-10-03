Function Remove-ValueFromEnvironmentVariable {
  param (
    [String] $Variable,
    [String] $Value,
    [String] $Scope
  )

  $var = [System.Environment]::GetEnvironmentVariable($Variable, $Scope)
  if ($var -ne $null) {
    $var = ($var.Split(";") | Where-Object { $_ -ne $Value }) -join ";"
    [System.Environment]::SetEnvironmentVariable($Variable, $var, $Scope)
  }
}

$LocalAppDataDirectory = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::LocalApplicationData)
$LibraryDirectory = "$LocalAppDataDirectory\Svetovid Library"
$LibraryFile = "svetovid-lib.jar"
$LibraryPath = "$LibraryDirectory\$LibraryFile"

Remove-Item $LibraryDirectory -Recurse

Remove-ValueFromEnvironmentVariable "CLASSPATH" $LibraryPath "User"

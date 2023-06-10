Function Test-EnvironmentVariableContainsValue {
  param (
    [String] $Variable,
    [String] $Value,
    [String] $Scope
  )

  $var = [System.Environment]::GetEnvironmentVariable($Variable, $Scope)
  If ($var -ne $null) {
    Return $var -split ";" -contains $Value
  }
  Return $false
}

$FileUrl = "https://svetovid.org/lib/svetovid-lib.jar"
$LibraryDirectory = "\Program Files\Svetovid Library"
$LibraryFile = "svetovid-lib.jar"
$LibraryPath = "$LibraryDirectory\$LibraryFile"

If (-Not(Test-Path -Path $LibraryDirectory)) {
  New-Item -ItemType Directory -Path $LibraryDirectory
}

If (-Not(Test-Path -Path $LibraryPath)) {
  [Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"
  Invoke-WebRequest $FileUrl -OutFile $LibraryPath
}

If (-Not(Test-EnvironmentVariableContainsValue "CLASSPATH" $LibraryPath "Machine")) {
  [System.Environment]::SetEnvironmentVariable("CLASSPATH", $Env:CLASSPATH + ";$LibraryPath", "Machine")
}

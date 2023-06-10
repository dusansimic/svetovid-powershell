Function Request-PrivilegeElevation {
  if (-Not
    (New-Object Security.Principal.WindowsPrincipal(
      [Security.Principal.WindowsIdentity]::GetCurrent()
    )).IsInRole(
      [Security.Principal.WindowsBuiltInRole]::Administrator
    )
  ) {
    Start-Process `
      -FilePath 'powershell' `
      -ArgumentList (
        '-File', $MyInvocation.MyCommand.Source, $args `
        | ForEach-Object{ $_ }
      ) `
      -Verb RunAs
    exit
  }
}

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

Request-PrivilegeElevation

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

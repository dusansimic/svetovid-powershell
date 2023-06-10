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

$LibraryDirectory = "\Program Files\Svetovid Library"
$LibraryFile = "svetovid-lib.jar"
$LibraryPath = "$LibraryDirectory\$LibraryFile"

Request-PrivilegeElevation

Remove-Item $LibraryDirectory -Recurse

Remove-ValueFromEnvironmentVariable "CLASSPATH" $LibraryPath "Machine"

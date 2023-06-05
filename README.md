# Svetovid installation script for Windows

[Svetovid](https://github.com/ivanpribela/svetovid-lib) is a supplement Library for introductory
programming courses in Java.

This repo contains PowerShell scripts that automate the process of installation and configuration of
this library so students can get started with coding ASAP. For now it requires administrator
privileges but the goal is to enable installation with both using the admin and regular user
privileges.

## Usage

### Installation

Download the script. Once it's downloaded, right click on the `install.ps1` script and run it as
administrator. This will automatically download Svetovid library and configure CLASSPATH variable
in the machine scope.

Once the installation is complete, restart the machine.

### Uninstall

To remove the Svetovid library and the CLASSPATH entry, just run the `uninstall.ps1` script the same
way as the installation script.

## Author

- Dušan Simić <<dusan.simic1810@gmail.com>>

## License

MIT

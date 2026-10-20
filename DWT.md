# About the dwt-1.25.2733.0 branch

A personal build of Windows Terminal, "DuplicatableWindowsTerminal (dwt)",
based on the stable release v1.25.2733.0 with a `duplicateWindow` action added.


## Building

Requirements: Visual Studio 2026 (v145 toolset) + Windows SDK 10.0.26100

```cmd
build-dwt.cmd
```

Builds `CascadiaPackage` (msix) in Release x64 with Release branding.
The only differences from the official release binaries are the lack of
PGO and code signing.

## Creating the distribution folder

After building, generate the unpackaged (portable) distribution:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -Command "& build\scripts\New-UnpackagedTerminalDistribution.ps1 -TerminalAppX src\cascadia\CascadiaPackage\AppPackages\CascadiaPackage_1.0.0.0_x64_Test\CascadiaPackage_1.0.0.0_x64.msix -XamlAppX packages\Microsoft.UI.Xaml.2.8.4\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.8.appx -Destination bin\dist -PortableMode"
```

**Note**: run this with pwsh 7. Windows PowerShell 5.1 misreads makepri's
UTF-8 dump XML on Japanese-locale systems (CP932), which breaks the PRI
merge step.

Extract the generated zip, then:

1. Rename `WindowsTerminal.exe` to `DuplicatableWindowsTerminal.exe`.
2. Rename `wt.exe` to `dwt.exe` (the shim; it launches the main executable
   in the same folder).
3. To share settings with the installed packaged Windows Terminal, turn
   `settings` into a junction:

```cmd
mklink /J settings %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
```

Because of the `.portable` marker the build runs in portable mode, and the
junction makes it read and write the installed Terminal's settings.json /
state.json directly.

## Directory inheritance

For `duplicateWindow` and friends to inherit the current directory, the
shell must report its CWD via OSC 9;9:

- PowerShell: emit `$e]9;9;"<path>"$e\` from the prompt function in `$PROFILE`
- cmd: set the `PROMPT` environment variable to `$e]9;9;$P$e\$P$G`

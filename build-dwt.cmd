@echo off
call "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64
cd /d D:\src\cwt
set PATH=D:\src\cwt\dep\nuget;%PATH%
nuget restore D:\src\cwt\OpenConsole.slnx -Verbosity quiet
nuget restore D:\src\cwt\dep\nuget\packages.config -Verbosity quiet -PackagesDirectory D:\src\cwt\packages
msbuild D:\src\cwt\OpenConsole.slnx /p:Configuration=Release /p:Platform=x64 /p:WindowsTerminalBranding=Release /p:AppxSymbolPackageEnabled=false /t:Terminal\CascadiaPackage /m /v:m

$flutter = 'D:\flutter\flutter\flutter\bin\flutter.bat'

Set-Location -LiteralPath $PSScriptRoot
& $flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080

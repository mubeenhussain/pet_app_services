# Pet App — quick setup (Windows)

$FlutterHome = "C:\Users\Mubeen\flutter"
$FlutterBin = Join-Path $FlutterHome "bin"

if ($env:Path -notlike "*$FlutterBin*") {
    Write-Host "Adding Flutter to PATH for this session..."
    $env:Path = "$FlutterBin;$env:Path"
}

Set-Location $PSScriptRoot

Write-Host "Running flutter pub get..."
flutter pub get

Write-Host ""
Write-Host "Next steps:"
Write-Host "1. flutterfire configure"
Write-Host "2. firebase emulators:start"
Write-Host "3. flutter run -t lib/main.dart --dart-define=GOOGLE_MAPS_API_KEY=your_key"
Write-Host ""
Write-Host "Flutter SDK: $FlutterHome"

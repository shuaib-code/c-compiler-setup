# Download and install TDM-GCC 64-bit
$downloadUrl = "https://github.com/jmeubank/tdm-gcc/releases/download/v10.3.0-tdm64-2/tdm64-gcc-10.3.0-2.exe"
# $expectedSha256 = "VERIFY_CHECKSUM_FROM_GITHUB_RELEASE_PAGE" # Replace with actual SHA256 from https://github.com/jmeubank/tdm-gcc/releases
$installerFile = "$env:TEMP\tdm64-gcc-10.3.0-2.exe"
$installDir = "$env:ProgramFiles\TDM-GCC-64"

# Download the installer
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerFile

# Verify SHA256 checksum (optional, replace with actual checksum or comment out if unavailable)
# $hash = Get-FileHash -Path $installerFile -Algorithm SHA256
# if ($hash.Hash -ne $expectedSha256 -and $expectedSha256 -ne "VERIFY_CHECKSUM_FROM_GITHUB_RELEASE_PAGE") {
#     Write-Error "SHA256 checksum verification failed! Expected: $expectedSha256, Got: $($hash.Hash)"
#     Remove-Item $installerFile
#     exit 1
# }

# Install TDM-GCC silently
Start-Process -FilePath $installerFile -ArgumentList "/S /D=$installDir" -Wait
Remove-Item $installerFile

# Add to user PATH if not already present
$binPath = "$installDir\bin"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notmatch [regex]::Escape($binPath)) {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$binPath", "User")
}

# Add Run-Code function to PowerShell profile
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
}

$functionDef = @'
function runc {
    param (
        [Parameter(Mandatory=$true)]
        [string]$file
    )
    $ext = [System.IO.Path]::GetExtension($file)
    $compiler = if ($ext -eq ".cpp") { "g++" } elseif ($ext -eq ".c") { "gcc" } else { throw "Unsupported file type: Use .c or .cpp" }
    $output = "temp.exe"
    & $compiler $file -o $output
    if ($LASTEXITCODE -eq 0) {
        .\$output
        Remove-Item $output
    } else {
        Write-Error "Compilation failed"
    }
}
'@

Add-Content -Path $profilePath -Value $functionDef

Write-Host "Installation complete. Restart PowerShell or run '. $PROFILE' to load changes."
Write-Host "Usage example: runc file.cpp"
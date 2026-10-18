<#
.SYNOPSIS
    Collects basic information about a Windows computer.

.DESCRIPTION
    Get-SystemInfo gathers key details about the local Windows computer,
    such as the operating system, hardware, memory, disk space, network
    and uptime, and displays them in one easy-to-read summary.
    The script only reads information. It does not change any settings.

.EXAMPLE
    .\Get-SystemInfo.ps1

    Displays a system information summary for this computer.

.NOTES
    Author:   Susan Oyediran
    Version:  1.0
    Requires: Windows, PowerShell 5.1 or later
#>

# --- Collect operating system information ---
$os = Get-CimInstance -ClassName Win32_OperatingSystem

$os.CSName
$os.Caption
$os.Version
# --- Collect hardware information ---
$computer  = Get-CimInstance -ClassName Win32_ComputerSystem
$processor = Get-CimInstance -ClassName Win32_Processor

$computer.Manufacturer
$computer.Model
$processor.Name
[math]::Round($computer.TotalPhysicalMemory / 1GB, 1)

# --- Collect disk information for the C: drive ---
$disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
[math]::Round($disk.Size / 1GB, 1)
[math]::Round($disk.FreeSpace / 1GB, 1)



# --- Work out how long since the last restart ---
$uptime = (Get-Date) - $os.LastBootUpTime

$uptime.Days
$uptime.Hours

# --- Collect network information ---
$network = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway }

$network.IPv4Address.IPAddress
function Get-SystemInfo {

<#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers
.DESCRIPTION
Get-SystemInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP Address
.PARAMETER ComputerName
One or more computer names or IP Addresses, up to a maximum
of 10.
.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\retry.txt
.PARAMETER LogErrors
Specify this switch to create a text log files of computers 
that could not be queried.
.EXAMPLE
Get-Contrent names.txt | Get-SystemInfo
.EXAMPLE
Get-SystemInfo -computername Server1,Server2
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True, 
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP Address")]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]] $ComputerName,
        
        [string] $ErrorLog = 'c:\retry.txt',

        [switch] $LogErrors
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $ComputerName) {
            Write-Verbose "Querying $computer"
            $os = Get-WmiObject -Class win32_operatingSystem `
                                -computername $Computer

            $comp = Get-WmiObject -Class Win32_ComputerSystem `
                                  -ComputerName $computer

            $bios = Get-WmiObject -Class Win32_BIOS `
                                  -ComputerName $computer

            $props = @{'ComputerName' = $computer;
                       'OSVersion' = $os.version;
                       'SPVersion' = $os.servicepackmajorversion;
                       'BIOSSerial' = $bios.serialnumber;
                       'Manufacturer' = $comp.manufacturer;
                       'Model' = $comp.model}
            Write-Verbose "WMI queries complete"
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {}
}
#Write-Host "--------  PIPELINE MODE --------"
#'localhost', 'OKPAL434654' | Get-SystemInfo -Verbose

#Write-Host "--------  PARAM MODE --------"
#Get-SystemInfo #-host localhost, OKPAL434654 -Verbose
#Get-systeminfo -host one,two,three,four,five,six,seven,eight,nine,ten,eleven
help get-systeminfo -full

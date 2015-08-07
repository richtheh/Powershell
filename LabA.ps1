function Get-ComputerDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [string[]] $ComputerName,
        
        [string] $ErrorLog
    )
    BEGIN {
        Write-Verbose "Starting Get-computerdetails"
    }
    PROCESS {
        foreach ($computer in $ComputerName) {
            Write-Verbose "Querying $computer"

            $os = Get-WmiObject -Class win32_operatingSystem `
                                -computername $Computer

            $comp = Get-WmiObject -Class Win32_ComputerSystem `
                                  -ComputerName $computer

            $bios = Get-WmiObject -Class Win32_BIOS `
                                  -ComputerName $computer

            $props = @{'ComputerName' = $computer;
                       'Workgroup' = $comp.workgroup;
                       'AdminPassword' = switch($comp.adminpasswordstatus){
                            1 {"Disabled"}
                            2 {"Enabled"}
                            3 {"NA"}
                            4 {"Unknown"}
                                         };
                       'Model' = $comp.model;
                       'Manufacturer' = $comp.manufacturer;
                       'BIOSSerial' = $bios.serialnumber;
                       'OSVersion' = $os.version;
                       'SPVersion' = $os.servicepackmajorversion
                       }

            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {
        Write-Verbose "Stopping Get-ComputerDetails"
    }
}

#Get-ComputerDetails -ErrorLog x.txt -ComputerName localhost, OKPAL434654
"localhost" | Get-ComputerDetails -Verbose

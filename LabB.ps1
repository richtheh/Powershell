function Get-DiskDetails {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName,
        
        [string] $ErrorLog
    )
    BEGIN {
    }
    PROCESS {
        foreach ($computer in $ComputerName) {

            $os = Get-WmiObject -Class win32_operatingSystem `
                                -computername $Computer

            $comp = Get-WmiObject -Class Win32_ComputerSystem `
                                  -ComputerName $computer

            $disk = Get-WmiObject -Class Win32_LogicalDisk `
                                  -ComputerName $computer

            $props = @{'ComputerName' = $computer;
                       'Freespace' = $disk.freespace;
                       'Drive' = $disk.name;
                       'Volume' = $disk.volumename;
                       'DriveType' = $disk.drivetype;
                       'Size' = $disk.size}

            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {}
}

Get-DiskDetails -ErrorLog x.txt -ComputerName localhost


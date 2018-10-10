#Requires -RunAsAdministrator
function Get-VSSWriters {
     <#
    .Synopsis
       Performs VSSAdmin list writers
    .DESCRIPTION
       Gets the VSS Writers and outputs it as a object.
    .EXAMPLE
       Get-VSSWriters
    .NOTES
       Uses regex to get the information and then splits it into objects.
    #>
    Begin {
        [string]$vssWriters = (vssadmin list writers) | Out-String
        #Regex to findthe first line and then its proceeding 4 lines
        $reg = [regex]::matches($vssWriters, '(Writer name:.*\n.*\n.*\n.*\n.*)')
        $vssObject = @()
        $VSSOutput = @()
        $VSS = @()

    }

    Process {
        #loop thought the regex matches and split them into their properties.
        foreach($value in $reg.value){
            $vssObject = New-Object PSCustomObject -Property([ordered]@{
                WriterName = ([regex]::Match($value,"Writer name: \'(.*)\'")).groups[1].value
                WriterId = ([regex]::Match($value,"Writer Id: (.*)")).groups[1].value
                WriterInstanceId = ([regex]::Match($value,"Writer Instance Id: (.*)")).groups[1].value
                State = ([regex]::Match($value,"State: \[(.)\]")).groups[1].value
                StateInfo = ([regex]::Match($value,"State: \[(.)\] (.*)")).groups[2].value
                LastError = ([regex]::Match($value,"Last error: (.*)")).groups[1].value
            })
        $VSSOutput += $vssObject
}
    }

    End {
        $VSSOutput
    }
}

Get-VSSWriters




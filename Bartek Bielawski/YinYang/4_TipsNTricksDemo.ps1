﻿#region DPS
throw "Hey, Dory! Forgot to use F8?"
#endregion

#region WhatIsYourName

Get-Help -Name Rename-Item -Parameter NewName
Get-Help -Name New-ADUser -Parameter Name

ls ?_*.* | Rename-Item -NewName { $_.Name -replace '^(\d)', '0$1' } -WhatIf

Push-Location ad:
@'
Imie,Nazwisko
James,Bond
Robin,Hood
'@ | ConvertFrom-Csv | New-ADUser -Name { '{0}, {1}' -f $_.Nazwisko, $_.Imie } -WhatIf

Pop-Location
#endregion

#region wildcards
Get-VM -Name D*
Get-VM -Name DuPSUG003[4-7]
Get-Service [ad][eil]*

ls c:\pr*\a*\a*\*.exe | % FullName
ls c:\*.exe -Recurse | Select-Object -First 5 | % FullName
cat c:\w*\sy*\dr*\e*\host	# <TAB>!
#endregion

#region variable == file

Push-Location -Path C:\Windows\System32\drivers\etc
${c:hosts}
${c:hosts} += '127.0.0.1   bielawb.org'
ping bielawb.org
Get-Content c:hosts -Raw | Set-Content variable:hostFile
$hostFile

Set-Content function:test-foo -Value 'echo test'
test-foo

#endregion

#region assign result of condition to variable
$logicalCondition = $true -eq 'False'
$result = if ($logicalCondition) {
    'true'
} else {
    'false'
}
#endregion

#region multiple variables at once

$parameter = 'one'

$one, $two, $three = switch ($parameter) {
    one {
        'And one...'
        'And two...'
        'And three...'
    }
    two {
        'And two...'
        'And three...'
        'And four...'
    }
}

#endregion

#region New syntax with .Where ...
$collection = 1, 2, 3, 2, 1
$collection.Where{ $_ -gt 1 }

$collection.Where(
    { $_ -gt 1},			# Condition...
    'SkipUntil'				# Mode...
)

$first, $second = $collection.Where(
    { $_ -gt 1},			# Condition...
    'Split',					# Mode...
    2						# Total count...
)

"First: $first"
"Second: $second"

#endregion

#region New syntax with .foreach
$cim
Get-DnsServerZone -Name *.168.192.in-addr.arpa -CimSession $cim
Get-DnsServerZone -Name (1,7,15).ForEach{"$_.168.192.in-addr.arpa"} -CimSession $cim

Get-DnsServerResourceRecord -Name 20* -ZoneName 7.168.192.in-addr.arpa -CimSession $cim
Get-DnsServerResourceRecord -Name (200..203) -ZoneName 7.168.192.in-addr.arpa -CimSession $cim
(200..203).ForEach{ Get-DnsServerResourceRecord -Name $_ -ZoneName 7.168.192.in-addr.arpa -CimSession $cim }

Get-Service (echo mgmt RM).ForEach{"Win$_"}
Get-Service Win*
#endregion

#region can has git alias?

Start-Process -FilePath https://en.wikipedia.org/wiki/LOLCODE

$gitAliases = 
    (git config --global -l).Where{ 
            $_ -match '^alias\.'
        }.ForEach{
            $_ -replace '^alias\.(\w+).*', '$1'
        }

$ExecutionContext.InvokeCommand.CommandNotFoundAction = { 
    param ($name, $eventArgs) 
    if ($name -in $gitAliases) { 
        $alias = $name
    } elseif ($aliases = $gitAliases -match [regex]::Escape($name)) { 
        $alias = $aliases | 
            Sort-Object -Property Length  | 
            Select-Object -First 1 
    } 
    
    if ($alias) { 
        $eventArgs.CommandScriptBlock = { git $alias @args }.GetNewClosure()
    } 
}

hai
gimmeh origin master

Set-Content -Path .\Test.txt -Value 'Some text' -Encoding Ascii

uppin .\Test.txt
awsum -m 'Adding/removing Test.txt'
kthx

Set-Content -Path .\Test.txt -Value 'Some other text' -Encoding Ascii
hai
plz
uppin *
onoes
kthxbye

# What if tab-completing folder names in the first token actually *would* make sense...?
$ExecutionContext.InvokeCommand.CommandNotFoundAction = { 
    param ($name, $eventArgs)
    if (Test-Path -Path $name -PathType Container) {
        $eventArgs.CommandScriptBlock = { Set-Location -LiteralPath $name }.GetNewClosure()
    }
}

#endregion

#region Where-Object/Foreach-Object 

# can take wildcards... 
ls | % at*
ls | ? le* -gt 4KB

# foreach with method and parameters...
'foo' | % rep* o a
[regex]'(?<=\b)\w' | % Replace 'my awesome title' { $args[0].Value.ToUpper() }

# Why stop there... ;)
[regex]'(?<=\b)\w' | % re* 'my awesome title' { $args | % v* | % *per }

#endregion

#region First come, first serve....
if ($true -or $(Start-Sleep -Seconds 3; $true)) {
    'True!'
}

if ($(Start-Sleep -Seconds 3; $true) -or $true) {
    'False!'
}

if ($false -and $(Start-Sleep -Seconds 3; $false)) {
    'False!'
}

if ($(Start-Sleep -Seconds 3; $false) -and $false) {
    'False!'
}
#endregion

#region *Variable
Get-Date -OutVariable data2
$data2.DayOfWeek

Get-Process -Id 13 -ErrorAction SilentlyContinue -ErrorVariable myError
$myError[0].Exception.Message

Get-ChildItem -Path C:\temp -PipelineVariable filetje -File |
    Get-Acl -PipelineVariable acltje |
    ForEach-Object Access |
    Select-Object FileSystemRights, IdentityReference, 
    @{
        Name = 'The Owner'
        Expression = { $acltje.Owner -replace '^.*\\' }
    }, @{
        Name = 'The Name'
        Expression = { $filetje.Name }
    }  -First 10 |
    Format-Table

#endregion

#region Caret and dollar
.\BrokenScript.ps1 -Id 13
sbp $^ 7
.\BrokenScript.ps1 -Id 13

gps | select Name, Id, VM | epcsv -not C:\Users\Bartek\Documents\process.csv
ii $$

#endregion

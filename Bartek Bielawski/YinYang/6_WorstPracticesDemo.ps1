﻿#region DPS
throw "Hey, Dory! Forgot to use F8?"
#endregion

#region Regex hammer in hand - see nails everywhere
$xml = @'
<xml>
    <ad>
        <user>Domain\User</user>
    </ad>
    <local>
        <Mine>
            <User>Administrator</User>
        </Mine>
    </local>
</xml>
'@

#region nope!
$xml -replace '(?<=<user>).*(?=</user>)', 'Domain\MrBeans'
#endregion

#region yes, yes, yes!
$element = Select-Xml -XPath //ad/user -Xml ([xml]$xml)
# XPath //user same effect - in XML/XPath size does matter
$element.Node.InnerText = 'Domain\MrBeans'
$element.Node.OwnerDocument.OuterXml
#endregion

#region links
Start-Process http://bit.ly/HeComesXml
Start-Process http://bit.ly/HeComesTShirt
#endregion
#endregion

#region I have LINQ and I won't hesitate to USE IT!

function Measure-CommandEx {
    param (
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock,
        [int64]$Count = 1e4,
        [switch]$ShowResult
    )
    1..$Count | ForEach-Object {
        Measure-Command -Expression $ScriptBlock
    } | Measure-Object -Sum -Average -Property TotalMilliseconds | Select-Object Average, @{
        Name = 'Count'
        Expression = { $Count }
    }, @{
        Name = 'Result'
        Expression = { if ($ShowResult) { & $ScriptBlock }}
    }, @{
        Name = 'FirstLine'
        Expression = { ($ScriptBlock.ToString() -split "`n")[1]}
    }
}

foreach ($taskPath in 'Task\Path', 'Task\Path\') {
    Write-Verbose "Variable value: $taskPath" -Verbose
    #region hell-no!
    # Piece of  AUTHENTIC code... no finger pointing...
    Measure-CommandEx -ShowResult {
        $lastChar = [System.Linq.Enumerable]::ToArray($taskPath) | select -Last 1
        if ($lastChar -ne "\")
        {
            $taskPath + "\";
        }
        else
        {
            $taskPath
        }
    }
    #endregion
    
    #region yes
    # KISS
    
    # regex magic...
    Measure-CommandEx -ShowResult {
        $taskPath -replace '(?<!\\)$', '\'
    }
    
    # even simpler...
    Measure-CommandEx -ShowResult {
        if ($taskPath -notmatch '\\$') {
            "$taskPath\"
        } else {
            $taskPath
        }
    }
    
    # We can 'like' it too....
    Measure-CommandEx -ShowResult {
        if ($taskPath -notlike '*\') {
            "$taskPath\"
        } else {
            $taskPath
        }
    }
    #endregion
}


#endregion

#region True, false...
$true -eq 'False'
'False' -eq $true

if ((Test-Path -LiteralPath C:\temp) -eq $true) {
    # well....
    (Get-Command -Name Test-Path).OutputType
}

$path = '\\server\share\folder\file.txt'

if ($path -match '^\\\\') {
    $unc = $true
}

# but...
$unc = $path -match '^\\\\'
$unc = $path -like '\\*'

#endregion

#region backtick...
#region ouch!
Get-Service -DisplayName Application* | ForEach-Object
{
    'HELP!!!!'
}

Get-Service -DisplayName Application* | ForEach-Object `
{
    'Backtick save me! I see {0}' -f $_.Name
}

Get-Service -DisplayName Application* | ForEach-Object ` 
{
    'Backtick save me! I see {0}' -f $_.Name
}

Get-Service `
| ForEach-Object `
{
    $_.Name
}
#endregion

#region breaking it right
Get-Service | 
    ForEach-Object {
    $_.
        Name
}

# other examples:
$list = 
    1,
    2

$brackets = (
    'doing something cool...'
)

[math]::
E
#endregion

# But long commands...

#region ouch!
Send-MailMessage -From bartek.bielawski@live.com `
    -To Jaap@dupsug.nl `
    -Subject 'DuPSUG - here I come!' `
    -Body @'

    Hi Jaap!

    As promised - I'm here!
'@ `
    -SmtpServer mail.server.org
#endregion

#region splatting
$splattedParameters = @{
    From = 'bartek.bielawski@live.com'
    To = 'Jaap@dupsug.nl'
    Subject = 'DuPSUG - here I come!'
    Body = @'

    Hi Jaap!

    As promised - I'm here!
'@
    SmtpServer = 'mail.server.org'
}

Send-MailMessage @splattedParameters


#endregion
#endregion

#region KiBi, MiBi, PiPi...
#region whaaaat?
Get-Disk | Where-Object { $_.Size -gt 1024 * 1024 * 1024 * 500}
$4gb = 4294967296
Get-VM | Where-Object { $_.MemoryStartup -ge $4gb }
#endregion
#region But....?
4GB
1e11
1.24e-2
0x0010
#endregion
#region Warning...
Get-CimInstance Win32_LogicalDisk -Filter "Size > 300GB"
# sub-expression to the rescue!
Get-CimInstance Win32_LogicalDisk -Filter "Size > $(300GB)"
#endregion
#endregion

#region Too smart is not that great...

foreach ($mode in 'Windows', 'Mixed') {
    "Mode is: $mode"
    # smart...
    switch ($Mode) {
        Windows { 1 }
        Mixed { 2 }
    }

    # too smart?
    1 + ($mode -eq 'Mixed')
    '=' * 20
}

#endregion

#region switch it off!
function Invoke-Annoyance {
    param (
        [switch]$On = $true
    )

    if ($On) {
        "It's on!"
    } else {
        "It's off!"
    }
}

Invoke-Annoyance -On
Invoke-Annoyance 
Invoke-Annoyance -On:$false

function Invoke-Sanity {
    param (
        [switch]$Off
    )

    if ($Off) {
        "It's off!"
    } else {
        "It's on!"
    }
}

Invoke-Sanity 
Invoke-Sanity -Off

#endregion

#region Error is error
try {
    Get-Process -Id 13
} catch {
    Write-Warning "It exploded, but I guess you don't care...?"
}

#endregion

#region promises, promises
function Add-Two {
    param (
        [Parameter(ValueFromPipeline)]
        [Int]$Number
    )
    
    $Number + 2
}

1,2,3 | Add-Two

Get-Command Remove-RDRemoteApp | ForEach-Object ScriptBlock

function Stop-It {
    [CmdletBinding(
            SupportsShouldProcess,
            ConfirmImpact = 'High'
    )]
    param ()
    
    New-Item C:\temp\foo.bar -Force
    if ($PSCmdlet.ShouldProcess('Stoping it')) {
        Write-Warning 'I stopped it'
    }
}

Stop-It
Stop-It -Confirm
#endregion

#region broken code

function Get-Broken {
    param (
        [Parameter(ValueFromPipeline)]
        [String]$Text
    )
    process {
        if ($Text -match 'Broken') {
            break
        } else {
            $Text
        }
    }
}

'foo', 'bar', 'broken', 'somethingElse' | Get-Broken | ForEach-Object { 'I got: {0}' -f $_ }

function Get-Return {
    param (
        [Parameter(ValueFromPipeline)]
        [String]$Text
    )
    process {
        if ($Text -match 'Broken') {
            return
        } else {
            $Text
        }
    }
}

'foo', 'bar', 'broken', 'somethingElse' | Get-Return | ForEach-Object { 'I got: {0}' -f $_ }


#endregion

#region What if... Hi, I'm Dory!

#region Thou shalt not change the system
Get-SmbShare -Name Temp
New-SmbShare -Path C:\temp -Name Temp -WhatIf
Get-SmbShare -Name Temp
#endregion

#endregion


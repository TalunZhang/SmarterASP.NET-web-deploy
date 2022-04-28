
$msdeploy = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe";

$source = $args[0]
$destination = $args[1]
$recycleApp = $args[2]
$computerName = $args[3]
$username = $args[4]
$password = $args[5]
$delete = $args[6]

$computerNameArgument = $computerName + '/MsDeploy.axd?site=' + $recycleApp

$directory = Split-Path -Path (Get-Location) -Parent
$baseName = (Get-Item $directory).BaseName
$contentPath = Join-Path(Join-Path $directory $baseName) $source

$targetPath = $recycleApp + $destination

[System.Collections.ArrayList]$msdeployArguments = 
    "-verb:sync",
    "-allowUntrusted",
    "-enableRule:DoNotDeleteRule"
    "-enableRule:AppOffline"
    "-disableLink:AppPoolExtension",
    "disableLink:ContentExtension",
    "-disableLink:CertificateExtension"
    "-source:contentPath=${contentPath}," +
    ("-dest:auto" + 
        "contentPath=${targetPath}," +
        "computerName=${computerNameArgument}," + 
        "username=${username}," +
        "password=${password}," +
        "IncludeAcls='False," +
        "AuthType='Basic'"
    )

if ($delete -NotMatch "true")
{
    $msdeployArguments.Add("-enableRule:DoNotDeleteRule")
}

& $msdeploy $msdeployArguments
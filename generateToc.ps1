#New-Item -Path . 

$file = "goldTracker"
$input_file = $file + ".toc"
$output_file = $file + ".txt"
$core = "core"
$exclusion = @("dataManagement.lua", "graphM.lua")

$init = 
"## Interface: 100007
## Title: goldTracker
## Author: Fixer
## Version: 0.7
## SavedVariablesPerCharacter: GTMoney

libs/LibDBIcon-1.0/embeds.xml
libs/LibDBIcon-1.0/LibDBIcon-1.0/lib.xml

libs/LibGraph-2.0/LibStub.lua
libs/LibGraph-2.0/LibGraph-2.0/LibGraph-2.0.lua"

$counter = 1
$storePath  = ""; $first = 1
$coreDirectory = Get-ChildItem -Path $core -Filter  *.lua -Recurse -Exclude $exclusion | Resolve-Path -Relative
foreach ($item in $coreDirectory){
    $item = $item.Replace(".\", ""); $item = $item.Replace("\", "/");  $value = $item.Split("/")
    $concat = ""
    foreach($o in $value){
        if($o -eq $value[$value.Count - 1]){ break }
        $concat += $o + "/"
    }
    if($concat -ne $storePath){ $init += "`n" }
    $storePath = $concat
    $findInfile = Select-String -Path $input_file -Pattern $item
    if(-Not $findInfile){
        if($first){ $init += "PLEASE REVIEW THIS FILE AND DELETE THOSE LINES" ; $first = 0 }
        $init += "`n" + $item
    }
    
}
write-host $init
$target_file = Get-ChildItem $output_file
if($target_file){
    Set-Content $output_file -Value $init
}else{
    New-Item -Path . -Name $output_file -ItemType "file" -Value $init
    write-host "file has been created with our values" 
}

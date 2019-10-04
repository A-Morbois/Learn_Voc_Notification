#https://github.com/Windos/BurntToast/blob/master/Help/New-BurntToastNotification.md


$current_location =  Split-Path "$($script:MyInvocation.MyCommand.Path)"

. "$current_location\config.ps1"


Install-Module BurntToast -Scope CurrentUser


#
#$_QuotesPath = "C:\Users\morboa-ext\Desktop\POC" 
#$_Rest = 1
#$_Duration = 240

$myWords = @()

foreach($p in $(Get-ChildItem -Path "$current_location\$VocPath\*.txt" -Recurse -file))
{
    #Write-Host $(get-content $p)
    foreach ($l  in $(get-content $p))
    {
        $myWords += $l
        #Write-Host $l
    }
}


Do
{
    $rnd = Get-Random -Maximum $myWords.count

    $quote = $myWords[$rnd]
    $word_to_learn = $myWords[$rnd].Split(";")[0]
    $translation = $myWords[$rnd].Split(";")[1]

    $img =   "$current_location\Images\$translation.png"

    write-host "$word_to_learn : $translation "

    #$BlogButton = New-BTButton -Content 'Listen to it'  -Arguments 'https://king.geek.nz'
    $ToastHeader = New-BTHeader -Id '001' -Title $word_to_learn
    New-BurntToastNotification -Sound Default  -AppLogo "$img"  -Text "$translation", "$(Get-Date -format HH:mm)" <#-Button $BlogButton#> -Header $ToastHeader

    [Int] $sleeping_Time = $Rest*60

    Start-Sleep -seconds $Sleeping_Time

    $Duration = $Duration - $Rest
    Write-host "Duration left :$($Duration)"
}until ($Duration -lt 0)

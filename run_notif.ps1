
$loc = "C:\Users\morboa-ext\Desktop\Perso\Dev\Learn_Voc_Notification\"


$current_location =  Split-Path "$($script:MyInvocation.MyCommand.Path)"

. "$current_location\config.ps1"


Install-Module BurntToast -Scope CurrentUser


#
#$_QuotesPath = "C:\Users\morboa-ext\Desktop\POC" 
#$_Rest = 1
#$_Duration = 240

$myQuotes = @()

foreach($p in $(Get-ChildItem -Path "$current_location\$VocPath\*.txt" -Recurse -file))
{
    #Write-Host $(get-content $p)
    foreach ($l  in $(get-content $p))
    {
        $myQuotes += $l
        #Write-Host $l
    }
}


Do
{
    $rnd = Get-Random -Maximum $myQuotes.count

    $quote = $myQuotes[$rnd]
    $word_to_learn = $myQuotes[$rnd].Split(";")[0]
    $translation = $myQuotes[$rnd].Split(";")[1]

    $img =   "$current_location\Images\$translation.png"
    write-host $img

    write-host "$word_to_learn : $translation "

    New-BurntToastNotification  -AppLogo "$img"  -Text "$word_to_learn" , "$translation"

    [Int] $sleeping_Time = $Rest*60

    Start-Sleep -seconds $Sleeping_Time

    $Duration = $Duration - $Rest
    Write-host "Duration left :$($Duration)"
}until ($Duration -lt 0)

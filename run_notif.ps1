param 
(
    [String] $_QuotesPath,
    [Int] $_Rest,
    [Int] $_Duration
)

Install-Module BurntToast -Scope CurrentUser



$_QuotesPath = "C:\Users\morboa-ext\Desktop\POC" 
$_Rest = 1
$_Duration = 240

$myQuotes = @()

foreach($p in $(Get-ChildItem -Path $_QuotesPath\*.txt -Recurse -file))
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

    #write-host $myQuotes[$rnd]
    $word = $myQuotes[$rnd].Split(";")[0]
    $translation = $myQuotes[$rnd].Split(";")[1]

    New-BurntToastNotification  -AppLogo ""  -Text "$word" , "$translation"
    [Int] $sleeping_Time = $_Rest*60
    Start-Sleep -seconds $Sleeping_Time
    $_Duration = $_Duration - $_Rest
    Write-host "Duration left :$($_Duration)"
}until ($_Duration -lt 0)

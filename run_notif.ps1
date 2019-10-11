#https://github.com/Windos/BurntToast/blob/master/Help/New-BurntToastNotification.md
# https://docs.microsoft.com/fr-fr/windows/uwp/design/shell/tiles-and-notifications/adaptive-interactive-toasts
#https://docs.microsoft.com/en-us/uwp/api/windows.ui.notifications.toastnotification.-ctor#Windows_UI_Notifications_ToastNotification__ctor_Windows_Data_Xml_Dom_XmlDocument_
#https://steemit.com/powershell/@esoso/fun-with-toast-notifications-in-powershell
#https://unsplash.com/documentation#search-photos



[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$current_location =  Split-Path "$($script:MyInvocation.MyCommand.Path)"

. "$current_location\config.ps1"


#Install-Module BurntToast -Scope CurrentUser


#
#$_QuotesPath = "C:\Users\morboa-ext\Desktop\POC" 
#$_Rest = 1
#$_Duration = 240

$myWords = @()

foreach($p in $(Get-ChildItem -Path "$current_location\$VocPath\*.txt" -Recurse -file))
{
    #Write-Host $(get-content $p)
    foreach ($l  in $(get-content -Encoding "UTF8" $p))
    {
        $myWords += $l
        #Write-Host $l
    }
}

Do
{
        $rnd = Get-Random -Maximum $myWords.count

        $word_to_learn = $myWords[$rnd].Split(";")[0]
        $translation = $myWords[$rnd].Split(";")[1]
        $prononciation = $myWords[$rnd].Split(";")[2]

        $img =   "$current_location\$ImgPath\$word_to_learn.png"
        
        $Picture = ".\Images\comer.png"
        $global:ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition


    

    $LogoImage = "file:///$global:ScriptPath/Images/$word_to_learn.jpg" 
    $HeroImage = "file:///$global:ScriptPath/Images/$word_to_learn.jpg"
    
    $HeroImage = "$global:ScriptPath/Images/$word_to_learn.jpg"

    
    $XMLHeroImg = ""

    $testHero = Test-Path $HeroImage -PathType Leaf
    if ($testHero -eq "True")
    {       
        $XMLHeroImg = "<image src=`"$HeroImage`"/>"
    }
    write-host $XMLHeroImg
    

    $testLogo= Test-Path $HLogoImage -PathType Leaf
    $XMLLogoImg = ""
    if ($testLogo -eq "True")
    {
        $XMLLogoImg =  '<image id="1" placement="appLogoOverride" hint-crop="circle" src="$LogoImage"/>'
    }


    Add-Type -AssemblyName presentationCore
    $mediaPlayer = New-Object system.windows.media.mediaplayer
    $mediaPlayer.open("$global:ScriptPath/Sound/$word_to_learn.mp3")

    $SoundLogo = "$global:ScriptPath/Images/speaker.png" #listen.png"

    $date = Get-Date 

    [xml]$Toast = @"
    <toast scenario="$Scenario">
        <visual>
        <binding template="ToastGeneric">
        <image placement="appLogoOverride" hint-crop="circle" src="$XMLLogoImg"/>

           
            <text placement="attribution">$date</text>
            <text>Time to Learn some Voc</text>
            <group>
                <subgroup>
                    <text hint-style="title" hint-wrap="true" >$word_to_learn</text>
                </subgroup>
            </group>
            <group>
                <subgroup>     
                    <text hint-style="body" hint-wrap="true" >$translation</text>
                </subgroup>
            </group>
            <group>
                <subgroup>     
                    <text placement="attribution"  >$prononciation</text>
                </subgroup>
            </group>
        
          $XMLHeroImg
          
        </binding>
        </visual>
        <actions>
            <action activationType="foreground" imageUri="$SoundLogo" arguments="action=ClickSound" content="Listen to it">         
        </action>
            
        </actions>
    </toast>
"@


    $App = "Microsoft.SoftwareCenter.DesktopToasts"
    $ToastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
    $ToastXml.LoadXml($Toast.OuterXml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($App).Show($ToastXml)

    Start-Sleep -seconds 2
    $($mediaPlayer.Play())

        write-host "$date : $word_to_learn : $translation "
        Write-host " Next one in $rest minutes : Duration left :$($Duration) "
    
        [Int] $sleeping_Time = $Rest*60

        Start-Sleep -seconds $Sleeping_Time

        $Duration = $Duration - $Rest
        
}until ($Duration -lt 0)


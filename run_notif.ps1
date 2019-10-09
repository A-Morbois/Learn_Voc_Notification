#https://github.com/Windos/BurntToast/blob/master/Help/New-BurntToastNotification.md
# https://docs.microsoft.com/fr-fr/windows/uwp/design/shell/tiles-and-notifications/adaptive-interactive-toasts
#https://docs.microsoft.com/en-us/uwp/api/windows.ui.notifications.toastnotification.-ctor#Windows_UI_Notifications_ToastNotification__ctor_Windows_Data_Xml_Dom_XmlDocument_
#https://steemit.com/powershell/@esoso/fun-with-toast-notifications-in-powershell
#https://unsplash.com/documentation#search-photos



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

        $img =   "$current_location\$ImgPath\$word_to_learn.png"
        
        $Picture = ".\Images\comer.png"
    $global:ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition


    #$enc = [System.Text.Encoding]::UTF8
    #$a = "$(茶)"
   # $i = $enc.GetBytes($a)
    $LogoImage = "file:///$global:ScriptPath/Images/$word_to_learn.jpg" 
    $HeroImage = "file:///$global:ScriptPath/Images/$word_to_learn.jpg"
    $Sound = "///$global:ScriptPath/Sound/$word_to_learn.mp3"

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]# | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] #| Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] #| Out-Null
        

    #$event = [Windows.ApplicationModel.Activation.ToastNotificationActivatedEventArgs]

    #Register-ObjectEvent -InputObject "ClickSound" -EventName "ClickSound" -Action{
    #    write-host "A"
    #}


    Add-Type -AssemblyName presentationCore
    $mediaPlayer = New-Object system.windows.media.mediaplayer
    $mediaPlayer.open("$global:ScriptPath/Sound/$word_to_learn.mp3")

    $SoundLogo = "$global:ScriptPath/Images/listen.png"
    #$mediaPlayer.Play()
    # <image placement="hero" src="$HeroImage"/>
    $date = Get-Date 

    [xml]$Toast = @"
    <toast scenario="$Scenario">
        <visual>
        <binding template="ToastGeneric">
           
            <image id="1" placement="appLogoOverride" hint-crop="circle" src="$LogoImage"/>
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
                    <text hint-style="body" hint-wrap="true" >$BodyText2</text>
                </subgroup>
            </group>
            <image src="$HeroImage"/>
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

        write-host "$word_to_learn : $translation "
        write-host $img
    
        [Int] $sleeping_Time = $Rest*60

        Start-Sleep -seconds $Sleeping_Time

        $Duration = $Duration - $Rest
        Write-host "Duration left :$($Duration)"
}until ($Duration -lt 0)



function ClickSound
{
    #$($mediaPlayer.Play())
}

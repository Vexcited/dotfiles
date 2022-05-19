$temp_download_folder = "./temp_downloads"
mkdir $temp_download_folder -Force > $null

function __DownloadAndInstall {
  param (
    [Parameter()]
    [string]$FileName,

    [Parameter()]
    [string]$DownloadUrl
  )

  $file_output = "$temp_download_folder/$FileName"
  Invoke-WebRequest $DownloadUrl -Out $file_output
  
  Write-Host "`t* Install from <$file_output>"
  Start-Process -FilePath $file_output -Wait

  Write-Host "`t* Done.`n`n"
}

function _Download_GitHubDesktopApp {
  $download_url = "https://central.github.com/deployments/desktop/desktop/latest/win32"
  Write-Host "+ Download 'GitHub Desktop' from <$download_url>"

  __DownloadAndInstall -FileName "github_desktop.exe" -DownloadUrl $download_url
}

function _Download_YouTubeMusicDesktopApp {
  $repo = "th-ch/youtube-music"
  Write-Host "+ Download 'youtube-music' from '$repo' repository."
  
  $releases_url = "https://api.github.com/repos/$repo/releases/latest"
  Write-Host "`t* Determine latest release."
  
  $assets = (Invoke-WebRequest $releases_url | ConvertFrom-Json).assets

  Foreach ($asset in $assets) { 
    $download_url = $asset.browser_download_url

    if ($download_url.Contains(".exe") -and $download_url.Contains("Setup") -and -not $download_url.Contains(".blockmap")) {
      __DownloadAndInstall -FileName "youtube_music.exe" -DownloadUrl $download_url
    }
  }
}

function Dowload_Softwares {
  Write-Host "`n---- END`n[SOFTWARES] Download.`n`n"
  
  _Download_GitHubDesktopApp
  # _Download_YouTubeMusicDesktopApp
  
  Write-Host "`n[SOFTWARES] Completed, clean-up temporary folder."
  rm -Recurse -Force $temp_download_folder
}


Dowload_Softwares

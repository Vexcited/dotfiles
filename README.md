# dotfiles
My dotfiles for Windows, Debian, Termux and so on.

## Termux

### Automated

Copy and paste this script into Termux and it will
automatically install all my setup.

```bash
pkg upgrade -y && \
pkg install git -y && \
cd ~/ && \
git clone https://github.com/vexcited/dotfiles && \
cd dotfiles && \
chmod -x ./setup-termux.sh && \
./setup-termux.sh
```

## Windows (Home: 21H2)

> TODO: Finish the scripts to automate everything below

```powershell
Set-ExecutionPolicy Unrestricted

$assets = (Invoke-WebRequest "https://api.github.com/repos/git-for-windows/git/releases/latest" | ConvertFrom-Json).assets
foreach ($asset in $assets) { 
  if ($asset.name -match 'Git-\d*\.\d*\.\d*-64-bit\.exe') {
    $file_name = "git-stable.exe"

    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $file_name
    Start-Process -Wait $file_name -ArgumentList /silent
    Remove-Item -Force $file_name -ErrorAction SilentlyContinue
  }
}
```

### Softwares

* GitHub Desktop (done)
* YT Music Desktop (done)
* Visual Studio Code - Insiders
* Discord + BD (Nord Theme)
* Spotify + spicetify
* OBS Studio
* Steam + GeForce NOW
* Ableton Live Lite
* Windows Terminal
* Node.js + `yarn` + `vercel`
* oh-my-posh
* Synthesia
* Chrome

### OMP - PowerShell `$PROFILE`

```powershell
Import-Module posh-git
Import-Module oh-my-posh
oh-my-posh init pwsh --config ~/Documents/GitHub/dotfiles/windows/theme.omp.json | Invoke-Expression
```
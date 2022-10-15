# dotfiles
My dotfiles for Windows, Arch-Linux, Termux and so on.

> Please note that these are MY configurations so don't blindly use them. Check the setup script and configuration files before using any of them.

## Termux (Android)

Copy and paste this script into Termux and it will
automatically run the setup script.

```bash
pkg upgrade -y && pkg install git -y && \
git clone https://github.com/Vexcited/dotfiles ~/.vexcited-dotfiles && cd ~/.vexcited-dotfiles && \
chmod +x ./setup.sh && \
./setup.sh
```

## Arch-Linux

My whole Arch-Linux setup and configuration is detailled
in [its wiki](https://github.com/Vexcited/dotfiles/wiki/Arch-Linux).

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
* Visual Studio Code
* Discord + BD (Nord Theme)
* Spotify + spicetify
* OBS Studio
* Steam + GeForce NOW
* (Ableton Live Lite)
* Windows Terminal
* Node.js + `yarn` + `pnpm` + `vercel`
* oh-my-posh
* Synthesia
* Chrome

### OMP - PowerShell `$PROFILE`

```powershell
Import-Module posh-git
Import-Module oh-my-posh
oh-my-posh init pwsh --config ~/Documents/GitHub/dotfiles/windows/theme.omp.json | Invoke-Expression
```

## Codespaces

Use the `setup-codespace.sh` file to automatically setup my codespace configuration.

To use this configuration on every new codespaces, go into your GitHub settings, then Codespaces, then Dotfiles, then select this repository. This will load the `setup.sh` script, which runs the `setup-codespace.sh` script.

### Included

- VNC, accessible on port `5901` when using local port forwarding.
- noVNC, accessible on port `6080` from the browser.
- Firefox ESR, installed for the VNC.
<!-- - VSCodium, installed for the VNC. -->
- Neovim~~, with custom configuration.~~
- zsh~~, with custom configuration.~~
- WakaTime auto-loader, needs `WAKATIME_API_KEY` environment variable to work.

### Configuration

The default VNC password is `vnc`.

To run the VNC session, you'll need to access the terminal and run `/usr/local/share/desktop-init.sh`.



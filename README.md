# dotfiles

My current configuration files for my dual-boot macOS and Asahi Linux (w/Fedora) on my M2 MacBook Air.

## Wallpapers

You may find them in [wallpapers](./wallpapers) directory.

## Chrome

### Theme
  
[Catppuccin Macchiato](https://chrome.google.com/webstore/detail/catppuccin-chrome-theme-m/cmpdlhmnmjhihmcfnigoememnffkimlk)

### Extensions

- [uBlock Origin Lite](https://chromewebstore.google.com/detail/ublock-origin-lite/ddkjiahejlhfcafbddmgiahcphecmpfh)
- [Authenticator](https://chromewebstore.google.com/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai)
- [I don't care about cookies](https://chromewebstore.google.com/detail/i-dont-care-about-cookies/fihnjjcciajhdojfnbdddfaoknhalnja)
- [Material Icons for GitHub](https://chromewebstore.google.com/detail/material-icons-for-github/bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc)
- [WakaTime](https://chromewebstore.google.com/detail/wakatime/jnbbnacmeggbgdjgaoojpmhdlkkpblgi)
- [nightTab](https://chromewebstore.google.com/detail/nighttab/hdpcadigjkbcpnlcpbcohpafiaefanki), *find my configurations in [nightTab](./nightTab) directory*
- [Stylus](https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)
  - [GitHub](https://github.com/catppuccin/userstyles/tree/main/styles/github)
  - [Codeberg](https://github.com/catppuccin/userstyles/tree/main/styles/codeberg)
  - [DeepL](https://github.com/catppuccin/userstyles/tree/main/styles/deepl)
  - [Google](https://github.com/catppuccin/userstyles/tree/main/styles/google)
  - [npm](https://github.com/catppuccin/userstyles/tree/main/styles/npm)
  - [Porkbun](https://github.com/catppuccin/userstyles/tree/main/styles/porkbun)
  - [Twitch](https://github.com/catppuccin/userstyles/tree/main/styles/twitch)
  - [Vercel](https://github.com/catppuccin/userstyles/tree/main/styles/vercel)
  - [YouTube](https://github.com/catppuccin/userstyles/tree/main/styles/youtube)

## how2sync - from dotfiles

### Globals

Works for both macOS and Asahi Linux.

```bash
# neovim
mkdir -p ~/.config/nvim && cp -r globals/nvim/* ~/.config/nvim/
```

### macOS

Exclusives for macOS.

```bash
# warp
mkdir -p ~/.warp && cp -r macOS/warp/* ~/.warp/
# zsh

# zed

```

### Linux

Exclusives for Asahi Linux.

```bash
# hypr

# waybar

# kitty

# zsh

# wofi

```

## how2sync - to dotfiles

### Globals

Works for both macOS and Asahi Linux.

```bash
# neovim
rm -rf globals/nvim/lua globals/nvim/init.lua && cp -r ~/.config/nvim/* globals/nvim/
```

### macOS

Exclusives for macOS.

```bash
# warp
rm -rf macOS/warp/themes && cp -r ~/.warp/* macOS/warp/
# zsh

# zed

```

### Linux

Exclusives for Asahi Linux.

```bash
# hypr

# waybar

# kitty

# zsh

# wofi

```

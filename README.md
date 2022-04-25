# dotfiles
My dotfiles for Windows, Debian, Termux and so on.

## Termux

```bash
pkg upgrade -y && \
pkg install git -y && \
cd ~/ && \
git clone https://github.com/vexcited/dotfiles && \
cd dotfiles && \
chmod -x ./setup-termux.sh && \
./setup-termux.sh
```

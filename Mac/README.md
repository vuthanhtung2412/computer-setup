# Setup step by step

## Must

1. Install brew
2. Install nix by run `./scripts/init_setup.sh`
3. Run nix setup `./scripts/hms.sh`
4. (Optional) Install desktop app with brew `brew bundle --file ~/.tung-setup/Brewfile`

## Optional improvement

+ key board repeat rate too slow 
  + Keyboard > key repeat rate max fast + delay until repeat max short
+ option is used to alternate char
  + Solution at [this link](https://apple.stackexchange.com/a/461625) which available in [my chezmoi config](https://github.com/vuthanhtung2412/dotfiles/blob/d01c7f0a63f659074215777aa63fdbc418d7ad11/private_Library/private_Keyboard%20Layouts/QWERTY%20no%20option.keylayout)
+ dock always on
  + desktop & Dock > Automatically show and hide the dock + size 1/3
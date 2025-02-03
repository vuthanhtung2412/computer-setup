# Setup step by step

## Must

1. Install brew
2. Install nix by run `./scripts/init_setup.sh`
3. Run nix setup `./scripts/hms.sh`
4. Install desktop app with brew `brew bundle --file ~/.tung-setup/Brewfile`

## Optional improvement

+ create alias for `~` home folder and move it to desktop

    ``` bash
    cd ~
    cd ..
    open .
    # make alias for ~ and drop it into ~/Desktop
    ```
+ pin machintoshHD to desktop : Finder menu > Preferences > General > Show these items on Desktop.
+ Hide top menu : Settings -> Automatically hide and show the menu bar

+ key board repeat rate too slow
  + Keyboard > key repeat rate max fast + delay until repeat max short

+ Home row setup
  + Clicking : Cmd + Space
  + Scrolling : Cmd + j

+ Disable everything at Setting > Keyboards > Shortcuts > Spotlight
+ Disable everything at Setting > Keyboards > Shortcuts > Input source

+ option is used to alternate char
  + Solution at [this link](https://apple.stackexchange.com/a/461625) which available in [my chezmoi config](https://github.com/vuthanhtung2412/dotfiles/blob/d01c7f0a63f659074215777aa63fdbc418d7ad11/private_Library/private_Keyboard%20Layouts/QWERTY%20no%20option.keylayout)
+ dock always on
  + desktop & Dock > Automatically show and hide the dock + size 1/3
+ Ctrl + 1/2/3/4 : to switch desktop (Keyboard -> Shortcut -> Mission control -> mission control)
  + 1 Web/Docs
  + 2 Terminal
  + 3 Obsidian notes
  + 4 Slack message
+ Install add `rust-analyzer` to `rustup` : `rustup component add rust-analyzer`
+ Stop desktop rearrangement when click an application
  + System settings -> desktop & dock -> mission control -> turn off `Automatically rearrangement spaces based on most recent used`
+ Approve terminal password requirements with fingerprint
  + `sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local`
+ Connect google calendar to calendar app of your mac
+ change screenshot dir `cmd shift 5` from `Desktop` to `Desktop/screenshots`

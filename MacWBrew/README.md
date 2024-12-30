# Useful commands

+ Check installed programs on the system `brew deps --tree --installed`
+ Sync the system with brewfiles

  ```
  alias bbic="brew update &&\
  brew bundle install --cleanup --file=~/.config/Brewfile --no-lock &&\
  brew upgrade"
  ```
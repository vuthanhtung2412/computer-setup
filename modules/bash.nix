{
  config,
  pkgs,
  ...
}:
{
  programs.bash = {
    enable = true;
    historyControl = [
      "erasedups"
      "ignoredups"
      "ignorespace"
    ];
    historyFileSize = 2000;
    historySize = 1000;
    bashrcExtra = ''
      alias gc='gcloud'

      # Initialize yazi like documentation : https://yazi-rs.github.io/docs/quick-start#shell-wrapper
      # programs.yazi.ZshIntegration is not working correctly since i bind `cd` to `zoxide`
      # error : zoxide: no match found
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };
}

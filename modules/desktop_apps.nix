{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    albert
    blueman
    # Chromium application can't find libGL
    # https://github.com/NixOS/nixpkgs/issues/269104
    # https://github.com/NixOS/nixpkgs/pull/269345
    # TODO: enable GPU for chromium based browser
    # (config.lib.nixGL.wrap brave)
    brave
    ibus-engines.bamboo
    xournalpp
    obsidian
    (config.lib.nixGL.wrapOffload blender)
    (config.lib.nixGL.wrapOffload obs-studio)
  ];
  services = {
    copyq.enable = true; # it is a must for Albert clipboard extension
    # fusuma for touchpad gesture
    fusuma = {
      enable = true;
      settings = {
        # Ctrl plus/minus for 2 fingers pinch is not ideal
        # Limitation of pinch to zoom in xserver : https://www.reddit.com/r/firefox/comments/wtdb7d/pinch_to_zoom_not_working_on_ubuntu/
        # TODO : web browser zoom experience on x11 https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/530
        threshold = {
          swipe = 0.1;
          pinch = 0.1;
        };
        interval = {
          swipe = 1;
          pinch = 0.2;
        };
        swipe = {
          "3" = {
            begin = {
              command = "xdotool keydown Alt";
            };
            right = {
              update = {
                command = "xdotool key Tab";
                interval = 4;
              };
            };
            left = {
              update = {
                command = "xdotool key Shift+Tab";
                interval = 4;
              };
            };
            end = {
              command = "xdotool keyup Alt";
            };
          };
          "4" = {
            left = {
              command = "xdotool key ctrl+alt+Right";
            };
            right = {
              command = "xdotool key ctrl+alt+Left";
            };
            up = {
              command = "xdotool key super+s";
            };
            down = {
              command = "xdotool key Escape && xdotool key super+d";
            };
          };
        };
        pinch = {
          "2" = {
            # Use in conjunction with mouse-pinch-to-zoom
            "in" = {
              # Zoom out
              # command = "xdotool keydown ctrl key minus keyup ctrl";
              # OR
              command = "xdotool keydown ctrl click 5 keyup ctrl";
            };
            out = {
              # command = "xdotool keydown ctrl key plus keyup ctrl";
              # OR
              command = "xdotool keydown ctrl click 4 keyup ctrl";
            };
          };
          "3" = {
            "in" = {
              command = "xdotool key super+Down";
            };
            out = {
              command = "xdotool key super+Up";
            };
          };
        };
      };
    };
  };
}

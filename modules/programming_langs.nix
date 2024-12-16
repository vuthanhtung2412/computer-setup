{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (python311.withPackages (
      ps: with ps; [
        # this is solely for albert plugins installation, and it also make sense since python is a scripting languages
        pip
      ]
    ))
    nixfmt-rfc-style # not available in mason yet
  ];
  programs = {
    mise = {
      # `mise implode` to purge every thing
      # `mise prune` to gc (state of every cofig file is kept in `~/.local/state/mise/tracked-configs` so it is good)
      enable = true;
      globalConfig = {
        tools = {
          python = "3.12";
          java = "21";
          rust = "1.81";
          go = "1.22";
          uv = "0.5";
          node = "20.18";
        };
        settings = {
          env_file = ".env";
        };
        env = {
          CARGO_TARGET_DIR = "target";
        };
      };
    };
  };
}

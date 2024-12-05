{
  config,
  pkgs,
  nixGL,
  ...
}:

{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "workbench.iconTheme" = "material-icon-theme";
      "git.confirmSync" = false;
      "git.suggestSmartCommit" = false;
      "workbench.colorTheme" = "Catppuccin Mocha";
      "terminal.integrated.sendKeybindingsToShell" = true;
    };
    extensions = with pkgs; [
      # Git
      vscode-extensions.github.vscode-pull-request-github
      vscode-extensions.eamodio.gitlens
      vscode-extensions.mhutchie.git-graph
      # Collaborative coding
      vscode-extensions.ms-vsliveshare.vsliveshare
      vscode-extensions.ms-vscode-remote.remote-ssh
      # Language support
      vscode-extensions.ms-vscode.cpptools-extension-pack
      vscode-extensions.vscjava.vscode-java-pack
      vscode-extensions.golang.go
      vscode-extensions.ecmel.vscode-html-css
      vscode-extensions.christian-kohler.npm-intellisense
      vscode-extensions.ms-vscode.live-server
      vscode-extensions.ms-toolsai.jupyter
      vscode-extensions.ms-python.python
      vscode-extensions.ms-python.debugpy
      vscode-extensions.ms-python.vscode-pylance
      vscode-extensions.njpwerner.autodocstring
      vscode-extensions.rust-lang.rust-analyzer
      vscode-extensions.bbenoist.nix
      vscode-extensions.formulahendry.code-runner
      # formatting
      vscode-extensions.esbenp.prettier-vscode
      vscode-extensions.dbaeumer.vscode-eslint
      # Other tools
      vscode-extensions.ms-azuretools.vscode-docker
      vscode-extensions.tim-koehler.helm-intellisense
      vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
      vscode-extensions.catppuccin.catppuccin-vsc
      # vscode-extensions.vscodevim.vim # vim in vscode is pretty shit better trying to swtich to neovim
      vscode-extensions.tomoki1207.pdf
      vscode-extensions.streetsidesoftware.code-spell-checker
      vscode-extensions.usernamehw.errorlens
      vscode-extensions.pkief.material-icon-theme
      vscode-extensions.shd101wyy.markdown-preview-enhanced
      vscode-extensions.continue.continue
      vscode-extensions.tailscale.vscode-tailscale
      # Unavailable extensions can be put in .vscode_rec_extensions/.vscode/extensions.json
    ];
  };
}

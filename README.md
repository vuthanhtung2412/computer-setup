# computer-setup

Set up script for my personal computer

+ Make file : each group of software will correspond to a task
+ Maintain a list of dotfiles with **chezmoi**

# Some thoughts about Nix

## Personal usage

+ Even though home manager support a wide range of dot files (nvim, oh-my-posh, vscode, firefox, tmux, basically everything i need). However, home manager make these files read-only, which make it less easy to add quick configuration latter. (this feels almost like ORM vs SQL)
+ Nix doesn't come with cask
+ When a program is released it will be on apt, dnf, pacman, brew first instead of nix
+ Personal usage doesn't require strong reproducibility guarantee

## Development

+ Every language has its own package manager, it doesn't use nix as first class support (we publish package to pip, go mod, cargo, npm but not nix)
+ Projects like maven2nix, node2nix, gradle2nix introduces a lot of overhead. Go mod and cargo is declarative already :)))
+ When it comes to deployment, docker is enough.

## User experience

+ Nix is way to hard to write and understand for configuration

## Some niche that might be good for nix

+ Include dev tools like (fzf, jq, kafka-cat) in the project
  
## Reference

+ [Nix starter template](https://github.com/Misterio77/nix-starter-configs)
+ [Installing Nix](https://github.com/DeterminateSystems/nix-installer)
+ [Installing home-manager](https://nix-community.github.io/home-manager/#sec-install-standalone)
+ [Home manager option](https://nix-community.github.io/home-manager/options.xhtml)
+ Some great ressource for devenv with Nix
  + [dev env nix template](https://github.com/the-nix-way/dev-templates)
  + [article about nix devenv](https://determinate.systems/posts/nix-direnv/)
  + <https://github.com/nix-community/home-manager>
  + <https://discourse.nixos.org/t/using-home-manager-to-control-default-user-shell/8489/4>
  + <https://home-manager-options.extranix.com/?query=zshrc&release=release-24.05>

# RFC about why managing Python with Conda in my Ubuntu machine

It all starts with my attempt to install Pytorch with CUDA enabled. My nix file looks like below
  
``` nix
# home.nix
{ config, pkgs, ... }:

{
  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      supportCuda = true;
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    cudaPackages.cudatoolkit
    (python311.withPackages(p: with p; [
      torch-bin
    ]))
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
      stdenv.cc.cc
      cudaPackages.cudatoolkit
    ];
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };
}
```

There is some problem with this set up

+ pytorch  still couldn't detect my gpu

  ``` sh
  ~#@❯ python3 -c "import torch; print(torch.cuda.is_available())"
  /nix/store/81drbwns26m7v25c0vw178y4m1dnb3l7-python3-3.11.9-env/lib/python3.11/site-packages/torch/cuda/init.py:118: UserWarning: CUDA initialization: Unexpected error from cudaGetDeviceCount(). Did you run some cuda functions before calling NumCudaDevices() that might have already set an error? Error 34: CUDA driver is a stub library (Triggered internally at ../c10/cuda/CUDAFunctions.cpp:108.)
    return torch._C._cuda_getDeviceCount() > 0
  False
  ```

+ Setting `LD_LIBRARY_PATH` interfere with dynamic binding of some program. For example Nvidia driver]

  ``` sh
  +---------------------------------------------------------------------------------------+
  | NVIDIA-SMI 535.183.06             Driver Version: 535.183.06   CUDA Version: ERR!     |
  |-----------------------------------------+----------------------+----------------------+
  | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
  |                                         |                      |               MIG M. |
  |=========================================+======================+======================|
  |   0  NVIDIA GeForce MX250           On  | 00000000:01:00.0 Off |                  N/A |
  | N/A   32C    P8              N/A / ERR! |      6MiB /  2048MiB |      0%      Default |
  |                                         |                      |                  N/A |
  +-----------------------------------------+----------------------+----------------------+

  +---------------------------------------------------------------------------------------+
  | Processes:                                                                            |
  |  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
  |        ID   ID                                                             Usage      |
  |=======================================================================================|
  |    0   N/A  N/A      6492      G   /usr/lib/xorg/Xorg                            4MiB |
  +---------------------------------------------------------------------------------------+
  ```

+ A nix connoiseur on Discord suggest me to scope LD_LIBRARY_PATH for only `pytorch`

  ```sh
  ~#@❯ RPATH="/nix/store/69kcmx74075pan3mxpf4k9sm5j0m7vyc-cuda-merged-12.2/lib/" CUDA_PATH="/nix/store/69kcmx74075pan3mxpf4k9sm5j0m7vyc-cuda-merged-12.2/" python3 -c "import torch; print(torch.cuda.is_available())"
  /nix/store/81drbwns26m7v25c0vw178y4m1dnb3l7-python3-3.11.9-env/lib/python3.11/site-packages/torch/cuda/__init__.py:118: UserWarning: CUDA initialization: Unexpected error from cudaGetDeviceCount(). Did you run some cuda functions before calling NumCudaDevices() that might have already set an error? Error 34: CUDA driver is a stub library (Triggered internally at ../c10/cuda/CUDAFunctions.cpp:108.)
    return torch._C._cuda_getDeviceCount() > 0
  False
  ~#@❯ LD_LIBRARY_PATH="/nix/store/69kcmx74075pan3mxpf4k9sm5j0m7vyc-cuda-merged-12.2/lib/" CUDA_PATH="/nix/store/69kcmx74075pan3mxpf4k9sm5j0m7vyc-cuda-merged-12.2/" python3 -c "import torch; print(torch.cuda.is_available())"
  /nix/store/81drbwns26m7v25c0vw178y4m1dnb3l7-python3-3.11.9-env/lib/python3.11/site-packages/torch/cuda/__init__.py:118: UserWarning: CUDA initialization: Unexpected error from cudaGetDeviceCount(). Did you run some cuda functions before calling NumCudaDevices() that might have already set an error? Error 34: CUDA driver is a stub library (Triggered internally at ../c10/cuda/CUDAFunctions.cpp:108.)
    return torch._C._cuda_getDeviceCount() > 0
  False
  ```

# Useful commands

+ Activate home manager `home-manager switch --flake ./home-manager` or `home-manager switch --impure --show-trace --flake . -b backup`
+ Update Fedora kernel `sudo dnf upgrade --refresh`
+ Update flake lock files `nix flake update`
+ Stop using home-manager completely by deleting ~/.nix-profile `rm -rf ~/.nix-profile`
+ Revert to previous version of home-manager [link](https://nix-community.github.io/home-manager/index.xhtml#sec-usage-rollbacks)
+ `du -sh /nix/store` check size of nix store
+ `nix-collect-garbage --delete-old` delete old generations and clean unreachable objects

# Bullshit note

+ TODO: long term solution for backup files
+ `zsh vi mode` is not necessary on second thoughts and it messes up keybindings of `fzf`. one quick way to fix [link](https://stackoverflow.com/questions/73033698/fzf-keybindings-doesnt-work-with-zsh-vi-mode)
+ Open source project idea (search image with ocr as you type in linux)
+ `nix-shell -p nix-info --run "nix-info -m"` check system info with nixd
+ nixgl set up with home manager [link](https://github.com/nix-community/nixgl/issues/114#issuecomment-1585323281)
+ Comparing terminal diff tools (delta vs difftastic vs diff-so-fancy)
  + diff-so-fancy is not as well maintained as the two other tools
  + For a diff tools i need it to have good integration with git and side-by-side view. side-by-side view work out of the box on both delta and difftastic, however git pager of delta is much better than difftastic.
  + In the end LazyVim is pretty based for diffing and `git diff`
+ touchegg doesn't propose that much advantage over fusuma. furthermore, touchegg is not natively supported by `nix home-manager`
+ Good example of how to use nix <https://github.com/sschleemilch/nix-config/blob/main/home/programs/terminal/oh-my-posh/default.nix>
+ Another things why `requirements.txt` is not enough for reproducibility is that where to get these version and all of the dependency from
+ Features i need from app launcher
  + quickly open with shortcut
  + search app in a fuzzy manner
  + translate
  + search
  + quick calculation
  + define
  + system command
  + clip board that can fuzzy search
  + music control
  + recent dir
  + recent doc
  + recent app
  + 1password
  + search screenshot
    + **Conclusion (by claude)** : Among these, I would recommend Albert as it likely covers most of your requirements out of the box with the least configuration needed. Ulauncher would be my second choice as it's more modern but might need additional extensions. When installed with Nix, Ulauncher extensions are not usable, no cask found. Rofi need to much to configure eventhough it is supported by nix home-manager. (Albert has better integration with nix and it takes less time to config since it doesn't depend on 3rd party plugin, the UX is not so top, fzf is bad, timer is hard to use)
+ Setting up every dot file with home manager might not be the best solution since in a company set up dotfiles might be modified so it might be a good pratice to let it mutable. **Another set up to consider :**
  + Solution 1:
    + Install every terminal tools with **Ansible (since it have a high adoption in industry and it should be declarative & idempotent for app installation) or nix**
    + write dotfiles and track it with **chezmoi**
    + to reset chezmoi `rm -rf ~/.local/share/chezmoi` 
    + About dev set up use **conda and direnv** to smoothly switch env between project. This also eliminate CUDA integration issue of nix packages
    + TODO : **nix for installation/Ansible for CUDA integrated app + dotfiles management with chezmoi + project-based Development env with conda and direnv**
  + Solution 2 :
    + I can still govern the dotfiles with nix home manager, but the dotfiles is written in a way much more readable and not dependent on home-manager internals. [This repo](https://github.com/omerxx/dotfiles) have some pretty cool shit that i can learn form. **A more flexible option can be using chezmoi which keep dotfiles mutables and track their changes, however, we can still reuse dotfiles from previous idea since it is not too home-manager dependent (preferred).**
    + fix CUDA integration problem of nix installed packages.
    + In every project, heavy package (eg. pytorch, tensorflow, torchvision) would be sourced with direnv via `use nix`. **Since CUDA is not yet very well integrated with Nix package => temporary move to CONDA for dev env management** (some opinions that seconds my conda choice [link](https://news.ycombinator.com/item?id=39388080))
    + [This Youtube channel](https://www.youtube.com/@devopstoolbox) is super based and exactly what I try to achieve.
    + Notes : some caveats after trying chezmoi with nix home-manager

      ```
      ~#@❯ chezmoi add ~/.tung
      ~#@❯ cat ~/.local/share/chezmoi/symlink_dot_tung
      /nix/store/hnyffcq6xpj6a567ah42nsc92c3l2kl2-home-manager-files/.tung 
      ```

    + `home-manager switch` takes 20s while there is nothing to do. I dont think chezmoi takes that long
    + **PROBLEM :** Nix flakes require all source files to be tracked by Git (using git add) before they can be referenced in your Home Manager configuration, otherwise they'll be invisible to Nix and cause "path does not exist" errors.

      ```
      ".tung_source" = {
        source = ./dotfiles/tung_source;
        recursive = true;
      };

      # return error "error: path '/nix/store/idld4rz8gy18zvx7aabmcgxh6wdw8zfm-source/home-manager/dotfiles/tung_source'" does not exist if `./dotfiles/tung_source` is not tracked by git yet. 
      ```

# TO LEARN NEOVIM

+ Testing
+ Debuging
+ Database
+ LSP
  + Auto lint
  + Install new LSP
  + Error highlight
+ Git
  + Change branch
  + Git diff
  + checkout a file content from another branch
  + Git commit / git push
  + Git stash
  + Cherry pick
  + rebase
+ Movement
  + 'd' is delete not cut
  + 'jj' to escape to normal mode
  + Jump to definition
  + Display definition
  + Jump back to where cursor was
  + Select and Edit multiple occurrence of a word
  + Fuzzy search command
  + Jump to a specific word in a line
  + Refractoring
  + Navigate with Table of content of a file
  + Go to Declaration: Navigate to where a symbol is declared (useful for type definition
  + Find all reference of a function or class
  + Find implementation of an abstract class
  + Change case and format : switch between bold, italic, uppercase, lowercase  
  + expand or contract text block
  + duplicate line
  + move block of text up down (alt + up/down in vscode)
  + intellisense autocompletion

# Plan to migrate from home-manager to condaWDirenv + home-manager + chezmoi

  [] test how conda reusing package in base env
  [] write a direnv function so that conda env with `$(pwd)` name is created or activated while cd into the dir
  [] dotfiles for vscode extension recommendation
  [] list all dotfiles that is managed by home manager
  [] make a `.bak` file for all listed dot file
  [] Track all these `.bak` files with `chezmoi`
  [] Gradually migrate dotfiles management of each program from `home-manager` to `chezmoi`
  [] Time `chezmoi` execution compare to `home-manager`
  
# FZF use case

+ find files
+ find dir with inner files/dir preview
+ search history
+ fzf file content can be achieved with `nvim` so it is not too necessary
+ if I master fd and use it with fzf it would be extremely useful since fd can easily filter by **file extension, regex, chained command** (on second thoughts fuzzy search is not working well with long text so fd is perfect for long text search)

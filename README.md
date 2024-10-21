# computer-setup
Set up script for my personal computer
+ Make file : each group of software will correspond to a task
+ Maintain a list of dotfiles with **chezmoi**

# Some thoughts about Nix

## Personal usage :
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
  + https://github.com/nix-community/home-manager
  + https://discourse.nixos.org/t/using-home-manager-to-control-default-user-shell/8489/4
  + https://home-manager-options.extranix.com/?query=zshrc&release=release-24.05

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
+ Activate home manager `home-manager switch --flake ./home-manager` or `home-manager switch --impure --flake .` (if auto detect nixGL is used)
+ Update Fedora kernel `sudo dnf upgrade --refresh`
+ Stop using home-manager completely by deleting ~/.nix-profile `rm -rf ~/.nix-profile`
+ Revert to previous version of home-manager [link](https://nix-community.github.io/home-manager/index.xhtml#sec-usage-rollbacks)

# Bullshit note
+ `zsh vi mode` is not necessary on second thoughts and it messes up keybindings of `fzf`. one quick way to fix [link](https://stackoverflow.com/questions/73033698/fzf-keybindings-doesnt-work-with-zsh-vi-mode)
+ nixgl set up with home manager [link](https://github.com/nix-community/nixgl/issues/114#issuecomment-1585323281)
+ touchegg doesn't propose that much advantage over fusuma. furthermore, touchegg is not natively supported by `nix home-manager`
+ Good example of how to use nix https://github.com/sschleemilch/nix-config/blob/main/home/programs/terminal/oh-my-posh/default.nix
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
    + About dev set up use **conda and direnv** to smoothly switch env between project. This also eliminate CUDA integration issue of nix packages 
    + TODO : **nix for installation/Ansible for CUDA integrated app + dotfiles management with chezmoi + project-based Development env with conda and direnv**
  + Solution 2 : 
    + I can still govern the dotfiles with nix home manager, but the dotfiles is written in a way much more readable and not dependent on home-manager internals. [This repo](https://github.com/omerxx/dotfiles) have some pretty cool shit that i can learn form. **A more flexible option can be using chezmoi which keep dotfiles mutables and track their changes, however, we can still reuse dotfiles from previous idea since it is not too home-manager dependent (preferred).**
    + fix CUDA integration problem of nix installed packages. 
    + In every project, heavy package (eg. pytorch, tensorflow, torchvision) would be sourced with direnv via `use nix`. **Since CUDA is not yet very well integrated with Nix package => temporary move to CONDA for dev env management**
    + [This Youtube channel](https://www.youtube.com/@devopstoolbox) is super based and exactly what I try to achieve.

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
  

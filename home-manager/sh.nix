let
  aliases = {
    "eza" = "eza -l --sort type --no-permissions --no-user --no-time --header --icons --no-filesize --group-directories-first";
    "tree" = "eza --tree";
    "ll" = "eza";
    "l" = "eza";
    "nv" = "nvim";
    ":q" = "exit";
    "q" = "exit";
    "gs" = "git status";
    "gb" = "git branch";
    "gco" = "git checkout";
    "gfr" = "git pull --rebase origin";
    "gft" = "git pull --rebase origin";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";
    "vault" = "ga . && gc -m \"sync $(date '+%Y-%m-%d %H:%M')\" && git push";
    "f" = ''fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'';
    "patch-elf" = "nix run nixpkgs#patchelf -- --set-interpreter '$(nix eval nixpkgs#stdenv.cc.bintools.dynamicLinker --raw)' $1";
  };
in
{ 
  programs = {
    thefuck.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';
      shellAliases = aliases;
    };

    bash = {
      enable = true;
      shellAliases = aliases;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };

    # nushell = {
    #   enable = true;
    #   shellAliases = aliases;
    #   extraConfig = ''
    #     $env.config = {
    #       show_banner: false,
    #     }
    #   '';
    # };
  };
}

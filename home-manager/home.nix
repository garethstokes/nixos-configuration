{ config, pkgs, ... }:
let
  vim-cabalfmt = pkgs.vimUtils.buildVimPlugin {
    name = "vim-cabalfmt";
    src = pkgs.fetchFromGitHub {
      owner = "sdiehl";
      repo = "vim-cabalfmt";
      rev = "90f544ee637ee16f5acad01f4d7952734c7baed0";
      sha256 = "PqgV85aPJLbYf165IhLUwr9R0dzhW6YX7vNULNKOPUM=";
    };
  };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file = {
    ".ssh/id_rsa".source = ~/keys/id_rsa;
    ".ssh/id_rsa.pub".source = ~/keys/id_rsa.pub;
    ".cabal/config".text = ''
      repository hackage.haskell.org
        url: http://hackage.haskell.org/

      remote-repo-cache: /home/gareth/.cabal/packages
      world-file: /home/gareth/.cabal/world
      extra-prog-path: /home/gareth/.cabal/bin
      build-summary: /home/gareth/.cabal/logs/build.log
      remote-build-reporting: anonymous
      jobs: $ncpus
      installdir: /home/gareth/.cabal/bin
    '';
    ".config/gobang/config.toml".text = ''
      [[conn]]
      type = "postgres"
      user = "gareth"
      host = "localhost"
      port = 5432
      database = "neph"
    '';
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

  home.packages = with pkgs; [
    spotify
    cacert
    bash
    autorandr
    slack
    gobang
    dbeaver
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    chromium = {
      enable = true;
    };

    firefox = { 
      enable = true;
      package = pkgs.firefox-wayland;
    };

    git = {
      enable = true;
      userName = "gareth";
      userEmail = "gareth.stokes@paidright.io";
      extraConfig = {
        core = { editor = "nvim"; };
      };
    };

    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = false;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; [
        vim-airline
        vim-airline-themes
        ctrlp-vim
        ack-vim
        tender-vim
        vim-nix
        haskell-vim
        nerdtree
        vim-fugitive
        elm-vim
        # coc-nvim
        vim-ormolu
        vim-cabalfmt
        vim-terraform
      ];

      coc = {
        enable = true;
        settings = {
          "languageserver" = {
            "haskell" = {
              "command" = "haskell-language-server-wrapper";
              "args" = ["--lsp"];
              "rootPatterns" = ["*.cabal" "cabal.project" "hie.yaml"];
              "filetypes" = ["haskell" "lhaskell"];
            };
            "metals" = {
              "command" = "metals-vim";
              "rootPatterns" = ["build.sbt"];
              "filetypes" = ["scala" "sbt"];
            };
          };
        };
      };

      extraConfig = ''
        set expandtab|retab
        set tabstop=2
        set shiftwidth=2
        set list
        set nu
        set colorcolumn=80
        set mouse=a
        syntax enable
        colorscheme tender
        set clipboard=unnamed
        filetype plugin indent on
        set cmdheight=2
        set updatetime=300

        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
          if (index(['vim', 'help'], &filetype) >0)
            execute 'h '.expand('<cword>')
          elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
          else
            execute '!' . &keywordprg . " " . expand('<cword>')
          endif
        endfunction

        " highlight symbol and refs when holding the cursor
        autocmd CursorHold * silent call CocActionAsync('highlight')

        " trigger tab completion
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        " function! s:check_back_space() abort
        "   let col = col('.') - 1
        "   return !col || getline('.')[col - 1]  =~# '\s'
        " endfunction

        map <C-n> :NERDTreeToggle<CR>
        let g:ormolu_command="fourmolu"
        let g:ormolu_suppress_stderr=1
        let g:ormolu_options=["-o -XTypeApplications"]

        let g:terraform_fmt_on_save=1
      '';

    };

    alacritty = {
      enable = true;
      settings = {
        font_size = "12";
      };
    };

    kitty = {
      enable = true;
      font = {
        package = pkgs.fira-code;
        name = "ubuntu-mono";
      };
      settings = {
        font_size = "12";

        background = "#000000";
        foreground = "#ecefc1";

        selection_background = "#0a385c";
        selection_foreground = "#0a1e24";

        cursor = "#708183";

        color0  = "#6e5246";
        color8  = "#674c31";
        color1  = "#e35a00";
        color9  = "#ff8a39";
        color2  = "#5cab96";
        color10 = "#adcab8";
        color3  = "#e3cd7b";
        color11 = "#ffc777";
        color4  = "#0e548b";
        color12 = "#67a0cd";
        color5  = "#e35a00";
        color13 = "#ff8a39";
        color6  = "#06afc7";
        color14 = "#83a6b3";
        color7  = "#f0f1ce";
        color15 = "#fefff0";

      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";
      history = {
        expireDuplicatesFirst = true;
        path = ".config/zsh/.zsh_history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "lambda";
      };
      shellAliases = {
        "ll" = "ls -al";
        "gl" = "git log --graph";
        "gfr" = "git pull --rebase";
        "gco" = "git checkout";
      };
      initExtra = ''
        hg() { history | grep $1 }
        pg() { ps aux | grep $1 }
        function chpwd() {
          emulate -L zsh
          ls
        }
        if [[ -n "$IN_NIX_SHELL" ]]; then
          export PS1="${"\${PS1}%F{red}nix%f"} "
        fi
      '';
      sessionVariables = {
        EDITOR = "vim";
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10";
        NIX_PATH = "/home/gareth/.nix-defexpr/channels:$NIX_PATH";
      };
    };

    tmux = {
      enable = true;
      terminal = "tmux-256color";
      shortcut = "b";
      extraConfig = ''
        set -g mouse on
      '';
    };
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}

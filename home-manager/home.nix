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
    nodejs
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
        vim-elixir
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
        set clipboard=unnamed
        filetype plugin indent on
        set cmdheight=2

        " make it look pretty
        colorscheme tender
        hi CocMenuSel ctermfg=black ctermbg=185

        " Some servers have issues with backup files, see #649.
        set nobackup
        set nowritebackup

        " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
        " delays and poor user experience.
        set updatetime=300

        " Always show the signcolumn, otherwise it would shift the text each time
        " diagnostics appear/become resolved.
        set signcolumn=yes

        " Use tab for trigger completion with characters ahead and navigate.
        " NOTE: There's always complete item selected by default, you may want to enable
        " no select by `"suggest.noselect": true` in your configuration file.
        " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
        " other plugin before putting this into your config.
        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        " Make <CR> to accept selected completion item or notify coc.nvim to format
        " <C-g>u breaks current undo, please make your own choice.
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        " Use <c-space> to trigger completion.
        if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
        else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif

        " Use `[g` and `]g` to navigate diagnostics
        " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)

        " GoTo code navigation.
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        " Use K to show documentation in preview window.
        nnoremap <silent> K :call ShowDocumentation()<CR>

        function! ShowDocumentation()
          if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
          else
            call feedkeys('K', 'in')
          endif
        endfunction

        " Highlight the symbol and its references when holding the cursor.
        autocmd CursorHold * silent call CocActionAsync('highlight')

        " Symbol renaming.
        nmap <leader>rn <Plug>(coc-rename)

        " Formatting selected code.
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)

        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder.
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end

        " Applying codeAction to the selected region.
        " Example: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)

        " Remap keys for applying codeAction to the current buffer.
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Apply AutoFix to problem on the current line.
        nmap <leader>qf  <Plug>(coc-fix-current)

        " Run the Code Lens action on the current line.
        nmap <leader>cl  <Plug>(coc-codelens-action)

        " Map function and class text objects
        " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)

        " Remap <C-f> and <C-b> for scroll float windows/popups.
        if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif

        " Use CTRL-S for selections ranges.
        " Requires 'textDocument/selectionRange' support of language server.
        nmap <silent> <C-s> <Plug>(coc-range-select)
        xmap <silent> <C-s> <Plug>(coc-range-select)

        " Add `:Format` command to format current buffer.
        command! -nargs=0 Format :call CocActionAsync('format')

        " Add `:Fold` command to fold current buffer.
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)

        " Add `:OR` command for organize imports of the current buffer.
        command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

        " Mappings for CoCList
        " Show all diagnostics.
        nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions.
        nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
        " Show commands.
        nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document.
        nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols.
        nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list.
        nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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

        copy_on_select = true;

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

{ inputs }:

{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.bat
    pkgs.fd
    pkgs.firefox
    pkgs.fzf
    pkgs.git-crypt
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.rofi
    pkgs.tree
    pkgs.watch
    pkgs.zathura
    pkgs.ghq
    pkgs.tig
    pkgs.chromium
    pkgs._1password-cli
    pkgs.dpkg
    pkgs.openssl
    pkgs.unzip
    pkgs.wget
    pkgs.nodejs
    pkgs.gopls
    pkgs.zls
    pkgs.zig

    pkgs.claude-code
    pkgs.codex
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    OPENAI_API_KEY = "op://credential/notesPlain";
  };

  home.file.".gdbinit".source = ./gdbinit;
  home.file.".inputrc".source = ./inputrc;

  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  xdg.configFile."ghostty/config".text = builtins.readFile ./ghostty.linux;
  xdg.configFile."jj/config.toml".text = builtins.readFile ./jujutsu.toml;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = true;

  home.stateVersion = "18.09";

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
  };

  programs.direnv= {
    enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      "source ${pkgs.theme-bobthefish}/functions/fish_prompt.fish"
      "source ${pkgs.theme-bobthefish}/functions/fish_right_prompt.fish"
      "source ${pkgs.theme-bobthefish}/functions/fish_title.fish"
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";

      # Two decades of using a Mac has made this such a strong memory
      # that I'm just going to keep it consistent.
      pbcopy = "xclip";
      pbpaste = "xclip -o";
    };

    plugins = [
      {
        name = "theme-bobthefish";
        src  = pkgs.theme-bobthefish;
      }
      {
        name = "fish-fzf";
        src  = pkgs.fish-fzf;
      }
      {
        name = "fish-ghq";
        src  = pkgs.fish-ghq;
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = "Shintaro Okumura";
    userEmail = "shinta@gx14ac.com";
    signing = {
      key = "54CA37D9C860E387";
      signByDefault = true;
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "gx14ac";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "source/go";
  };

  programs.jujutsu = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "x";
    secureSocket = false;
    clock24 = true;
    keyMode = "vi";

    extraConfig = ''
      unbind C-b

      set -ga terminal-overrides ",*256col*:Tc"
    
      set -g @dracula-show-battery false
      set -g @dracula-show-network false
      set -g @dracula-show-weather false
      set -g prefix C-x

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      setw -g mode-keys vi
      bind -T copy-mode-vi v send -X begin-selection
      bind | split-window -h
      bind - split-window -v
    
      run-shell ${pkgs.tmux-pain-control}/pain_control.tmux
      run-shell ${pkgs.tmux-dracula}/dracula.tmux
    #'';
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  
    plugins = with pkgs; [
      customVim.vim-cue
      customVim.vim-fish
      customVim.vim-fugitive
      customVim.vim-misc
      customVim.vim-tla
      customVim.vim-dracula
      customVim.vim-zig
      customVim.AfterColors
      customVim.vim-nord

      customVim.nvim-comment
      customVim.nvim-codecompanion
      customVim.nvim-conform
      customVim.nvim-dressing
      customVim.nvim-gitsigns
      customVim.nvim-lualine
      customVim.nvim-lspconfig
      customVim.nvim-nui
      customVim.nvim-render-markdown
      customVim.nvim-plenary
      customVim.nvim-telescope
      customVim.nvim-treesitter-context
      customVim.github-nvim-theme
  
      vimPlugins.vim-airline
      vimPlugins.vim-airline-themes
      vimPlugins.vim-eunuch
      vimPlugins.vim-gitgutter
      vimPlugins.vim-markdown
      vimPlugins.vim-nix
      vimPlugins.nvim-treesitter-parsers.elixir
      vimPlugins.nvim-treesitter
      vimPlugins.typescript-vim
      vimPlugins.copilot-lua
    ];
  
    extraConfig = (import ./vim-config.nix) { inherit pkgs; };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}

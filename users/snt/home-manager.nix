{ inputs }:

{ config, lib, pkgs, ... }:

let
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

    amp = "op run -- amp";
    codex = "op run -- codex";
    # claude alias is defined as a fish function below (op run breaks TTY)
  };
in {
  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  xdg.configFile."i3/config" = { source = ./i3; force = true; };
  xdg.configFile."ghostty/config" = { source = ./ghostty.linux; force = true; };

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.bat
    pkgs.chezmoi
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
    pkgs.clang-tools
    pkgs.valgrind
    pkgs.gdb

    pkgs.codex
    pkgs.code-cursor
    pkgs.claude-code
    pkgs.awscli2
  ] ++ lib.optionals (pkgs.unstable ? amp) [
    pkgs.unstable.amp
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
    # These are resolved by `op run` when using amp/codex aliases
    # OPENAI_API_KEY = "op://credential/notesPlain";
    # AMP_API_KEY = "op://credential/ampApiKey";

    # Claude Code with AWS Bedrock
    CLAUDE_CODE_USE_BEDROCK = "1";
    AWS_REGION = "us-east-1";
    # Primary: Sonnet 4.5
    ANTHROPIC_MODEL = "us.anthropic.claude-sonnet-4-5-20250929-v1:0";
    # Small/Fast: Haiku 4.5
    ANTHROPIC_SMALL_FAST_MODEL = "us.anthropic.claude-haiku-4-5-20251001-v1:0";
    # Output / thinking limits
    CLAUDE_CODE_MAX_OUTPUT_TOKENS = "8192";
    MAX_THINKING_TOKENS = "1024";
  };

  # Dotfiles are managed by chezmoi - auto-apply on activation
  home.activation.chezmoi = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.chezmoi}/bin/chezmoi apply --force --source ~/git/github.com/shintaoku/dotfiles || true
  '';

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = true;

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  services.ssh-agent.enable = true;

  home.stateVersion = "18.09";

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = shellAliases;
  };

  programs.direnv = {
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
      # Claude Code model switching functions
      ''
      function claude
          set -lx AWS_ACCESS_KEY_ID (op read op://env/claude-code-nix/env/AWS_ACCESS_KEY_ID)
          set -lx AWS_SECRET_ACCESS_KEY (op read op://env/claude-code-nix/env/AWS_SECRET_ACCESS_KEY)
          command claude $argv
      end

      function claude-env
          echo "AWS_REGION: $AWS_REGION"
          echo "PRIMARY: $ANTHROPIC_MODEL"
          echo "FAST: $ANTHROPIC_SMALL_FAST_MODEL"
          echo "MAX_OUT: $CLAUDE_CODE_MAX_OUTPUT_TOKENS THINK: $MAX_THINKING_TOKENS"
      end

      function sonnet
          set -gx ANTHROPIC_MODEL "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
          echo "✓ Primary set to Sonnet 4.5"
      end

      function opus
          set -gx ANTHROPIC_MODEL "us.anthropic.claude-opus-4-5-20251101-v1:0"
          echo "✓ Primary set to Opus 4.5"
      end
      ''
    ]);

    shellAliases = shellAliases;

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
      key = "69847720DA9C3381F589A505118AE47F5FD3E630";
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
    '';
  };

  programs.kitty = {
    enable = true;
    # Config managed by chezmoi
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

    # Plugins still managed by Nix for reproducibility
    plugins = with pkgs; [
      customVim.vim-cue
      customVim.vim-fish
      customVim.vim-fugitive
      customVim.vim-misc
      customVim.vim-tla
      customVim.vim-zig
      customVim.AfterColors
      customVim.vim-nord

      # dracula-nvim from nixpkgs (Treesitter supported)
      vimPlugins.dracula-nvim

      # catppuccin theme (Treesitter supported)
      vimPlugins.catppuccin-nvim

      customVim.nvim-comment
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
      vimPlugins.nvim-treesitter
      vimPlugins.nvim-treesitter.withAllGrammars
      # Or specify individual parsers:
      # vimPlugins.nvim-treesitter-parsers.go
      # vimPlugins.nvim-treesitter-parsers.lua
      # vimPlugins.nvim-treesitter-parsers.nix
      # vimPlugins.nvim-treesitter-parsers.python
      # vimPlugins.nvim-treesitter-parsers.rust
      # vimPlugins.nvim-treesitter-parsers.typescript
      # vimPlugins.nvim-treesitter-parsers.javascript
      vimPlugins.typescript-vim
      customVim.llama-vim
      customVim.nvim-cmp
      customVim.cmp-nvim-lsp
      customVim.cmp-buffer
      customVim.cmp-vsnip
      customVim.vim-vsnip
    ];

    # Config managed by chezmoi (~/.config/nvim/init.lua)
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}

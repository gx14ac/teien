{ config, lib, pkgs, ... }:

{
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
    pkgs._1password

    pkgs.go
    pkgs.gopls
    pkgs.zig-master

    pkgs.tetex
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
  };

  home.file.".gdbinit".source = ./gdbinit;
  home.file.".inputrc".source = ./inputrc;

  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;

  # tree-sitter parsers
  xdg.configFile."nvim/parser/proto.so".source = "${pkgs.tree-sitter-proto}/parser";
  xdg.configFile."nvim/queries/proto/folds.scm".source = "${pkgs.tree-sitter-proto}/queries/folds.scm";
  xdg.configFile."nvim/queries/proto/highlights.scm".source = "${pkgs.tree-sitter-proto}/queries/highlights.scm";
  xdg.configFile."nvim/queries/proto/textobjects.scm".source = ./textobjects.scm;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = true;

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
    userEmail = "flekystyley@gmail.com";
    #signing = {
    #  key = "523D5DC389D273BC";
    #  signByDefault = true;
    #};
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "shintard";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "source/go";
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "x";
    secureSocket = false;
    clock24 = true;
    keyMode = "vi";

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"
    
      set -g @dracula-show-battery false
      set -g @dracula-show-network false
      set -g @dracula-show-weather false
    
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
    package = pkgs.neovim-nightly;
  
    plugins = with pkgs; [
      customVim.vim-cue
      customVim.vim-fish
      customVim.vim-fugitive
      customVim.vim-misc
      customVim.vim-tla
      customVim.vim-zig
      customVim.AfterColors
      customVim.vim-nord
      customVim.nvim-comment
      customVim.nvim-tree
      customVim.nvim-lspconfig
      customVim.nvim-plenary # depends on telescope
      customVim.nvim-telescope
      customVim.nvim-treesitter
      customVim.nvim-treesitter-playground
      customVim.nvim-treesitter-textobjects
  
      vimPlugins.vim-airline
      vimPlugins.vim-airline-themes
      vimPlugins.vim-eunuch
      vimPlugins.vim-gitgutter
      vimPlugins.vim-markdown
      vimPlugins.vim-nix
      vimPlugins.typescript-vim
    ];
  
    extraConfig = (import ./vim-config.nix) { inherit pkgs; };
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";

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

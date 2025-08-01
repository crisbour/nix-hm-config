{config, pkgs, ...}:
let
  hasGUI = config.home.user-info.has_gui;
  packagedExtensions = with pkgs.vscode-extensions; [
      asciidoctor.asciidoctor-vscode
      vscodevim.vim
      mkhl.direnv
      #asvetliakov.vscode-neovim
      ms-python.python
      arrterian.nix-env-selector
      #pinage404.nix-extension-pack
      bbenoist.nix
      #pinage404.nix-extension-pack
      editorconfig.editorconfig
      rust-lang.rust-analyzer
      #ms-azuretools.vscode-docker
      #ms-python.python
      #ms-python.vscode-pylance
      ms-toolsai.jupyter
      #ms-vscode.cpptools
      julialang.language-julia
  ];
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "vscode-sshfs";
      publisher = "Kelvin";
      version = "1.25.0";
      sha256 = "7358e9649e54b23787d7e343f4d71777a14ab2f0acf093051a649d2b6aeea26c";
    }
    {
      name = "postman-for-vscode";
      publisher = "Postman";
      version = "1.10.1";
      sha256 = "sha256-DyibkdR8gfU2spND2BasRdUr7vckMe9TNv+EyygyGEQ=";
    }
    {
      name = "vscode-h5web";
      publisher = "h5web";
      version = "0.1.9";
      sha256 = "sha256-Qi0FTjInZ+HgGtqN5Z+pVktPHApSsfsrypyVWDtqZrg=";
    }
  ];
in
{

  home.packages = [
    pkgs.platformio
  ];

  programs.vscode = {
    enable = hasGUI;
    #package = pkgs.vscode-fhsWithPackages (pkgs: with pkgs; [ zlib rustup ]);
    profiles.default ={
      extensions = packagedExtensions ++ marketplaceExtensions;
      userSettings = {
        #"vim.enableNeovim" = true;
        #"vim.neovimPath" = "/home/cristi/.nix-profile/bin/nvim";

        # Visual: Enable ligatures
        "editor.fontLigatures" = true;

        # Third-party extensions
        "jupyter.askForKernelRestart" = false;
        "jupyter.diagnostics.reservedPythonNames.enabled" = false;
        "rust-analyzer.lens.enable" = false;
        "rust-analyzer.inlayHints.enable" = false;
        # TODO: Configure vs-code and neovim integration: https://medium.com/@nikmas_dev/vscode-neovim-setup-keyboard-centric-powerful-reliable-clean-and-aesthetic-development-582d34297985

        "julia.executablePath" = "/home/cristi/.nix-profile/bin/julia";
        "julia.execution.codeInREPL" = true;
        "terminal.integrated.commandsToSkipShell" = [ "language-julia.interrupt" ];

        # Neovim support
        #"extensions.experimental.affinity" = {
        #  "asvetliakov.vscode-neovim" = 1;
        #};
        #"vscode-neovim.neovimExecutablePaths.linux" = /home/cristi/.nix-profile/bin/nvim;
        #"vscode-neovim.neovimInitVimPaths.linux" = "$HOME/.config/nvim/init.lua";
      };
    };
    #idx.extensions = [
    #  "mhutchie.git-graph"
    #  "streetsidesoftware.code-spell-checker"
    #  "oderwat.indent-rainbow"
    #];
    #keybindings = [
    #];
  };
}

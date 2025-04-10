{ pkgs, inputs, ... }:
# Heavily inspired by https://github.com/anotherhadi/nixy/blob/main/themes/stylix/2025.nix
{
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
     # Edited catppuccin
    #base16Scheme = {
    #  base00 = "0b0b0b"; # Default Background
    #  base01 =
    #    "1b1b1b"; # Lighter Background (Used for status bars, line number and folding marks)
    #  base02 = "2b2b2b"; # Selection Background
    #  base03 = "45475a"; # Comments, Invisibles, Line Highlighting
    #  base04 = "585b70"; # Dark Foreground (Used for status bars)
    #  base05 = "fcfcfc"; # Default Foreground, Caret, Delimiters, Operators
    #  base06 = "f5e0dc"; # Light Foreground (Not often used)
    #  base07 = "b4befe"; # Light Background (Not often used)
    #  base08 =
    #    "f38ba8"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    #  base09 =
    #    "fab387"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    #  base0A = "f9e2af"; # Classes, Markup Bold, Search Text Background
    #  base0B = "a6e3a1"; # Strings, Inherited Class, Markup Code, Diff Inserted
    #  base0C =
    #    "94e2d5"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    #  base0D =
    #    "A594FD"; # Functions, Methods, Attribute IDs, Headings, Accent color
    #  base0E =
    #    "cba6f7"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    #  base0F =
    #    "f2cdcd"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    #};

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "NerdFontsSymbolsOnly" "JetBrainsMono" ]; });
        #name = "JetBrains Mono Nerd Font";
        name = "Iosevka Nerd Font";
      };
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 13;
        terminal = 12;
      };
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    polarity = "dark";
    image = pkgs.fetchurl {
      url =
        "https://github.com/anotherhadi/nixy-wallpapers/blob/main/wallpapers/"
        + "clouds-4.png" + "?raw=true";
      sha256 = "sha256-Z9H48uIhGVckEWYyofpyjziPf35rswG7RKS2DIqbYJ4=";
    };
  };
}

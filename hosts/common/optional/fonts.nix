{ pkgs, ... }:
{
  # Followed from steroids configs: https://github.com/workflow/dotfiles/tree/c8186106da0cfce1d1c37716720a732c0c98aebd
  fonts.packages = [
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.nerd-fonts.fira-code # Extension for enlarged operators
    pkgs.nerd-fonts.noto
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-monochrome-emoji
  ];
}

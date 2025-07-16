{ pkgs, ... }:
{
  # Followed from steroids configs: https://github.com/workflow/dotfiles/tree/c8186106da0cfce1d1c37716720a732c0c98aebd
  fonts.packages = [
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.font-awesome
    pkgs.font-awesome_4
    pkgs.font-awesome_5
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.inconsolata
    pkgs.noto-fonts # For microsoft websites like Github and Linkedin on Chromium browsers
  ];
}

# Home-manager NIX

## Alacritty config

Install `alacritty` and `neovim` with home-manager as per resources. 

In order to easily change the alacritty theme and not spend time copying color scheme across, make use of the `alacritty-colorscheme` tool [^al-color].

Grab alacrity theme and link `~/.config/alacritty/colors` to the directory that contains the color schemes.
Then apply the theme buy running `alacritty-colorscheme <scheme_name>.{yml,yaml}`. If you run neo-vim, using the flag `-V` creates the `.vimrc_background` which will make vim use the same theme. Otherwise, you need to explicitly include this in your `.vimrc`.

TODO: Nix Home-manager config to:
- install alacritty-colorscheme
- clone alacritty themes and link/copy color schemes to `.config/alacritty/colors`
- run `alacritty-colorscheme -V <prefered-colorscheme.{yaml,yml}>`. Alternatively, replace colors section with the colorscheme of choice and find a way to configure `.vimrc_background` as well


## Resources
[al-color]: https://github.com/toggle-corp/alacritty-colorscheme




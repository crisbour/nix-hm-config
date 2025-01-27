# Home-manager NIX

## Alacritty config

Install `alacritty` and `neovim` with home-manager as per resources. 

In order to easily change the alacritty theme and not spend time copying color
scheme across, make use of the `alacritty-colorscheme` tool [^al-color].

Grab alacrity theme and link `~/.config/alacritty/colors` to the directory that
contains the color schemes. Then apply the theme buy running
`alacritty-colorscheme <scheme_name>.{yml,yaml}`. If you run neo-vim, using the
flag `-V` creates the `.vimrc_background` which will make vim use the same
theme. Otherwise, you need to explicitly include this in your `.vimrc`.

TODO: Nix Home-manager config to:
- install alacritty-colorscheme
- clone alacritty themes and link/copy colour schemes to
`.config/alacritty/colors`
- run `alacritty-colorscheme -V <prefered-colorscheme.{yaml,yml}>`.
Alternatively, replace colors section with the colorscheme of choice and find a
way to configure `.vimrc_background` as well

## Usage

### Update flakes

```
nix flake update
```

### Configuration

### SecureBoot gotcha

NixOS doesn't provide a signed image, hence in order to boot in NixOS
installation, we need to disable shim layer verification from within a trusted
live session. Boot into ubuntu and disable verification:
```
 sudo mokutil --disable-validation
```


### NixOS

1. Setup partitions and mount them:

```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode mount ./hosts/<your_host>/disko-config.nix
# Or just mount them if we are in fixup mode (boot from libe session to fix our current install)
sudo nix run github:nix-community/disko -- --mode zap_create_mount ./disko-config.nix
```

2. Install, but if running with [lanzaboote]() dissable it for initial
   installation.

```
sudo nixos-install --root /mnt --flake .#<your_host>
```

3. (if using lanzaboote)
    a) generate keys using `sbctl`. ==WARN stable/unstable sbctl generate their
    keys in `/etc/secureboot` or `/var/lib/sbctl` respectively==
    ```
    sbct create-keys
    ```
    b) Reinstall just as in step (2.) with `lanzaboote` enabled using the 
    `pkiPath` pointing to the correct destination.
    c) Enter BIOS setup mode and clean-up all keys or enter `Audit Mode`
    d) En-roll your keys with Microsoft signature
    ```
    sbctl enrol-keys -m
    ```

### Home

Because this make use of env variables `USER` and `HOME` it is not a pure
derivation, therefore it requires the `impure` argument.

```
home-manager switch --impure --flake .#<name_of_configuration>
```

Flakes are an experimental feature in older release. In order to make use of
them without verbosity in the command, allow flakes if you are following
nix-unstable. Add the following to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

## Debug

Running X11 apps under Wayland sometimes ends up with issues:
- hardware mouse offset due to fractional scalling
- window goes blank when application spawns new window. This is probably not a graphics issue as on an intel only desktop the problem persists.

### Momentary fix

Nix problem can be circumvented atm using a full fledged compositor for wayland, such as `weston`. This still has a few downsides:

- Fixed window size on the screen
- In per window mode, can have other windows being spawned

1. Full window:
```bash
weston -B x11 --xwayland
```

2. App with a sole window (this works nicely) 
```bash
weston -B x11 --xwayland --shell="kiosk-shell.so"
```


==TODO Hyprland compositor should suffice as well if we sort out what is the alternative of how weston renders the X11 windows==
- [ ] Could the problem be caused by using the lightweight greetd window manager? Try GDM and see if the problem persists

### TODO

- [ ] I like swaylock better than hyprlock
- [x] pinentry-ghome3 doesn't work in hyprland, even with hyprpolkitagent and
gcr enabled; using pinentry-qt for now, which looks bad
- [ ] I quite like how JManch puts assertions to check his config and document
what has been working and what not
- [x] Add `git` to flake dependencies as containers or minimal system might not have it
- [x] Allow Unfree: Not working with Flakes for my config, find alternative
- [ ] How to install `nixgl.auto.nixGLDefault` from home-manager?
- [ ] Use XanMod for Nexus in order to have out of the box Google's TCP BRR for
  increased TCP throughput

#### Inbox
- [Hyprnova: Hyprland
configs](https://github.com/zDyanTB/HyprNova/tree/master?tab=readme-ov-file)

## Resources
[al-color]: https://github.com/toggle-corp/alacritty-colorscheme
- [Nix builtins and lib
  ref](https://teu5us.github.io/nix-lib.html#nixpkgs-library-functions)

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kicad
    # Xilinx wrapper https://gitlab.com/doronbehar/nix-xilinx/-/tree/master?ref_type=heads
    inputs.nix-xilinx.xilinx-shell
    inputs.nix-xilinx.vivado
    inputs.nix-xilinx.vitis
    inputs.nix-xilinx.vitis_hls
    inputs.nix-xilinx.model_composer
    inputs.nix-xilinx.petalinux-install-shell

    ltspice
  ];
}

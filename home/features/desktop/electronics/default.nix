{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kicad

    # FIXME: Waveforms fails to be pulled
    #inputs.waveforms.waveforms

    prusa-slicer

    picoscope
  ];
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    julia-bin
  ];

  home.file.".julia/config/startup.jl".source = ./startup.jl;
  home.file.".julia/config/startup_ijulia.jl".text = ''
    # automatically reload code of imported libraries
    # https://timholy.github.io/Revise.jl/stable/config
    try
        @eval using Revise
    catch e
        @warn "Error initializing Revise" exception=(e, catch_backtrace())
    end
  '';

}

{pkgs, ...}:
{
  imports = [
    #./syncthing.nix
  ];

  # Ollama - Local LLM service for AI code suggestions (avante-nvim)
  services.ollama = {
    enable = true;
    # FIXME: overlays something don't apply to the nixos flake, so unstable is not reachable
    package = pkgs.ollama-cuda;
    host = "127.0.0.1";
    port = 11434;
    #syncModels = true;
    loadModels = [
      "llama3.2"
      "qwen2.5-coder:7b"
    ];

    # Optional: Set environment variables
    environmentVariables = {
      # OLLAMA_MODELS = "/var/lib/ollama/models"; # Default location
      # OLLAMA_ORIGINS = "*"; # Allow all CORS origins (for web UIs)
    };
  };
}

{pkgs, ...}:
{
  imports = [
    #./syncthing.nix
  ];

  # Ollama - Local LLM service for AI code suggestions (avante-nvim)
  services.ollama = {
    enable = true;
    #package = pkgs.unstable.ollama-cuda;
    acceleration = "cuda";
    host = "127.0.0.1";
    port = 11434;
    #syncModels = true;
    loadModels = [
      "llama3.2"
      "qwen2.5-coder:7b"
    ];
    # Uncomment for GPU acceleration (requires NVIDIA drivers)
    # acceleration = "cuda";
    # Or for AMD: acceleration = "rocm";
    # Or for Vulkan: acceleration = "vulkan";

    # Optional: Set environment variables
    environmentVariables = {
      # OLLAMA_MODELS = "/var/lib/ollama/models"; # Default location
      # OLLAMA_ORIGINS = "*"; # Allow all CORS origins (for web UIs)
    };
  };
}

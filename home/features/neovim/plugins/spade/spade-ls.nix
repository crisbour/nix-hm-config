{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitLab writeText;
  src-spade-language-server = fetchFromGitLab {
    owner = "spade-lang";
    repo = "spade-language-server";
    rev = "1617d4da678340a8d6899b5dd5744406e1fdfdbc";  # Specify the commit or tag
    sha256 = "sha256-vNkKQ0U3EXX3BQxNlPA2FQDuQjaSh7yEiJL8ZdRS3pM=";  # Provide the hash for the source
  };
  spade-language-server = rustPlatform.buildRustPackage {
      pname = "spade-language-server";
      version = "0.1.0";  # Specify the version if needed
      nativeBuildInputs = [
        openssl
        pkg-config
      ];
      src = src-spade-language-server;
      PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
      cargoLock = {
        lockFile = src-spade-language-server + "/Cargo.lock";
        outputHashes = {
          "codespan-0.12.0" = "sha256-3F2006BR3hyhxcUTaQiOjzTEuRECKJKjIDyXonS/lrE=";
          "spade-0.9.0" = "sha256-dFp20ZktuKFKNOnUR7Izm+mJMFv5wx25mt7YEFeMNw0=";
          "swim-0.9.0" = "sha256-hrnoYI1DbV3zLQcXspjzJUruY+7OxAv3aOB91q2rUaw=";
        };
      };
    };
in
spade-language-server

{ pkgs, ... }:
with pkgs;
let
  inherit stdenv fetchFromGitLab writeText;
  src-swim = fetchFromGitLab {
    owner = "spade-lang";
    repo = "swim";
    rev = "2d3a3db22226b9b19f7c48027fcaabef10192ea0";  # Specify the commit or tag
    sha256 = "sha256-jEmsGmtLZrOZUzSEOpnfXwtxy3DDSEfFbKp0rdRkfHI=";  # Provide the hash for the source
  };
  swim = rustPlatform.buildRustPackage {
      pname = "swim";
      version = "0.9.0";  # Specify the version if needed
      nativeBuildInputs = [
        openssl
        pkg-config
        git
      ];
      src = src-swim;
      # Disable the check phase to ignore cargo test
      doCheck = false;

      PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
      cargoLock = {
        lockFile = src-swim + "/Cargo.lock";
        #outputHashes = {
        #  "spade-0.9.0" = "sha256-dFp20ZktuKFKNOnUR7Izm+mJMFv5wx25mt7YEFeMNw0=";
        #};
      };
    };
in
swim

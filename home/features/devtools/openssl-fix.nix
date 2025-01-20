{ pkgs, ... }:
{
  home.packages = with pkgs;[
    openssl
    openssl.dev
    pkg-config
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    #OPENSSL_DIR = "${pkgs.openssl.dev}";
  };
}

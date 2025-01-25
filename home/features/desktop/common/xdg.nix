{ pkgs, lib, ... }:
with lib;
let
  defaultApps = {
    browser            = [ "zen.desktop" ];
    text               = [ "nvim.desktop" ];
    image              = [ "oculante.desktop" ];
    audio              = [ "mpv.desktop" ];
    video              = [ "mpv.desktop" ];
    directory          = [ "nemo.desktop" ];
    office             = [ "libreoffice.desktop" ];
    #TODO: Checkout Zathura
    pdf                = [ "okular.desktop" ];
    terminal           = [ "kitty.desktop" ];
    archive            = [ "org.gnome.FileRoller.desktop" ];
    discord            = [ "webcord.desktop" ];
    mw-matlabconnector = [ "mw-matlabconnector.desktop" ];
    mw-simulink        = [ "mw-simulink.desktop" ];
    mw-matlab          = [ "mw-matlab.desktop" ];
  };

  mimeMap = {
    text = [
      "text/plain"
      "text/markdown"
      "text/plain"
      "text/x-shellscript"
      "text/x-python"
      "text/x-go"
      "text/css"
      "text/javascript"
      "text/x-c"
      "text/x-c++"
      "text/x-java"
      "text/x-rust"
      "text/x-yaml"
      "text/x-toml"
      "text/x-dockerfile"
      "text/x-xml"
      "text/x-php"
    ];
    image = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/webp"
    ];
    audio = [
      "audio/aac"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/wav"
      "audio/webm"
      "audio/x-matroska"
    ];
    video = [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/webm"
      "video/x-flv"
      "video/x-matroska"
      "video/x-msvideo"
    ];
    directory = [ "inode/directory" ];
    browser = [
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
    office = [
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/msword"
      "application/vnd.ms-excel"
      "application/vnd.ms-powerpoint"
      "application/rtf"
    ];
    pdf = [ "application/pdf" ];
    terminal = [ "terminal" ];
    archive = [
      "application/zip"
      "application/rar"
      "application/7z"
      "application/*tar"
    ];
    discord = [ "x-scheme-handler/discord" ];
    mw-matlabconnector = [ "x-scheme-handler/mw-matlabconnector" ];
    mw-simulink        = [ "x-scheme-handler/mw-simulink" ];
    mw-matlab          = [ "x-scheme-handler/mw-matlab" ];
  };

  associations =
    with lists;
    listToAttrs (
      flatten (
        mapAttrsToList (
          key: map (type: attrsets.nameValuePair type defaultApps."${key}")
        ) mimeMap
      )
    );
in
{
  xdg = {
    enable = true;
    # TODO mimeTypes?
    #configFile."mimeapps.list".force = true;
    mimeApps.enable = true;
    mimeApps.associations.added = associations;
    mimeApps.defaultApplications = associations;

  };

  #xdg.portal.enable = true;
  #xdg.portal.config.common.default = "*";
  #xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  home.sessionVariables = {
    # prevent wine from creating file associations
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
  };
}

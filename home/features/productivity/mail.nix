{
  pkgs,
  lib,
  config,
  ...
}: let
  mbsync = "${config.programs.mbsync.package}/bin/mbsync";
  pass = "${config.programs.password-store.package}/bin/pass";

  common = rec {
    realName = "Cristian Bourceanu";
    gpg = {
      # TODO Replace with my own sign key
      key = "09B0 879F FEF5 5E7B 046E  58C7 AEF4 A543 011E 8AC1";
      signByDefault = true;
    };
    signature = {
      showSignature = "append";
      text = ''
        ${realName}

        PGP: ${gpg.key}
      '';
      # TODO Add my own blog to the email signature if I end up creating one
    };
  };
in {
  # TODO Opt in mail to persist if I decide to use clean system
  #home.persistence = {
  #  "/persist/${config.home.homeDirectory}".directories = ["Mail"];
  #};

  accounts.email = {
    maildirBasePath = "Mail";
    accounts = {

      # TODO Add protonmail for outmost important emails
      personal =
        rec {
          primary = true;
          address = "bourceanu.cristi@gmail.com";
          #passwordCommand = "${pass} google.com/accounts.google.com/${address} | head -n1";
          passwordCommand = "${pass} ${smtp.host}";

          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };
          #folders = {
          #  inbox  = "Inbox";
          #  drafts = "Drafts";
          #  sent   = "Sent";
          #  trash  = "Trash";
          #};
          neomutt = {
            enable = true;
            #extraMailboxes = [
            #  "Archive"
            #  "Drafts"
            #  "Junk"
            #  "Sent"
            #  "Trash"
            #];
          };
          notmuch.enable = true;

          imap.host = "imap.gmail.com";
          msmtp.enable = true;
          smtp.host = "smtp.gmail.com";
          userName = address;
        }
        // common;

      university =
        rec {
          address = "s2703496@ed.ac.uk";
          aliases = [
            "V.C.Bourceanu@sms.ed.ac.uk"
          ];

          passwordCommand = "${pass} ease.ed.ac.uk | head -n1";

          mbsync = {
            enable = true;
            create = "maildir";
            #expunge = "both";
          };
          neomutt = {
            enable = true;
          };
          notmuch.enable = true;

          imap.host = "outlook.office365.com";
          smtp.host = "outlook.office365.com";
          msmtp.enable = true;
          userName = address;
        }
        // common;

      junk =
        rec {
          address = "bourceanu_cristi@yahoo.com";
          passwordCommand = "${pass} mbsync/${address}";

          mbsync = {
            enable = true;
            create = "maildir";
            #expunge = "both";
          };
          neomutt.enable = true;
          notmuch.enable = true;

          imap.host = "imap.mail.yahoo.com";
          smtp.host = "smtp.mail.yahoo.com";
          msmtp.enable = true;
          userName = address;
        }
        // common;
    };
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  #systemd.user.services.mbsync = {
  #  Unit = {
  #    Description = "mbsync synchronization";
  #  };
  #  Service = let
  #    gpgCmds = import ../cli/gpg-commands.nix {inherit pkgs;};
  #  in {
  #    Type = "oneshot";
  #    ExecCondition = ''
  #      /bin/sh -c "${gpgCmds.isUnlocked}"
  #    '';
  #    ExecStart = "${mbsync} -a";
  #  };
  #};
  #systemd.user.timers.mbsync = {
  #  Unit = {
  #    Description = "Automatic mbsync synchronization";
  #  };
  #  Timer = {
  #    OnBootSec = "30";
  #    OnUnitActiveSec = "5m";
  #  };
  #  Install = {
  #    WantedBy = ["timers.target"];
  #  };
  #};
}

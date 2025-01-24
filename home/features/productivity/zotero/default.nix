{ config, lib, pkgs, ... }:
# Copied from https://github.com/somasis/nixos/blob/665bf28a1a36246c57b50cc10eb7afce6fc70de2/users/somasis/desktop/study/citation.nix#L122
let
  study = "${config.home.homeDirectory}/study";

  # TODO Add UoE proxy
  # proxy = "";
in
{
  imports = [ ];

  programs.zotero = {
    enable = true;

    package = pkgs.zotero;

    profiles.default = {
      # TODO installation seems broken?
      extensions = with pkgs.zotero-addons; [
        zotero-abstract-cleaner
        zotero-auto-index
        zotero-ocr
        zotero-open-pdf
        zotero-preview
        zotero-robustlinks
        zotero-storage-scanner
        zotmoov
        zotero-delitemwithatt
        scite-zotero
        cita
        ai-research-assistant
        #zotero-gpt
        zotero-better-notes
      ];

      settings =
        let
          # Chicago Manual of Style [latest] edition (note)
          style = "https://www.zotero.org/styles/ieee-sensors-journal";
          locale = "en-US";
        in
        {
          # See <https://www.zotero.org/support/preferences/hidden_preferences> also.
          "general.smoothScroll" = false;
          "intl.accept_language" = "en-US, en";

          # Use the flake-provided versions of translators and styles.
          "extensions.zotero.automaticScraperUpdates" = false;

          # Use Appalachian State University's OpenURL resolver
          #"extensions.zotero.openURL.resolver" = "${proxy}?url=https://resolver.ebscohost.com/openurl?";
          "extensions.zotero.findPDFs.resolvers" = [
            {
              "name" = "Sci-Hub";
              "method" = "GET";
              "url" = "https://sci-hub.ru/{doi}";
              "mode" = "html";
              "selector" = "#pdf";
              "attribute" = "src";
              "automatic" = true;
            }
            {
              "name" = "Google Scholar";
              "method" = "GET";
              "url" = "{z:openURL}https://scholar.google.com/scholar?q=doi%3A{doi}";
              "mode" = "html";
              "selector" = ".gs_or_ggsm a:first-child";
              "attribute" = "href";
              "automatic" = true;
            }
          ];

          # Sort settings
          "extensions.zotero.sortAttachmentsChronologically" = true;
          "extensions.zotero.sortNotesChronologically" = true;

          # Item adding settings
          "extensions.zotero.automaticSnapshots" = true; # Take snapshots of webpages when items are made from them
          "extensions.zotero.translators.RIS.import.ignoreUnknown" = false; # Don't discard unknown RIS tags when importing
          "extensions.zotero.translators.attachSupplementary" = true; # "Translators should attempt to attach supplementary data when importing items"

          # Citation settings
          "extensions.zotero.export.lastStyle" = style;
          "extensions.zotero.export.quickCopy.locale" = locale;
          "extensions.zotero.export.quickCopy.setting" = "bibliography=${style}";
          "extensions.zotero.export.citePaperJournalArticleURL" = false;

          # Feed options
          "extensions.zotero.feeds.defaultTTL" = 24 * 7; # Refresh feeds every week
          "extensions.zotero.feeds.defaultCleanupReadAfter" = 60; # Clean up read feed items after 60 days
          "extensions.zotero.feeds.defaultCleanupUnreadAfter" = 90; # Clean up unread feed items after 90 days

          # Attachment settings
          "extensions.zotero.useDataDir" = true;
          "extensions.zotero.dataDir" = "${config.home.homeDirectory}/Zotero";
          "extensions.zotero.saveRelativeAttachmentPath" = true;
          "extensions.zotero.baseAttachmentPath" = "${study}/doc";

          # Reading settings
          "extensions.zotero.tabs.title.reader" = "filename"; # Show filename in tab title

          # Sync settings
          "extensions.zotero.sync.storage.enabled" = false; # File synchronization is handled by Syncthing.
          # "extensions.zotero.attachmentRenameFormatString" = "{%c - }%t{100}{ (%y)}"; # Set the file name format used by Zotero's internal stuff

          "extensions.zotero.autoRenameFiles.fileTypes" = lib.concatStringsSep "," [
            "application/pdf"
            "application/epub+zip"
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            "application/vnd.oasis.opendocument.text"
          ];

          "extensions.zotero.aria.enabled" = true;

          # Zotero OCR
          "extensions.zotero.zoteroocr.pdftoppmPath" = "${pkgs.poppler_utils}/bin/pdftoppm";
          "extensions.zotero.zoteroocr.ocrPath" = "${pkgs.tesseract}/bin/tesseract";
          "extensions.zotero.zoteroocr.language" = "eng";

          "extensions.zotero.zoteroocr.outputPDF" = true; # Output options > "Save output as a PDF with text layer"
          "extensions.zotero.zoteroocr.overwritePDF" = true; # Output options > "Save output as a PDF with text layer" > "Overwrite the initial PDF with the output"

          "extensions.zotero.zoteroocr.outputHocr" = false; # Output options > "Save output as a HTML/hocr file(s)"
          "extensions.zotero.zoteroocr.outputNote" = false; # Output options > "Save output as a note"
          "extensions.zotero.zoteroocr.outputPNG" = false; # Output options > "Save the intermediate PNGs as well in the folder"

          "ui.use_activity_cursor" = true;

          # Recursive view of articles in the hierarchy
          "extensions.zotero.recursiveCollections" = true;

          # Enable Zotero API
          # TODO: Find how to enable Zotero API to work with Joplin ZoteroLink

          # LibreOffice extension settings
          # TODO Setup LibreOffice perhaps like `somasis` or keep with Joplin BibTex manual export
          # Alternative: explore Zotero Link plugin for Joplin
          #"extensions.zotero.integration.useClassicAddCitationDialog" = true;
          #"extensions.zoteroOpenOfficeIntegration.installed" = true;
          #"extensions.zoteroOpenOfficeIntegration.skipInstallation" = true;
        }

        # TODO Other extensions settings to be enabled
        # // {
        #   # Add-ons > Robust Links (Item adding settings)
        #   "extensions.robustlinks.archiveonadd" = "yes";
        #   "extensions.robustlinks.whatarchive" = "random";

        #   # Add-ons > Citation settings
        #   "extensions.zoteropreview.citationstyle" = style; # Zotero Citation Preview

        #   # Add-ons > DOI Manager
        #   "extensions.shortdoi.tag_invalid" = "#invalid_doi";
        #   "extensions.shortdoi.tag_multiple" = "#multiple_doi";
        #   "extensions.shortdoi.tag_nodoi" = "#no_doi";

        # FIXME: ZotMov replace ZotFile for Zotero 7, port settings for it
        # Add-ons > Zotero PDF Preview
        # "extensions.zotero.pdfpreview.previewTabName" = "PDF"; # Default tab name clashes with Zotero Citation Preview

        #   # Add-ons > Zotero AutoIndex
        #   "extensions.zotero.fulltext.pdfMaxPages" = 1024;

        #   # Add-ons > ZotFile (Attachment settings)
        #   "extensions.zotfile.dest_dir" = "${study}/doc";
        #   "extensions.zotfile.useZoteroToRename" = false; # ZotFile > Renaming Rules > "Use Zotero to Rename";
        #   "extensions.zotfile.pdfExtraction.localeDateInNote" = false;
        #   "extensions.zotfile.pdfExtraction.isoDate" = true; # Use YYYY-MM-DD in the note titles
        #   "extensions.zotfile.pdfExtraction.UsePDFJS" = true; # ZotFile > Advanced Settings > "Extract annotations..." > "Use pdf.js to extract annotations"

        #   # [Last, First - ]title[ (volume)][ ([year][, book title/journal/publisher/meeting])]
        #   "extensions.zotfile.renameFormat" = "{%g - }%t{ (%v)}{ (%y{, %B|, %w})}"; # ZotFile > Renaming Rules > "Format for all Item Types except Patents"

        #   "extensions.zotfile.wildcards.user" = builtins.toString (builtins.toJSON {
        #     "B" = "bookTitle"; # %B: For book sections.
        #     "4" = {
        #       field = "dateAdded";
        #       operations = [{
        #         flags = "g";
        #         function = "replace";
        #         regex = "(\\d{4})-(\\d{2})-(\\d{2})(.*)";
        #         replacement = "$1$2$3";
        #       }];
        #     };
        #   });

        #   "extensions.zotfile.authors_delimiter" = ", "; # ZotFile > Renaming Rules > "Delimiter between multiple authors"

        #   "extensions.zotfile.truncate_title" = true; # ZotFile > Renaming Rules > "Truncate title after . or : or ?"

        #   "extensions.zotfile.truncate_title_max" = true; # ZotFile > Renaming Rules > "Maximum length of title"
        #   "extensions.zotfile.max_titlelength" = 80;

        #   "extensions.zotfile.truncate_authors" = true; # ZotFile > Renaming Rules > "Maximum number of authors"
        #   "extensions.zotfile.max_authors" = 2; # ZotFile > Renaming Rules > "Maximum number of authors"

        #   "extensions.zotfile.removeDiacritics" = true; # ZotFile > Advanced Settings > "Remove special characters (diacritics) from filename"

        #   "extensions.zotfile.import" = false; # ZotFile > Location of Files > Custom Location
        #   "extensions.zotero.autoRenameFiles.linked" = true; # ZotFile > General Settings > Location of Files > Custom Location

        #   "extensions.zotfile.useFileTypes" = true; # ZotFile > Advanced Settings > "Only work with the following filetypes"
        #   "extensions.zotfile.filetypes" = lib.concatStringsSep "," [
        #     "pdf"
        #     "epub"
        #     "docx"
        #     "odt"
        #   ];

        #   "extensions.zotfile.confirmation" = false; # ZotFile > Advanced Settings > "Ask user when attaching new files"
        #   "extensions.zotfile.confirmation_batch" = 0;
        #   "extensions.zotfile.confirmation_batch_ask" = false; # ZotFile > Advanced Settings > "Ask user to (batch) rename or move [0] or more attachments
        #   "extensions.zotfile.automatic_renaming" = 3; # ZotFile > Advanced Settigns > "Automatically rename new attachments" > "Always ask (non-disruptive)"
        # }

        # Configuration options which will only become relevant with Zotero 7.
        // lib.optionalAttrs ((lib.strings.toInt (lib.versions.major (lib.strings.getVersion config.programs.zotero.package))) >= 7) {
          "extensions.zotero.reader.ebookFontFamily" = "serif";

          # "extensions.zotero.openReaderInNewWindow" = true;

          # # ouch
          # "extensions.zotero.attachmentRenameTemplate" = ''
          #   {{ if {{ creators }} != "" }}{{ if {{ creators max="1" name-part-separator=", " }} == {{ creators max="1" name="family-given" }}, }}{{ creators max="2" name="family-given" join=", " suffix=" - " }}{{ else }}{{ if {{ creators max="1" }} != {{ creators max="2" }} }}{{ creators max="1" name="family-given" name-part-separator=", " join=", " suffix=" et al. - " }}{{ else }}{{ creators max="2" name="family-given" name-part-separator=", " join=", " suffix=" - " }}{{ endif }}{{ endif }}{{ else }}{{ creators max="1" name="family-given" name-part-separator=", " }}{{ endif }}{{ if shortTitle != "" }}{{ shortTitle }}{{ else }}{{ if {{ title truncate="80" }} == {{ title }} }}{{ title }}{{ else }}{{ title truncate="80" suffix="..." }}{{ endif }}{{ endif }}{{ if itemType == "book" }} ({{ year }}{{ publisher truncate="80" prefix=", " }}){{ elseif itemType == "bookSection" }} ({{ year }}{{ bookTitle prefix=", " truncate="80" }}){{ elseif itemType == "blogpost" }} ({{ if year != "" }}{{ year }}{{ blogTitle prefix=", " }}{{ else }}{{ blogTitle }}{{ endif }}){{ elseif itemType == "webpage" }} ({{ year }}{{ websiteTitle prefix=", " }}){{ elseif itemType == "newspaperArticle" }} ({{ year }}{{ publicationTitle truncate="80" prefix=", " }}{{ section truncate="80" prefix=", " }}){{ elseif itemType == "presentation" }} ({{ year }}{{ meetingName truncate="80" prefix=", " }}){{ elseif publicationTitle != "" }} ({{ year }}{{ publicationTitle truncate="80" prefix=", " }}{{ if volume != year }}{{ volume prefix=" "  }}{{ endif }}{{ issue prefix=", no. " }}){{ elseif year != "" }} ({{ year }}){{ endif }}
          # '';
          "extensions.zotero.autoRenameFiles.linked" = true;

          # <https://github.com/wileyyugioh/zotmoov>
          # "extensions.zotmoov.dst_dir" = "${study}/doc";
          # "extensions.zotmoov.allowed_fileext" = [ "pdf" "epub" "docx" "odt" ];
          # "extensions.zotmoov.delete_files" = true;

          # Enable userChrome
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        # userChrome = ''
        # * {
        #     /* Disable animations */
        #     transition: none !important;
        #     transition-duration: 0 !important;

        #     /* Square everything */
        #     border-radius: 0 !important;

        #     /* No shadows */
        #     box-shadow: none !important;
        # }

        # :root {
        #     --tab-min-height: 44px;
        # }

        # :root:not([legacytoolbar="true"]) {
        #     --tab-min-height: 36px;
        # }

        # /* Use Arc's style for toolbars */
        # #titlebar {
        #     background: ${config.theme.colors.background} !important; /* config.theme.colors.background */
        #     color: ${config.theme.colors.foreground} !important; /* config.theme.colors.foreground */
        # }
        # '';

    };
  };

  # TODO: Fill in engines to search with: https://github.com/somasis/nixos/blob/665bf28a1a36246c57b50cc10eb7afce6fc70de2/users/somasis/desktop/study/citation.nix#L379

}

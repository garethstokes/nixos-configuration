{ pkgs, ... }:
{
  home = {
    sessionVariables.BROWSER = "firefox";

    file."firefox-gnome-theme" = {
      target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
      source = (fetchTarball {
        url = "https://github.com/rafaelmardojai/firefox-gnome-theme/archive/refs/tags/v126.tar.gz";
        sha256 = "1r6vvhzk8gwhs78k54ppsxzfkw7lbldjivydy87ij6grj3cf6mld";
      });
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    # profiles.default = {
    #   name = "Default";
    #   settings = {
    #     "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    #     "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #     # "browser.tabs.drawInTitlebar" = true;
    #     "svg.context-properties.content.enabled" = true;
    #     "gnomeTheme.normalWidthTabs" = true;
    #     "gnomeTheme.tabsAsHeaderbar" = true;
    #   };
    #   userChrome = ''
    #     @import "firefox-gnome-theme/userChrome.css";
    #     @import "firefox-gnome-theme/theme/colors/dark.css"; 
    #   '';
    # };
  };
}

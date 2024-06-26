{ pkgs, ... }:
{
  programs.kitty = {
     enable = true;
     catppuccin.enable = true;
     font = {
       package = pkgs.fira-code;
       name = "Fira Code";
     };
     settings = {
       font_size = "16";

       background = "#000000";
       # foreground = "#ecefc1";

       # selection_background = "#0a385c";
       # selection_foreground = "#0a1e24";

       cursor = "#708183";

       # color0  = "#6e5246";
       # color8  = "#674c31";
       # color1  = "#e35a00";
       # color9  = "#ff8a39";
       # color2  = "#5cab96";
       # color10 = "#adcab8";
       # color3  = "#e3cd7b";
       # color11 = "#ffc777";
       # color4  = "#0e548b";
       # color12 = "#67a0cd";
       # color5  = "#e35a00";
       # color13 = "#ff8a39";
       # color6  = "#06afc7";
       # color14 = "#83a6b3";
       # color7  = "#f0f1ce";
       # color15 = "#fefff0";

       copy_on_select = true;

      };
  };
}

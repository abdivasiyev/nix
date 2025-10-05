{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    coc = {
      enable = true;
      settings = {
        "coc" = {
          "preferences" = {
            "formatOnSave" = true;
            "useQuickfixForLocations" = true;
          };
        };
        "editor" = {
          "codeActionsOnSave" = {
            "source.organizeImports" = true;
          };
        };
        "languageserver" = {
          "nix" = {
            "command" = "nixd";
            "filetypes" = ["nix"];
            "settings" = {
              "nixd" = {
                "formatting" = {
                  "command" = ["alejandra"];
                };
              };
            };
          };
        };
        "codeLens.enable" = true;
        "colors.enable" = true;
      };
    };
    plugins = with pkgs.vimPlugins; [
      {
        type = "lua";
        plugin = gruvbox-material-nvim;
        config = builtins.readFile ./lua/colorscheme.lua;
      }
    ];
    extraLuaConfig = builtins.concatStringsSep "\n" [
      (builtins.readFile ./lua/options.lua)
      (builtins.readFile ./lua/keymap.lua)
      (builtins.readFile ./lua/coc.lua)
    ];
  };
}

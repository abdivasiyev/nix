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
        coc = {
          preferences = {
            formatOnSave = true;
            useQuickfixForLocations = true;
          };
        };
        editor = {
          codeActionsOnSave = {
            "source.organizeImports" = true;
          };
        };
        languageserver = {
          gopls = {
            command = "gopls";
            filetypes = ["go"];
            rootPatterns = ["go.mod" "go.work"];
            settings = {
              gopls = {
                gofumpt = false;
                codelenses = {
                  gc_details = true;
                  generate = true;
                  regenerate_cgo = true;
                  run_govulncheck = true;
                  test = true;
                  tidy = true;
                  upgrade_dependency = true;
                  vendor = true;
                };
                hints = {
                  assignVariableTypes = true;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = true;
                  constantValues = true;
                  functionTypeParameters = true;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
                analyses = {
                  nilness = true;
                  unusedparams = true;
                  unusedwrite = true;
                  useany = true;
                  shadow = true;
                  unusedvariable = true;
                };
                usePlaceholders = true;
                completeUnimported = true;
                staticcheck = true;
                directoryFilters = [ "-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules" ];
                semanticTokens = true;
              };
            };
          };
          nix = {
            command = "nixd";
            filetypes = ["nix"];
            settings = {
              nixd = {
                formatting = {
                  command = ["alejandra"];
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
      (builtins.readFile ./lua/autocmd.lua)
      (builtins.readFile ./lua/coc.lua)
    ];
  };
}

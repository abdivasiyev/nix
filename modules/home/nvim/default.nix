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
          lua = {
            command = "lua-language-server";
            filetypes = ["lua"];
            settings = {
              Lua = {
                "codeLens.enable" = true;
                "hint.enable" = true;
                "hint.setType" = true;
                "completion.callSnippet" = "Replace";
                "diagnostics.disable" = ["lowercase-global"];
                "workspace" = {
                  "library" = [
                    "${pkgs.neovim-unwrapped}/share/nvim/runtime"
                    "$HOME/.config/nvim"
                    "$HOME/.local/share/nvim/site"
                  ];
                };
              };
            };
          };
          haskell = {
            command = "haskell-language-server-wrapper";
            args = ["--lsp"];
            rootPatterns = ["*.cabal" "stack.yaml" "cabal.project" "package.yaml" "hie.yaml"];
            filetypes = ["haskell" "lhaskell"];
            settings = {
              haskell = {
                formattingProvider = "fourmolu";
              };
            };
          };
          gopls = {
            command = "gopls";
            filetypes = ["go"];
            rootPatterns = ["go.mod" "go.work"];
            settings = {
              gopls = {
                gofumpt = false;
                codelenses = {
                  vulncheck = true;
                  test = true;
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
                  shadow = true;
                };
                usePlaceholders = true;
                completeUnimported = true;
                staticcheck = true;
                directoryFilters = ["-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules"];
                semanticTokens = true;
                diagnosticsTrigger = "Save";
                symbolMatcher = "Fuzzy";
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
      nvim-web-devicons
      undotree
      vim-visual-multi
      vim-fugitive
      vim-wakatime
      {
        type = "lua";
        plugin = lualine-nvim;
        config = builtins.readFile ./lua/lualine.lua;
      }
      {
        type = "lua";
        plugin = gitsigns-nvim;
        config = builtins.readFile ./lua/gitsigns.lua;
      }
      {
        type = "lua";
        plugin = nvim-ufo;
        config = builtins.readFile ./lua/nvim-ufo.lua;
      }
      {
        type = "lua";
        plugin = telescope-nvim;
        config = builtins.readFile ./lua/telescope.lua;
      }
      {
        type = "lua";
        plugin = nvim-tree-lua;
        config = builtins.readFile ./lua/nvim-tree.lua;
      }
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

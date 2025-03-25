{pkgs, ...}:
{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;
		plugins = with pkgs.vimPlugins; [
			nvim-web-devicons
			{
				plugin = telescope-nvim;
				type = "lua";
				config = builtins.readFile(../nvim/telescope.lua);
			}
			{
				plugin = nvim-tree-lua;
				type = "lua";
				config = builtins.readFile(../nvim/nvim-tree.lua);
			}
		];
		extraLuaConfig = builtins.readFile(../nvim/base-config.lua);
	};
}

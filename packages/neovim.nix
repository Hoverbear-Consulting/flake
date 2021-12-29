{ neovim, vimPlugins, tree-sitter }:

neovim.override {
  vimAlias = true;
  viAlias = true;
  configure = {
    customRC = ''
      luafile ${../config/nvim/init.lua}
    '';
    packages.myVimPackage = with vimPlugins; {
      start = [
        LanguageClient-neovim
        awesome-vim-colorschemes
        rust-vim
        vim-nix
        telescope-nvim
        plenary-nvim
        popup-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        gitsigns-nvim
        (nvim-treesitter.withPlugins (plugins: tree-sitter.allGrammars))
      ];
    };
  };
}

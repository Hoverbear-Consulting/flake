{ neovim, vimPlugins }:

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
        fzf-vim
      ];
    };
  };
}

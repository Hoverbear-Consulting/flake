{ neovim, vimPlugins }:

neovim.override {
  vimAlias = true;
  viAlias = true;
  configure = {
    customRC = builtins.readFile ../config/nvim/nvimrc;
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

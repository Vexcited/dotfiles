vim.cmd [[ packadd packer.nvim ]]

return require('packer').startup(function()
  use "wbthomason/packer.nvim"
  use "neovim/nvim-lspconfig"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-path"
  use "ray-x/lsp_signature.nvim"

  use {
    "goolord/alpha-nvim",
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  }

  use {
    "catppuccin/nvim",
    as = "catppuccin"
  }
 
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      {"nvim-lua/plenary.nvim"}
    }
  }

  use 'vim-airline/vim-airline'

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons'
    }
  }

  use 'github/copilot.vim'
  use 'wakatime/vim-wakatime'
  use 'andweeb/presence.nvim'
end)

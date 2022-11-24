local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
        PACKER_BOOTSTRAP = fn.system({
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path,
        })
        print("Installing packer close and reopen Neovim...")
        vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
        return
end

-- Have packer use a popup window
packer.init({
        display = {
                open_fn = function()
                        return require("packer.util").float({ border = "rounded" })
                end,
        },
})

-- Install your plugins here
return packer.startup(function(use)
        use "wbthomason/packer.nvim";
        use "nvim-lua/plenary.nvim";
        use "kyazdani42/nvim-web-devicons";
        use 'nvim-lua/popup.nvim'
        use 'lewis6991/impatient.nvim'
        use "folke/which-key.nvim"

        --  Fundamentals
        use {
                'nvim-tree/nvim-tree.lua',
                requires = {
                        'nvim-tree/nvim-web-devicons', -- optional, for file icons
                },
                tag = 'nightly' -- optional, updated every week. (see issue #1193)
        }
        use {
                'nvim-telescope/telescope.nvim', tag = '0.1.x',
                requires = { { 'nvim-lua/plenary.nvim' } }
        }
        use 'nvim-telescope/telescope-media-files.nvim'
        use {
                'nvim-lualine/lualine.nvim',
                requires = { 'kyazdani42/nvim-web-devicons', opt = true }
        }
        use {
                "windwp/nvim-autopairs",
                config = function() require("nvim-autopairs").setup {
                                fast_wrap = {},
                        }
                end
        }
        use {
                'numToStr/Comment.nvim',
                config = function()
                        require('Comment').setup()
                end
        }
        use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
        use "moll/vim-bbye"
        use { "akinsho/toggleterm.nvim", tag = '*', config = function()
                require("toggleterm").setup()
        end }
        use {
                "ahmedkhalf/project.nvim",
                config = function()
                        require("project_nvim").setup {
                        }
                        require('telescope').load_extension('projects')
                end
        }
        use {
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                        require "indent_blankline".setup()
                end
        }
        use 'goolord/alpha-nvim'

        -- Colorschemes
        use "folke/tokyonight.nvim";
        use "lunarvim/darkplus.nvim";
        use "ayu-theme/ayu-vim";
        use "tiagovla/tokyodark.nvim";
        use { 'shaunsingh/oxocarbon.nvim', run = './install.sh' }

        -- Completions
        use "hrsh7th/nvim-cmp";
        use "hrsh7th/cmp-buffer";
        use "hrsh7th/cmp-path";
        use "hrsh7th/cmp-nvim-lsp";
        use "hrsh7th/cmp-nvim-lua";
        use "hrsh7th/cmp-cmdline"
        use "onsails/lspkind.nvim";

        -- Snippets
        use "L3MON4D3/LuaSnip";
        use "saadparwaiz1/cmp_luasnip";
        use "rafamadriz/friendly-snippets";

        -- LSP
        use { "williamboman/mason.nvim",
                'neovim/nvim-lspconfig',
                "williamboman/mason-lspconfig.nvim" };

        -- Dap
        use 'mfussenegger/nvim-dap'

        -- Tree-sitter
        use {
                'nvim-treesitter/nvim-treesitter',
                run = function()
                        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                        ts_update()
                end,
        }
        use 'JoosepAlviste/nvim-ts-context-commentstring'

        -- Git Sign
        use {
                'lewis6991/gitsigns.nvim',
                -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
        }

        -- Rust
        use 'simrat39/rust-tools.nvim'

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if PACKER_BOOTSTRAP then
                require("packer").sync()
        end
end)

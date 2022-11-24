require "nvim-treesitter.configs".setup({
        ensure_installed = "all", -- one of "all" or a list of languages
        highlight = {
                enable = true, -- false will disable the whole extension
        },
        autopairs = {
                enable = true,
        },
        indent = { enable = true },
        context_commentstring = {
                enable = true
        },

})

local cmp = require "cmp"
local luasnip = require "luasnip"
local lspkind = require "lspkind"
local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require "luasnip/loaders/from_vscode".lazy_load()

cmp.setup({
        snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
        },
        window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                                cmp.select_next_item()
                        elseif luasnip.expandable() then
                                luasnip.expand_or_jump()
                        elseif has_words_before() then
                                cmp.complete()
                        else
                                fallback()
                        end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                                cmp.select_prev_()
                        elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                        else
                                fallback()
                        end
                end, { 'i', 's' })
        }),
        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
        }, {
                { name = 'buffer' },
        }),
        formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                        if vim.tbl_contains({ 'path' }, entry.source.name) then
                                local icon, hl_group = require 'nvim-web-devicons'.get_icon(entry:get_completion_item()
                                        .label)
                                if icon then
                                        vim_item.kind = icon
                                        vim_item.kind_hl_group = hl_group
                                        vim.item.menu = ({
                                                buffer = "[BUF]",
                                                nvim_lsp = "[LSP]",
                                                luasnip = "[LUA]",
                                                nvim_lua = "[VIM]",
                                        })[entry.source.name]
                                        return vim_item
                                end
                        end
                        return lspkind.cmp_format({ mode = "symbol_text", with_text = false, menu = {
                                buffer = "[BUF]",
                                nvim_lsp = "[LSP]",
                                luasnip = "[LUA]",
                                nvim_lua = "[VIM]",
                        } })(entry, vim_item)
                end
        },
        enabled = function()
                -- disable completion in comments
                local context = require 'cmp.config.context'
                -- keep command mode completion enabled when cursor is in a comment
                if vim.api.nvim_get_mode().mode == 'c' then
                        return true
                else
                        return not context.in_treesitter_capture("comment")
                            and not context.in_syntax_group("Comment")
                end
        end
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
                { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
                { name = 'buffer' },
        })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
                { name = 'buffer' }
        }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
                { name = 'path' }
        }, {
                { name = 'cmdline' }
        })
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
)

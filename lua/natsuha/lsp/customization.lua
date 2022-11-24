local M = {}
function M.setup_key_mappings(bufopts)
        local opts = { noremap = true, silent = true }
        -- vim.keymap.set('n', '<space>ee', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

function M.show_diagnostic_on_hover(bufnr)
        vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                        local opts = {
                                focusable = false,
                                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                                border = 'rounded',
                                source = 'always',
                                prefix = ' ',
                                scope = 'cursor',
                        }
                        vim.diagnostic.open_float(nil, opts)
                end
        })
end

function M.use_float_borders()
        vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
        vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
        local border = {
                { "┏", "FloatBorder" },
                { "━", "FloatBorder" },
                { "┓", "FloatBorder" },
                { "┃", "FloatBorder" },
                { "┛", "FloatBorder" },
                { "━", "FloatBorder" },
                { "┗", "FloatBorder" },
                { "┃", "FloatBorder" },
        }
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or border
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end
end

function M.use_diagnostic_config()
        -- Signs
        local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
        }
        for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
        -- Config
        local config = {
                virtual_text = {
                        source = "always",
                        -- prefix = "x"
                },
                signs = {
                        active = signs, -- show signs
                },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                        focusable = true,
                        style = "minimal",
                        border = "rounded",
                        source = "always",
                        header = "",
                        prefix = "",
                },
        }
        vim.diagnostic.config(config)
end

function M.highlight_number_line()
        -- Highlight line number instead of having icons in sign column
        vim.cmd [[
  highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
  highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
  highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
  highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold

  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]]
end

function M.highlight_symbol_on_hover(client, bufnr)

        if client.server_capabilities.documentHighlightProvide then
                vim.cmd [[
    hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  ]]
                vim.api.nvim_create_augroup('lsp_document_highlight', {
                        clear = false
                })
                vim.api.nvim_clear_autocmds({
                        buffer = bufnr,
                        group = 'lsp_document_highlight',
                })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        group = 'lsp_document_highlight',
                        buffer = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        group = 'lsp_document_highlight',
                        buffer = bufnr,
                        callback = vim.lsp.buf.clear_references,
                })
        end
end

return M

local settings = require "natsuha.lsp.settings"
local capabilities = require "cmp_nvim_lsp".default_capabilities()
local customization = require "natsuha.lsp.customization"
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        customization.setup_key_mappings(bufopts)
        customization.show_diagnostic_on_hover(bufnr)
        customization.highlight_symbol_on_hover(client, bufnr)
end

local lsp_flags = {
        -- This is the default in Nvim 0.7+
        debounce_text_changes = 150,
}

local handler = {
        capabilities = capabilities,
        on_attach = on_attach,
        lsp_flags = lsp_flags,
        settings = settings
}

return handler

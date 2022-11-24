local mason_lspconfig = require "mason-lspconfig"
local handler = require "natsuha.lsp.handler"
local lspconfig = require "lspconfig"

local function get_default_handler(server_name)
        return {
                capabilities = handler.capabilities,
                on_attach = handler.on_attach,
                lsp_flags = handler.lsp_flags,
                settings = handler.settings[server_name]
        }
end

mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
                lspconfig[server_name].setup(get_default_handler(server_name))
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        ["rust_analyzer"] = function()
                require("rust-tools").setup {
                        server = get_default_handler 'rust_analyzer'
                }
        end
}

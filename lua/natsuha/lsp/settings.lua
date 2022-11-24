local settings = {
        ['sumneko_lua'] = {
                Lua = {
                        diagnostics = {
                                globals = { "vim" },
                        },
                        workspace = {
                                library = {
                                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                        [vim.fn.stdpath("config") .. "/lua"] = true,
                                },
                        },
                },
        },
        ['rust_analyzer'] = {
                ['rust-analyzer'] = {
                        checkOnSave = {
                                command = "clippy"
                        }

                }
        }
}

return settings

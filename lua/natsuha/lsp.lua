require "natsuha.lsp.mason"
require("natsuha.lsp.lspconfig")
local customizations = require "natsuha.lsp.customization"
customizations.use_diagnostic_config()
customizations.use_float_borders()
customizations.highlight_number_line()

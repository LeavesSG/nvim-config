local M = {}

function M.set_color_scheme(colorscheme)
        vim.cmd("colorscheme " .. colorscheme)
end

return M

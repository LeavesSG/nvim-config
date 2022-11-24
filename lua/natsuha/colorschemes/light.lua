local set             = require("utils").set_color_scheme
local light_themes    = {
        -- "ayu",
        "tokyonight-day",
        -- "oxocarbon",
}
local installation    = {
        ['ayu'] = function()
                vim.cmd "let ayucolor='light'"
                set "ayu"
        end,
}
local len             = #light_themes
local random_index    = (tonumber(os.date("%S")) % len) + 1
vim.o.background      = "light"
local use_colorscheme = light_themes[random_index]
local ok              = pcall(installation[use_colorscheme])
if not ok then
        set(use_colorscheme)
end

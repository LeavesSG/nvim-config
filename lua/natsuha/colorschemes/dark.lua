local set             = require("utils").set_color_scheme
local dark_themes    = {
        -- "ayu",
        "tokyonight-storm",
        "tokyonight-moon",
        "tokyonight-night",
        -- "oxocarbon",
}
local installation    = {
        ['ayu'] = function()
                vim.cmd "let ayucolor='dark'"
                set "ayu"
        end,
}
local len             = #dark_themes
local random_index    = (tonumber(os.date("%S")) % len) + 1
vim.o.background      = "dark"
local use_colorscheme = dark_themes[random_index]
local ok              = pcall(installation[use_colorscheme])
if not ok then
        set(use_colorscheme)
end

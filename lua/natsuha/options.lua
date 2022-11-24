local opt = {
        backup = false,
        clipboard = "unnamedplus",
        -- cmdheight = 2,
        completeopt = { "menuone", "noselect" },
        conceallevel = 0,
        hlsearch = true,
        ignorecase = true,
        mouse = "a",
        pumheight = 10,
        showmode = false,
        showtabline = 2,
        smartcase = true, -- smart case
        smartindent = true,
        swapfile = false, -- creates a swapfile
        termguicolors = true,
        timeoutlen = 300,
        undofile = true,
        expandtab = true,
        cursorline = true,
        number = true,
        numberwidth = 4,
        guifont = "CaskaydiaCove Nerd Font SemiLight, ",
        updatetime = 250,
}
for k, v in pairs(opt) do
        vim.opt[k] = v
end
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

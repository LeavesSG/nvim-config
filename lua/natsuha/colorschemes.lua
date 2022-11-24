local function is_light()
        local time = tonumber(os.date("%H"))
        print(time)
        if time > 6 and time < 18 then
                return 'light'
        end
        return 'dark'
end
local variant = is_light()
require("natsuha.colorschemes." .. variant)

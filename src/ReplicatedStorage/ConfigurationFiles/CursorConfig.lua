--!strict
-- [[ModuleScript] CursorConfig]
-- Maps cursor names to uploaded Decal asset IDs
-- Created by cursor_converter.py
local CursorConfig = {
    cursors = {
        -- Zundamon themed cursors
        -- Replace 'rbxassetid://0' with real uploaded Decal IDs
        ['alternate'] = 'rbxassetid://0',
        ['busy'] = 'rbxassetid://0',
        ['cross'] = 'rbxassetid://0',
        ['handwriting'] = 'rbxassetid://0',
        ['help'] = 'rbxassetid://0',
        ['link'] = 'rbxassetid://0',
        ['location'] = 'rbxassetid://0',
        ['move'] = 'rbxassetid://0',
        ['normal'] = 'rbxassetid://0',
        ['person'] = 'rbxassetid://0',
        ['resize_nesw'] = 'rbxassetid://0',
        ['resize_ns'] = 'rbxassetid://0',
        ['resize_nwse'] = 'rbxassetid://0',
        ['resize_we'] = 'rbxassetid://0',
        ['text'] = 'rbxassetid://0',
        ['unavailable'] = 'rbxassetid://0',
        ['working'] = 'rbxassetid://0',

        -- Standard UI cursors
        default = '',
        pointing = '',
        waiting = '',
        text = '',
    },
}
function CursorConfig.getCursor(name)
    return CursorConfig.cursors[name] or ''
end

return CursorConfig
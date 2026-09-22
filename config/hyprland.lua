-- lua script keybinds
-- windows + arrow keys to move windows, maximize and minimize
-- windows + space to show minimized windows, click one to bring it forward to the current workspace
-- windows + click for float mode
-- windows + right click to resize in float mode
-- alt + tab to change focus
-- alt + arrow keys or space for media controls
-- alt + 4 to close focused window (same as f4 on my slim keyboard)
-- todo add way to select a window from the hidden workspace without using the mouse


-- settings for main monitor (needed to adjust scale)
hl.monitor({
    output   = "",
    scale    = "1",
})

-- startup commands
hl.on("hyprland.start", function () 
  hl.exec_cmd("caelestia shell -d")
end)

-- the look of everything
hl.config({
    general = {
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
        },
        resize_on_border = true,
    },
    decoration = {
        rounding       = 10,
        active_opacity   = .95,
        inactive_opacity = .9,
        blur = {
            size      = 10,
        },
    },
})

-- move window up or maximize with super + arrow keys
hl.bind("SUPER + up", function()
    local active = hl.get_active_window()
    if not active or active.fullscreen ~= 0 or active.workspace.name == "special:hidden" then
        return
    end
    if active.floating then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        return
    end
    local windows = hl.get_windows({ workspace = active.workspace })
    local can_move_up = false
    for _, window in ipairs(windows) do
        if window.address ~= active.address and not window.floating and window.at.y < active.at.y then
            can_move_up = true
            break
        end
    end
    if can_move_up then
        hl.dispatch(hl.dsp.window.move({ direction = "up" }))
    else
        hl.dispatch(hl.dsp.window.fullscreen({mode = "fullscreen"}))
    end
end)

-- move window down or minimize with super + arrow keys
hl.bind("SUPER + down", function()
    local active = hl.get_active_window()
    if not active or active.workspace.name == "special:hidden" then
        return
    end
    if active.fullscreen ~= 0 then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen" }))
        return
    end
    if active.floating then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end
    local windows = hl.get_windows({ workspace = active.workspace })
    local can_move_down = false
    for _, window in ipairs(windows) do
        if window.address ~= active.address and not window.floating and window.at.y > active.at.y then
            can_move_down = true
            break
        end
    end
    if can_move_down then
        hl.dispatch(hl.dsp.window.move({ direction = "down" }))
    else
        local mouse = hl.get_cursor_pos()
        local workspace = active.workspace.name
        hl.dispatch(hl.dsp.window.move({ workspace = "special:hidden" }))
        hl.dispatch(hl.dsp.workspace.toggle_special("hidden"))
        workspace_windows = hl.get_windows({ workspace = workspace })
        local visible_windows = {}
        for _, window in pairs(hl.get_windows()) do
            if window.workspace.visible then
                table.insert(visible_windows, window)
            end
        end
        table.sort(visible_windows, function(a, b)
            local function distance_to_window(window)
                local left   = window.at.x
                local right  = window.at.x + window.size.x
                local top    = window.at.y
                local bottom = window.at.y + window.size.y
                local x = math.max(left, math.min(mouse.x, right))
                local y = math.max(top, math.min(mouse.y, bottom))
                return (x - mouse.x)^2 + (y - mouse.y)^2
            end
            return distance_to_window(a) < distance_to_window(b)
        end)
        if #visible_windows > 0 then
            hl.dispatch(hl.dsp.focus({ window = visible_windows[1] }))
        end
    end
end)

-- functions to unminimize a window from the hidden workspace
local current_workspace = nil
local function select_hidden()
    local active = hl.get_active_window()
    if active and active.workspace.name == "special:hidden" and active.workspace.visible then
        hl.dispatch(hl.dsp.window.move({ workspace = current_workspace }))
        hl.unbind("mouse:272")
        hl.bind("mouse:272", select_hidden, { non_consuming = true })
    end
end
hl.bind("SUPER + space", function()
    local active = hl.get_active_window()
    local pos = hl.get_cursor_pos()
    local monitor = hl.get_monitor_at(pos)
    if not monitor then
        return
    end
    current_workspace = monitor.active_workspace
    hl.dispatch(hl.dsp.workspace.toggle_special("hidden"))
    if active.workspace.name == "special:hidden" then
        hl.unbind("mouse:272")
        hl.bind("mouse:272", select_hidden, { non_consuming = true })
    else
        hl.unbind("mouse:272")
        hl.bind("mouse:272", select_hidden, { non_consuming = false }) 
    end
end)
hl.bind("mouse:272", select_hidden, { non_consuming = true })

-- move window left with super + arrow keys
hl.bind("SUPER + left", function()
    local active = hl.get_active_window()
    if not active or active.workspace.name == "special:hidden" then
        return
    end
    if active.fullscreen ~= 0 then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    end
    if active.floating then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end
    hl.dispatch(hl.dsp.window.move({ direction = "left" }))
end)

-- move window right with super + arrow keys
hl.bind("SUPER + right", function()
    local active = hl.get_active_window()
    if not active or active.workspace.name == "special:hidden" then
        return
    end
    if active.fullscreen ~= 0 then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    end
    if active.floating then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end
    hl.dispatch(hl.dsp.window.move({ direction = "right" }))
end)

-- change focus with alt + tab
hl.bind("ALT + tab", function()
    local active = hl.get_active_window()
    if not active or active.workspace.name == "special:hidden" and active.workspace.visible then
        return
    end
    local windows = {}
    for _, window in pairs(hl.get_windows()) do
        if window.workspace.visible then
            table.insert(windows, window)
        end
    end
    table.sort(windows, function(a, b)
        if a.at.x == b.at.x then
            return a.at.y < b.at.y
        end
        return a.at.x < b.at.x
    end)
    local index = 1
    for i, window in ipairs(windows) do
        if window.address == active.address then
            index = (i % #windows) + 1
            break
        end
    end
    if #windows > 0 then
        hl.dispatch(hl.dsp.focus({ window = windows[index] }))
    end
end)

-- move/resieze windows with super + mouse in float mode
hl.bind("SUPER + mouse:272", function()
    local active = hl.get_active_window()
    if not active or active.workspace.name == "special:hidden" then
        return
    end
    if not active.floating then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end
    hl.dispatch(hl.dsp.window.drag())
end)
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

-- media controls
hl.bind("ALT + right",  hl.dsp.exec_cmd("playerctl next"))
hl.bind("ALT + space", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("ALT + left",  hl.dsp.exec_cmd("playerctl previous"))

-- other bindings
hl.bind("ALT + 4", hl.dsp.window.close())
hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), { release = true })
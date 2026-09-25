-- lua script keybinds
-- windows + arrow keys to move windows, maximize and minimize
-- windows + space to show minimized windows, click or hit enter on one to bring it forward to the current workspace
-- windows + click for float mode
-- windows + right click to resize in float mode
-- alt + tab to change focus
-- alt + arrow keys or space for media controls
-- alt + 4 to close focused window (same as f4 on my slim keyboard)
-- windows for start menu
-- windows + s for settings
-- windows + escape for power menu
-- windows + shift + v for screen record
-- windows + v for clipboard history
-- windows + e for emoji keyboard
-- windows + shift + s for screenshot
-- windows + R for kitty
-- ctrl + shift + esc for dashboard (similar to task manager)


-- settings for monitors
hl.monitor({
    output = "HDMI-A-4",
    mirror = "HDMI-A-1",
    scale = 1,
})
hl.monitor({
    output = "HDMI-A-1",
    position = "0x0",
})
hl.monitor({
    output = "DP-2",
    position = "1920x0",
    scale = 1,
})

-- startup commands
hl.on("hyprland.start", function () 
   hl.exec_cmd("caelestia shell -d")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("cliphist wipe")
    hl.exec_cmd("udiskie")
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
        hl.unbind("RETURN")
        hl.bind("mouse:272", select_hidden, { non_consuming = true })
        hl.bind("RETURN", select_hidden, { non_consuming = true })
    end
end
hl.bind("SUPER + space", function()
    local active = hl.get_active_window()
    local pos = hl.get_cursor_pos()
    local monitor = hl.get_monitor_at(pos)
    if not monitor or #hl.get_workspace_windows("special:hidden") == 0 then
        return
    end
    current_workspace = monitor.active_workspace
    hl.dispatch(hl.dsp.workspace.toggle_special("hidden"))
    if active.workspace.name == "special:hidden" then
        hl.unbind("mouse:272")
        hl.unbind("RETURN")
        hl.bind("mouse:272", select_hidden, { non_consuming = true })
        hl.bind("RETURN", select_hidden, { non_consuming = true })
    else
        hl.unbind("mouse:272")
        hl.unbind("RETURN")
        hl.bind("mouse:272", select_hidden, { non_consuming = false }) 
        hl.bind("RETURN", select_hidden, { non_consuming = false })
    end
end)
hl.bind("mouse:272", select_hidden, { non_consuming = true })
hl.bind("RETURN", select_hidden, { non_consuming = true })

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
    local windows = {}
    local hidden = {}
    for _, window in pairs(hl.get_windows()) do
        if window.workspace.visible then
            table.insert(windows, window)
        end
        if window.workspace.name == "special:hidden" and window.workspace.visible then
            table.insert(hidden, window)
        end
    end
    if #hidden > 0 then
        windows = hidden
    end
    table.sort(windows, function(a, b)
        if a.at.x == b.at.x then
            return a.at.y < b.at.y
        end
        return a.at.x < b.at.x
    end)
    local index = 1
    if active then
        for i, window in ipairs(windows) do
            if window.address == active.address then
                index = (i % #windows) + 1
                break
            end
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

-- close windows and handle when all minimized windows are closed
hl.bind("ALT + 4", function()
    local active = hl.get_active_window()
    local windows = hl.get_workspace_windows("special:hidden")
    if not active then
        return
    end
    if active.workspace.name == "special:hidden" and #windows == 1 then
        hl.unbind("mouse:272")
        hl.unbind("RETURN")
        hl.bind("mouse:272", select_hidden, { non_consuming = true })
        hl.bind("RETURN", select_hidden, { non_consuming = true })
    end
    hl.dispatch(hl.dsp.window.close())
end)

-- media controls
hl.bind("ALT + right",  hl.dsp.global("caelestia:mediaNext"))
hl.bind("ALT + space", hl.dsp.global("caelestia:mediaToggle"))
hl.bind("ALT + left",  hl.dsp.global("caelestia:mediaPrev"))
hl.bind("ALT + up", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0"))
hl.bind("ALT + down", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1.0"))

-- other bindings that are similar to windows bindings
hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), { release = true })
hl.bind("SUPER + S", hl.dsp.global("caelestia:nexus"))
hl.bind("SUPER + ESCAPE", hl.dsp.global("caelestia:session"))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.global("caelestia:dashboard"))
hl.bind("SUPER + SHIFT + V", hl.dsp.global("caelestia:utilities"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("caelestia clipboard && ydotool key 29:1 42:1 47:1 47:0 42:0 29:0"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("caelestia emoji -p && (ydotool key 29:1 42:1 47:1 47:0 42:0 29:0; cliphist list | head -n 1 | cliphist delete)"))
hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("kitty"))

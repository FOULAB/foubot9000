--    __             _           _    ___  _  __       __        ____  __
--   / _| ___  _   _| |__   ___ | |_ / _ \| |/ /  _ _  \ \      / /  \/  |
--  | |_ / _ \| | | | '_ \ / _ \| __| (_) | ' /  (_|_)  \ \ /\ / /| |\/| |
--  |  _| (_) | |_| | |_) | (_) | |_ \__, | . \   _ _    \ V  V / | |  | |
--  |_|  \___/ \__,_|_.__/ \___/ \__|  /_/|_|\_\ (_|_)    \_/\_/  |_|  |_|

-- Graphical entrypoint for Foubot


-- /!\ Warning! Ugly boilerplate bellow until the next header!

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
-- Theming library we partially use
-- Might also be load-bearing in loading Xresources :shrug:
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Runtime error handling
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Setting avaialble layouts to floating only.
-- In practice we're disabling tiling management.
awful.layout.layouts = {
    awful.layout.suit.floating,
}



--   _                _
--  | |    ___   ___ | | _____
--  | |   / _ \ / _ \| |/ / __|
--  | |__| (_) | (_) |   <\__ \
--  |_____\___/ \___/|_|\_\___/

-- Screen dimentions in pixels.
-- Used as reference later in the code.

screen_height = 1024
screen_width = 1280
bar_height = 20

--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- theme = gears.filesystem.get_configuration_dir() .. "theme.lua"

-- Loading defaults
-- theme = gears.filesystem.get_themes_dir() .. "default/theme.lua"
theme = gears.filesystem.get_configuration_dir() .. "theme.lua"
beautiful.init(theme)

gears.debug.print_warning(beautiful.awesome_icon)

-- Colours
gears.wallpaper.set("#000000")

awful.screen.connect_for_each_screen(function(s)
    awful.tag.add("1", {
        layout             = awful.layout.suit.floating,
        screen             = s,
        selected           = true,
    })
end)


--  _   _ _   _ _
-- | | | | |_(_) |___
-- | | | | __| | / __|
-- | |_| | |_| | \__ \
--  \___/ \__|_|_|___/

-- Small menu, mostly for debugging.
-- Conatins entries for in-place restart, quitting, and the hotkey cheat sheet.
-- Invoked with Mod+W, or a right-click on the background.
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon }}})
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })


function placement_with_offset (placement, offset, c, ...)
    return placement(c, {offset=offset, ...})
end

-- Quickly calculate the real window size, removing borders
function winsize (size)
    return size - (beautiful.border_width * 2)
end


--  _  __          _     _           _
-- | |/ /___ _   _| |__ (_)_ __   __| |___
-- | ' // _ \ | | | '_ \| | '_ \ / _` / __|
-- | . \  __/ |_| | |_) | | | | | (_| \__ \
-- |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
--           |___/

-- Base modifier key. Set to Mod5, usually mapped to AltGr/RightALt.
-- Valid values are Mod1~Mod5, Shift, Lock, Control, Any.
-- To see the mappings in a session, use `xmodmap -pm`. You may been to prefix
-- the command with the X DISPLAY variable.
modkey = "Mod5"

globalkeys = gears.table.join(
    -- AwesomeWM control
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Window control
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    )
)

-- Window control, Part II
clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",
        function (c)
            c:kill()
        end,
        {description = "close", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Set keys
root.keys(globalkeys)

-- Mouse binds
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)


--   ____        _
--  |  _ \ _   _| | ___  ___
--  | |_) | | | | |/ _ \/ __|
--  |  _ <| |_| | |  __/\__ \
--  |_| \_\\__,_|_|\___||___/

-- Quick calculation for resizing rules
-- 19 = bar height
effective_height = screen_height - bar_height
effective_width = screen_width

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_offscreen + awful.placement.no_overlap
        }
    },

    {
        rule = {fullscreen = true},
        property = {above = true}
    },

    {
        rule = {
            class = "Polybar",
        },
        properties = {
            focus = false,
            focusable = false,
            floating = true,
            titlebars_enabled = false,
            border_width = 0,
            placement = awful.placement.bottom
        }
    },

    -- Force Awesome to ignore the window size increments set by rxvt
    {
        rule = {
            class = "URxvt"
        },
        properties = {
            size_hints_honor = false
        }
    },

    {
        rule = {
            class = "URxvt",
            name = "foubot9000:météo"
        },
        properties = {
            placement = function(...) return awful.placement.top_left(...) end,
            width = winsize(effective_width // 2),
            height = winsize(effective_height // 2)
        }
    },

    {
        rule = {
            class = "URxvt",
            name = "foubot9000:placeholder"
        },
        properties = {
            placement = function(...) return awful.placement.top_right(...) end,
            width = winsize(effective_width // 2),
            height = winsize(effective_height // 2)
        }
    },

    {
        rule = {
            class = "URxvt",
            name = "foubot9000:irc"
        },
        properties = {
            placement = function(...) return placement_with_offset(awful.placement.bottom, {y=-bar_height}, ...) end,
            width = winsize(effective_width),
            height = winsize(effective_height // 2)
        }
    }
}


--   ____  _                   _
--  / ___|(_) __ _ _ __   __ _| |___
--  \___ \| |/ _` | '_ \ / _` | / __|
--   ___) | | (_| | | | | (_| | \__ \
--  |____/|_|\__, |_| |_|\__,_|_|___/
--           |___/

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


--  ____  _             _
-- / ___|| |_ __ _ _ __| |_ _   _ _ __
-- \___ \| __/ _` | '__| __| | | | '_ \
--  ___) | || (_| | |  | |_| |_| | |_) |
-- |____/ \__\__,_|_|   \__|\__,_| .__/
--                               |_|

-- Disable *automatic* energy saving and blanking for the display
awful.spawn({"xset", "s", "off", "-dpms"})

-- Let The Show Begin!
awful.spawn({"chpst", "-L", "fb9000.lock", "--", "foubot/bin/burrito.sh"})

-- Mouse the mouse cursor out of view
mouse.coords({
    x = screen_width,
    y = screen_height
})

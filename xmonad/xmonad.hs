import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Themes
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Renamed
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.ShowWName

myLayout = toggleLayouts (noBorders Full) $ gaps [(U,14), (D,14), (L,14), (R,14)] $ tiled ||| myTabbed
  where
    tiled    
      = renamed [Replace "Tiles"]
      $ spacingWithEdge 10
      $ Tall nmaster delta ratio
    myTabbed
      = renamed [Replace "Tabs"]
      $ noBorders $ tabbedAlways shrinkText myTabConf
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitle = const ""
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    }
  where
    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

myFocusedBorderColor :: String
myFocusedBorderColor = "#61afef"

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "setxkbmap latam"
  spawnOnce "pipewire"
  spawnOnce "pipewire-pulse"
  spawnOnce "nitrogen --restore"
  spawnOnce "trayer --transparent true --width 5  --alpha 0 --SetPartialStrut true --height 24 --tint 0x1E222A --edge top --align right"
  spawnOnce "devmon"
  spawnOnce "picom --experimental-backends --backend glx --xrender-sync-fence"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "dunst"
  spawnOnce "mpd ~/.config/mpd/mpd.conf"

main :: IO ()
main = xmonad
  . ewmhFullscreen
  . ewmh
  . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
  $ myConfig

myConfig = def
    { modMask = mod4Mask
    , layoutHook = showWName' myShowWNameTheme myLayout
    , startupHook = myStartupHook
    , logHook = setWMName "LG3D"
    , focusedBorderColor = myFocusedBorderColor
    , borderWidth = 0
    , workspaces = ["1", "2", "3", "4", "5"]
    }
  `additionalKeysP`
    [ ("M-S-<Return>", spawn "kitty"          )
    , ("M-S-=", unGrab *> spawn "scrot -s"        )
    , ("M-d"  , spawn "rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/launchers/misc/appdrawer_alt.rasi"            )
    , ("M-f"  , sequence_ [sendMessage (Toggle "Full"), sendMessage ToggleStruts]       )
    , ("M-s"  , spawn "next-sink"       )
    , ("<Print>", spawn "scrot")
    ]

myTabConf = def
    { fontName            = "xft:JetBrainsMono Nerd Font:size=10:bold"
    , activeColor         = "#363B46"
    , activeBorderColor   = "#40bf40"
    , activeTextColor     = "#ffffff"
    , inactiveColor       = "#1E222A"
    , inactiveBorderColor = "#333333"
    , inactiveTextColor   = "#dddddd"
    , urgentColor         = "#900000"
    , urgentBorderColor   = "#2f343a"
    , urgentTextColor     = "#ffffff"
    , activeBorderWidth   = 0
    , inactiveBorderWidth = 0
    , urgentBorderWidth   = 0
    }

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:JetBrainsMono Nerd Font:size=35:bold"
    , swn_bgcolor           = "#1E222A"
    , swn_color             = "#ffffff"
    , swn_fade              = 0.5
    }


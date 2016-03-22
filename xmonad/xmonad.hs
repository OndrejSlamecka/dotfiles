import XMonad
import XMonad.Layout.ResizableTile
import qualified Data.Map as M (fromList)
import Data.List (intercalate)

import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe, hPutStrLn)

import Graphics.X11.ExtraTypes.XF86 -- multimedia keys

-- volume settings
data Vol = Inc | Dec
instance Show Vol where
    show Inc = "+"
    show Dec = "-"

volume x = intercalate " && " [m_on, h_on, vol]
    where m_on = "amixer set Master on"
          h_on = "amixer set Headphone on"
          vol  = "amixer set Master 2" ++ show x

toggleSound = "pactl set-sink-mute 0 toggle"

-- own keys
myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList
    [
    -- resizableTile, use mod-a and mod-z
      ((modm,                 xK_a), sendMessage MirrorShrink)
    , ((modm,                 xK_z), sendMessage MirrorExpand)

    -- mod-b to toggle bars
    , ((modm,                 xK_b), sendMessage ToggleStruts)

    -- audio
    , ((0, xF86XK_AudioLowerVolume), spawn $ volume Dec)
    , ((0, xF86XK_AudioRaiseVolume), spawn $ volume Inc)
    , ((0,        xF86XK_AudioMute), spawn toggleSound)
    ]


barPP :: PP
barPP = def { ppCurrent = wrap "[" "]"
            , ppVisible = wrap "(" ")"
            , ppUrgent  = xmobarColor "red" "yellow"
            , ppLayout  = const ""
            }

main = do
    xmobar <- spawnPipe "pkill -f '^xmobar'; stack exec xmobar ~/.xmonad/xmobar.hs"
    xmonad $ def {
      terminal = "urxvt"
    , normalBorderColor  = "#6272a4" -- or more classical: "#cccccc"
    , focusedBorderColor = "#ff5555" -- "#D32F2F"
    , layoutHook = avoidStruts $ smartBorders $ ResizableTall 1 (3/100) (1/2) []
    , keys = myKeys <+> keys def
    , logHook = dynamicLogWithPP barPP { ppOutput = hPutStrLn xmobar }
    , modMask = mod4Mask -- use the Win key as mod
    }


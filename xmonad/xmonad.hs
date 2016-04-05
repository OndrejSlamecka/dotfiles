import qualified Data.Map (fromList)
import XMonad
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import Graphics.X11.ExtraTypes.XF86 -- multimedia keys


-- Volume
data Vol = Increase | Decrease | Toggle

volume :: Vol -> X ()
volume m = spawn $ case m of
  Toggle   -> "amixer set Master toggle"
  Increase -> on +&&+ modvol "+"
  Decrease -> on +&&+ modvol "-"
  where
    modvol   = ("amixer set Master 2" ++)
    on       = on_m +&&+ on_h
    on_m     = "amixer set Master on"
    on_h     = "amixer set Headphone on"
    a +&&+ b = a ++ " && " ++ b


-- XMonad
main :: IO ()
main = do
  myXmobar <- spawnPipe "pkill -f '^xmobar'; stack exec xmobar ~/.xmonad/xmobar.hs"
  xmonad $ def {
    terminal           = "urxvt"
  , normalBorderColor  = "#6272a4" -- the Dracula theme
  , focusedBorderColor = "#ff5555"
  , layoutHook         = myLayoutHook
  , keys               = myKeys <+> keys def
  , logHook            = myLogHook myXmobar
  , modMask            = mod4Mask -- use the Win key as mod
  , handleEventHook    = docksEventHook
  }
  where
    myLayoutHook = avoidStruts . smartBorders $ (tall ||| wide)
      where tall = ResizableTall 1 (3/100) (1/2) []
            wide = Mirror tall

    myKeys XConfig {XMonad.modMask = modm} = Data.Map.fromList
      [
      -- resizableTile, use mod-a and mod-z
        ((modm,                 xK_a), sendMessage MirrorShrink)
      , ((modm,                 xK_z), sendMessage MirrorExpand)

      -- mod-b to toggle bars
      , ((modm,                 xK_b), sendMessage ToggleStruts)

      -- audio
      , ((0, xF86XK_AudioLowerVolume), volume Decrease)
      , ((0, xF86XK_AudioRaiseVolume), volume Increase)
      , ((0,        xF86XK_AudioMute), volume Toggle)
      ]

    myLogHook bar = dynamicLogWithPP $ def
      { ppCurrent = wrap "[" "]"
      , ppVisible = wrap "(" ")"
      , ppUrgent  = xmobarColor "red" "yellow"
      , ppLayout  = const ""
      , ppOutput  = hPutStrLn bar
      }


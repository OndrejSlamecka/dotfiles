import qualified Data.Map (fromList)
import Control.Monad (void)
import XMonad
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import XMonad.Actions.Volume
import XMonad.Actions.SpawnOn (manageSpawn, spawnOn)
import qualified XMonad.StackSet as W (view, greedyView, shift)
import Graphics.X11.ExtraTypes.XF86 -- multimedia keys
import Graphics.X11.ExtraTypes.XorgDefault -- zcaron and similar Czech keys


-- XMonad
main :: IO ()
main = do
  myXmobar <- spawnPipe "pkill -f '^xmobar'; stack exec xmobar ~/.xmonad/xmobar.hs &> ~/.xmonad/xmobar.errors"
  xmonad $ def { terminal           = "termite"
               , normalBorderColor  = "#6272a4" -- the Dracula theme
               , focusedBorderColor = "#ff5555"
               , layoutHook         = myLayoutHook
               , keys               = myKeys <+> keys def
               , logHook            = myLogHook myXmobar
               , modMask            = mod4Mask -- use the Win key as mod
               , manageHook         = manageSpawn <+> manageHook def
               , handleEventHook    = docksEventHook
               , startupHook        = myStartupHook
               }
  where
    myLayoutHook = avoidStruts . smartBorders $ (tall ||| wide)
      where
        tall = ResizableTall 1 (3/100) (1/2) []
        wide = Mirror tall

    myStartupHook = spawnOn "2" "google-chrome-stable"
                    <+> spawnOn "3" "audacious"
                    <+> windows (W.view "2")

    myKeys conf@XConfig { modMask = modm } = Data.Map.fromList $
      [
      -- resizableTile, use mod-a and mod-z
        ((modm,                 xK_a), sendMessage MirrorExpand)
      , ((modm,                 xK_z), sendMessage MirrorShrink)

      -- mod-b to toggle bars
      , ((modm,                 xK_b), sendMessage ToggleStruts)

      -- mod-p to run launcher
      , ((modm,                 xK_p), spawn "rofi -show run")

      -- audio, contrary to intuition `setMute True` means unmute
      , ((0, xF86XK_AudioLowerVolume), void $ setMute True >> lowerVolume 3)
      , ((0, xF86XK_AudioRaiseVolume), void $ setMute True >> raiseVolume 3)
      , ((0,        xF86XK_AudioMute), void   toggleMute)
      ]
      ++
      -- Switching workspaces with my Czech keyboard
      -- (ůěšřžýáíé instead of 1234567890)
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) uesrzyaie
        , (m, f) <- [(noModMask, W.greedyView), (shiftMask, W.shift)]
      ]
      where
        uesrzyaie = [ xK_uring  -- ů
                    , xK_ecaron -- ě
                    , xK_scaron -- š
                    , xK_ccaron -- č
                    , xK_rcaron -- ř
                    , xK_zcaron -- ž
                    , xK_yacute -- ý
                    , xK_aacute -- á
                    , xK_iacute -- í
                    , xK_eacute -- é
                    ]

    myLogHook bar = dynamicLogWithPP $ def
      { ppCurrent = wrap "[" "]"
      , ppVisible = wrap "(" ")"
      , ppUrgent  = xmobarColor "red" "yellow"
      , ppLayout  = const ""
      , ppOutput  = hPutStrLn bar
      }

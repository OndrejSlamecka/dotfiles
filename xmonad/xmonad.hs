import qualified Data.Map (fromList)
import Codec.Binary.UTF8.String (encodeString)
import Control.Monad (void, liftM)
import Data.List (intercalate, intersperse, isPrefixOf, isSuffixOf)
import XMonad
import XMonad.Layout (Full)
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog hiding (wrap)
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import XMonad.Actions.Volume (toggleMute, setMute, lowerVolume, raiseVolume)
import XMonad.Actions.SpawnOn (manageSpawn, spawnOn)
import XMonad.Actions.PhysicalScreens
import XMonad.Layout.IndependentScreens
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W (view, greedyView, shift)
import XMonad.Actions.PhysicalScreens
import XMonad.Layout.IndependentScreens
import XMonad.Hooks.EwmhDesktops
import           XMonad.Util.NamedWindows (getName, unName)
import           XMonad.Util.WorkspaceCompare (getSortByIndex, WorkspaceSort)
import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86 -- multimedia keys
import Graphics.X11.ExtraTypes.XorgDefault -- zcaron and similar Czech keys

import System.IO (Handle)
import Control.Applicative
import Data.Maybe
import Graphics.X11.Xinerama (getScreenInfo)


spawnXmobarOnScreen :: Int -> IO Handle
spawnXmobarOnScreen screen = spawnPipe $ "stack exec -- xmobar -x " ++ show screen ++ " ~/dotfiles/xmonad/xmobar.hs"

-- XMonad
main :: IO ()
main = do
  spawn "pkill xmobar"
  nScreens <- countScreens
  xmobars <- mapM spawnXmobarOnScreen [0..nScreens-1]

  xmonad $ def { terminal           = "kitty"
               , normalBorderColor  = "#6272a4" -- the Dracula theme
               , focusedBorderColor = "#ff5555"
               , workspaces         = withScreens (S nScreens) (map show [1..9])
               , layoutHook         = myLayoutHook
               , keys               = myKeys <+> keys def
               , logHook            = fancyLogHook xmobars
               , modMask            = mod4Mask -- use the Win key as mod
               , manageHook         = manageSpawn <+> manageHook def <+> manageDocks
               , handleEventHook    = docksEventHook
               --, startupHook        = myStartupHook
               }
  where
    myLayoutHook = avoidStruts . smartBorders $ (tall ||| wide ||| Full)
      where
        tall = ResizableTall 1 (3/100) (1/2) []
        wide = Mirror tall

    myStartupHook = spawnOn "1_1" "firefox"
                    <+> spawnOn "2_1" "audacious"
                    <+> windows (W.view "1_1")

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

      -- lock
      , ((modm,                 xK_g), spawn "light-locker-command -l")
      ]
      ++
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      [((modm .|. mask, key), f sc)
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, mask) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]]
      ++
      [((m .|. modm, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


logTitles ppFocus ppUnfocus =
        let
            windowTitles windowset = sequence (map (fmap showName . getName) (W.index windowset))
                where
                    fw = W.peek windowset
                    showName nw =
                        let
                            window = unName nw
                            name = shorten 50 (show nw)
                        in
                            if maybe False (== window) fw
                                then
                                    ppFocus name
                                else
                                    ppUnfocus name
        in
            withWindowSet $ liftM (Just . (intercalate " | ")) . windowTitles

--
fancyLogHook :: [Handle] -> X ()
fancyLogHook hs = do
  let screens = map S [0..length hs - 1]
  ws <- gets windowset
  mapM (uncurry $ oneScreenLogHook ws) (zip screens hs)

  return ()

sepBy :: String   -- ^ separator
      -> [String] -- ^ fields to output
      -> String
sepBy sep = concat . intersperse sep . filter (not . null)

-- TODO: Clean up.
-- This was quickly hacked up, clean it on the next free time occasion.
oneScreenLogHook :: WindowSet -> ScreenId -> Handle -> X ()
oneScreenLogHook ws s h = do
  sort' <- getSortByIndex
  let workspaces = sort' $ filter (onScreen s) $ map W.workspace (W.current ws : W.visible ws) ++ W.hidden ws

  finalText <- sepBy " " <$> (sequence (map fmt workspaces))
  io $ hPutStrLn h (encodeString finalText)

  where
    onScreen (S s) wos = ((show s) ++ "_") `isPrefixOf` (W.tag wos)

    this     = W.currentTag ws
    visibles = map (W.tag . W.workspace) (W.visible ws)

    fmt :: W.Workspace String b Window -> X String
    fmt w = do
      workspace <- doWorkspace w
      return $ printer ((tail $ snd $ break (=='_') $ (W.tag w)) ++ workspace)
     where printer | W.tag w == this                               = wrap "[" "]"
                   | W.tag w `elem` visibles && isJust (W.stack w) = wrap "(" ")"
                   | W.tag w `elem` visibles                       = wrap "|" "|"
                   | isJust (W.stack w)                            = wrap "(" ")"
                   | otherwise                                     = const ""

    doWorkspace w = titles (W.stack w)
    titles :: Maybe (W.Stack Window) -> X String
    titles Nothing = pure ""
    titles (Just stack) = (": "++) <$> (intercalate " | " <$> sequence (foo (W.integrate stack)))
    foo :: [Window] -> [X String]
    foo stack = map (fmap ((shorten 50) . fixName . show) . getName) stack

    fixName n
      | (chromeSuffix `isSuffixOf` n) = "Chrome - " ++ (reverse . drop (length chromeSuffix) . reverse) n -- TODO https://www.joachim-breitner.de/blog/600-On_taking_the_last_n_elements_of_a_list
      | (firefoxSuffix `isSuffixOf` n) = "Firefox - " ++ (reverse . drop (length firefoxSuffix) . reverse) n -- TODO https://www.joachim-breitner.de/blog/600-On_taking_the_last_n_elements_of_a_list
      | ("Audacious" `isSuffixOf` n)     = "Audacious"
      | otherwise = n

    chromeSuffix = " - Google Chrome"
    firefoxSuffix = " - Mozilla Firefox"


-- | Wrap a string in delimiters, unless it is empty.
wrap :: String  -- ^ left delimiter
     -> String  -- ^ right delimiter
     -> String  -- ^ output string
     -> String
wrap _ _ "" = ""
wrap l r m  = l ++ m ++ r

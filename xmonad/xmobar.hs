-- see also http://ixday.github.io/pop-up-with-xmobar.html
-- $ echo -e "\uf027"   -- to print UTF char to be used by Font Awesome

Config
  { font = "xft:Ubuntu:size=5:antialias=true"
  , additionalFonts  = ["xft:FontAwesome:size=5"]
  , bgColor          = "black"
  , fgColor          = "grey"
  , alpha            = 160
  , position         = Bottom
  , textOffset       = -1
  , iconOffset       = -1
  , lowerOnStart     = True
  , pickBroadest     = False
  , persistent       = False
  , hideOnStart      = False
  , iconRoot         = "."
  , allDesktops      = True
  , overrideRedirect = True
  , sepChar          = "%"
  , alignSep         = "}{"
  , template = " %StdinReader% }{ %volume%   %date%  "
  , commands =
    [ Run Date "%H:%M" "date" 10
    , Run Com "dotfiles/xmonad/volume.sh" [] "volume" 10
    , Run StdinReader
    ]
  }

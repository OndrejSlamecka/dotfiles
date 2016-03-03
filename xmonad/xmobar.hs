-- see also http://ixday.github.io/pop-up-with-xmobar.html
-- $ echo -e "\uf027"   -- to print UTF char to be used by Font Awesome

Config { font = "xft:Ubuntu:size=10:antialias=true"
       , additionalFonts = ["xft:FontAwesome-11"]
       , bgColor = "black"
       , fgColor = "grey"
       , alpha = 50
       , position = BottomP 2 2
       , textOffset = -1
       , iconOffset = -1
       , lowerOnStart = True
       , pickBroadest = False
       , persistent = False
       , hideOnStart = False
       , iconRoot = "."
       , allDesktops = True
       , overrideRedirect = True
       , commands = [ Run Date "%H:%M" "date" 10
                    , Run Com "/home/ondra/.xmonad/volume.sh" [] "volume" 10
                    , Run StdinReader ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ <fn=1>%volume%</fn>   %date%"
       }

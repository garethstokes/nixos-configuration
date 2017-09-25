import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import System.IO

base = desktopConfig

main = do
  xmproc <- spawnPipe "xmobar"

  xmonad $ base
    { manageHook = manageDocks <+> manageHook base
    , layoutHook = avoidStruts $ noBorders (layoutHook base)
    , logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  , ppTitle = shorten 21
                  }
    , terminal          = myTerminal
    , modMask           = myModMask
    } `additionalKeys`
      [ ((myModMask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
      , ((myModMask, xK_c), spawn "chromium")
      , ((myModMask, xK_s), spawn "slack")
      ]

myTerminal = "urxvt"
myModMask  = mod4Mask

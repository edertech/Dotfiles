import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import System.IO (Handle, hPutStrLn)
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.SetWMName


main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ docks defaultConfig
        { manageHook  = manageDocks <+> manageHook defaultConfig
        , layoutHook  = avoidStruts  $  layoutHook defaultConfig
        , startupHook = startupApps
        , focusedBorderColor  = "#c678dd"
        , logHook     = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
        , modMask     = modKey
        , terminal    = term
        } `additionalKeys` customKeys

term = "alacritty -e fish"
modKey = mod4Mask

startupApps = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    setWMName "LG3D"

customKeys =
    [ ((modKey .|. shiftMask, xK_z  ), spawn $ "arcolinux-logout")
    , ((modKey .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
    , ((modKey .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
    , ((0, xK_Print                 ), spawn $ "xfce4-screenshooter")
    , ((modKey, xK_r                ), spawn $ "rofi -show run")
    ]

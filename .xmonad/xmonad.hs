import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import System.IO (Handle, hPutStrLn)
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.SetWMName
import Graphics.X11.ExtraTypes.XF86


main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ docks defaultConfig
        { manageHook         = manageDocks <+> manageHook defaultConfig
        , layoutHook         = avoidStruts  $  layoutHook defaultConfig
        , startupHook        = startupApps
        , focusedBorderColor = "#c678dd"
        , modMask            = modKey
        , handleEventHook    = fullscreenEventHook
        , terminal           = term
        , logHook            = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
        } `additionalKeys` customKeys

term     = "alacritty -e fish"
modKey   = mod4Mask
modShift = modKey .|. shiftMask

startupApps = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    setWMName "LG3D"

customKeys =
    [ ((modShift, xK_z             ), spawn $ "arcolinux-logout")
    , ((0       , xK_Print         ), spawn $ "xfce4-screenshooter")
    , ((0       , xF86XK_AudioPlay ), spawn $ "playerctl play-pause")
    , ((0       , xF86XK_AudioNext ), spawn $ "playerctl next")
    , ((0       , xF86XK_AudioPrev ), spawn $ "playerctl previous")
    , ((0       , xF86XK_AudioStop ), spawn $ "playerctl stop")
    ]

import XMonad

import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName

import XMonad.Layout.Spacing

import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import Data.Monoid
import Data.Maybe
import Data.Tree

import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

------------------------------------------------------------------------

-- The preferred terminal program.
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus
-- also passes the click to the window.
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth = 2

-- We use super (windows key) as modifier key.
myModMask = mod4Mask

-- Workspaces
myWorkspaces = ["web", "dev", "game", "msc", "dsc"]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..]

-- Make workspaces clickable.
clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#2E3440"
myFocusedBorderColor = "#5E81AC"

------------------------------------------------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-shift-enter                Launch XMonad preferred terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- mod-p                          Launch rofi in `drun` mode
    , ((modm              , xK_p     ), spawn "rofi -show drun")

    -- alt-tab                        Launch rofi in `window` mode
    , ((mod1Mask,           xK_Tab   ), spawn "rofi -show window") 

    -- mod-shift-l                    Switch keyboard layout between us(intl) and fr
    , ((modm .|. shiftMask, xK_l     ), spawn "~/.xmonad/scripts/switchlayout.sh")

    -- mod-shift-c                    Close focused window.
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- mod-space                     Rotate through the available layout algorithms
    , ((modm              , xK_space ), sendMessage NextLayout)

    --  mod-shift-space               Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)    

    -- mod-j                          Move focus to the next window
    , ((modm              , xK_j     ), windows W.focusDown)

    -- mod-k                          Move focus to the previous window
    , ((modm              , xK_k     ), windows W.focusUp)

    -- mod-shift-j                    Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown)

    -- mod-shift-k                    Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp)

    -- mod-h                          Shrink the master area
    , ((modm              , xK_h     ), sendMessage Shrink)

    -- mod-l                          Expand the master area
    , ((modm              , xK_l     ), sendMessage Expand)

    -- mod-t                          Push window back into tiling; unfloat and re-tile it
    , ((modm              , xK_t     ), withFocused $ windows . W.sink)

    -- mod-r                          Resize/refresh viewed windows to the correct size
    , ((modm              , xK_r     ), refresh)

    -- mod-comma                      Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- mod-period                     Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- mod-shift-q                    Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- mod-q                          Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- mod-shift-slash                Open help text in alacritty (less)
    , ((modm .|. shiftMask, xK_slash ), spawn "alacritty -e less ~/.xmonad/help.txt")

    -- mod-shift-s                    Take a screenshot (flameshot)
    , ((modm .|. shiftMask, xK_s     ), spawn "flameshot gui")

    -- XF86MonBrightnessUp            Brightness +10%
    , ((0,                 0x1008ff02), spawn "xbacklight -inc 10")
    -- XF86MonBrightnessDown          Brightness -10%
    , ((0,                 0x1008ff03), spawn "xbacklight -dec 10")

    -- XF86AudioRaiseVolume           Volume +2% to Master
    , ((0,                 0x1008ff13), spawn "amixer -q sset Master 2%+")
    -- XF86AudioLowerVolume           Volume -2% to Master
    , ((0,                 0x1008ff11), spawn "amixer -q sset Master 2%-")

    -- XF86AudioMute                  Toggle Master (amixer)
    , ((0,                 0x1008ff12), spawn "amixer set Master toggle")
    -- XF86AudioMicMute               Toggle Capture (amixer)
    , ((0,                 0x1008ffb2), spawn "amixer set Capture toggle")

    -- shift-XF86AudioRaiseVolume     Volume +2% to Capture (amixer)
    , ((shiftMask,         0x1008ff13), spawn "amixer -q sset Capture 2%+")
    -- shift-XF86AudioLowerVolume.    Volume -2% to Capture (amixer)
    , ((shiftMask,         0x1008ff11), spawn "amixer -q sset Capture 2%-")
    ]
    ++

    -- mod-[1..5], Switch to workspace N
    -- mod-shift-[1..5], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_5]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1.     Set the window to floating mode and move by dragging.
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button3.   Set the window to floating mode and resize by dragging.
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

------------------------------------------------------------------------

myLayout = avoidStruts $ spacing 10 $ (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------

myManageHook = composeAll
    [ className =? "confirm"       --> doFloat
    , className =? "file_progress" --> doFloat
    , className =? "dialog"        --> doFloat
    , className =? "download"      --> doFloat
    , className =? "error"         --> doFloat
    , className =? "notification"  --> doFloat

    , className =? "discord"       --> doShift (myWorkspaces !! 4)
    
    , isDialog                     --> doFloat
    , isFullscreen                 --> doFullFloat
    
    -- When we pin to desktop, always float.
    , className =? "flameshot"     --> doFloat
    ]

myEventHook = dynamicPropertyChange "WM_CLASS"
  $ composeAll [
    className =? "Spotify" --> doShift (myWorkspaces !! 3)
  , className =? "Steam" --> doShift (myWorkspaces !! 2)
  ]

------------------------------------------------------------------------

myWallpaperPath :: String
myWallpaperPath = "~/.vexcited-dotfiles/wallpapers/wallpaper-2.png"

myStartupHook = do
  setWMName "LG3D"
  spawnOnce $ "feh --no-fehbg --bg-fill " ++ myWallpaperPath ++ " &"
  spawnOnce "picom --experimental-backend -b &"
  spawnOnce "~/.xmonad/scripts/trayer.sh &"

------------------------------------------------------------------------

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
  xmonad $ ewmh $ docks $ defaults xmproc

defaults xmproc = def {
  terminal           = myTerminal,
  focusFollowsMouse  = myFocusFollowsMouse,
  clickJustFocuses   = myClickJustFocuses,
  borderWidth        = myBorderWidth,
  modMask            = myModMask,
  workspaces         = myWorkspaces,
  normalBorderColor  = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,

-- Key bindings.
  keys               = myKeys,
  mouseBindings      = myMouseBindings,

-- Hooks, layouts.
  layoutHook         = myLayout,
  manageHook         = myManageHook,
  handleEventHook    = myEventHook,
  startupHook        = myStartupHook,
  logHook            =
    workspaceHistoryHook <+> dynamicLogWithPP xmobarPP
      { ppOutput          = \x -> hPutStrLn xmproc x
      , ppCurrent         = xmobarColor "#88C0D0" "" . wrap "<box type=Bottom width=4 mb=0 color=#88C0D0>" "</box>"
      , ppVisible         = xmobarColor "#88C0D0" "" . clickable
      , ppHidden          = xmobarColor "#81A1C1" "" . clickable
      , ppHiddenNoWindows = xmobarColor "#5E81AC" "" . clickable
      , ppOrder           = \(ws : t : ex) -> [ws]
      }
}

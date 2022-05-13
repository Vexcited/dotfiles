import XMonad

import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

import XMonad.Hooks.ManageDocks         ( ToggleStruts(..)
                                        , avoidStruts
                                        , docks
                                        , manageDocks
                                        )

import XMonad.Hooks.DynamicLog          ( PP(..)
                                        , dynamicLogWithPP
                                        , shorten
                                        , wrap
                                        , xmobarColor
                                        , xmobarPP
                                        )

import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import XMonad.Layout.Spacing

import Data.Monoid
import Data.Maybe
import Data.Tree

import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program.
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth = 2

-- We use the "windows key" as modmask..
myModMask = mod4Mask

myWorkspaces = ["www", "dev", "game", "music", "discord"]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..]

-- Make workspaces clickable.
clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#2E3440"
myFocusedBorderColor = "#5E81AC"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- M-Space-Enter => Launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- M-p => Launch rofi.
    , ((modm,               xK_p     ), spawn "rofi -show drun")

    -- Alt-Tab => Show windows in rofi.
    , ((mod1Mask,           xK_Tab   ), spawn "rofi -show window") 

    -- M-Shift-l => Switch keyboard layout between US-Intl <-> French
    , ((modm .|. shiftMask, xK_l     ), spawn "~/.xmonad/scripts/switchlayout.sh")

    -- M-Shift-c => Close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- M-Space => Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  M-Shift-Space => Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    

    -- Media keys.
    , ((0,                 0x1008ff03), spawn "xbacklight -dec 10")
    , ((0,                 0x1008ff02), spawn "xbacklight -inc 10")
    , ((0,                 0x1008ff11), spawn "amixer -q sset Master 2%-")
    , ((0,                 0x1008ff13), spawn "amixer -q sset Master 2%+")
    , ((0,                 0x1008ff12), spawn "amixer set Master toggle")
    , ((0,                 0x1008ffb2), spawn "amixer set Capture toggle")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
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
    , className =? "Steam"         --> doShift (myWorkspaces !! 2)
    
    , isDialog                     --> doFloat
    , isFullscreen                 --> doFullFloat
    ]

myEventHook = dynamicPropertyChange "WM_CLASS"
  $ composeAll [className =? "Spotify" --> doShift (myWorkspaces !! 3)]

------------------------------------------------------------------------

myWallpaperPath :: String
myWallpaperPath = "~/.vexcited-dotfiles/wallpapers/wallpaper-2.png"

myStartupHook = do
  setWMName "LG3D"
  spawnOnce $ "feh --bg-fill " ++ myWallpaperPath ++ " &"
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
            , ppCurrent         = xmobarColor "#88C0D0" "" . wrap "<box type=Bottom width=2 mb=0 color=#88C0D0>" "</box>"
            , ppVisible         = xmobarColor "#88C0D0" "" . clickable
            , ppHidden          = xmobarColor "#81A1C1" "" . clickable
            , ppHiddenNoWindows = xmobarColor "#5E81AC" "" . clickable
            , ppTitle           = xmobarColor "#B3AFC2" "" . shorten 60
            , ppSep             = "<fc=#4C566A> <fn=1>|</fn> </fc>"
            , ppOrder           = \(ws : t : ex) -> [ws] ++ ex
            }
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["Modifier key: 'super'.",
    "",
    "-- Launching and killing programs",
    "mod-Shift-Enter  Launch a terminal",
    "mod-p            Launch rofi",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "alt-tab          Launch rofi in window mode",
    "",
    "-- Move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- Modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- Resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- Quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "",
    "-- Others",
    "mod-Shift-l  Switch keyboard layout between US-INTL <-> FR",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

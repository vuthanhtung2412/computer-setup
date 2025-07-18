# Vivaldi

## Why not chrome ?

+ Can't split
+ Can't jump to adjacent windows
+ Can't hide tab bar and address bar to save screen space
+ No command bar

## Why not Arc ?

+ Battery hog
+ Address bar can't be on top
+ I don't like auto video pop out
+ `Cmd + f` : can ai search private link (I don't like this)

## Why not Obsidian web view ?

+ No extension

## Commands to know

+ `tab bar` (Opt + e/Cmd + Shift + e) : toogle tab bar (I prefer keeping it off on the left)
+ `address bar` : toogle address bar (I prefer keeping it off)
+ `bookmark bar` : toogle bookmark bar (I prefer keeping it off)
+ `status bar` : toogle status bar (I prefer keeping it off)
+ `tile vertically` (Opt + Shift + \)
+ `tile horizontally` (Opt + -)
+ `Previous/Next tab (by order)` (Opt + shift + h/l)
+ `untile` (Opt + q)
+ `Hibernate background task`
+ `Open command bar` (Cmd + P)
+ `Focus previous/next pane` (Ctrl + h/l)

## Setup

+ Memory saver to `automatic`
+ `Start up/homepage` to <https://www.google.com> and `new tab page` to `homepage`
+ Fix quick command priority
  + open tabs
  + commands
  + bookmarks
  + browsing history
+ Panels on the right
+ New tab position : `After the active tab` or `default`
+ `Tab display > Display close button` : uncheck `On Left Side`

## Notes

+ Since vivaldi tiling is tab-scoped not workspace-scope -> avoid using tab split for extended duration.
+ In a tab stack tiled view, a new tab will automatically open in a tiled pane.
+ Switch tab always break tiling setup. Other browsers seem to use the same mechanism (zen,edge)
+ Avoid new creating new tabs. Try using vimium `b` and `o` as much as possible
  + only use tab for page that has high latency load (ddog, figma)
+ complex grid tile is only possible in tab group

## Problems

+ `Focus previous pane` is not working whet text box is auto focus.
  + Current workaround let tiled tabs close together (in the same tabstack) in a tabstack and then do (Opt + shift + h/l)

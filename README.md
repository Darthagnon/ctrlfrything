# CtrlFrything
Search your current Windows Explorer folder with voidtools' Everything via Ctrl+F, while maintaining a global Everything Search Hotkey. This program also offers an optional additional ```Win```+```S``` global hotkey, for a Everything Search (```Win``` keys cannot be set via Everything settings).

Long have I dreamed of completely replacing Windows Search Indexer (which is rather slow and useless) with [voidtools' Everything](https://voidtools.com/downloads/).

- Vanilla Everything allows you to set a global hotkey to "Toggle Window" (I use ```Ctrl```+```Alt```+```Space```; as far as I know, you can't set ```Win```+```S``` as a hotkey for this)
- There's a hidden config option called ```hotkey_explorer_path_search``` that allows you to set a custom hotkey to search your current working directory in Windows Explorer. [Unfortunately, as of writing, it doesn't work as expected, and replaces the global hotkey](https://www.voidtools.com/forum/viewtopic.php?f=5&t=9055&p=33607#p33607). As a workaround, someone wrote [this AHK script](https://www.voidtools.com/forum/viewtopic.php?t=5928#p17399). In this repo, I update this script to look and work a bit nicer, following inspiration from [Eclipse Encryption](https://github.com/DannyBen/eclipse).
- You can replace the Win10 taskbar search box with [EverythingToolbar](https://github.com/stnkl/EverythingToolbar/releases). It should also work on Windows 7/8/8.1.

Using the above tweaks, you can pretty much [disable Windows Search Indexer](https://www.online-tech-tips.com/computer-tips/simple-ways-to-increase-your-computers-performace-turn-off-indexing-on-your-local-drives/) and just use Everything instead (though, if I remember correctly, last time I did that, my start menu wasn't updating with new shortcuts to newly installed programs).

## Changes I made to the original script:
- Read Everything path from INI, otherwise default to ```C:\Program Files\Everything\Everything.exe```
- ```Win```+```S``` global hotkey for a global search. This script is intended for people who want to completely replace Windows Search Indexer with Everything, so why not? This is optional.
- Icon for compiled EXE that looks like the official Everything icon (same colour scheme).
- Custom context menu for compiled EXE (removed default AutoHotKey junk that we don't need)
- Compiled EXE has been tested to take up no more RAM than running the raw AHK script, so no need to worry about that. 2-3MB RAM

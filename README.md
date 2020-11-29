# CtrlFrything
Search your current Windows Explorer folder with voidtools' Everything via Ctrl+F

Long have I dreamed of completely replacing Windows Search Indexer (which is rather slow and useless) with [voidtools' Everything](https://voidtools.com/downloads/).

- Vanilla Everything allows you to set a global hotkey to "Toggle Window" (I use ```Ctrl```+```Alt```+```Space```; as far as I know, you can't set ```Win```+```S``` as a hotkey for this)
- There's a hidden config option called ```hotkey_explorer_path_search``` that allows you to set a custom hotkey to search your current working directory in Windows Explorer. [Unfortunately, as of writing, it doesn't work as expected, and replaces the global hotkey](https://www.voidtools.com/forum/viewtopic.php?f=5&t=9055&p=33607#p33607). As a workaround, someone wrote [this AHK script](https://www.voidtools.com/forum/viewtopic.php?t=5928#p17399). In this repo, I update this script to look and work a bit nicer, following inspiration from [Eclipse Encryption](https://github.com/DannyBen/eclipse).
- You can replace the Win10 taskbar search box with [EverythingToolbar](https://github.com/stnkl/EverythingToolbar/releases). It should also work on Windows 7/8/8.1.

Using the above tweaks, you can pretty much [disable Windows Search Indexer](https://www.online-tech-tips.com/computer-tips/simple-ways-to-increase-your-computers-performace-turn-off-indexing-on-your-local-drives/) and just use Everything instead (though, if I remember correctly, last time I did that, my start menu wasn't updating with new shortcuts to newly installed programs).


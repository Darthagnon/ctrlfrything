;------------------------------------------------------------------------------
; CtrlFrything
; Search with VoidTools' Everything via Ctrl+F (current folder) and Win+S (global, optional)
;------------------------------------------------------------------------------
; By Fraka, https://www.voidtools.com/forum/viewtopic.php?t=5928#p17399
; Contributions by Darthagnon, https://github.com/Darthagnon/ctrlfrything
; Fixes by u/G1ZM02K, https://www.reddit.com/r/AutoHotkey/comments/k8hfu2/how_to_make_tray_checkmarks_persist_across_script/
;------------------------------------------------------------------------------
; Depends on VoidTools' Everything https://www.voidtools.com/
;------------------------------------------------------------------------------

#SingleInstance, Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

VersionString = 1.2

; Custom Tray Menu
Menu Tray, Tip, Search Everything via Ctrl+F
Menu Tray, NoStandard ; No standard AHK tray context menu
Menu Tray, Add, Commandeer Win+&S, ComWS ; Checkbox for INI option to Search Everything via Win+S
Menu Tray, Add, Start with Windows, Autoload
Menu Tray, Add, &Pause Hotkeys, MenuSuspend ;AHK "Suspend" does what I expect "Pause" to do.
Menu Tray, Add, &About CtrlFrything..., About
Menu Tray, Add, E&xit CtrlFrything, Exit

; Create settings INI if it doesn't exist and prepopulate with default values
IfNotExist CtrlFrything.ini
{ ; Brackets needed, otherwise it will do 1st IniWrite "IfNotExist", but always do 2nd Iniwrite
  IniWrite C:\Program Files\Everything\Everything.exe, CtrlFrything.ini, Config, EverythingPath
  IniWrite %ReplaceWinS%, CtrlFrything.ini, Config, ReplaceWinS ;Write CORRECT value to ini!
}

; Read settings INI, specify default values in case it is unreadable
IniRead, EverythingPath, CtrlFrything.ini, Config, EverythingPath, C:\Program Files\Everything\Everything.exe
IniRead, ReplaceWinS, CtrlFrything.ini, Config, ReplaceWinS, 0
If ReplaceWinS ;If read value=True
  Menu Tray, Check, Commandeer Win+&S ;Set the checkmark!
  
IfExist %A_Startup%\%A_ScriptName%.lnk, Menu Tray, Check, Start with Windows

If( FileExist( "CtrlFrything.ico" ) )
  Menu Tray, Icon, CtrlFrything.ico,, 1 ;Freeze tray icon, so it doesn't change to AHK "S"(suspend) or "H" (paused). Custom pause icon unavailable?

; Setting: Depending on INI, set global hotkey Win+S (Windows Search) to open Everything instead.
#If ( ReplaceWinS=1)
#s::Run, % EverythingPath

; Main function: Ctrl+F within a Windows Explorer window searches the current working directory.
#If WinActive("ahk_class CabinetWClass")   ; contextual Hotkey, run only for active windows of class 'CabinetWClass'
^f::
  ActiveID := WinExist()   ; ID of the 'last found' window by #If
  For w In ComObjCreate("Shell.Application").Windows
    If (w.HWND = ActiveID)   ; test if ID (HWND) of the explorer window equals the one of the currently active window
    {
      StringReplace, Folder, % w.document.folder.self.path, `%20, % A_Space, All
      Run, % EverythingPath " -path " chr(34) Folder chr(34)
      Break
    }
  w := ""   ; release object w.
Return
#If   ; end contextual hotkey

Autoload:
  IfExist %A_Startup%\%A_ScriptName%.lnk,FileDelete %A_Startup%\%A_ScriptName%.lnk
  else FileCreateShortcut %A_ScriptFullPath%,       %A_Startup%\%A_ScriptName%.lnk
  Menu Tray, ToggleCheck, Start with Windows
Return  

About:
  MsgBox 64, About CtrlFrything, CtrlFrything v%VersionString% `nby AHK & Everything Communities`nhttps://github.com/Darthagnon/ctrlfrything`n`nSearch with VoidTools' Everything via Ctrl+F (current folder) and Win+S (global, optional). `n`n If you installed Everything to a custom path, edit CtrlFrything's INI file.
Return

ComWs:
  ReplaceWinS := !ReplaceWinS ; flip INI flag
  IniWrite %ReplaceWinS%, CtrlFrything.ini, Config, ReplaceWinS
  Reload ; Checkmarks are not persistent across reloads
  Sleep 1000
Return

MenuSuspend: ; Place Suspend option at the end so script doesn't start suspended.
  Menu, Tray, ToggleCheck, &Pause Hotkeys ; toggle checkmark next to "Pause" in tray menu
  Ticked := !Ticked ; flip temp variable flag
  Suspend, Toggle ; Main purpose of this subroutine
Return

Exit:
  ExitApp
  
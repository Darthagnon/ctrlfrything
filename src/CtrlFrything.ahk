; Source: https://www.voidtools.com/forum/viewtopic.php?t=5928#p17399
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force

; Create settings INI if it doesn't exist and prepopulate with default values
IfNotExist CtrlFrything.ini
{ ; Brackets needed, otherwise it will do 1st IniWrite "IfNotExist", but always do 2nd Iniwrite
	IniWrite C:\Program Files\Everything\Everything.exe, CtrlFrything.ini, Config, EverythingPath
	IniWrite 0, CtrlFrything.ini, Config, ReplaceWinS
}

; Read settings INI, specify default values in case it is unreadable
IniRead, EverythingPath, CtrlFrything.ini, Config, EverythingPath, C:\Program Files\Everything\Everything.exe
IniRead, ReplaceWinS, CtrlFrything.ini, Config, ReplaceWinS, 0


; Custom Tray Menu
If( FileExist( "CtrlFrything.ico" ) )
{
	Menu, Tray, Icon, CtrlFrything.ico,, 1 ;Freeze tray icon, so it doesn't change to AHK "S"(suspend) or "H" (paused). Custom pause icon unavailable?
}

Menu Tray, Tip, Search Everything via Ctrl+F
Menu Tray, NoStandard ; No standard AHK tray context menu
Menu Tray, Add, Commandeer Win+&S, ComWS ; Checkbox for INI option to Search Everything via Win+S
Menu Tray, Add, &Pause Hotkeys, MenuSuspend ;AHK "Suspend" does what I expect "Pause" to do.
Menu Tray, Add, E&xit CtrlFrything, Exit


; Setting: Depending on INI, set global hotkey Win+S (Windows Search) to open Everything instead.
#If ( ReplaceWinS=1)
#s:: 
	{
		Run, % EverythingPath
	}
Return
#If ; End conditional


; Main function: Ctrl+F within a Windows Explorer window searches the current working directory.
#If WinActive("ahk_class CabinetWClass")   ; contextual Hotkey, run only for active windows of class 'CabinetWClass'

^f::
   ActiveID := WinExist()   ; ID of the 'last found' window by #If
   For w In ComObjCreate("Shell.Application").Windows
   {
      If (w.HWND = ActiveID)   ; test if ID (HWND) of the explorer window equals the one of the currently active window
      {
         StringReplace, Folder, % w.document.folder.self.path, `%20, % A_Space, All
         Run, % EverythingPath " -path " chr(34) Folder chr(34)
         Break
      }
   }
   w := ""   ; release object w.
Return
#If   ; end contextual hotkey

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
Return

; Debug emergency quit red button
; Esc::ExitApp  ; Exit script with Escape key

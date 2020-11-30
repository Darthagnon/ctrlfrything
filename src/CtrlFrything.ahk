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

	Menu, Tray, Icon, CtrlFrything.ico

Menu Tray, Tip, Search Everything via Ctrl+F
Menu Tray, NoStandard
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

Exit:
    ExitApp
Return



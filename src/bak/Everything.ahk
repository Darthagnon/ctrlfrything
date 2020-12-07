; Source: https://www.voidtools.com/forum/viewtopic.php?t=5928#p17399
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force

#If WinActive("ahk_class CabinetWClass")   ; contextual Hotkey, run only for active windows of class 'CabinetWClass'
^F:: ; EDIT ME (^F = Ctrl+F)
   ActiveID := WinExist()   ; ID of the 'last found' window by #If
   For w In ComObjCreate("Shell.Application").Windows
   {
      If (w.HWND = ActiveID)   ; test if ID (HWND) of the explorer window equals the one of the currently active window
      {
         StringReplace, Folder, % w.document.folder.self.path, `%20, % A_Space, All
         Run, % "E:\Program Files\pf(x64)\Everything\Everything.exe -path " chr(34) Folder chr(34) ; EDIT ME
         Break
      }
   }
   w := ""   ; release object w.
Return
#If   ; end contextual hotkey
;------------------------------------------------------------------------------
; Eclipse
; Encrypt / Decrypt any text with a simple hotkey
;------------------------------------------------------------------------------
; By Danny Ben Shitrit - Sector Seven
; http://sector-seven.net | db@sector-seven.net
;------------------------------------------------------------------------------
; Uses MySecret.exe by DI Management Services Pty Ltd
; MySecret: http://www.di-mgt.com.au/mysecret.html
;------------------------------------------------------------------------------

; INIT
#SingleInstance Force
VersionString = 0.25
SetWorkingDir %A_ScriptDir%
FileInstall MySecret.exe, %A_Temp%\MySecret.exe
MySecret = %A_Temp%\MySecret.exe
If( !FileExist( MySecret ) ) {
	MsgBox 48, Oops..., Unable to find MySecret.exe.
	ExitApp
}

; TRAY MENU
If( FileExist( "Eclipse.ico" ) )
	Menu, Tray, Icon, Eclipse.ico
Menu Tray, Tip, Eclipse %VersionString%
Menu Tray, NoStandard
Menu Tray, Add, &Modify Encryption/Decryption Hotkey, ModifyActionHotkey
Menu Tray, Add, M&odify Forget Password Hotkey, ModifyForgetHotkey
Menu Tray, Add
Menu Tray, Add, &Forget Password, Forget
Menu Tray, Add
Menu Tray, Add, &About Eclipse, About
Menu Tray, Add, E&xit Eclipse, Exit

; INI CONFIG IF AVAILABLE
IniRead ActionKey, Eclipse.ini, Config, ActionHotkey , ^+e	
IniRead ForgetKey, Eclipse.ini, Config, ForgetHotkey , ^+!f	
IniRead HideIcon,  Eclipse.ini, Config, HideIcon , 0
IniRead RememberDefault,  Eclipse.ini, Config, RememberDefaultState, 1
IniRead AlwaysOnTop,  Eclipse.ini, Config, AlwaysOnTop, 1
Hotkey %ActionKey%, Execute
Hotkey %ForgetKey%, Forget

If( HideIcon )
	Menu Tray, NoIcon

; GUI
Gui Margin, 4, 4
Gui +ToolWindow 
If( AlwaysOnTop )
	Gui +AlwaysOnTop
Gui +E0x40000
Gui Font, s16
Gui Add, Edit, w200 vPass Center Password
Gui Font, s11
Gui Add, Checkbox, Checked%RememberDefault% vRemember gFocusPassword, &Remember
Gui Add, Button, x0 y0 w0 h0 Default gGuiSubmit

Return
#include HotkeyDialog.ahk

Execute:
	Clipboard := ""
	Send ^c
	ClipWait 1, 1
	If !ErrorLevel {
		If Remember 
			Gosub RunSecret
		Else {
			Gui Show,,Password			
			GuiControl Focus, Pass
		}
	}
Return

RunSecret:
	RunWait %MySecret% -p`"%pass%`",,HIDE
	Send ^v
Return

GuiSubmit:
	Gui Submit
	GuiControl,,Pass, % ""
	Gosub RunSecret
Return

GuiEscape:
GuiClose:
	Gui Hide
Return

Forget:
	Remember := false
	Pass := ""	
Return

FocusPassword:
	GuiControl Focus, Pass
Return

ModifyActionHotkey:
	NewKey := SelectHotkey( ActionKey )
	If( NewKey != ActionKey ) {
		IniWrite %NewKey%, Eclipse.ini, Config, ActionHotkey	
		Reload
		Sleep 1000
	}
Return

ModifyForgetHotkey:
	NewKey := SelectHotkey( ForgetKey )
	If( NewKey != ForgetKey ) {
		IniWrite %NewKey%, Eclipse.ini, Config, ForgetHotkey
		Reload
		Sleep 1000
	}
Return

About:
	MsgBox 64, About Eclipse, Eclipse %VersionString% by Danny Ben Shitrit`nwww.sector-seven.net
Return

Exit:
	ExitApp
Return

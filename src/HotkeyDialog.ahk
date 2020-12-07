SelectHotkey( originalKey="" ) {
	Global _SelectHotkeyOpen, _SelectHotkeyAction
	Static GuiKey, GuiCtrl, GuiAlt, GuiWin, GuiShift
	
	KeyList := "A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|1|2|3|4|5|6|7|8|9|0|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|``|-|=|[|]|;|'|\|,|.|/|Home|End|Insert|Delete|PgUp|PgDn|Backspace"
	
	_SelectHotkeyOpen := true
	
	GuiCtrl  := InStr( originalKey, "^" ) ? 1 : 0
	GuiAlt   := InStr( originalKey, "!" ) ? 1 : 0
	GuiShift := InStr( originalKey, "+" ) ? 1 : 0
	GuiWin   := InStr( originalKey, "#" ) ? 1 : 0
	GuiKey   := RegexReplace( originalKey, "[!+^#]", "" )
	
	GuiID := 8
	Gui %GuiID%:Margin, 10, 10
	Gui %GuiID%:Add, Checkbox, w40 vGuiCtrl Checked%GuiCtrl%, Ctrl
	Gui %GuiID%:Add, Checkbox, xp y+8 vGuiShift Checked%GuiShift%, Shift
	Gui %GuiID%:Add, Checkbox, xp y+8 vGuiAlt Checked%GuiAlt%, Alt
	Gui %GuiID%:Add, Checkbox, xp y+8 vGuiWin Checked%GuiWin%, Win
	
	Gui %GuiID%:Add, ListBox, x80 y10 w100 r6 vGuiKey, %KeyList%
	GuiControl %GuiID%:ChooseString, GuiKey, %GuiKey%
	
	Gui %GuiID%:Add, Button, x10 y+10 w80 Default gReturnHotkey,OK
	Gui %GuiID%:Add, Button, x+10 yp wp gCancelHotkey,Cancel
	
	Gui %GuiID%:Show,,Hotkey
	
	Loop
		If( !_SelectHotkeyOpen )
			Break
			
	If( _SelectHotkeyAction == "cancel" )
		return originalKey
			
	Gui %GuiID%:Submit
	Gui %GuiID%:Destroy
	
	Result := ""
	If( GuiCtrl )
		Result .= "^"
	If( GuiShift )
		Result .= "+"
	If( GuiAlt )
		Result .= "!"
	If( GuiWin )
		Result .= "#"
		
	Result .= GuiKey
	Return Result
}

8GuiEscape:
8GuiClose:
CancelHotkey:
	Gui 8:Destroy
	_SelectHotkeyOpen := false
	_SelectHotkeyAction := "cancel"
Return

ReturnHotkey:
	_SelectHotkeyOpen := false
	_SelectHotkeyAction := "save"
Return
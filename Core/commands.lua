-- Slash commands for addon

defaults = {
	someOption = true,
	whispersTimer = 10,
	voidLoopOption = true,
	whispersLoopOption = true,
	spiritsLoopOption = true,
}

SLASH_WOTV1 = "/wotv"
SLASH_WOTV2 = "/whispersofthevoid"

SlashCmdList.WOTV = function(msg, editBox)
	if msg == "test" then
		print("Test of /commands")
	elseif msg == "reset" then
		WhispersOfTheVoidDB = CopyTable(defaults) -- reset to defaults
		f.db = WhispersOfTheVoidDB 
		print("DB has been reset to default")
	elseif msg == "toggle" then
		f.db.someOption = not f.db.someOption
		print("Toggled someOption to", f.db.someOption)
	else
		InterfaceOptionsFrame_OpenToCategory(f.panel)
	end
end
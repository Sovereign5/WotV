-- create db
local sounds = {}
local f = CreateFrame("Frame")

--  Example of main file w/ options 

function f:OnEvent(event, addOnName)
	if addOnName == "WhispersOfTheVoid" then
		WhispersOfTheVoidDB = WhispersOfTheVoidDB or {}
		self.db = WhispersOfTheVoidDB
		for k, v in pairs(defaults) do -- copy the defaults table and possibly any new options
			if self.db[k] == nil then -- avoids resetting any false values
				self.db[k] = v
			end
		end
		self:InitializeOptions()
		initSounds()
		hooksecurefunc("JumpOrAscendStart", function()
			if self.db.someOption then
				print("Your character jumped.")
			end
		end)
		WhispersOfTheVoidTimer = C_Timer.NewTimer(self.db.whispersTimer, whispersFunction) -- C_Timer that can be cancelled, allowing whisper timer to change w/o issue
	end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)

-- 	Initalize options
function f:InitializeOptions()
	self.panel = CreateFrame("Frame")
	self.panel.name = "Whispers Of The Void" -- Creates panel in options menu

	-- Button to Enable Whispers
	cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, -20)
	cb.Text:SetText("Enable Whispers")
	-- there already is an existing OnClick script that plays a sound, hook it
	cb:HookScript("OnClick", function(_, btn, down)
		self.db.someOption = cb:GetChecked()
		initSounds()
	end)
	cb:SetChecked(self.db.someOption)

	-- Enable whispersLoopSounds
	whispersLoopFrame = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	whispersLoopFrame:SetPoint("TOPLEFT", 40, -50)
	whispersLoopFrame.Text:SetText("Enable Looping Whispers (8 Second duration recommended for continuous effect)")
	whispersLoopFrame:HookScript("OnClick", function(_, btn, down)
		self.db.whispersLoopOption = whispersLoopFrame:GetChecked()
		initSounds()
	end)
	whispersLoopFrame:SetChecked(self.db.whispersLoopOption)

	-- Enables spirits Loop
	spiritsLoopFrame = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	spiritsLoopFrame:SetPoint("TOPLEFT", 40, -80)
	spiritsLoopFrame.Text:SetText("Enable Sprits Loop (6 seconds, might need to alter)")
	spiritsLoopFrame:HookScript("OnClick", function(_, btn, down)
		self.db.spiritsLoopOption = spiritsLoopFrame:GetChecked()
		initSounds()
	end)
	spiritsLoopFrame:SetChecked(self.db.spiritsLoopOption)


	-- Enable Void Loops
	voidLoopFrame = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	voidLoopFrame:SetPoint("TOPLEFT", 40, -110)
	voidLoopFrame.Text:SetText("Enable Void Loops")
	voidLoopFrame:HookScript("OnClick", function(_, btn, down)
		self.db.voidLoopOption = voidLoopFrame:GetChecked()
		initSounds()
	end)
	voidLoopFrame:SetChecked(self.db.voidLoopOption)

	-- Slider for time between Whispers
	whispersTimeSlider = CreateFrame("Slider", "whispers_SliderGlobalName", self.panel, "OptionsSliderTemplate")
	whispersTimeSlider:SetWidth(175)
	whispersTimeSlider:SetHeight(20)
	whispersTimeSlider:SetOrientation('HORIZONTAL')
	whispersTimeSlider:SetPoint("TOPLEFT", 50, -140)
	getglobal(whispersTimeSlider:GetName() .. 'Low'):SetText('8') --Sets the left-side slider text
 	getglobal(whispersTimeSlider:GetName() .. 'High'):SetText('1200') --Sets the right-side slider text
 	whispersTimeSlider:SetValueStep(1)
 	whispersTimeSlider:SetMinMaxValues(8, 1200)
 	whispersTimeSlider:SetObeyStepOnDrag(true)
 	whispersTimeSlider:SetValue(self.db.whispersTimer)

 	-- Value of Slider
 	WhispersTimeSliderValueBox = CreateFrame("EditBox", "whispers_ValueBoxGlobalName", self.panel, "InputBoxTemplate")
 	WhispersTimeSliderValueBox:SetPoint("LEFT", whispers_SliderGlobalName, "RIGHT", 15, 0)
 	WhispersTimeSliderValueBox:SetAutoFocus(false) -- Necessary; default is true and causes keyboard to lock
 	WhispersTimeSliderValueBox:SetSize(100, 25)

 	-- Change to Slider changes Edit Box (And default value)
 	whispersTimeSlider:SetScript("OnValueChanged", function(sliderSelf, value, userInput)
 		self.db.whispersTimer = (floor(value))
 		WhispersTimeSliderValueBox:SetText(floor(value))
 		WhispersOfTheVoidTimer:Cancel() -- Cancels the Whisper Timer
 		WhispersOfTheVoidTimer = C_Timer.NewTimer(WhispersOfTheVoidDB.whispersTimer, whispersFunction) -- Starts a new timer with the new specs
 	end)

 	WhispersTimeSliderValueBox:SetScript("OnTextChanged", function(boxSelf, userInput)
 		if userInput then
 			local value = boxSelf:GetText()
 			if (tonumber(value) ~= nil) then
	 			sliderMin, sliderMax = whispersTimeSlider:GetMinMaxValues()
	 			if (tonumber(value) >= sliderMin and tonumber(value) <= sliderMax) then
	 				whispersTimeSlider:SetValue(value)
		 			self.db.whispersTimer = value;
		 			WhispersOfTheVoidTimer:Cancel()
		 			WhispersOfTheVoidTimer = C_Timer.NewTimer(WhispersOfTheVoidDB.whispersTimer, whispersFunction)
		 		end
		 	else
		 		WhispersTimeSliderValueBox:SetText("")
		 	end
 		end
 	end)

	-- This does something, IDK, probably hooks the panel into the options menu
	InterfaceOptions_AddCategory(self.panel)
end

function whispersFunction()
	-- print("timer success")
	if (cb:GetChecked(true)) then
		if (table.getn(sounds) > 0) then
			--print(sounds)
			selectTable = sounds[math.random(#sounds)]
			selectAudio = selectTable[math.random(#selectTable)]
			if (tonumber(selectAudio) ~= nil) then
				PlaySoundFile(selectAudio)
			end
		end
	else
		WhispersOfTheVoidTimer:Cancel()
	end
	WhispersOfTheVoidTimer = C_Timer.NewTimer(WhispersOfTheVoidDB.whispersTimer, whispersFunction)
end

function initSounds()
	table.wipe(sounds) -- Wipes table to start clean
	if (voidLoopFrame:GetChecked(true)) then -- Puts Void God voices into table
		table.insert(sounds, voidSounds)
	end

	if (whispersLoopFrame:GetChecked(true)) then -- Puts Looping Whispers into table
		table.insert(sounds, whispersLoopSounds)
	end
	if (spiritsLoopFrame:GetChecked(true)) then
		table.insert(sounds, voidSpiritsSounds)
	end
end
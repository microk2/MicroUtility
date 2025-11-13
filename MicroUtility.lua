local AddonName = ...
local AddonFrame = CreateFrame("Frame", "MicroUtility")
AddonFrame:RegisterEvent("ADDON_LOADED")
AddonFrame:RegisterEvent("QUEST_DETAIL")
AddonFrame:RegisterEvent("QUEST_COMPLETE")
AddonFrame:RegisterEvent("QUEST_PROGRESS")

local G_CLOCK_FRAME_NAME = "MicroUtilityClock"
local G_QUEST_ID_FRAME_NAME = "MicroUtilityQuestId"

function CreateFakeClock()
	local originalClockFrame = _G["TimeManagerClockTicker"]
	local fakeClockFrame = _G[G_CLOCK_FRAME_NAME]
	
	if originalClockFrame and originalClockFrame:IsVisible() then
		originalClockFrame:Hide()
	end
	
	if not fakeClockFrame then
		fakeClockFrame = CreateFrame("Frame", G_CLOCK_FRAME_NAME, _G["TimeManagerClockButton"])
		fakeClockFrame:SetSize(80, 20)
		fakeClockFrame:SetPoint("CENTER", -5, 1)

		fakeClockFrame.text = fakeClockFrame:CreateFontString(nil, "ARTWORK", "WhiteNormalNumberFont")
		fakeClockFrame.text:SetAllPoints()
		fakeClockFrame.text:SetJustifyH("CENTER")
		
		fakeClockFrame:Show()
		_G[G_CLOCK_FRAME_NAME] = fakeClockFrame
	end
	
	return fakeClockFrame
end

function UpdateTime()
    local localCheck = _G["TimeManagerLocalTimeCheck"]
    local militaryCheck = _G["TimeManagerMilitaryTimeCheck"]
	local clock = CreateFakeClock()
	
    if not (clock and localCheck and militaryCheck) then return end

    local useLocalTime = localCheck:GetChecked()
    local useMilitaryTime = militaryCheck:GetChecked()

    local h, m, s = nil;
    local ampm = ""

	if useLocalTime then
        local t = date("*t")
        h, m, s = t.hour, t.min, t.sec
    else
        local svh, svm = GetGameTime()

		-- sec between server time and local time have a delay
        h, m = svh, svm 
    end
	
    if not useMilitaryTime then
        if h == 0 then
            h = 12
            ampm = " AM"
        elseif h < 12 then
            ampm = " AM"
        elseif h == 12 then
            ampm = " PM"
        else
            h = h - 12
            ampm = " PM"
        end
    end
	
	if useLocalTime then
		clock.text:SetFormattedText(string.format("%02d:%02d:%02d%s", h, m, s, ampm))
	else
		clock.text:SetFormattedText(string.format("%02d:%02d%s", h, m, ampm))
	end
end

AddonFrame:SetScript("OnUpdate", function(self, elapsed)
    
end)

AddonFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == AddonName then
        C_Timer.NewTicker(1, UpdateTime)
		
        self:UnregisterEvent("ADDON_LOADED")
    end
	
	if event == "QUEST_DETAIL" or event == "QUEST_COMPLETE" or event == "QUEST_PROGRESS" then
		local questFrame = _G["QuestFrame"]
		local questIdFrame = _G[G_QUEST_ID_FRAME_NAME]
		
		if not questIdFrame then
			questIdFrame = CreateFrame("Frame", G_QUEST_ID_FRAME_NAME, questFrame)
			questIdFrame:SetSize(120, 30)
			questIdFrame:SetPoint("TOP", 0, -30) -- Position below the QuestFrame
			
			questIdFrame.text = questIdFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			questIdFrame.text:SetPoint("CENTER", questIdFrame, "CENTER", 0, 0)
			
			_G[G_QUEST_ID_FRAME_NAME] = questIdFrame
		end
		
		questIdFrame.text:SetText("Quest ID: " .. GetQuestID())
	end
end)
local AddonName, ns = ...
ns.Time = {}

ns.Time.Defines = {
	["ClockFrameName"] = "MicroUtilityClock",
}

ns.Time.CreateFakeClock = (function()
	local originalClockFrame = _G["TimeManagerClockTicker"]
	local fakeClockFrame = _G[ns.Time.Defines.ClockFrameName]
	
	if originalClockFrame and originalClockFrame:IsVisible() then
		originalClockFrame:Hide()
	end
	
	if not fakeClockFrame then
		fakeClockFrame = CreateFrame("Frame", ns.Time.Defines.ClockFrameName, _G["TimeManagerClockButton"])
		fakeClockFrame:SetSize(80, 20)
		fakeClockFrame:SetPoint("CENTER", -5, 1)

		fakeClockFrame.text = fakeClockFrame:CreateFontString(nil, "ARTWORK", "WhiteNormalNumberFont")
		fakeClockFrame.text:SetAllPoints()
		fakeClockFrame.text:SetJustifyH("CENTER")
		
		fakeClockFrame:Show()
		_G[ns.Time.Defines.ClockFrameName] = fakeClockFrame
	end
	
	return fakeClockFrame
end)

ns.Time.UpdateTime = (function()
	local localCheck = _G["TimeManagerLocalTimeCheck"]
    local militaryCheck = _G["TimeManagerMilitaryTimeCheck"]
	local clock = ns.Time.CreateFakeClock()
	
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
end)
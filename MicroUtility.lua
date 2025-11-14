local AddonName, ns = ...
local Addon = CreateFrame("Frame", "MicroUtility")
Addon:RegisterEvent("ADDON_LOADED")
Addon:RegisterEvent("QUEST_DETAIL")
Addon:RegisterEvent("QUEST_COMPLETE")
Addon:RegisterEvent("QUEST_PROGRESS")
Addon:RegisterEvent("GOSSIP_SHOW")

Addon:SetScript("OnUpdate", function(self, elapsed)
    
end)

Addon:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == AddonName then
        C_Timer.NewTicker(1, ns.Time.UpdateTime)
		
        self:UnregisterEvent("ADDON_LOADED")
    end
	
	ns.Quest.HandleEvent(event, arg1)
	ns.Gossip.HandleEvent(event, arg1)
end)
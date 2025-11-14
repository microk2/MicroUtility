local AddonName, ns = ...
ns.Quest = {}

ns.Quest.Defines = {
	["QuestIdFrameName"] = "MicroUtilityQuestId",
}

ns.Quest.Classification = {
	[0] = "Important",
	[1] = "Legendary",
	[2] = "Campaign",
	[3] = "Calling",
	[4] = "Meta",
	[5] = "Recurring",
	[6] = "Questline",
	[7] = "Normal",
	[8] = "BonusObjective",
	[9] = "Threat",
	[10] = "WorldQuest",
}

ns.Quest.HandleEvent = (function(event, arg1)
	if event == "QUEST_DETAIL" or event == "QUEST_COMPLETE" or event == "QUEST_PROGRESS" then
		local questFrame = _G["QuestFrame"]
		local questFrameName = ns.Quest.Defines.QuestIdFrameName;
		local questIdFrame = _G[questFrameName]
		
		if not questIdFrame then
			questIdFrame = CreateFrame("Frame", questFrameName, questFrame)
			questIdFrame:SetSize(120, 30)
			questIdFrame:SetPoint("TOP", 0, -30) -- Position below the QuestFrame
			
			questIdFrame.text = questIdFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			questIdFrame.text:SetPoint("CENTER", questIdFrame, "CENTER", 0, 0)
			
			_G[questFrameName] = questIdFrame
		end
		
		local class = C_QuestInfoSystem.GetQuestClassification(GetQuestID())
		
		questIdFrame.text:SetText("Quest ID: " .. GetQuestID() .. " " .. ns.Quest.Classification[class])
	end
end)
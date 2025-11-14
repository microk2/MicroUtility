local AddonName, ns = ...
ns.Gossip = {}

ns.Gossip.Defines = {
}

ns.Gossip.HandleEvent = (function(event, arg1)
	if event == "GOSSIP_SHOW" then
		local info = C_GossipInfo.GetOptions()
		for i, v in pairs(info) do
			-- print(v.orderIndex, v.gossipOptionID, v.name)
		end
	end
end)
local mod = SweetPack

local description = {
	"{{Collectible422}} Adds a stacking 7% chance of activating Glowing Hourglass every time you get hit",
    "Once activated, the chance will stay at 0% until you complete a room",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_CURSE_OF_THE_FOOL, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_CURSE_OF_THE_FOOL, description)



function mod:FoolCurseDMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	local player = entity:ToPlayer()

	if player:HasCollectible(CollectibleType.COLLECTIBLE_CURSE_OF_THE_FOOL, false) then
		local data = player:GetData()

		-- Get the chance
		if not data.FoolCurseChance then
			data.FoolCurseChance = 0
		end
		-- Keep it at zero until the player clears a room
		if not data.FoolCurseUsed then
			data.FoolCurseChance = data.FoolCurseChance + 7
		end

		-- Roll for each copy of the item
		for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CURSE_OF_THE_FOOL, false) do
			if mod:Random(1, 100) <= data.FoolCurseChance then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, UseFlag.USE_NOANIM, -1, 0)

				-- Reset the chance
				data.FoolCurseChance = 0
				data.FoolCurseUsed = true
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.FoolCurseDMG, EntityType.ENTITY_PLAYER)

function mod:FoolrCurseRoomClear()
    for i = 0, Game():GetNumPlayers() - 1 do
		local data = Isaac.GetPlayer(i):GetData()

		if data.FoolCurseUsed then
			data.FoolCurseUsed = nil
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.FoolrCurseRoomClear)
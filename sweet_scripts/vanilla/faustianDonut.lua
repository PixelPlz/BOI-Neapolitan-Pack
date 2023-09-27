local mod = SweetPack

local description = {
	"↑ +0.5 Damage up",
	"↑ +15% Tear Multiplier",
	"↑ +2 Range up",
	"↓ -1 Luck down",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_FAUSTIAN_DONUT, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_FAUSTIAN_DONUT, description)



function mod:DonutCache(player, cacheFlags)
	for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_FAUSTIAN_DONUT, false) do
		-- Damage
		if cacheFlags & CacheFlag.CACHE_DAMAGE > 0 then
			player.Damage = player.Damage + 0.5
		end

		-- Tears
		if cacheFlags & CacheFlag.CACHE_FIREDELAY > 0 then
			player.MaxFireDelay = player.MaxFireDelay * 0.85
		end

		-- Range
		if cacheFlags & CacheFlag.CACHE_RANGE > 0 then
			player.TearRange = player.TearRange + 80
		end

		-- Luck
		if cacheFlags & CacheFlag.CACHE_LUCK > 0 then
			player.Luck = player.Luck - 1
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.DonutCache)
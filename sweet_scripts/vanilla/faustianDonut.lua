local mod = SweetPack

local descriptionEN = {
	"↑ +0.5 Damage",
	"↑ +12% Tears multiplier",
	"↑ +2 Range",
	"↓ -1 Luck",
}
local descriptionRU = {
	"↑ +0.5 к урону",
	"↑ +12% множитель слезы",
	"↑ +2 дальности",
	"↓ -1 удача",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_FAUSTIAN_DONUT, descriptionEN, "Faustian Donut", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_FAUSTIAN_DONUT, descriptionRU, "Фаустовский Пончик", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_FAUSTIAN_DONUT, descriptionEN)



function mod:DonutCache(player, cacheFlags)
	for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_FAUSTIAN_DONUT, false) do
		-- Damage
		if cacheFlags & CacheFlag.CACHE_DAMAGE > 0 then
			player.Damage = player.Damage + 0.5
		end

		-- Tears
		if cacheFlags & CacheFlag.CACHE_FIREDELAY > 0 then
			player.MaxFireDelay = player.MaxFireDelay * 0.88
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
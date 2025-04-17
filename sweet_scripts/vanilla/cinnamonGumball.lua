local mod = SweetPack

local descriptionEN = {
	"Every 24 shots, fire a piece of chewed gum that sticks to enemies and deals high damage over time",
	"↓ -0.05 Speed",
}
local descriptionRU = {
	"Каждые 24 выстрела, выпускаете кусочек жевательной резинки, который прилипает к врагам и со временем наносит большой урон",
	"↓ -0.05 к скорости",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_CINNAMON_GUMBALL, descriptionEN, "Cinnamon Gumball", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_CINNAMON_GUMBALL, descriptionRU, "Жевательная резинка с корицей", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_CINNAMON_GUMBALL, descriptionEN)



function mod:GumballCache(player, cacheFlags)
	for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CINNAMON_GUMBALL, true) do
		-- Speed
		if cacheFlags & CacheFlag.CACHE_SPEED > 0 then
			player.MoveSpeed = player.MoveSpeed - 0.05
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GumballCache)



-- Make every 24th tear a gum tear
function mod:FireGumball(tear)
    local player = tear.SpawnerEntity:ToPlayer() or Isaac.GetPlayer(0)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_CINNAMON_GUMBALL, false) and tear.TearIndex % 24 == 0 then
        tear:AddTearFlags(TearFlags.TEAR_BOOGER | TearFlags.TEAR_BURN)
        tear:ChangeVariant(TearVariant.BOOGER)

        -- Custom color
        local color = tear.Color
        color:SetColorize(2,1,1, 1)
        tear.Color = color

        tear.CollisionDamage = tear.CollisionDamage * 2 + 1
        tear.Scale = tear.Scale * 1.2
        tear:Update()

        SFXManager():Play(SoundEffect.SOUND_LITTLE_SPIT, 0.9)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.FireGumball)
local mod = SweetPack

local description = {
    "{{SoulHeart}} Using a bad or neutral pill will give a Soul Heart",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, description)



function mod:GlassOfWaterPill(effect, player)
	for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, false) do
		local effectConfig = Isaac.GetItemConfig():GetPillEffect(effect)
		local isPositive = effectConfig.EffectSubClass == 1 -- 0 = neutral, 1 = positive, 2 = negative

		if isPositive == false then
			player:AddSoulHearts(2)

			local visual = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 4, player.Position, Vector.Zero, nil):ToEffect()
			visual:FollowParent(player)
			visual.DepthOffset = player.DepthOffset + 10
			visual.SpriteOffset = Vector(0, player.SpriteScale.Y * -35)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.GlassOfWaterPill)
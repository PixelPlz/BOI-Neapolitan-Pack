local mod = SweetPack

local descriptionEN = {
    "{{SoulHeart}} Using a neutral or bad pill will give a half or full Soul Heart respectively",
}
local descriptionRU = {
    "{{SoulHeart}} Используя нейтральную или плохую таблетку даст половину или поное Сердце Души соответственно",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, descriptionEN, "Glass of Water", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, descriptionRU, "Стакан Воды", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, descriptionEN)



mod.GlassOfWaterPills = {
	{PillEffect.PILLEFFECT_BAD_GAS, 1},
	{PillEffect.PILLEFFECT_BAD_TRIP, 2},
	{PillEffect.PILLEFFECT_BOMBS_ARE_KEYS, 1},
	{PillEffect.PILLEFFECT_EXPLOSIVE_DIARRHEA, 1},
	{PillEffect.PILLEFFECT_HEALTH_DOWN, 2},
	{PillEffect.PILLEFFECT_I_FOUND_PILLS, 1},
	{PillEffect.PILLEFFECT_PUBERTY, 1},
	{PillEffect.PILLEFFECT_RANGE_DOWN, 2},
	{PillEffect.PILLEFFECT_SPEED_DOWN, 2},
	{PillEffect.PILLEFFECT_TEARS_DOWN, 2},
	{PillEffect.PILLEFFECT_LUCK_DOWN, 2},
	{PillEffect.PILLEFFECT_TELEPILLS, 1},
	{PillEffect.PILLEFFECT_HEMATEMESIS, 1},
	{PillEffect.PILLEFFECT_PARALYSIS, 2},
	{PillEffect.PILLEFFECT_AMNESIA, 2},
	{PillEffect.PILLEFFECT_LEMON_PARTY, 1},
	{PillEffect.PILLEFFECT_WIZARD, 2},
	{PillEffect.PILLEFFECT_ADDICTED, 2},
	{PillEffect.PILLEFFECT_RELAX, 1},
	{PillEffect.PILLEFFECT_QUESTIONMARK, 2},
	{PillEffect.PILLEFFECT_LARGER, 1},
	{PillEffect.PILLEFFECT_SMALLER, 1},
	{PillEffect.PILLEFFECT_RETRO_VISION, 2},
	{PillEffect.PILLEFFECT_X_LAX, 2},
	{PillEffect.PILLEFFECT_IM_DROWSY, 1},
	{PillEffect.PILLEFFECT_IM_EXCITED, 1},
	{PillEffect.PILLEFFECT_HORF, 1},
	{PillEffect.PILLEFFECT_SHOT_SPEED_DOWN, 2},
	{PillEffect.PILLEFFECT_EXPERIMENTAL, 1},
}



function mod:GlassOfWaterPill(effect, player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, false) and effect ~= PillEffect.PILLEFFECT_VURP then
		local effectConfig = Isaac.GetItemConfig():GetPillEffect(effect)

		for i, effect in pairs(mod.GlassOfWaterPills) do
			if effectConfig.ID == effect[1] then
				local hearts = effect[2]
				player:AddSoulHearts(hearts * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GLASS_OF_WATER, false))

				-- Effects
				local visual = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 4, player.Position, Vector.Zero, nil):ToEffect()
				visual:FollowParent(player)
				visual.DepthOffset = player.DepthOffset + 10
				visual.SpriteOffset = Vector(0, player.SpriteScale.Y * -35)

				SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)

				break
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.GlassOfWaterPill)
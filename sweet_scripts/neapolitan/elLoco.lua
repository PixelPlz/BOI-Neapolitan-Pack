local mod = SweetPack

local descriptionEN = {
	"Applies a random status effect to every enemy in the room",
}
local descriptionRU = {
	"Применяется эффект случайного состояния к каждому врагу в комнате",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_EL_LOCO, descriptionEN, "El Loco", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_EL_LOCO, descriptionRU, "El Loco", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_EL_LOCO, descriptionEN)



function mod:ElLocoUse(id, rng, player, flags, slot, vardata)
	-- Apply status effects
	for i, enemy in pairs(Isaac.GetRoomEntities()) do
		if enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
			local effect = mod:Random(1, 8)
			local source = EntityRef(player)
			local duration = 6 * 30
			local damage = player.Damage * 1.5

			-- Burn
			if effect == 1 then
				enemy:AddBurn(source, duration, damage)
			-- Charm
			elseif effect == 2 then
				enemy:AddCharmed(source, duration)
			-- Confusion
			elseif effect == 3 then
				enemy:AddConfusion(source, duration, false)
			-- Fear
			elseif effect == 4 then
				enemy:AddFear(source, duration)
			-- Freeze
			elseif effect == 5 then
				enemy:AddFreeze(source, duration)
			-- Poison
			elseif effect == 6 then
				enemy:AddPoison(source, duration, damage)
			-- Shrink
			elseif effect == 7 then
				enemy:AddShrink(source, duration)
			-- Slowing
			elseif effect == 8 then
				local color = Color(2, 2, 2, 1, 0.196, 0.196, 0.196) -- Spider Bite effect color
				enemy:AddSlowing(source, duration, 0.75, color)
			end
		end
	end

	-- Effects
	Game():ShowHallucination(9)
	SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD) -- Play the hallucination sound at a lower volume
	SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 1.35, 0, false, 0.5)

	local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, player.Position, Vector.Zero, player):GetSprite()
	fart:ReplaceSpritesheet(0, "gfx/effects/effect_fart_delirious.png")
	fart:LoadGraphics()

	return {
		Discharge = true,
		Remove    = false,
		ShowAnim  = true,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ElLocoUse, CollectibleType.COLLECTIBLE_EL_LOCO)
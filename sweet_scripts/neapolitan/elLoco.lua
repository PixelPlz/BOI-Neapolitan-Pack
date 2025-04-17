local mod = SweetPack

local descriptionEN = {
	"Warp nearby enemies into weaker enemies, poops or pickups",
	"Applies a random status effect to every enemy in the room",
}
local descriptionRU = {
	"Применяется эффект случайного состояния к каждому врагу в комнате",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_EL_LOCO, descriptionEN, "El Loco", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_EL_LOCO, descriptionRU, "El Loco", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_EL_LOCO, descriptionEN)



mod.ElLocoPickups = {
	{PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF},
	{PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL},
	{PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
	{PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
	{PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
}



function mod:ElLocoUse(id, rng, player, flags, slot, vardata)
	for i, enemy in pairs(Isaac.GetRoomEntities()) do
		if enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
			-- Apply status effects
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


			-- Warp enemies
			if not enemy:IsBoss() and enemy.Position:Distance(player.Position) <= 85 then
				local warpRoll = mod:Random()

				-- Remove completely
				if warpRoll <= 0.11 then
					enemy:Remove()

				-- Reroll
				elseif warpRoll <= 0.33 then
					Game():RerollEnemy(enemy)

				-- Turn into poop
				elseif warpRoll <= 0.66 then
					enemy:Remove()

					local poopVariant = warpRoll <= 0.335 and 1 or 0
					Isaac.Spawn(EntityType.ENTITY_POOP, poopVariant, 0, enemy.Position, enemy.Velocity, player)

				-- Turn into pickups
				else
					enemy:Remove()

					local chosen = mod:Random(1, #mod.ElLocoPickups)
					chosen = mod.ElLocoPickups[chosen]
					Isaac.Spawn(EntityType.ENTITY_PICKUP, chosen[1], chosen[2], enemy.Position, enemy.Velocity, player)
				end

				-- Poof
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, enemy.Position, Vector.Zero, enemy):ToEffect()
				poof:GetSprite().Color = Color(2.5,2.5,2.5, 1, 0,0,0, 1.25,1,1, 1)
			end
		end
	end


	-- Effects
	Game():ShowHallucination(9)
	SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD)
	SFXManager():Play(SoundEffect.SOUND_STATIC, 0.55)

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
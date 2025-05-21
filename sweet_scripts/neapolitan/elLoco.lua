local mod = SweetPack

local descriptionEN = {
	"Warp enemies into poops or pickups within close range",
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
				local warpRoll = mod:Random(1, 1000) -- Divide it by 10 to get the chances :)
				enemy:Remove()

				-- Turn into poop
				if warpRoll <= 300 then
					local poopVariant = warpRoll <= 5 and 1 or 0 -- !!! GOLDEN POOP LOOK IT'S RIGHT HERE !!!
					Isaac.Spawn(EntityType.ENTITY_POOP, poopVariant, 0, enemy.Position, enemy.Velocity, player)

				-- Turn into pickups
				elseif warpRoll <= 700 then
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



-- Wisp farts
function mod:ElLocoWisp(wisp)
	if wisp.SubType == CollectibleType.COLLECTIBLE_EL_LOCO and wisp:HasMortalDamage() then
		local chosen = mod:Random(1, 3)
		local player = wisp.Player
		local radius = 85

		-- Butter Bean fart
		if chosen == 1 then
			Game():ButterBeanFart(wisp.Position, radius, player, true, false)

		-- Kideny Bean fart
		elseif chosen == 2 then
			Game():CharmFart(wisp.Position, radius, player)

		-- Regular fart
		else
			Game():Fart(wisp.Position, radius, player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.ElLocoWisp, FamiliarVariant.WISP)
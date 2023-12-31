local mod = SweetPack

local descriptionEN = {
	"{{Charm}} Charms all enemies in the room",
}
local descriptionRU = {
	"{{Charm}} Очаровавывает всех врагов в комнате",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_DRUM_OF_WAR, descriptionEN, "Drum of War", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_DRUM_OF_WAR, descriptionRU, "Барабан Войны", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_DRUM_OF_WAR, descriptionEN)



function mod:WarDrumUse(id, rng, player, flags, slot, vardata)
	-- Charm all enemies
	for i, enemy in pairs(Isaac.GetRoomEntities()) do
		if enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
			enemy:AddCharmed(EntityRef(player), 10 * 30)
		end
	end

	-- Effects
	Game():ShakeScreen(12)
	SFXManager():Play(SoundEffect.SOUND_MOM_FOOTSTEPS) -- Kinda sounds like drums
	SFXManager():Play(SoundEffect.SOUND_WAR_FIRE_SCREEM, 0.8)

	return {
		Discharge = true,
		Remove    = false,
		ShowAnim  = true,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.WarDrumUse, CollectibleType.COLLECTIBLE_DRUM_OF_WAR)
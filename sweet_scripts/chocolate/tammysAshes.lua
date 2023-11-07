local mod = SweetPack

local descriptionEN = {
	"Spawns 3 purgatory ghosts",
}
local descriptionRU = {
	"Создает 3 призрака чистилища",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_TAMMYS_ASHES, descriptionEN, "Tammy's Ashes", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_TAMMYS_ASHES, descriptionRU, "Прах Тэмми", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_TAMMYS_ASHES, descriptionEN)



function mod:TammysAshesUse(id, rng, player, flags, slot, vardata)
	-- Purgatory ghosts
	for i = 1, 3 do
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, player.Position + mod:RandomVector(30), Vector.Zero, player)
	end

	-- Ashes
	local ashColor = Color(1,1,1, 1)
	ashColor:SetColorize(0.25,0.25,0.25, 1)

	local ashes = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, player.Position, Vector.Zero, player):GetSprite()
	ashes.Color = ashColor
	SFXManager():Stop(SoundEffect.SOUND_FART)

	-- Effects
	Game():ShakeScreen(6)
	SFXManager():Play(SoundEffect.SOUND_POT_BREAK_2, 0.75)
	SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 2)

	return {
		Discharge = true,
		Remove    = false,
		ShowAnim  = true,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TammysAshesUse, CollectibleType.COLLECTIBLE_TAMMYS_ASHES)
local mod = SweetPack

local descriptionEN = {
	"{{Collectible350}} On hit, applies the Toxic Shock effect and spawns 1-2 poison attack flies",
}
local descriptionRU = {
	"{{Collectible350}} При получении урона, вызывает эффект Токсического Шока и создаёт 1-2 ядовитых атакующих мух",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_RAD_ROACH, descriptionEN, "Rad Roach", "en_us")
mod:CreateEID(CollectibleType.COLLECTIBLE_RAD_ROACH, descriptionRU, "Радиактивный Таракан", "ru")
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_RAD_ROACH, descriptionEN)



function mod:RadRoachDMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	local player = entity:ToPlayer()

	if player:HasCollectible(CollectibleType.COLLECTIBLE_RAD_ROACH, false) then
		-- Apply Toxic Shock effect (this is dumb but there is no other way to apply the haze effect)
		player:AddCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, 0, false, 0, 0)
		player:RemoveCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, true, 0, true)

		-- Spawn poison flies
		local itemCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_RAD_ROACH, true)
		for i = 1, mod:Random(itemCount, itemCount * 2) do
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 2, player.Position, Vector.Zero, player):ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end

		SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 1.1)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.RadRoachDMG, EntityType.ENTITY_PLAYER)
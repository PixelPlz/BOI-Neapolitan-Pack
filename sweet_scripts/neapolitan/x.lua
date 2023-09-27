local mod = SweetPack

local description = {
	"",
}
mod:CreateEID(CollectibleType.COLLECTIBLE_X, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_X, description)



-- Get a random color
function mod:GetFunkyColor()
	local color = Color(math.random(),math.random(),math.random(), 1, math.random() / 2,math.random() / 2,math.random() / 2)
	color:SetColorize(math.random(),math.random(),math.random(), math.random())
	color:SetTint(math.random(),math.random(),math.random(), 1)
	return color
end



function mod:XNewRoom()
	if mod:DoesAnyoneHaveItem(CollectibleType.COLLECTIBLE_X) then
		local room = Game():GetRoom()

		-- Give a random item, reroll the other ones
		if not room:IsClear() then
			for i = 0, Game():GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(i)

				-- Reroll stats + items
				player:UseActiveItem(CollectibleType.COLLECTIBLE_D4, UseFlag.USE_NOANIM | UseFlag.USE_REMOVEACTIVE, -1, 0)
				player:UseActiveItem(CollectibleType.COLLECTIBLE_D8, UseFlag.USE_NOANIM, -1, 0)

				-- Gain an item every 2 rooms
				local data = player:GetData()

				if not data.XRoomsCleared or data.XRoomsCleared >= 1 then
					data.XRoomsCleared = 0

					local pool = math.random(0, ItemPoolType.NUM_ITEMPOOLS - 1)
					local item = Game():GetItemPool():GetCollectible(pool, false, room:GetDecorationSeed(), CollectibleType.COLLECTIBLE_NULL)
					player:AddCollectible(item, 100, true, 0, 0)

				else
					data.XRoomsCleared = data.XRoomsCleared + 1
				end
			end
		end


		-- Reroll obstacles
		Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D12, UseFlag.USE_NOANIM, -1, 0)

		-- Randomize color for obstacles
		for grindex = 0, room:GetGridSize() - 1 do
			if room:GetGridEntity(grindex) ~= nil then
				local sprite = room:GetGridEntity(grindex):GetSprite()
				sprite.Color = mod:GetFunkyColor()
			end
		end


		-- Reroll all enemies
		for i, enemy in pairs(Isaac.GetRoomEntities()) do
			if enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
				-- Chance to replace bosses with Skinless Hush
				if enemy:IsBoss() and math.random(1, 20) == 1 then
					enemy:ToNPC():Morph(408, 0, 0, -1)

				else
					Game():RerollEnemy(enemy)
				end
			end
		end

		-- Reroll items and pickups
		Game():RerollLevelCollectibles()
		Game():RerollLevelPickups(room:GetDecorationSeed())


		-- Reroll backdrop
		Game():ShowHallucination(0)
		SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD)

	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.XNewRoom)



-- Random enemy HP, scale and color
function mod:XEnemy(entity)
	if mod:DoesAnyoneHaveItem(CollectibleType.COLLECTIBLE_X) then
		-- Random HP
		local stageMulti = math.ceil(Game():GetLevel():GetAbsoluteStage() / 2)
		local multi = math.random(1, stageMulti * 100) / 100
		entity.MaxHitPoints = entity.MaxHitPoints * multi

		-- Prevent Gideon from softlocking
		if entity.Type == EntityType.ENTITY_GIDEON then
			entity.MaxHitPoints = math.ceil(entity.MaxHitPoints)
		end

		entity.HitPoints = entity.MaxHitPoints

		-- Random scale + sprite stuff
		entity.Scale = math.random(20, 200) / 100
		entity:SetColor(mod:GetFunkyColor(), -1, 0, false, true)
		entity:GetSprite().Rotation = math.random(0, 359)
		entity:GetSprite().PlaybackSpeed = math.random(50, 200) / 100
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_INIT, CallbackPriority.LATE, mod.XEnemy)



-- Random projectile flags
function mod:XProjectileInit(projectile)
	if mod:DoesAnyoneHaveItem(CollectibleType.COLLECTIBLE_X) then
		projectile:AddProjectileFlags(1<<math.random(0, 57))
		projectile:AddChangeFlags(1<<math.random(0, 57))
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.XProjectileInit)



-- Random color, rotation and speed for every entity
function mod:XGenericSpriteRandomizer(entity)
	if mod:DoesAnyoneHaveItem(CollectibleType.COLLECTIBLE_X) then
		if ((entity.Type == EntityType.ENTITY_PROJECTILE or entity.Type == EntityType.ENTITY_EFFECT) and entity.FrameCount <= 1)
		or entity.FrameCount <= 0 then
			entity:SetColor(mod:GetFunkyColor(), -1, 0, false, true)
			entity:GetSprite().Rotation = math.random(0, 359)
			entity:GetSprite().PlaybackSpeed = math.random(50, 200) / 100
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.XGenericSpriteRandomizer)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.XGenericSpriteRandomizer)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.XGenericSpriteRandomizer)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.XGenericSpriteRandomizer)



-- Sound randomizer
function mod:XSoundRandomizer()
	if mod:DoesAnyoneHaveItem(CollectibleType.COLLECTIBLE_X) then
		for i = 1, 10 do
			local chosenSound = math.random(1, SoundEffect.NUM_SOUND_EFFECTS - 1)

			if SFXManager():IsPlaying(chosenSound) then
				SFXManager():Stop(chosenSound)
				local newSound = math.random(1, SoundEffect.NUM_SOUND_EFFECTS - 1)
				local pitch = 1 + math.random(-50, 50) / 100
				SFXManager():Play(newSound, 1, 0, false, pitch)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.XSoundRandomizer)
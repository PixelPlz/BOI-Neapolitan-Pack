local mod = SweetPack

local description = {
	"Teleports you to the boss room after starting a new floor",
    "Will not activate in Depths II, Blue Womb, Void, the Ascent or Home",
    "Bosses will drop an additional heart when defeated"
}
mod:CreateEID(CollectibleType.COLLECTIBLE_CURSE_OF_THE_EMPEROR, description)
mod:CreateEncylopedie(CollectibleType.COLLECTIBLE_CURSE_OF_THE_EMPEROR, description)



function mod:EmperorCurseNewFloor()
    local level = Game():GetLevel()
    local stage = level:GetAbsoluteStage()

    if mod:DoesAnyoneHaveItem(CollectibleType.COLLECTIBLE_CURSE_OF_THE_EMPEROR)
    and not (stage == LevelStage.STAGE3_1 and (level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0)) -- Not in Depths XL
    and stage ~= LevelStage.STAGE3_2 -- Not in Depths II
    and stage ~= LevelStage.STAGE4_3 -- Not in the Blue Womb
    and stage ~= LevelStage.STAGE7 -- Not in the Void
    and stage ~= LevelStage.STAGE8 -- Not in Home
    and not level:IsAscent() then -- Not in the Ascent
        Isaac.GetPlayer(0):GetData().EmperorCurseTimer = 30
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.EmperorCurseNewFloor)

function mod:EmperorCurseTimer(player)
    local data = player:GetData()

    if data.EmperorCurseTimer and player:AreControlsEnabled() then
        -- Teleport
        if data.EmperorCurseTimer <= 0 then
            player:UseCard(Card.CARD_EMPEROR, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            data.EmperorCurseTimer = nil

        else
            data.EmperorCurseTimer = data.EmperorCurseTimer - 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.EmperorCurseTimer)



-- Make bosses always drop an extra heart
function mod:EmperorCurseBossDeath(entity)
	if mod:DoesAnyoneHaveItem(CollectibleType.COLLECTIBLE_CURSE_OF_THE_EMPEROR)
    and entity:IsBoss() and Game():GetRoom():GetAliveBossesCount() == 1 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, entity.Position, mod:RandomVector(mod:Random(4, 6)), entity)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.EmperorCurseBossDeath)
local mod = SweetPack



--[[ Utility functions ]]--
-- Replaces math.random 
function mod:Random(min, max, rng)
	rng = rng or mod.RNG

	-- Float
	if not min and not max then
		return rng:RandomFloat()

	-- Integer
	elseif min and not max then
		return rng:RandomInt(min + 1)

	-- Range
	else
		local difference = math.abs(min)

		-- For ranges with negative numbers
		if min < 0 then
			max = max + difference
			return rng:RandomInt(max + 1) - difference
		-- For positive only
		else
			max = max - difference
			return rng:RandomInt(max + 1) + difference
		end
	end
end


-- Get a vector with a random angle
function mod:RandomVector(length)
	local vector = Vector.FromAngle(mod:Random(359))
	if length then
		vector = vector:Resized(length)
	end
	return vector
end



--[[ Item functions ]]--
-- Check if any players have the specified item
function mod:DoesAnyoneHaveItem(id, onlyRealItem)
	for i = 0, Game():GetNumPlayers() - 1 do
		if Isaac.GetPlayer(i):HasCollectible(id, onlyRealItem) then
			return true
		end
	end
	return false
end


-- Create EID entry
function mod:CreateEID(id, description, name, language)
	if EID then
		local combinedDescription

		-- Create the description
		for i, line in pairs(description) do
			if i == 1 then
				combinedDescription = line
			else
				combinedDescription = combinedDescription .. "#" .. line
			end
		end

		EID:addCollectible(id, combinedDescription, name, language)
	end
end

-- Create Encyclopedia entry
function mod:CreateEncylopedie(id, description)
	if Encyclopedia then
		local EncyclopediaEntry = {
			{ -- Effect
				{str = "Effect", fsize = 3, clr = 3, halign = 0},
			},
		}

		-- Create the description
		for i, line in pairs(description) do
			-- Doesn't show up properly in the Encyclopedia
			local text = line:gsub('{{.*}}', "")
			text = text:gsub("↑ ", "")
			text = text:gsub("↓ ", "")

			text = {str = text}
			table.insert(EncyclopediaEntry[1], text)
		end

		Encyclopedia.AddItem({
			ID = id,
			WikiDesc = EncyclopediaEntry,
		})
	end
end
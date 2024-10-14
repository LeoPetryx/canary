local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_MELEEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DRAWBLOOD)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	if tile then
		local target = tile:getTopCreature()
		if target and target ~= cid then
			targetName = target:getName():lower()
			casterName = cid:getName():lower()
			if table.contains(monsters, targetName) and casterName ~= targetName then
				target:addHealth(-target:getMaxHealth())
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("zombiespell")
spell:words("###864654")
spell:needLearn(true)
spell:needDirection(true)
spell:cooldown("1000")
spell:isSelfTarget(false)
spell:register()

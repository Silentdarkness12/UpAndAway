--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local prefabs = 
{
	--"cloud_jelly",
}

local function OnHit(inst, owner, target)
	local pt = Vector3(inst.Transform:GetWorldPosition())
	inst:Remove()
end	

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    anim:SetBank("crow")
    anim:SetBuild("crow_build")
    anim:PlayAnimation("idle")
        
    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbird")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(30)
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    --inst.components.lootdropper:AddChanceLoot("jellyegg")
    
        
    local brain = require "brains/beebrain"
    inst:SetBrain(brain)    

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	
	--Mantas will sail overhead. I think the only way to attack one would be to use a ranged weapon. 
	--If attacked, they will go offscreen and come back lower, to sail past the player.
		
	return inst
end

return Prefab ("common/monsters/manta", fn, assets) 
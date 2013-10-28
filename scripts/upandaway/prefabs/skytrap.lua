--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/eyeplant.zip"),
}

local prefabs =
{
	""
}

local function retargetfn(inst)
    return FindEntity(inst, TUNING.EYEPLANT_ATTACK_DIST, function(guy) 
        if guy.components.combat and guy.components.health and not guy.components.health:IsDead() then
            return (guy:HasTag("character") or guy:HasTag("monster") or guy:HasTag("animal") or guy:HasTag("prey") or guy:HasTag("eyeplant") or guy:HasTag("lureplant")) and not checkmaster(guy, inst)
        end
    end)
end

local function shouldKeepTarget(inst, target)
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        local distsq = target:GetDistanceSqToInst(inst)
        
        return distsq < TUNING.EYEPLANT_STOPATTACK_DIST*TUNING.EYEPLANT_STOPATTACK_DIST
    else
        return false
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("eyeplant")
    inst.AnimState:SetBuild("eyeplant")
    inst.AnimState:PlayAnimation("spawn")
    inst.AnimState:PushAnimation("idle")

	inst:AddComponent("inspectable")	

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.EYEPLANT_ATTACK_PERIOD)
    inst.components.combat:SetRange(6)
    inst.components.combat:SetRetargetFunction(0.2, retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.components.combat:SetDefaultDamage(10)	

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(30)    

	return inst
end

return Prefab ("common/inventory/skytrap", fn, assets) 

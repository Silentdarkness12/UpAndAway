BindGlobal()

local assets = {
	Asset("ANIM", "anim/axe.zip"),
	Asset("ANIM", "anim/wind_axe.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_wind_axe.zip"),	

    Asset( "ATLAS", "images/inventoryimages/wind_axe.xml" ),
    Asset( "IMAGE", "images/inventoryimages/wind_axe.tex" ),
}

local prefabs = {
    "whirlwind",
    "lightning",
}

local function onattackfn(inst, owner, target)
    local outcome = math.random(1,3)
    local lightning = SpawnPrefab("lightning")
    local whirlwind = SpawnPrefab("whirlwind")
    local target_pt = target:GetPosition()
    local owner_pt = owner:GetPosition()
    if outcome == 1 then
        lightning.Transform:SetPosition(target_pt.x, target_pt.y, target_pt.z)
    elseif outcome == 2 then
        lightning.Transform:SetPosition(owner_pt.x, owner_pt.y, owner_pt.z)
        if IsDLCEnabled(REIGN_OF_GIANTS) then
            local headinsulator = GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            local bodyinsulator = GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            local insulator = headinsulator or bodyinsulator
            if insulator and insulator.components.insulator then
                owner.components.health:DoDelta(-10)
            else owner.components.health:DoDelta(-30) end
        else owner.components.health:DoDelta(-30) end
    elseif outcome == 3 then
        if math.random(1,4) == 4 then
            whirlwind.Transform:SetPosition(target_pt.x, target_pt.y, target_pt.z)
        end
    end
end

local function onfinishedfn(inst)
    inst:Remove()
end

local function onequipfn(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_wind_axe", "swap_axe")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequipfn(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function fn(inst)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    MakeInventoryPhysics(inst)
  
    anim:SetBank("axe")
    anim:SetBuild("wind_axe")
    anim:PlayAnimation("idle")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(60)
    inst.components.weapon:SetOnAttack(onattackfn)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP)

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wind_axe.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(20)
    inst.components.finiteuses:SetUses(20)
    inst.components.finiteuses:SetOnFinished(onfinishedfn)
    --inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequipfn)
    
    inst.components.equippable:SetOnUnequip(onunequipfn)

	return inst
end

return Prefab("cloudrealm/inventory/wind_axe", fn, assets, prefabs)
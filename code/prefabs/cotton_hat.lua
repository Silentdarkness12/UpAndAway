BindGlobal()

local assets=
{
	Asset("ANIM", "anim/cotton_hat.zip"),
    Asset("ANIM", "anim/hat_miner_off.zip"),
}


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "cotton_hat", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
        
    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAIR")
    end
        
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
    end

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
end

local function onperish(inst)
	inst:Remove()
end

local function fn(Sim)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("strawhat")
        inst.AnimState:SetBuild("cotton_hat")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/cotton_hat.xml"

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

        inst.components.equippable:SetOnEquip( onequip )

        inst.components.equippable:SetOnUnequip( onunequip )

        return inst
end

return Prefab ("common/inventory/cotton_hat", fn, assets) 

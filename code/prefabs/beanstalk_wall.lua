BindGlobal()

require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/wall.zip"),
	Asset("ANIM", "anim/beanstalk_wall.zip"),

    Asset( "ATLAS", "images/inventoryimages/beanstalk_wall_item.xml" ),
    Asset( "IMAGE", "images/inventoryimages/beanstalk_wall_item.tex" ),
}

local prefabs =
{
	"beanstalk_chunk",
	"beanstalk_wall_item",
}

local stage0loot = {
}

local stage1loot = {
	"beanstalk_chunk",
}	

local stage2loot = {
	"beanstalk_chunk",		
}	

local stage3loot = {
	"beanstalk_chunk",
}	

local stage4loot = {
	"beanstalk_chunk",
	"beanstalk_chunk",
		
}

local stage4loot = {
	"beanstalk_chunk",
	"beanstalk_chunk",
	"beanstalk_chunk",
	"beanstalk_chunk",			
}		

local maxloots = 4
local maxhealth = 20

local function makeobstacle(inst)
		
	inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)	
	inst.Physics:ClearCollisionMask()
	inst.Physics:SetMass(0)
	inst.Physics:CollidesWith(COLLISION.ITEMS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	inst.Physics:SetActive(true)
	local ground = GetWorld()
	if ground then
	    local pt = Point(inst.Transform:GetWorldPosition())
	    ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
	end
end

local function clearobstacle(inst)
	--inst:DoTaskInTime(2*FRAMES, function() inst.Physics:SetActive(false) end)
	inst.Physics:SetActive(false)

	local ground = GetWorld()
	if ground then
	    local pt = Point(inst.Transform:GetWorldPosition())
	    ground.Pathfinder:RemoveWall(pt.x, pt.y, pt.z)
	end
end

local function onchopped(inst, worker)
	local debris = SpawnPrefab("collapse_small")
	debris.AnimState:SetMultColour(0,50,0,1)
	debris.Transform:SetPosition(inst.Transform:GetWorldPosition())

	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")	

	inst.components.lootdropper:DropLoot()	
		
	inst:Remove()
end

local function onhit(inst)
	local healthpercent = inst.components.health:GetPercent()
	if healthpercent == 1 then
		inst.AnimState:PlayAnimation("1_hit")		
		inst.AnimState:PushAnimation("1")	
		inst.components.growable:SetStage(5)
	elseif healthpercent == .75 then
		inst.AnimState:PlayAnimation("3_4_hit")		
		inst.AnimState:PushAnimation("3_4")	
		inst.components.growable:SetStage(4)
	elseif healthpercent == .5 then
		inst.AnimState:PlayAnimation("1_2_hit")		
		inst.AnimState:PushAnimation("1")
		inst.components.growable:SetStage(3)	
	elseif healthpercent == .25 then
		inst.AnimState:PlayAnimation("1_4_hit")		
		inst.AnimState:PushAnimation("1")	
		inst.components.growable:SetStage(2)
	elseif healthpercent == 0 then
		--inst.AnimState:PlayAnimation("0_hit")		
		inst.AnimState:PushAnimation("0")
		inst.components.growable:SetStage(1)				
	end	
end

local function SetSapling(inst)
	inst.components.lootdropper:SetLoot(stage0loot)
	if inst.components.workable then
		inst:RemoveComponent("workable")
	end	
	clearobstacle(inst)
	inst.AnimState:PlayAnimation("0")
	print("set1")
end

local function GrowSapling(inst)
    inst.AnimState:PlayAnimation("0")
    clearobstacle(inst)
    inst.components.health.currenthealth = 0
end

local function SetShort(inst)
	if not inst.components.workable then
		inst:AddComponent("workable")
	end	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnFinishCallback(onchopped)
	if inst.components.workable then
	    inst.components.workable:SetWorkLeft(1)
	end

	inst.components.lootdropper:SetLoot(stage1loot)
	clearobstacle(inst)
	inst.AnimState:PlayAnimation("1_4")
	print("set2")
end

local function GrowShort(inst)
    inst.AnimState:PlayAnimation("1_4")
    clearobstacle(inst)
    inst.components.health.currenthealth = maxhealth / 4
end

local function SetNormal(inst)
	if not inst.components.workable then
		inst:AddComponent("workable")
	end	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnFinishCallback(onchopped)	
	if inst.components.workable then
	    inst.components.workable:SetWorkLeft(2)
	end

	inst.components.lootdropper:SetLoot(stage2loot)
	clearobstacle(inst)
	inst.AnimState:PlayAnimation("1_2")
	print("set3")
end

local function GrowNormal(inst)
    inst.AnimState:PlayAnimation("1_2")
    clearobstacle(inst)
    inst.components.health.currenthealth = maxhealth / 2
end

local function SetTall(inst)
	if not inst.components.workable then
		inst:AddComponent("workable")
	end	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnFinishCallback(onchopped)
	if inst.components.workable then
	    inst.components.workable:SetWorkLeft(3)
	end

	inst.components.lootdropper:SetLoot(stage3loot)
	makeobstacle(inst)
	inst.AnimState:PlayAnimation("3_4")
	print("set4")
end

local function GrowTall(inst)
    inst.AnimState:PlayAnimation("3_4")
    makeobstacle(inst)
    inst.components.health.currenthealth = maxhealth - (maxhealth / 4)
end

local function SetOld(inst)
	if not inst.components.workable then
		inst:AddComponent("workable")
	end	
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnFinishCallback(onchopped)
	if inst.components.workable then
	    inst.components.workable:SetWorkLeft(4)
	end

	inst.components.lootdropper:SetLoot(stage4loot)
	makeobstacle(inst)
	inst.AnimState:PlayAnimation("1")
	print("set5")
end

local function GrowOld(inst)
    inst.AnimState:PlayAnimation("1")
    makeobstacle(inst)
    inst.components.health.currenthealth = maxhealth
end

local growth_stages =
{
	{name="sapling", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base, TUNING.EVERGREEN_GROW_TIME[1].random) end, fn = function(inst) SetSapling(inst) end,  growfn = function(inst) GrowSapling(inst) end},
    {name="short", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base, TUNING.EVERGREEN_GROW_TIME[1].random) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end},
    {name="normal", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base, TUNING.EVERGREEN_GROW_TIME[2].random) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end},
    {name="tall", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base, TUNING.EVERGREEN_GROW_TIME[3].random) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end},
    {name="old", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[4].base, TUNING.EVERGREEN_GROW_TIME[4].random) end, fn = function(inst) SetOld(inst) end, growfn = function(inst) GrowOld(inst) end},
}

local function ondeploywall(inst, pt, deployer)
	local wall = SpawnPrefab("beanstalk_wall") 
	if wall then 
		pt = Vector3(math.floor(pt.x)+.5, 0, math.floor(pt.z)+.5)
		wall.Physics:SetCollides(false)
		wall.Physics:Teleport(pt.x, pt.y, pt.z) 
		wall.Physics:SetCollides(true)
		inst.components.stackable:Get():Remove()

		local ground = GetWorld()
		if ground then
		    ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
		end
	end 		
end

local function test_wall(inst, pt)
	local tiletype = GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GROUND.IMPASSABLE 
		
	if ground_OK then
		local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 2, nil, {"NOBLOCK", "player", "FX", "INLIMBO", "DECOR"}) -- or we could include a flag to the search?

		for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				local dsq = distsq( Vector3(v.Transform:GetWorldPosition()), pt)
				if v:HasTag("wall") then
					if dsq < .1 then return false end
				else
					if  dsq< 1 then return false end
				end
			end
		end
			
		return true

	end
	return false
		
end

local function onsave(inst, data)
	--data.stage = inst.components.growable.stage
end

local function onload(inst, data)
	print("Stage should be" .. inst.components.growable.stage)
	if inst.components.growable.stage >= 4 then
		makeobstacle(inst)
	else
		clearobstacle(inst)
	end
end

local function onremoveentity(inst)
	clearobstacle(inst)
end

local function itemfn(inst)

	local inst = CreateEntity()
	inst:AddTag("wallbuilder")
		
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	    
	inst.AnimState:SetBank("beanstalk_wall")
	inst.AnimState:SetBuild("beanstalk_wall")
	inst.AnimState:PlayAnimation("0")
	inst.Transform:SetScale(1.6,1.6,1.6)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/beanstalk_wall_item.xml"
	    	
	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)
			
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
		
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploywall
	inst.components.deployable.test = test_wall
	inst.components.deployable.min_spacing = 0
	inst.components.deployable.placer = "beanstalk_wall_placer"
		
	return inst
end

local function fn(inst)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst:AddTag("wall")
	MakeObstaclePhysics(inst, .5)    
	inst.entity:SetCanSleep(false)
	anim:SetBank("beanstalk_wall")
	anim:SetBuild("beanstalk_wall")
	--inst.Transform:SetScale(3,3,3)
	    
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(stage0loot)
		
	inst:AddComponent("combat")
	inst.components.combat.onhitfn = onhit
		
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(maxhealth)
	inst.components.health.currenthealth = 0
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	inst:AddTag("noauradamage")

	inst:AddComponent("repairable")
	--inst.components.repairable.announcecanfix = false
		
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	inst.components.burnable.flammability = 1

	inst.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")		

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(1)
    inst.components.growable.loopstages = false
    inst.components.growable:StartGrowing()
						
	inst.OnLoad = onload
	inst.OnSave = onsave
	inst.OnRemoveEntity = onremoveentity

	return inst
end

return {
	Prefab ("common/inventory/beanstalk_wall", fn, assets, prefabs),
	Prefab ("common/inventoryitem/beanstalk_wall_item", itemfn, assets, prefabs),
	MakePlacer("common/beanstalk_wall_placer", "beanstalk_wall", "beanstalk_wall", "0", false, false, true),
}
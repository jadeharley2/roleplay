
function SpawnMoney(amount,ent,pos)
	local e = ents.Create("rp_money")
	e:SetAmount(amount)
	e:SetSizepower(1)
	e:SetParent(ent)
	e:SetPos(pos) 
	e:Spawn()
	return e
end
--lua_run SpawnMoney(100,TACTOR:GetParent(),TACTOR:GetPos())
ENT.title = "Cash"

function ENT:Init()  
	local phys = self:AddComponent(CTYPE_PHYSOBJ)  
	local model = self:AddComponent(CTYPE_MODEL)  
	self.model = model
	self.phys = phys
	self:SetSpaceEnabled(false)
	self:AddFlag(FLAG_PHYSSIMULATED)
	
	self:AddFlag(FLAG_STOREABLE)
	--phys:SetMass(10)  
	
end
function ENT:LoadModel() 
	local model_scale = self:GetParameter(VARTYPE_MODELSCALE) or 1
	
	local model = self.model
	local world = matrix.Scaling(model_scale)-- * matrix.Rotation(-90,0,0)
	 
	local phys =  self.phys
	local amul = 0.8
	
	
	model:SetRenderGroup(RENDERGROUP_LOCAL)
	model:SetModel("money/m1.json")--self:GetParameter(VARTYPE_MODEL)) 
	model:SetBlendMode(BLEND_OPAQUE) 
	model:SetRasterizerMode(RASTER_DETPHSOLID) 
	model:SetDepthStencillMode(DEPTH_ENABLED)  
	model:SetBrightness(1)
	model:SetFadeBounds(0,99999,0)  
	
	
	if(model:HasCollision()) then
		phys:SetShapeFromModel(world * matrix.Scaling(1/amul) ) 
	else
		phys:SetShape(mdl,world * matrix.Scaling(1/amul) ) 
	end
	
	phys:SetMass(10) 
	
	model:SetMatrix( world* matrix.Translation(-phys:GetMassCenter()*amul ))
	
end
function ENT:Load()
	self:LoadModel() 
	self:SetPos(self:GetPos()) 
end
function ENT:Spawn() 
	self:LoadModel() 
end 

function ENT:SetAmount(val) 
	self:SetParameter(VARTYPE_AMOUNT,val)
	self.info = val.."$"
end 

function ENT:Stack(other)
	local am = other:GetParameter(VARTYPE_AMOUNT) or 0
	local slf = self:GetParameter(VARTYPE_AMOUNT) or 0
	self:SetAmount(am+slf)
	other:Despawn()
	return true
end


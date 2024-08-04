HLT.playerWalkSpeed = 100
HLT.playerRunSpeed = 200
HLT.playerSlowWalkSpeed = 80
HLT.playerSlowRunSpeed = 160
HLT.playerViewOffsetDuckedValue = Vector(0,0,48) 

function pMeta:setJustSpawned(bool)
    self:SetNWBool('justSpawned', bool )
end

function pMeta:justSpawned()
	return self:GetNWBool('justSpawned', false)
end

function pMeta:setIsNoClipping(bool)
    self:SetNWBool('isNoClipping', bool )
end

function pMeta:isNoClipping()
	return self:GetNWBool('isNoClipping', false)
end

function pMeta:setPlyHasFlashLightEnabled(bool)
    self:SetNWBool('plyHasFlashLightEnabled', bool )
end

function pMeta:hasFlashLightEnabled()
	return self:GetNWBool('plyHasFlashLightEnabled', false)
end

function pMeta:setStamina(float)
	self:SetNWFloat('stamina', float)
end

function pMeta:getStamina(float)
	return self:GetNWFloat('stamina', 100)
end

function pMeta:setMaxStamina(float)
	self:SetNWFloat('maxStamina', float)
end

function pMeta:getMaxStamina(float)
	return self:GetNWFloat('maxStamina', 100)
end

function pMeta:setIsHolstered(bool)
	self:SetNWBool('isHolstered', bool )
end

function pMeta:isHolstered()
	return self:GetNWBool('isHolstered', false)
end

function pMeta:setIsReloading(bool)
	self:SetNWBool('isReloading', bool )
end

function pMeta:isReloading()
	return self:GetNWBool('isReloading', false)
end

function pMeta:setIsAiming(bool)
	self:SetNWBool('isAiming', bool )
end
function pMeta:isAiming()
	return self:GetNWBool('isAiming', false)
end

function pMeta:setJustLandedJump(bool)
	self:SetNWBool('justLandedJump', bool )
end

function pMeta:getJustLandedJump()
	return self:GetNWBool('justLandedJump', false)
end

function pMeta:setLastTimeLandedOnGround(float)
	self:SetNWFloat('lastTimeLandedOnGround', float)
end

function pMeta:getLastTimeLandedOnGround(float)
	return self:GetNWFloat('lastTimeLandedOnGround', 0)
end

function pMeta:setLastTimeJumped(float)
	self:SetNWFloat('lastTimeJumped', float)
end

function pMeta:getLastTimeJumped(float)
	return self:GetNWFloat('lastTimeJumped', 0)
end

function pMeta:setIsHoldingBreath(bool)
	self:SetNWBool('isHoldingBreath', bool )
end

function pMeta:isHoldingBreath()
	return self:GetNWBool('isHoldingBreath', false)
end



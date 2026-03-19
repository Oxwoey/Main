local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local SilentAim = {}
SilentAim.__index = SilentAim

SilentAim.new = function()
    local self = setmetatable({}, SilentAim)
    
    self.Enabled = false
    self.Distance = 30
    self.Hitboxes = {"Head", "Torso", "Left Leg", "Right Leg"}
    
    self._Hooked = false
    self._OriginalRaycast = nil
    
    return self
end

SilentAim.GetClosestPlayer = function(self)
    local target = nil
    local mag = math.huge
    
    local char = LocalPlayer.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then 
        return nil 
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChild("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local _, onScreen = Camera:WorldToScreenPoint(root.Position)
                
                if onScreen then
                    local d = (char.HumanoidRootPart.Position - root.Position).Magnitude
                    if d < mag and d <= self.Distance then
                        target = p
                        mag = d
                    end
                end
            end
        end
    end
    
    return target
end

SilentAim.Init = function(self)
    if self._Hooked then return end
    
    local scripts = LocalPlayer:WaitForChild("PlayerScripts")
    local moduleInstance = scripts:WaitForChild("RaycastModule", 10)
    
    if not moduleInstance then return end
    
    local RaycastModule = require(moduleInstance)
    
    if RaycastModule and RaycastModule.RaycastFromCam then
        self._OriginalRaycast = RaycastModule.RaycastFromCam
        self._Hooked = true
        
        RaycastModule.RaycastFromCam = function(origin, mult)
            if not self.Enabled then
                return self._OriginalRaycast(origin, mult)
            end
            
            local target = self:GetClosestPlayer()
            
            if target and target.Character then
                local part = target.Character:FindFirstChild(self.Hitboxes[math.random(1, #self.Hitboxes)])
                
                if part then
                    local res = {
                        Instance = part,
                        Position = part.Position,
                        Normal = Vector3.new(0, 1, 0),
                        Material = Enum.Material.Plastic
                    }
                    
                    return res, part.CFrame:ToObjectSpace(CFrame.new(res.Position))
                end
            end
            
            return self._OriginalRaycast(origin, mult)
        end
    end
end

return SilentAim.new()

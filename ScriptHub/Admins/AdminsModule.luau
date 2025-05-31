local AdminModule = {}
AdminModule.__index = AdminModule

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local function sayString(str)
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		TextChatService.TextChannels.RBXGeneral:SendAsync(str)
	else
		local sayEvent = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if sayEvent then
			sayEvent.SayMessageRequest:FireServer(str, "All")
		end
	end
end

function AdminModule.Create(owners, prefix)
	local self = setmetatable({}, AdminModule)
	self.Owners = owners or {}
	self.Prefix = prefix or ";"
	self.Commands = {}
	return self
end

function AdminModule:IsAdmin(userId)
	for _, id in ipairs(self.Owners) do
		if id == userId then
			return true
		end
	end
	return false
end

function AdminModule:GetTargets(sender, targetArg)
	local targets = {}
	targetArg = (targetArg or ""):lower()

	if targetArg == "all" then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= sender then
				table.insert(targets, player)
			end
		end
	else
		local target = Players:FindFirstChild(targetArg)
		if target then
			table.insert(targets, target)
		end
	end
	return targets
end

function AdminModule:RegisterDefaultCommands()
	self.Commands.kick = function(sender, targets)
		for _, target in ipairs(targets) do
			target:Kick("Kicked by " .. sender.Name)
		end
	end

	self.Commands.reveal = function(sender, _)
		sayString("I'm")
	end

	self.Commands.bring = function(sender, targets)
		local sHRP = sender.Character and sender.Character:FindFirstChild("HumanoidRootPart")
		if not sHRP then return end
		for _, target in ipairs(targets) do
			local tHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
			if tHRP then
				sHRP.CFrame = tHRP.CFrame + tHRP.CFrame.LookVector * 3
			end
		end
	end
end

function AdminModule:HookPlayer(player)
	player.Chatted:Connect(function(msg)
		if not self:IsAdmin(player.UserId) then return end
		if msg:sub(1, 1) ~= self.Prefix then return end

		local args = msg:sub(2):split(" ")
		local cmd = args[1]:lower()
		local targetArg = args[2]
		local targets = self:GetTargets(player, targetArg)

		local action = self.Commands[cmd]
		if action then
			action(player, targets)
		end
	end)
end

function AdminModule:Enable()
	self:RegisterDefaultCommands()
	for _, player in ipairs(Players:GetPlayers()) do
		self:HookPlayer(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:HookPlayer(player)
	end)
end

return AdminModule

-- КОРОЧ РЕБЯТА ЗНАЮ САМ ТУТ ПОЛ ВЕЩЕЙ МОГУТ БЫТЬ БАГАННЫЕ Я ПОФИКШУ
-- JUST BETA
-- made by crysorune

local AdminModule = {}
AdminModule.__index = AdminModule

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local IsLoopKill = false

type Player = Player
type CommandFunction = (Player, { Player }) -> ()

local function sayString(str: string)
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		TextChatService.TextChannels.RBXGeneral:SendAsync(str)
	else
		local sayEvent = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if sayEvent and sayEvent:IsA("Folder") then
			local sayMessageRequest = sayEvent:FindFirstChild("SayMessageRequest")
			if sayMessageRequest and sayMessageRequest:IsA("RemoteEvent") then
				sayMessageRequest:FireServer(str, "All")
			end
		end
	end
end

type AdminModuleType = {
	Owners: { number },
	Prefix: string,
	Commands: { [string]: CommandFunction },

	IsAdmin: (self: AdminModuleType, userId: number) -> boolean,
	GetTargets: (self: AdminModuleType, sender: Player, targetArg: string?) -> { Player },
	RegisterDefaultCommands: (self: AdminModuleType) -> (),
	HookPlayer: (self: AdminModuleType, player: Player) -> (),
	Enable: (self: AdminModuleType) -> ()
}

function AdminModule.Create(owners: { number }?, prefix: string?): AdminModuleType
	local self = setmetatable({}, AdminModule) :: AdminModuleType
	self.Owners = owners or {}
	self.Prefix = prefix or ";"
	self.Commands = {}
	return self
end

function AdminModule:IsAdmin(userId: number): boolean
	for _, id in ipairs(self.Owners) do
		if id == userId then
			return true
		end
	end
	return false
end

function AdminModule:GetTargets(sender: Player, targetArg: string?): { Player }
	local targets = {}
	local arg = (targetArg or ""):lower()

	if arg == "all" then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= sender then
				table.insert(targets, player)
			end
		end
	else
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= sender and (
				player.Name:lower():find(arg, 1, true) or
				player.DisplayName:lower():find(arg, 1, true)
			) then
				table.insert(targets, player)
			end
		end
	end
	return targets
end

function AdminModule:RegisterDefaultCommands()
	self.Commands.AddTestCommans = function(sender: Player, targets: { Player })
		-- мехинику пишите
        print(sender.Name)
	end

	self.Commands.kick = function(sender: Player, targets: { Player })
		for _, target in ipairs(targets) do
			target:Kick("Kicked by " .. sender.Name)
		end
	end

	self.Commands.reveal = function(sender: Player, _: { Player })
		sayString("/w " .. sender.Name .. " I'm")
	end

	self.Commands.bring = function(sender: Player, targets: { Player })
		local root = sender.Character and sender.Character:FindFirstChild("HumanoidRootPart")
		if not root or not root:IsA("BasePart") then return end
		for _, target in ipairs(targets) do
			local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
			if tRoot and tRoot:IsA("BasePart") then
				tRoot.CFrame = root.CFrame
			end
		end
	end

	self.Commands.kill = function(_: Player, targets: { Player })
		for _, target in ipairs(targets) do
			local humanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end
	end

	self.Commands.freeze = function(_: Player, targets: { Player })
		for _, target in ipairs(targets) do
			local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
			if root and root:IsA("BasePart") then
				root.Anchored = true
			end
		end
	end

	self.Commands.unfreeze = function(_: Player, targets: { Player })
		for _, target in ipairs(targets) do
			local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
			if root and root:IsA("BasePart") then
				root.Anchored = false
			end
		end
	end

	self.Commands.loopkill = function(_: Player, targets: { Player })
		IsLoopKill = true
		task.spawn(function()
			while IsLoopKill do
				for _, target in ipairs(targets) do
					local humanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid.Health = 0
					end
				end
				task.wait(1)
			end
		end)
	end

	self.Commands.unloopkill = function(_: Player, _: { Player })
		IsLoopKill = false
	end
end

function AdminModule:HookPlayer(player: Player)
	player.Chatted:Connect(function(msg: string)
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

	Players.PlayerAdded:Connect(function(player: Player)
		self:HookPlayer(player)
	end)
end

return AdminModule

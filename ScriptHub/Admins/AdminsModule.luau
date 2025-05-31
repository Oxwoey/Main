local AdminModule = {}
AdminModule.__index = AdminModule

local ChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local function sayString(str)
	if ChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		ChatService.TextChannels.RBXGeneral:SendAsync(str)
	else
		game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
	end
end

function AdminModule.CreateAdmins(owners, prefix)
	local self = setmetatable({}, AdminModule)
	self.OwnersIds = owners
	self.PrefixChat = prefix or "!"
	return self
end

function AdminModule:AddAdmin(userId)
	table.insert(self.OwnersIds, userId)
end

function AdminModule:RemoveAdmin(userId)
	local index = table.find(self.OwnersIds, userId)
	if index then
		table.remove(self.OwnersIds, index)
	end
end

function AdminModule:IsAdmin(userId)
	return table.find(self.OwnersIds, userId) ~= nil
end

function AdminModule:GetTargets(sender, targetArg)
	local targets = {}

	if not targetArg or targetArg == "" then
		return targets
	end

	targetArg = targetArg:lower()

	if targetArg == "all" then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= sender then
				table.insert(targets, player)
			end
		end
	else
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Name:lower() == targetArg then
				table.insert(targets, player)
			end
		end
	end

	return targets
end

AdminModule.Commands = {
	kick = function(self, sender, targetArg)
		local targets = self:GetTargets(sender, targetArg)
		for _, target in ipairs(targets) do
			target:Kick("Kicked by " .. sender.Name)
		end
	end,

	reveal = function(self, sender, targetArg)
		sayString("I'm admin: " .. sender.Name)
	end,
}

return AdminModule

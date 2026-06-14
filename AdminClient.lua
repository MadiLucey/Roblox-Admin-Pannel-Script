local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("AdminRemote")

player.Chatted:Connect(function(msg)
	-- send all chat messages to server
	-- server will decide if it's valid admin
	remote:FireServer(msg)
end)

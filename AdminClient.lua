local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("AdminRemote")

player.Chatted:Connect(function(msg)
	-- Sends messages to server and decides if it is an admin
	remote:FireServer(msg)
end)

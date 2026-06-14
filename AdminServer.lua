local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:WaitForChild("AdminRemote")

local GAMEPASS_ID = 123456789 -- enter your gamepass id here 

local function isAdmin(player)
	local success, owns = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
	end)

	return success and owns
end

local function getChar(player)
	return player.Character
end

remote.OnServerEvent:Connect(function(player, message)
	if not isAdmin(player) then return end
	if typeof(message) ~= "string" then return end

	local args = string.split(message, " ")
	local cmd = string.lower(args[1] or "")

	local char = getChar(player)
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	-- SPEED
	if cmd == "speed" then
		local value = tonumber(args[2])
		if hum and value then
			hum.WalkSpeed = math.clamp(value, 16, 300)
		end

	-- JUMP
	elseif cmd == "jump" then
		local value = tonumber(args[2])
		if hum and value then
			hum.JumpPower = math.clamp(value, 50, 300)
		end

	-- INVISIBLE
	elseif cmd == "invisible" then
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 1
			elseif v:IsA("Decal") then
				v.Transparency = 1
			end
		end

	elseif cmd == "visible" then
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 0
			elseif v:IsA("Decal") then
				v.Transparency = 0
			end
		end

	-- FLY (simple server-assisted)
	elseif cmd == "fly" then
		if root and not root:FindFirstChild("FlyForce") then
			local bv = Instance.new("BodyVelocity")
			bv.Name = "FlyForce"
			bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
			bv.Velocity = Vector3.new(0, 60, 0)
			bv.Parent = root
		end

	elseif cmd == "unfly" then
		if root then
			local f = root:FindFirstChild("FlyForce")
			if f then f:Destroy() end
		end

	-- BTOOLS (basic)
	elseif cmd == "btools" then
		for _, name in ipairs({"Clone", "Hammer", "Grab"}) do
			local tool = Instance.new("HopperBin")
			tool.BinType = Enum.BinType[name]
			tool.Parent = player.Backpack
		end
	end
end)

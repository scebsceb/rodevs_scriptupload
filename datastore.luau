--// Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

--// DataStores
local PlayerData = DataStoreService:GetDataStore("PlayerData")

--// Variables or Tables
local Template = {
	Cash = 0,
}

--// Functions
local function saveData(player)
	local Data = {
		Cash = player.leaderstats.Cash.Value,
	}
	
	local success, err = pcall(function()
		PlayerData:SetAsync(player.UserId, Data)
	end)
	
	if not success then
		warn("Data can't be saved for player " .. player.Name .. ". Error: " .. err)
	end
end

--// Events
Players.PlayerAdded:Connect(function(player)
	local Data
	
	local success, err = pcall(function()
		Data = PlayerData:GetAsync(player.UserId) or Template
	end)
	
	if not success then
		player:Kick("Your data can't be loaded. Try rejoin.")
		return
	end
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Parent = player
	leaderstats.Name = "leaderstats"
	
	local Cash = Instance.new("IntValue")
	Cash.Parent = leaderstats
	Cash.Name = "Cash"
	Cash.Value = Data.Cash
	
	Cash.Changed:Connect(function()
		if Cash.Value < 0 then
			Cash.Value = 0
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	saveData(player)
end)

game:BindToClose(function()
	for _, player in Players:GetPlayers() do
		saveData(player)
	end
end)

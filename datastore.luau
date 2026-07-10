local DataStoreService = game:GetService("DataStoreService")
local PlayerData = DataStoreService:GetDataStore("PlayerData")

local Players = game:GetService("Players")

local Template = {
	Cash = 0,
}

local function saveData(player)
	local Data = {
		Cash = player.leaderstats.Cash.Value,
	}
	
	local success, err = pcall(function()
		PlayerData:SetAsync(player.UserId, Data)
	end)
	
	if success then
		print(player.Name.." ("..player.DisplayName..") Data saved!")
	end
end

Players.PlayerAdded:Connect(function(player)
	local Data
	
	local success, err = pcall(function()
		Data = PlayerData:GetAsync(player.UserId) or Template
	end)
	
	if not success then
		player:Kick("Your data can't be loaded. Try rejoin.")
		return
	end
	
	print(Data)
	
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	local Cash = Instance.new("IntValue", leaderstats)
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

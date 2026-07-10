--// Services
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages (Modules)
local Packet = require(ReplicatedStorage.Packages.Packet)

--// Objects (Variables)
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local PlayerGui = Player:WaitForChild("PlayerGui")
local Bars = PlayerGui:WaitForChild("Bars")
local Health = Bars:WaitForChild("Health")

--// Threads
local HealthTextThread = nil

--// Gradients Templates
local Gradients = {
	Huge = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 255, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 255, 0)),
	},
	
	Medium = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 0)),
	},
	
	Small = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 0, 0)),
	},
}

Packet("UpdateHealthUI", Packet.Any).OnClientEvent:Connect(function(data)
	if data.Health < 0 then return end
	
	local Bar = Health:FindFirstChild("Bar")
	if not Bar then return end
	
	local HealthLabel = Health:FindFirstChild("HealthLabel")
	
	--// Bar Size, Health Percentage
	local progress = data.Health / data.MaxHealth
	TweenService:Create(Bar, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {Size = UDim2.new(progress, 0, 1, 0)}):Play()

	local percent = math.floor(progress*100)
	
	--// Text Animation
	
	local finalText = "Health: "..percent.."%"
	HealthLabel.Text = ""
	
	if HealthTextThread then
		task.cancel(HealthTextThread)
	end
	
	HealthTextThread = task.spawn(function()
		for i = 1, #finalText do
			HealthLabel.Text = string.sub(finalText, 1, i)
			task.wait(0.04)
		end
		
		HealthTextThread = nil
	end)
	
	--// Bar Stroke
	if data.Health < data.MaxHealth then
		Bar.UIStroke.Enabled = true
	elseif data.Health >= data.MaxHealth then
		Bar.UIStroke.Enabled = false
	end
	
	--// Bar Gradient
	
	if percent >= 100 then
		Bar.UIGradient.Color = Gradients.Huge
	end
	
	if percent <= 50 then
		Bar.UIGradient.Color = Gradients.Medium
	end
	
	if percent <= 25 then
		Bar.UIGradient.Color = Gradients.Small
	end
end)

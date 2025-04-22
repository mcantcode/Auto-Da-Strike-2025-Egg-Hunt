local localPlayer = game:GetService("Players").LocalPlayer
local character = localPlayer and localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

local eggHunt = workspace:FindFirstChild("EggHunt")
local player = eggHunt and eggHunt:FindFirstChild("Player")
local playerHumanoidRootPart = player and player:FindFirstChild("HumanoidRootPart")

if not humanoidRootPart or not playerHumanoidRootPart then
	return
end

local function getEggAmount()
	local eggCount = 0

	for _, v in pairs(eggHunt:GetChildren()) do
		if v:IsA("Part") then
			eggCount = eggCount + 1
		end
	end

	return eggCount
end

if getEggAmount() < 20 then
	local starterGui = game:GetService("StarterGui")

	local function serverHop()
		local placeId = 15186202290

		local success, result = pcall(function()
			return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100")).data
		end)

		if success then
			for _, v in pairs(result) do
				if v.playing < 20 and v.id ~= game.JobId then
					game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, v.id, localPlayer)
				end
			end
		end
	end

	if getgenv()["Auto Server Hop"] then
		starterGui:SetCore("SendNotification", {
			Title = "Warning!",
			Text = "There isn't enough eggs in this server, server hopping.."
		})

		serverHop()

		return
	else
		local bindable = Instance.new("BindableFunction")

		bindable.OnInvoke = function(response)
			if response == "Yes" then
				serverHop()
			end
		end

		starterGui:SetCore("SendNotification", {
			Title = "Warning!",
			Text = "There isn't enough eggs in this server, do you want to server hop?",
			Callback = bindable,
			Button1 = "Yes",
			Button2 = "No"
		})

		return
	end
end

for _, v in pairs(eggHunt:GetChildren()) do
	if v:IsA("Part") then
		humanoidRootPart.CFrame = v.CFrame
		task.wait(0.5)
		game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
		task.wait(0.5)
	end
end

humanoidRootPart.CFrame = playerHumanoidRootPart.CFrame

print("Punchside.lua started")
local ADMINS = { 
	[476432193] = true,
	[9569524] = true
}
local PREFIX = "-"
local BANNED_USERS = {}
local mutedPlayers = {}
local cmds = {}
local connections = {}
local playerData = {}
local visualizers = {}
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
tag = false
--
local replicatedStorage = game:GetService("ReplicatedStorage")
local punchyFolder = replicatedStorage:FindFirstChild("Punchy's folder") or Instance.new("Folder", replicatedStorage)
punchyFolder.Name = "Punchy's folder"
repeat task.wait() until replicatedStorage:FindFirstChild("Punchy's folder")
--[[
if replicatedStorage:FindFirstChild("cxo's folder") and replicatedStorage:FindFirstChild("cxo's folder"):FindFirstChild("OrbScript") then
	local clonedorb = replicatedStorage:FindFirstChild("cxo's folder"):FindFirstChild("OrbScript"):Clone()
	clonedorb.Parent = replicatedStorage:FindFirstChild("Punchy's folder")
else
	require(126332046537913) -- orb script loader
	repeat task.wait() until replicatedStorage:FindFirstChild("OrbScript")
	replicatedStorage.OrbScript.Parent = replicatedStorage:FindFirstChild("Punchy's folder")
end

if replicatedStorage:FindFirstChild("cxo's folder") and replicatedStorage:FindFirstChild("cxo's folder"):FindFirstChild("Crash") then
	local clonedcrash = replicatedStorage:FindFirstChild("cxo's folder"):FindFirstChild("Crash"):Clone()
	clonedcrash.Parent = replicatedStorage:FindFirstChild("Punchy's folder")
else
	require(114690429107613) -- crash script loader
	repeat task.wait() until replicatedStorage:FindFirstChild("Crash")
	replicatedStorage.Crash.Parent = replicatedStorage:FindFirstChild("Punchy's folder")
end--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:FindFirstChild("PunchsideClientEvent") or Instance.new("RemoteEvent")
remote.Name = "PunchsideClientEvent"
remote.Parent = ReplicatedStorage
-- LOAD GOOG (Remote Execution Utilities)

local function runClientCode(player, code)
	if not game:GetService("ServerScriptService"):FindFirstChild("goog") then
		local ticking = tick()
		require(112354705578311).load()
		repeat task.wait() until game:GetService("ServerScriptService"):FindFirstChild("goog") or tick() - ticking > 10
	end

	local goog = game:GetService("ServerScriptService"):FindFirstChild("goog")
	if not goog then
		warn("goog failed to be added, command can not continue")
		return
	end

	local scr = goog:FindFirstChild("Utilities").Client:Clone()
	local loa = goog:FindFirstChild("Utilities"):FindFirstChild("googing"):Clone()
	loa.Parent = scr
	scr:WaitForChild("Exec").Value = code

	if player.Character then
		scr.Parent = player.Character
	else
		scr.Parent = player:WaitForChild("PlayerGui")
	end

	scr.Enabled = true
end


-- Nuke Script by ccuser44 (github/ccuser44/Fast-nuclear-explosion), MIT License
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Constants
local CLOUD_RING_MESH_ID = "rbxassetid://3270017"
local CLOUD_SPHERE_MESH_ID = "rbxassetid://1185246"
local CLOUD_MESH_ID = "rbxassetid://1095708"
local CLOUD_COLOR_TEXTURE = "rbxassetid://1361097"

-- Variables
local basePart = Instance.new("Part")
basePart.Anchored = true
basePart.Locked = true
basePart.CanCollide = false
basePart.CanQuery = false
basePart.CanTouch = false
basePart.TopSurface = Enum.SurfaceType.Smooth
basePart.BottomSurface = Enum.SurfaceType.Smooth
basePart.Size = Vector3.new(1, 1, 1)

local baseMesh = Instance.new("SpecialMesh")
baseMesh.MeshType = Enum.MeshType.FileMesh

local sphereMesh, ringMesh = baseMesh:Clone(), baseMesh:Clone()
sphereMesh.MeshId = CLOUD_SPHERE_MESH_ID
ringMesh.MeshId = CLOUD_RING_MESH_ID

local cloudMesh = baseMesh:Clone()
cloudMesh.MeshId, cloudMesh.TextureId = CLOUD_MESH_ID, CLOUD_COLOR_TEXTURE
cloudMesh.VertexColor = Vector3.new(0.9, 0.6, 0)

local skybox = Instance.new("Sky")
skybox.SkyboxFt, skybox.SkyboxBk = "rbxassetid://1012887", "rbxassetid://1012890"
skybox.SkyboxLf, skybox.SkyboxRt = "rbxassetid://1012889", "rbxassetid://1012888"
skybox.SkyboxDn, skybox.SkyboxUp = "rbxassetid://1012891", "rbxassetid://1014449"

local nukeSkyboxes, realSkyboxes = setmetatable({}, {__mode = "v"}), setmetatable({}, {__mode = "v"})
local nukeIgnore = setmetatable({}, {__mode = "v"})
local explosionParams = OverlapParams.new()
explosionParams.FilterDescendantsInstances = nukeIgnore
explosionParams.FilterType = Enum.RaycastFilterType.Exclude
explosionParams.RespectCanCollide = true

-- Functions
local function basicTween(instance, properties, duration)
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(
			duration,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.In,
			0,
			false,
			0
		),
		properties
	)
	tween:Play()
	if tween.PlaybackState == Enum.PlaybackState.Playing or tween.PlaybackState == Enum.PlaybackState.Begin then
		tween.Completed:Wait()
	end
end

local function createMushroomCloud(position, container, clouds, shockwave)
	local baseCloud = basePart:Clone()
	baseCloud.Position = position

	local poleBase = basePart:Clone()
	poleBase.Position = position + Vector3.new(0, 0.1, 0)

	local cloud1 = basePart:Clone()
	cloud1.Position = position + Vector3.new(0, 0.75, 0)

	local cloud2 = basePart:Clone()
	cloud2.Position = position + Vector3.new(0, 1.25, 0)

	local cloud3 = basePart:Clone()
	cloud3.Position = position + Vector3.new(0, 1.7, 0)

	local poleRing = basePart:Clone()
	poleRing.Position = position + Vector3.new(0, 1.3, 0)
	poleRing.Transparency = 0.2
	poleRing.BrickColor = BrickColor.new("Dark stone grey")
	poleRing.CFrame = poleRing.CFrame * CFrame.Angles(math.rad(90), 0, 0)

	local mushCloud = basePart:Clone()
	mushCloud.Position = position + Vector3.new(0, 2.3, 0)

	local topCloud = basePart:Clone()
	topCloud.Position = position + Vector3.new(0, 2.7, 0)

	do
		local baseCloudMesh = cloudMesh:Clone()
		baseCloudMesh.Parent = baseCloud 
		baseCloudMesh.Scale = Vector3.new(2.5, 1, 4.5)

		local poleBaseMesh = cloudMesh:Clone()
		poleBaseMesh.Scale = Vector3.new(1.25, 2, 2.5)
		poleBaseMesh.Parent = poleBase

		local cloud1Mesh = cloudMesh:Clone()
		cloud1Mesh.Scale = Vector3.new(0.5, 3, 1)
		cloud1Mesh.Parent = cloud1

		local cloud2Mesh = cloudMesh:Clone()
		cloud2Mesh.Scale = Vector3.new(0.5, 1.5, 1)
		cloud2Mesh.Parent = cloud2

		local cloud3Mesh = cloudMesh:Clone()
		cloud3Mesh.Scale = Vector3.new(0.5, 1.5, 1)
		cloud3Mesh.Parent = cloud3

		local poleRingMesh = ringMesh:Clone()
		poleRingMesh.Scale = Vector3.new(1.2, 1.2, 1.2)
		poleRingMesh.Parent = poleRing

		local topCloudMesh = cloudMesh:Clone()
		topCloudMesh.Scale = Vector3.new(7.5, 1.5, 1.5)
		topCloudMesh.Parent = topCloud

		local mushCloudMesh = cloudMesh:Clone()
		mushCloudMesh.Scale = Vector3.new(2.5, 1.75, 3.5)
		mushCloudMesh.Parent = mushCloud
	end

	table.insert(clouds, baseCloud)
	table.insert(clouds, topCloud)
	table.insert(clouds, mushCloud)
	table.insert(clouds, cloud1)
	table.insert(clouds, cloud2)
	table.insert(clouds, cloud3)
	table.insert(clouds, poleBase)
	table.insert(clouds, poleRing)

	local bigRing = basePart:Clone()
	bigRing.Position = position
	bigRing.CFrame = bigRing.CFrame * CFrame.Angles(math.rad(90), 0, 0)

	local smallRing = basePart:Clone()
	smallRing.Position = position
	smallRing.BrickColor = BrickColor.new("Dark stone grey")
	smallRing.CFrame = smallRing.CFrame * CFrame.Angles(math.rad(90), 0, 0)

	local innerSphere = basePart:Clone()
	innerSphere.Position = position
	innerSphere.BrickColor = BrickColor.new("Bright orange")
	innerSphere.Transparency = 0.5

	local outterSphere = basePart:Clone()
	outterSphere.Position = position
	outterSphere.BrickColor = BrickColor.new("Bright orange")
	outterSphere.Transparency = 0.5

	do
		local bigMesh = ringMesh:Clone()
		bigMesh.Scale = Vector3.new(5, 5, 1)
		bigMesh.Parent = bigRing

		local smallMesh = ringMesh:Clone()
		smallMesh.Scale = Vector3.new(4.6, 4.6, 1.5)
		smallMesh.Parent = smallRing

		local innerSphereMesh = sphereMesh:Clone()	
		innerSphereMesh.Scale = Vector3.new(-6.5, -6.5, -6.5)
		innerSphereMesh.Parent = innerSphere

		local outterSphereMesh = sphereMesh:Clone()
		outterSphereMesh.Scale = Vector3.new(6.5, 6.5, 6.5)
		outterSphereMesh.Parent = outterSphere
	end

	table.insert(shockwave, bigRing)	
	table.insert(shockwave, smallRing)
	table.insert(shockwave, outterSphere)
	table.insert(shockwave, innerSphere)

	for _, v in ipairs(shockwave) do
		v.Parent = container
	end
	for _, v in ipairs(clouds) do
		v.Parent = container
	end

	return {
		OutterSphere = outterSphere,
		InnerSphere = innerSphere,
		BigRing = bigRing,
		SmallRing = smallRing,
		BaseCloud = baseCloud,
		PoleBase = poleBase,
		PoleRing = poleRing,
		Cloud1 = cloud1,
		Cloud2 = cloud2,
		Cloud3 = cloud3,
		MushCloud = mushCloud,
		TopCloud = topCloud
	}
end

local function effects(nolighting)
	for i = 1, 2 do
		local explosionSound = Instance.new("Sound")
		explosionSound.Name = "NUKE_SOUND"
		explosionSound.SoundId = "http://www.roblox.com/asset?id=130768997"
		explosionSound.Volume = 0.5
		explosionSound.PlaybackSpeed = i / 2
		explosionSound.RollOffMinDistance, explosionSound.RollOffMaxDistance = 0, 10000
		explosionSound.Archivable = false
		explosionSound.Parent = SoundService
		explosionSound:Play()
		Debris:AddItem(explosionSound, 30)
	end

	if not nolighting then
		local oldBrightness = Lighting.Brightness
		Lighting.Brightness = 5
		basicTween(Lighting, {Brightness = 1}, 4 / 0.01 * (1 / 60))
		Lighting.Brightness = oldBrightness
	end
end

local function tagHumanoid(humanoid, attacker)
	local creatorTag = Instance.new("ObjectValue")
	creatorTag.Name = "creator"
	creatorTag.Value = attacker
	Debris:AddItem(creatorTag, 2)
	creatorTag.Parent = humanoid
end
local function createListGui(player, title, items)
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ListGui"
	screenGui.Parent = player.PlayerGui

	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 550, 0, 450)
	frame.Position = UDim2.new(0.5, -275, 0.5, -225)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = screenGui

	local DragFunc = Instance.new("UIDragDetector", frame)

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame

	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.Position = UDim2.new(0, -20, 0, -20)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.ZIndex = -1
	shadow.Parent = frame

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 48)
	topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	topBar.BorderSizePixel = 0
	topBar.Parent = frame

	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 10)
	topBarCorner.Parent = topBar

	local cornerFix = Instance.new("Frame")
	cornerFix.Size = UDim2.new(1, 0, 0, 12)
	cornerFix.Position = UDim2.new(0, 0, 1, -12)
	cornerFix.BackgroundColor3 = topBar.BackgroundColor3
	cornerFix.BorderSizePixel = 0
	cornerFix.ZIndex = topBar.ZIndex
	cornerFix.Parent = topBar

	local dragIcon = Instance.new("ImageLabel")
	dragIcon.Name = "DragIcon"
	dragIcon.Size = UDim2.new(0, 16, 0, 16)
	dragIcon.Position = UDim2.new(0, 14, 0, 16)
	dragIcon.BackgroundTransparency = 1
	dragIcon.Image = "rbxassetid://7733715400"
	dragIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
	dragIcon.Parent = topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Text = title
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, 40, 0, 0)
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 22
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	local controlsFrame = Instance.new("Frame")
	controlsFrame.Name = "WindowControls"
	controlsFrame.Size = UDim2.new(0, 80, 0, 40)
	controlsFrame.Position = UDim2.new(1, -90, 0, 4)
	controlsFrame.BackgroundTransparency = 1
	controlsFrame.Parent = topBar

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Size = UDim2.new(0, 32, 0, 32)
	minimizeButton.Position = UDim2.new(0, 0, 0, 0)
	minimizeButton.Text = "–"
	minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 22
	minimizeButton.Parent = controlsFrame

	local minimizeCorner = Instance.new("UICorner")
	minimizeCorner.CornerRadius = UDim.new(0, 16)
	minimizeCorner.Parent = minimizeButton

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 32, 0, 32)
	closeButton.Position = UDim2.new(1, -40, 0, 0)
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
	closeButton.BorderSizePixel = 0
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 26
	closeButton.Parent = controlsFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 16)
	closeCorner.Parent = closeButton

	-- Enhanced ScrollingFrame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ItemScroll"
	scrollFrame.Size = UDim2.new(1, -24, 1, -68)
	scrollFrame.Position = UDim2.new(0, 12, 0, 58)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	scrollFrame.ScrollBarImageTransparency = 0.5
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	padding.Parent = scrollFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.Name
	layout.Parent = scrollFrame

	-- Create item entries with enhanced styling
	for i, item in ipairs(items) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Name = "Item_" .. i
		itemFrame.Size = UDim2.new(1, -10, 0, 44)
		itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
		itemFrame.BorderSizePixel = 0
		itemFrame.Parent = scrollFrame

		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 8)
		itemCorner.Parent = itemFrame

		-- Subtle gradient effect
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 60)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 50))
		})
		gradient.Rotation = 90
		gradient.Parent = itemFrame

		-- Item icon (bullet point)
		local itemIcon = Instance.new("ImageLabel")
		itemIcon.Size = UDim2.new(0, 16, 0, 16)
		itemIcon.Position = UDim2.new(0, 12, 0, 14)
		itemIcon.BackgroundTransparency = 1
		itemIcon.Image = "rbxassetid://6031094670" -- Dot icon
		itemIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		itemIcon.Parent = itemFrame

		local itemLabel = Instance.new("TextLabel")
		itemLabel.Name = "ItemLabel"
		itemLabel.Text = item
		itemLabel.Size = UDim2.new(1, -40, 1, 0)
		itemLabel.Position = UDim2.new(0, 40, 0, 0)
		itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		itemLabel.BackgroundTransparency = 1
		itemLabel.Font = Enum.Font.Gotham
		itemLabel.TextSize = 16
		itemLabel.TextXAlignment = Enum.TextXAlignment.Left
		itemLabel.TextWrapped = true
		itemLabel.Parent = itemFrame

		-- Enhanced hover effect
		itemFrame.MouseEnter:Connect(function()
			TweenService:Create(
				itemFrame,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(65, 65, 70)}
			):Play()
		end)

		itemFrame.MouseLeave:Connect(function()
			TweenService:Create(
				itemFrame,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(50, 50, 55)}
			):Play()
		end)
	end

	-- Improved dragging functionality with visual feedback
	local dragging, dragStart, startPos

	-- Visual feedback when hovering over the top bar
	topBar.MouseEnter:Connect(function()
		TweenService:Create(
			dragIcon,
			TweenInfo.new(0.2),
			{ImageColor3 = Color3.fromRGB(255, 255, 255)}
		):Play()
	end)

	topBar.MouseLeave:Connect(function()
		if not dragging then
			TweenService:Create(
				dragIcon,
				TweenInfo.new(0.2),
				{ImageColor3 = Color3.fromRGB(180, 180, 180)}
			):Play()
		end
	end)

	local function updateDrag(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local targetPosition = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)

			-- Smooth dragging with tweening
			TweenService:Create(
				frame,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = targetPosition}
			):Play()
		end
	end

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			-- Visual feedback when dragging begins
			TweenService:Create(
				topBar,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(55, 55, 60)}
			):Play()

			TweenService:Create(
				dragIcon,
				TweenInfo.new(0.2),
				{ImageColor3 = Color3.fromRGB(255, 255, 255)}
			):Play()
		end
	end)

	UserInputService.InputChanged:Connect(updateDrag)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false

			-- Visual feedback when dragging ends
			TweenService:Create(
				topBar,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(45, 45, 50)}
			):Play()
		end
	end)

	-- Control button effects
	minimizeButton.MouseEnter:Connect(function()
		TweenService:Create(
			minimizeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(75, 75, 80)}
		):Play()
	end)

	minimizeButton.MouseLeave:Connect(function()
		TweenService:Create(
			minimizeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(60, 60, 65)}
		):Play()
	end)

	closeButton.MouseEnter:Connect(function()
		TweenService:Create(
			closeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(255, 85, 85)}
		):Play()
	end)

	closeButton.MouseLeave:Connect(function()
		TweenService:Create(
			closeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(230, 75, 75)}
		):Play()
	end)

	-- Minimize functionality (collapses the window to just the top bar)
	local windowExpanded = true
	minimizeButton.MouseButton1Click:Connect(function()
		windowExpanded = not windowExpanded

		if windowExpanded then
			-- Expand window
			TweenService:Create(
				frame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, 550, 0, 450)}
			):Play()
			minimizeButton.Text = "–"
		else
			-- Collapse window to just the top bar
			TweenService:Create(
				frame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, 550, 0, 48)}
			):Play()
			minimizeButton.Text = "+"
		end
	end)

	-- Improved close animation
	closeButton.MouseButton1Click:Connect(function()
		-- First shrink the window
		local shrinkTween = TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
		)

		-- Also fade out
		local fadeTween = TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 1}
		)

		shrinkTween:Play()
		fadeTween:Play()

		shrinkTween.Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)

	-- Opening animation with bounce effect
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.BackgroundTransparency = 0.2

	TweenService:Create(
		frame,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 550, 0, 450), Position = UDim2.new(0.5, -275, 0.5, -225), BackgroundTransparency = 0}
	):Play()
end
local function createInfoGui(player, title, info)
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InfoGui"
	screenGui.Parent = player.PlayerGui

	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 500, 0, 350)
	frame.Position = UDim2.new(0.5, -250, 0.5, -175)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = screenGui

	local DragFunc = Instance.new("UIDragDetector", frame)

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame

	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.Position = UDim2.new(0, -20, 0, -20)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.ZIndex = -1
	shadow.Parent = frame

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 48)
	topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	topBar.BorderSizePixel = 0
	topBar.Parent = frame

	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 10)
	topBarCorner.Parent = topBar

	local cornerFix = Instance.new("Frame")
	cornerFix.Size = UDim2.new(1, 0, 0, 12)
	cornerFix.Position = UDim2.new(0, 0, 1, -12)
	cornerFix.BackgroundColor3 = topBar.BackgroundColor3
	cornerFix.BorderSizePixel = 0
	cornerFix.ZIndex = topBar.ZIndex
	cornerFix.Parent = topBar

	local dragIcon = Instance.new("ImageLabel")
	dragIcon.Name = "DragIcon"
	dragIcon.Size = UDim2.new(0, 16, 0, 16)
	dragIcon.Position = UDim2.new(0, 14, 0, 16)
	dragIcon.BackgroundTransparency = 1
	dragIcon.Image = "rbxassetid://7733715400"
	dragIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
	dragIcon.Parent = topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Text = title
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, 40, 0, 0)
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 22
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	local controlsFrame = Instance.new("Frame")
	controlsFrame.Name = "WindowControls"
	controlsFrame.Size = UDim2.new(0, 80, 0, 40)
	controlsFrame.Position = UDim2.new(1, -90, 0, 4)
	controlsFrame.BackgroundTransparency = 1
	controlsFrame.Parent = topBar

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Size = UDim2.new(0, 32, 0, 32)
	minimizeButton.Position = UDim2.new(0, 0, 0, 0)
	minimizeButton.Text = "–"
	minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 22
	minimizeButton.Parent = controlsFrame

	local minimizeCorner = Instance.new("UICorner")
	minimizeCorner.CornerRadius = UDim.new(0, 16)
	minimizeCorner.Parent = minimizeButton

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 32, 0, 32)
	closeButton.Position = UDim2.new(1, -40, 0, 0)
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
	closeButton.BorderSizePixel = 0
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 26
	closeButton.Parent = controlsFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 16)
	closeCorner.Parent = closeButton

	-- Create content container
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(1, -24, 1, -68)
	contentFrame.Position = UDim2.new(0, 12, 0, 58)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 6
	contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	contentFrame.ScrollBarImageTransparency = 0.5
	contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentFrame.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	padding.Parent = contentFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = contentFrame

	-- Create info items with enhanced styling
	local index = 0
	for key, value in pairs(info) do
		index = index + 1

		local infoFrame = Instance.new("Frame")
		infoFrame.Name = "InfoItem_" .. index
		infoFrame.Size = UDim2.new(1, -10, 0, 44)
		infoFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
		infoFrame.BorderSizePixel = 0
		infoFrame.LayoutOrder = index
		infoFrame.Parent = contentFrame

		local infoCorner = Instance.new("UICorner")
		infoCorner.CornerRadius = UDim.new(0, 8)
		infoCorner.Parent = infoFrame

		-- Subtle gradient effect
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 60)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 50))
		})
		gradient.Rotation = 90
		gradient.Parent = infoFrame

		-- Key label
		local keyLabel = Instance.new("TextLabel")
		keyLabel.Name = "KeyLabel"
		keyLabel.Text = key .. ":"
		keyLabel.Size = UDim2.new(0.4, -20, 1, 0)
		keyLabel.Position = UDim2.new(0, 14, 0, 0)
		keyLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
		keyLabel.BackgroundTransparency = 1
		keyLabel.Font = Enum.Font.GothamSemibold
		keyLabel.TextSize = 16
		keyLabel.TextXAlignment = Enum.TextXAlignment.Left
		keyLabel.Parent = infoFrame

		-- Value label
		local valueLabel = Instance.new("TextLabel")
		valueLabel.Name = "ValueLabel"
		valueLabel.Text = tostring(value)
		valueLabel.Size = UDim2.new(0.6, 0, 1, 0)
		valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
		valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Font = Enum.Font.Gotham
		valueLabel.TextSize = 16
		valueLabel.TextXAlignment = Enum.TextXAlignment.Left
		valueLabel.TextWrapped = true
		valueLabel.Parent = infoFrame

		-- Enhanced hover effect
		infoFrame.MouseEnter:Connect(function()
			TweenService:Create(
				infoFrame,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(65, 65, 70)}
			):Play()
		end)

		infoFrame.MouseLeave:Connect(function()
			TweenService:Create(
				infoFrame,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(50, 50, 55)}
			):Play()
		end)
	end

	-- Improved dragging functionality with visual feedback
	local dragging, dragStart, startPos

	-- Visual feedback when hovering over the top bar
	topBar.MouseEnter:Connect(function()
		TweenService:Create(
			dragIcon,
			TweenInfo.new(0.2),
			{ImageColor3 = Color3.fromRGB(255, 255, 255)}
		):Play()
	end)

	topBar.MouseLeave:Connect(function()
		if not dragging then
			TweenService:Create(
				dragIcon,
				TweenInfo.new(0.2),
				{ImageColor3 = Color3.fromRGB(180, 180, 180)}
			):Play()
		end
	end)

	local function updateDrag(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local targetPosition = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)

			-- Smooth dragging with tweening
			TweenService:Create(
				frame,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = targetPosition}
			):Play()
		end
	end

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			-- Visual feedback when dragging begins
			TweenService:Create(
				topBar,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(55, 55, 60)}
			):Play()

			TweenService:Create(
				dragIcon,
				TweenInfo.new(0.2),
				{ImageColor3 = Color3.fromRGB(255, 255, 255)}
			):Play()
		end
	end)

	UserInputService.InputChanged:Connect(updateDrag)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false

			-- Visual feedback when dragging ends
			TweenService:Create(
				topBar,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(45, 45, 50)}
			):Play()
		end
	end)

	-- Control button effects
	minimizeButton.MouseEnter:Connect(function()
		TweenService:Create(
			minimizeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(75, 75, 80)}
		):Play()
	end)

	minimizeButton.MouseLeave:Connect(function()
		TweenService:Create(
			minimizeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(60, 60, 65)}
		):Play()
	end)

	closeButton.MouseEnter:Connect(function()
		TweenService:Create(
			closeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(255, 85, 85)}
		):Play()
	end)

	closeButton.MouseLeave:Connect(function()
		TweenService:Create(
			closeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(230, 75, 75)}
		):Play()
	end)

	-- Minimize functionality (collapses the window to just the top bar)
	local windowExpanded = true
	minimizeButton.MouseButton1Click:Connect(function()
		windowExpanded = not windowExpanded

		if windowExpanded then
			-- Expand window
			TweenService:Create(
				frame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, 500, 0, 350)}
			):Play()
			minimizeButton.Text = "–"
		else
			-- Collapse window to just the top bar
			TweenService:Create(
				frame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, 500, 0, 48)}
			):Play()
			minimizeButton.Text = "+"
		end
	end)

	-- Improved close animation
	closeButton.MouseButton1Click:Connect(function()
		-- First shrink the window
		local shrinkTween = TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
		)

		-- Also fade out
		local fadeTween = TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 1}
		)

		shrinkTween:Play()
		fadeTween:Play()

		shrinkTween.Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)

	-- Opening animation with bounce effect
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.BackgroundTransparency = 0.2

	TweenService:Create(
		frame,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, -250, 0.5, -175), BackgroundTransparency = 0}
	):Play()
end
local function destruction(position, radius, attacker)
	for _, v in ipairs(workspace:GetPartBoundsInRadius(position, radius, explosionParams)) do
		if v.ClassName ~= "Terrain" and v.Anchored == false then
			if attacker then
				local humanoid = v.Parent:FindFirstChildOfClass("Humanoid")
				if humanoid and not humanoid:FindFirstChild("creator") then
					tagHumanoid(humanoid, attacker)
				end
			end
			v:BreakJoints()
			v.Material = Enum.Material.CorrodedMetal
			v.AssemblyLinearVelocity = CFrame.new(v.Position, position):VectorToWorldSpace(Vector3.new(math.random(-5, 5), 5, 1000))
		end
	end
end

local function explode(position, explosionSize, nolighting, attacker)
	local shockwaveCompleted = false
	explosionParams.FilterDescendantsInstances = nukeIgnore
	local clouds, shockwave = {}, {}
	local container = Instance.new("Model")
	container.Name = "PUNCHY_NUCLEAREXPLOSION"
	container.Archivable = false
	container.ModelStreamingMode = Enum.ModelStreamingMode.Atomic
	container.Parent = workspace
	table.insert(nukeIgnore, container)

	local cloudData = createMushroomCloud(position, container, clouds, shockwave)
	local outterSphere, innerSphere, bigRing, smallRing = cloudData.OutterSphere, cloudData.InnerSphere, cloudData.BigRing, cloudData.SmallRing
	local baseCloud, poleBase, poleRing = cloudData.BaseCloud, cloudData.PoleBase, cloudData.PoleRing
	local cloud1, cloud2, cloud3, mushCloud, topCloud = cloudData.Cloud1, cloudData.Cloud2, cloudData.Cloud3, cloudData.MushCloud, cloudData.TopCloud
	
	local newSky = skybox:Clone()
	table.insert(nukeSkyboxes, newSky)
	newSky.Parent = Lighting
	task.spawn(effects, nolighting)

	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") and not table.find(nukeSkyboxes, v) and not table.find(realSkyboxes, v) then
			table.insert(realSkyboxes, v)
		end
	end

	task.spawn(function()
		local maxSize = explosionSize * 3
		local smallSize = explosionSize / 2.5
		local nukeDuration = (maxSize - smallSize) / 2 * (1 / 60)
		local transforms = {
			{innerSphere, Vector3.new(-6.5 * maxSize, -6.5 * maxSize, -6.5 * maxSize)},
			{outterSphere, Vector3.new(6.5 * maxSize, 6.5 * maxSize, 6.5 * maxSize)},
			{smallRing, Vector3.new(4.6 * maxSize, 4.6 * maxSize, 1.5 * maxSize)},
			{bigRing, Vector3.new(5 * maxSize, 5 * maxSize, 1 * maxSize)},
		}

		for _, v in ipairs(transforms) do
			local object, scale = v[1], v[2]
			if typeof(object) == "Instance" then
				local mesh = object:FindFirstChildOfClass("SpecialMesh")
				if mesh then
					mesh.Scale = scale * (smallSize / maxSize)
					task.spawn(basicTween, mesh, {Scale = scale}, nukeDuration)
				end
			end
		end

		do
			local startclock = os.clock()
			local expGrow, expStat = maxSize - smallSize, smallSize
			repeat
				destruction(
					position,
					(((os.clock() - startclock) / nukeDuration) * expGrow + expStat) * 2,
					attacker
				)
				task.wait(1/25)
			until (os.clock() - startclock) > nukeDuration
		end

		for _, v in ipairs(shockwave) do
			v.Transparency = 0
			task.spawn(basicTween, v, {Transparency = 1}, 100 * (1 / 60))
		end
		task.wait(100 * (1 / 60))

		for _, v in ipairs(shockwave) do
			v:Destroy()
		end
		shockwaveCompleted = true
	end)

	task.spawn(function()
		local transforms = {
			{baseCloud, Vector3.new(2.5 * explosionSize, 1 * explosionSize, 4.5 * explosionSize), Vector3.new(0, 0.05 * explosionSize, 0)},
			{poleBase, Vector3.new(1 * explosionSize, 2 * explosionSize, 2.5 * explosionSize), Vector3.new(0, 0.1 * explosionSize, 0)},
			{poleRing, Vector3.new(1.2 * explosionSize, 1.2 * explosionSize, 1.2 * explosionSize), Vector3.new(0, 1.3 * explosionSize, 0)},
			{topCloud, Vector3.new(0.75 * explosionSize, 1.5 * explosionSize, 1.5 * explosionSize), Vector3.new(0, 2.7 * explosionSize, 0)},
			{mushCloud, Vector3.new(2.5 * explosionSize, 1.75 * explosionSize, 3.5 * explosionSize), Vector3.new(0, 2.3 * explosionSize, 0)},
			{cloud1, Vector3.new(0.5 * explosionSize, 3 * explosionSize, 1 * explosionSize), Vector3.new(0, 0.75 * explosionSize, 0)},
			{cloud2, Vector3.new(0.5 * explosionSize, 1.5 * explosionSize, 1 * explosionSize), Vector3.new(0, 1.25 * explosionSize, 0)},
			{cloud3, Vector3.new(0.5 * explosionSize, 1.5 * explosionSize, 1 * explosionSize), Vector3.new(0, 1.7 * explosionSize, 0)},
		}

		for _, v in ipairs(transforms) do
			local object, scale = v[1], v[2]
			if typeof(object) == "Instance" then
				object.Position = position + v[3] / 5
				local mesh = object:FindFirstChildOfClass("SpecialMesh")
				if mesh then
					mesh.Scale = scale / 5
					task.spawn(basicTween, mesh, {Scale = scale}, 2)
				end
				task.spawn(basicTween, object, {Position = position + v[3]}, 2)
			end
		end
	end)
	task.wait(2)

	for _, v in ipairs(clouds) do
		local mesh = v:FindFirstChildOfClass("SpecialMesh")
		if mesh then
			mesh.VertexColor = Vector3.new(0.9, 0.6, 0)
			task.spawn(basicTween, mesh, {VertexColor = Vector3.new(0.9, 0, 0)}, 0.6 / 0.0025 * (1 / 60))
		end
	end
	task.wait(0.6 / 0.0025 * (1 / 60))

	for _, v in ipairs(clouds) do
		local mesh = v:FindFirstChildOfClass("SpecialMesh")
		if mesh then
			mesh.VertexColor = Vector3.new(0.9, 0, 0)
			task.spawn(basicTween, mesh, {VertexColor = Vector3.new(0.5, 0, 0)}, (0.9 - 0.5) / 0.01 * (1 / 60) * 2)
		end
	end
	task.wait((0.9 - 0.5) / 0.01 * (1 / 60) * 2)

	local skyConnection
	skyConnection = newSky.AncestryChanged:Connect(function()
		if newSky and newSky.Parent ~= Lighting and table.find(nukeSkyboxes, newSky) then
			table.remove(nukeSkyboxes, table.find(nukeSkyboxes, newSky))
		end
		local hasNukeSkyboxes = false
		for _, v in ipairs(nukeSkyboxes) do
			if v.Parent == Lighting then
				hasNukeSkyboxes = true
				break
			end
		end
		if not hasNukeSkyboxes then
			for i = #realSkyboxes, 1, -1 do
				local v = realSkyboxes[i]
				if v.Parent == Lighting then
					v.Parent = nil
					task.spawn(function()
						task.wait()
						v.Parent = Lighting
					end)
				elseif table.find(realSkyboxes, v) then
					table.remove(realSkyboxes, table.find(realSkyboxes, v))
				end
			end
		end
		skyConnection:Disconnect()
	end)
	Debris:AddItem(newSky, 10)

	for _, v in ipairs(clouds) do
		local mesh = v:FindFirstChildOfClass("SpecialMesh")
		if mesh then
			mesh.VertexColor = Vector3.new(0, 0, 0)
			task.spawn(basicTween, mesh, {VertexColor = Vector3.new(0.5, 0.5, 0.5)}, 0.5 / 0.005 * (1 / 60))
			task.spawn(basicTween, mesh, {Scale = mesh.Scale + Vector3.new(0.1, 0.1, 0.1) * (0.5 / 0.005)}, 0.5 / 0.005 * (1 / 60))
		end
		task.spawn(basicTween, v, {Transparency = 0.5}, 0.5 / 0.005 * (1 / 60))
	end
	task.wait(0.5 / 0.005 * (1 / 60))

	for _, v in ipairs(clouds) do
		task.spawn(basicTween, v, {Transparency = 1}, 20)
		local mesh = v:FindFirstChildOfClass("SpecialMesh")
		if mesh then
			task.spawn(basicTween, mesh, {Scale = mesh.Scale + Vector3.new(0.1, 0.1, 0.1) * (1 / 0.005)}, 20)
		end
	end
	task.wait(20)

	while true do task.wait(1) if shockwaveCompleted then break end end
	container:Destroy()
end
local function notify(plr, title, message, duration)
	if typeof(plr) == "string" then return end

	local gui = Instance.new("ScreenGui")
	gui.Name = game:GetService("HttpService"):GenerateGUID(false)
	gui.ResetOnSpawn = false
	gui.Parent = plr:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 320, 0, 90)
	frame.Position = UDim2.new(1.5, -340, 1, -110)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame

	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.Position = UDim2.new(0, -15, 0, -15)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.Parent = frame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title
	titleLabel.Size = UDim2.new(1, -20, 0.35, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 5)
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 18
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = frame

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Text = message
	messageLabel.Size = UDim2.new(1, -20, 0.65, -10)
	messageLabel.Position = UDim2.new(0, 10, 0.35, 0)
	messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 14
	messageLabel.TextWrapped = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.Parent = frame

	task.spawn(function()
		local TweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local tween = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(1, -340, 1, -110)})
		tween:Play()

		task.wait(duration or 5)

		tween = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(1.5, -340, 1, -110)})
		tween:Play()
		tween.Completed:Wait()
		gui:Destroy()
	end)
end

local function showCenterNotification(plr, title, message, duration)
	local gui = Instance.new("ScreenGui")
	gui.Name = "CenterNotificationGui"
	gui.ResetOnSpawn = false
	gui.Parent = plr:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 400, 0, 180)
	frame.Position = UDim2.new(0.5, -200, 0.5, -90)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 12)
	uiCorner.Parent = frame

	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.Position = UDim2.new(0, -20, 0, -20)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.Parent = frame

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
	})
	gradient.Rotation = 45
	gradient.Parent = frame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title
	titleLabel.Size = UDim2.new(1, -40, 0.3, 0)
	titleLabel.Position = UDim2.new(0, 20, 0, 20)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 24
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.Parent = frame

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Text = message
	messageLabel.Size = UDim2.new(1, -60, 0.7, -40)
	messageLabel.Position = UDim2.new(0, 30, 0.3, 0)
	messageLabel.BackgroundTransparency = 1
	titleLabel.RichText = true
	messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 20
	messageLabel.TextWrapped = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Center
	messageLabel.Parent = frame

	frame.BackgroundTransparency = 1
	titleLabel.TextTransparency = 1
	messageLabel.TextTransparency = 1
	shadow.ImageTransparency = 1

	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(messageLabel, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(shadow, tweenInfo, {ImageTransparency = 0.5}):Play()

	task.delay(duration or 5, function()

		TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
		TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 1}):Play()
		TweenService:Create(messageLabel, tweenInfo, {TextTransparency = 1}):Play()
		TweenService:Create(shadow, tweenInfo, {ImageTransparency = 1}):Play()

		task.delay(0.3, function()
			gui:Destroy()
		end)
	end)
end

local function getPlayers(arg, sender)
	local targets = {}
	arg = arg:lower()
	if arg == "me" then
		table.insert(targets, sender)
	elseif arg == "all" then
		for _, p in ipairs(game.Players:GetPlayers()) do
			table.insert(targets, p)
		end
	elseif arg == "others" then
		for _, p in ipairs(game.Players:GetPlayers()) do
			if p ~= sender then
				table.insert(targets, p)
			end
		end
	else
		for _, p in ipairs(game.Players:GetPlayers()) do
			if p.Name:lower():sub(1, #arg) == arg or p.DisplayName:lower():sub(1, #arg) == arg then
				table.insert(targets, p)
			end
		end
	end
	return targets
end
local function addCommand(cmdName, func, aliases, options)
	options = options or {}
	local commandTable = {
		name = cmdName,
		func = func,
		aliases = aliases or {},
		noTarget = options.noTarget or false
	}
	cmds[cmdName:lower()] = commandTable
	if aliases then
		for _, alias in ipairs(aliases) do
			cmds[alias:lower()] = commandTable
		end
	end
end
local function teleportToFront(target, destination)
	if target and target.PrimaryPart and destination and destination.PrimaryPart then
		target:SetPrimaryPartCFrame(destination.PrimaryPart.CFrame * CFrame.new(0, 3, -5))
	end
end

addCommand("kill", function(sender, targets)
	for _, p in ipairs(targets) do
		if p.Character then
			local humanoid = p.Character:FindFirstChild("Humanoid")
			if humanoid then humanoid.Health = 0 end
		end
	end
end)

addCommand("bring", function(sender, targets)
	if sender.Character then
		for _, p in ipairs(targets) do
			teleportToFront(p.Character, sender.Character)
		end
	end
end, {"br"})
addCommand("tp", function(sender, targets)
	if sender.Character then
		for _, p in ipairs(targets) do
			teleportToFront(sender.Character, p.Character)
		end
	end
end, {"teleport", "to"})
addCommand("kick", function(sender, targets, args)
	local reason = table.concat(args, " ") or "No reason provided"
	for _, p in ipairs(targets) do
		p:Kick("\n\nKicked by:\n" .. sender.Name .. "\n\nReason: " .. reason)
	end
end)

addCommand("ban", function(sender, targets, args)
    local reason = table.concat(args, " ") or "No reason provided"
    for _, p in ipairs(targets) do
        BANNED_USERS[p.UserId] = {
            name = p.Name, -- Store the player's name
            reason = reason,
            banner = sender.Name,
            timestamp = os.time()
        }
        p:Kick("\nBanned by: " .. sender.Name .. "\nReason: " .. reason)
    end
end)

addCommand("timeban", function(sender, targets, args)
	local duration = tonumber(args[1])
	if not duration then
		notify(sender, "Error", "Please specify ban duration in minutes", 5)
		return
	end
	table.remove(args, 1)
	local reason = table.concat(args, " ") or "No reason provided"

	for _, p in ipairs(targets) do
		BANNED_USERS[p.UserId] = {
			name = p.Name, -- Store the player's name
			reason = reason,
			banner = sender.Name,
			timestamp = os.time(),
			duration = duration * 60
		}
		p:Kick("\n\nTemporarily banned by:\n" .. sender.Name .. "\nDuration: " .. duration .. " minutes" .. "\nReason: " .. reason)
	end
end)

addCommand("unban", function(sender, targets, args)
	for _, p in ipairs(targets) do
		BANNED_USERS[p.UserId] = nil
		notify(sender, "Unban", p.Name .. " has been unbanned", 5)
	end
end)
addCommand("shutdown", function(sender, targets, args)
	local reason = #args > 0 and table.concat(args, " ") or "No reason provided"

	for _, p in ipairs(game.Players:GetPlayers()) do
		p:Kick("\nPunchy Admin!\n\nServer shutdown by:\n" .. sender.Name .. "\n\nReason:\n" .. reason .. "\n\n")
	end

	task.wait(1)
	game:Shutdown()
end, {"sd"}, { noTarget = true })
addCommand("freeze", function(sender, targets)
	for _, p in ipairs(targets) do
		if p.Character then
			for _, part in ipairs(p.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = true
				end
			end
		end
	end
end)
addCommand("unfreeze", function(sender, targets)
	for _, p in ipairs(targets) do
		if p.Character then
			for _, part in ipairs(p.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = false
				end
			end
		end
	end
end)
addCommand("explode", function(sender, targets)
	for _, targetPlayer in ipairs(targets) do
		if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local success, err = pcall(function()
				local explosion = Instance.new("Explosion")
				explosion.Position = targetPlayer.Character.HumanoidRootPart.Position
				explosion.Parent = workspace
				game:GetService("Debris"):AddItem(explosion, 2)
			end)
			if not success then
				notify(sender, "Error", "Explosion failed for " .. targetPlayer.Name .. ": " .. err, 5)
			end
		else
			notify(sender, "Error", targetPlayer.Name .. " has no character", 5)
		end
	end
end)
addCommand("hang", function(sender, targets)
	for _, plr in ipairs(targets) do
		if plr.Character and plr.Character:FindFirstChild("Head") and 
			plr.Character:FindFirstChild("HumanoidRootPart") and 
			plr.Character:FindFirstChild("Torso") then

			local parts = {}

			local floor = Instance.new("Part", workspace)
			floor.Name = "Punchy was here"
			floor.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0)
			floor.Material = Enum.Material.Wood
			floor.BrickColor = BrickColor.new("Rust")
			floor.Size = Vector3.new(16, 1, 16)
			floor.Anchored = true
			table.insert(parts, floor)

			local pole = Instance.new("Part", workspace)
			pole.Name = "Punchy was here"
			pole.CFrame = floor.CFrame * CFrame.new(0, 6.5, 7)
			pole.Material = Enum.Material.Wood
			pole.BrickColor = BrickColor.new("Rust")
			pole.Size = Vector3.new(2, 12, 2)
			pole.Anchored = true
			table.insert(parts, pole)

			local pole2 = Instance.new("Part", workspace)
			pole2.Name = "Punchy was here"
			pole2.CFrame = pole.CFrame * CFrame.new(0, 6.5, -2)
			pole2.Material = Enum.Material.Wood
			pole2.BrickColor = BrickColor.new("Rust")
			pole2.Size = Vector3.new(2, 1, 6)
			pole2.Anchored = true
			table.insert(parts, pole2)

			local metal = Instance.new("Part", workspace)
			metal.Name = "Punchy was here"
			metal.CFrame = pole.CFrame * CFrame.new(0, 7.05, -4)
			metal.Material = Enum.Material.DiamondPlate
			metal.BrickColor = BrickColor.new("Black")
			metal.Size = Vector3.new(2, 0.1, 0.1)
			metal.Anchored = true
			table.insert(parts, metal)

			local metal2 = Instance.new("Part", workspace)
			metal2.Name = "Punchy was here"
			metal2.CFrame = metal.CFrame * CFrame.new(-1.05, -0.56, 0)
			metal2.Material = Enum.Material.DiamondPlate
			metal2.BrickColor = BrickColor.new("Black")
			metal2.Size = Vector3.new(0.1, 1.213, 0.1)
			metal2.Anchored = true
			table.insert(parts, metal2)

			local metal3 = Instance.new("Part", workspace)
			metal3.Name = "Punchy was here"
			metal3.CFrame = metal.CFrame * CFrame.new(1.05, -0.56, 0)
			metal3.Material = Enum.Material.DiamondPlate
			metal3.BrickColor = BrickColor.new("Black")
			metal3.Size = Vector3.new(0.1, 1.213, 0.1)
			metal3.Anchored = true
			table.insert(parts, metal3)

			local metal4 = Instance.new("Part", workspace)
			metal4.Name = "Punchy was here"
			metal4.CFrame = pole.CFrame * CFrame.new(0, 5.93, -4)
			metal4.Material = Enum.Material.DiamondPlate
			metal4.BrickColor = BrickColor.new("Black")
			metal4.Size = Vector3.new(2, 0.1, 0.1)
			metal4.Anchored = true
			table.insert(parts, metal4)

			local rope = Instance.new("Part", workspace)
			rope.Name = "Punchy was here"
			rope.CFrame = metal4.CFrame * CFrame.new(0, -0.60, 0)
			rope.Material = Enum.Material.Leather
			rope.BrickColor = BrickColor.new("Burnt Sienna")
			rope.Size = Vector3.new(0.1, 1.113, 0.1)
			rope.Anchored = true
			table.insert(parts, rope)

			local rope2 = Instance.new("Part", workspace)
			rope2.Name = "Punchy was here"
			rope2.CFrame = rope.CFrame * CFrame.new(0, -0.6, 0)
			rope2.Material = Enum.Material.Leather
			rope2.BrickColor = BrickColor.new("Burnt Sienna")
			rope2.Size = Vector3.new(1.459, 0.1, 0.1)
			rope2.Anchored = true
			table.insert(parts, rope2)

			local rope3 = Instance.new("Part", workspace)
			rope3.Name = "Punchy was here"
			rope3.CFrame = rope2.CFrame * CFrame.new(0.78, -0.5560, 0)
			rope3.Material = Enum.Material.Leather
			rope3.BrickColor = BrickColor.new("Burnt Sienna")
			rope3.Size = Vector3.new(0.1, 1.215, 0.1)
			rope3.Anchored = true
			table.insert(parts, rope3)

			local rope4 = Instance.new("Part", workspace)
			rope4.Name = "Punchy was here"
			rope4.CFrame = rope2.CFrame * CFrame.new(-0.78, -0.5560, 0)
			rope4.Material = Enum.Material.Leather
			rope4.BrickColor = BrickColor.new("Burnt Sienna")
			rope4.Size = Vector3.new(0.1, 1.215, 0.1)
			rope4.Anchored = true
			table.insert(parts, rope4)

			local rope5 = Instance.new("Part", workspace)
			rope5.Name = "Punchy was here"
			rope5.CFrame = rope.CFrame * CFrame.new(0, -1.715, 0)
			rope5.Material = Enum.Material.Leather
			rope5.BrickColor = BrickColor.new("Burnt Sienna")
			rope5.Size = Vector3.new(1.459, 0.1, 0.1)
			rope5.Anchored = true
			table.insert(parts, rope5)

			plr.Character.Head.CFrame = rope5.CFrame * CFrame.new(0, 1, 0.5)
			plr.Character.HumanoidRootPart.Anchored = true
			plr.Character.Humanoid.Animator:Destroy()
			plr.Character.Torso.Neck.C0 = plr.Character.Torso.Neck.C0 * CFrame.Angles(math.rad(90), 0, 0)

			local humanoid = plr.Character:FindFirstChild("Humanoid")
			if humanoid then
				local damageConnection
				damageConnection = game:GetService("RunService").Heartbeat:Connect(function()
					if humanoid.Health <= 0 then
						for _, part in ipairs(parts) do
							part:Destroy()
						end
						damageConnection:Disconnect()
						return
					end
					humanoid.Health = humanoid.Health - 0.3
				end)
			end
		end
	end
end)
addCommand("mcdonalds", function(sender)
	if not game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder"):FindFirstChild("McDonald's") then
		local success, fail = pcall(function()
			require(83374861646895)
		end)

		if success and sender.Character and sender.Character:FindFirstChild("HumanoidRootPart") then
			repeat task.wait() until workspace:FindFirstChild("McDonald's")
			workspace:FindFirstChild("McDonald's").Parent = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder")
			local building = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder"):FindFirstChild("McDonald's"):Clone()
			building.PrimaryPart = building:FindFirstChild("Floor")
			building.Parent = workspace
			building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(-9.5, -3, -30) * CFrame.Angles(0,math.rad(180),0))
		else
			notify(sender, "Punchy's admin", "McDonalds failed to load: ".. fail)
		end
	else
		local building = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder"):FindFirstChild("McDonald's"):Clone()
		building.PrimaryPart = building:FindFirstChild("Floor")
		building.Parent = workspace
		building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(-9.5, -3, -30) * CFrame.Angles(0,math.rad(180),0))
	end
end)

addCommand("unload", function(sender)
	for _, player in ipairs(game.Players:GetPlayers()) do
		if ADMINS[player.UserId] then
			notify(player, "Punchy Admin System", "System is being unloaded...", 5)
		end
	end

	for userId, connection in pairs(connections or {}) do
		if typeof(connection) == "RBXScriptConnection" then
			connection:Disconnect()
		end
	end

	for _, v in ipairs(workspace:GetChildren()) do
		if v.Name == "Punchy was here" or v.Name == "HamsterBall" then
			v:Destroy()
		end
	end

	ADMINS = {}
	BANNED_USERS = {}
	connections = {}
	cmds = {}

	local replicatedStorage = game:GetService("ReplicatedStorage")
	local folder = replicatedStorage:FindFirstChild("Punchy's folder")
	if folder then
		folder:Destroy()
	end

	notify(sender, "Punchy Admin", "System has been unloaded successfully", 5)
end)
addCommand("addadmin", function(sender, targets)
	for _, p in ipairs(targets) do
		ADMINS[p.UserId] = true
		notify(sender, "Punchy Admin Added", p.Name.." is now an admin", 5)
	end
end)
addCommand("reset", function(sender, targets)
	for _, plr in ipairs(targets) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local currentCFrame = plr.Character.HumanoidRootPart.CFrame

			local connection
			connection = plr.CharacterAdded:Connect(function(newCharacter)
				local hrp = newCharacter:WaitForChild("HumanoidRootPart")
				task.wait(0.05)
				hrp.CFrame = currentCFrame
				connection:Disconnect()
			end)

			plr:LoadCharacter()
		end
	end
end, {"re"})
addCommand("cmds", function(sender)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CommandsGui"
	screenGui.Parent = sender:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 550, 0, 450)
	frame.Position = UDim2.new(0.5, -275, 0.5, -225)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = screenGui

	local DragFunc = Instance.new("UIDragDetector", frame)

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame

	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.Position = UDim2.new(0, -20, 0, -20)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.ZIndex = -1
	shadow.Parent = frame

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 48)
	topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	topBar.BorderSizePixel = 0
	topBar.Parent = frame

	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 10)
	topBarCorner.Parent = topBar

	local cornerFix = Instance.new("Frame")
	cornerFix.Size = UDim2.new(1, 0, 0, 12)
	cornerFix.Position = UDim2.new(0, 0, 1, -12)
	cornerFix.BackgroundColor3 = topBar.BackgroundColor3
	cornerFix.BorderSizePixel = 0
	cornerFix.ZIndex = topBar.ZIndex
	cornerFix.Parent = topBar

	local dragIcon = Instance.new("ImageLabel")
	dragIcon.Name = "DragIcon"
	dragIcon.Size = UDim2.new(0, 16, 0, 16)
	dragIcon.Position = UDim2.new(0, 14, 0, 16)
	dragIcon.BackgroundTransparency = 1
	dragIcon.Image = "rbxassetid://7733715400"
	dragIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
	dragIcon.Parent = topBar

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = "Punchy Admin Commands"
	title.Size = UDim2.new(1, -100, 1, 0)
	title.Position = UDim2.new(0, 40, 0, 0)
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topBar

	local controlsFrame = Instance.new("Frame")
	controlsFrame.Name = "WindowControls"
	controlsFrame.Size = UDim2.new(0, 80, 0, 40)
	controlsFrame.Position = UDim2.new(1, -90, 0, 4)
	controlsFrame.BackgroundTransparency = 1
	controlsFrame.Parent = topBar

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Size = UDim2.new(0, 32, 0, 32)
	minimizeButton.Position = UDim2.new(0, 0, 0, 0)
	minimizeButton.Text = "–"
	minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 22
	minimizeButton.Parent = controlsFrame

	local minimizeCorner = Instance.new("UICorner")
	minimizeCorner.CornerRadius = UDim.new(0, 16)
	minimizeCorner.Parent = minimizeButton

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 32, 0, 32)
	closeButton.Position = UDim2.new(1, -40, 0, 0)
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
	closeButton.BorderSizePixel = 0
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 26
	closeButton.Parent = controlsFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 16)
	closeCorner.Parent = closeButton

	-- More polished ScrollingFrame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "CommandScroll"
	scrollFrame.Size = UDim2.new(1, -24, 1, -68)
	scrollFrame.Position = UDim2.new(0, 12, 0, 58)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	scrollFrame.ScrollBarImageTransparency = 0.5
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	padding.Parent = scrollFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.Name
	layout.Parent = scrollFrame

	-- Enhanced command item styling
	for cmdName, cmdData in pairs(cmds) do
		if cmdName == string.lower(cmdData.name) then  -- Only display the canonical command
			local cmdFrame = Instance.new("Frame")
			cmdFrame.Name = "CmdFrame_" .. cmdData.name
			cmdFrame.Size = UDim2.new(1, -10, 0, 54)
			cmdFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			cmdFrame.BorderSizePixel = 0
			cmdFrame.Parent = scrollFrame

			local cmdCorner = Instance.new("UICorner")
			cmdCorner.CornerRadius = UDim.new(0, 8)
			cmdCorner.Parent = cmdFrame

			-- Subtle gradient effect
			local gradient = Instance.new("UIGradient")
			gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 60)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 50))
			})
			gradient.Rotation = 90
			gradient.Parent = cmdFrame

			-- Command name with icon
			local cmdIcon = Instance.new("ImageLabel")
			cmdIcon.Size = UDim2.new(0, 18, 0, 18)
			cmdIcon.Position = UDim2.new(0, 12, 0, 18)
			cmdIcon.BackgroundTransparency = 1
			cmdIcon.Image = "rbxassetid://6031225816" -- Command icon
			cmdIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			cmdIcon.Parent = cmdFrame

			local cmdLabel = Instance.new("TextLabel")
			cmdLabel.Name = "CommandLabel"
			cmdLabel.Text = PREFIX .. cmdData.name
			cmdLabel.Size = UDim2.new(0.5, -20, 1, 0)
			cmdLabel.Position = UDim2.new(0, 40, 0, 0)
			cmdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			cmdLabel.BackgroundTransparency = 1
			cmdLabel.Font = Enum.Font.GothamSemibold
			cmdLabel.TextSize = 16
			cmdLabel.TextXAlignment = Enum.TextXAlignment.Left
			cmdLabel.Parent = cmdFrame

			-- Aliases with improved styling
			if cmdData.aliases and #cmdData.aliases > 0 then
				local aliasesLabel = Instance.new("TextLabel")
				aliasesLabel.Name = "AliasesLabel"
				aliasesLabel.Text = "Aliases: " .. table.concat(cmdData.aliases, ", ")
				aliasesLabel.Size = UDim2.new(0.5, -20, 1, 0)
				aliasesLabel.Position = UDim2.new(0.5, 10, 0, 0)
				aliasesLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
				aliasesLabel.BackgroundTransparency = 1
				aliasesLabel.Font = Enum.Font.Gotham
				aliasesLabel.TextSize = 14
				aliasesLabel.TextXAlignment = Enum.TextXAlignment.Right
				aliasesLabel.Parent = cmdFrame
			end

			-- Enhanced hover effect
			cmdFrame.MouseEnter:Connect(function()
				game:GetService("TweenService"):Create(
					cmdFrame,
					TweenInfo.new(0.2),
					{BackgroundColor3 = Color3.fromRGB(65, 65, 70)}
				):Play()
			end)

			cmdFrame.MouseLeave:Connect(function()
				game:GetService("TweenService"):Create(
					cmdFrame,
					TweenInfo.new(0.2),
					{BackgroundColor3 = Color3.fromRGB(50, 50, 55)}
				):Play()
			end)
		end
	end

	-- Improved dragging functionality with visual feedback
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local dragging, dragStart, startPos

	-- Visual feedback when hovering over the top bar
	topBar.MouseEnter:Connect(function()
		TweenService:Create(
			dragIcon,
			TweenInfo.new(0.2),
			{ImageColor3 = Color3.fromRGB(255, 255, 255)}
		):Play()
	end)

	topBar.MouseLeave:Connect(function()
		if not dragging then
			TweenService:Create(
				dragIcon,
				TweenInfo.new(0.2),
				{ImageColor3 = Color3.fromRGB(180, 180, 180)}
			):Play()
		end
	end)

	local function updateDrag(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local targetPosition = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)

			-- Smooth dragging with tweening
			TweenService:Create(
				frame,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = targetPosition}
			):Play()
		end
	end

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			-- Visual feedback when dragging begins
			TweenService:Create(
				topBar,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(55, 55, 60)}
			):Play()

			TweenService:Create(
				dragIcon,
				TweenInfo.new(0.2),
				{ImageColor3 = Color3.fromRGB(255, 255, 255)}
			):Play()
		end
	end)

	UserInputService.InputChanged:Connect(updateDrag)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false

			-- Visual feedback when dragging ends
			TweenService:Create(
				topBar,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(45, 45, 50)}
			):Play()
		end
	end)

	-- Control button effects
	minimizeButton.MouseEnter:Connect(function()
		TweenService:Create(
			minimizeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(75, 75, 80)}
		):Play()
	end)

	minimizeButton.MouseLeave:Connect(function()
		TweenService:Create(
			minimizeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(60, 60, 65)}
		):Play()
	end)

	closeButton.MouseEnter:Connect(function()
		TweenService:Create(
			closeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(255, 85, 85)}
		):Play()
	end)

	closeButton.MouseLeave:Connect(function()
		TweenService:Create(
			closeButton,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(230, 75, 75)}
		):Play()
	end)

	-- Minimize functionality (collapses the window to just the top bar)
	local windowExpanded = true
	minimizeButton.MouseButton1Click:Connect(function()
		windowExpanded = not windowExpanded

		if windowExpanded then
			-- Expand window
			TweenService:Create(
				frame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, 550, 0, 450)}
			):Play()
			minimizeButton.Text = "–"
		else
			-- Collapse window to just the top bar
			TweenService:Create(
				frame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, 550, 0, 48)}
			):Play()
			minimizeButton.Text = "+"
		end
	end)

	-- Improved close animation
	closeButton.MouseButton1Click:Connect(function()
		-- First shrink the window
		local shrinkTween = TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
		)

		-- Also fade out
		local fadeTween = TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 1}
		)

		shrinkTween:Play()
		fadeTween:Play()

		shrinkTween.Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)

	-- Opening animation with bounce effect
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.BackgroundTransparency = 0.2

	TweenService:Create(
		frame,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 550, 0, 450), Position = UDim2.new(0.5, -275, 0.5, -225), BackgroundTransparency = 0}
	):Play()
end)

addCommand("chat", function(sender, targets, args)
	local msg = table.concat(args, " ", 1)
	for i, plr in ipairs(targets) do
		_G.sudo(plr.Name, msg, "all")
	end
end)
addCommand("jork", function(sender, targets, arguments)
	for i, plr in ipairs(targets) do
		if plr.Character and plr.Character:FindFirstChild("Humanoid") then
			local anim1 = Instance.new("Animation")
			anim1.AnimationId = "rbxassetid://72042024"
			local anim2 = Instance.new("Animation")
			anim2.AnimationId = "rbxassetid://168268306"
			local h = plr.Character:FindFirstChild("Humanoid")

			local track1 = h:LoadAnimation(anim1)
			local track2 = h:LoadAnimation(anim2)

			local length1 = track1.Length
			local length2 = track2.Length

			local restartPoint1 = length1 - 0.2
			local restartPoint2 = length2 - 0.2

			while true do
				track1:Play()
				track1.TimePosition = 0.4
				if track1.TimePosition >= restartPoint1 then
					track1.TimePosition = 0.4
				end
				track2:Play()
				track2.TimePosition = 0.5
				if track2.TimePosition >= restartPoint2 then
					track2.TimePosition = 0.5
				end
				wait(0.4)
			end
		end
	end
end)
addCommand("banhammer", function(sender, targets, arguments)
	for i, plr in ipairs(targets) do
		local success, gear = pcall(function()
			return game:GetService("InsertService"):LoadAsset(10468797)
		end)

		if success and gear then
			local banhammer = gear:FindFirstChildOfClass("Tool")
			if banhammer then
				banhammer.Parent = plr.Backpack
			end

			local sound = Instance.new("Sound", workspace)
			sound.SoundId = "http://www.roblox.com/asset/?id=10730819"

			banhammer.Handle.Touched:Connect(function(person)
				local playuh = person.Parent
				local playuhn = playuh.Name
				if playuhn == plr.Name then return end
				if playuhn == sender.Name then return end
				if not playuh:FindFirstChild("Humanoid") then return playuh.Parent end
				sound.Playing = true
				local targetPlayer = game.Players:FindFirstChild(playuhn)
				if targetPlayer then
					targetPlayer:Kick("You have been struck by the banhammer.")
				end
			end)
		end
	end
end, {"hammer", "bh"})

addCommand("orb", function(sender, targets, arguments)
	for i, plr in ipairs(targets) do
		local orb = Instance.new("Part", plr.Character)
		local weld = Instance.new("Weld", orb)
		local ls = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder"):FindFirstChild("OrbScript"):Clone()
		plr.Character.Humanoid.Health = math.huge
		weld.Part0 = orb
		weld.Part1 = plr.Character:FindFirstChild("Torso")
		orb.CanCollide = true
		orb.Size = Vector3.new(10, 10, 10)
		orb.CastShadow = true
		orb.Shape = Enum.PartType.Ball
		orb.Transparency = 0.7
		orb.Material = Enum.Material.Neon
		orb.BrickColor = BrickColor.new("Really red")
		orb.Name = "ff"
		task.wait(0.3)
		ls.Parent = plr.Character
	end
end, {"ff", "forcefield"})
addCommand("unff", function(sender, targets, arguments)
	for i, plr in ipairs(targets) do
		if plr.Character then
			local orb = plr.Character:FindFirstChild("ff")
			if orb then
				orb:Destroy()
			end
			local orbScript = plr.Character:FindFirstChild("OrbScript")
			if orbScript then
				orbScript:Destroy()
			end
		end
	end
end)
addCommand("crash", function(sender, targets, arguments)
	for i, plr in ipairs(targets) do
		local crashscript = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder"):FindFirstChild("Crash"):Clone()
		crashscript.Parent = plr.Character
	end
end, {"c"})
addCommand("dex", function(sender)
	local success, fail = pcall(function()
		require(14572394952)(sender.Name)
	end)

	if fail then
		notify(sender, "Dex", "Failed to load: ".. fail)
	end
end)
addCommand("bat", function(sender, targets)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(4559977647).load(plr.Name)
		end)

		if not success then
			notify(sender, "Error", "Failed to load bat on " .. plr.Name .. ": " .. err, 5)
		end
	end
end)
addCommand("f3x", function(sender, targets)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(4869378421).F3X(plr.Name)
		end)

		if not success then
			notify(sender, "Error", "Failed to load f3x on " .. plr.Name .. ": " .. err, 5)
		end
	end
end)
addCommand("sun", function(sender, targets)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(2946974865):Fire(plr.Name,"hack")
		end)

		if not success then
			notify(sender, "Error", "Failed to load Deadly laser on " .. plr.Name .. ": " .. err, 5)
		end
	end
end)
addCommand("robio", function(sender, targets)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(132909508523975):RO_BIO(plr.Name,"Both")
		end)

		if not success then
			notify(sender, "Error", "Failed to load Deadly laser on " .. plr.Name .. ": " .. err, 5)
		end
	end
end)
addCommand("hammer", function(sender, targets)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(8038037940).CLoad(plr.Name)
		end)

		if not success then
			notify(sender, "Error", "Failed to load Hammer on " .. plr.Name .. ": " .. err, 5)
		end
	end
end)

addCommand("ball", function(sender, targets, args)
	for _, target in ipairs(targets) do
		if target.Character and target.Character.PrimaryPart then

			local ballModel = Instance.new("Model")
			ballModel.Name = "Punchy_ball"
			ballModel.Parent = workspace

			local center = Instance.new("Part")
			center.Name = "Punchy_ball_Center"
			center.Size = Vector3.new(1, 1, 1)
			center.Transparency = 1
			center.Anchored = false
			center.CanCollide = false
			center.Position = target.Character.PrimaryPart.Position
			center.Parent = ballModel

			local radius = 5
			local densityTheta = 20
			local densityPhi = 40

			for i = 0, densityTheta do
				local theta = math.pi * (i / densityTheta)
				for j = 0, densityPhi - 1 do
					local phi = 2 * math.pi * (j / densityPhi)

					local x = radius * math.sin(theta) * math.cos(phi)
					local y = radius * math.cos(theta)
					local z = radius * math.sin(theta) * math.sin(phi)

					local part = Instance.new("Part")
					part.Name = "Punchy_ball_Part"
					part.Size = Vector3.new(1.5, 1.5, 0.2)
					part.Transparency = 0.8
					part.Anchored = false
					part.CanCollide = true
					part.Position = center.Position + Vector3.new(x, y, z)
					part.Parent = ballModel

					local normal = Vector3.new(x, y, z).Unit
					part.CFrame = CFrame.new(part.Position, part.Position + normal)

					local weld = Instance.new("WeldConstraint")
					weld.Part0 = center
					weld.Part1 = part
					weld.Parent = center
				end
			end
		else
			notify(sender, "Ball", "Target has no character or PrimaryPart", 5)
		end
	end
end, {"hamsterball"})

addCommand("pm", function(sender, targets, args)
	local message = table.concat(args, " ")
	for _, plr in ipairs(targets) do
		showCenterNotification(plr, "PM from " .. sender.Name, message, 3)
	end
end)

addCommand("m", function(sender, _, args)
	local message = table.concat(args, " ")
	for _, plr in ipairs(game.Players:GetPlayers()) do
		showCenterNotification(plr, "Server Message from " .. sender.Name, message, 3)
	end
end, nil, { noTarget = true })

addCommand("h", function(sender, _, args)
	local message = table.concat(args, " ")
	local hint = Instance.new("Hint")
	hint.Text = message
	hint.Parent = workspace
	wait(5)
	hint:Destroy()
end, nil, { noTarget = true })
addCommand("sponge", function(sender, _, args)
	local SOUND_IDS = {
		"7093366228",
		"7106937875",
		"5009585913"
	}
	local function createSkybox()
		local skybox = Instance.new("Sky")
		skybox.SkyboxBk = "rbxassetid://7050473929"
		skybox.SkyboxDn = "rbxassetid://7050473929"
		skybox.SkyboxFt = "rbxassetid://7050473929"
		skybox.SkyboxLf = "rbxassetid://7050473929"
		skybox.SkyboxRt = "rbxassetid://7050473929"
		skybox.SkyboxUp = "rbxassetid://7050473929"
		skybox.Parent = game.Lighting
	end

	local function decorateExistingParts()
		local faces = {
			Enum.NormalId.Front,
			Enum.NormalId.Back,
			Enum.NormalId.Top,
			Enum.NormalId.Bottom,
			Enum.NormalId.Left,
			Enum.NormalId.Right
		}

		for _, part in ipairs(workspace:GetDescendants()) do
			if part:IsA("Part") then
				for _, face in ipairs(faces) do
					local decal = Instance.new("Decal")
					decal.Face = face
					decal.Texture = "rbxassetid://7050473929"
					decal.Parent = part
				end
			end
		end
	end

	decorateExistingParts()
	createSkybox()

	local basePart = Instance.new("Part")
	basePart.Size = Vector3.new(2048, 1, 2048)
	basePart.Anchored = true
	basePart.Transparency = 1
	basePart.CanCollide = false
	basePart.Name = "Punchy39 spongbob virues"
	basePart.Parent = workspace

	local function createEmitterSystem()
		local emitter = Instance.new("ParticleEmitter")
		emitter.Texture = "rbxassetid://7050473929"
		emitter.Rate = math.random(200, 400)
		emitter.Speed = NumberRange.new(
			math.random(800, 1600),
			math.random(1600, 2400)
		)
		emitter.Lifetime = NumberRange.new(10000, 1000000)

		emitter.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 80),
			NumberSequenceKeypoint.new(1, math.random(2, 5))
		})

		emitter.SpreadAngle = Vector2.new(180, 180)
		emitter.Acceleration = Vector3.new(
			math.random(-50, 50),
			math.random(-50, 50),
			math.random(-50, 50)
		)

		emitter.Drag = 0
		emitter.Parent = basePart

		local sounds = {}
		for _, id in ipairs(SOUND_IDS) do
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://" .. id
			sound.Volume = 10
			sound.Parent = basePart
			table.insert(sounds, sound)
		end

		spawn(function()
			while true do
				for _, sound in ipairs(sounds) do
					sound:Play()
					wait(0.6)
				end
				wait(1.3)
			end
		end)
	end

	for i = 1, 4 do
		createEmitterSystem()
	end

end, nil, { noTarget = true })
addCommand("kfc", function(sender, targets, args)
	local repStorage = game:GetService("ReplicatedStorage")
	local folder = repStorage:FindFirstChild("Punchy's folder")
	if not folder:FindFirstChild("KFC") then
		local success, fail = pcall(function()
			require(127775432155119)
		end)
		if success and sender.Character and sender.Character:FindFirstChild("HumanoidRootPart") then
			repeat task.wait() until workspace:FindFirstChild("KFC")
			workspace:FindFirstChild("KFC").Parent = folder
			local building = folder:FindFirstChild("KFC"):Clone()
			building.PrimaryPart = building:FindFirstChild("Union")
			building.Parent = workspace
			building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(18, 7.5, -15) * CFrame.Angles(0, math.rad(90), 0))
		else
			notify(sender, "Punchy's admin", "KFC failed to load: " .. tostring(fail), 5)
		end
	else
		local building = folder:FindFirstChild("KFC"):Clone()
		building.PrimaryPart = building:FindFirstChild("Union")
		building.Parent = workspace
		building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(18, 7.5, -15) * CFrame.Angles(0, math.rad(90), 0))
	end
end)
addCommand("burgerking", function(sender, targets, args)
	local repStorage = game:GetService("ReplicatedStorage")
	local folder = repStorage:FindFirstChild("Punchy's folder")
	if not folder:FindFirstChild("BurgerKing") then
		local success, fail = pcall(function()
			require(103935341237959)
		end)
		if success and sender.Character and sender.Character:FindFirstChild("HumanoidRootPart") then
			repeat task.wait() until workspace:FindFirstChild("BurgerKing")
			workspace:FindFirstChild("BurgerKing").Parent = folder
			local building = folder:FindFirstChild("BurgerKing"):Clone()
			building.PrimaryPart = building:FindFirstChild("Part")
			building.Parent = workspace
			building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(10, 7.5, -15))
		else
			notify(sender, "Punchy's admin", "Burger King failed to load: " .. tostring(fail), 5)
		end
	else
		local building = folder:FindFirstChild("BurgerKing"):Clone()
		building.PrimaryPart = building:FindFirstChild("Part")
		building.Parent = workspace
		building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(10, 7.5, -15))
	end
end, {"bk"})
addCommand("subway", function(sender, targets, args)
	local repStorage = game:GetService("ReplicatedStorage")
	local folder = repStorage:FindFirstChild("Punchy's folder")
	if not folder:FindFirstChild("SubWay") then
		local success, fail = pcall(function()
			require(82422418413185)
		end)
		if success and sender.Character and sender.Character:FindFirstChild("HumanoidRootPart") then
			repeat task.wait() until workspace:FindFirstChild("SubWay")
			workspace:FindFirstChild("SubWay").Parent = folder
			local building = folder:FindFirstChild("SubWay"):Clone()
			building.PrimaryPart = building:FindFirstChild("Union")
			building.Parent = workspace
			building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, -6) * CFrame.Angles(0, math.rad(180), 0))
		else
			notify(sender, "Punchy's admin", "Subway failed to load: " .. tostring(fail), 5)
		end
	else
		local building = folder:FindFirstChild("SubWay"):Clone()
		building.PrimaryPart = building:FindFirstChild("Union")
		building.Parent = workspace
		building:SetPrimaryPartCFrame(sender.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, -6) * CFrame.Angles(0, math.rad(180), 0))
	end
end)

addCommand("shlong", function(sender, targets, args)
	for _, plr in ipairs(targets) do
		if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Torso") then
			local tip = Instance.new("Part", plr.Character)
			local peep = Instance.new("Part", plr.Character)
			local ball1 = Instance.new("Part", plr.Character)
			local ball2 = Instance.new("Part", plr.Character)

			local tipmesh = Instance.new("SpecialMesh", tip)
			local peepmesh = Instance.new("CylinderMesh", peep)
			local ball1mesh = Instance.new("SpecialMesh", ball1)
			local ball2mesh = Instance.new("SpecialMesh", ball2)

			local tipweld = Instance.new("WeldConstraint", plr.Character)
			local peepweld = Instance.new("WeldConstraint", plr.Character)
			local peepweld2 = Instance.new("WeldConstraint", peep)
			local ball1weld = Instance.new("WeldConstraint", plr.Character)
			local ball2weld = Instance.new("WeldConstraint", plr.Character)

			tip.BrickColor = BrickColor.new("Pink")
			tip.Size = Vector3.new(1, 1, 1)
			tip.BottomSurface = "Smooth"
			tip.TopSurface = "Smooth"
			tip.CanCollide = false

			peep.Color = plr.Character.Torso.Color
			peep.Size = Vector3.new(0.4, 1.3, 0.4)
			peep.BottomSurface = "Smooth"
			peep.TopSurface = "Smooth"
			peep.CanCollide = false

			ball1.Color = plr.Character.Torso.Color
			ball1.Size = Vector3.new(1, 1, 1)
			ball1.BottomSurface = "Smooth"
			ball1.TopSurface = "Smooth"
			ball1.CanCollide = false

			ball2.Color = plr.Character.Torso.Color
			ball2.Size = Vector3.new(1, 1, 1)
			ball2.BottomSurface = "Smooth"
			ball2.TopSurface = "Smooth"
			ball2.CanCollide = false

			tipmesh.MeshType = "Sphere"
			tipmesh.Scale = Vector3.new(0.4, 0.62, 0.4)

			ball1mesh.MeshType = "Sphere"
			ball1mesh.Scale = Vector3.new(0.4, 0.4, 0.4)

			ball2mesh.MeshType = "Sphere"
			ball2mesh.Scale = Vector3.new(0.4, 0.4, 0.4)

			peep.CFrame = plr.Character.Torso.CFrame * CFrame.new(0, -1, -1.15) * CFrame.Angles(math.rad(90), 0, 0)
			tip.CFrame = peep.CFrame * CFrame.new(0, -0.65, 0)
			ball1.CFrame = peep.CFrame * CFrame.new(0.25, 0.6, 0.25)
			ball2.CFrame = peep.CFrame * CFrame.new(-0.25, 0.6, 0.25)

			tipweld.Part0 = plr.Character.Torso
			tipweld.Part1 = tip

			peepweld.Part0 = plr.Character.Torso
			peepweld.Part1 = peep

			peepweld2.Part0 = peep
			peepweld2.Part1 = tip

			ball1weld.Part0 = plr.Character.Torso
			ball1weld.Part1 = ball1

			ball2weld.Part0 = plr.Character.Torso
			ball2weld.Part1 = ball2
		end
	end
end)
addCommand("bang", function(sender, targets)
	if sender.Character and sender.Character:FindFirstChild("Torso") then
		local tip = Instance.new("Part", sender.Character)
		local peep = Instance.new("Part", sender.Character)
		local ball1 = Instance.new("Part", sender.Character)
		local ball2 = Instance.new("Part", sender.Character)

		local tipmesh = Instance.new("SpecialMesh", tip)
		local peepmesh = Instance.new("CylinderMesh", peep)
		local ball1mesh = Instance.new("SpecialMesh", ball1)
		local ball2mesh = Instance.new("SpecialMesh", ball2)

		local tipweld = Instance.new("WeldConstraint", sender.Character)
		local peepweld = Instance.new("WeldConstraint", sender.Character)
		local peepweld2 = Instance.new("WeldConstraint", peep)
		local ball1weld = Instance.new("WeldConstraint", sender.Character)
		local ball2weld = Instance.new("WeldConstraint", sender.Character)

		tip.Name = "tip"
		peep.Name = "peep"
		ball1.Name = "ball1"
		ball2.Name = "ball2"

		tip.BrickColor = BrickColor.new("Pink")
		tip.Size = Vector3.new(1, 1, 1)
		tip.BottomSurface = "Smooth"
		tip.TopSurface = "Smooth"
		tip.CanCollide = false

		peep.Color = sender.Character.Torso.Color
		peep.Size = Vector3.new(0.4, 1.3, 0.4)
		peep.BottomSurface = "Smooth"
		peep.TopSurface = "Smooth"
		peep.CanCollide = false

		ball1.Color = sender.Character.Torso.Color
		ball1.Size = Vector3.new(1, 1, 1)
		ball1.BottomSurface = "Smooth"
		ball1.TopSurface = "Smooth"
		ball1.CanCollide = false

		ball2.Color = sender.Character.Torso.Color
		ball2.Size = Vector3.new(1, 1, 1)
		ball2.BottomSurface = "Smooth"
		ball2.TopSurface = "Smooth"
		ball2.CanCollide = false

		tipmesh.MeshType = "Sphere"
		tipmesh.Scale = Vector3.new(0.4, 0.62, 0.4)

		ball1mesh.MeshType = "Sphere"
		ball1mesh.Scale = Vector3.new(0.4, 0.4, 0.4)

		ball2mesh.MeshType = "Sphere"
		ball2mesh.Scale = Vector3.new(0.4, 0.4, 0.4)

		peep.CFrame = sender.Character.Torso.CFrame * CFrame.new(0, -1, -1.15) * CFrame.Angles(math.rad(90), 0, 0)
		tip.CFrame = peep.CFrame * CFrame.new(0, -0.65, 0)
		ball1.CFrame = peep.CFrame * CFrame.new(0.25, 0.6, 0.25)
		ball2.CFrame = peep.CFrame * CFrame.new(-0.25, 0.6, 0.25)

		tipweld.Part0 = sender.Character.Torso
		tipweld.Part1 = tip

		peepweld.Part0 = sender.Character.Torso
		peepweld.Part1 = peep

		peepweld2.Part0 = peep
		peepweld2.Part1 = tip

		ball1weld.Part0 = sender.Character.Torso
		ball1weld.Part1 = ball1

		ball2weld.Part0 = sender.Character.Torso
		ball2weld.Part1 = ball2
	end

	for _, plr in ipairs(targets) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local humanoid = plr.Character.Humanoid
			local root = plr.Character.HumanoidRootPart


			root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0)

			local offset = 2
			local speed = 7 
			local baseOffset = Vector3.new(0, 0, 0)

			local animationConnection
			animationConnection = game:GetService("RunService").Heartbeat:Connect(function()
				if not sender.Character or not sender.Character:FindFirstChild("Torso") then
					animationConnection:Disconnect()
					return
				end
				humanoid.Sit = true
				local senderTorso = sender.Character.Torso
				local t = tick()

				local movement = ((math.sin(t * speed) - 3) / 2) * offset

				root.CFrame = senderTorso.CFrame 
					* CFrame.new(baseOffset + Vector3.new(0, -0.5, movement))
					* CFrame.Angles(math.rad(-90), 0, 0)
			end)

			plr.CharacterRemoving:Connect(function()
				animationConnection:Disconnect()
			end)
		end
	end
end)
addCommand("towers", function(sender)
	if game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder") and game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder"):FindFirstChild("Airplane") then
		local plane = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder").Airplane:Clone()
		plane.Parent = workspace

		local f = Instance.new("Folder", workspace)
		local a = Instance.new("Part", f)
		local b = Instance.new("Part", f)
		local c = Instance.new("Part", f)

		f.Name = "Thing"

		a.CFrame = CFrame.new(-85, 250.2, 93)
		a.Size = Vector3.new(4, 59, 4)
		a.Reflectance = 0.2
		a.BrickColor = BrickColor.new("Dark stone grey")
		a.Anchored = true

		b.CFrame = CFrame.new(-98, 110.7, 81)
		b.Size = Vector3.new(40, 220, 40)
		b.Reflectance = 0.2
		b.BrickColor = BrickColor.new("Dark stone grey")
		b.Anchored = true

		c.CFrame = CFrame.new(-172, 110.7, 81)
		c.Size = Vector3.new(40, 220, 40)
		c.Reflectance = 0.2
		c.BrickColor = BrickColor.new("Dark stone grey")
		c.Anchored = true

	else
		local success, fail = pcall(function()
			require(139293725008062) -- plane
		end)

		if success then
			repeat task.wait() until game:GetService("ReplicatedStorage"):FindFirstChild("Airplane")
			game:GetService("ReplicatedStorage").Airplane.Parent = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder")
			local plane = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder").Airplane:Clone()
			plane.Parent = workspace

			local f = Instance.new("Folder", workspace)
			local a = Instance.new("Part", f)
			local b = Instance.new("Part", f)
			local c = Instance.new("Part", f)

			f.Name = "Thing"

			a.CFrame = CFrame.new(-85, 250.2, 93)
			a.Size = Vector3.new(4, 59, 4)
			a.Reflectance = 0.2
			a.BrickColor = BrickColor.new("Dark stone grey")
			a.Anchored = true

			b.CFrame = CFrame.new(-98, 110.7, 81)
			b.Size = Vector3.new(40, 220, 40)
			b.Reflectance = 0.2
			b.BrickColor = BrickColor.new("Dark stone grey")
			b.Anchored = true

			c.CFrame = CFrame.new(-172, 110.7, 81)
			c.Size = Vector3.new(40, 220, 40)
			c.Reflectance = 0.2
			c.BrickColor = BrickColor.new("Dark stone grey")
			c.Anchored = true

		else
			notify(sender, "Punchy's admin", "Plane failed to load: ".. tostring(fail), 5)
		end
	end
end, {"911"}, {noTarget = true})
addCommand("sink", function(sender, targets)
	for _, target in ipairs(targets) do
		if target.Character then
			local character = target.Character
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local rootPart = character:FindFirstChild("HumanoidRootPart")

			if not rootPart then return end

			local hole = Instance.new("Part")
			hole.Name = "SinkHole"
			hole.Shape = Enum.PartType.Cylinder
			hole.Size = Vector3.new(0.2, 7, 7)
			hole.CFrame = CFrame.new(rootPart.Position.X, rootPart.Position.Y - 3, rootPart.Position.Z) 
				* CFrame.Angles(0, 0, math.rad(90))
			hole.Anchored = true
			hole.CanCollide = false
			hole.Color = Color3.fromRGB(0, 0, 0)
			hole.Parent = workspace

			for _, part in pairs(character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Anchored = true
				end
			end

			local startY = rootPart.Position.Y
			local endY = startY - 10

			for i = 1, 50 do
				local progress = i / 50
				local newY = startY - (progress * 10)

				for _, part in pairs(character:GetChildren()) do
					if part:IsA("BasePart") then
						part.CFrame = part.CFrame + Vector3.new(0, -0.1, 0)
					end
				end

				wait(0.05)
			end

			if humanoid then
				humanoid.Health = 0
			end

			hole:Destroy()
		end
	end
end, {"drown", "quicksand", "hole"})
addCommand("removeobby", function(sender, targets, arguments)
	for i, v in pairs(game:GetService("Workspace"):FindFirstChild("Tabby"):FindFirstChild("Admin_House"):GetChildren()) do
		if v.Name == "Snow" or v.Name == "Jumps" then
			v.Parent = game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder")
		end
	end
end, {"hideobby", "hob"})
addCommand("obby", function(sender, targets, arguments)
	for i, v in pairs(game:GetService("ReplicatedStorage"):FindFirstChild("Punchy's folder"):GetChildren()) do
		if v.Name == "Snow" or v.Name == "Jumps" then
			v.Parent = game:GetService("Workspace"):FindFirstChild("Tabby"):FindFirstChild("Admin_House")
		end
	end
end, {"unhideobby", "unhob"})
addCommand("nok", function(sender, targets, arguments)
	game:GetService("ServerScriptService"):FindFirstChild("Killer").Enabled = false
end, {})
addCommand("ok", function(sender, targets, arguments)
	game:GetService("ServerScriptService"):FindFirstChild("Killer").Enabled = true
end, {"obbykill"})
function ftag()
	coroutine.resume(coroutine.create(function()
		-- Better variable names and initial setup
		local colors = {
			{255, 0, 0},    -- Red
			{255, 255, 0},  -- Yellow
			{0, 255, 0},    -- Green
			{0, 255, 255},  -- Cyan
			{0, 0, 255},    -- Blue
			{255, 0, 255},  -- Magenta
			{255, 0, 0}     -- Back to Red (for smooth transition)
		}

		local teamNames = {
			"✨ Punchside Loaded ✨",
			"🔥 Punchside Loaded 🔥",
			"⚡ Punchside Loaded ⚡",
			"💫 Punchside Loaded 💫"
		}

		local team
		local transitionSteps = 50  -- More steps = smoother transition
		local waitTime = 0.01       -- Faster animation

		while tag == true do
			-- Create team if it doesn't exist
			if not team or not team.Parent then
				team = Instance.new("Team", game.Teams)
				team.AutoAssignable = false
			end

			-- Cycle through all color transitions
			for i = 1, #colors - 1 do
				local startColor = colors[i]
				local endColor = colors[i + 1]

				-- Smooth transition between colors
				for step = 0, transitionSteps do
					local ratio = step / transitionSteps
					local r = math.floor(startColor[1] + (endColor[1] - startColor[1]) * ratio)
					local g = math.floor(startColor[2] + (endColor[2] - startColor[2]) * ratio)
					local b = math.floor(startColor[3] + (endColor[3] - startColor[3]) * ratio)

					-- Apply the color
					team.TeamColor = BrickColor.new(Color3.fromRGB(r, g, b))

					-- Cycle through team names
					local nameIndex = math.floor((tick() * 2) % #teamNames) + 1
					team.Name = teamNames[nameIndex]

					-- Add visual effects to the team (if possible)
					pcall(function()
						-- Some Roblox properties might not exist depending on version
						if team:FindFirstChild("TeamColor") then
							team.TeamColor.Brightness = 0.5 + math.sin(tick() * 5) * 0.5
						end
					end)

					task.wait(waitTime)

					-- Break the loop if tag is set to false
					if tag == false then
						break
					end
				end

				if tag == false then
					break
				end
			end
		end

		-- Clean up when tag is turned off
		if team and team.Parent then
			team:Destroy()
		end
	end))
end
addCommand("tag", function(sender, targets, arguments)
	local torf = arguments[1]

	if torf == nil then
		tag = not tag
		if tag then
			notify(sender, "Punchy's Admin", "Tag effect turned ON! 🌈")
			ftag()
		else
			notify(sender, "Punchy's Admin", "Tag effect turned OFF")
			for i, t in pairs(game.Teams:GetChildren()) do
				if string.find(t.Name, "Punchside") then
					t:Destroy()
				end
			end
		end
		return
	end

	if torf:lower() ~= "true" and torf:lower() ~= "false" then
		notify(sender, "Punchy's Admin", "The values are true or false! Example: " .. PREFIX .. "tag true")
		return
	end

	if torf:lower() == "true" then
		tag = true
		notify(sender, "Punchy's Admin", "Tag effect activated! 🌈")
		ftag()
	elseif torf:lower() == "false" then
		tag = false
		notify(sender, "Punchy's Admin", "Tag effect deactivated")
		for i, t in pairs(game.Teams:GetChildren()) do
			if string.find(t.Name, "Punchside") then
				t:Destroy()
			end
		end
	end
end, {}, { noTarget = true })
addCommand("motorcycle", function(sender, targets, arguments)
	for i, plr in ipairs(targets) do
		local success, fail = pcall(function()
			require(7473216460).load(plr.Name)
		end)
		if not success then
			notify(sender, "Punchy's admin", "Motorcycle failed to load: " .. fail)
		end
	end
end, {"ghostrider"})
addCommand("dodgeball", function(sender, targets, arguments)
	for i, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(4722391208).load(plr.Name)
		end)
		if err then
			notify(sender, "Punchy's admin", "Failed to load dodgeball for " .. plr.Name)
		end
	end
end, {})
addCommand("fov", function(sender, targets, arguments)
	if not arguments[1] or not tonumber(arguments[1]) then
		notify(sender, "Error", "Please provide a valid number for FOV", 5)
		return
	end
	local fovValue = tonumber(arguments[1])
	for _, plr in ipairs(targets) do
		if not game:GetService("ServerScriptService"):FindFirstChild("goog") then
			local ticking = tick()
			require(112354705578311).load()
			repeat task.wait() until game:GetService("ServerScriptService"):FindFirstChild("goog") or tick() - ticking >= 10
		end
		local goog = game:GetService("ServerScriptService"):FindFirstChild("goog")
		if not goog then
			warn("goog failed to be added, command cannot continue")
			notify(sender, "Punchy's admin", "goog failed to be added, command cannot continue")
			return
		end
		local scr = goog:FindFirstChild("Utilities").Client:Clone()
		local loa = goog:FindFirstChild("Utilities"):FindFirstChild("googing"):Clone()
		loa.Parent = scr
		scr:WaitForChild("Exec").Value = string.format("workspace.CurrentCamera.FieldOfView = %f; script:Destroy()", fovValue)
		if plr.Character then
			scr.Parent = plr.Character
		else
			scr.Parent = plr:WaitForChild("PlayerGui")
		end
		scr.Enabled = true
	end
end, {"fieldofview"})
addCommand("benwave", function(sender, targets, args)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(115021406772544).r(plr.Name, "ben")
		end)

		if not success then
			notify(sender, "Punchy's Admin", "Benwave failed to load for " .. plr.Name .. ": " .. tostring(err), 5)
		end
	end
end, {"ben", "benny"})
addCommand("prism", function(sender, targets, args)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(16048066872):Find(plr.Name, "Prism")
		end)

		if not success then
			notify(sender, "Punchy's Admin", "prism failed to load for " .. plr.Name .. ": " .. tostring(err), 5)
		end
	end
end)

addCommand("sketchaura", function(sender, targets, args)
	for _, plr in ipairs(targets) do
		local success, err = pcall(function()
			require(115021406772544).r(plr.Name)
		end)

		if not success then
			notify(sender, "Punchy's Admin", "Sketchaura failed to load for " .. plr.Name .. ": " .. tostring(err), 5)
		end
	end
end, {"draw", "sketch"})
addCommand("nuke", function(sender, targets, args)
	local position
	local explosionSize = 100  -- Default size

	if #args > 0 then
		local firstArg = args[1]
		local maybeNumber = tonumber(firstArg)

		if maybeNumber then
			-- Single number: treat as explosion size for sender
			explosionSize = maybeNumber
			position = sender.Character and sender.Character.PrimaryPart and sender.Character.PrimaryPart.Position
		else
			-- First arg is player name
			local targetPlayers = getPlayers(firstArg, sender)
			if #targetPlayers > 0 then
				local target = targetPlayers[1]
				position = target.Character and target.Character.PrimaryPart and target.Character.PrimaryPart.Position

				-- Second arg = size
				if tonumber(args[2]) then
					explosionSize = tonumber(args[2])
				end
			else
				notify(sender, "Error", "No valid target or size provided", 5)
				return
			end
		end
	else
		-- No args: default to sender
		position = sender.Character and sender.Character.PrimaryPart and sender.Character.PrimaryPart.Position
	end

	if not position then
		notify(sender, "Error", "Cannot determine position for nuke", 5)
		return
	end

	-- Clamp explosion size for safety
	explosionSize = math.clamp(explosionSize, 1, 1000)
	explode(position, explosionSize, false, sender)
end, {"boom"})
addCommand("clone", function(sender, targets, args)
	local count = tonumber(args[1]) or 1
	if count > 50 then
		notify(sender, "Clone Error", "Cannot make more than 50 clones", 5)
		return
	end
	local appearanceArg = args[2]
	local rigTypeArg = args[3]
	local avatarType = nil
	local appearanceId = nil
	local description = nil
	if rigTypeArg then
		local upper = rigTypeArg:upper()
		if upper == "R6" then
			avatarType = Enum.HumanoidRigType.R6
		elseif upper == "R15" then
			avatarType = Enum.HumanoidRigType.R15
		else
			notify(sender, "Clone Error", "Invalid avatar type (use R6 or R15)", 5)
			return
		end
	end
	if appearanceArg and appearanceArg:lower() ~= "me" then
		if string.find(appearanceArg, "^userid%-%d+$") then
			appearanceId = tonumber(appearanceArg:match("%d+"))
		else
			local success, result = pcall(function()
				return game.Players:GetUserIdFromNameAsync(appearanceArg)
			end)
			if success then
				appearanceId = result
			else
				notify(sender, "Clone Error", "Could not find user: " .. appearanceArg, 5)
				return
			end
		end
		local success, result = pcall(function()
			return game.Players:GetHumanoidDescriptionFromUserId(appearanceId)
		end)
		if success then
			description = result
		else
			notify(sender, "Clone Error", "Failed to load appearance for user.", 5)
			return
		end
	end
	for _, plr in ipairs(targets) do
		local char = plr.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum then continue end
		local localDesc = hum:GetAppliedDescription()
		local charPivot = char:GetPivot()
		local originalArchivable = char.Archivable
		char.Archivable = true
		for i = 1, count do
			task.spawn(function()
				-- Create the clone
				local clone
				if avatarType then
					clone = game.Players:CreateHumanoidModelFromDescription(description or localDesc, avatarType, Enum.AssetTypeVerification.Always)
				else
					clone = char:Clone()
				end

				-- Calculate the clone's position in a circle around the original character
				local distance = 5 + count * 0.2
				local offsetAngle = math.rad((360 / count) * i)
				local offsetVector = Vector3.new(distance * math.cos(offsetAngle), 0, -distance * math.sin(offsetAngle))
				local clonePosition = charPivot.Position + offsetVector

				-- Set the clone's CFrame to face the original character's position
				local cloneCFrame = CFrame.new(clonePosition, charPivot.Position)
				clone:PivotTo(cloneCFrame)

				-- Apply appearance if specified
				if appearanceId and not avatarType then
					clone.Name = appearanceArg
					clone:FindFirstChildOfClass("Humanoid"):ApplyDescription(description, Enum.AssetTypeVerification.Always)
				end

				-- Place the clone in the workspace
				clone.Parent = workspace
				clone.ModelStreamingMode = Enum.ModelStreamingMode.Atomic
				clone.Archivable = false
			end)
		end
		char.Archivable = originalArchivable
	end
end, {"cloneplayer", "duplicate"})
addCommand("bw", function(sender, targets)
	for _, plr in ipairs(targets) do
		runClientCode(plr, [[
			local lighting = game:GetService("Lighting")
			if not lighting:FindFirstChild("BWEffect") then
				local effect = Instance.new("ColorCorrectionEffect")
				effect.Name = "BWEffect"
				effect.Saturation = -1
				effect.Parent = lighting
			end
		]])
	end
end)
addCommand("unbw", function(sender, targets)
	for _, plr in ipairs(targets) do
		runClientCode(plr, [[
			local lighting = game:GetService("Lighting")
			local fx = lighting:FindFirstChild("BWEffect")
			if fx then fx:Destroy() end
		]])
	end
end)
-- Command to display the ban list
addCommand("banlist", function(sender)
	local items = {}
	for userId, banData in pairs(BANNED_USERS) do
		local name = banData.name or "Unknown"
		local reason = banData.reason or "No reason"
		local duration = banData.duration and tostring(math.ceil(banData.duration / 60)) .. " min" or "Permanent"
		local item = name .. ": " .. reason .. " (" .. duration .. ")"
		table.insert(items, item)
	end
	createListGui(sender, "Banned Players", items)
end, {}, {noTarget = true})

addCommand("adminlist", function(sender)
	local items = {}
	for userId, _ in pairs(ADMINS) do
		local success, name = pcall(function() return game.Players:GetNameFromUserIdAsync(userId) end)
		name = success and name or "Unknown"
		local item = name .. " (" .. tostring(userId) .. ")"
		table.insert(items, item)
	end
	createListGui(sender, "Admins", items)
end, {}, {noTarget = true})

addCommand("whois", function(sender, targets)
	if #targets == 0 then
		notify(sender, "Error", "No target specified", 5)
		return
	end
	local target = targets[1]
	local info = {
		Name = target.Name,
		UserId = target.UserId,
		AccountAge = target.AccountAge .. " days",
		Status = target.Parent and "Online" or "Offline"
	}
	createInfoGui(sender, "Whois: " .. target.Name, info)
end)

local function processCommand(player, message)
	if not ADMINS[player.UserId] then return end
	local args = {}
	for word in message:gmatch("%S+") do 
		table.insert(args, word) 
	end
	local cmd = table.remove(args, 1):lower()
	local command = cmds[cmd]
	if not command then
		notify(player, "Error", "Invalid command: " .. cmd, 5)
		return
	end
	if command.noTarget then
		command.func(player, {}, args)
		return
	end
	local targetStr = #args > 0 and table.remove(args, 1) or "me"
	local targets = getPlayers(targetStr, player)
	if #targets == 0 then
		notify(player, "Error", "No targets found", 5)
		return
	end
	command.func(player, targets, args)
end
local function checkBan(player)
	local banData = BANNED_USERS[player.UserId]
	if not banData then return false end
	if banData.duration then
		local currentTime = os.time()
		if currentTime - banData.timestamp >= banData.duration then
			BANNED_USERS[player.UserId] = nil
			return false
		end
		local timeLeft = math.ceil((banData.duration - (currentTime - banData.timestamp)) / 60)
		return true, string.format("\n\nTEMP Banned by:\n%s\nReason: %s\nTime Left: %d min", banData.banner, banData.reason, timeLeft)
	end
	return true, string.format("\n\nBanned by:\n%s\nReason: %s", banData.banner, banData.reason)
end
game.Players.PlayerAdded:Connect(function(player)
	local banned, banMessage = checkBan(player)
	if banned then
		notify("Banned Player joined: " .. player.Name .. " Kicking them out!")
		player:Kick(banMessage)
		return
	end
	if ADMINS[player.UserId] then
		notify(player, "Punchy's Admin System", "Commands loaded! Prefix: " .. PREFIX, 10)
	end
	player.Chatted:Connect(function(message)
		if message:sub(1, #PREFIX) == PREFIX then
			processCommand(player, message:sub(#PREFIX+1))
		end
	end)
end)

for i, v in pairs(game.Players:GetPlayers()) do 
	if ADMINS[v.UserId] then    
		v.Chatted:Connect(function(message)
			print(message)
			if message:sub(1, #PREFIX) == PREFIX then
				processCommand(v, message:sub(#PREFIX + 1))
			end
		end)
	end
end

for _, player in ipairs(game.Players:GetPlayers()) do
	if ADMINS[player.UserId] then
		notify(player, "Punchy's Admin System", "Commands loaded! Prefix: " .. PREFIX .. "\n", 10)
	end
end
print("Punchside loaded!!!")







--[[ Universal ESP for Solar/Executors (players: green = visible, red = invisible) ]]--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function isVisible(target)
    if not LocalPlayer.Character or not target.Character then return false end
    local head = LocalPlayer.Character:FindFirstChild("Head")
    local targetHead = target.Character:FindFirstChild("Head")
    if not head or not targetHead then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Workspace.Camera}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(head.Position, (targetHead.Position - head.Position).Unit * (targetHead.Position - head.Position).Magnitude, params)
    if result and result.Instance and not result.Instance:IsDescendantOf(target.Character) then
        return false
    end
    return true
end

local function highlightPlayer(plr, col)
    local character = plr.Character
    if not character then return end
    local h = character:FindFirstChild("SolarESP") or Instance.new("Highlight")
    h.Name = "SolarESP"
    h.Adornee = character
    h.FillColor = col
    h.OutlineColor = col
    h.OutlineTransparency = 0
    h.Parent = character
end

local function removeHighlight(plr)
    local character = plr.Character
    if character then
        local h = character:FindFirstChild("SolarESP")
        if h then h:Destroy() end
    end
end

while true do
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            removeHighlight(plr)
            if plr.Character and plr.Character:FindFirstChild("Head") then
                if isVisible(plr) then
                    highlightPlayer(plr, Color3.fromRGB(0,255,0))
                else
                    highlightPlayer(plr, Color3.fromRGB(255,0,0))
                end
            end
        end
    end
    task.wait(1)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function isVisible(target)
    local character = LocalPlayer.Character
    local targetCharacter = target.Character
    if not character or not targetCharacter then return false end

    local head = character:FindFirstChild("Head")
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not head or not targetHead then return false end

    -- Raycast od własnej głowy do głowy celu
    local ray = Ray.new(head.Position, (targetHead.Position - head.Position).unit * (targetHead.Position - head.Position).magnitude)
    local hitPart, hitPosition = workspace:FindPartOnRay(ray, character)

    -- Jeśli promień dotarł do celu bez przeszkód, gracz jest widoczny
    if hitPart and hitPart:IsDescendantOf(targetCharacter) then
        return true
    end
    return false
end

function addHighlight(player, color)
    local character = player.Character
    if not character then return end
    if character:FindFirstChild("ESPHighlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Parent = character
end

function removeHighlight(player)
    local character = player.Character
    if not character then return end
    local highlight = character:FindFirstChild("ESPHighlight")
    if highlight then
        highlight:Destroy()
    end
end

function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            removeHighlight(player)
            if isVisible(player) then
                addHighlight(player, Color3.fromRGB(0,255,0)) -- Zielony
            else
                addHighlight(player, Color3.fromRGB(255,0,0)) -- Czerwony
            end
        end
    end
end

-- Co sekundę aktualizuj kolory ESP
while true do
    pcall(updateHighlights)
    wait(1)
end

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local BLOCK = script.Parent
local ENDPOINT = "http://127.0.0.1:5000/vision"

-- RESOLUÇÃO AVANÇADA
local RES_X = 120 
local RES_Y = 90 
local FOV = math.rad(75)
local MAX_DIST = 200

local function getVisionData()
    local frameData = {}
    local origin = BLOCK.Position
    local baseCFrame = BLOCK.CFrame

    for y = 0, RES_Y - 1 do
        local pitch = (y / (RES_Y - 1) - 0.5) * FOV
        for x = 0, RES_X - 1 do
            local yaw = (x / (RES_X - 1) - 0.5) * FOV
            local dir = (CFrame.Angles(-pitch, -yaw, 0)).LookVector
            local worldDir = baseCFrame:VectorToWorldSpace(dir)

            local result = workspace:Raycast(origin, worldDir * MAX_DIST)
            
            if result then
                local part = result.Instance
                local color = part.Color
                
                -- TRUQUE DE COR: Se for parte de um Personagem, tentamos brilho extra
                if part.Parent:FindFirstChild("Humanoid") or part.Parent.Parent:FindFirstChild("Humanoid") then
                    -- Multiplicamos levemente para destacar o boneco do cenário
                    table.insert(frameData, math.min(255, math.floor(color.R * 280)))
                    table.insert(frameData, math.min(255, math.floor(color.G * 280)))
                    table.insert(frameData, math.min(255, math.floor(color.B * 280)))
                else
                    table.insert(frameData, math.floor(color.R * 255))
                    table.insert(frameData, math.floor(color.G * 255))
                    table.insert(frameData, math.floor(color.B * 255))
                end
            else
                -- Fundo (Espaço vazio) - Roxo escuro/Preto para dar contraste
                table.insert(frameData, 10)
                table.insert(frameData, 10)
                table.insert(frameData, 20)
            end
        end
    end
    return frameData
end

local lastSend = 0
RunService.Heartbeat:Connect(function()
    if tick() - lastSend < 0.05 then return end -- Rodando a 20 FPS
    lastSend = tick()

    local success, json = pcall(function()
        return HttpService:JSONEncode({
            resX = RES_X,
            resY = RES_Y,
            pixels = getVisionData()
        })
    end)

    if success then
        pcall(function()
            HttpService:PostAsync(ENDPOINT, json)
        end)
    end
end)

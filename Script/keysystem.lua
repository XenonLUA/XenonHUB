local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
local BackgroundFrame = Instance.new("Frame")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local VerifyButton = Instance.new("TextButton")
local GetKeyButton = Instance.new("TextButton")
local TitleLabel = Instance.new("TextLabel")
local TextLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "LoginGui"

BackgroundFrame.Parent = ScreenGui
BackgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundFrame.BackgroundTransparency = 0.5
BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
BackgroundFrame.Position = UDim2.new(0, 0, 0, 0)

Frame.Parent = BackgroundFrame
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0.5, 0, 0.5, 0)
Frame.Position = UDim2.new(0.25, 0, 0.25, 0)

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0.05, 0)

TitleLabel.Parent = Frame
TitleLabel.Text = "XENON HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
TitleLabel.Position = UDim2.new(0.1, 0, 0.1, 0)

TextBox.Parent = Frame
TextBox.PlaceholderText = "Enter your key"
TextBox.Size = UDim2.new(0.8, 0, 0.2, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.4, 0)

VerifyButton.Parent = Frame
VerifyButton.Text = "Verify Key"
VerifyButton.Size = UDim2.new(0.38, 0, 0.2, 0)
VerifyButton.Position = UDim2.new(0.1, 0, 0.7, 0)

GetKeyButton.Parent = Frame
GetKeyButton.Text = "Get Key"
GetKeyButton.Size = UDim2.new(0.38, 0, 0.2, 0)
GetKeyButton.Position = UDim2.new(0.52, 0, 0.7, 0)

TextLabel.Parent = Frame
TextLabel.Text = ""
TextLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
TextLabel.Position = UDim2.new(0.1, 0, 0.9, 0)
TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.BackgroundTransparency = 1

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

local http_request = syn and syn.request or request

local function validateKey(key)
    local url = "https://xenon-next-js-seven.vercel.app/api/validate-key"
    local response = http_request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({ key = key })
    })

    print("Validating key:", key)
    print("HTTP response status:", response.StatusCode)
    print("HTTP response body:", response.Body)

    if response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body)
        if data.valid then
            print("Key is valid")
            ScreenGui:Destroy()

            -- Critical code to run after key validation
            -- Insert your code here that should only run when the key is valid
        else
            TextLabel.Text = "Invalid key"
            print("Invalid key")
        end
    else
        TextLabel.Text = "Failed to connect to server: " .. response.StatusCode
        print("Failed to connect to server: " .. response.StatusCode)
    end
end

VerifyButton.MouseButton1Click:Connect(function()
    local key = TextBox.Text
    if key == "" then
        TextLabel.Text = "Please enter a key."
        return
    end
    
    validateKey(key)
end)

GetKeyButton.MouseButton1Click:Connect(function()
    local url = "https://xenon-next-js-seven.vercel.app"
    setclipboard(url)
    TextLabel.Text = "URL copied to clipboard"
    print("URL copied to clipboard:", url)
end)

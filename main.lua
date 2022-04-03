--[[
             /$$   /$$ /$$   /$$ /$$$$$$$$ /$$$$$$$  /$$$$$$$$ /$$   /$$
            | $$$ | $$| $$  | $$|__  $$__/| $$__  $$| $$_____/| $$  / $$
            | $$$$| $$| $$  | $$   | $$   | $$  \ $$| $$      |  $$/ $$/
            | $$ $$ $$| $$  | $$   | $$   | $$$$$$$/| $$$$$    \  $$$$/ 
            | $$  $$$$| $$  | $$   | $$   | $$__  $$| $$__/     >$$  $$ 
            | $$\  $$$| $$  | $$   | $$   | $$  \ $$| $$       /$$/\  $$
            | $$ \  $$|  $$$$$$/   | $$   | $$  | $$| $$$$$$$$| $$  \ $$
            |__/  \__/ \______/    |__/   |__/  |__/|________/|__/  |__/
--]]

local LoadTime = tick();

print("Credits to the N'Zoth 🖕");
print("Sponsored by EPIC GANG 🔥😎");

local usedCache = shared.__urlcache and next(shared.__urlcache) ~= nil -- THANKS WALLY ( Totally not skidding off the great wally)
shared.__urlcache = shared.__urlcache or {}
local function urlLoad(url)
    local success, result

    if shared.__urlcache[url] then
        success, result = true, shared.__urlcache[url]
    else
        success, result = pcall(game.HttpGet, game, url)
    end

    if (not success) then
        return fail(string.format('Failed to GET url %q for reason: %q', url, tostring(result)))
    end

    local fn, err = loadstring(result)
    if (type(fn) ~= 'function') then
        return fail(string.format('Failed to loadstring url %q for reason: %q', url, tostring(err)))
    end

    local results = { pcall(fn) }
    if (not results[1]) then
        return fail(string.format('Failed to initialize url %q for reason: %q', url, tostring(results[2])))
    end

    shared.__urlcache[url] = result
    return unpack(results, 2)
end

-- [[ Variables ]]
-- <:Important:>
local dwMarketplaceService = game:GetService('MarketplaceService');
local dwReplicatedStorage = game:GetService('ReplicatedStorage');
local dwRunService = game:GetService('RunService');
local dwWorkspace = game:GetService('Workspace');
local dwEntities = game:GetService('Players');
local dwCoreGui = game:GetService('CoreGui');
local dwDebris = game:GetService('Debris');
local dwCamera = dwWorkspace.CurrentCamera;
-- <:Minor:>
local getUI_Library = urlLoad('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua');
local getFunctions = urlLoad('https://raw.githubusercontent.com/NUTTREX/Roblox/main/Functions.lua');
local game_Name = dwMarketplaceService:GetProductInfo(game.PlaceId).Name;

local dwSelectionBox = dwWorkspace:WaitForChild('SelectionBox', 30);
local dwEntitiesFolder = dwWorkspace:WaitForChild('Entities', 30);
local dwChunksFolder = dwWorkspace:WaitForChild('Chunks', 30);

local dwVisualsFolder = Instance.new('Folder');
-- <:Connections:>
local dwMobChamCon; local dwMobTextCon; local dwOreChamCon; local dwOreTextCon;

-- [[ Tables ]]
local dwMobsData = {
    ['pig'] = { 
        Color3.fromRGB(255, 100, 140); -- [[ <Color3> FillInColor ]]
        Color3.fromRGB(0, 0, 0); -- [[ <Color3> OutlineColor ]]
        .5; -- [[ <Int> FillInTransparency ]]
        0; -- [[ <Int> FillInColor ]]
    };
    ['chicken'] = { 
        Color3.fromRGB(255, 180, 80);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
    ['zombie'] = { 
        Color3.fromRGB(30, 70, 30);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
    ['spider'] = { 
        Color3.fromRGB(100, 0, 0);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
    ['crawler'] = { 
        Color3.fromRGB(69, 255, 90);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
    ['cow'] = { 
        Color3.fromRGB(190, 85, 10);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
    ['sheep'] = { 
        Color3.fromRGB(255, 255, 255);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
};
local dwMobs = {
    'pig';
    'chicken';
    'zombie';
    'spider';
    'crawler';
    'cow';
    'sheep';
};
local dwOreDecalData = {
    ['rbxassetid://7225133219'] = {'Diamond Ore'};
    ['rbxassetid://7225129962'] = {'Gold Ore'};
    ['rbxassetid://7225125860'] = {'Iron Ore'};
    ['rbxassetid://7216837867'] = {'Coal Ore'};
};
local dwOreData = {
    ['Diamond Ore'] = { 
        Color3.fromRGB(0, 255, 230); -- [[ <Color3> FillInColor ]]
        Color3.fromRGB(0, 0, 0); -- [[ <Color3> OutlineColor ]]
        .5; -- [[ <Int> FillInTransparency ]]
        0; -- [[ <Int> FillInColor ]]
    };
    ['Gold Ore'] = { 
        Color3.fromRGB(255, 170, 0);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
    ['Iron Ore'] = { 
        Color3.fromRGB(200,200,200);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
    ['Coal Ore'] = { 
        Color3.fromRGB(50,50,50);
        Color3.fromRGB(0, 0, 0);
        .5;
        0;
    };
};
local dwOres = {
    'Diamond Ore';
    'Gold Ore';
    'Iron Ore';
    'Coal Ore';
};
local dwAnimations = {
    [1] = { '|', '/', '─', '\\' };
    [2] = { '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘' };
    [3] = { 'N', 'N\'', 'N\'Z', 'N\'Zo', 'N\'Zot', 'N\'Zoth', 'N\'Zot', 'N\'Zo', 'N\'Z', 'N\'', '', 'N', 'Nu', 'Nut', 'Nutr', 'Nutre', 'Nutrex', 'Nutre', 'Nutr', 'Nut', 'Nu', 'N', ''};
    [4] = { 'e', 'eg', 'egg', 'egg', 'egg ', 'egg s', 'egg sa', 'egg sal', 'egg sala', 'egg salad', 'egg salad ', 'egg salad i', 'egg salad is', 'egg salad is ', 'egg salad is r', 'egg salad is rl', 'egg salad is rly', 'egg salad is rly ', 'egg salad is rly f', 'egg salad is rly fa', 'egg salad is rly fat', 'egg salad is rly fa', 'egg salad is rly f', 'egg salad is rly ', 'egg salad is rly', 'egg salad is rl', 'egg salad is r', 'egg salad is ', 'egg salad is', 'egg salad i', 'egg salad ', 'egg salad', 'egg sala', 'egg sal', 'egg sa', 'egg s', 'egg ', 'egg', 'eg', 'e', ''};
};
-- [[ Functions ]]

local function WTS(dwEntity)
    local Screen = dwCamera:WorldToViewportPoint(dwEntity.Position);
    return Vector2.new(Screen.X, Screen.Y);
end;

local function onMobAddedDrawCham(dwEntity, m_ColorFill, m_ColorOutline, m_TransFill, m_TransOutline, dwConnection, dwSecondaryConnection, dwCallBack, dwSecondaryCallBack)
    local dwCham = Instance.new('Highlight');
    dwCham.Adornee = dwEntity;
    dwCham.Parent = dwVisualsFolder;
    dwCham.Enabled = true;

    dwCham.FillColor = m_ColorFill or Color3.fromRGB(255, 255, 255);
    dwCham.OutlineColor = m_ColorOutline or Color3.fromRGB(0, 0, 0);

    dwCham.FillTransparency = m_TransFill or 0;
    dwCham.OutlineTransparency = m_TransOutline or 0;

    dwCham.Name = getFunctions.Generate_String(69);

    local dwTag = Instance.new('StringValue');
    dwTag.Name = "Cham"
    dwTag.Parent = dwEntity;

    task.spawn(function()
        while task.wait() do
            if dwConnection then
                dwCham.FillColor = dwConnection.Value;
            end;

            if dwSecondaryConnection then
                dwCham.OutlineColor = dwSecondaryConnection.Value;
            end;
            
            if dwCallBack.Value == false then
                dwCham:Destroy();
                dwTag:Destroy();
            end;

            if not dwSecondaryCallBack.Value[dwEntity.Name] then
                dwCham:Destroy();
                dwTag:Destroy();
            end;
        end;
    end);
    
    local dwAncestryChanged;
    dwAncestryChanged = dwEntity.AncestryChanged:Connect(function()
        if not dwEntity:IsDescendantOf(dwWorkspace) then
            dwDebris:AddItem(dwCham, 1);
            dwTag:Destroy();
            dwAncestryChanged:Disconnect();
        end;
    end);
end;

local function onOreAddedDrawText(dwEntity, m_Color, dwText, dwZIndex, dwTextSize, dwCallBack, dwSecondaryCallBack)
    local dwTest = Drawing.new('Text');
    dwTest.Position = WTS(dwEntity);
    dwTest.Color = m_Color or Color3.fromRGB(255, 255, 255);
    dwTest.Text = dwText or dwEntity.Name;
    dwTest.Size = dwTextSize or 20;
    dwTest.Center = true;
    dwTest.Outline = true;
    dwTest.Font = 0;
    dwTest.ZIndex = dwZIndex or 10;

    local dwTag = Instance.new('StringValue');
    dwTag.Name = "Text";
    dwTag.Parent = dwEntity;
    
    local dwEntityParent = dwEntity.Parent;

    local dwRunServiceSignal;
    
    task.spawn(function()
        while task.wait() do
            if not dwSecondaryCallBack.Value[dwEntity.Name] and dwTest ~= nil and dwTest.__OBJECT_EXISTS then
                dwTest:Remove();
                dwTag:Destroy();
                dwRunServiceSignal:Disconnect();
                break;
            end;

            if dwCallBack.Value == false and dwTest ~= nil and dwTest.__OBJECT_EXISTS then
                dwTest:Remove();
                dwTest = nil;
                dwTag:Destroy();
                dwRunServiceSignal:Disconnect();
                break;
            end;
        end;
    end);

    dwRunServiceSignal = dwRunService.RenderStepped:Connect(function()
        local _, OnScreen = dwCamera:WorldToViewportPoint(dwEntity.Position)
        if dwEntity:IsDescendantOf(Workspace) and dwTest ~= nil and OnScreen and dwTest.__OBJECT_EXISTS then
            dwTest.Position = WTS(dwEntity);
            dwTest.Visible = true;
        elseif dwEntity:IsDescendantOf(Workspace) and dwTest ~= nil and not OnScreen and dwTest.__OBJECT_EXISTS then
            dwTest.Visible = false;
        elseif not dwEntity:IsDescendantOf(Workspace) and dwTest ~= nil and dwTest.__OBJECT_EXISTS then
            dwTag:Destroy();
            dwTest:Remove();
            dwTest = nil;
            dwRunServiceSignal:Disconnect();
        end
    end)
end;

local function onMobAddedDrawText(dwEntity, m_Color, dwText, dwZIndex, dwTextSize, dwCallBack, dwSecondaryCallBack)
    local dwTest = Drawing.new('Text');
    dwTest.Position = WTS(dwEntity);
    dwTest.Color = m_Color or Color3.fromRGB(255, 255, 255);
    dwTest.Text = dwText or dwEntity.Name;
    dwTest.Size = dwTextSize or 20;
    dwTest.Center = true;
    dwTest.Outline = true;
    dwTest.Font = 0;
    dwTest.ZIndex = dwZIndex or 10;

    local dwTag = Instance.new('StringValue');
    dwTag.Name = "Text"
    dwTag.Parent = dwEntity.Parent;
    
    local dwEntityParent = dwEntity.Parent;

    local dwRunServiceSignal;

    task.spawn(function()
        while task.wait() do
            if dwEntityParent ~= nil then
                if not dwSecondaryCallBack.Value[dwEntityParent.Name] and dwTest ~= nil and dwTest.__OBJECT_EXISTS then
                    dwTest:Remove();
                    dwTag:Destroy();
                    dwRunServiceSignal:Disconnect();
                    break;
                end;
            end

            if dwCallBack.Value == false and dwTest ~= nil and dwTest.__OBJECT_EXISTS then
                dwTest:Remove();
                dwTest = nil;
                dwTag:Destroy();
                dwRunServiceSignal:Disconnect();
                break;
            end;
        end;
    end);

    dwRunServiceSignal = dwRunService.RenderStepped:Connect(function()
        local _, OnScreen = dwCamera:WorldToViewportPoint(dwEntity.Position)
        if dwEntity:IsDescendantOf(Workspace) and dwTest ~= nil and OnScreen and dwTest.__OBJECT_EXISTS then
            dwTest.Position = WTS(dwEntity);
            dwTest.Visible = true;
        elseif dwEntity:IsDescendantOf(Workspace) and dwTest ~= nil and not OnScreen and dwTest.__OBJECT_EXISTS then
            dwTest.Visible = false;
        elseif not dwEntity:IsDescendantOf(Workspace) and dwTest ~= nil and dwTest.__OBJECT_EXISTS then
            dwTag:Destroy();
            dwTest:Remove();
            dwTest = nil;
            dwRunServiceSignal:Disconnect();
        end
    end)
end;

local function onPartName(dwEntity, dwName)
    dwEntity.Name = dwName

    local dwTag = Instance.new('StringValue');
    dwTag.Name = "Named"
    dwTag.Parent = dwEntity;
end

-- [[ Code ]]

getUI_Library:SetWatermark(game_Name.." | "..game.PlaceId);

for Index, dwChunk in next, dwChunksFolder:GetChildren() do -- Game Fix
    if dwChunk:IsA('Folder') then 
        for Index, dwPart in next, dwChunk:GetChildren() do
            if dwPart:IsA('BasePart') and not dwPart:FindFirstChild('Named') then
                for Index, dwDecal in next, dwPart:GetChildren() do
                    if dwDecal:IsA('Decal') then
                        if dwOreDecalData[dwDecal.Texture] then
                            onPartName(dwPart, dwOreDecalData[dwDecal.Texture][1]);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

dwChunksFolder.ChildAdded:Connect(function() -- Game Fix
    for Index, dwChunk in next, dwChunksFolder:GetChildren() do 
        for Index, dwPart in next, dwChunk:GetChildren() do
            if dwPart:IsA('BasePart') and not dwPart:FindFirstChild('Named') then
                for Index, dwDecal in next, dwPart:GetChildren() do
                    if dwDecal:IsA('Decal') then
                        if dwOreDecalData[dwDecal.Texture] then
                            onPartName(dwPart, dwOreDecalData[dwDecal.Texture][1]);
                        end;
                    end;
                end;
            end;
        end;
    end;
end);

local mainWindow = getUI_Library:CreateWindow('') do
    -- // Visuals
    local visualsTab = mainWindow:AddTab('Visuals') do
        local visualsBox = visualsTab:AddLeftTabbox() do
            local visualsBox = visualsBox:AddTab('Mobs') do
                visualsBox:AddToggle('EntitiesCham', { Text = 'Entities Chams'})
                visualsBox:AddToggle('EntitiesTextESP', { Text = 'Entities Text ESP'})
                visualsBox:AddDropdown('EntitiesDropdown', { Text = 'Select Entities', Default = nil, Values = dwMobs, AllowNull = true, Multi = true});
            end;
        end;
        local AnothervisualsBox = visualsTab:AddRightTabbox() do
            local visualsBox = AnothervisualsBox:AddTab('Ores') do
                visualsBox:AddToggle('OresCham', { Text = 'Ores Chams'})
                visualsBox:AddToggle('OresTextESP', { Text = 'Ores Text ESP'})
                visualsBox:AddDropdown('OresDropdown', { Text = 'Select Ores', Default = nil, Values = dwOres, AllowNull = true, Multi = true});
            end;
        end;
    end;
    -- //
    -- // Miscs
    local MiscellaneousTab = mainWindow:AddTab('Miscellaneous') do
        local visualsBox = MiscellaneousTab:AddLeftTabbox() do
            local visualsBox = visualsBox:AddTab('World') do
                visualsBox:AddToggle('SelectionBox', { Default = true, Text = 'SelectionBox'}):AddColorPicker('SelectionBoxColor', { Default = Color3.fromRGB(0, 0, 0)}):AddColorPicker('SelectionBoxOutlineColor', { Default = Color3.fromRGB(0, 0, 0)})
                visualsBox:AddToggle('RainbowSelectionBox', { Text = 'Rainbow SelectionBox'})
                visualsBox:AddSlider('SurfaceTransparency', { Text = 'SelectionBox Surface Transparency', Min = 0, Max = 1, Default = 1, Rounding = 1});
            end;
        end;
    end;
    -- //
end;

task.spawn(function()
    local dwPickedAnimation = dwAnimations[math.random(1, #dwAnimations)];
    local Delay;
    
    if dwPickedAnimation == dwAnimations[3] or dwPickedAnimation == dwAnimations[1] then
        Delay = .2;
    else
        Delay = .1;
    end;

    while task.wait() do
        for dwIndex, dwField in next, dwPickedAnimation do
            mainWindow:SetWindowTitle(dwField);
            task.wait(Delay);
        end;
    end;
end);

pcall(function() -- big troll!
    local Joke = 868739862.5*2/2*2/3*3/69*69;
    local JokeString = dwEntities:GetNameFromUserIdAsync(Joke);
    debug.setconstant(require(dwReplicatedStorage.LocalModules.GeneralUI.Chat).add_message, 1, tostring(JokeString));
    debug.setconstant(require(dwReplicatedStorage.LocalModules.GeneralUI.Chat).add_message, 4, 'Cock Master');
end);

dwVisualsFolder.Name = getFunctions.Generate_String(69);
dwVisualsFolder.Parent = dwCoreGui;

-- [[ Toggles | Options ]]

Toggles.OresCham:OnChanged(function()
    if Toggles.OresCham.Value then
        for Index, dwChunk in next, dwChunksFolder:GetChildren() do -- Quick check if we already have Entities
            if dwChunk:IsA('Folder') then 
                for Index, dwPart in next, dwChunk:GetChildren() do
                    if dwPart:IsA('BasePart') and Options.OresDropdown.Value[dwPart.Name] and not dwPart:FindFirstChild('Cham') then
                        onMobAddedDrawCham(dwPart, dwOreData[dwPart.Name][1], dwOreData[dwPart.Name][2], dwOreData[dwPart.Name][3], dwOreData[dwPart.Name][4], nil, nil, Toggles.OresCham, Options.OresDropdown);
                    end;
                end;
            end;
        end;
        local dwOreChamCon = dwChunksFolder.ChildAdded:Connect(function(dwChild) -- Connection So it's Automatic
            task.wait(1)
            for Index, dwPart in next, dwChild:GetChildren() do
                if dwPart:IsA('BasePart') and Options.OresDropdown.Value[dwPart.Name] and not dwPart:FindFirstChild('Cham') then
                    onMobAddedDrawCham(dwPart, dwOreData[dwPart.Name][1], dwOreData[dwPart.Name][2], dwOreData[dwPart.Name][3], dwOreData[dwPart.Name][4], nil, nil, Toggles.OresCham, Options.OresDropdown);
                end;
            end;
        end);
    elseif Toggles.OresCham and dwOreChamCon then
        dwOreChamCon:Disconnect();
    end;
end)

Toggles.OresTextESP:OnChanged(function()
    if Toggles.OresTextESP.Value then
        for Index, dwChunk in next, dwChunksFolder:GetChildren() do -- Quick check if we already have Entities
            if dwChunk:IsA('Folder') then 
                for Index, dwPart in next, dwChunk:GetChildren() do
                    if dwPart:IsA('BasePart') and Options.OresDropdown.Value[dwPart.Name] and not dwPart:FindFirstChild('Text') then
                        onOreAddedDrawText(dwPart, nil, dwPart.Name, 10, 20, Toggles.OresTextESP, Options.OresDropdown);
                    end;
                end;
            end;
        end;

        local dwOreTextCon = dwChunksFolder.ChildAdded:Connect(function(dwChild) -- Connection So it's Automatic
            task.wait(1)
            for Index, dwPart in next, dwChild:GetChildren() do
                if dwPart:IsA('BasePart') and Options.OresDropdown.Value[dwPart.Name] and not dwPart:FindFirstChild('Text') then
                    onOreAddedDrawText(dwPart, nil, dwPart.Name, 10, 20, Toggles.OresTextESP, Options.OresDropdown);
                end;
            end;
        end);
    elseif Toggles.OresTextESP and dwOreTextCon then
        dwOreTextCon:Disconnect();
    end;
end)

Options.OresDropdown:OnChanged(function()
    for Index, dwChunk in next, dwChunksFolder:GetChildren() do -- Quick check if we already have Entities
        if dwChunk:IsA('Folder') then 
            for Index, dwPart in next, dwChunk:GetChildren() do
                if dwPart:IsA('BasePart') and Options.OresDropdown.Value[dwPart.Name] and not dwPart:FindFirstChild('Cham') and Toggles.OresCham.Value then
                    onMobAddedDrawCham(dwPart, dwOreData[dwPart.Name][1], dwOreData[dwPart.Name][2], dwOreData[dwPart.Name][3], dwOreData[dwPart.Name][4], nil, nil, Toggles.OresCham, Options.OresDropdown);
                end;
            end;
        end;

        if dwChunk:IsA('Folder') then 
            for Index, dwPart in next, dwChunk:GetChildren() do
                if dwPart:IsA('BasePart') and Options.OresDropdown.Value[dwPart.Name] and not dwPart:FindFirstChild('Text') and Toggles.OresTextESP.Value then
                    onOreAddedDrawText(dwPart, nil, dwPart.Name, 10, 20, Toggles.OresTextESP, Options.OresDropdown);
                end;
            end;
        end;
    end;
end);

Toggles.EntitiesTextESP:OnChanged(function()
    if Toggles.EntitiesTextESP.Value then
        for Index, dwModel in next, dwEntitiesFolder:GetChildren() do -- Quick check if we already have Entities
            if dwModel:IsA('Model') and Options.EntitiesDropdown.Value[dwModel.Name] and not dwModel:FindFirstChild('Text') then
                if dwModel:FindFirstChild('Body') then
                    onMobAddedDrawText(dwModel.Body, nil, dwModel.Name, 10, 20, Toggles.EntitiesTextESP, Options.EntitiesDropdown);
                end;
            end;
        end;
        local dwMobTextCon = dwEntitiesFolder.ChildAdded:Connect(function(dwChild) -- Connection So it's Automatic
            if dwChild:IsA('Model') and Options.EntitiesDropdown.Value[dwChild.Name] and not dwChild:FindFirstChild('Text') then
                if dwChild:FindFirstChild('Body') then
                    onMobAddedDrawText(dwChild.Body, nil, dwChild.Name, 10, 20, Toggles.EntitiesTextESP, Options.EntitiesDropdown);
                end;
            end;
        end);
    elseif Toggles.EntitiesTextESP and dwMobTextCon then
        dwMobTextCon:Disconnect();
    end;
end)

Toggles.EntitiesCham:OnChanged(function()
    if Toggles.EntitiesCham.Value then
        for Index, dwModel in next, dwEntitiesFolder:GetChildren() do -- Quick check if we already have Entities
            if dwModel:IsA('Model') and Options.EntitiesDropdown.Value[dwModel.Name] and not dwModel:FindFirstChild('Cham') then
                onMobAddedDrawCham(dwModel, dwMobsData[dwModel.Name][1], dwMobsData[dwModel.Name][2], dwMobsData[dwModel.Name][3], dwMobsData[dwModel.Name][4], nil, nil, Toggles.EntitiesCham, Options.EntitiesDropdown);
            end;
        end;
        local dwMobChamCon = dwEntitiesFolder.ChildAdded:Connect(function(dwChild) -- Connection So it's Automatic
            if dwChild:IsA('Model') and Options.EntitiesDropdown.Value[dwChild.Name] and not dwChild:FindFirstChild('Cham') then
                onMobAddedDrawCham(dwChild, dwMobsData[dwChild.Name][1], dwMobsData[dwChild.Name][2], dwMobsData[dwChild.Name][3], dwMobsData[dwChild.Name][4], nil, nil, Toggles.EntitiesCham, Options.EntitiesDropdown);
            end;
        end);
    elseif Toggles.EntitiesCham and dwMobChamCon then
        dwMobChamCon:Disconnect();
    end;
end)

Options.EntitiesDropdown:OnChanged(function()
    for Index, dwModel in next, dwEntitiesFolder:GetChildren() do -- Quick check if we already have Entities
        if dwModel:IsA('Model') and Options.EntitiesDropdown.Value[dwModel.Name] and not dwModel:FindFirstChild('Cham') and Toggles.EntitiesCham.Value then
            onMobAddedDrawCham(dwModel, dwMobsData[dwModel.Name][1], dwMobsData[dwModel.Name][2], dwMobsData[dwModel.Name][3], dwMobsData[dwModel.Name][4], nil, nil, Toggles.EntitiesCham, Options.EntitiesDropdown);
        end;

        if dwModel:IsA('Model') and Options.EntitiesDropdown.Value[dwModel.Name] and not dwModel:FindFirstChild('Text') and Toggles.EntitiesTextESP.Value then
            if dwModel:FindFirstChild('Body') then
                onMobAddedDrawText(dwModel.Body, nil, dwModel.Name, 10, 20, Toggles.EntitiesTextESP, Options.EntitiesDropdown);
            end;
        end;
    end;
end);

Toggles.SelectionBox:OnChanged(function()
    if Toggles.SelectionBox.Value then
        dwSelectionBox.Visible = true;
    else
        dwRunService:UnbindFromRenderStep('RainbowSelectionBox');
        dwSelectionBox.Color3 = Options.SelectionBoxOutlineColor.Value;
        dwSelectionBox.SurfaceColor3 = Options.SelectionBoxColor.Value;
        Toggles.RainbowSelectionBox:SetValue(false);
        dwSelectionBox.Visible = false;
    end;
end);

Toggles.RainbowSelectionBox:OnChanged(function()
    if Toggles.RainbowSelectionBox.Value and Toggles.SelectionBox.Value then
        dwRunService:BindToRenderStep('RainbowSelectionBox', Enum.RenderPriority.Camera.Value, function() dwSelectionBox.Color3 = Color3.fromHSV(tick()%5/5, 1, 1); dwSelectionBox.SurfaceColor3 = Color3.fromHSV(tick()%5/5, 1, 1); end);
    else
        dwRunService:UnbindFromRenderStep('RainbowSelectionBox');
        dwSelectionBox.Color3 = Options.SelectionBoxOutlineColor.Value;
        dwSelectionBox.SurfaceColor3 = Options.SelectionBoxColor.Value;
    end;
end);

Options.SelectionBoxColor:OnChanged(function()
    if Toggles.RainbowSelectionBox.Value == false then
        dwSelectionBox.SurfaceColor3 = Options.SelectionBoxColor.Value;
    end;
end);

Options.SelectionBoxOutlineColor:OnChanged(function()
    if Toggles.RainbowSelectionBox.Value == false then
        dwSelectionBox.Color3 = Options.SelectionBoxOutlineColor.Value; 
    end;
end);

Options.SurfaceTransparency:OnChanged(function()
    dwSelectionBox.SurfaceTransparency = Options.SurfaceTransparency.Value
end);

getUI_Library:Notify(string.format('Loaded script in %.4f second(s)!', tick() - LoadTime), 5);

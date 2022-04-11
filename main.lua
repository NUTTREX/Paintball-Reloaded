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
local dwVirtualInputManager = game:GetService('VirtualInputManager');
local dwMarketplaceService = game:GetService('MarketplaceService');
local dwReplicatedStorage = game:GetService('ReplicatedStorage');
local dwUserInputService = game:GetService('UserInputService');
local dwHttpService = game:GetService('HttpService');
local dwRunService = game:GetService('RunService');
local dwWorkspace = game:GetService('Workspace');
local dwEntities = game:GetService('Players');
local dwCoreGui = game:GetService('CoreGui');
local dwDebris = game:GetService('Debris');
local dwStat = game:GetService('Stats');
local dwCamera = dwWorkspace.CurrentCamera;
local dwLocalEntity = dwEntities.LocalPlayer;
local dwGetPlayers = dwEntities.GetPlayers;

-- <:Minor:>
local getUI_Library = urlLoad('https://raw.githubusercontent.com/NUTTREX/LinoriaLib/main/Library.lua');
local getFunctions = urlLoad('https://raw.githubusercontent.com/NUTTREX/Roblox/main/Functions.lua');
local getESP_Library = urlLoad('https://kiriot22.com/releases/ESP.lua');
local game_Name = dwMarketplaceService:GetProductInfo(game.PlaceId).Name;   
local dwPing = dwStat:WaitForChild('PerformanceStats', 30):WaitForChild('Ping', 30);
local dwApplyDamage;
local dwDebrisFolder;
if dwWorkspace:WaitForChild('GameMain', 10):WaitForChild('ApplyDamage', 10) then
    dwApplyDamage = dwWorkspace.GameMain.ApplyDamage;
end;
if dwWorkspace:WaitForChild('Debris', 10) then
    dwDebrisFolder = dwWorkspace.Debris;
end;
-- <:Connections:>

-- [[ Tables ]]
shared.DrawCache = {};
shared.TagCache = {};
shared.Threads = {};
shared.Callbacks = {};

local dwTrashData = {
    ['Black'] = { 
        Color3.fromRGB(255, 255, 255); -- [[ <Color3> Text ]]
        20; -- [[ <Int> Size ]]
        50; -- [[ <Int> ZIndex ]]
        "Mythic Item"; -- [[ <String> Text ]]
    };
    ['Legendary'] = { 
        Color3.fromRGB(225, 180, 70); 
        20; 
        40; 
        "Legendary Item";
    };
    ['Epic'] = { 
        Color3.fromRGB(160, 30, 255); 
        20; 
        30;
        "Epic Item";
    };
    ['Rare'] = { 
        Color3.fromRGB(0, 170, 255); 
        20; 
        20;
        "Rare Item";
    };
    ['Normal'] = { 
        Color3.fromRGB(130, 130, 130); 
        20; 
        10;
        "Normal Item";
    };
};
local dwAnimations = {
    [1] = { '|', '/', '─', '\\' };
    [2] = { '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘' };
    [3] = { 'N', 'N\'', 'N\'Z', 'N\'Zo', 'N\'Zot', 'N\'Zoth', 'N\'Zot', 'N\'Zo', 'N\'Z', 'N\'', ' ', 'N', 'Nu', 'Nut', 'Nutr', 'Nutre', 'Nutrex', 'Nutre', 'Nutr', 'Nut', 'Nu', 'N', ' '};
    [4] = { 'e', 'eg', 'egg', 'egg', 'egg ', 'egg s', 'egg sa', 'egg sal', 'egg sala', 'egg salad', 'egg salad ', 'egg salad i', 'egg salad is', 'egg salad is ', 'egg salad is r', 'egg salad is rl', 'egg salad is rly', 'egg salad is rly ', 'egg salad is rly f', 'egg salad is rly fa', 'egg salad is rly fat', 'egg salad is rly fa', 'egg salad is rly f', 'egg salad is rly ', 'egg salad is rly', 'egg salad is rl', 'egg salad is r', 'egg salad is ', 'egg salad is', 'egg salad i', 'egg salad ', 'egg salad', 'egg sala', 'egg sal', 'egg sa', 'egg s', 'egg ', 'egg', 'eg', 'e', ' '};
};
-- [[ Functions ]]

local SaveManager = {} do
    SaveManager.Ignore = {}
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object) 
                return { type = 'Toggle', idx = idx, value = object.Value } 
            end,
            Load = function(idx, data)
                if Toggles[idx] then 
                    Toggles[idx]:SetValue(data.value)
                end
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = 'Slider', idx = idx, value = tostring(object.Value) }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValue(data.value)
                end
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValue(data.value)
                end
            end,
        },
        ColorPicker = {
            Save = function(idx, object)
                return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex() }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValueRGB(Color3.fromHex(data.value))
                end
            end,
        },
        KeyPicker = {
            Save = function(idx, object)
                return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValue({ data.key, data.mode })
                end
            end,
        }
    }

    function SaveManager:Save(name)
        local fullPath = tostring(game.PlaceId)..'/configs/' .. name .. '.json'

        local data = {
            version = 2,
            objects = {}
        }

        for idx, toggle in next, Toggles do
            if self.Ignore[idx] then continue end
            table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
        end

        for idx, option in next, Options do
            if not self.Parser[option.Type] then continue end
            if self.Ignore[idx] then continue end

            table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
        end 

        local success, encoded = pcall(dwHttpService.JSONEncode, dwHttpService, data)
        if not success then
            return false, 'failed to encode data'
        end

        writefile(fullPath, encoded)
        return true
    end

    function SaveManager:Load(name)
        local file = tostring(game.PlaceId)..'/configs/' .. name .. '.json'
        if not isfile(file) then return false, 'invalid file' end

        local success, decoded = pcall(dwHttpService.JSONDecode, dwHttpService, readfile(file))
        if not success then return false, 'decode error' end
        if decoded.version ~= 2 then return false, 'invalid version' end

        for _, option in next, decoded.objects do
            if self.Parser[option.type] then
                self.Parser[option.type].Load(option.idx, option)
            end
        end

        return true
    end

    function SaveManager.Refresh()
        local list = listfiles(tostring(game.PlaceId)..'/configs')

        local out = {}
        for i = 1, #list do
            local file = list[i]
            if file:sub(-5) == '.json' then
                -- i hate this but it has to be done ...

                local pos = file:find('.json', 1, true)
                local start = pos

                local char = file:sub(pos, pos)
                while char ~= '/' and char ~= '\\' and char ~= '' do
                    pos = pos - 1
                    char = file:sub(pos, pos)
                end

                if char == '/' or char == '\\' then
                    table.insert(out, file:sub(pos + 1, start - 1))
                end
            end
        end
        
        Options.ConfigList.Values = out;
        Options.ConfigList:SetValues()

        return out
    end

    function SaveManager.Check()
        local list = listfiles(tostring(game.PlaceId)..'/configs')

        for _, file in next, list do
            if isfolder(file) then continue end

            local data = readfile(file)
            local success, decoded = pcall(dwHttpService.JSONDecode, dwHttpService, data)

            if success and type(decoded) == 'table' and decoded.version ~= 2 then
                pcall(delfile, file)
            end
        end
    end
end;

local function _unload()
    getUI_Library:Unload();

    if getESP_Library then
        do
            getESP_Library:Toggle(false);
            getESP_Library.FaceCamera = false;
            getESP_Library.TeamMates = false;
            getESP_Library.Names = false;
            getESP_Library.Tracers = false;
            getESP_Library.Boxes = false;
        end
    end

    if shared.TagCache then
        for Index = #shared.TagCache, 1, -1 do
            local TagObject = table.remove(shared.TagCache, Index);
            TagObject:Destroy()
        end;
    end;

    if shared.DrawCache then
        for Index = #shared.DrawCache, 1, -1 do
            local RenderObject = table.remove(shared.DrawCache, Index);
            RenderObject.Visible = false;
            RenderObject:Remove();
            RenderObject = nil
        end;
    end;

    for Index = 1, #shared.Threads do
        coroutine.close(shared.Threads[Index])
    end;

    for Index = 1, #shared.Callbacks do
        task.spawn(shared.Callbacks[Index])
    end;
end;

local function WTS(dwEntity)
    local Screen = dwCamera:WorldToViewportPoint(dwEntity.Position);
    return Vector2.new(Screen.X, Screen.Y);
end;

local function KillAll()
    for Index, dwEntity in next, dwGetPlayers(dwEntities) do
        if dwEntity ~= dwLocalEntity and dwEntity.Character and dwEntity.Character:FindFirstChild('Humanoid') and dwEntity.Character.Humanoid.Health > 0 then
            local Table = {
                [1] = dwEntity;
                [2] = {
                    ['charge_amm'] = 1;
                    ['scope_shot'] = true;
                };
                [3] = dwHttpService:GenerateGUID(true);
                [4] = false;
            };
            dwApplyDamage:FireServer(Table);
        end;
    end;
end;

local function getTime()
    local dwTime = os.date('*t');
    local dwDate = os.date('%A, %B %d %Y');
    return ("%02d:%02d:%02d %s %s"):format(((dwTime.hour % 24) - 1) % 12 + 1, dwTime.min, dwTime.sec, dwTime.hour > 11 and "PM" or "AM", dwDate);
end;

local function getPing()
    local dwPingColor = "\"#00ff00\""
    local dwPingString = '0'

    if dwPing:GetValue() > 200 then
        dwPingColor = "\"#ff0000\""
    elseif dwPing:GetValue() > 150 and dwPing:GetValue() < 200 then
        dwPingColor = "\"#ffff00\""
    elseif dwPing:GetValue() < 100 then
        dwPingColor = "\"#00ff00\""
    end;

    dwPingString = '<font color='..dwPingColor..'>'..string.split(tostring(dwPing:GetValue()), '.')[1]..'ms'..'</font>'
    return dwPingString
end;

local function RainbowBullets()
    for Index, Instance in next, dwDebrisFolder:GetChildren() do
        if Instance:IsA('BasePart') then
            Instance.Color = Color3.fromHSV(tick()%5/5, 1, 1);
        end;
    end
    for Index, Model in next, dwCamera:GetChildren() do
        if Model:IsA('Model') and Model.Name == 'ProjectileModel' then
            for Index, Instance in next, Model:GetDescendants() do
                if Instance:IsA('Trail') then
                    Instance.Color = ColorSequence.new(Color3.fromHSV(tick()%5/5, 1, 1));
                end;
            end;
        end;
    end;
end;
-- [[ Code ]]

spawn(function()
    while task.wait() do
        getUI_Library:SetWatermark(game_Name..' - '..game.PlaceId..' | '..getTime()..' | '..getPing());
    end;
end);

-- // Window

local Window = getUI_Library:CreateWindow({
    Title = '';
    AutoShow  = true;
    Center = true;
    Size = UDim2.fromOffset(550, 550);
});

-- // Tabs

local Tabs = {};
Tabs.Rage = Window:AddTab('Rage');
Tabs.Visuals = Window:AddTab('Visuals');
Tabs.Miscellaneous = Window:AddTab('Miscellaneous');

-- // Groups

local Groups = {};

Groups.Player = Tabs.Rage:AddLeftGroupbox('Player');
    Groups.Player:AddToggle('KillAll', { Text = 'Kill All', Tooltip = 'Kill enemy players' }):AddKeyPicker('KillAuraBind', { Default = 'N', NoUI = false, Text = 'KillAura', SyncToggleState = true});
    Groups.Player:AddDivider()
Groups.Players = Tabs.Visuals:AddLeftGroupbox('Players Visuals');
    Groups.Players:AddToggle('ESPEnabled', { Text = 'Enabled' }):OnChanged(function()
        getESP_Library:Toggle(Toggles.ESPEnabled.Value);
    end);
    Groups.Players:AddToggle('ESPShowTeams', { Text = 'Show teammates' }):OnChanged(function()
        getESP_Library.TeamMates = Toggles.ESPShowTeams.Value;
    end);
    Groups.Players:AddToggle('ESPShowNames', { Text = 'Show names' }):OnChanged(function()
        getESP_Library.Names = Toggles.ESPShowNames.Value;
    end);
    Groups.Players:AddToggle('ESPShowTracers', { Text = 'Show tracers' }):OnChanged(function()
        getESP_Library.Tracers = Toggles.ESPShowTracers.Value;
    end);
    Groups.Players:AddToggle('ESPShowBoxes', { Text = 'Show boxes' }):OnChanged(function()
        getESP_Library.Boxes = Toggles.ESPShowBoxes.Value;
    end);
Groups.World = Tabs.Visuals:AddRightGroupbox('Weapon Visuals');
    Groups.World:AddToggle('RainbowBullets', { Text = 'Rainbow Bullets' })
Groups.Gui = Tabs.Miscellaneous:AddRightGroupbox('Gui');
    Groups.Gui:AddLabel('<font color="#0084ff">Nutrex</font> - Script')
    Groups.Gui:AddLabel('<font color="#00ff66">Wally</font> - Contribution')
    Groups.Gui:AddDivider()
    Groups.Gui:AddButton('Unload script', function() pcall(_unload) end)
task.spawn(function()
    local dwPickedAnimation = dwAnimations[math.random(1, #dwAnimations)];
    local Delay;
    local dwSelected = ' ';

    if dwPickedAnimation == dwAnimations[3] or dwPickedAnimation == dwAnimations[1] then
        Delay = .2;
    else
        Delay = .1;
    end;

    task.spawn(function()
        while wait() do
            Window:SetWindowTitle('<font color="#'..Color3.fromHSV(tick()%5/5, 1, 1):ToHex()..'">'..dwSelected..'</font>');
        end;
    end);
    while task.wait() do
        for dwIndex, dwField in next, dwPickedAnimation do
            dwSelected = dwField;
            task.wait(Delay);
        end;
    end;
end);

if type(readfile) == 'function' and type(writefile) == 'function' and type(makefolder) == 'function' and type(isfolder) == 'function' then
    Tabs.Settings = Window:AddTab('Settings');
    Groups.Configs = Tabs.Settings:AddLeftGroupbox('Configs');

    makefolder(tostring(game.PlaceId))
    makefolder(tostring(game.PlaceId)..'\\configs')

    Groups.Configs:AddDropdown('ConfigList', { Text = 'Config list', Values = {} })
    Groups.Configs:AddInput('ConfigName',    { Text = 'Config name' })

    Groups.Configs:AddDivider()

    Groups.Configs:AddButton('Save config', function()
        local name = Options.ConfigName.Value;
        if name:gsub(' ', '') == '' then
            return getUI_Library:Notify('Invalid config name.', 3)
        end

        local success, err = SaveManager:Save(name)
        if not success then
            return getUI_Library:Notify(tostring(err), 5)
        end

        getUI_Library:Notify(string.format('Saved config %q', name), 5)
        task.defer(SaveManager.Refresh)
    end)

    Groups.Configs:AddButton('Load config', function()
        local name = Options.ConfigList.Value
        local success, err = SaveManager:Load(name)
        if not success then
            return getUI_Library:Notify(tostring(err), 5)
        end

        getUI_Library:Notify(string.format('Loaded config %q', name), 5)
    end)

    Groups.Configs:AddButton('Refresh list', SaveManager.Refresh)

    task.defer(SaveManager.Refresh)
    task.defer(SaveManager.Check)
else
    getUI_Library:Notify('Failed to create configs tab due to your exploit missing certain file functions.', 2)
end;

-- [[ Toggles | Options ]]

getUI_Library.KeybindFrame.Visible = true;

Toggles.KillAll:OnChanged(function()
    if Toggles.KillAll.Value then
        dwRunService:BindToRenderStep('KillAll', Enum.RenderPriority.Camera.Value, KillAll);
    else
        dwRunService:UnbindFromRenderStep('KillAll');
    end;
end);

Toggles.RainbowBullets:OnChanged(function()
    if Toggles.RainbowBullets.Value then
        dwRunService:BindToRenderStep('RainbowBullets', Enum.RenderPriority.Camera.Value, RainbowBullets);
    else
        dwRunService:UnbindFromRenderStep('RainbowBullets');
    end;
end);

-- Hooks

getUI_Library:Notify(string.format('Loaded script in %.4f second(s)!', tick() - LoadTime), 5);

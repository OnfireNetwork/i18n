translations = {}
local files = {}
local language = "en"
local packages = nil

local function readFile(name)
    local fh = io.open(name, "r")
    if fh == nil then
        return nil
    end
    fh:close()
    local content = ""
    for line in io.lines(name) do
        content = content..line
    end
    return content
end
local function loadConfig()
    local fileContent = readFile("server_config.json")
    if fileContent ~= nil then
        local serverConfig = json_decode(fileContent)
        packages = serverConfig.packages
    else
        print("[i18n] server_config.json not found, falling back on i18n.json")
    end
    fileContent = readFile("i18n.json")
    if fileContent == nil then
        if packages == nil then
            print("[i18n] server_config.json and i18n.json not found, no translations are loaded")
        end
        return
    end
    local config = json_decode(fileContent)
    if config.language ~= nil then
        language = config.language
        if packages == nil then
            packages = config.packages
        end
    end
    if packages == nil then
        print("[i18n] server_config.json not found and i18n.json has no packages property, no translations are loaded")
        packages = {}    
    end
end

loadConfig()
for i=1,#packages do
    local fileContent = readFile("packages/"..packages[i].."/i18n/"..language..".json")
    if fileContent == nil then
        if language ~= "en" then
            fileContent = readFile("packages/"..packages[i].."/i18n/en.json")
        end
    end
    if fileContent ~= nil then
        files[packages[i]] = fileContent
        translations[packages[i]] = json_decode(fileContent)
    end
end

AddEvent("OnPlayerJoin", function(player)
    for k,v in pairs(files) do
        CallRemoteEvent(player, "i18n_start_file", k, v:len())
        local offset = 1
        while offset < v:len() do
            CallRemoteEvent(player, "i18n_send_file_data", k, v:sub(offset, offset + 999))
            offset = offset + 1000
        end
    end
    CallRemoteEvent(player, "i18n_ready")
    CallEvent("OnTranslationReady", player)
end)

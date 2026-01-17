-- ssod/server.lua (server-sided)

local activeRequests = 0
local stopScheduled = false
local STOP_DELAY_MS = 3000

local function canUse(src)
    return IsPlayerAceAllowed(src, "screenshot.use")
end

local function startScreenshotBasic()
    local state = GetResourceState('screenshot-basic')
    if state ~= 'started' and state ~= 'starting' then
        StartResource('screenshot-basic')
    end
end

local function stopScreenshotBasic()
    if GetResourceState('screenshot-basic') == 'started' then
        StopResource('screenshot-basic')
    end
end

local function scheduleStop()
    if stopScheduled then return end
    stopScheduled = true

    SetTimeout(STOP_DELAY_MS, function()
        stopScheduled = false

        if activeRequests <= 0 then
            activeRequests = 0
            stopScreenshotBasic()
        end
    end)
end

RegisterNetEvent('ssod:requestUpload', function(webhook, field, options)
    local src = source
    if not canUse(src) then return end

    activeRequests = activeRequests + 1
    startScreenshotBasic()

    TriggerClientEvent('ssod:doUpload', src, webhook, field or "files[]", options or { encoding = "jpg" })
end)

RegisterNetEvent('ssod:done', function()
    activeRequests = activeRequests - 1
    if activeRequests <= 0 then
        scheduleStop()
    end
end)

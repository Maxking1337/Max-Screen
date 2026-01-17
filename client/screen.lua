local callbacks = {}
local requestId = 0

RegisterNUICallback('screenshot_created', function(data, cb)
    cb(true)
    
    local id = data.id
    if not id then return end
    
    local callback = callbacks[id]
    if callback then
        callbacks[id] = nil
        callback(data.data)
    end
end)

local function requestScreenshotUpload(url, field, options, cb)
    local id = requestId
    requestId = requestId + 1
    
    if cb then
        callbacks[id] = cb
    end
    
    local req = {
        encoding = (options and options.encoding) or 'jpg',
        headers = (options and options.headers) or {},
        targetURL = url,
        targetField = field,
        resultURL = ('http://%s/screenshot_created'):format(GetCurrentResourceName()),
        correlation = id
    }
    

    if options then
        for k, v in pairs(options) do
            if k ~= 'encoding' and k ~= 'headers' then
                req[k] = v
            end
        end
    end
    
    SendNUIMessage({
        request = req
    })
end

exports('requestScreenshotUpload', requestScreenshotUpload)

AddEventHandler('onResourceStop', function(resName)
    if resName == GetCurrentResourceName() then
        callbacks = {}
    end
end)
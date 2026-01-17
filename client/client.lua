local isProcessing = false

local function waitForResource(resName, timeout)
  local start = GetGameTimer()
  while GetResourceState(resName) ~= 'started' do
    if (GetGameTimer() - start) > timeout then
      return false
    end
    Wait(100)
  end
  return true
end

local function handleUpload(webhook, field, options)
  if isProcessing then return end
  isProcessing = true

  if not waitForResource('Max-Screen', 3000) then
    isProcessing = false
    TriggerServerEvent('ssod:done')
    return
  end
  Wait(200)

  local success, err = pcall(function()
    exports['Max-Screen']:requestScreenshotUpload(
      webhook,
      field or "files[]",
      options or { encoding = "jpg" },
      function()
        isProcessing = false
        TriggerServerEvent('ssod:done')
      end
    )
  end)

  if not success then
    isProcessing = false
    TriggerServerEvent('ssod:done')
  end
end


exports('UploadScreenshot', function(webhook, field, options)
  handleUpload(webhook, field, options)
end)


RegisterNetEvent('max1337:screenupload', function(webhook, field, options)
  handleUpload(webhook, field, options)
end)


-- RegisterCommand("testscreenshot", function()
--   local webhook = "
--   TriggerEvent("max1337:screenupload", webhook, "files[]", { encoding = "jpg" })
-- end, false)


-- RegisterCommand("exportscreenshot", function()
--   local webhook = "
--   exports["Max-Screen"]:UploadScreenshot(webhook, "files[]", { encoding = "jpg" })
-- end, false)

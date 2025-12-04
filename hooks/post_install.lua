-- hooks/post_install.lua
-- Performs additional setup after installation
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#postinstall-hook

function PLUGIN:PostInstall(ctx)
    -- Available context:
    -- ctx.rootPath - Root installation path
    -- ctx.runtimeVersion - Full version string
    -- ctx.sdkInfo[PLUGIN.name] - SDK information

    local sdkInfo = ctx.sdkInfo[PLUGIN.name]
    local path = sdkInfo.path
    -- local version = sdkInfo.version

    -- The file is downloaded directly, move it to bin/ and make executable
    os.execute("mkdir -p " .. path .. "/bin")

    local srcFile = path .. "/" .. PLUGIN.name
    local destFile = path .. "/bin/" .. PLUGIN.name

    -- Move and make executable
    local result = os.execute("mv " .. srcFile .. " " .. destFile .. " && chmod +x " .. destFile)
    if result ~= 0 then
        error("Failed to install " .. PLUGIN.name .. " binary")
    end

    -- Verify installation works
    local testResult = os.execute(destFile .. " version > /dev/null 2>&1")
    if testResult ~= 0 then
        error(PLUGIN.name .. " installation appears to be broken")
    end
end

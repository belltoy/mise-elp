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

    local is_windows = RUNTIME.osType:lower() == "windows"
    local exe = is_windows and PLUGIN.name .. ".exe" or PLUGIN.name

    -- The file is downloaded directly, move it to bin/ and make executable
    local srcFile = path .. "/" .. exe
    local destFile = path .. "/bin/" .. exe

    local mkdir, move, null
    if is_windows then
        -- cmd.exe needs backslashes in paths
        local function win(p)
            return '"' .. p:gsub("/", "\\") .. '"'
        end
        mkdir = "mkdir " .. win(path .. "/bin")
        move = "move /Y " .. win(srcFile) .. " " .. win(destFile)
        null = "NUL"
        destFile = win(destFile)
    else
        mkdir = "mkdir -p " .. path .. "/bin"
        move = "mv " .. srcFile .. " " .. destFile .. " && chmod +x " .. destFile
        null = "/dev/null"
    end

    os.execute(mkdir)
    local result = os.execute(move)
    if result ~= 0 then
        error("Failed to install " .. PLUGIN.name .. " binary")
    end

    -- Verify installation works
    local testResult = os.execute(destFile .. " version > " .. null .. " 2>&1")
    if testResult ~= 0 then
        error(PLUGIN.name .. " installation appears to be broken")
    end
end

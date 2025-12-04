-- hooks/env_keys.lua
-- Configures environment variables for the installed tool
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#envkeys-hook

function PLUGIN:EnvKeys(ctx)
    -- Available context:
    -- ctx.path - Main installation path
    -- ctx.runtimeVersion - Full version string
    -- ctx.sdkInfo[PLUGIN.name] - SDK information

    local mainPath = ctx.path

    -- Basic configuration (minimum required for most tools)
    -- This adds the bin directory to PATH so the tool can be executed
    return {
        {
            key = "PATH",
            value = mainPath .. "/bin",
        },
    }
end

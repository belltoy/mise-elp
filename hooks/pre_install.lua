-- hooks/pre_install.lua
-- Returns download information for a specific version
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#preinstall-hook

-- Helper function for platform detection (uncomment and modify as needed)
local function get_platform(version_info)
    -- RUNTIME object is provided by mise/vfox
    -- RUNTIME.osType: "Windows", "Linux", "Darwin"
    -- RUNTIME.archType: "amd64", "386", "arm64", etc.

    local os_name = RUNTIME.osType:lower()
    local arch = RUNTIME.archType

    -- Map to your tool's platform naming convention
    -- Adjust these mappings based on how your tool names its releases
    local platform_map = {
        ["darwin"] = {
            ["amd64"] = "macos-x86_64-apple-darwin",
            ["arm64"] = "macos-aarch64-apple-darwin",
        },
        ["linux"] = {
            ["amd64"] = "linux-x86_64-unknown-linux-gnu",
            ["arm64"] = "linux-aarch64-unknown-linux-gnu",
        },
        ["windows"] = {
            ["amd64"] = "windows-x86_64-pc-windows-msvc",
        },
    }

    local os_map = platform_map[os_name]
    if os_map then
        return os_map[arch] or error("Architecture " .. arch .. " not supported for OS " .. os_name)
    end

    error("OS " .. os_name .. " not supported")
end

local function fetch_checksum(version_info)
    local os_name = RUNTIME.osType:lower()
    local arch = RUNTIME.archType

    local elp_os_name = nil
    if os_name == "windows" then
        elp_os_name = "windows"
    elseif os_name == "linux" then
        elp_os_name = "linux"
    elseif os_name == "darwin" then
        elp_os_name = "macos"
    end

    local elp_arch = nil
    if arch == "amd64" then
        elp_arch = "x86_64"
    elseif arch == "arm64" then
        elp_arch = "aarch64"
    end

    local sha256 = nil
    if version_info.os[elp_os_name] then
        if version_info.os[elp_os_name][elp_arch] then
            sha256 = version_info.os[elp_os_name][elp_arch].sha256 or nil
        else
            error("Architecture " .. elp_arch .. " not supported for OS " .. elp_os_name)
        end
    else
        error("OS " .. elp_os_name .. " not supported")
    end
    return sha256
end

local download_base_url = "https://github.com/WhatsApp/erlang-language-platform/releases/download/"

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local lists = self:Available({})

    if version == "latest" or version == "" then
        version = lists[1].version
    end
    local version_info = nil
    for _, v in ipairs(lists) do
        if v.version == version then
            version_info = v
            break
        end
    end
    if not version_info then
        error("Version " .. version .. " not found in available versions.")
    end

    local otp_version = version:match("^(otp%-.+)%-%d%d%d%d%-%d%d%-%d%d.*$")
    local release_version = version:match("^otp%-.+%-(%d%d%d%d%-%d%d%-%d%d.*)$")
    if not otp_version or not release_version then
        error("Invalid version format: " .. version .. ". Expected format: otp-XX.Y-YYYY-MM-DD_Z")
    end

    local platform = get_platform(version_info) -- Uncomment the helper function above
    local url = download_base_url .. release_version .. "/elp-" .. platform .. "-" .. otp_version .. ".tar.gz"

    local sha256 = fetch_checksum(version_info)

    return {
        version = version,
        url = url,
        sha256 = sha256,
        note = "Downloading elp " .. version,
    }
end

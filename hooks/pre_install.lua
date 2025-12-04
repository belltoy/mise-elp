-- hooks/pre_install.lua
-- Returns download information for a specific version
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#preinstall-hook

-- Helper function for platform detection (uncomment and modify as needed)
local function get_platform()
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
        }
    }

    local os_map = platform_map[os_name]
    if os_map then
        return os_map[arch] or "linux-x86_64"  -- fallback
    end

    -- Default fallback
    return "linux-x86_64"
end

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local otp_version = ctx.opt_version
    -- ctx.runtimeVersion contains the full version string if needed

    -- Example 1: Simple binary download
    -- local url = "https://github.com/<GITHUB_USER>/<GITHUB_REPO>/releases/download/v" .. version .. "/<TOOL>-linux-amd64"

    -- Example 2: Platform-specific binary
    -- local platform = get_platform() -- Uncomment the helper function above
    -- local url = "https://github.com/<GITHUB_USER>/<GITHUB_REPO>/releases/download/v" .. version .. "/<TOOL>-" .. platform

    -- Example 3: Archive (tar.gz, zip) - mise will extract automatically
    -- local url = "https://github.com/<GITHUB_USER>/<GITHUB_REPO>/releases/download/v" .. version .. "/<TOOL>-" .. version .. "-linux-amd64.tar.gz"

    -- Example 4: Raw file from repository
    -- local url = "https://raw.githubusercontent.com/<GITHUB_USER>/<GITHUB_REPO>/" .. version .. "/bin/<TOOL>"

    -- Replace with your actual download URL pattern
    -- local url = "https://example.com/<TOOL>/releases/download/" .. version .. "/<TOOL>"

    -- https://github.com/WhatsApp/erlang-language-platform/releases/download/2025-11-04/elp-linux-aarch64-unknown-linux-gnu-otp-26.2.tar.gz
    local platform = get_platform() -- Uncomment the helper function above
    -- local otp_version = "otp-26.2"  -- Adjust OTP version as needed
    local url = "https://github.com/WhatsApp/erlang-language-platform/releases/download/" .. version .. "/elp-" .. platform .. "-" .. otp_version .. ".tar.gz"

    -- Optional: Fetch checksum for verification
    -- local sha256 = fetch_checksum(version) -- Implement if checksums are available

    return {
        version = version,
        url = url,
        sha256 = ctx.addition.sha256, -- Optional but recommended for security
        note = "Downloading elp " .. version,
        -- addition = { -- Optional: download additional components
        --     {
        --         name = "component",
        --         url = "https://example.com/component.tar.gz"
        --     }
        -- }
    }
end

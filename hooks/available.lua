-- hooks/available.lua
-- Returns a list of available versions for the tool
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#available-hook

local function check_platform(asset, platform_name, platform_table)
    if asset.name:match(platform_name) then
        if not platform_table[platform_name] then
            platform_table[platform_name] = {}
        end
        local sha256 = nil
        if type(asset["digest"]) == "string" then
            sha256 = asset["digest"] and asset["digest"]:match("sha256:(.+)$") or nil
        end
        platform_table[platform_name] = {
            sha256 = sha256,
        }
    end
    return platform_table
end

local function check_os(asset, os_name, os_table)
    if asset.name:match(os_name) then
        if not os_table[os_name] then
            os_table[os_name] = {}
        end

        if RUNTIME.archType == "amd64" then
            os_table[os_name] = check_platform(asset, "x86_64", os_table[os_name])
        end
        if RUNTIME.archType == "arm64" then
            os_table[os_name] = check_platform(asset, "aarch64", os_table[os_name])
        end
    end
    return os_table
end

function PLUGIN:Available(ctx)
    local http = require("http")
    local json = require("json")

    local repo_url = "https://api.github.com/repos/WhatsApp/erlang-language-platform/releases"

    -- mise automatically handles GitHub authentication - no manual token setup needed
    local resp, err = http.get({
        url = repo_url,
    })

    if err ~= nil then
        error("Failed to fetch versions: " .. err)
    end
    if resp.status_code ~= 200 then
        error("GitHub API returned status " .. resp.status_code .. ": " .. resp.body)
    end

    local releases = json.decode(resp.body)
    local result = {}
    local release_versions = {}

    -- Process tags/releases
    local latest = true
    for _, release_info in ipairs(releases) do
        local version = release_info.name

        if not release_versions[version] then
            release_versions[version] = {
                version = version,
                otp_versions = {},
            }
        end

        for _, asset in ipairs(release_info.assets) do
            local otp_version = asset.name:match("(otp%-.+)%.tar%.gz$")
            if otp_version then
                if not release_versions[version].otp_versions[otp_version] then
                    release_versions[version].otp_versions[otp_version] = {
                        otp_version = otp_version,
                        os = {},
                    }
                end
                -- Check OS and platform
                if RUNTIME.osType:lower() == "darwin" then
                    release_versions[version].otp_versions[otp_version].os =
                        check_os(asset, "macos", release_versions[version].otp_versions[otp_version].os)
                elseif RUNTIME.osType:lower() == "linux" then
                    release_versions[version].otp_versions[otp_version].os =
                        check_os(asset, "linux", release_versions[version].otp_versions[otp_version].os)
                elseif RUNTIME.osType:lower() == "windows" then
                    release_versions[version].otp_versions[otp_version].os =
                        check_os(asset, "windows", release_versions[version].otp_versions[otp_version].os)
                end

                if latest then
                    release_versions[version].note = "latest"
                    latest = false
                end
            end
        end

        table.sort(release_versions[version].otp_versions, function(a, b)
            return a.otp_version > b.otp_version
        end)
    end

    local tmp = {}
    for n, i in pairs(release_versions) do
        for otp_v, otp_i in pairs(i.otp_versions) do
            table.insert(tmp, {
                version = otp_v .. "-" .. n,
                release_date = n,
                otp_version = otp_v,
                os = otp_i.os,
                note = nil,
            })
        end
    end

    table.sort(tmp, function(a, b)
        if a.release_date == b.release_date then
            return a.otp_version > b.otp_version
        else
            return a.release_date > b.release_date
        end
    end)

    for _, v in pairs(tmp) do
        table.insert(result, v)
    end

    return result
end

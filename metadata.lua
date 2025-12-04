-- metadata.lua
-- Plugin metadata and configuration
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#metadata-lua

PLUGIN = { -- luacheck: ignore
    -- Required: Tool name (lowercase, no spaces)
    name = "elp",

    -- Required: Plugin version (not the tool version)
    version = "2025-11-04",

    -- Required: Brief description of the tool
    description = "A mise tool plugin for elp (The Erlang Language Platform)",

    -- Required: Plugin author/maintainer
    author = "belltoy",

    -- Optional: Repository URL for plugin updates
    updateUrl = "https://github.com/belltoy/mise-elp",

    -- Optional: Minimum mise runtime version required
    minRuntimeVersion = "0.2.0",

    -- Optional: Legacy version files this plugin can parse
    -- legacyFilenames = {
    --     ".<TOOL>-version",
    --     ".<TOOL>rc"
    -- }
}

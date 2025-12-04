# mise tool plugin for elp

This is a a mise tool plugin for [elp](https://whatsapp.github.io/erlang-language-platform/).

## Using this Plugin

### Install plugin
```bash
mise plugin install elp https://github.com/belltoy/mise-elp.git
```

### Install elp tool

```bash
## List available versions
mise ls-remote elp

## Install latest version
mise install elp

## Install OTP specific latest version aliases
mise install elp@otp-26
mise install elp@otp-27
mise install elp@otp-28

## Install specific version
mise install elp@otp-28-2025-11-04
```

> [!Tip]
> Since `elp` use date as release version for now, this plugin provides aliases for each supported
> OTP version for conveniently installing the latest `elp` for that OTP version.

Add `elp` to your `.mise.toml` for project-specific usage:

```toml
[tools]
elp = "otp-27"
```

## Development Workflow

### Setting up development environment

1. Install pre-commit hooks (optional but recommended):
```bash
hk install
```

This sets up automatic linting and formatting on git commits.

### Local Testing

1. Link your plugin for development:
```bash
mise plugin link --force <TOOL> .
```

2. Run tests:
```bash
mise run test
```

3. Run linting:
```bash
mise run lint
```

4. Run full CI suite:
```bash
mise run ci
```

### Code Quality

This template uses [hk](https://hk.jdx.dev) for modern linting and pre-commit hooks:

- **Automatic formatting**: `stylua` formats Lua code
- **Static analysis**: `luacheck` catches Lua issues
- **GitHub Actions linting**: `actionlint` validates workflows
- **Pre-commit hooks**: Runs all checks automatically on git commit

Manual commands:
```bash
hk check      # Run all linters (same as mise run lint)
hk fix        # Run linters and auto-fix issues
```

## Files

- `metadata.lua` – Plugin metadata and configuration
- `hooks/available.lua` – Returns available versions from upstream
- `hooks/pre_install.lua` – Returns artifact URL for a given version
- `hooks/post_install.lua` – Post-installation setup (permissions, moving files)
- `hooks/env_keys.lua` – Environment variables to export (PATH, etc.)
- `.github/workflows/ci.yml` – GitHub Actions CI/CD pipeline
- `mise.toml` – Development tools and configuration
- `mise-tasks/` – Task scripts for testing
- `hk.pkl` – Modern linting and pre-commit hook configuration
- `.luacheckrc` – Lua linting configuration
- `stylua.toml` – Lua formatting configuration


## References

Refer to the mise docs for detailed information:

- [Tool plugin development](https://mise.jdx.dev/tool-plugin-development.html) - Complete guide to plugin development
- [Lua modules reference](https://mise.jdx.dev/plugin-lua-modules.html) - Available Lua modules and functions
- [Plugin publishing](https://mise.jdx.dev/plugin-publishing.html) - How to publish your plugin
- [mise-plugins organization](https://github.com/mise-plugins) - Community plugins repository

## Publishing

1. Ensure all tests pass: `mise run ci`
2. Create a GitHub repository for your plugin
3. Push your code
4. (Optional) Request to transfer to [mise-plugins](https://github.com/mise-plugins) organization
5. Add to the [mise registry](https://github.com/jdx/mise/blob/main/registry.toml) via PR

## License

MIT

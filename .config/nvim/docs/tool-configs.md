# Tool Configuration Files

Global config file locations for LSP servers, linters, and formatters.

## LSP Servers

| Server | Config File | Location |
|--------|-------------|----------|
| lua_ls | `.luarc.json` | Project root |
| pyright | `pyrightconfig.json` | Project root |
| gopls | (uses go.mod settings) | Project root |
| ts_ls | `tsconfig.json` | Project root |
| bashls | (no external config) | - |
| jsonls | (no external config) | - |
| yamlls | (no external config) | - |
| marksman | (no external config) | - |

### Pyright Example (`pyrightconfig.json`)

```json
{
  "typeCheckingMode": "basic",
  "reportMissingTypeStubs": false,
  "reportUnknownMemberType": false,
  "reportUnknownArgumentType": false,
  "pythonVersion": "3.11"
}
```

### Lua Language Server Example (`.luarc.json`)

```json
{
  "diagnostics": {
    "disable": ["lowercase-global", "unused-local"]
  },
  "workspace": {
    "checkThirdParty": false
  }
}
```

---

## Linters

| Linter | Config File | Global Location |
|--------|-------------|-----------------|
| pylint | `.pylintrc` or `pyproject.toml` | `~/.pylintrc` |
| ruff | `ruff.toml` or `pyproject.toml` | `~/.config/ruff/ruff.toml` |
| mypy | `mypy.ini` or `pyproject.toml` | `~/.mypy.ini` |
| eslint | `.eslintrc.json` or `eslint.config.js` | `~/.eslintrc.json` |
| shellcheck | (CLI args only) | - |
| markdownlint | `.markdownlint.json` | `~/.markdownlintrc` |
| yamllint | `.yamllint` or `.yamllint.yaml` | `~/.config/yamllint/config` |
| jsonlint | (no config file) | - |
| sqlfluff | `.sqlfluff` | `~/.sqlfluff` |
| hadolint | `.hadolint.yaml` | `~/.config/hadolint.yaml` |

### Pylint Example (`~/.pylintrc`)

```ini
[MESSAGES CONTROL]
disable=C0114,C0115,C0116,W0611,W0612

[FORMAT]
max-line-length=120
```

### Ruff Example (`~/.config/ruff/ruff.toml`)

```toml
line-length = 120
target-version = "py311"

[lint]
ignore = ["E501", "F401"]
select = ["E", "F", "W", "I"]
```

### Markdownlint Example (`~/.markdownlintrc`)

```json
{
  "MD013": false,
  "MD033": false,
  "MD041": false
}
```

Common rules to disable:
- `MD013` - Line length
- `MD033` - Inline HTML
- `MD041` - First line should be a heading

### Yamllint Example (`~/.config/yamllint/config`)

```yaml
extends: default
rules:
  line-length:
    max: 120
  truthy:
    check-keys: false
```

### Hadolint Example (`~/.config/hadolint.yaml`)

```yaml
ignored:
  - DL3008
  - DL3009
trustedRegistries:
  - docker.io
```

---

## Formatters

| Formatter | Config File | Global Location |
|-----------|-------------|-----------------|
| stylua | `stylua.toml` or `.stylua.toml` | `~/.config/stylua/stylua.toml` |
| black | `pyproject.toml` | `~/.config/black` |
| ruff | `ruff.toml` or `pyproject.toml` | `~/.config/ruff/ruff.toml` |
| isort | `pyproject.toml` or `.isort.cfg` | `~/.isort.cfg` |
| prettier | `.prettierrc` | `~/.prettierrc` |
| shfmt | (CLI args only) | - |
| gofumpt | (no config file) | - |
| yamlfmt | `.yamlfmt` | `~/.config/yamlfmt/.yamlfmt` |
| sql-formatter | `.sql-formatter.json` | - |

### Stylua Example (`~/.config/stylua/stylua.toml`)

```toml
indent_type = "Spaces"
indent_width = 2
column_width = 120
quote_style = "AutoPreferDouble"
```

### Black Example (`~/.config/black`)

```toml
[tool.black]
line-length = 120
target-version = ["py311"]
```

### Prettier Example (`~/.prettierrc`)

```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "printWidth": 100
}
```

### Yamlfmt Example (`~/.config/yamlfmt/.yamlfmt`)

```yaml
line_ending: lf
indent: 2
retain_line_breaks: true
```

---

## pyproject.toml (Python Unified Config)

Many Python tools read from `pyproject.toml`:

```toml
[tool.ruff]
line-length = 120
ignore = ["E501"]

[tool.ruff.lint]
select = ["E", "F", "W", "I"]

[tool.black]
line-length = 120

[tool.isort]
profile = "black"
line_length = 120

[tool.mypy]
ignore_missing_imports = true
strict = false

[tool.pylint.messages_control]
disable = ["C0114", "C0115", "C0116"]

[tool.pylint.format]
max-line-length = 120
```

---

## Notes

- Project-level configs override global configs
- Some tools search upward from the file being checked
- Use `pyproject.toml` for Python tools when possible (single source of truth)
- LSP settings in `lsp.lua` can also override external configs
